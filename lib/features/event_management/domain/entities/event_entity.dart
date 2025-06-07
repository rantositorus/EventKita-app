import 'package:equatable/equatable.dart';
import 'location_entity.dart';

class EventEntity extends Equatable {
  final String id;
  final String creatorId;
  final String title;
  final String description;
  final DateTime dateTime;
  final LocationEntity location;
  final int? capacity;
  final String? category;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const EventEntity({
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
    this.updatedAt,
  });

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
        imageUrl,
        createdAt,
        updatedAt,
      ];
  
}