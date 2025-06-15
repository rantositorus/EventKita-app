import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreRsvpService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create
  Future<void> createRsvp({
    required String eventId,
    required String name,
    required String phone,
    required int attending,
    String? notes,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final eventRsvpRef = _firestore
        .collection('events')
        .doc(eventId)
        .collection('rsvps')
        .doc(user.uid);

    await eventRsvpRef.set({
      'userId': user.uid,
      'name': name,
      'phone': phone,
      'notes': notes ?? '',
      'attending': attending,
      'timestamp': FieldValue.serverTimestamp(),
    });

    final userRsvpRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_rsvps')
        .doc(eventId);

    await userRsvpRef.set({
      'eventId': eventId,
      'rsvpTime': FieldValue.serverTimestamp(),
    });
  }

  // Read
  Future<Map<String, dynamic>?> getRsvp(String eventId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final doc = await _firestore
        .collection('events')
        .doc(eventId)
        .collection('rsvps')
        .doc(user.uid)
        .get();

    return doc.exists ? doc.data() : null;
  }

  // Update
  Future<void> updateRSVP({
    required String eventId,
    required String name,
    required String phone,
    required int attending,
    String? notes,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final docRef = _firestore
        .collection('events')
        .doc(eventId)
        .collection('rsvps')
        .doc(user.uid);

    await docRef.update({
      'name': name,
      'phone': phone,
      'notes': notes ?? '',
      'attending': attending,
    });
  }

  //delete
  Future<void> deleteRSVP(String eventId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final batch = _firestore.batch();

    // dari event/rsvp
    final eventRsvpRef = _firestore
        .collection('events')
        .doc(eventId)
        .collection('rsvps')
        .doc(user.uid);
    batch.delete(eventRsvpRef);

    // dari users/myrsvp
    final userRsvpRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_rsvps')
        .doc(eventId);
    batch.delete(userRsvpRef);

    await batch.commit();
  }

  //Count Total Attending
  Future<int> getTotalRsvpCount(String eventId) async {
    final snapshot = await _firestore
        .collection('events')
        .doc(eventId)
        .collection('rsvps')
        .get();

    int total = 0;
    for (final doc in snapshot.docs) {
      total += (doc.data()['attending'] ?? 1) as int;;
    }
    return total;
  }
}
