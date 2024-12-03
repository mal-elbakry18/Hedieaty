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
}
