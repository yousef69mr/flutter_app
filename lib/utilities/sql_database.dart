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
        onCreate: _onCreate, version: 14, onUpgrade: _onUpgrade);
    return db;
  }

  _onCreate(Database db, int version) async {
    // await db.execute('''
    // CREATE TABLE "users" (
    //   "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    //   "name" TEXT NOT NULL,
    //   "email" TEXT NOT NULL,
    //   "level" INTEGER NOT NULL,
    //   "gender" TEXT NULL,
    //   "avatar" TEXT NULL,
    //   "password" TEXT NOT NULL,
    //   "studentId" TEXT NOT NULL
    // )''');

    // print("onCreate ====================");
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('''
    CREATE TABLE "stores" (
      "id" TEXT NOT NULL PRIMARY KEY,
      "name" TEXT NOT NULL,
      "latitude" REAL NOT NULL,
      "longitude" REAL NOT NULL,
      "createdAt" TEXT NULL
    )''');

    await db.execute('''
    CREATE TABLE "favorite_stores" (
      "id" TEXT NOT NULL PRIMARY KEY,
      "storeId" TEXT NOT NULL,
      "userId" TEXT NOT NULL,
      "createdAt" TEXT NULL,
      FOREIGN KEY (storeId) REFERENCES "stores" (id) ON DELETE CASCADE ON UPDATE NO ACTION,
      FOREIGN KEY (userId) REFERENCES "users" (id) ON DELETE CASCADE ON UPDATE NO ACTION


    )''');

    // await db.execute('ALTER TABLE "favorite_stores" ADD COLUMN "createdAt" TEXT NULL');

    // await db.execute('DELETE FROM stores');

    // await db.execute('DROP TABLE favorite_stores');
    // await db.execute('DROP TABLE stores');
    // await db.execute('''
    // CREATE TABLE "users" (
    //   "id" TEXT NOT NULL PRIMARY KEY,
    //   "name" TEXT NOT NULL,
    //   "email" TEXT NOT NULL,
    //   "avatar" TEXT NULL,
    //   "level" INTEGER NOT NULL,
    //   "gender" TEXT NULL,
    //   "password" TEXT NOT NULL,
    //   "role" TEXT NOT NULL,
    //   "studentId" TEXT NOT NULL
    // )''');

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

  Future<void> executeTransaction(
      void Function(Transaction txn) transactionHandler) async {
    Database? mydb = await db;
    try {
      await mydb!.transaction((txn) async {
        transactionHandler(txn);
      });
    } catch (e) {
      // Handle transaction errors
      print('Transaction failed: $e');
      // Optionally, rethrow the error or handle it gracefully
      // rethrow;
    }
  }
}
