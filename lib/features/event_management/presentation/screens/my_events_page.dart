import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_event_page.dart';
import 'package:event_kita_app/features/event_management/presentation/bloc/my_events_list/my_events_list_cubit.dart';
import 'package:event_kita_app/features/event_management/presentation/widgets/my_event_card.dart';

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acara Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateEventPage()),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<MyEventsListCubit, MyEventsListState>(
        listener: (context, state) {
          if (state is MyEventsListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MyEventsListLoading || state is MyEventsListInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MyEventsListLoaded) {
            if (state.events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Kamu belum membuat acara apapun.'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed:
                          () =>
                              context.read<MyEventsListCubit>().fetchMyEvents(),
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<MyEventsListCubit>().fetchMyEvents();
              },
              child: ListView.builder(
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  final event = state.events[index];
                  return MyEventCard(event: event);
                },
              ),
            );
          }
          return const Center(child: Text('Silahkan refresh halaman.'));
        },
      ),
    );
  }
}
