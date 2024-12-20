import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream for unread notifications count
  Stream<int> getUnreadNotificationCountStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUser.uid)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  /// Stream for all notifications for the current user
  Stream<List<Map<String, dynamic>>> getNotificationsStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Include notification ID
        return data;
      }).toList();
    });
  }

  /// Stream for real-time notifications
  Stream<Map<String, dynamic>> getNewNotificationStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final latest = snapshot.docs.first;
        return {
          ...latest.data(),
          'id': latest.id,
        };
      }
      return {};
    });
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUser.uid)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUser.uid)
        .get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  /// Send a notification to a specific user
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'title': title,
        'message': message,
        'isRead': false,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error sending notification: $e');
    }
  }

  /// Generate notifications for a gift pledge
  Future<void> notifyGiftPledge({
    required String eventId,
    required String giftName,
    required String pledgedByUserId,
    required String eventCreatorId,
  }) async {
    final pledgedByUserDoc = await _firestore.collection('users').doc(pledgedByUserId).get();
    final pledgedByUsername = pledgedByUserDoc.data()?['name'] ?? 'Unknown';

    await sendNotification(
      userId: eventCreatorId,
      title: 'Gift Pledged',
      message: '$pledgedByUsername pledged "$giftName" for your event.',
    );
  }

  /// Generate notifications for a new friend addition
  Future<void> notifyFriendAdded({
    required String friendUserId,
    required String addedByUserId,
  }) async {
    final addedByUserDoc = await _firestore.collection('users').doc(addedByUserId).get();
    final addedByUsername = addedByUserDoc.data()?['name'] ?? 'Unknown';

    await sendNotification(
      userId: friendUserId,
      title: 'New Friend Added',
      message: '$addedByUsername has added you as a friend.',
    );
  }

  /// Generate notifications for a new event
  Future<void> notifyNewEvent({
    required String eventName,
    required String creatorId,
  }) async {
    final friendsSnapshot = await _firestore.collection('users').doc(creatorId).collection('friends').get();

    for (final friend in friendsSnapshot.docs) {
      final friendUserId = friend.id;

      await sendNotification(
        userId: friendUserId,
        title: 'New Event',
        message: 'Your friend has created a new event: "$eventName".',
      );
    }
  }
}
