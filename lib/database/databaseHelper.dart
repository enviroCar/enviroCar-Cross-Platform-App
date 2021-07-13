import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import './carsTable.dart';
import 'tracksTable.dart';

class DatabaseHelper {
  static Database _database;

  // name and version of the database, to be changed later
  static const _dbName = 'testDB1.db';
  static const _dbVersion = 1;

  // private construction to create a singleton of the database instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // fetching the database
  Future<Database> get getDatabase async {
    // return database if it is already open
    if (_database != null) {
      return _database;
    } else {
      return _database = await initDatabase();
    }
  }

  // openining the database
  Future<Database> initDatabase() async {
    final String dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, _dbName),
      version: _dbVersion,
      onCreate: createDatabase,
    );
  }

  // creating the database and the tables if it is the first time
  Future<void> createDatabase(Database db, int version) async {
    await db.execute(CarsTable.carsTableQuery);
    await db.execute(TracksTable.localTrackCreateTableQuery);
  }

  // method to insert values in the database
  // return the primary key of the inserted value
  Future<int> insertValue(
      {@required String tableName, @required Map<String, dynamic> data}) async {
    final Database db = await instance.getDatabase;
    final int primaryKey = await db.insert(
      tableName,
      data,
    );

    return primaryKey;
  }

  // reads all values in the table
  Future<List<Map<String, dynamic>>> readAllValues(
      {@required String tableName}) async {
    final Database db = await instance.getDatabase;

    return db.query(tableName);
  }

  // update a value in the table
  Future<int> updateValue({@required String tableName, @required int columnId, @required Map<String, dynamic> updatedData}) async {
    final Database db = await instance.getDatabase;
    return db.update(tableName, updatedData, where: '$tableName = ?', whereArgs: [columnId]);
  }

  Future<List<Map<String, dynamic>>> readValue({@required String tableName, @required String id}) async {
    final Database db = await instance.getDatabase;
    return db.query(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // deletes the value
  Future<void> deleteValue(
      {@required String tableName, @required Map<String, dynamic> data}) async {
    final Database db = await instance.getDatabase;
    db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }
}
