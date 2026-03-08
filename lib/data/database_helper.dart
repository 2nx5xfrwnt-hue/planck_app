import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

/// Singleton helper managing the app's SQLite database.
///
/// Tables:
///   user_progress    – single-row aggregate progress
///   post_interactions – per-post unlock / bookmark state
///   daily_feeds      – cached daily feed JSON blobs
///   module_progress  – per-module completion tracking
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static const String _dbName = 'planck.db';
  static const int _dbVersion = 1;

  Database? _database;

  /// Returns the open database, creating it on first access.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_progress (
        id INTEGER PRIMARY KEY,
        insight_points INTEGER NOT NULL DEFAULT 0,
        current_streak INTEGER NOT NULL DEFAULT 0,
        last_active_date TEXT,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE post_interactions (
        post_id TEXT PRIMARY KEY,
        feed_date TEXT NOT NULL,
        is_unlocked INTEGER NOT NULL DEFAULT 0,
        unlocked_at TEXT,
        is_bookmarked INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE daily_feeds (
        feed_date TEXT PRIMARY KEY,
        feed_json TEXT NOT NULL,
        feed_version INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE module_progress (
        module_id TEXT PRIMARY KEY,
        is_completed INTEGER NOT NULL DEFAULT 0,
        completed_at TEXT,
        cards_viewed_count INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Seed the single user_progress row.
    await db.insert('user_progress', {
      'id': 1,
      'insight_points': 0,
      'current_streak': 0,
      'last_active_date': null,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  // ---------------------------------------------------------------------------
  // User progress
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getUserProgress() async {
    final db = await database;
    final rows = await db.query('user_progress', where: 'id = ?', whereArgs: [1]);
    if (rows.isEmpty) {
      // Shouldn't happen after onCreate, but handle defensively.
      final now = DateTime.now().toIso8601String();
      await db.insert('user_progress', {
        'id': 1,
        'insight_points': 0,
        'current_streak': 0,
        'last_active_date': null,
        'updated_at': now,
      });
      return {
        'insight_points': 0,
        'current_streak': 0,
        'last_active_date': null,
        'updated_at': now,
      };
    }
    return rows.first;
  }

  Future<void> updateInsightPoints(int points) async {
    final db = await database;
    await db.update(
      'user_progress',
      {
        'insight_points': points,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<void> updateStreak(int streak, String lastActiveDate) async {
    final db = await database;
    await db.update(
      'user_progress',
      {
        'current_streak': streak,
        'last_active_date': lastActiveDate,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  // ---------------------------------------------------------------------------
  // Post interactions
  // ---------------------------------------------------------------------------

  Future<void> markPostUnlocked(String postId, String feedDate) async {
    final db = await database;
    await db.insert(
      'post_interactions',
      {
        'post_id': postId,
        'feed_date': feedDate,
        'is_unlocked': 1,
        'unlocked_at': DateTime.now().toIso8601String(),
        'is_bookmarked': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> isPostUnlocked(String postId) async {
    final db = await database;
    final rows = await db.query(
      'post_interactions',
      columns: ['is_unlocked'],
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    if (rows.isEmpty) return false;
    return rows.first['is_unlocked'] == 1;
  }

  Future<Set<String>> getUnlockedPostIds(String feedDate) async {
    final db = await database;
    final rows = await db.query(
      'post_interactions',
      columns: ['post_id'],
      where: 'feed_date = ? AND is_unlocked = 1',
      whereArgs: [feedDate],
    );
    return rows.map((r) => r['post_id'] as String).toSet();
  }

  Future<void> toggleBookmark(String postId, bool bookmarked) async {
    final db = await database;
    await db.update(
      'post_interactions',
      {'is_bookmarked': bookmarked ? 1 : 0},
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  // ---------------------------------------------------------------------------
  // Daily feeds
  // ---------------------------------------------------------------------------

  Future<String?> getCachedFeed(String feedDate, int feedVersion) async {
    final db = await database;
    final rows = await db.query(
      'daily_feeds',
      where: 'feed_date = ? AND feed_version = ?',
      whereArgs: [feedDate, feedVersion],
    );
    if (rows.isEmpty) return null;
    return rows.first['feed_json'] as String;
  }

  Future<void> cacheFeed(String feedDate, String feedJson, int feedVersion) async {
    final db = await database;
    await db.insert(
      'daily_feeds',
      {
        'feed_date': feedDate,
        'feed_json': feedJson,
        'feed_version': feedVersion,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ---------------------------------------------------------------------------
  // Module progress
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>?> getModuleProgress(String moduleId) async {
    final db = await database;
    final rows = await db.query(
      'module_progress',
      where: 'module_id = ?',
      whereArgs: [moduleId],
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<void> markModuleCompleted(String moduleId) async {
    final db = await database;
    await db.insert(
      'module_progress',
      {
        'module_id': moduleId,
        'is_completed': 1,
        'completed_at': DateTime.now().toIso8601String(),
        'cards_viewed_count': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCardsViewedCount(String moduleId, int count) async {
    final db = await database;
    // Upsert: insert if absent, update if present.
    final existing = await getModuleProgress(moduleId);
    if (existing == null) {
      await db.insert('module_progress', {
        'module_id': moduleId,
        'is_completed': 0,
        'completed_at': null,
        'cards_viewed_count': count,
      });
    } else {
      await db.update(
        'module_progress',
        {'cards_viewed_count': count},
        where: 'module_id = ?',
        whereArgs: [moduleId],
      );
    }
  }

  Future<List<Map<String, dynamic>>> getAllModuleProgress() async {
    final db = await database;
    return db.query('module_progress');
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
