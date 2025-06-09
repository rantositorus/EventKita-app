import 'package:cloud_firestore/cloud_firestore.dart';
import 'location_model.dart';

class EventModel {
  final String id;
  final String creatorId;
  final String title;
  final String description;
  final Timestamp dateTime;
  final LocationModel location;
  final int? capacity;
  final String? category;
  final String? imageUrl;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  EventModel({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    this.capacity,
    this.category,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      creatorId: data['creatorId'] as String,
      title: data['title'] as String,
      description: data['description'] as String,
      dateTime: data['dateTime'] as Timestamp,
      location: LocationModel.fromJson(
        data['location'] as Map<String, dynamic>,
      ),
      capacity: data['capacity'] as int?,
      category: data['category'] as String?,
      imageUrl: data['bannerImageUrl'] as String?,
      createdAt: data['createdAt'] as Timestamp,
      updatedAt: data['updatedAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'creatorId': creatorId,
      'title': title,
      'description': description,
      'dateTime': dateTime,
      'location': location.toJson(),
      'capacity': capacity,
      'category': category,
      'bannerImageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
