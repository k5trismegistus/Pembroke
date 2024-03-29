import 'package:pembroke/models/card.dart' as models;
import 'package:pembroke/repositories/db.dart';
import 'package:sqflite/sqflite.dart';

class CardRepository {

  Future<void> insertCard(models.Card card) async {
    final Database _db = DbStore.database;
    var result = await _db.insert(
      'cards',
      card.toMap(),
    );
  }

  Future<List<models.Card>> listCard({int limit = 10, int offset = 0}) async {
    final Database _db = DbStore.database;

    var result = (await _db.query(
      'cards',
      columns: ['id', 'text', 'language'],
      limit: limit,
      offset: offset,
    )).toList();
    return result.map((r) => models.Card.fromMap(r)).toList();
  }

  Future<models.Card> getCardById(int id) async {
    final Database _db = DbStore.database;

    var result = (await _db.query(
      'cards',
      columns: ['id', 'text', 'language'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    )).toList();

    if (result.length == 0) {
      return null;
    }

    return models.Card.fromMap(result[0]);
  }

  Future<void> removeCardById(int id) async {
    final Database _db = DbStore.database;

    await _db.delete(
      'cards',
      where: 'id = ?',
      whereArgs: [id]
    );

    return;
  }

  Future<List<int>> listIds() async {
    final Database _db = DbStore.database;

    var result = (await _db.query(
      'cards',
      columns: ['id'],
    )).toList();

    return result.map((_result) {
      return _result['id'] as int;
    }).toList();
  }

  Future<models.Card> previousCard({int id}) async {
    final Database _db = DbStore.database;

    var result = (await _db.query(
      'cards',
      columns: ['id', 'text', 'language'],
      where: 'id < ?',
      whereArgs: [id],
      limit: 1,
    )).toList();

    if (result.length == 0) {
      return null;
    }

    return models.Card.fromMap(result[0]);
  }

  Future<models.Card> nextCard({int id}) async {
    final Database _db = DbStore.database;

    var result = (await _db.query(
      'cards',
      columns: ['id', 'text', 'language'],
      where: 'id > ?',
      whereArgs: [id],
      limit: 1,
    )).toList();

    if (result.length == 0) {
      return null;
    }

    return models.Card.fromMap(result[0]);
  }
}