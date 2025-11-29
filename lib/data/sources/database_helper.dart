import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

/// Database helper for managing SQLite database
class DatabaseHelper {
  static const String _databaseName = 'panic_relief.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String tableSessionRecords = 'session_records';
  static const String tableCustomCards = 'custom_cards';
  static const String tableAffirmationSets = 'affirmation_sets';

  // Singleton instance
  static DatabaseHelper? _instance;
  static Database? _database;
  static bool _initializationFailed = false;
  static bool _ffiInitialized = false;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  /// Check if database initialization failed
  bool get initializationFailed => _initializationFailed;

  /// Initialize FFI for desktop platforms
  static void _initFfi() {
    if (_ffiInitialized) return;
    
    // Initialize FFI for Windows, Linux, macOS
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      debugPrint('SQLite FFI initialized for desktop platform');
    }
    _ffiInitialized = true;
  }

  /// Get database instance
  Future<Database> get database async {
    if (_initializationFailed) {
      throw Exception('Database initialization previously failed');
    }
    
    try {
      _database ??= await _initDatabase();
      return _database!;
    } catch (e) {
      _initializationFailed = true;
      debugPrint('Database initialization error: $e');
      rethrow;
    }
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    try {
      // Initialize FFI for desktop platforms
      _initFfi();
      
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, _databaseName);

      debugPrint('Initializing database at: $path');

      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      debugPrint('Failed to initialize database: $e');
      rethrow;
    }
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    // Session records table
    await db.execute('''
      CREATE TABLE $tableSessionRecords (
        id TEXT PRIMARY KEY,
        startTime INTEGER NOT NULL,
        endTime INTEGER NOT NULL,
        duration INTEGER NOT NULL,
        stepsCompleted INTEGER NOT NULL,
        completedSteps TEXT NOT NULL,
        metadata TEXT
      )
    ''');


    // Create index for faster date queries
    await db.execute('''
      CREATE INDEX idx_session_start_time ON $tableSessionRecords (startTime)
    ''');

    // Custom cards table
    await db.execute('''
      CREATE TABLE $tableCustomCards (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        mainText TEXT NOT NULL,
        subText TEXT,
        buttonText TEXT NOT NULL,
        type TEXT NOT NULL,
        isEnabled INTEGER NOT NULL DEFAULT 1,
        orderIndex INTEGER NOT NULL,
        customData TEXT
      )
    ''');

    // Affirmation sets table
    await db.execute('''
      CREATE TABLE $tableAffirmationSets (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        affirmations TEXT NOT NULL,
        isDefault INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future migrations here
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE ...');
    // }
  }

  /// Close database
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  /// Delete database (for testing or reset)
  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
