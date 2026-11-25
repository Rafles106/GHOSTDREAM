import 'package:flutter/material.dart';
import '../services/ride_service.dart';
import 'akun_screen.dart';
import 'aktivitas_screen.dart';
import 'beranda_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int initialTab;

  const DashboardScreen({super.key, this.initialTab = 0});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _currentIndex;
  final RideService _rideService = RideService();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab.clamp(0, 2);
    _rideService.addListener(_onRideChanged);
  }

  @override
  void dispose() {
    _rideService.removeListener(_onRideChanged);
    super.dispose();
  }

  void _onRideChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveOrder = _rideService.activeOrder != null;

    final pages = [
      BerandaScreen(
        onSelectTab: (index) => setState(() => _currentIndex = index.clamp(0, 2)),
      ),
      const AktivitasScreen(),
      const AkunScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: Colors.white,
          elevation: 0,
          indicatorColor: const Color(0xFFE0F2FE),
          onDestinationSelected: (idx) {
            setState(() => _currentIndex = idx);
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF0284C7)),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: hasActiveOrder,
                label: const Text('1'),
                backgroundColor: const Color(0xFF10B981),
                child: const Icon(Icons.receipt_long_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: hasActiveOrder,
                label: const Text('1'),
                backgroundColor: const Color(0xFF10B981),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Color(0xFF0284C7),
                ),
              ),
              label: 'Aktivitas',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: Color(0xFF0284C7)),
              label: 'Akun',
            ),
          ],
        ),
      ),
    );
  }
}