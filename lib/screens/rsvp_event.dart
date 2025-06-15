import 'package:flutter/material.dart';
import '../services/firestore_rsvp.dart';

class RsvpEventPage extends StatefulWidget {
  final String eventId;
  final String eventTitle;
  final bool isEdit;
  final Map<String, dynamic>? existingData;

  const RsvpEventPage({
    super.key,
    required this.eventId,
    required this.eventTitle,
    this.isEdit = false,
    this.existingData,
  });

  @override
  State<RsvpEventPage> createState() => _RsvpEventPageState();
}

class _RsvpEventPageState extends State<RsvpEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  final FirestoreRsvpService rsvpService = FirestoreRsvpService();
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.existingData != null) {
      nameController.text = widget.existingData!['name'] ?? '';
      phoneController.text = widget.existingData!['phone'] ?? '';
      notesController.text = widget.existingData!['notes'] ?? '';
      numberController.text = (widget.existingData!['attending'] ?? 1).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit
              ? 'Edit RSVP for ${widget.eventTitle}'
              : 'RSVP for ${widget.eventTitle}',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: numberController,
                decoration: const InputDecoration(
                    labelText: 'How many people will attend?'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  final number = int.tryParse(value);
                  if (number == null || number < 1) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => isSubmitting = true);

                    try {
                      if (widget.isEdit) {
                        await rsvpService.updateRSVP(
                          eventId: widget.eventId,
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          notes: notesController.text.trim(),
                          attending: int.parse(numberController.text),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('RSVP updated successfully!')),
                        );
                      } else {
                        final existing = await rsvpService
                            .getRsvp(widget.eventId);
                        if (existing != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "You've already RSVPed for this event.")),
                          );
                          setState(() => isSubmitting = false);
                          return;
                        }

                        await rsvpService.createRsvp(
                          eventId: widget.eventId,
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          attending: int.parse(numberController.text),
                          notes: notesController.text.trim(),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                              Text('RSVP submitted successfully!')),
                        );
                      }

                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    } finally {
                      setState(() => isSubmitting = false);
                    }
                  }
                },
                child: Text(widget.isEdit ? 'Update RSVP' : 'Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
