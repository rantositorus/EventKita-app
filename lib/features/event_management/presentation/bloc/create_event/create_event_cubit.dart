import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:event_kita_app/features/event_management/domain/entities/event_entity.dart';
import 'package:event_kita_app/features/event_management/domain/entities/location_entity.dart';
import 'package:event_kita_app/features/event_management/domain/usecases/create_event.dart';

part 'create_event_state.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  final CreateEvent createEventUseCase;
  final _uuid = const Uuid();

  CreateEventCubit({required this.createEventUseCase})
    : super(CreateEventInitial());

  Future<void> submitCreateEvent(Map<String, dynamic> eventData) async {
    print('Data yang diterima: $eventData');
    emit(CreateEventLoading());
    try {
      final now = DateTime.now();
      final event = EventEntity(
        id: _uuid.v4(),
        creatorId: "user123",
        title: eventData['title'] ?? 'Event Title',
        description: eventData['description'] ?? 'Event Description',
        dateTime: eventData['dateTime'] ?? now,
        location: LocationEntity(
          latitude: eventData['latitude'] ?? 0.0,
          longitude: eventData['longitude'] ?? 0.0,
          address: eventData['location_address'] ?? 'Event Address',
        ),
        createdAt: now,
        updatedAt: now,
        capacity: eventData['capacity'],
        category: eventData['category'],
        imageUrl: eventData['imageUrl'],
      );

      final failureOrSuccess = await createEventUseCase(event);
      failureOrSuccess.fold(
        (failure) => emit(CreateEventError(failure.message)),
        (_) => emit(CreateEventSuccess()),
      );
    } catch (e) {
      emit(CreateEventError(e.toString()));
    }
  }
}
