import 'package:dartz/dartz.dart';
import 'package:event_kita_app/core/errors/failure.dart';
import 'package:event_kita_app/features/event_management/domain/entities/event_entity.dart';

abstract class EventRepository {
  Future<Either<Failure, void>> createEvent(EventEntity event);
  Future<Either<Failure, void>> updateEvent(EventEntity event);
  Future<Either<Failure, void>> deleteEvent(String eventId);
  Future<Either<Failure, List<EventEntity>>> getMyEvents(String creatorId);
}