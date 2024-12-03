import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add User
  Future<void> addUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).set(data);
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
}
