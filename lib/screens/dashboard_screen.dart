import 'package:flutter/material.dart';
import '../models/driver_model.dart';
import '../widgets/poliride_brand.dart';
import 'beranda_screen.dart';
import 'pesanan_screen.dart';
import 'penghasilan_screen.dart';
import 'akun_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  final DriverModel? driver;

  const DashboardScreen({super.key, this.driver});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DriverModel currentDriver;
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    currentDriver = widget.driver ?? const DriverModel();
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Keluar / Istirahat'),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun driver mitra POLIRIDE?',
          style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
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

  void _toggleOnline() {
    setState(() {
      currentDriver = currentDriver.copyWith(isOnline: !currentDriver.isOnline);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(currentDriver.isOnline
            ? 'Mitra ONLINE: Siap menerima pesanan mahasiswa 🟢'
            : 'Mitra OFFLINE: Sedang istirahat ⚪'),
        backgroundColor: currentDriver.isOnline ? const Color(0xFF16A34A) : const Color(0xFF64748B),
        duration: const Duration(seconds: 2),
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
        title: const PolirideBrand(fontSize: 19, badgeText: 'MITRA'),
        actions: [
          // Capsule Badge ONLINE / OFFLINE Driver
          InkWell(
            onTap: _toggleOnline,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: currentDriver.isOnline ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: currentDriver.isOnline ? const Color(0xFF86EFAC) : const Color(0xFFCBD5E1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentDriver.isOnline ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    currentDriver.isOnline ? 'ONLINE' : 'OFFLINE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: currentDriver.isOnline ? const Color(0xFF15803D) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Lonceng Notifikasi
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none_rounded, color: Color(0xFF0F172A), size: 22),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 7,
                    height: 7,
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

          // Avatar Driver di Header (Klik untuk buka Akun)
          InkWell(
            onTap: () {
              setState(() => _currentNavIndex = 3);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.only(right: 14, left: 2),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0284C7),
                border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
              ),
              child: const Center(
                child: Icon(Icons.two_wheeler_rounded, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          BerandaScreen(
            driver: currentDriver,
            onAcceptOrder: () => setState(() => _currentNavIndex = 1),
            onToggleOnline: (v) => setState(() => currentDriver = currentDriver.copyWith(isOnline: v)),
          ),
          PesananScreen(
            driver: currentDriver,
            onTripCompleted: () => setState(() => _currentNavIndex = 2),
            onBackToHome: () => setState(() => _currentNavIndex = 0),
          ),
          PenghasilanScreen(
            driver: currentDriver,
          ),
          AkunScreen(
            driver: currentDriver,
            onDriverUpdated: (updated) => setState(() => currentDriver = updated),
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
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.two_wheeler_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Penghasilan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
