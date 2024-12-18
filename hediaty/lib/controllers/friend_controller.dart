/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get Current User ID
  Future<String?> getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Add Friend by Phone Number
 /* Future<void> addFriendByPhone(String phoneNumber) async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    final friendSnapshot = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    if (friendSnapshot.docs.isEmpty) {
      throw Exception("No user found with this phone number.");
    }

    final friendData = friendSnapshot.docs.first.data();
    final friendId = friendSnapshot.docs.first.id;

    // Check if already friends
    final existingFriendSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .where('friendId', isEqualTo: friendId)
        .get();

    if (existingFriendSnapshot.docs.isNotEmpty) {
      throw Exception("This user is already your friend.");
    }

    // Add Friend (Two-way friendship)
    await _firestore.collection('users').doc(userId).collection('friends').add({
      'friendId': friendId,
      'friendName': friendData['name'],
      'friendPhone': friendData['phoneNumber'],
      'addedAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('users').doc(friendId).collection('friends').add({
      'friendId': userId,
      'friendName': FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown',
      'friendPhone': FirebaseAuth.instance.currentUser?.phoneNumber,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }*/

  // Add Friend by Phone Number
  Future<void> addFriendByPhone(String phoneNumber) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("User not logged in");

      // Check if the friend exists in Firestore
      final querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("No user found with this phone number.");
      }

      // Retrieve the friend's document
      final friendDoc = querySnapshot.docs.first;
      final friendId = friendDoc.id;

      // Check if the friend is already added
      final currentUserFriendsRef =
      _firestore.collection('friends').doc(currentUser.uid);

      final friendListSnapshot = await currentUserFriendsRef.get();

      List<dynamic>? friendsList;
      if (friendListSnapshot.exists) {
        friendsList = (friendListSnapshot.data() != null?['friends'] ?? []) as List?;
      } else {
        friendsList = [] ;
      }

      if (friendsList!.contains(friendId)) {
        throw Exception("User is already your friend.");
      }

      // Add the friend to the current user's friend list
      friendsList.add(friendId);
      await currentUserFriendsRef.set({'friends': friendsList});

      print("Friend added successfully!");
    } catch (e) {
      print("Error adding friend: $e");
      throw Exception("Failed to add friend: $e");
    }
  }

  // Fetch Friends List
  /*Stream<List<Map<String, dynamic>>> fetchFriends() async* {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    yield* _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'friendId': doc.data()['friendId'],
          'friendName': doc.data()['friendName'],
          'friendPhone': doc.data()['friendPhone'],
          'addedAt': doc.data()['addedAt'],
        };
      }).toList();
    });
  }*/

  // Fetch Friends for Current User
  Stream<List<Map<String, dynamic>>> fetchFriends() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception("User not logged in.");
    }

    return _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('friends')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'friendId': doc.id,
          'friendName': data['friendName'],
          'friendPhone': data['friendPhone'],
          'addedAt': data['addedAt'],
        };
      }).toList();
    });
  }

  // Delete Friend
  Future<void> deleteFriend(String friendId) async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    final userFriendSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .where('friendId', isEqualTo: friendId)
        .get();

    final friendUserSnapshot = await _firestore
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .where('friendId', isEqualTo: userId)
        .get();

    // Delete the friendship (Two-way)
    for (var doc in userFriendSnapshot.docs) {
      await _firestore.collection('users').doc(userId).collection('friends').doc(doc.id).delete();
    }

    for (var doc in friendUserSnapshot.docs) {
      await _firestore.collection('users').doc(friendId).collection('friends').doc(doc.id).delete();
    }
  }
}
*/
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user ID
  Future<String?> getCurrentUserId() async {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  // Fetch Friends List (Stream)
  Stream<List<Map<String, dynamic>>> fetchFriends() async* {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    yield* _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'friendId': doc.id,
          'friendName': data['friendName'],
          'friendPhone': data['friendPhone'],
          'addedAt': data['addedAt'],
        };
      }).toList();
    });
  }

  // Add Friend by Phone Number
  Future<Map<String, dynamic>> fetchFriendDetailsByPhone(String phoneNumber) async {
    // Check if user exists with the given phone number
    final querySnapshot = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception("No user found with this phone number.");
    }

    final friendDoc = querySnapshot.docs.first;
    return {
      'friendId': friendDoc.id,
      'friendName': friendDoc['name'],
      'friendPhone': friendDoc['phoneNumber'],
    };
  }

  Future<void> addFriendByPhone(String phoneNumber) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception("User not logged in.");

    final friendDetails = await fetchFriendDetailsByPhone(phoneNumber);
    final friendId = friendDetails['friendId'];

    // Check if the friend is already added
    final friendRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('friends');

    final existingFriendSnapshot =
    await friendRef.where('friendId', isEqualTo: friendId).get();

    if (existingFriendSnapshot.docs.isNotEmpty) {
      throw Exception("This user is already your friend.");
    }

    // Add friend to both users' collections
    await friendRef.add({
      'friendId': friendId,
      'friendName': friendDetails['friendName'],
      'friendPhone': friendDetails['friendPhone'],
      'addedAt': FieldValue.serverTimestamp(),
    });

    await _firestore
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .add({
      'friendId': currentUser.uid,
      'friendName': currentUser.displayName ?? 'Unknown',
      'friendPhone': currentUser.phoneNumber ?? 'Unknown',
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete Friend
  Future<void> deleteFriend(String friendId) async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    // Remove friend from current user's collection
    final currentUserFriends = _firestore
        .collection('users')
        .doc(userId)
        .collection('friends');

    final friendDocs =
    await currentUserFriends.where('friendId', isEqualTo: friendId).get();
    for (var doc in friendDocs.docs) {
      await currentUserFriends.doc(doc.id).delete();
    }

    // Remove current user from the friend's collection
    final friendRef =
    _firestore.collection('users').doc(friendId).collection('friends');
    final currentDocs =
    await friendRef.where('friendId', isEqualTo: userId).get();
    for (var doc in currentDocs.docs) {
      await friendRef.doc(doc.id).delete();
    }
  }
}
*/
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get Current User ID
  Future<String?> getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

// Fetch Friends for Current User
  Stream<List<Map<String, dynamic>>> fetchFriends() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception("User not logged in.");
    }

    return _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('friends')
        .snapshots()
        .asBroadcastStream() // Allow multiple listeners
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'friendId': doc.id,
          'firstName': data['first_name'],
          'lastName': data['last_name'],
          'addedAt': (data['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        };
      }).toList();
    });
  }

  // Add Friend by Phone Number
  Future<Map<String, dynamic>?> fetchFriendByPhone(String phoneNumber) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null; // No user found
      }

      final friendData = querySnapshot.docs.first.data();
      final friendId = querySnapshot.docs.first.id;

      return {
        'id': friendId,
        'first_name': friendData['first_name'],
        'last_name': friendData['last_name'],
        'phoneNumber': friendData['phoneNumber'],
      };
    } catch (e) {
      throw Exception("Error fetching friend: $e");
    }
  }
  Future<void> addFriendByPhone(String phoneNumber) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("User not logged in");

      // Check if friend exists
      final querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("No user found with this phone number.");
      }

      final friendDoc = querySnapshot.docs.first;
      final friendId = friendDoc.id;
      final friendData = friendDoc.data();

      // Add friend to current user's friends collection
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('friends')
          .doc(friendId)
          .set({
        'first_name': friendData['first_name'],
        'last_name': friendData['last_name'],
        'phoneNumber': friendData['phoneNumber'],
        'addedAt': FieldValue.serverTimestamp(),
      });

      // Add current user to friend's friends collection
      await _firestore
          .collection('users')
          .doc(friendId)
          .collection('friends')
          .doc(currentUser.uid)
          .set({
        'first_name': currentUser.displayName?.split(' ')[0] ?? 'Unknown',
        'last_name': currentUser.displayName?.split(' ')[1] ?? '',
        'phoneNumber': currentUser.phoneNumber,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding friend: $e");
      throw Exception("Failed to add friend: $e");
    }
  }

  // Delete Friend (Two-Way Deletion)
  Future<void> deleteFriend(String friendId) async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    try {
      // Remove friend from current user's friends list
      final userFriendsRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('friends')
          .where('friendId', isEqualTo: friendId);

      final userFriendDocs = await userFriendsRef.get();
      for (var doc in userFriendDocs.docs) {
        await doc.reference.delete();
      }

      // Remove current user from friend's friends list
      final friendFriendsRef = _firestore
          .collection('users')
          .doc(friendId)
          .collection('friends')
          .where('friendId', isEqualTo: userId);

      final friendFriendDocs = await friendFriendsRef.get();
      for (var doc in friendFriendDocs.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception("Failed to delete friend: $e");
    }
  }
}
*/

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate Username
  String _generateUsername(String firstName, String lastName) {
    final random = Random();
    int randomNumber = random.nextInt(9999);
    return "${firstName.toLowerCase()}_${lastName.toLowerCase()}_$randomNumber";
  }

  // Add Friend by Phone Number
  Future<void> addFriend(String friendPhone) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) throw Exception("User not logged in.");

    // Fetch current user details
    final currentUserDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    if (!currentUserDoc.exists) throw Exception("Current user details not found.");

    final currentUserData = currentUserDoc.data();
    final currentUsername = _generateUsername(
        currentUserData?['first_name'], currentUserData?['last_name']);

    // Fetch friend by phone number
    final friendSnapshot = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: friendPhone)
        .limit(1)
        .get();

    if (friendSnapshot.docs.isEmpty) {
      throw Exception("No user found with this phone number.");
    }

    final friendDoc = friendSnapshot.docs.first;
    final friendId = friendDoc.id;
    final friendData = friendDoc.data();

    // Prevent duplicate friendship
    final query = await _firestore
        .collection('friends')
        .where('user1Id', isEqualTo: currentUser.uid)
        .where('user2Id', isEqualTo: friendId)
        .get();

    if (query.docs.isNotEmpty) {
      throw Exception("Friendship already exists.");
    }

    // Save friendship
    await _firestore.collection('friends').add({
      'user1Id': currentUser.uid,
      'user1FirstName': currentUserData?['first_name'],
      'user1LastName': currentUserData?['last_name'],
      'user1Username': currentUsername,
      'user1Phone': currentUserData?['phoneNumber'],
      'user2Id': friendId,
      'user2FirstName': friendData['first_name'],
      'user2LastName': friendData['last_name'],
      'user2Username': _generateUsername(friendData['first_name'], friendData['last_name']),
      'user2Phone': friendData['phoneNumber'],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Fetch Friends List
  Stream<List<Map<String, dynamic>>> fetchFriends() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) throw Exception("User not logged in.");

    return _firestore
        .collection('friends')
        .where('user1Id', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'friendId': data['user2Id'],
        'friendName': "${data['user2FirstName']} ${data['user2LastName']}",
        'friendUsername': data['user2Username'],
        'friendPhone': data['user2Phone'],
      };
    }).toList());
  }
}
