import 'package:dartz/dartz.dart';
import 'package:event_kita_app/core/errors/failure.dart';
import 'package:event_kita_app/features/event_management/domain/repositories/event_repository.dart';

class DeleteEvent {
  final EventRepository repository;

  DeleteEvent(this.repository);

  Future<Either<Failure, void>> call(String eventId) async {
    return await repository.deleteEvent(eventId);
  }
}