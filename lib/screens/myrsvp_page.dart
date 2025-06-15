import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../screens/event_detail_page.dart';
import '../screens/rsvp_event.dart';
import '../services/firestore_rsvp.dart';

class MyRSVPPage extends StatefulWidget {
  const MyRSVPPage({super.key});

  @override
  State<MyRSVPPage> createState() => _MyRsvpPageState();
}

class _MyRsvpPageState extends State<MyRSVPPage> {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  final rsvpService = FirestoreRsvpService();

  late Future<List<Map<String, dynamic>>> _myRsvpFuture;

  @override
  void initState() {
    super.initState();
    _myRsvpFuture = _fetchMyRsvps();
  }

  Future<List<Map<String, dynamic>>> _fetchMyRsvps() async {
    if (user == null) return [];

    final myRsvpSnapshot = await firestore
        .collection('users')
        .doc(user!.uid)
        .collection('my_rsvps')
        .orderBy('rsvpTime', descending: true)
        .get();

    final List<Map<String, dynamic>> myEvents = [];

    for (final doc in myRsvpSnapshot.docs) {
      final eventId = doc.id;
      final eventDoc = await firestore.collection('events').doc(eventId).get();
      if (eventDoc.exists) {
        final eventData = eventDoc.data()!;
        eventData['id'] = eventId;

        final rawDateTime = eventData['dateTime'];
        if (rawDateTime is Timestamp) {
          final dateTime = rawDateTime.toDate();
          eventData['dateTimeString'] = DateFormat('EEE, MMM d • h:mm a').format(dateTime);
        } else if (rawDateTime is String) {
          eventData['dateTimeString'] = rawDateTime;
        } else {
          eventData['dateTimeString'] = '';
        }

        myEvents.add(eventData);
      }
    }

    return myEvents;
  }

  void _deleteRsvp(String eventId) async {
    await rsvpService.deleteRSVP(eventId);
    setState(() {
      _myRsvpFuture = _fetchMyRsvps();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("RSVP deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My RSVPs')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _myRsvpFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final rsvpEvents = snapshot.data ?? [];
          if (rsvpEvents.isEmpty) {
            return const Center(child: Text("You haven't RSVP'd to any event."));
          }

          return ListView.builder(
            itemCount: rsvpEvents.length,
            itemBuilder: (context, index) {
              final event = rsvpEvents[index];

              return ListTile(
                title: Text(event['title'] ?? 'Untitled'),
                subtitle: Text(event['dateTimeString'] ?? ''),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'detail') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EventDetailPage(event: event),
                        ),
                      );
                    } else if (value == 'edit') {
                      final existing = await rsvpService.getRsvp(event['id']);
                      if (existing != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RsvpEventPage(
                              eventId: event['id'],
                              eventTitle: event['title'] ?? '',
                              isEdit: true,
                              existingData: existing,
                            ),
                          ),
                        ).then((_) {
                          setState(() {
                            _myRsvpFuture = _fetchMyRsvps();
                          });
                        });
                      }
                    } else if (value == 'delete') {
                      _deleteRsvp(event['id']);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'detail', child: Text('View Details')),
                    const PopupMenuItem(value: 'edit', child: Text('Edit RSVP')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete RSVP')),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
