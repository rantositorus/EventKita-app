import 'package:event_kita_app/features/event_management/presentation/bloc/create_event/create_event_cubit.dart';
import 'package:event_kita_app/features/event_management/presentation/screens/map_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:event_kita_app/features/event_management/domain/entities/event_entity.dart';

typedef EventFormSubmitCallback = void Function(Map<String, dynamic> eventData);

class EventForm extends StatefulWidget {
  final EventEntity? initialEvent;
  final EventFormSubmitCallback onSubmit;

  const EventForm({super.key, this.initialEvent, required this.onSubmit});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationAddressController;
  DateTime? _selectedDateTime;
  LatLng? _selectedLatLng;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialEvent?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialEvent?.description ?? '',
    );
    _locationAddressController = TextEditingController(
      text: widget.initialEvent?.location.address ?? '',
    );
    _selectedDateTime = widget.initialEvent?.dateTime;

    if (widget.initialEvent != null) {
      _selectedLatLng = LatLng(
        widget.initialEvent!.location.latitude,
        widget.initialEvent!.location.longitude,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationAddressController.dispose();
    super.dispose();
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.push<LocationResult>(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerPage()),
    );

    if (result != null) {
      setState(() {
        _selectedLatLng = result.latLng;
        _locationAddressController.text = result.address;
      });
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
    );

    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap pilih tanggal dan waktu acara.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (_selectedLatLng == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap pilih lokasi dari peta.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final eventData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'dateTime': _selectedDateTime!,
        'location_address': _locationAddressController.text,
        'latitude': _selectedLatLng!.latitude,
        'longitude': _selectedLatLng!.longitude,
      };
      widget.onSubmit(eventData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Nama Acara',
              border: OutlineInputBorder(),
            ),
            validator:
                (value) =>
                    (value == null || value.isEmpty)
                        ? 'Nama acara tidak boleh kosong.'
                        : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Deskripsi Acara',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            validator:
                (value) =>
                    (value == null || value.isEmpty)
                        ? 'Deskripsi acara tidak boleh kosong.'
                        : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _locationAddressController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Alamat Lokasi',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.map_outlined),
                onPressed: _openMapPicker,
              ),
            ),
            validator:
                (value) =>
                    (value == null || value.isEmpty)
                        ? 'Alamat lokasi tidak boleh kosong.'
                        : null,
            onTap: _openMapPicker,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedDateTime == null
                        ? 'Pilih Tanggal & Waktu'
                        : DateFormat(
                          'dd MMM yy, HH:mm',
                          'id_ID',
                        ).format(_selectedDateTime!),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectDateTime(context),
                  child: const Text('PILIH'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          BlocBuilder<CreateEventCubit, CreateEventState>(
            builder: (context, state) {
              if (state is CreateEventLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: _submitForm,
                child: Text(
                  widget.initialEvent == null
                      ? 'Buat Acara'
                      : 'Simpan Perubahan',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
