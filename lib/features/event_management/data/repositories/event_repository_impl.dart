import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:event_kita_app/core/errors/failure.dart';
import 'package:event_kita_app/features/event_management/data/datasources/event_remote_datasource.dart';
import 'package:event_kita_app/features/event_management/data/models/event_model.dart';
import 'package:event_kita_app/features/event_management/data/models/location_model.dart';
import 'package:event_kita_app/features/event_management/domain/entities/event_entity.dart';
import 'package:event_kita_app/features/event_management/domain/entities/location_entity.dart';
import 'package:event_kita_app/features/event_management/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDatasource remoteDatasource;

  EventRepositoryImpl({required this.remoteDatasource});

  EventModel _mapEntityToModel(EventEntity entity) => EventModel(
    id: entity.id,
    creatorId: entity.creatorId,
    title: entity.title,
    description: entity.description,
    dateTime: Timestamp.fromDate(entity.dateTime),
    location: LocationModel(
      address: entity.location.address,
      latitude: entity.location.latitude,
      longitude: entity.location.longitude
    ),
    capacity: entity.capacity,
    category: entity.category,
    imageUrl: entity.imageUrl,
    createdAt: Timestamp.fromDate(entity.createdAt),
    updatedAt: Timestamp.fromDate(entity.updatedAt),
  );

  EventEntity _mapModelToEntity(EventModel model) => EventEntity(
    id: model.id,
    creatorId: model.creatorId,
    title: model.title,
    description: model.description,
    dateTime: model.dateTime.toDate(),
    location: LocationEntity(
      address: model.location.address,
      latitude: model.location.latitude,
      longitude: model.location.longitude,
    ),
    capacity: model.capacity,
    category: model.category,
    imageUrl: model.imageUrl,
    createdAt: model.createdAt.toDate(),
    updatedAt: model.updatedAt.toDate(),
  );

  @override
  Future<Either<Failure, void>> createEvent(EventEntity event) async {
    try {
      final eventModel = _mapEntityToModel(event);
      await remoteDatasource.createEvent(eventModel);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateEvent(EventEntity event) async {
    try {
      final eventModel = _mapEntityToModel(event);
      await remoteDatasource.updateEvent(eventModel);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String eventId) async {
    try {
      await remoteDatasource.deleteEvent(eventId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> getMyEvents(String creatorId) async {
    try {
      final eventModels = await remoteDatasource.getMyEvents(creatorId);
      final eventEntities = eventModels.map((model) => _mapModelToEntity(model)).toList();
      return Right(eventEntities);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

}
