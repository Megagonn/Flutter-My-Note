import 'package:notepad2/model/notemodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbModel {
  //creating a sigleton
  DbModel._();
  //assigning the singleton to a static varible
  static final db = DbModel._();

  static Database? _database;
  //getting the database
  Future<Database> get database async {
    return _database ??= await init();
  }

//initializing the database
  Future<Database> init() async {
    return await openDatabase(
      join(await getDatabasesPath(), "note.db"),
      onCreate: (db, version) {
        db.execute(
          '''
            CREATE TABLE Note (id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT, category TEXT, date TEXT)
        ''',
        );
      },
      version: 1,
    );
  }

  //GETTING DATAS FORM THE DB
  getData() async {
    var db = await database;
    var allDatas = await db.query('note');
    if (allDatas.isEmpty) {
      return null;
    }
    return allDatas;
  }

  addData(Note note) async {
    var db = await database;
    await db.insert(
      'note',
      note.toMap(note),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  updateDb(Note note) async {
    var db = await database;
    await db.update(
      "note",
      note.toMap(note),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  delData(int id) async {
    var db = await database;
    await db.delete("note", where: 'id=?', whereArgs: [id] );
  }
}
