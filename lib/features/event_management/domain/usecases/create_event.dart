import 'package:dartz/dartz.dart';
import 'package:event_kita_app/core/errors/failure.dart';
import 'package:event_kita_app/features/event_management/domain/entities/event_entity.dart';
import 'package:event_kita_app/features/event_management/domain/repositories/event_repository.dart';

class CreateEvent {
  final EventRepository repository;
  
  CreateEvent(this.repository);
  
  Future<Either<Failure, void>> call(EventEntity event) async{
    return await repository.createEvent(event);
  }
}