import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_kita_app/features/event_management/presentation/bloc/create_event/create_event_cubit.dart';
import 'package:event_kita_app/features/event_management/presentation/bloc/my_events_list/my_events_list_cubit.dart';
import 'package:event_kita_app/features/event_management/presentation/widgets/event_form.dart';

class CreateEventPage extends StatelessWidget {
  const CreateEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateEventCubit, CreateEventState>(
      listener: (context, state) {
        if (state is CreateEventSuccess) {
          context.read<MyEventsListCubit>().fetchMyEvents();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Acara berhasil dibuat!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is CreateEventError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Buat Acara Baru')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: EventForm(
            onSubmit: (eventData) {
              context.read<CreateEventCubit>().submitCreateEvent(eventData);
            },
          ),
        ),
      ),
    );
  }
}
