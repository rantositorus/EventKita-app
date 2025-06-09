part of 'create_event_cubit.dart';

abstract class CreateEventState extends Equatable {
  const CreateEventState();

  @override
  List<Object> get props => [];
}

class CreateEventInitial extends CreateEventState {}

class CreateEventLoading extends CreateEventState {}

class CreateEventSuccess extends CreateEventState {}

class CreateEventError extends CreateEventState {
  final String message;

  const CreateEventError(this.message);

  @override
  List<Object> get props => [message];
}
