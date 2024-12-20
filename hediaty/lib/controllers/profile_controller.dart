import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch User Details
  Future<Map<String, dynamic>> getUserDetails() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception("User not logged in");

    final userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc.data() ?? {};
  }

  // Update User Profile Photo
 /* Future<void> updateProfilePhoto(String photoUrl) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception("User not logged in");

    await _firestore.collection('users').doc(userId).update({
      'photoUrl': photoUrl,
    });
  }*/
  Future<void> updateProfilePhoto(String photoUrl) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("User not logged in.");

    await _firestore.collection('users').doc(userId).update({'photoUrl': photoUrl});
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }



}
