import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationResult {
  final LatLng latLng;
  final String address;

  LocationResult({required this.latLng, required this.address});
}

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  final String _mapTilerApiKey = "iFD3zozklog7ywbo97Ln";

  final LatLng _initialPosition = LatLng(37.7749, -122.4194); // San Francisco
  LatLng? _selectedPosition;
  String _selectedAddress = "Geser peta dan ketuk untuk memilih lokasi";
  bool _isLoadingAddress = false;

  void _onMapTapped(TapPosition tapPosition, LatLng position) {
    setState(() {
      _selectedPosition = position;
      _selectedAddress = "Memuat alamat...";
      _isLoadingAddress = true;
    });
    _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}',
    );
    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'com.example.eventKita_app'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _selectedAddress = data['display_name'] ?? 'Alamat tidak ditemukan.';
        });
      } else {
        setState(() {
          _selectedAddress = 'Gagal mendapatkan alamat.';
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = 'Error: Gagal terhubung.';
      });
    } finally {
      setState(() {
        _isLoadingAddress = false;
      });
    }
  }

  void _confirmSelection() {
    if (_selectedPosition != null && !_isLoadingAddress) {
      final result = LocationResult(
        latLng: _selectedPosition!,
        address: _selectedAddress,
      );
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi Acara'),
        actions: [
          if (_selectedPosition != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _confirmSelection,
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _initialPosition,
          initialZoom: 12,
          onTap: _onMapTapped,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=$_mapTilerApiKey',
            userAgentPackageName: 'com.example.eventkita_app',
          ),
          if (_selectedPosition != null)
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: _selectedPosition!,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _confirmSelection,
        backgroundColor:
            _selectedPosition != null
                ? Theme.of(context).primaryColor
                : Colors.grey,
        child:
            _isLoadingAddress
                ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
                : const Icon(Icons.check),
      ),
    );
  }
}
