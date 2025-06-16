import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreEvents {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getEventsStream() {
    return _firestore
        .collection('events')
        .orderBy('capacity', descending: true)
        .limit(3)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }

  Stream<List<Map<String, dynamic>>> getAllEventsStream() {
    return _firestore
        .collection('events')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }
}
