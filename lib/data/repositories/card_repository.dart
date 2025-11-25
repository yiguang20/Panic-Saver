import 'package:sqflite/sqflite.dart';
import '../models/crisis_card.dart';
import '../sources/database_helper.dart';

/// Repository for managing custom crisis cards
class CardRepository {
  final DatabaseHelper _dbHelper;

  CardRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper();

  /// Save or update a card
  Future<void> saveCard(CrisisCard card) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableCustomCards,
      card.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all custom cards
  Future<List<CrisisCard>> getAllCards() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableCustomCards,
      orderBy: 'orderIndex ASC',
    );
    return maps.map((map) => CrisisCard.fromJson(map)).toList();
  }

  /// Get enabled cards only
  Future<List<CrisisCard>> getEnabledCards() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableCustomCards,
      where: 'isEnabled = ?',
      whereArgs: [1],
      orderBy: 'orderIndex ASC',
    );
    return maps.map((map) => CrisisCard.fromJson(map)).toList();
  }

  /// Get a single card by ID
  Future<CrisisCard?> getCardById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableCustomCards,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return CrisisCard.fromJson(maps.first);
  }


  /// Update card enabled status
  Future<void> setCardEnabled(String id, bool enabled) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableCustomCards,
      {'isEnabled': enabled ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Update card order
  Future<void> updateCardOrder(String id, int newOrder) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableCustomCards,
      {'orderIndex': newOrder},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Reorder cards (swap positions)
  Future<void> reorderCards(List<CrisisCard> cards) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      for (int i = 0; i < cards.length; i++) {
        await txn.update(
          DatabaseHelper.tableCustomCards,
          {'orderIndex': i},
          where: 'id = ?',
          whereArgs: [cards[i].id],
        );
      }
    });
  }

  /// Delete a card
  Future<void> deleteCard(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableCustomCards,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all custom cards
  Future<void> deleteAllCards() async {
    final db = await _dbHelper.database;
    await db.delete(DatabaseHelper.tableCustomCards);
  }

  /// Initialize with default cards if empty
  Future<void> initializeDefaultCards(List<CrisisCard> defaultCards) async {
    final existing = await getAllCards();
    if (existing.isEmpty) {
      for (final card in defaultCards) {
        await saveCard(card);
      }
    }
  }

  /// Reset to default cards
  Future<void> resetToDefaults(List<CrisisCard> defaultCards) async {
    await deleteAllCards();
    for (final card in defaultCards) {
      await saveCard(card);
    }
  }

  /// Export cards as JSON-compatible list
  Future<List<Map<String, dynamic>>> exportCards() async {
    final cards = await getAllCards();
    return cards.map((c) => c.toJson()).toList();
  }

  /// Import cards from JSON-compatible list
  Future<int> importCards(List<Map<String, dynamic>> data) async {
    int imported = 0;
    for (final json in data) {
      try {
        final card = CrisisCard.fromJson(json);
        await saveCard(card);
        imported++;
      } catch (e) {
        continue;
      }
    }
    return imported;
  }
}


