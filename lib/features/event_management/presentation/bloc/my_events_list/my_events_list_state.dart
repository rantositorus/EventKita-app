part of 'my_events_list_cubit.dart';

abstract class MyEventsListState extends Equatable {
  const MyEventsListState();

  @override
  List<Object> get props => [];
}

class MyEventsListInitial extends MyEventsListState {}

class MyEventsListLoading extends MyEventsListState {}

class MyEventsListLoaded extends MyEventsListState {
  final List<EventEntity> events;

  const MyEventsListLoaded(this.events);

  @override
  List<Object> get props => [events];
}

class MyEventsListError extends MyEventsListState {
  final String message;

  const MyEventsListError(this.message);

  @override
  List<Object> get props => [message];
}
