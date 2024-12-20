


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

  /// Fetch Friends List
  Stream<List<Map<String, dynamic>>> fetchFriends() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception("User not logged in.");
    }

    return _firestore
        .collection('users')
        .doc(currentUser.uid)
        .snapshots()
        .asyncMap((snapshot) async {
      if (!snapshot.exists) {
        return [];
      }

      // Get the `user_id` for the current user
      final currentUserData = snapshot.data();
      final currentUserId = currentUserData?['user_id'];

      if (currentUserId == null) {
        throw Exception("Current user's user_id not found.");
      }

      // Retrieve the friends array
      final friendsArray = currentUserData?['friends'] ?? [];
      List<Map<String, dynamic>> friendsWithDetails = [];

      // Fetch details for each friend based on `user_id`
      for (var friend in friendsArray) {
        final friendId = friend['friend_id']; // Friend's `user_id`

        // Fetch the friend's details from the `users` collection
        final friendSnapshot = await _firestore
            .collection('users')
            .where('user_id', isEqualTo: friendId)
            .limit(1)
            .get();

        if (friendSnapshot.docs.isNotEmpty) {
          final friendData = friendSnapshot.docs.first.data();

          // Add the friend's details to the list
          friendsWithDetails.add({
            'friendship_id': friend['friendship_id'], // Friendship ID
            'friend_id': friendId, // Friend's `user_id`
            'friend_name': friendData['first_name'] ?? 'Unknown', // Friend's name
            'friend_phone': friendData['number'] ?? 'N/A', // Friend's phone
          });
        }
      }

      return friendsWithDetails;
    });
  }


  /// Get Username by User ID
  Future<String?> getUsernameByUserId(int userId) async {
    try {
      // Query the `users` collection for the given `user_id`
      final querySnapshot = await _firestore
          .collection('users')
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Extract and return the `name` attribute
        return querySnapshot.docs.first.data()['name'] as String?;
      }
      return null; // Return null if no user found
    } catch (e) {
      throw Exception("Failed to fetch username by user_id: $e");
    }
  }
  Stream<List<Map<String, dynamic>>> fetchFriendsWithDetails() async* {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception("User not logged in.");
    }

    final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();

    if (!userDoc.exists) {
      throw Exception("Current user's document does not exist.");
    }

    final friendsList = List<Map<String, dynamic>>.from(userDoc.data()?['friends'] ?? []);

    List<Map<String, dynamic>> friendsWithDetails = [];

    for (var friend in friendsList) {
      final friendUserId = friend['friend_id'] as int;

      // Fetch the friend's details
      final username = await getUsernameByUserId(friendUserId);
      if (username != null) {
        friendsWithDetails.add({
          ...friend,
          'username': username,
        });
      }
    }

    yield friendsWithDetails;
  }





  // Add a friend by phone number
  Future<void> addFriendByPhone(String phoneNumber) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("User not logged in.");
      }

      final currentUserDoc =
      await _firestore.collection('users').doc(currentUser.uid).get();
      if (!currentUserDoc.exists) {
        throw Exception("Current user document not found.");
      }

      final currentUserData = currentUserDoc.data();
      final currentUserId = currentUserData?['user_id'];

      final querySnapshot = await _firestore
          .collection('users')
          .where('number', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("No user found with the given phone number.");
      }

      final friendDoc = querySnapshot.docs.first;
      final friendData = friendDoc.data();
      final friendId = friendData['user_id'];

      final friendshipId = ([currentUserId, friendId]..sort()).join();
      // Check if the user is trying to add themselves
      if (currentUserId == friendId) {
        throw Exception("You cannot add yourself as a friend.");
      }
      final existingFriendship = await _firestore
          .collection('friendships')
          .doc(friendshipId)
          .get();

      if (existingFriendship.exists) {
        throw Exception("Friendship already exists.");
      }

      await _firestore.collection('friendships').doc(friendshipId).set({
        'user1_id': currentUserId,
        'user2_id': friendId,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Update both users' friends list
      await _firestore.collection('users').doc(currentUser.uid).update({
        'friends': FieldValue.arrayUnion([
          {'friend_id': friendId, 'friendship_id': friendshipId}
        ]),
      });
      await _firestore.collection('users').doc(friendDoc.id).update({
        'friends': FieldValue.arrayUnion([
          {'friend_id': currentUserId, 'friendship_id': friendshipId}
        ]),
      });

      // Send notification to the friend
      await _notificationController.sendNotification(
        userId: friendDoc.id,
        title: 'New Friend Added',
        message: '${currentUserData?['name']} added you as a friend.',
      );
    } catch (e) {
      throw Exception("Error adding friend: $e");
    }
  }

  Future<void> deleteFriend(String friendId, String friendshipId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception("User not logged in.");
    }

    try {
      // Step 1: Fetch the current user's `user_id` from Firestore
      final currentUserDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      if (!currentUserDoc.exists) {
        throw Exception("Current user's document not found.");
      }

      final currentUserData = currentUserDoc.data();
      final currentUserId = currentUserData?['user_id']?.toString(); // Convert to String if needed

      if (currentUserId == null) {
        throw Exception("Current user's user_id not found.");
      }

      // Step 2: Fetch the friendship document
      final friendshipDoc = await _firestore.collection('friendships').doc(friendshipId).get();
      if (!friendshipDoc.exists) {
        throw Exception("Friendship document not found for ID: $friendshipId.");
      }

      final friendshipData = friendshipDoc.data();

      // Debugging logs
      print("CurrentUserId: $currentUserId, User1Id: ${friendshipData?['user1_id']}, User2Id: ${friendshipData?['user2_id']}");
      print("Provided FriendId: $friendId");

      // Step 3: Validate that the current user is part of the friendship
      final user1Id = friendshipData?['user1_id']?.toString(); // Ensure String type
      final user2Id = friendshipData?['user2_id']?.toString(); // Ensure String type

      String otherUserId;
      if (currentUserId == user1Id) {
        otherUserId = user2Id!;
      } else if (currentUserId == user2Id) {
        otherUserId = user1Id!;
      } else {
        throw Exception("Current user is not part of this friendship.");
      }

      // Step 4: Ensure the `friendId` matches the resolved `otherUserId`
      if (friendId != otherUserId) {
        throw Exception("The provided friendId does not match the other user in the friendship.");
      }

      // Step 5: Delete the friendship document
      await _firestore.collection('friendships').doc(friendshipId).delete();

      // Step 6: Update the current user's `friends` list
      await _firestore.collection('users').doc(currentUser.uid).update({
        'friends': FieldValue.arrayRemove([
          {'friend_id': friendId, 'friendship_id': friendshipId}
        ]),
      });

      // Step 7: Update the friend's `friends` list
      final friendDocSnapshot = await _firestore
          .collection('users')
          .where('user_id', isEqualTo: friendId)
          .limit(1)
          .get();

      if (friendDocSnapshot.docs.isNotEmpty) {
        final friendDocId = friendDocSnapshot.docs.first.id;

        await _firestore.collection('users').doc(friendDocId).update({
          'friends': FieldValue.arrayRemove([
            {'friend_id': currentUserId, 'friendship_id': friendshipId}
          ]),
        });
      }

      print("Friendship successfully deleted.");
    } catch (e) {
      print("Error deleting friend: $e");
      throw Exception("Failed to delete friend: $e");
    }
  }






}
