/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Email Sign Up
  Future<User?> signUpWithEmail(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential.user;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  // Email Login
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // Add Google user to Firestore if new
      if (userCredential.additionalUserInfo!.isNewUser) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': googleUser.displayName,
          'email': googleUser.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return userCredential.user;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
*/



import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 /* Future<void> saveUserToFirestore(User user) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    final userData = {
      'name': user.displayName ?? "User", // Use displayName if available
      'email': user.email,
      'phone': user.phoneNumber ?? "",
      'createdAt': FieldValue.serverTimestamp(),
    };

    await userDoc.set(userData, SetOptions(merge: true)); // Avoid overwriting existing fields
  }
  */
  /*Future<void> saveUserToFirestore(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    // Check if user already exists
    final existingUser = await userDoc.get();
    if (existingUser.exists) return;

    // Generate unique user ID (incremental integer)
    final userIdDoc = _firestore.collection('metadata').doc('user_count');
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userIdDoc);
      int currentId = !snapshot.exists ? snapshot.data() != null?0 : ['count'] ?? 0;
      transaction.set(userIdDoc, {'count': currentId + 1});
    });

    // Fetch the incremented ID
    final userIdSnapshot = await userIdDoc.get();
    final userId = userIdSnapshot.data()?['count'];

    // Generate a random username if none exists
    final generatedUsername = user.displayName ?? 'User${userId.toString().padLeft(6, '0')}';

    // Prepare user data
    final userData = {
      'userId': userId, // Unique integer ID
      'username': generatedUsername,
      'name': user.displayName ?? "User",
      'email': user.email,
      'phone': user.phoneNumber ?? "",
      'createdAt': FieldValue.serverTimestamp(),
    };

    // Save user data to Firestore
    await userDoc.set(userData, SetOptions(merge: true));
  }*/
  /*Future<void> saveUserToFirestore(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    // Check if user already exists
    final existingUser = await userDoc.get();
    if (existingUser.exists) return;

    // Reference to the user count document
    final userIdDoc = _firestore.collection('metadata').doc('user_count');

    // Increment the user count in a transaction
    int userId;
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userIdDoc);

      // Initialize or increment the user count
      int currentId = snapshot.exists
          ? (snapshot.data()?['count'] ?? 0)
          : 0;


      userId = currentId + 1;

      // Update the count in Firestore
      transaction.set(userIdDoc, {'count': userId});
    });

    // Generate a random username if none exists
    final generatedUsername = user.displayName ?? 'User${userId.toString().padLeft(6, '0')}';

    // Prepare user data
    final userData = {
      'userId': userId, // Unique integer ID
      'username': generatedUsername,
      'name': user.displayName ?? "User",
      'email': user.email,
      'phone': user.phoneNumber ?? "",
      'createdAt': FieldValue.serverTimestamp(),
    };

    // Save user data to Firestore
    await userDoc.set(userData, SetOptions(merge: true));
  }*/
  Future<void> saveUserToFirestore(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    // Check if user already exists
    final existingUser = await userDoc.get();
    if (existingUser.exists) return;

    // Reference to the user count document
    final userIdDoc = _firestore.collection('metadata').doc('user_count');

    // Declare userId as nullable
    int? userId;

    // Increment the user count in a transaction
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userIdDoc);

      // Initialize or increment the user count
      int currentId = snapshot.exists
          ? (snapshot.data()?['count'] ?? 0)
          : 0;

      userId = currentId + 1;

      // Update the count in Firestore
      transaction.set(userIdDoc, {'count': userId});
    });

    // Safely use userId after ensuring it is not null
    if (userId == null) {
      throw Exception('Failed to generate user ID');
    }

    // Generate a random username if none exists
    final generatedUsername = user.displayName ?? 'User${userId.toString().padLeft(6, '0')}';

    // Prepare user data
    final userData = {
      'userId': userId, // Unique integer ID
      'username': generatedUsername,
      'name': user.displayName ?? "User",
      'email': user.email,
      'phone': user.phoneNumber ?? "",
      'createdAt': FieldValue.serverTimestamp(),
    };

    // Save user data to Firestore
    await userDoc.set(userData, SetOptions(merge: true));
  }



  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.exists ? userDoc.data() : null;
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }


  // Email Sign Up
  Future<User?> signUpWithEmail(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential.user;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Email Login
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // Add Google user to Firestore if new
      if (userCredential.additionalUserInfo!.isNewUser) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': googleUser.displayName,
          'email': googleUser.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return userCredential.user;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
