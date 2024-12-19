import 'package:flutter/material.dart';
import 'Database_Class.dart'; // Replace with the actual path to your Databaseclass file.

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized for async operations.
  Databaseclass db = Databaseclass();

  // Test your database
  await testDatabase(db);

  runApp(const MyApp());
}

Future<void> testDatabase(Databaseclass db) async {
  // Delete database to start fresh (optional for testing)
  await db.deleteMyDatabase();

  // Test Insert Data
  String insertUserSQL = '''
    INSERT INTO users (first_name, last_name, number, email, password, image)
    VALUES ('Malak', 'Doe', '123456789', 'johndoe@example.com', 'hashed_password', 'path/to/image.jpg')
  ''';
  int insertUserResponse = await db.insertData(insertUserSQL);
  print('Insert User Response: $insertUserResponse');

  // Test Insert Data
  String insertUserSQL_2 = '''
    INSERT INTO users (first_name, last_name, number, email, password, image)
    VALUES ('Malak', 'Elbakry', '12345678', 'malak@example.com', 'hashed_password', 'path/to/image.jpg')
  ''';
  int insertUserResponse_2 = await db.insertData(insertUserSQL_2);
  print('Insert User Response: $insertUserResponse_2');

  // Test Read Data
  String readUserSQL = 'SELECT * FROM users';
  var readUserResponse = await db.readData(readUserSQL);
  print('Read User Response: $readUserResponse');

  // Test Update Data
  String updateUserSQL = '''
    UPDATE users SET first_name = 'Jane' WHERE id = 1
  ''';
  int updateUserResponse = await db.updateData(updateUserSQL);
  print('Update User Response: $updateUserResponse');
  // Test Update Data
  String updateUserSQL_2 = '''
    UPDATE users SET first_name = 'amr' WHERE id = 2
  ''';
  int updateUserResponse_2 = await db.updateData(updateUserSQL_2);
  print('Update User Response: $updateUserResponse_2');

  // Verify Update
  readUserResponse = await db.readData(readUserSQL);
  print('Read After Update: $readUserResponse');

  // Test Delete Data
  String deleteUserSQL = 'DELETE FROM users WHERE id = 1';
  int deleteUserResponse = await db.deleteData(deleteUserSQL);
  print('Delete User Response: $deleteUserResponse');

  // Verify Delete
  readUserResponse = await db.readData(readUserSQL);
  print('Read After Delete: $readUserResponse');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Database Test'),
        ),
        body: const Center(
          child: Text('Check your console for database operations.'),
        ),
      ),
    );
  }
}
