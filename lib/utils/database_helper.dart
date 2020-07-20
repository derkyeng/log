import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mini_notebook/models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String table = 'noteTable';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnContent = 'content';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initializeDb();
    return _db;
  }

  _initializeDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'notebook.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $table($columnId INTEGER PRIMARY KEY, $columnTitle TEXT, $columnContent TEXT)');
  }

  Future<int> insert(Note note) async {
    var dbHelper = await db;
    var result = await dbHelper.insert(table, note.toMap());
    return result;
  }

  Future<List> getAllNotes() async {
    var dbHelper = await db;
    var result = await dbHelper
        .query(table, columns: [columnId, columnTitle, columnContent]);
    return result.toList();
  }

  Future<int> getCount() async {
    var dbHelper = await db;
    return Sqflite.firstIntValue(
        await dbHelper.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<Note> getNote(int id) async {
    var dbHelper = await db;
    List<Map> result = await dbHelper.query(table,
        columns: [columnId, columnTitle, columnContent],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (result.length > 0) {
      return new Note.fromMap(result.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    var dbHelper = await db;
    return await dbHelper
        .delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateNote(Note note) async {
    var dbHelper = await db;
    return await dbHelper.update(table, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
  }

  Future close() async {
    var dbHelper = await db;
    return dbHelper.close();
  }
}
