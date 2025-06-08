import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../assets/components/event_card.dart';
import '../services/firestore_profile.dart';

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
            onPressed: () {
              Navigator.of(context).pop();
            },
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

  void _handleDaftar(User? user) {
    if (user == null) {
      _showLoginDialog();
    } else {
      // Navigator.pushNamed(context, 'rsvp_event');
    }
  }

  final List<Map<String, String>> events = const [
    {
      'title': 'Title',
      'description': 'Description duis aute irure dolor in reprehenderit in voluptate velit.',
      'location': 'Hotel ABC',
      'date': '10 November 2025',
    },
    {
      'title': 'Title',
      'description': 'Description duis aute irure dolor in reprehenderit in voluptate velit.',
      'location': 'Hotel ABC',
      'date': '10 November 2025',
    },
    {
      'title': 'Title',
      'description': 'Description duis aute irure dolor in reprehenderit in voluptate velit.',
      'location': 'Hotel ABC',
      'date': '10 November 2025',
    },
    {
      'title': 'Title',
      'description': 'Description duis aute irure dolor in reprehenderit in voluptate velit.',
      'location': 'Hotel ABC',
      'date': '10 November 2025',
    },
  ];

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
              future: user != null ? firestoreProfile.getName(user.uid) : Future.value(''),
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
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          child: Column(
                            children: [
                              const Text(
                                'Buat Acaramu Sendiri!',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                                child: const Text('Buat Acara', style: TextStyle(color: Colors.white),),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Event',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Highlighted Events',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ...events.map((event) => EventCard(
                            event: event,
                            user: user,
                            onDaftar: _handleDaftar,
                          )),
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
