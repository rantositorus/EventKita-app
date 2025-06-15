import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../assets/components/event_card.dart';
import '../screens/event_detail_page.dart';
import '../screens/myrsvp_page.dart';
import '../services/firestore_profile.dart';
import '../services/firestore_events.dart';

final FirestoreEvents firestoreEvents = FirestoreEvents();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreProfile firestoreProfile = FirestoreProfile();

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Authentication Required'),
        content: const Text('Please login or register to continue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, 'register');
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  void _handleBuatAcara(User? user) {
    if (user == null) {
      _showLoginDialog();
    } else {
      // Navigator.pushNamed(context, 'create_event');
    }
  }

  void _goToMyRSVPs(User? user) {
    if (user == null) {
      _showLoginDialog();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MyRSVPPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F1FF),
          body: SafeArea(
            child: FutureBuilder<String>(
              future: user != null
                  ? firestoreProfile.getName(user.uid)
                  : Future.value(''),
              builder: (context, nameSnapshot) {
                final username = nameSnapshot.data ?? '';

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          user != null
                              ? 'Selamat Datang, $username'
                              : 'Selamat Datang!',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0x556750A4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: Column(
                            children: [
                              const Text(
                                'Quick Start Menu',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => _handleBuatAcara(user),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6750A4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'Buat Acara',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => _goToMyRSVPs(user),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'Lihat RSVP Saya',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Highlighted Events',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      FutureBuilder(
                        future: firestoreEvents.getTop3Events(),
                        builder: (context, eventsSnapshot) {
                          if (eventsSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (eventsSnapshot.hasError) {
                            return Center(
                                child: Text('Error: ${eventsSnapshot.error}'));
                          }
                          final events = eventsSnapshot.data ?? [];
                          if (events.isEmpty) {
                            return const Center(
                                child: Text('No events found.'));
                          }
                          return Column(
                            children: events
                                .map((event) => EventCard(
                              event: event,
                              user: user,
                              onDetails: (ctx, user) {
                                Navigator.push(
                                  ctx,
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        EventDetailPage(event: event),
                                  ),
                                );
                              },
                            ))
                                .toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}