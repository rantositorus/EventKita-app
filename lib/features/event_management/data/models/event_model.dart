import 'package:equatable/equatable.dart';
import 'location_model.dart';

class EventModel extends Equatable {
  final String id;
  final String creatorId;
  final String title;
  final String description;
  final DateTime dateTime;
  final LocationModel location;
  final int? capacity;
  final String? category;
  final String? bannerImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    this.capacity,
    this.category,
    this.bannerImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      location: LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      capacity: json['capacity'] != null ? (json['capacity'] as num).toInt() : null,
      category: json['category'] as String?,
      bannerImageUrl: json['bannerImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creatorId': creatorId,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'location': location.toJson(),
      'capacity': capacity,
      'category': category,
      'bannerImageUrl': bannerImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        creatorId,
        title,
        description,
        dateTime,
        location,
        capacity,
        category,
        bannerImageUrl,
        createdAt,
        updatedAt,
      ];
}