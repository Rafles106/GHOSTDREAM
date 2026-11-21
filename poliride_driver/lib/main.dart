import 'package:flutter/material.dart';
import 'models/driver_model.dart';
import 'screens/akun_screen.dart';
import 'screens/beranda_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/location_picker_screen.dart';
import 'screens/login_screen.dart';
import 'screens/penghasilan_screen.dart';
import 'screens/pesanan_screen.dart';
import 'screens/register_screen.dart';
import 'screens/splash_screen.dart';
import 'widgets/poliride_brand.dart';

void main() {
  runApp(const PolirideApp());
}

class PolirideApp extends StatelessWidget {
  const PolirideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POLIRIDE DRIVER - Portal Pengemudi Mitra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF0284C7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0284C7),
          primary: const Color(0xFF0284C7),
          secondary: const Color(0xFF10B981),
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF0F172A)),
        ),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/location-picker': (context) => const LocationPickerScreen(),
        '/beranda': (context) => Scaffold(
              appBar: AppBar(
                title: const PolirideBrand(fontSize: 19, badgeText: 'MITRA'),
                elevation: 0.5,
              ),
              body: const BerandaScreen(driver: DriverModel()),
            ),
        '/pesanan': (context) => Scaffold(
              appBar: AppBar(
                title: const PolirideBrand(fontSize: 19, badgeText: 'MITRA'),
                elevation: 0.5,
              ),
              body: const PesananScreen(driver: DriverModel()),
            ),
        '/penghasilan': (context) => Scaffold(
              appBar: AppBar(
                title: const PolirideBrand(fontSize: 19, badgeText: 'MITRA'),
                elevation: 0.5,
              ),
              body: const PenghasilanScreen(driver: DriverModel()),
            ),
        '/akun': (context) => Scaffold(
              appBar: AppBar(
                title: const PolirideBrand(fontSize: 19, badgeText: 'MITRA'),
                elevation: 0.5,
              ),
              body: const AkunScreen(driver: DriverModel()),
            ),
      },
    );
  }
}
