import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PolirideMapScreen extends StatefulWidget {
  const PolirideMapScreen({Key? key}) : super(key: key);

  @override
  State<PolirideMapScreen> createState() => _PolirideMapScreenState();
}

class _PolirideMapScreenState extends State<PolirideMapScreen> {
  // Titik tengah kawasan Polinela, Bandar Lampung
  static const LatLng _polinelaCenter = LatLng(-5.3578, 105.2335);

  // Batas kotak area operasional (Polinela & sekitar Rajabasa)
  static final LatLngBounds _polinelaBounds = LatLngBounds(
    const LatLng(-5.3660, 105.2250), // Sudut Barat Daya (Kiri Bawah)
    const LatLng(-5.3490, 105.2420), // Sudut Timur Laut (Kanan Atas)
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Peta Poliride',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // 1. Komponen Utama OpenStreetMap
          FlutterMap(
            options: MapOptions(
              initialCenter: _polinelaCenter,
              initialZoom: 16.5,
              minZoom: 15.0,
              maxZoom: 19.0,
              // Mengunci area peta agar tetap di sekitar kampus
              cameraConstraint: CameraConstraint.contain(
                bounds: _polinelaBounds,
              ),
            ),
            children: [
              // Lapisan visual gambar peta dari OpenStreetMap
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.poliride.app',
              ),
              // Marker atau Pin di tengah kampus Polinela
              MarkerLayer(
                markers: [
                  Marker(
                    point: _polinelaCenter,
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_pin,
                      size: 45,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 2. Widget Tambahan di Atas Peta (Contoh: Panel Informasi Area)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Area Aktif: Kampus Polinela & Sekitar Rajabasa',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}