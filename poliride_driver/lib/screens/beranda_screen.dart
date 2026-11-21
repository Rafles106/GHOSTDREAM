import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/driver_model.dart';
import 'map_screen.dart';

class BerandaScreen extends StatefulWidget {
  final DriverModel driver;
  final VoidCallback? onAcceptOrder;
  final ValueChanged<bool>? onToggleOnline;

  const BerandaScreen({
    super.key,
    required this.driver,
    this.onAcceptOrder,
    this.onToggleOnline,
  });

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  bool _hasIncomingOrder = false;
  late bool _isOnline;

  // Koordinat simulasi driver di area kampus
  static const LatLng _driverPos = LatLng(-5.3578, 105.2335);

  @override
  void initState() {
    super.initState();
    _isOnline = widget.driver.isOnline;
  }

  @override
  void didUpdateWidget(BerandaScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.driver.isOnline != oldWidget.driver.isOnline) {
      setState(() {
        _isOnline = widget.driver.isOnline;
      });
    }
  }

  void _handleToggleOnline(bool value) {
    setState(() {
      _isOnline = value;
      _hasIncomingOrder = false;
    });
    if (widget.onToggleOnline != null) {
      widget.onToggleOnline!(value);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value
            ? 'Status Mitra Aktif: Siap menerima orderan kampus! 🟢'
            : 'Status Mitra Nonaktif: Istirahat sejenak ⚪'),
        backgroundColor: value ? const Color(0xFF16A34A) : const Color(0xFF64748B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Driver Card (Aktif / Nonaktif Toggle)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isOnline ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _isOnline ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isOnline ? Icons.two_wheeler_rounded : Icons.pause_circle_outline_rounded,
                    color: _isOnline ? const Color(0xFF15803D) : const Color(0xFF64748B),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _isOnline ? '🟢 Aktif' : '⚪ Offline',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: _isOnline ? const Color(0xFF15803D) : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isOnline ? '(Siap Terima Order)' : '(Istirahat)',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Area Siaga: GKB, Rektorat, GSG Kampus',
                        style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isOnline,
                  activeColor: const Color(0xFF16A34A),
                  onChanged: _handleToggleOnline,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Pesanan Baru Masuk Card (Bila Online & ada order)
          if (_isOnline && _hasIncomingOrder) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE0F2FE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.notifications_active_rounded, color: Color(0xFF0284C7), size: 16),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Pesanan Baru Masuk!',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.timer_outlined, size: 12, color: Color(0xFFD97706)),
                            SizedBox(width: 4),
                            Text(
                              '12s',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  // Info Tarif
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PoliRide Motor', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          Text('Tarif Flat Khusus Mahasiswa', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Rp 3.000',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Route Points
                  Row(
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.radio_button_checked, size: 14, color: Color(0xFF16A34A)),
                          Container(width: 2, height: 24, color: const Color(0xFFCBD5E1)),
                          const Icon(Icons.location_on, size: 14, color: Color(0xFFEF4444)),
                        ],
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jemput: Gedung SFS (Depan)',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Antar: Gedung GSG (Pintu Barat)',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tombol Tolak & Terima
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              _hasIncomingOrder = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Pesanan ditolak.')),
                            );
                          },
                          child: const Text('Tolak', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0284C7),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                          label: const Text('Terima Orderan', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                            setState(() {
                              _hasIncomingOrder = false;
                            });
                            if (widget.onAcceptOrder != null) {
                              widget.onAcceptOrder!();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Hotspot Permintaan Kampus (Heatmap / Campus hotspots)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.local_fire_department_rounded, color: Color(0xFFEA580C), size: 20),
                  SizedBox(width: 6),
                  Text(
                    'Hotspot Permintaan Kampus',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Padat 🔥',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFC2410C)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildHotspotItem(
                  title: 'Area Gedung Kuliah Bersama (GKB)',
                  desc: '15+ order/jam • Jam bubar kelas',
                  level: 'Tinggi',
                  levelColor: const Color(0xFFDC2626),
                  levelBg: const Color(0xFFFEE2E2),
                ),
                const Divider(height: 16),
                _buildHotspotItem(
                  title: 'Gedung GSG & Kantin Perikanan',
                  desc: '8+ order/jam • Antrian makan siang',
                  level: 'Sedang',
                  levelColor: const Color(0xFFD97706),
                  levelBg: const Color(0xFFFEF3C7),
                ),
                const Divider(height: 16),
                _buildHotspotItem(
                  title: 'Gerbang Depan & Rektorat',
                  desc: '4+ order/jam • Akses masuk utama',
                  level: 'Normal',
                  levelColor: const Color(0xFF16A34A),
                  levelBg: const Color(0xFFDCFCE7),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Peta Operasional Kampus OpenStreetMap
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Peta Operasional Kampus',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PolirideMapScreen()),
                  );
                },
                child: const Text(
                  'Perbesar Peta →',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: _driverPos,
                      initialZoom: 16.2,
                      minZoom: 14.0,
                      maxZoom: 18.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.poliride.driver',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _driverPos,
                            width: 44,
                            height: 44,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF0284C7),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.two_wheeler, color: Colors.white, size: 24),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.my_location, size: 14, color: Color(0xFF0284C7)),
                          SizedBox(width: 4),
                          Text(
                            'Lokasi Anda: Sekitar Gedung GKB',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHotspotItem({
    required String title,
    required String desc,
    required String level,
    required Color levelColor,
    required Color levelBg,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(height: 2),
              Text(desc, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: levelBg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            level,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: levelColor),
          ),
        ),
      ],
    );
  }
}
