import '../models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class EventRemoteDatasource {
  Future<void> createEvent(EventModel event);
  Future<void> updateEvent(EventModel event);
  Future<void> deleteEvent(String eventId);
  Future<List<EventModel>> getMyEvents(String creatorId);
}

class EventRemoteDataSourceImpl implements EventRemoteDatasource {
  final FirebaseFirestore firestore;

  EventRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> createEvent(EventModel event) async {
    try {
      await firestore.collection('events').doc(event.id).set(event.toMap());
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateEvent(EventModel event) async {
    try {
      await firestore.collection('events').doc(event.id).update(event.toMap());
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      await firestore.collection('events').doc(eventId).delete();
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<EventModel>> getMyEvents(String creatorId) async {
    try {
      final querySnapshot = await firestore
          .collection('events')
          .where('creatorId', isEqualTo: creatorId)
          .orderBy('dateTime', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => EventModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}