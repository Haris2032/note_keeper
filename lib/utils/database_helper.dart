import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:note_keeper/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // singleton databasehelper
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescr = 'descr';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //Get the path direction for both Android and ios for store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colDescr TEXT,$colPriority TEXT,$colDate TEXT)');
  }

  Future<List<Map<String,dynamic>>>getNotemapLoist() async {
    Database db = await this.database;

    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  Future<int>insertnote(note note) async {
    Database db = await this.database;

    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  Future<int>updatenote(note note) async {
    Database db = await this.database;

    var result = await db.update(noteTable, note.toMap(),where: '$colId =?',whereArgs: [note.id]);
    return result;
  }
  Future<int> deletenote(int id) async {
    Database db = await this.database;

    var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  Future<int>getCount() async {
    Database db = await this.database;
    List<Map<String,dynamic>> x= await db.rawQuery('SELECT COUNT(*) FROM $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<note>> getNotelist() async{
    var noteMapList = await getNotemapLoist();
    int count = noteMapList.length;

    List<note> noteList = List<note>();
    for(int i=0;i<count;i++){
      noteList.add(note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
