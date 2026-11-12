import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/location_picker_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const PolirideApp());
}

class PolirideApp extends StatelessWidget {
  const PolirideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POLIRIDE PINANG SIRIH - Ojek Kampus Polineks',
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
      // Membuka SplashScreen yang secara otomatis beralih ke LoginScreen
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/location-picker': (context) => const LocationPickerScreen(),
      },
    );
  }
}
