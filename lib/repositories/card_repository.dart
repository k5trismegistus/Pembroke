import 'package:pembroke/models/card.dart';
import 'package:pembroke/repositories/db.dart';

class CardRepository {
  Future<void> insertCard(Card card) async {
    // Get a reference to the database.
    final Db _db = new Db();

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await _db.database.insert(
      'cards',
      card.toMap(),
    );
  }
}