/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class EventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create Event
  Future<void> createEvent({
    required String name,
    required String description,
    required DateTime date,
    required String category,
    required bool isPublished,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final eventId = _firestore.collection('events').doc().id;

      // Create the event document
      await _firestore.collection('events').doc(eventId).set({
        'id': eventId,
        'name': name,
        'description': description,
        'date': date.toIso8601String(),
        'category': category,
        'userId': user.uid,
        'userName': user.displayName ?? 'Anonymous',
        'isPublished': isPublished,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Notify friends if published
      if (isPublished) {
        await sendNotificationToFriends(
          userId: user.uid,
          title: 'New Event Published',
          body: '$name on ${date.toLocal()}',
        );
      }
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  // Update Event
  Future<void> updateEvent(String eventId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('events').doc(eventId).update(updatedData);
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  // Delete Event
  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  // Fetch Events
  Stream<List<Map<String, dynamic>>> fetchEvents() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    return _firestore
        .collection('events')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: false)
        .snapshots()
        .map((query) =>
        query.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }

  // Notify Friends
  Future<void> sendNotificationToFriends({
    required String userId,
    required String title,
    required String body,
  }) async {
    try {
      final friendsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('friends')
          .get();

      for (var friend in friendsSnapshot.docs) {
        final fcmToken = friend.data()['fcmToken'] as String?;
        if (fcmToken != null) {
          await FirebaseMessaging.instance.sendMessage(
            to: fcmToken,
            /*notification: RemoteMessage(
              notification: RemoteNotification(
                title: title,
                body: body,
              ),
            ),*/
          );
        }
      }
    } catch (e) {
      throw Exception('Failed to send notifications: $e');
    }
  }
}
*/

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Create Event
  Future<void> createEvent({
    required String name,
    required String description,
    required DateTime date,
    required String category,
    required bool isPublished,
  }) async {
    try {
      final userId = await getCurrentUserId();
      if (userId == null) throw Exception("User not logged in");

      // Add event to Firestore
      await _firestore.collection('events').add({
        'name': name,
        'description': description,
        'date': date.toIso8601String(),
        'category': category,
        'isPublished': isPublished,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  // Validate Event
  bool validateEvent({
    required String name,
    required String description,
    required DateTime? date,
    required String? category,
  }) {
    if (name.trim().isEmpty ||
        description.trim().isEmpty ||
        date == null ||
        category == null) {
      return false;
    }
    return true;
  }

  // Fetch Events (My Events and Friends' Events)
  Stream<List<Map<String, dynamic>>> fetchEvents() async* {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    yield* _firestore
        .collection('events')
        .orderBy('date') // Sort by date
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'],
          'description': data['description'],
          'date': data['date'],
          'category': data['category'],
          'isPublished': data['isPublished'],
          'userId': data['userId'],
          'creatorName': data['creatorName'] ?? 'Unknown',
        };
      }).toList();
    });
  }

  // Fetch Only My Events
  Stream<List<Map<String, dynamic>>> fetchMyEvents() async* {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    yield* _firestore
        .collection('events')
        .where('userId', isEqualTo: userId) // Filter by current user
        .orderBy('date') // Sort by date
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'],
          'description': data['description'],
          'date': data['date'],
          'category': data['category'],
          'isPublished': data['isPublished'],
          'userId': data['userId'],
          'creatorName': data['creatorName'] ?? 'Unknown',
        };
      }).toList();
    });
  }

  // Edit Event
  Future<void> editEvent({
    required String eventId,
    required String name,
    required String description,
    required DateTime date,
    required String category,
  }) async {
    try {
      final userId = await getCurrentUserId();
      if (userId == null) throw Exception("User not logged in");

      final event = await _firestore.collection('events').doc(eventId).get();

      if (event.exists && event.data()?['userId'] == userId) {
        await _firestore.collection('events').doc(eventId).update({
          'name': name,
          'description': description,
          'date': date.toIso8601String(),
          'category': category,
        });
      } else {
        throw Exception("You can only edit your own events");
      }
    } catch (e) {
      throw Exception('Failed to edit event: $e');
    }
  }

  // Delete Event
  Future<void> deleteEvent(String eventId) async {
    try {
      final userId = await getCurrentUserId();
      if (userId == null) throw Exception("User not logged in");

      final event = await _firestore.collection('events').doc(eventId).get();

      if (event.exists && event.data()?['userId'] == userId) {
        await _firestore.collection('events').doc(eventId).delete();
      } else {
        throw Exception("You can only delete your own events");
      }
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }
}*/

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get Current User ID
  Future<String?> getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Validate Event Details
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

  // Create a New Event
  Future<void> createEvent({
    required String name,
    required String description,
    required DateTime date,
    required String category,
    required bool isPublished,
  }) async {
    try {
      final userId = await getCurrentUserId();
      if (userId == null) throw Exception("User not logged in");

      // Add event to Firestore
      await _firestore.collection('events').add({
        'name': name,
        'description': description,
        'date': date.toIso8601String(),
        'category': category,
        'isPublished': isPublished,
        'userId': userId,
        'creatorName': FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  // Fetch My Events as a Future
  Future<List<Map<String, dynamic>>> fetchMyEventsFuture() async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    final snapshot = await _firestore
        .collection('events')
        .where('userId', isEqualTo: userId)
        .orderBy('date')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'],
        'description': data['description'],
        'date': data['date'],
        'category': data['category'],
        'isPublished': data['isPublished'],
        'userId': data['userId'],
        'creatorName': data['creatorName'] ?? 'Unknown',
      };
    }).toList();
  }

  // Fetch Friends' Events as a Future
  Future<List<Map<String, dynamic>>> fetchFriendsEventsFuture() async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    final snapshot = await _firestore
        .collection('events')
        .where('userId', isNotEqualTo: userId)
        .orderBy('date')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'],
        'description': data['description'],
        'date': data['date'],
        'category': data['category'],
        'isPublished': data['isPublished'],
        'userId': data['userId'],
        'creatorName': data['creatorName'] ?? 'Unknown',
      };
    }).toList();
  }

  // Delete Event
  Future<void> deleteEvent(String eventId) async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    final event = await _firestore.collection('events').doc(eventId).get();

    if (event.exists && event.data()?['userId'] == userId) {
      await _firestore.collection('events').doc(eventId).delete();
    } else {
      throw Exception("You can only delete your own events.");
    }
  }

  // Edit Event
  Future<void> editEvent({
    required String eventId,
    required String name,
    required String description,
    required DateTime date,
    required String category,
  }) async {
    try {
      final userId = await getCurrentUserId();
      if (userId == null) throw Exception("User not logged in");

      final event = await _firestore.collection('events').doc(eventId).get();

      if (event.exists && event.data()?['userId'] == userId) {
        await _firestore.collection('events').doc(eventId).update({
          'name': name,
          'description': description,
          'date': date.toIso8601String(),
          'category': category,
        });
      } else {
        throw Exception("You can only edit your own events.");
      }
    } catch (e) {
      throw Exception('Failed to edit event: $e');
    }
  }
}

*/
/*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get Current User ID
  Future<String?> getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Prevent Duplicate Event Creation
  Future<bool> isEventAlreadyCreated(String name) async {
    final userId = await getCurrentUserId();
    final query = await _firestore
        .collection('events')
        .where('userId', isEqualTo: userId)
        .where('name', isEqualTo: name)
        .get();

    return query.docs.isNotEmpty;
  }

  // Create Event
  Future<void> createEvent({
    required String name,
    required String description,
    required DateTime date,
    required String category, required bool isPublished,
  }) async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    // Check for duplicates
    if (await isEventAlreadyCreated(name)) {
      throw Exception("Event with this name already exists!");
    }

    await _firestore.collection('events').add({
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'category': category,
      'userId': userId,
      'creatorName': FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Fetch My Events
  Stream<List<Map<String, dynamic>>> fetchMyEvents() async* {
    final userId = await getCurrentUserId();
    yield* _firestore
        .collection('events')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return {'id': doc.id, ...data};
    }).toList());
  }

  // Fetch Event Details
  Future<Map<String, dynamic>?> fetchEventDetails(String eventId) async {
    final snapshot = await _firestore.collection('events').doc(eventId).get();
    return snapshot.exists ? snapshot.data() : null;
  }

  // Edit Event
  Future<void> editEvent({
    required String eventId,
    required String name,
    required String description,
    required DateTime date,
    required String category,
  }) async {
    await _firestore.collection('events').doc(eventId).update({
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'category': category,
    });
  }

  // Delete Event
  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  // Validate Event Details
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

}
*/


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/firebase/auth_services.dart';

class EventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Get Current User ID
  Future<String?> getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Getter for Current User ID
  String? get currentUserId {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  // Fetch My Events
  Stream<List<Map<String, dynamic>>> fetchMyEvents() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Stream.empty(); // Return empty stream if user not logged in
    }

    return _firestore
        .collection('events')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> fetchFriendsEvents() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('events')
        .where('userId', isNotEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    });
  }


  // Fetch Friends' Events
 /* Stream<List<Map<String, dynamic>>> fetchFriendsEvents() async* {
    final userId = await getCurrentUserId();
    yield* _firestore
        .collection('events')
        .where('userId', isNotEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return {'id': doc.id, ...data};
    }).toList());
  }*/

  // Prevent Duplicate Event Creation
  Future<bool> isEventAlreadyCreated(String name) async {
    final userId = await getCurrentUserId();
    final query = await _firestore
        .collection('events')
        .where('userId', isEqualTo: userId)
        .where('name', isEqualTo: name)
        .get();

    return query.docs.isNotEmpty;
  }

  // Create Event
  Future<void> createEvent({
    required String name,
    required String description,
    required DateTime date,
    required String category,
    required bool isPublished,
  }) async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    // Check for duplicates
    if (await isEventAlreadyCreated(name)) {
      throw Exception("Event with this name already exists!");
    }
    final user = FirebaseAuth.instance.currentUser;
    final userDetails = await AuthService().getUserDetails(user!.uid);
    await _firestore.collection('events').add({
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'category': category,
      'userId': userId,
      'creatorName':userDetails?["first_name"] ?? "User",
      'createdAt': FieldValue.serverTimestamp(),
    });
  }


  // Fetch Event Details
  Future<Map<String, dynamic>?> fetchEventDetails(String eventId) async {
    final snapshot = await _firestore.collection('events').doc(eventId).get();
    return snapshot.exists ? snapshot.data() : null;
  }

  // Edit Event
  Future<void> editEvent({
    required String eventId,
    required String name,
    required String description,
    required DateTime date,
    required String category,
  }) async {
    await _firestore.collection('events').doc(eventId).update({
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'category': category,
    });
  }

  // Delete Event
  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  // Validate Event Details
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
}
