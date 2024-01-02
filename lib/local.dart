import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'constants.dart';





class MyLocalStorage{

  Database? _database;

  MyLocalStorage._singleton();
  static final MyLocalStorage instance = MyLocalStorage._singleton();



  ///This method checks for whether the Database is null.
  ///It returns the database if it is not-null but initializes(opens it) it if null.
  Future<Database> get getDatabase async {
    if(_database != null){
      return _database!;
    } else{
      return _database = await initDatabase();
    }

  }

  ///Opens the database.
  ///This method first gets the database path, joins it with a name then calls the openDatabase() method from sqlite
  ///to open a database or create one.
  static initDatabase() async {
    final path = await getDatabasesPath();
    String databasePath = join(path, databaseName);
    return await openDatabase(databasePath,
        version: databaseVersion,
        onCreate:(Database db, int version) async {
          version = databaseVersion;
          await db.execute(createContactTable);
        });
  }
}