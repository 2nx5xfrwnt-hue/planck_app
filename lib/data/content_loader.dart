import 'dart:convert';
import 'package:flutter/services.dart';
import 'planck_database.dart';

class ContentLoader {
  static const String _contentAssetPath = 'assets/content.json';
  static const String _metaKeyContentVersion = 'content_version';

  /// Syncs the bundled content.json into SQLite.
  /// Only performs a full upsert if the bundled version is newer than
  /// what was previously loaded, making it safe to call on every launch.
  static Future<void> syncIfNeeded() async {
    final jsonString = await rootBundle.loadString(_contentAssetPath);
    final Map<String, dynamic> json = jsonDecode(jsonString);

    final int bundledVersion = json['version'] as int;
    final db = PlanckDatabase.instance;

    final String? storedVersionStr = await db.getMeta(_metaKeyContentVersion);
    final int storedVersion = storedVersionStr != null
        ? int.tryParse(storedVersionStr) ?? 0
        : 0;

    if (bundledVersion <= storedVersion) {
      // Already up to date; nothing to do.
      return;
    }

    final List<dynamic> facts = json['facts'] as List<dynamic>;
    for (final factEntry in facts) {
      await db.upsertFact(factEntry as Map<String, dynamic>);
    }

    await db.setMeta(_metaKeyContentVersion, bundledVersion.toString());
  }
}
