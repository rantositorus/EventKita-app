part of 'update_event_cubit.dart';

abstract class UpdateEventState extends Equatable {
  const UpdateEventState();

  @override
  List<Object> get props => [];
}

class UpdateEventInitial extends UpdateEventState {}

class UpdateEventLoading extends UpdateEventState {}

class UpdateEventSuccess extends UpdateEventState {}

class UpdateEventError extends UpdateEventState {
  final String message;

  const UpdateEventError(this.message);

  @override
  List<Object> get props => [message];
}
