import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../assets/components/event_card.dart';
import '../services/firestore_events.dart';

final FirestoreEvents firestoreEvents = FirestoreEvents();

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F1FF),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Event',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FutureBuilder(
                future: firestoreEvents.getEvents(),
                builder: (context, eventsSnapshot) {
                  if (eventsSnapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (eventsSnapshot.hasError) {
                    return Center(child: Text("Error: ${eventsSnapshot.error}"));
                  }
                  final events = eventsSnapshot.data ?? [];
                  if (events.isEmpty) {
                    return const Center(child: Text("No events found."));
                  }
                  final filteredEvents = events.where((event) {
                    final title = event['title']!.toLowerCase();
                    final description = event['description']!.toLowerCase();
                    return title.contains(searchQuery.toLowerCase()) ||
                        description.contains(searchQuery.toLowerCase());
                  }).toList();
                  return Column(
                    children: filteredEvents.map<Widget>((event) {
                      return EventCard(
                        event: event,
                        user: user,
                        onDaftar: (user) {
                          if (user != null) {
                            print('User ${user.email} registered for ${event['title']}');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please log in to register')),
                            );
                          }
                        },
                      );
                    }).toList(),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
