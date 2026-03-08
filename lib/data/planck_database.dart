import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'quantum_post.dart';

class PlanckDatabase {
  static final PlanckDatabase instance = PlanckDatabase._init();
  static Database? _database;

  PlanckDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('planck.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Facts Table (Content Pool)
    await db.execute('''
      CREATE TABLE facts (
        id TEXT PRIMARY KEY,
        teaser TEXT NOT NULL,
        body TEXT NOT NULL,
        category TEXT,
        difficulty INTEGER DEFAULT 1,
        batch INTEGER NOT NULL,
        created_at TEXT
      )
    ''');

    // 2. Fact Progress (User Interaction)
    await db.execute('''
      CREATE TABLE fact_progress (
        fact_id TEXT PRIMARY KEY,
        seen_count INTEGER DEFAULT 0,
        task_completed INTEGER DEFAULT 0,
        ip_earned INTEGER DEFAULT 0,
        first_seen_at TEXT,
        last_seen_at TEXT,
        FOREIGN KEY (fact_id) REFERENCES facts (id)
      )
    ''');

    // 3. Feed Entries (Daily History)
    await db.execute('''
      CREATE TABLE feed_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        position INTEGER NOT NULL,
        fact_id TEXT NOT NULL,
        task_type INTEGER NOT NULL,
        FOREIGN KEY (fact_id) REFERENCES facts (id)
      )
    ''');

    // 4. App Meta (Key-Value Store)
    await db.execute('''
      CREATE TABLE app_meta (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
    
    // Initialize default Insight Points
    await db.insert('app_meta', {'key': 'insight_points', 'value': '0'});
  }
  
  // --- Helper Methods ---

  Future<void> upsertFact(Map<String, dynamic> factData) async {
    final db = await database;
    await db.insert(
      'facts',
      {
        'id': factData['id'],
        'teaser': factData['teaser'],
        'body': factData['body'],
        'category': factData['category'],
        'difficulty': factData['difficulty'],
        'batch': factData['batch'],
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getInsightPoints() async {
    final db = await database;
    final result = await db.query(
      'app_meta',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: ['insight_points'],
    );
    
    if (result.isNotEmpty) {
      return int.parse(result.first['value'] as String);
    }
    return 0;
  }

  Future<void> addInsightPoints(int points) async {
    final db = await database;
    await db.transaction((txn) async {
      final result = await txn.query(
        'app_meta',
        columns: ['value'],
        where: 'key = ?',
        whereArgs: ['insight_points'],
      );
      
      int currentPoints = 0;
      if (result.isNotEmpty) {
        currentPoints = int.parse(result.first['value'] as String);
      }
      
      final newPoints = currentPoints + points;
      
      await txn.insert(
        'app_meta',
        {'key': 'insight_points', 'value': newPoints.toString()},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<String?> getMeta(String key) async {
    final db = await database;
    final result = await db.query(
      'app_meta',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [key],
    );
    
    if (result.isNotEmpty) {
      return result.first['value'] as String;
    }
    return null;
  }

  Future<void> setMeta(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_meta',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Closes the database connection
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
