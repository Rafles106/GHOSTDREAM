import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/driver_model.dart';
import 'map_screen.dart';

class PesananScreen extends StatefulWidget {
  final DriverModel driver;
  final VoidCallback? onTripCompleted;
  final VoidCallback? onBackToHome;

  const PesananScreen({
    super.key,
    required this.driver,
    this.onTripCompleted,
    this.onBackToHome,
  });

  @override
  State<PesananScreen> createState() => _PesananScreenState();
}

class _PesananScreenState extends State<PesananScreen> {
  bool _hasActiveOrder = true;

  // Koordinat simulasi rute antar jemput kampus Polinela
  static const LatLng _pickupPos = LatLng(-5.3585, 105.2320); // Gedung SFS
  static const LatLng _driverPos = LatLng(-5.3578, 105.2330); // Posisi Driver
  static const LatLng _destPos = LatLng(-5.3560, 105.2345); // Gedung GSG

  void _showChatMahasiswa() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFE0F2FE),
                    child: const Icon(Icons.person, color: Color(0xFF0284C7)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Daskiva (Mahasiswa)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('NIM: 2341720088 • Gedung SFS', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Hari ini 11:20 WIB', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(maxWidth: 260),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'Halo bang, saya tunggu di depan lobby Gedung SFS ya, pakai ransel hitam.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(maxWidth: 260),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'Siap kak, saya pakai jaket PoliRide dan motor PCX Putih. OTW!',
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Ketik pesan ke penumpang...',
                          hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF0284C7),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pesan terkirim ke mahasiswa.')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCompleteTripDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A)),
            SizedBox(width: 8),
            Text('Selesaikan Antaran?'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pastikan penumpang Daskiva telah tiba dengan selamat di tujuan Gedung GSG.',
              style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
            ),
            SizedBox(height: 12),
            Text(
              'Ongkos Tunai: Rp 3.000',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _hasActiveOrder = false;
              });
              if (widget.onTripCompleted != null) {
                widget.onTripCompleted!();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Antaran Selesai! Ongkos Rp 3.000 diterima secara tunai. Mantap! 🎉'),
                  backgroundColor: Color(0xFF16A34A),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Selesai & Terima Tunai'),
          ),
        ],
      ),
    );
  }

  void _showCancelTripDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Batalkan Antaran?'),
        content: const Text(
          'Pembatalan sepihak oleh driver memerlukan konfirmasi alasan mendesak.',
          style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kembali', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _hasActiveOrder = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Antaran telah dibatalkan.'),
                  backgroundColor: Color(0xFF64748B),
                ),
              );
            },
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasActiveOrder) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.two_wheeler_outlined, size: 54, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tidak Ada Pesanan Berlangsung',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Siaga di area hotspot kampus untuk menerima pesanan mahasiswa baru.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(Icons.home_filled, size: 18),
                label: const Text('Kembali ke Beranda'),
                onPressed: () {
                  if (widget.onBackToHome != null) {
                    widget.onBackToHome!();
                  } else {
                    setState(() {
                      _hasActiveOrder = true;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STATUS ANTARAN',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0284C7), letterSpacing: 0.8),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Pesanan Berlangsung',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.directions_bike, size: 14, color: Color(0xFF15803D)),
                    SizedBox(width: 4),
                    Text(
                      'Menuju Tujuan',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Card Informasi Penumpang & Rute
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Mahasiswa / Pemesan
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: const Color(0xFFBAE6FD), width: 2),
                          ),
                          child: const Center(
                            child: Icon(Icons.person, color: Colors.white, size: 28),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.school, size: 10, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'Daskiva',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.verified, size: 15, color: Color(0xFF0284C7)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Mahasiswa Aktif Polinela • ⭐ 5.0 (28 Trip)',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Rute Penjemputan & Pengantaran
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.radio_button_checked, color: Color(0xFF16A34A), size: 18),
                        Container(width: 2, height: 32, color: const Color(0xFFCBD5E1)),
                        const Icon(Icons.location_on, color: Color(0xFFEF4444), size: 18),
                      ],
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TITIK JEMPUT',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                          ),
                          Text(
                            'Gedung SFS',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          Text(
                            'Depan Lobby Utama Gedung SFS',
                            style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'TUJUAN PENGANTARAN',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
                          ),
                          Text(
                            'Gedung GSG',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          Text(
                            'Pintu Barat Gedung Serbaguna',
                            style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Rincian Tarif
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tarif PoliRide Motor', style: TextStyle(fontSize: 11, color: Color(0xFF166534))),
                          Text('Metode Pembayaran: Tunai', style: TextStyle(fontSize: 10, color: Color(0xFF15803D), fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text(
                        'Rp 3.000',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF15803D)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Tombol Komunikasi: Chat Mahasiswa & WhatsApp
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF0284C7)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Color(0xFF0284C7)),
                        label: const Text('Chat Mahasiswa', style: TextStyle(color: Color(0xFF0284C7), fontSize: 12, fontWeight: FontWeight.bold)),
                        onPressed: _showChatMahasiswa,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF16A34A)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: const Icon(Icons.phone, size: 16, color: Color(0xFF16A34A)),
                        label: const Text('WhatsApp', style: TextStyle(color: Color(0xFF16A34A), fontSize: 12, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Membuka WhatsApp mahasiswa Daskiva (+62 812-3456-7890)...')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Live Route Tracking Mini Map
          Container(
            height: 180,
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
                      initialZoom: 16.3,
                      minZoom: 14.0,
                      maxZoom: 18.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.poliride.driver',
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: const [_pickupPos, _driverPos, _destPos],
                            strokeWidth: 4.5,
                            color: const Color(0xFF0284C7),
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          const Marker(
                            point: _pickupPos,
                            width: 30,
                            height: 30,
                            child: Icon(Icons.location_on, color: Color(0xFF16A34A), size: 28),
                          ),
                          Marker(
                            point: _driverPos,
                            width: 36,
                            height: 36,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF0284C7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.two_wheeler, color: Colors.white, size: 20),
                            ),
                          ),
                          const Marker(
                            point: _destPos,
                            width: 30,
                            height: 30,
                            child: Icon(Icons.location_pin, color: Color(0xFFEF4444), size: 28),
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
                          Icon(Icons.navigation_rounded, size: 14, color: Color(0xFF0284C7)),
                          SizedBox(width: 4),
                          Text('Navigasi Rute Aktif', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tombol Utama: Selesaikan Antaran
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 2,
              ),
              icon: const Icon(Icons.check_circle_rounded, size: 20),
              label: const Text(
                'Selesaikan Antaran',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              onPressed: _showCompleteTripDialog,
            ),
          ),
          const SizedBox(height: 10),

          // Tombol Batalkan Antaran
          Center(
            child: TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: const Color(0xFFDC2626)),
              icon: const Icon(Icons.cancel_outlined, size: 16),
              label: const Text('Batalkan Antaran (Alasan Darurat)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              onPressed: _showCancelTripDialog,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
