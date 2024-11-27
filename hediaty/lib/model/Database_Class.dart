import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Databaseclass {
  static Database? _MyDataBase;

  Future<Database?> get MyDataBase async {
    if (_MyDataBase == null) {
      _MyDataBase = await initialize();
      return _MyDataBase;
    } else {
      return _MyDataBase;
    }
  }

  int Version = 1;

  initialize() async {
    String mypath = await getDatabasesPath();
    String path = join(mypath, 'myDataBasess.db');
    Database mydb = await openDatabase(path, version: Version,
        onCreate: (db, Version) async {
          var batch = db.batch();

          // 1. User Table
          batch.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            first_name TEXT NOT NULL,
            last_name TEXT NOT NULL,
            number TEXT,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL, -- store hashed passwords
            image TEXT -- store file path or base64-encoded string
          )
        ''');

          // 2. Friends List Table
          batch.execute('''
          CREATE TABLE friends_list (
            user_id INTEGER NOT NULL,
            friend_id INTEGER NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users (id),
            FOREIGN KEY (friend_id) REFERENCES users (id)
          )
        ''');

          // 3. List/Event Table
          batch.execute('''
          CREATE TABLE lists_events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            list_details_id INTEGER,
            user_id INTEGER NOT NULL,
            status TEXT NOT NULL DEFAULT 'open', -- Status for the entire list
            FOREIGN KEY (user_id) REFERENCES users (id)
          )
        ''');

          // 4. Gift Table
          batch.execute('''
          CREATE TABLE gifts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT,
            category TEXT,
            price REAL,
            image TEXT -- store file path or base64-encoded string
          )
        ''');

          // 5. List-Details/Event-Details Table
          batch.execute('''
          CREATE TABLE list_event_details (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            list_id INTEGER NOT NULL,
            gift_id INTEGER NOT NULL,
            status TEXT NOT NULL DEFAULT 'available', -- e.g., 'available', 'pledged'
            pledged_by INTEGER, -- User who pledged the gift
            FOREIGN KEY (list_id) REFERENCES lists_events (id),
            FOREIGN KEY (gift_id) REFERENCES gifts (id),
            FOREIGN KEY (pledged_by) REFERENCES users (id)
          )
        ''');

          await batch.commit();
          print("Database has been created .......");
        });
    return mydb;
  }

  readData(String SQL) async {
    Database? mydatabase = await MyDataBase;
    print("Retrieving Database...");
    var response = await mydatabase!.rawQuery(SQL);
    return response;
  }

  insertData(String SQL) async {
    Database? mydatabase = await MyDataBase;
    print("Inserting Into Database...");
    int response = await mydatabase!.rawInsert(SQL);
    return response;
  }

  deleteData(String SQL) async {
    Database? mydatabase = await MyDataBase;
    print("Deleting from Database...");
    int response = await mydatabase!.rawDelete(SQL);
    return response;
  }

  updateData(String SQL) async {
    Database? mydatabase = await MyDataBase;
    print("Updating Database...");
    int response = await mydatabase!.rawUpdate(SQL);
    return response;
  }

  deleteMyDatabase() async {
    String database = await getDatabasesPath();
    String Path = join(database, 'myDataBasess.db');
    bool ifitexist = await databaseExists(Path);
    if (ifitexist == true) {
      print('it exist');
    } else {
      print("it doesn't exist");
    }
    await deleteDatabase(Path);
    print("MyData has been deleted");
  }
}
