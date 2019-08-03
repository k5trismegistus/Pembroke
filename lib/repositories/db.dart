import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final DATABASE = 'pembroke.db';
final VERSION = 1;

Future onCreate(Database db, int version) async {
  db.execute('''
    CREATE_TABLE cards (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      text TEXT NOT NULL,
      language TEXT NOT NULL
    )
  ''');
}

class Db {
  static Db _db; // singleton instance
  Database _database;
  bool isReady = false;

  factory Db() {
    if (_db == null) {
      var _db = new Db();

      getDatabasesPath()
        .then((databaseDirPath) {
          return join(databaseDirPath, DATABASE);
        })
        .then((databasePath) {
          openDatabase(databasePath, onCreate: onCreate, version: VERSION).then((database) {
            _db._database = database;
            _db.isReady = true;
          });
        });

      return _db;
    } else {
      return _db;
    }
  }

  get database => _database;

  Db._internal();
}