import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GiftController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addGift({
    required String name,
    required String description,
    required String category,
    String? imageUrl,
    String status = 'available',
    String? purchaseUrl,
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("User not logged in");

    await _firestore.collection('gifts').add({
      'name': name,
      'description': description,
      'category': category,
      'imageUrl': imageUrl ?? '', // Default to an empty string if null
      'status': status, // Use provided status or default to 'available'
      'purchaseUrl': purchaseUrl ?? '',
      'createdBy': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }





  // Fetch All Gifts
  Stream<List<Map<String, dynamic>>> fetchAllGifts() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return _firestore
        .collection('gifts')
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
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

  // Update Gift Status
  Future<void> updateGiftStatus(String giftId, String status) async {
    await _firestore.collection('gifts').doc(giftId).update({
      'status': status,
    });
  }

  // Add Gift to Event
  Future<void> addGiftToEvent({
    required String eventId,
    required Map<String, dynamic> gift,
  }) async {
    final eventGiftsRef = _firestore
        .collection('events')
        .doc(eventId)
        .collection('event_gifts')
        .doc(gift['id']);

    final existingGift = await eventGiftsRef.get();

    if (existingGift.exists) {
      throw Exception("This gift is already added to the event.");
    }

    await eventGiftsRef.set(gift);
  }

  // Fetch Gifts for an Event
  Stream<List<Map<String, dynamic>>> fetchEventGifts(String eventId) {
    return _firestore
        .collection('events')
        .doc(eventId)
        .collection('event_gifts')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }
  Stream<List<Map<String, dynamic>>> fetchGifts({String? statusFilter}) {
    return _firestore.collection('gifts')
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

}
