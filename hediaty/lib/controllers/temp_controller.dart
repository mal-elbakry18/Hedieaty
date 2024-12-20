import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_controller.dart';

class FriendController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationController _notificationController = NotificationController();

  // Get Current User ID
  Future<String?> getCurrentUserId() async {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  // Fetch Current User's Friendships
  Stream<List<Map<String, dynamic>>> fetchFriends() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("User not logged in.");
    }

    return _firestore
        .collection('friendships')
        .where('user1_id', isEqualTo: currentUser.uid)
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<Map<String, dynamic>> friends = [];

      for (var doc in querySnapshot.docs) {
        final friendshipData = doc.data();
        final friendId =
        friendshipData['user2_id']; // Get the other user's ID

        // Fetch friend's details
        final friendDoc = await _firestore.collection('users').doc(friendId).get();

        if (friendDoc.exists) {
          final friendData = friendDoc.data();
          friends.add({
            'friend_id': friendId,
            'friendship_id': doc.id,
            'friend_name': '${friendData?['first_name']} ${friendData?['last_name']}',
            'friend_phone': friendData?['number'] ?? 'N/A',
          });
        }
      }
      return friends;
    });
  }

  // Add a Friend by Phone Number
  Future<void> addFriendByPhone(String phoneNumber) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("User not logged in.");
    }

    final currentUserId = currentUser.uid;

    try {
      // Check if the friend exists in Firestore
      final querySnapshot = await _firestore
          .collection('users')
          .where('number', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("No user found with the given phone number.");
      }

      // Retrieve the friend's document
      final friendDoc = querySnapshot.docs.first;
      final friendId = friendDoc.id;

      // Prevent adding oneself
      if (currentUserId == friendId) {
        throw Exception("You cannot add yourself as a friend.");
      }

      // Check if the friendship already exists
      final friendshipQuery = await _firestore
          .collection('friendships')
          .where('user1_id', isEqualTo: currentUserId)
          .where('user2_id', isEqualTo: friendId)
          .get();

      if (friendshipQuery.docs.isNotEmpty) {
        throw Exception("Friendship already exists.");
      }

      // Create the friendship
      await _firestore.collection('friendships').add({
        'user1_id': currentUserId,
        'user2_id': friendId,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Send a notification to the friend
      final currentUserDoc = await _firestore.collection('users').doc(currentUserId).get();
      final currentUserData = currentUserDoc.data();

      await _notificationController.sendNotification(
        userId: friendId,
        title: 'New Friend Request',
        message: '${currentUserData?['first_name']} added you as a friend!',
      );

      print("Friend added successfully.");
    } catch (e) {
      print("Error adding friend: $e");
      throw Exception("Failed to add friend: $e");
    }
  }

  // Delete a Friend
  Future<void> deleteFriend(String friendId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      throw Exception("User not logged in.");
    }

    try {
      // Find the friendship document
      final friendshipQuery = await _firestore
          .collection('friendships')
          .where('user1_id', isEqualTo: currentUserId)
          .where('user2_id', isEqualTo: friendId)
          .get();

      if (friendshipQuery.docs.isEmpty) {
        throw Exception("Friendship document not found.");
      }

      // Delete the friendship
      final friendshipId = friendshipQuery.docs.first.id;
      await _firestore.collection('friendships').doc(friendshipId).delete();

      print("Friendship successfully deleted.");
    } catch (e) {
      print("Error deleting friend: $e");
      throw Exception("Failed to delete friend: $e");
    }
  }
}
