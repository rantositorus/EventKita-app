import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:event_kita_app/features/event_management/domain/entities/event_entity.dart';
import 'package:event_kita_app/features/event_management/domain/entities/location_entity.dart';
import 'package:event_kita_app/features/event_management/domain/usecases/update_event.dart';

part 'update_event_state.dart';

class UpdateEventCubit extends Cubit<UpdateEventState> {
  final UpdateEvent updateEventUseCase;

  UpdateEventCubit({required this.updateEventUseCase})
    : super(UpdateEventInitial());

  Future<void> submitUpdateEvent({
    required EventEntity eventData,
    required Map<String, dynamic> newEventData,
  }) async {
    // Debug
    print('Data yang diterima untuk update: $eventData');
    emit(UpdateEventLoading());
    try {
      final now = DateTime.now();
      final event = EventEntity(
        id: eventData.id,
        creatorId: eventData.creatorId,
        title: newEventData['title'],
        description: newEventData['description'],
        dateTime: newEventData['dateTime'],
        location: LocationEntity(
          latitude: newEventData['latitude'],
          longitude: newEventData['longitude'],
          address: newEventData['location_address'],
        ),
        createdAt: eventData.createdAt,
        updatedAt: now,
        capacity: newEventData['capacity'],
        category: newEventData['category'],
        imageUrl: newEventData['imageUrl'],
      );

      final failureOrSuccess = await updateEventUseCase(event);
      failureOrSuccess.fold(
        (failure) => emit(UpdateEventError(failure.message)),
        (_) => emit(UpdateEventSuccess()),
      );
    } catch (e) {
      emit(UpdateEventError(e.toString()));
    }
  }
}
