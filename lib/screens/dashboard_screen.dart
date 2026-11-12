import 'package:flutter/material.dart';
import '../models/ride_model.dart';
import '../models/user_model.dart';
import '../services/ride_service.dart';
import '../widgets/campus_map_placeholder.dart';
import '../widgets/custom_button.dart';
import '../widgets/poliride_brand.dart';
import 'location_picker_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  final UserModel? user;

  const DashboardScreen({super.key, this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late UserModel currentUser;
  int _currentNavIndex = 0;

  // Active Spot & Order state
  String _selectedPickupSpot = 'Gedung GFS';
  final String _selectedDestinationSpot = 'Gerbang Depan';
  bool _hasActiveOrder = true;
  int _activityFilterIndex = 0; // 0: Dalam Proses, 1: Selesai, 2: Dibatalkan
  int _categoryFilterIndex = 0; // 0: Semua, 1: PoliRide, 2: PoliFood
  bool _showDriverMapInActivity = false;

  // Settings state in Profile
  bool _allowAutoLocation = true;
  bool _useDefaultBalance = true;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user ??
        UserModel(
          id: 'USR-2024-001',
          npm: '22753012',
          name: 'Garbon',
          email: 'garbon@student.polinela.ac.id',
          major: 'Teknologi Informasi / Teknologi Rekayasa Perangkat Lunak',
          balance: 25750.0,
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

              // Rute Box
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

              // Tarif Info
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
                    _activityFilterIndex = 0;
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

  void _showTopUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF0284C7)),
            SizedBox(width: 8),
            Text('Isi Saldo PoliRIDE'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih nominal top up cepat melalui Virtual Account atau Kasir Kampus:',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [10000, 20000, 50000].map((amt) {
                return OutlinedButton(
                  onPressed: () {
                    setState(() {
                      currentUser = currentUser.copyWith(
                        balance: currentUser.balance + amt,
                      );
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Berhasil menambah saldo Rp $amt!'),
                        backgroundColor: const Color(0xFF16A34A),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0284C7)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Rp $amt'),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showCancelOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Batalkan Pesanan?'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ketentuan Pembatalan POLIRIDE:\n'
              '• Pembatalan sebelum driver tiba bebas penalti.\n'
              '• Pembatalan berulang setelah driver tiba dapat menurunkan reputasi akun mahasiswa Anda.',
              style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
            ),
          ],
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
                _activityFilterIndex = 2; // Jump to Dibatalkan tab
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pesanan berhasil dibatalkan. Saldo tidak terpotong.'),
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
          'Menghubungi Posko Keamanan & Satpam Politeknik Negeri Bengkalis / Polineks.\n'
          'Lokasi koordinat Anda akan dibagikan ke petugas piket kampus.',
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
                  content: Text('Panggilan darurat terhubung ke Posko Satpam 24 Jam.'),
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

      // App Bar Header (Matching Figma)
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const PolirideBrand(fontSize: 19),
        actions: [
          // Wallet Balance Pill with + button
          InkWell(
            onTap: _showTopUpDialog,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 15,
                    color: Color(0xFF0284C7),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Rp ${currentUser.balance.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0369A1),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0284C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),

          // Bell Icon with unread dot
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF0F172A), size: 24),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tidak ada notifikasi baru hari ini.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              Positioned(
                right: 12,
                top: 12,
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
          const SizedBox(width: 8),
        ],
      ),

      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          _buildHomeScreen(),
          _buildActivityScreen(),
          _buildAccountScreen(),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
        selectedItemColor: const Color(0xFF0284C7),
        unselectedItemColor: const Color(0xFF94A3B8),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Aktivitas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Akun',
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SCREEN 4: BERANDA (CUSTOMER HOME)
  // ==========================================
  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Row
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
                    'NIM: ${currentUser.npm} • Mahasiswa TRPL',
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
                child: const Row(
                  children: [
                    Text(
                      '🟢 AKTIF',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF15803D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search Destination / Route Quick Selector
          InkWell(
            onTap: _openLocationPicker,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(14),
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
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0284C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.search, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Section: Rute Favorit Anda
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rute Favorit Anda',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              InkWell(
                onTap: _openLocationPicker,
                child: const Text(
                  'Atur Rute',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.directions_bike, size: 16, color: Color(0xFF0284C7)),
                          SizedBox(width: 6),
                          Text(
                            'Gerbang Samping ➔ Gedung GFS',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Est. 5-7 min • Flat Rp 3.000',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _showBookingSheet(
                    pickup: 'Gerbang Samping',
                    destination: 'Gedung GFS',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Text('Pesan Lagi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: Layanan Tersedia
          const Text(
            'Layanan Tersedia',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              // PoliRide Motor
              Expanded(
                child: InkWell(
                  onTap: () => _showBookingSheet(
                    pickup: _selectedPickupSpot,
                    destination: _selectedDestinationSpot,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBAE6FD)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0284C7).withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
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
                          child: const Icon(Icons.two_wheeler_rounded, color: Color(0xFF0284C7), size: 26),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'PoliRide Motor',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Cepat, aman, hemat keliling kampus',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Tarif Flat: Rp 3.000',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF15803D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // PoliFood
              Expanded(
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Menu PoliFood Kampus: Nasi Ayam Geprek, Jus Buah, Es Teh Jumbo.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFED7AA)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
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
                          child: const Icon(Icons.lunch_dining_rounded, color: Color(0xFFEA580C), size: 26),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'PoliFood',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Pesan makan & minuman ke gedung',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEDD5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Banyak Promo',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC2410C),
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
          const SizedBox(height: 18),

          // Campus Announcement Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Color(0xFF2563EB), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Info Terkini: Penyesuaian rute di sekitar Gedung Kuliah Bersama (GKB) dikarenakan perbaikan jalan kampus.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Section: Gedung Kampus Terpopuler
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gedung Kampus Terpopuler',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              InkWell(
                onTap: _openLocationPicker,
                child: const Text(
                  'Semua Gedung',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // List of popular buildings matching Figma
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
              itemBuilder: (context, index) {
                final spot = RideService.campusSpots[index];
                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    dense: true,
                    leading: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF0284C7)),
                    ),
                    title: Text(
                      spot.name,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    subtitle: Text(
                      '${spot.distance} dari posisi Anda',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Rp 3.000',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                          onPressed: () => _showBookingSheet(
                            pickup: _selectedPickupSpot,
                            destination: spot.name,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 22),

          // Section: Zona Ramai Saat Ini (Live Campus Map Preview)
          const Text(
            'Zona Ramai Saat Ini',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),

          CampusMapPlaceholder(
            height: 190,
            selectedLocation: _selectedPickupSpot,
            showDriver: true,
            showTrafficOverlay: true,
            badgeText: '35 Driver Siaga di Kampus',
            subLabel: 'Zona Rawan Macet Polineks (Jam Pulang Kuliah)',
            onOrderTap: _openLocationPicker,
          ),
          const SizedBox(height: 20),

          // Promo Banner (Diskon 30% Naik PoliRide)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFB45309), Color(0xFFD97706)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB45309).withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Promo Spesial Mahasiswa',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Diskon 30% Naik PoliRide',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Gunakan voucher: POLIPEL',
                        style: TextStyle(fontSize: 12, color: Color(0xFFFEF3C7)),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Voucher POLIPEL berhasil disalin! Otomatis terpasang di pemesanan berikutnya.'),
                        backgroundColor: Color(0xFFB45309),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFB45309),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Text('Pakai Kupon', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Safe & Helpline Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
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
                  child: const Icon(Icons.shield_outlined, color: Color(0xFF0284C7), size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PoliRide Safe & Helpline',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        'Perjalanan aman dipantau pos satpam kampus',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: _showEmergencyDialog,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                    side: const BorderSide(color: Color(0xFF0284C7)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Bantuan', style: TextStyle(fontSize: 11, color: Color(0xFF0284C7))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ==========================================
  // SCREEN 5, 6, 7: AKTIVITAS (ACTIVITY TABS)
  // ==========================================
  Widget _buildActivityScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AKTIVITAS PESANAN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    currentUser.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Saldo Rp ${currentUser.balance.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filter Segmented Chips (Dalam Proses / Selesai / Dibatalkan)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSegmentChip(
                  label: _hasActiveOrder ? 'Dalam Proses (1)' : 'Dalam Proses (0)',
                  isSelected: _activityFilterIndex == 0,
                  onTap: () => setState(() => _activityFilterIndex = 0),
                ),
                const SizedBox(width: 8),
                _buildSegmentChip(
                  label: 'Selesai (11)',
                  isSelected: _activityFilterIndex == 1,
                  onTap: () => setState(() => _activityFilterIndex = 1),
                ),
                const SizedBox(width: 8),
                _buildSegmentChip(
                  label: 'Dibatalkan (1)',
                  isSelected: _activityFilterIndex == 2,
                  onTap: () => setState(() => _activityFilterIndex = 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // VIEW 1: Dalam Proses (Screens 5 & 7)
          if (_activityFilterIndex == 0) ...[
            if (_hasActiveOrder) ...[
              // Ongoing Active Order Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0284C7).withOpacity(0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge & Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.directions_bike_rounded, size: 14, color: Color(0xFF0284C7)),
                              SizedBox(width: 6),
                              Text(
                                'MENJEMPUT',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0284C7),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'Rp 3.000',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Driver Row
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE0F2FE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_rounded, color: Color(0xFF0284C7), size: 26),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Badaruddin',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Icon(Icons.star_rounded, size: 16, color: Color(0xFFEAB308)),
                                  Text(
                                    '4.9',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Honda Beat • BK 1902 AB',
                                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        // Call & Chat buttons
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Menghubungi telepon driver Badaruddin...')),
                            );
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                              color: Color(0xFFDCFCE7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.call, size: 16, color: Color(0xFF15803D)),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Membuka chat PoliRIDE dengan driver Badaruddin...')),
                            );
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE0F2FE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Color(0xFF0284C7)),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),

                    // Route Points
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Column(
                          children: [
                            Icon(Icons.circle, size: 12, color: Color(0xFF16A34A)),
                            SizedBox(
                              height: 22,
                              child: VerticalDivider(thickness: 1.5, color: Color(0xFFCBD5E1)),
                            ),
                            Icon(Icons.location_on, size: 14, color: Color(0xFFEF4444)),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Titik Jemput: $_selectedPickupSpot',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Titik Antar: Lobby Gedung Rektorat',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Estimation note
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF0284C7)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Driver sedang menuju titik penjemputan. Estimasi tiba dalam 3 menit.',
                              style: TextStyle(fontSize: 11, color: Color(0xFF475569)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: _showDriverMapInActivity ? 'Tutup Peta' : 'Lihat Posisi Driver di Peta',
                            height: 44,
                            icon: Icons.map_outlined,
                            backgroundColor: const Color(0xFF0284C7),
                            onPressed: () {
                              setState(() {
                                _showDriverMapInActivity = !_showDriverMapInActivity;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: _showCancelOrderDialog,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFEF4444)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                          ),
                          child: const Text('Batalkan', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),

                    if (_showDriverMapInActivity) ...[
                      const SizedBox(height: 14),
                      CampusMapPlaceholder(
                        height: 180,
                        selectedLocation: _selectedPickupSpot,
                        showDriver: true,
                        showTrafficOverlay: true,
                        badgeText: 'Driver 150m dari titik jemput',
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Pengemudi PoliRide Rating 100% card (Screen 7)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified_user_rounded, color: Color(0xFF16A34A), size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pengemudi PoliRide Rating 100%',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF15803D),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Semua driver mitra adalah mahasiswa & staf terverifikasi Politeknik Negeri Bengkalis untuk menjamin keamanan perjalanan.',
                            style: TextStyle(fontSize: 11, color: Color(0xFF166534)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Detail Pembayaran Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Pembayaran',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Metode Pembayaran', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        Text('Saldo PoliRIDE (Non-tunai)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tarif Flat Ojek', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        Text('Rp 3.000', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Diskon Voucher', style: TextStyle(fontSize: 12, color: Color(0xFF16A34A))),
                        Text('-Rp 0', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
                      ],
                    ),
                    const Divider(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Bayar', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        Text(
                          'Rp 3.000',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0284C7)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Ketentuan Pembatalan POLIRIDE Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFED7AA)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.shield_outlined, color: Color(0xFFEA580C), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Ketentuan Pembatalan POLIRIDE',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFC2410C)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Pembatalan gratis jika driver belum bergerak ke titik jemput. Pembatalan setelah driver tiba dapat dikenakan penalti reputasi akun mahasiswa.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF9A3412)),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Menghubungi Pusat Bantuan CS Satpam Kampus 24 Jam...')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFEA580C)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Pusat Bantuan & Komplain CS Satpam',
                        style: TextStyle(fontSize: 11, color: Color(0xFFEA580C), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, size: 48, color: Color(0xFF10B981)),
                    const SizedBox(height: 12),
                    const Text(
                      'Tidak ada pesanan aktif saat ini',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Pesan PoliRide Motor sekarang untuk bepergian di kampus.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _showBookingSheet(
                        pickup: _selectedPickupSpot,
                        destination: 'Gedung GFS',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Pesan Ojek Sekarang'),
                    ),
                  ],
                ),
              ),
            ],
          ]

          // VIEW 2: Selesai (Screen 6)
          else if (_activityFilterIndex == 1) ...[
            // Category filter chips
            Row(
              children: [
                _buildCategoryChip(
                  label: 'Semua (14)',
                  isSelected: _categoryFilterIndex == 0,
                  onTap: () => setState(() => _categoryFilterIndex = 0),
                ),
                const SizedBox(width: 8),
                _buildCategoryChip(
                  label: 'PoliRide Motor (11)',
                  isSelected: _categoryFilterIndex == 1,
                  onTap: () => setState(() => _categoryFilterIndex = 1),
                ),
                const SizedBox(width: 8),
                _buildCategoryChip(
                  label: 'PoliFood (3)',
                  isSelected: _categoryFilterIndex == 2,
                  onTap: () => setState(() => _categoryFilterIndex = 2),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // List of completed orders
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredCompletedOrders().length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = _filteredCompletedOrders()[index];
                final isFood = order.type == RideType.poliFood;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isFood ? Icons.lunch_dining_rounded : Icons.two_wheeler_rounded,
                                size: 18,
                                color: isFood ? const Color(0xFFEA580C) : const Color(0xFF0284C7),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                order.title,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isFood ? const Color(0xFFFFEDD5) : const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Selesai',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isFood ? const Color(0xFFC2410C) : const Color(0xFF15803D),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        order.dateTime,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isFood
                            ? '${order.pickup} • ${order.foodItems}'
                            : '${order.pickup} ➔ ${order.destination}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Driver: ${order.driverName} (${order.vehicleInfo})',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      if (order.review != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 14, color: Color(0xFFEAB308)),
                            const SizedBox(width: 4),
                            Text(
                              order.review!,
                              style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF475569)),
                            ),
                          ],
                        ),
                      ],
                      const Divider(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rp ${order.fare.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (isFood) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Memesan ulang menu PoliFood...')),
                                );
                              } else {
                                _showBookingSheet(
                                  pickup: order.pickup,
                                  destination: order.destination,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0284C7),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: Size.zero,
                            ),
                            child: Text(
                              isFood ? 'Pesan Ulang' : 'Pesan Lagi',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ]

          // VIEW 3: Dibatalkan
          else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: RideService.cancelledOrders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = RideService.cancelledOrders[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order.title,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Dibatalkan',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(order.dateTime, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                      const SizedBox(height: 4),
                      Text(
                        '${order.pickup} ➔ ${order.destination}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        order.review ?? 'Dibatalkan oleh mahasiswa',
                        style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 20),

          // Help / Lost Item Card (Screen 5 & 6)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.help_center_outlined, color: Color(0xFF0284C7), size: 24),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kendala atau Barang Tertinggal?',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        'Hubungi Pos Satpam & CS Kampus 24 Jam',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: _showEmergencyDialog,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0284C7)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('Bantuan', style: TextStyle(fontSize: 11, color: Color(0xFF0284C7))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  List<RideOrder> _filteredCompletedOrders() {
    if (_categoryFilterIndex == 1) {
      return RideService.completedOrders.where((o) => o.type == RideType.poliRide).toList();
    } else if (_categoryFilterIndex == 2) {
      return RideService.completedOrders.where((o) => o.type == RideType.poliFood).toList();
    }
    return RideService.completedOrders;
  }

  Widget _buildSegmentChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0284C7) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF0284C7) : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SCREEN 8: AKUN CUSTOMER (PROFILE)
  // ==========================================
  Widget _buildAccountScreen() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      children: [
        // Profile Card (Garbon)
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            'G',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0284C7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'NIM: ${currentUser.npm} • Angkatan ${currentUser.angkatan}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 6),
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur edit profil mahasiswa.')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0284C7)),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            minimumSize: Size.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text(
                            'Edit Profil',
                            style: TextStyle(fontSize: 10, color: Color(0xFF0284C7), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Stats Row (Saldo / Poin / Tier)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildProfileStat(
                    title: 'Saldo',
                    value: 'Rp ${currentUser.balance.toStringAsFixed(0)}',
                    icon: Icons.account_balance_wallet_outlined,
                    color: const Color(0xFF0284C7),
                  ),
                  Container(height: 32, width: 1, color: const Color(0xFFE2E8F0)),
                  _buildProfileStat(
                    title: 'Poin',
                    value: '★ ${currentUser.points}',
                    icon: Icons.star_border_rounded,
                    color: const Color(0xFFEAB308),
                  ),
                  Container(height: 32, width: 1, color: const Color(0xFFE2E8F0)),
                  _buildProfileStat(
                    title: 'Tier',
                    value: '🥇 ${currentUser.tier}',
                    icon: Icons.workspace_premium_outlined,
                    color: const Color(0xFF10B981),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Section: Identitas Akademik
        const Text(
          'Identitas Akademik',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              _buildInfoRow(
                icon: Icons.school_outlined,
                title: 'Jurusan / Program Studi',
                value: currentUser.major,
              ),
              const Divider(height: 18),
              _buildInfoRow(
                icon: Icons.mail_outline_rounded,
                title: 'Email Kampus',
                value: currentUser.email,
              ),
              const Divider(height: 18),
              _buildInfoRow(
                icon: Icons.phone_outlined,
                title: 'No. WhatsApp',
                value: '${currentUser.phone} (Terverifikasi)',
              ),
              const Divider(height: 18),
              _buildInfoRow(
                icon: Icons.verified_outlined,
                title: 'Status Akun',
                value: '${currentUser.status} (${currentUser.semester})',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Section: Preferensi & Kenyamanan
        const Text(
          'Preferensi & Kenyamanan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('Izin Lokasi Otomatis', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Mendeteksi gedung kampus terdekat', style: TextStyle(fontSize: 11)),
                  value: _allowAutoLocation,
                  activeColor: const Color(0xFF0284C7),
                  onChanged: (val) => setState(() => _allowAutoLocation = val),
                ),
              ),
              const Divider(height: 1),
              Material(
                color: Colors.transparent,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('Metode Bayar Default (Saldo)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Prioritaskan pembayaran non-tunai', style: TextStyle(fontSize: 11)),
                  value: _useDefaultBalance,
                  activeColor: const Color(0xFF0284C7),
                  onChanged: (val) => setState(() => _useDefaultBalance = val),
                ),
              ),
              const Divider(height: 1),
              Material(
                color: Colors.transparent,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('Tema Gelap / Dark Mode', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Tampilan kontras hemat baterai', style: TextStyle(fontSize: 11)),
                  value: _isDarkMode,
                  activeColor: const Color(0xFF0284C7),
                  onChanged: (val) => setState(() => _isDarkMode = val),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Section: Keamanan & Layanan
        const Text(
          'Keamanan & Layanan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),

        // SOS Darurat Card
        InkWell(
          onTap: _showEmergencyDialog,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: const Row(
              children: [
                Icon(Icons.emergency_rounded, color: Color(0xFFDC2626), size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SOS Darurat Kampus',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
                      ),
                      Text(
                        'Hubungi Satpam & Posko Darurat 24 Jam',
                        style: TextStyle(fontSize: 11, color: Color(0xFF991B1B)),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFDC2626)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              _buildActionTile(
                icon: Icons.menu_book_rounded,
                title: 'Panduan Penggunaan POLIRIDE',
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildActionTile(
                icon: Icons.support_agent_rounded,
                title: 'Hubungi Admin PoliRIDE',
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildActionTile(
                icon: Icons.description_outlined,
                title: 'Syarat & Ketentuan Pengguna',
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Logout Button
        OutlinedButton.icon(
          onPressed: _handleLogout,
          icon: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626)),
          label: const Text(
            'Keluar (Akun Mahasiswa)',
            style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: Color(0xFFFECACA), width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 18),

        // Footer App Info
        const Center(
          child: Column(
            children: [
              Text(
                'POLIRIDE Mobile App v2.4 • Politeknik Negeri Bengkalis / Polineks',
                style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              SizedBox(height: 2),
              Text(
                'Karya Inovasi Mahasiswa Jurusan Teknologi Informasi',
                style: TextStyle(fontSize: 10, color: Color(0xFFCBD5E1)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildProfileStat({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF0284C7)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: const Color(0xFF0284C7), size: 20),
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFCBD5E1)),
        onTap: onTap,
      ),
    );
  }
}
