import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreEvents {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getEvents() async {
    '''
    Fetches a list of events from Firestore.
    Returns a list of event data as maps.
    Throws an exception if the fetch fails.
    List contains:
    capacity (number)

    category (string)

    createdAt (timestamp)

    creatorId (string)

    dateTime (timestamp)

    description (string)

    imageUrl (string)

    location (map): address (string), latitude (number), longitude (number)

    title (string)

    updatedAt (timestamp)
    ''';
    try {
      QuerySnapshot snapshot = await _firestore.collection('events').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getTop3Events() async {
    QuerySnapshot snapshot = await _firestore
    .collection('events')
    .orderBy('capacity', descending: true)
    .limit(3)
    .get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}