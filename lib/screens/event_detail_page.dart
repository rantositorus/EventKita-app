import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../assets/components/map_preview.dart';
import '../services/firestore_rsvp.dart';
import '../screens/rsvp_event.dart';

final FirestoreRsvpService _rsvpService = FirestoreRsvpService();

class EventDetailPage extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailPage({super.key, required this.event});

  String _formatEventDateTime(dynamic dateTimeValue) {
    try {
      DateTime dateTime;

      if (dateTimeValue is Timestamp) {
        dateTime = dateTimeValue.toDate();
      } else if (dateTimeValue is String) {
        dateTime = DateTime.parse(dateTimeValue);
      } else {
        return 'Unknown date';
      }

      return DateFormat('EEEE, d MMMM yyyy • h:mm a').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F1FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          event['title'] ?? 'Event Detail',
          style: const TextStyle(color: Colors.black),
        ),
        actions: const [
          Icon(Icons.bookmark_border, color: Colors.black),
          SizedBox(width: 12),
          Icon(Icons.more_vert, color: Colors.black),
          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: event['imageUrl'] != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  event['imageUrl'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
                  : const Icon(Icons.image, size: 48),
            ),

            const SizedBox(height: 16),

            Text(
              event['title'] ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            if (event['dateTime'] != null)
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    _formatEventDateTime(event['dateTime']),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),

            const SizedBox(height: 8),

            FutureBuilder<int>(
              future: _rsvpService.getTotalRsvpCount(event['id']),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('Loading RSVP...');
                }

                final total = snapshot.data!;
                final capacity = event['capacity'] ?? 0;

                return Row(
                  children: [
                    const Icon(Icons.people_outline, size: 18),
                    const SizedBox(width: 4),
                    Text('$total / $capacity'),
                  ],
                );
              },
            ),

            const SizedBox(height: 12),

            Text(
              event['description'] ?? '',
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 16),

            const Text('Lokasi :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(event['location']?['address'] ?? 'No address'),

            const SizedBox(height: 12),

            if (event['location']?['latitude'] != null &&
                event['location']?['longitude'] != null)
              MapPreview(
                latitude: event['location']['latitude'],
                longitude: event['location']['longitude'],
              ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please login to RSVP for this event'),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RsvpEventPage(
                          eventId: event['id'] ?? '',
                          eventTitle: event['title'] ?? 'Untitled Event',
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('RSVP',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
