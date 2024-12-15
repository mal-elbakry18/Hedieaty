import 'package:cloud_firestore/cloud_firestore.dart';

class HomepageController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch Upcoming Events
  Future<List<Map<String, dynamic>>> fetchUpcomingEvents(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: false)
          .limit(3)
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  // Fetch Friends List
  Future<List<Map<String, dynamic>>> fetchFriendsList(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('friends')
          .where('ownerId', isEqualTo: userId)
          .orderBy('addedAt', descending: true)
          .limit(3)
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Error fetching friends: $e');
    }
  }

  // Fetch Notification Count
  Future<int> fetchNotificationCount(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false) // Only count unread notifications
          .get();

      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }
}
