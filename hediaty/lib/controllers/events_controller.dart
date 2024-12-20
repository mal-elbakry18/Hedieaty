import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_controller.dart';

class EventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final NotificationController _notificationController = NotificationController();
  /// Get Current User ID
  Future<int?> getCurrentUserId() async {
    final firebaseUserId = FirebaseAuth.instance.currentUser?.uid;
    if (firebaseUserId == null) {
      throw Exception("User is not logged in.");
    }

    // Fetch user_id from Firestore
    final userDoc = await _firestore.collection('users').doc(firebaseUserId).get();
    if (!userDoc.exists) {
      throw Exception("User document does not exist in Firestore.");
    }

    final userId = userDoc.data()?['user_id'] as int?;
    if (userId == null) {
      throw Exception("user_id is missing in the user document.");
    }
    return userId;
  }

  ///Events related
  ///
 /* /// Fetch My Events as a Broadcast Stream
  Stream<List<Map<String, dynamic>>> fetchMyEvents() async* {
    final currentUserId = await getCurrentUserId();
    if (currentUserId == null) return;

    yield* _firestore
        .collection('events')
        .where('creatorId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) { return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
         // Convert to a Broadcast Stream
  }).asBroadcastStream();
  }

  /// Fetch Friends' Events as a Broadcast Stream
  Stream<List<Map<String, dynamic>>> fetchFriendsEvents() async* {
    final currentUserId = await getCurrentUserId();
    if (currentUserId == null) return;

    // Fetch friendships where the current user is either `user1_id` or `user2_id`
    final friendshipsSnapshot = await _firestore
        .collection('friendships')
        .where('user1_id', isEqualTo: currentUserId)
        .get();

    final reverseFriendshipsSnapshot = await _firestore
        .collection('friendships')
        .where('user2_id', isEqualTo: currentUserId)
        .get();

    // Combine and extract friend IDs
    final friendIds = <int>{};
    for (var doc in friendshipsSnapshot.docs) {
      friendIds.add(doc.data()['user2_id'] as int);
    }
    for (var doc in reverseFriendshipsSnapshot.docs) {
      friendIds.add(doc.data()['user1_id'] as int);
    }

    if (friendIds.isEmpty) {
      print("fetchFriendsEvents: No friends found.");
      return;
    }

    // Fetch events created by friends
    yield* _firestore
        .collection('events')
        .where('creatorId', whereIn: friendIds.toList())
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    });
  }
*/
  /// Prevent Duplicate Event Creation
  Future<bool> isEventAlreadyCreated(String name, int creatorId) async {
    final query = await _firestore
        .collection('events')
        .where('creatorId', isEqualTo: creatorId)
        .where('name', isEqualTo: name)
        .get();

    return query.docs.isNotEmpty;
  }

  Stream<List<Map<String, dynamic>>> fetchMyEvents() async* {
    final currentUserId = await getCurrentUserId();
    if (currentUserId == null) return;

    yield* _firestore
        .collection('events')
        .where('creatorId', isEqualTo: currentUserId)
        .snapshots()
        .asyncMap((snapshot) async {
      final events = snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      for (final event in events) {
        final creatorName = await getUserNameById(event['creatorId']);
        event['creatorName'] = creatorName ?? 'Unknown';
      }
      return events;
    });
  }

  Stream<List<Map<String, dynamic>>> fetchFriendsEvents() async* {
    final currentUserId = await getCurrentUserId();
    if (currentUserId == null) return;

    final friendshipsSnapshot = await _firestore
        .collection('friendships')
        .where('user1_id', isEqualTo: currentUserId)
        .get();

    final reverseFriendshipsSnapshot = await _firestore
        .collection('friendships')
        .where('user2_id', isEqualTo: currentUserId)
        .get();

    final friendIds = <int>{};
    for (var doc in friendshipsSnapshot.docs) {
      friendIds.add(doc.data()['user2_id'] as int);
    }
    for (var doc in reverseFriendshipsSnapshot.docs) {
      friendIds.add(doc.data()['user1_id'] as int);
    }

    if (friendIds.isEmpty) return;

    yield* _firestore
        .collection('events')
        .where('creatorId', whereIn: friendIds.toList())
        .snapshots()
        .asyncMap((snapshot) async {
      final events = snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      for (final event in events) {
        final creatorName = await getUserNameById(event['creatorId']);
        event['creatorName'] = creatorName ?? 'Unknown';
      }
      return events;
    });
  }

  /// Create Event
  Future<void> createEvent({
    required String name,
    required String description,
    required DateTime date,
    required String category,
    required bool isPublished,
  }) async {
    try {
      final creatorId = await getCurrentUserId();
      if (creatorId == null) {
        throw Exception("Creator ID could not be retrieved.");
      }

      await _firestore.collection('events').add({
        'name': name,
        'description': description,
        'date': date.toIso8601String(),
        'category': category,
        'creatorId': creatorId,
        'isPublished': isPublished,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Notify friends about the new event
      final friendsSnapshot = await _firestore
          .collection('users')
          .doc(creatorId.toString())
          .collection('friends')
          .get();

      for (final friend in friendsSnapshot.docs) {
        await _notificationController.sendNotification(
          userId: friend.id,
          title: 'New Event Added',
          message: 'Your friend has created a new event: "$name".',
        );
      }
    } catch (e) {
      throw Exception("Failed to create event: $e");
    }
  }


  /// Fetch Event Details
  Future<Map<String, dynamic>?> fetchEventDetails(String eventId) async {
    try {
      final snapshot = await _firestore.collection('events').doc(eventId).get();
      return snapshot.exists ? snapshot.data() : null;
    } catch (e) {
      throw Exception("Failed to fetch event details: $e");
    }
  }

  /// Edit Event
  Future<void> editEvent({
    required String eventId,
    required String name,
    required String description,
    required DateTime date,
    required String category,
  }) async {
    try {
      await _firestore.collection('events').doc(eventId).update({
        'name': name,
        'description': description,
        'date': date.toIso8601String(),
        'category': category,
      });
    } catch (e) {
      throw Exception("Failed to update event: $e");
    }
  }

  /// Fetch Events Created by a Specific User
  Future<List<Map<String, dynamic>>> fetchEventsByCreator(int creatorId) async {
    try {
      final querySnapshot = await _firestore
          .collection('events')
          .where('creatorId', isEqualTo: creatorId)
          .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch events: $e");
    }
  }

  /// Delete Event
  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  /// Validate Event Details
  bool validateEvent({
    required String name,
    required String description,
    required DateTime? date,
    required String? category,
  }) {
    return name.trim().isNotEmpty &&
        description.trim().isNotEmpty &&
        date != null &&
        category != null;
  }

  Future<String?> getUserNameById(int creatorId) async {
    try {
      final userSnapshot = await _firestore
          .collection('users')
          .where('user_id', isEqualTo: creatorId)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        return userSnapshot.docs.first.data()['name'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Failed to fetch user name: $e");
    }
  }

  ///Gift-Event related
  /// Fetch Gifts Related to an Event as Stream
  Stream<List<Map<String, dynamic>>> fetchEventGifts(String eventId) {
    return _firestore
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    });
  }

  /// Add Gift to Event
  Future<void> addGiftToEvent(String eventId, Map<String, dynamic> gift) async {
    final giftRef = _firestore.collection('events').doc(eventId).collection('gifts');
    final existingGift = await giftRef.where('giftId', isEqualTo: gift['id']).get();

    if (existingGift.docs.isNotEmpty) {
      throw Exception("This gift is already added to the event.");
    }

    await giftRef.doc(gift['id']).set({
      ...gift,
      'giftId': gift['id'],
      'addedAt': FieldValue.serverTimestamp(),
    });
  }
  /// Remove Gift from Event
  Future<void> removeGiftFromEvent(String eventId, String giftId) async {
    await _firestore
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .doc(giftId)
        .delete();
  }

  /// Check if a Gift is Already Added to Event
  Future<bool> isGiftAlreadyInEvent(String eventId, String giftId) async {
    final eventGifts = await _firestore
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .where('giftId', isEqualTo: giftId)
        .get();

    return eventGifts.docs.isNotEmpty;
  }
  Future<Map<String, dynamic>> getUserDetailsByFirebaseUid(String firebaseUid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(firebaseUid).get();
      if (!userDoc.exists) {
        throw Exception("User not found in Firestore.");
      }
      return userDoc.data()!;
    } catch (e) {
      throw Exception("Failed to fetch user details: $e");
    }
  }


}
