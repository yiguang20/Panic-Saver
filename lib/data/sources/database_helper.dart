import 'package:sqflite/sqflite.dart';
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

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  /// Get database instance
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
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
