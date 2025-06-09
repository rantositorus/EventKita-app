import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../assets/components/event_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final List<Map<String, String>> allEvents = const [
    {
      'title': 'Title',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'location': 'Hotel ABC',
      'date': '10 November 2025',
    },
    {
      'title': 'Another Event',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'location': 'Hotel XYZ',
      'date': '15 November 2025',
    },
    {
      'title': 'Test',
      'description': 'Test.',
      'location': 'Test Park',
      'date': '18 November 2025',
    },
  ];

  List<Map<String, String>> get filteredEvents {
    if (searchQuery.isEmpty) return allEvents;
    return allEvents.where((event) {
      final title = event['title']!.toLowerCase();
      final description = event['description']!.toLowerCase();
      return title.contains(searchQuery.toLowerCase()) ||
          description.contains(searchQuery.toLowerCase());
    }).toList();
  }

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
              Column(
                children: filteredEvents.map((event) {
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
