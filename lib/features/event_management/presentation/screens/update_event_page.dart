import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_kita_app/features/event_management/presentation/bloc/update_event/update_event_cubit.dart';
import 'package:event_kita_app/features/event_management/presentation/bloc/my_events_list/my_events_list_cubit.dart';
import 'package:event_kita_app/features/event_management/presentation/widgets/event_form.dart';

import '../../domain/entities/event_entity.dart';

class UpdateEventPage extends StatelessWidget {
  final EventEntity event;
  const UpdateEventPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateEventCubit, UpdateEventState>(
      listener: (context, state) {
        if (state is UpdateEventSuccess) {
          context.read<MyEventsListCubit>().fetchMyEvents();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Acara berhasil diperbarui!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is UpdateEventError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Acara')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: EventForm(
            initialEvent: event,
            onSubmit: (newEventData) {
              context.read<UpdateEventCubit>().submitUpdateEvent(
                eventData: event,
                newEventData: newEventData,
              );
            },
          ),
        ),
      ),
    );
  }
}
