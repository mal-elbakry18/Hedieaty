import 'package:sqflite/sqflite.dart';
import 'Database_Class.dart';

class User {
  int? id;
  String firstName;
  String lastName;
  String? number;
  String email;
  String password; // Store hashed passwords
  String? image; // File path or base64-encoded string

  // Constructor
  User({
    this.id,
    required this.firstName,
    required this.lastName,
    this.number,
    required this.email,
    required this.password,
    this.image,
  });

  // Convert a User object to a Map (for database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'number': number,
      'email': email,
      'password': password,
      'image': image,
    };
  }

  // Create a User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      number: map['number'],
      email: map['email'],
      password: map['password'],
      image: map['image'],
    );
  }

  // Insert a User into the database
  static Future<int> insert(User user) async {
    Database? db = await Databaseclass().MyDataBase;
    return await db!.insert('users', user.toMap());
  }

  // Fetch all users from the database
  static Future<List<User>> getAll() async {
    Database? db = await Databaseclass().MyDataBase;
    List<Map<String, dynamic>> result = await db!.query('users');
    return result.map((map) => User.fromMap(map)).toList();
  }

  // Update a user in the database
  Future<int> update() async {
    Database? db = await Databaseclass().MyDataBase;
    return await db!.update('users', toMap(), where: 'id = ?', whereArgs: [id]);
  }

  // Delete a user from the database
  static Future<int> delete(int id) async {
    Database? db = await Databaseclass().MyDataBase;
    return await db!.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
