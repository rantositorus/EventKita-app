import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:event_kita_app/features/event_management/domain/entities/event_entity.dart';
import 'package:event_kita_app/features/event_management/domain/usecases/get_my_events.dart';
import 'package:event_kita_app/features/event_management/domain/usecases/delete_event.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'my_events_list_state.dart';

class MyEventsListCubit extends Cubit<MyEventsListState> {
  final GetMyEvents getMyEventsUseCase;
  final DeleteEvent deleteEventUseCase;

  MyEventsListCubit({
    required this.getMyEventsUseCase,
    required this.deleteEventUseCase,
  }) : super(MyEventsListInitial());

  Future<void> fetchMyEvents() async {
    emit(MyEventsListLoading());
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(MyEventsListError("User not authenticated"));
      return;
    }
    final _currentCreatorId = user.uid;
    final failureOrEvents = await getMyEventsUseCase(_currentCreatorId);
    failureOrEvents.fold(
      (failure) => emit(MyEventsListError(failure.message)),
      (events) => emit(MyEventsListLoaded(events)),
    );
  }

  Future<void> removeEvent(String eventId) async {
    final currentState = state;
    if (currentState is MyEventsListLoaded) {
      final updatedList =
          currentState.events.where((e) => e.id != eventId).toList();
      emit(MyEventsListLoaded(updatedList));

      final failureOrSuccess = await deleteEventUseCase(eventId);

      failureOrSuccess.fold((failure) {
        emit(currentState);
        emit(MyEventsListError("Gagal menghapus event: ${failure.message}"));
      }, (_) => {});
    }
  }
}
