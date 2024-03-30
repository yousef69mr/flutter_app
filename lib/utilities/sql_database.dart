import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

class SqlDatabase {
  static Database? _db;

  Future<Database?> get db async {
    //init db if null only
    _db ??= await initial();

    return _db;
  }

  initial() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'local_db.db');

    // to alter database table just change the version number
    // and make the modification in onUpgrade
    Database db = await openDatabase(path,
        onCreate: _onCreate, version: 6, onUpgrade: _onUpgrade);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE "users" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "name" TEXT NOT NULL,
      "email" TEXT NOT NULL,
      "level" INTEGER NOT NULL,
      "gender" TEXT NULL,
      "password" TEXT NOT NULL,
      "studentId" TEXT NOT NULL
    )''');

    print("onCreate ====================");
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE users');

    await db.execute('''
    CREATE TABLE "users" (
      "id" TEXT NOT NULL PRIMARY KEY,
      "name" TEXT NOT NULL,
      "email" TEXT NOT NULL,
      "avatar" TEXT NULL,
      "level" INTEGER NOT NULL,
      "gender" TEXT NULL,
      "password" TEXT NOT NULL,
      "role" TEXT NOT NULL,
      "studentId" TEXT NOT NULL
    )''');

    // await db.execute('ALTER TABLE "users" ADD COLUMN "avatar" TEXT NULL');

    print("onUpgrade ====================");
  }

  Future<List<Map<String, dynamic>>> readData(String sql) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.rawQuery(sql);
    return response;
  }

  Future<int> insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  Future<int> updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  Future<int> deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }
}
