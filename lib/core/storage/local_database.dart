import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../logging/app_logger.dart';

/// Local database for caching API responses
/// 
/// Provides offline-first architecture with automatic cache expiration
/// Supports storing JSON data with TTL (Time To Live)
class LocalDatabase {
  static Database? _database;
  static const String _dbName = 'app_cache.db';
  static const int _dbVersion = 1;

  // Table names
  static const String _cacheTable = 'cache';

  /// Get database instance (singleton pattern)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDatabase() async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, _dbName);

      AppLogger.info('Initializing local database at: $path');

      return await openDatabase(
        path,
        version: _dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize database', e, stackTrace);
      rethrow;
    }
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_cacheTable(
        key TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        expiry INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    AppLogger.info('Database tables created successfully');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    AppLogger.info('Upgrading database from v$oldVersion to v$newVersion');
    // Add migration logic here when needed
  }

  /// Cache data with expiration time
  Future<void> cacheData(String key, dynamic data, Duration ttl) async {
    try {
      final db = await database;
      final expiry = DateTime.now().add(ttl).millisecondsSinceEpoch;
      final createdAt = DateTime.now().millisecondsSinceEpoch;

      final jsonData = json.encode(data);

      await db.insert(
        _cacheTable,
        {
          'key': key,
          'data': jsonData,
          'expiry': expiry,
          'created_at': createdAt,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      AppLogger.debug('Cached data for key: $key with TTL: ${ttl.inMinutes}m');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to cache data for key: $key', e, stackTrace);
    }
  }

  /// Get cached data if not expired
  Future<dynamic> getCachedData(String key) async {
    try {
      final db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;

      final results = await db.query(
        _cacheTable,
        where: 'key = ? AND expiry > ?',
        whereArgs: [key, now],
      );

      if (results.isEmpty) {
        AppLogger.debug('Cache miss for key: $key');
        return null;
      }

      final data = results.first['data'] as String;
      AppLogger.debug('Cache hit for key: $key');
      return json.decode(data);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get cached data for key: $key', e, stackTrace);
      return null;
    }
  }

  /// Check if cache exists and is valid
  Future<bool> isCacheValid(String key) async {
    try {
      final db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;

      final results = await db.query(
        _cacheTable,
        columns: ['key'],
        where: 'key = ? AND expiry > ?',
        whereArgs: [key, now],
      );

      return results.isNotEmpty;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to check cache validity for key: $key', e, stackTrace);
      return false;
    }
  }

  /// Clear specific cache by key
  Future<void> clearCache(String key) async {
    try {
      final db = await database;
      await db.delete(
        _cacheTable,
        where: 'key = ?',
        whereArgs: [key],
      );
      AppLogger.debug('Cleared cache for key: $key');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear cache for key: $key', e, stackTrace);
    }
  }

  /// Clear all expired cache entries
  Future<void> clearExpiredCache() async {
    try {
      final db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;

      final deletedCount = await db.delete(
        _cacheTable,
        where: 'expiry < ?',
        whereArgs: [now],
      );

      AppLogger.info('Cleared $deletedCount expired cache entries');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear expired cache', e, stackTrace);
    }
  }

  /// Clear all cache
  Future<void> clearAllCache() async {
    try {
      final db = await database;
      await db.delete(_cacheTable);
      AppLogger.info('Cleared all cache');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear all cache', e, stackTrace);
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;

      final totalResult = await db.rawQuery('SELECT COUNT(*) as count FROM $_cacheTable');
      final validResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $_cacheTable WHERE expiry > ?',
        [now],
      );

      final total = Sqflite.firstIntValue(totalResult) ?? 0;
      final valid = Sqflite.firstIntValue(validResult) ?? 0;

      return {
        'total': total,
        'valid': valid,
        'expired': total - valid,
      };
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get cache stats', e, stackTrace);
      return {'total': 0, 'valid': 0, 'expired': 0};
    }
  }

  /// Close database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
    AppLogger.info('Database connection closed');
  }
}
