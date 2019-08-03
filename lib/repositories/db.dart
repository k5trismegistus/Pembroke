import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final DATABASE = 'pembroke.db';
final VERSION = 1;

Future onCreate(Database db, int version) async {
  db.execute('''
    CREATE TABLE cards (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      text TEXT NOT NULL,
      language TEXT NOT NULL
    )
  ''');
}

class DbStore {
  static Database _db;

  static Future initialize() {

    return getDatabasesPath()
      .then((databaseDirPath) {
        return join(databaseDirPath, DATABASE);
      })
      .then((databasePath) {
        openDatabase(databasePath, onCreate: onCreate, version: VERSION).then((database) {
          _db = database;
        });
      });
  }

  static get database {
    return _db;
  }
}