import 'package:dartz/dartz.dart';
import 'package:event_kita_app/core/errors/failure.dart';
import 'package:event_kita_app/features/event_management/domain/entities/event_entity.dart';
import 'package:event_kita_app/features/event_management/domain/repositories/event_repository.dart';

class GetMyEvents {
  final EventRepository repository;

  GetMyEvents(this.repository);

  Future<Either<Failure, List<EventEntity>>> call(String creatorId) async {
    return await repository.getMyEvents(creatorId);
  }
}