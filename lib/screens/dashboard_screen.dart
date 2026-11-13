import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/ride_model.dart';
import '../models/user_model.dart';
import '../services/ride_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/poliride_brand.dart';
import 'aktivitas_screen.dart';
import 'profil_screen.dart';
import 'location_picker_screen.dart';
import 'login_screen.dart';
import 'map_screen.dart';

class DashboardScreen extends StatefulWidget {
  final UserModel? user;

  const DashboardScreen({super.key, this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late UserModel currentUser;
  int _currentNavIndex = 0;

  String _selectedPickupSpot = 'Gedung SFS';
  final String _selectedDestinationSpot = 'Gerbang Depan';
  bool _hasActiveOrder = true;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user ??
        UserModel(
          id: 'USR-2024-001',
          npm: '2341720001',
          name: 'Gorbon',
          email: 'gorbon@polinema.ac.id',
          major: 'Teknologi Informasi / D-IV TI',
          balance: 0.0,
          points: 1250,
          tier: 'Gold',
        );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Keluar'),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun mahasiswa POLIRIDE?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _openLocationPicker() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          initialSpot: _selectedPickupSpot,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _selectedPickupSpot = result;
      });
      _showBookingSheet(pickup: result, destination: _selectedDestinationSpot);
    }
  }

  void _showBookingSheet({required String pickup, required String destination}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.two_wheeler_rounded, color: Color(0xFF0284C7)),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pesan PoliRide Motor',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Tarif Flat Mahasiswa Seluruh Kampus',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.radio_button_checked, size: 18, color: Color(0xFF16A34A)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Jemput: $pickup',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 14,
                          child: VerticalDivider(color: Color(0xFFCBD5E1), thickness: 1.5),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 18, color: Color(0xFFEF4444)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Tujuan: $destination',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tarif Flat PoliRide',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF166534)),
                    ),
                    Text(
                      'Rp 3.000',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF15803D),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Konfirmasi Pesanan Ojek',
                icon: Icons.two_wheeler_rounded,
                backgroundColor: const Color(0xFF0284C7),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _hasActiveOrder = true;
                    _currentNavIndex = 1;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pesanan berhasil dibuat! Driver sedang menuju titik jemput.'),
                      backgroundColor: Color(0xFF0284C7),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCancelOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Batalkan Pesanan?'),
        content: const Text(
          'Pembatalan sebelum driver tiba bebas penalti.',
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
                  content: Text('Pesanan berhasil dibatalkan.'),
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

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('SOS Darurat Kampus'),
          ],
        ),
        content: const Text(
          'Menghubungi Posko Keamanan & Satpam Politeknik Negeri Lampung.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Panggilan darurat terhubung ke Posko Satpam.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Panggil Satpam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const PolirideBrand(fontSize: 19),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none_rounded, color: Color(0xFF0F172A), size: 24),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tidak ada notifikasi baru.')),
              );
            },
          ),
          InkWell(
            onTap: () {
              setState(() => _currentNavIndex = 2);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.only(right: 14, left: 4),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0284C7),
                border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
              ),
              child: const Center(
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          _buildHomeScreen(),
          AktivitasScreen(
            user: currentUser,
            onReorder: (pickup, destination) => _showBookingSheet(pickup: pickup, destination: destination),
            onBackToHome: () => setState(() => _currentNavIndex = 0),
          ),
          ProfilScreen(
            user: currentUser,
            onLogout: _handleLogout,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
        selectedItemColor: const Color(0xFF0284C7),
        unselectedItemColor: const Color(0xFF94A3B8),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Aktivitas'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, ${currentUser.name} 👋',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'NIM: ${currentUser.npm} • ${currentUser.major}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
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
                child: const Text(
                  '🟢 AKTIF',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF15803D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _openLocationPicker,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.location_on, color: Color(0xFF0284C7), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedPickupSpot,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Mau pergi ke mana hari ini?',
                          style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.search, color: Color(0xFF0284C7), size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Layanan Tersedia
          const Text(
            'Layanan Tersedia',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _showBookingSheet(pickup: _selectedPickupSpot, destination: _selectedDestinationSpot),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBAE6FD)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE0F2FE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.two_wheeler_rounded, color: Color(0xFF0284C7), size: 24),
                        ),
                        const SizedBox(height: 8),
                        const Text('PoliRide Motor', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        const Text('Tarif Flat: Rp 3.000', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFEDD5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lunch_dining_rounded, color: Color(0xFFEA580C), size: 24),
                      ),
                      const SizedBox(height: 8),
                      const Text('PoliFood', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      const Text('Segera Hadir', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFC2410C))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Peta Interaktif OpenStreetMap di Beranda
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Peta Kampus Polinela',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
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
          const SizedBox(height: 10),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: const LatLng(-5.3578, 105.2335), // Polinela
                      initialZoom: 16.0,
                      minZoom: 14.0,
                      maxZoom: 18.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.poliride.app',
                      ),
                      const MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(-5.3578, 105.2335),
                            width: 80,
                            height: 80,
                            child: Icon(
                              Icons.location_pin,
                              size: 40,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Zona Ramai Saat Ini
          const Text(
            'Zona Ramai Saat Ini',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.local_fire_department, color: Colors.orange, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Area Gedung GFS & GSG Polinela',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Banyak driver siaga di titik ini (Jam Pulang Kuliah).',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Banner Promo Kuliah Pagi (Cokelat)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFB45309), // Warna cokelat tema promo
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'PROMO KULIAH PAGI',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Icon(Icons.alarm, color: Colors.white, size: 24),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Diskon 30% Naik PoliRide',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Berlaku pukul 06.00 - 07.00 WIB untuk seluruh mahasiswa Polinela.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('KODE KUPON: ', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'RAJINAPEL',
                            style: TextStyle(color: Color(0xFFB45309), fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFB45309),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Kupon RAJINAPEL berhasil digunakan!')),
                        );
                      },
                      child: const Text('Pakai Kupon', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // PoliRide Safe & Helpline Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.security, color: Color(0xFF0284C7), size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PoliRide Safe & Helpline',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Admin PoliRIDE',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0284C7)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _showEmergencyDialog,
                  child: const Text('Bantuan', style: TextStyle(fontSize: 12, color: Color(0xFF0284C7))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}