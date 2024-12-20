import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_controller.dart';

class GiftController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   final NotificationController _notificationController = NotificationController();

  Stream<List<Map<String, dynamic>>> fetchMyGiftsStream() async* {
    try {
      // Get the Firebase Auth user ID
      final firebaseUserId = FirebaseAuth.instance.currentUser?.uid;
      if (firebaseUserId == null) {
        throw Exception("No logged-in user found.");
      }

      // Fetch the user's `user_id` from the Firestore `users` collection
      final userDoc = await _firestore.collection('users').doc(firebaseUserId).get();
      final userId = userDoc.data()?['user_id'];

      if (userId == null) {
        throw Exception("User ID not found in Firestore.");
      }

      // Stream gifts created by the user (compare `creatorId` with `user_id`)
      yield* _firestore
          .collection('gifts')
          .where('creatorId', isEqualTo: userId) // Correctly compare with `creatorId`
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList());
    } catch (e) {
      print("Error in fetchMyGiftsStream: $e");
      yield [];
    }
  }




  Future<int?> getCurrentUserId() async {
    try {
      // Fetch the current Firebase user
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        throw Exception("No logged-in user found.");
      }

      // Fetch the user document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid) // Ensure the document ID matches firebase_uid
          .get();

      if (!userDoc.exists) {
        throw Exception("User document does not exist for the given Firebase UID.");
      }

      // Extract 'user_id'
      final userData = userDoc.data();
      if (userData == null || !userData.containsKey('user_id')) {

        throw Exception("User document does not contain 'user_id'.");
      }
      print(userData['user_id'] as int);
      return userData['user_id'] as int;
    } catch (e) {
      print("Error fetching current user ID: $e");
      return null;
    }
  }




  Future<List<Map<String, dynamic>>> fetchMyGifts(int userId) async {
    final querySnapshot = await _firestore
        .collection('gifts')
        .where('creatorId', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }


  Future<void> addGift({
    required String name,
    required String description,
    required String category,
    String? imageUrl,
    String status = 'available',
    String? purchaseUrl,
  }) async {
    try {
      // Fetch current user ID
      final firebaseUserId = FirebaseAuth.instance.currentUser?.uid;
      if (firebaseUserId == null) throw Exception("User not logged in");

      final userDoc = await _firestore.collection('users').doc(firebaseUserId).get();
      final userId = userDoc.data()?['user_id'];
      if (userId == null) {
        throw Exception("User ID not found in Firestore.");
      }

      // Check for duplicates
      final existingGifts = await _firestore
          .collection('gifts')
          .where('creatorId', isEqualTo: userId)
          .where('name', isEqualTo: name)
          .get();

      if (existingGifts.docs.isNotEmpty) {
        throw Exception("This gift already exists in your collection.");
      }

      // Add the gift to Firestore
      await _firestore.collection('gifts').add({
        'name': name,
        'description': description,
        'category': category,
        'imageUrl': imageUrl ?? '',
        'status': status,
        'purchaseUrl': purchaseUrl ?? '',
        'creatorId': userId, // Ensure `creatorId` is saved correctly
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding gift: $e");
      throw Exception("Failed to add gift: $e");
    }
  }



  // Fetch all gifts in the system (for adding to event)
  Stream<List<Map<String, dynamic>>> fetchAllGifts() {
    return _firestore.collection('gifts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    });
  }

  // Fetch Gifts by Status
  Stream<List<Map<String, dynamic>>> fetchGiftsByStatus(String status) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return _firestore
        .collection('gifts')
        .where('createdBy', isEqualTo: userId)
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  Future<void> addGiftToEvent(String eventId, Map<String, dynamic> gift) async {
    await _firestore.collection('events').doc(eventId).collection('gifts').add({
      'giftId': gift['id'],
      'name': gift['name'],
      'category': gift['category'],
      'status': 'available',
      'pledgedBy': null,
    });
  }




  // Fetch gifts in the event
  Stream<List<Map<String, dynamic>>> fetchEventGifts(String eventId) {
    return _firestore
        .collection('events')
        .doc(eventId)
        .snapshots()
        .map((snapshot) {
      final event = snapshot.data();
      if (event == null || !event.containsKey('gifts')) return [];
      final gifts = List<Map<String, dynamic>>.from(event['gifts']);
      return gifts;
    });
  }

  Stream<List<Map<String, dynamic>>> fetchGiftsCreatedByUser({String? statusFilter}) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception("User not logged in.");
    }

    return _firestore.collection('gifts')
        .where('createdBy', isEqualTo: userId) // Filter by gifts created by the current user
        .where('status', isEqualTo: statusFilter ?? 'available') // Filter by status if provided
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'],
          'imageUrl': data['imageUrl'],
          'category': data['category'],
          'description': data['description'],
          'purchaseUrl': data['purchaseUrl'],
          'status': data['status'],
        };
      }).toList();
    });
  }
// Fetch event gifts once (non-stream)
  Future<List<Map<String, dynamic>>> fetchEventGiftsOnce(String eventId) async {
    try {
      final snapshot = await _firestore
          .collection('gifts')
          .where('eventId', isEqualTo: eventId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'],
          'imageUrl': data['imageUrl'],
          'category': data['category'],
          'status': data['status'],
          'description': data['description'],
        };
      }).toList();
    } catch (e) {
      throw Exception('Error fetching event gifts: $e');
    }
  }
  Future<bool> isUserFriend(String userId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("User not logged in");

      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      final friends = userDoc.data()?['friends'] ?? [];

      return friends.contains(userId);
    } catch (e) {
      throw Exception('Error checking friend status: $e');
    }
  }


  // Update Gift Status
  Future<void> updateGiftStatus(String giftId, String eventId, String newStatus) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception("User not logged in");
    }

    // Update gift status and pledger info
    await _firestore
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .doc(giftId)
        .update({
      'status': newStatus,
      if (newStatus == 'pledged') 'pledgedBy': userId else 'pledgedBy': null,
    });
  }


  Future<bool> isFriend(int currentUserId, int friendUserId) async {
    final currentUser = await _firestore.collection('users').doc(currentUserId as String?).get();
    final friends = List<Map<String, dynamic>>.from(currentUser.data()?['friends'] ?? []);
    return friends.any((friend) => friend['friendId'] == friendUserId);
  }


  Future<void> removeGiftFromEvent({
    required String eventId,
    required String giftId,
  }) async {
    final eventGiftsRef = _firestore
        .collection('events')
        .doc(eventId)
        .collection('event_gifts')
        .doc(giftId);

    await eventGiftsRef.delete();
  }


  Future<void> pledgeGift(String eventId, String giftId, String pledgedBy) async {
    try {
      await _firestore
          .collection('events')
          .doc(eventId)
          .collection('gifts')
          .doc(giftId)
          .update({
        'status': 'pledged',
        'pledgedBy': pledgedBy,
      });

      // Send notification to the event creator about the pledge
      final eventDoc = await _firestore.collection('events').doc(eventId).get();
      final eventCreatorId = eventDoc.data()?['creatorId'];
      final giftDoc = await _firestore
          .collection('events')
          .doc(eventId)
          .collection('gifts')
          .doc(giftId)
          .get();
      final giftName = giftDoc.data()?['name'] ?? 'Unnamed Gift';

      if (eventCreatorId != null) {
        await _notificationController.sendNotification(
          userId: eventCreatorId,
          title: 'Gift Pledged',
          message: '$pledgedBy pledged "$giftName" for your event.',
        );
      }
    } catch (e) {
      throw Exception("Error pledging gift: $e");
    }
  }




  Future<bool> isGiftAlreadyInEvent(String eventId, String giftId) async {
    final eventGifts = await _firestore
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .where('giftId', isEqualTo: giftId)
        .get();

    return eventGifts.docs.isNotEmpty;
  }
  Future<bool> isUserEventOwner(String eventId, int userId) async {
    final eventDoc = await _firestore.collection('events').doc(eventId).get();
    return eventDoc.exists && eventDoc.data()?['creatorId'] == userId;
  }
  Future<void> addPledgedGift({
    required String eventId,
    required String giftId,
    required String pledgedBy,
    required String eventName,
    required Map<String, dynamic> giftDetails,
  }) async {
    try {
      await _firestore.collection('pledged_gifts').add({
        'eventId': eventId,
        'giftId': giftId,
        'pledgedBy': pledgedBy, // Username of the pledger
        'eventName': eventName, // Name of the event
        'giftDetails': giftDetails, // Full gift details
        'pledgedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add pledged gift: $e');
    }
  }


  Stream<List<Map<String, dynamic>>> fetchPledgedGiftsStream({String? eventId, String? creatorId}) {
    Query query = _firestore.collection('pledged_gifts');

    if (eventId != null) {
      query = query.where('eventId', isEqualTo: eventId);
    }
    if (creatorId != null) {
      query = query.where('creatorId', isEqualTo: creatorId);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
    });
  }

  /// Fetch the username from the user ID
  Future<String> getUsernameByUserId(int userId) async {
    try {
      final userDoc = await _firestore
          .collection('users')
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .get();

      if (userDoc.docs.isNotEmpty) {
        return userDoc.docs.first.data()['username'] as String;
      } else {
        throw Exception("User not found in Firestore.");
      }
    } catch (e) {
      throw Exception("Failed to fetch username: $e");
    }
  }

  /// Fetch the event name from the event ID
  Future<String> getEventNameById(String eventId) async {
    try {
      final eventDoc = await _firestore.collection('events').doc(eventId).get();

      if (eventDoc.exists) {
        return eventDoc.data()?['name'] as String? ?? "Unknown Event";
      } else {
        throw Exception("Event not found in Firestore.");
      }
    } catch (e) {
      throw Exception("Failed to fetch event name: $e");
    }
  }



}
