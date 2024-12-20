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
    // Prevent duplicates
    final existingGifts = await _firestore
        .collection('gifts')
        .where('createdBy', isEqualTo: userId)
        .where('name', isEqualTo: name)
        .where('description', isEqualTo: description)
        .where('purchaseUrl', isEqualTo: purchaseUrl ?? '')
        .get();

    if (existingGifts.docs.isNotEmpty) {
      throw Exception("This gift already exists in your collection.");
    }

    await _firestore.collection('gifts').add({
      'name': name,
      'description': description,
      'category': category,
      'imageUrl': imageUrl != null && imageUrl.isNotEmpty ? imageUrl : '', // Avoid invalid URLs
      'status': status,
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

    await eventGiftsRef.set({
      ...gift,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

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

  //Pledge Gift
// Pledge a gift for an event
  Future<void> pledgeGift({
    required String eventId,
    required String giftId,
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("User not logged in.");

    final giftRef = _firestore.collection('gifts').doc(giftId);
    final giftSnapshot = await giftRef.get();

    if (!giftSnapshot.exists) {
      throw Exception("Gift not found.");
    }

    // Update the gift status to pledged
    await giftRef.update({'status': 'pledged', 'pledgedBy': userId, 'pledgedAt': FieldValue.serverTimestamp()});

    // Add the gift to the event's pledged gifts
    final eventGiftsRef = _firestore.collection('events').doc(eventId).collection('pledged_gifts');
    await eventGiftsRef.doc(giftId).set({
      ...giftSnapshot.data()!,
      'pledgedBy': userId,
      'pledgedAt': FieldValue.serverTimestamp(),
    });

    print("Gift pledged successfully!");
  }


}
