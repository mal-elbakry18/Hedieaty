import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add User
 /* Future<void> addUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).set(data);
  }*/
  Future<void> addUser(String uid, String username, int userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).set({
      ...data,
      'userId': userId,
      'username': username,
    });
  }


  // Create List/Event
  Future<void> createList(String userId, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('lists_events')
        .add(data);
  }

  // Add Gift to List
  Future<void> addGift(String userId, String listId, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('lists_events')
        .doc(listId)
        .collection('gifts')
        .add(data);
  }

  // Pledge Gift
  Future<void> pledgeGift(String userId, String listId, String giftId, String pledgerId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('lists_events')
        .doc(listId)
        .collection('gifts')
        .doc(giftId)
        .update({'status': 'pledged', 'pledged_by': pledgerId});
  }

  // Add Friend
  Future<void> addFriend(String userId, String friendId) async {
    await _firestore.collection('friends_list').add({
      'user_id': userId,
      'friend_id': friendId,
    });
  }
  Future<int> incrementCounter(String docPath, String field) async {
    final docRef = _firestore.doc(docPath);

    return await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      // Check if the document exists and get the current value of the field
      int currentValue = 0;
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?; // Safely cast the data
        if (data != null && data.containsKey(field)) {
          currentValue = data[field] as int? ?? 0;
        }
      }

      // Update the field with the incremented value
      transaction.update(docRef, {field: currentValue + 1});
      return currentValue + 1;
    });
  }




}
