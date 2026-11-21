import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poliride/main.dart';
import 'package:poliride/screens/dashboard_screen.dart';
import 'package:poliride/screens/location_picker_screen.dart';
import 'package:poliride/screens/login_screen.dart';

void main() {
  testWidgets('POLIRIDE app splash and login screen render test', (WidgetTester tester) async {
    await tester.pumpWidget(const PolirideApp());

    // Initially shows Splash Screen branding
    expect(find.text('Pilihan Tepat Mobilitas Kampus'), findsOneWidget);

    // Fast-forward splash screen timer
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Should transition to LoginScreen
    expect(find.text('Masuk Akun Mahasiswa'), findsOneWidget);
    expect(find.text('Poli-Ride Ojek Kampus Polineks'), findsOneWidget);
    expect(find.text('DAFTAR AKUN'), findsOneWidget);
  });

  testWidgets('dashboard navigation opens home, activity, and account tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    // Verify Home tab
    expect(find.text('Halo, Garbon 👋'), findsOneWidget);
    expect(find.text('Rute Favorit Anda'), findsOneWidget);
    expect(find.text('PoliRide Motor'), findsOneWidget);
    expect(find.text('Zona Ramai Saat Ini'), findsOneWidget);

    // Switch to Aktivitas tab
    await tester.tap(find.text('Aktivitas'));
    await tester.pumpAndSettle();
    expect(find.text('AKTIVITAS PESANAN'), findsOneWidget);
    expect(find.text('Dalam Proses (1)'), findsOneWidget);
    expect(find.text('MENJEMPUT'), findsOneWidget);
    expect(find.text('Badaruddin'), findsOneWidget);

    // Switch to Selesai filter
    await tester.tap(find.text('Selesai (11)'));
    await tester.pumpAndSettle();
    expect(find.text('PoliRide Motor (11)'), findsOneWidget);

    // Switch to Akun tab
    await tester.tap(find.text('Akun'));
    await tester.pumpAndSettle();
    expect(find.text('Garbon'), findsOneWidget);
    expect(find.text('Identitas Akademik'), findsOneWidget);
    expect(find.text('Email Kampus'), findsOneWidget);

    // Scroll to see emergency and settings
    await tester.drag(find.text('Garbon'), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('SOS Darurat Kampus'), findsOneWidget);
  });

  testWidgets('location picker screen renders correctly and confirms selection', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LocationPickerScreen()));

    expect(find.text('Pilih Titik Jemput'), findsOneWidget);
    expect(find.text('Gedung GFS'), findsWidgets);
    expect(find.text('Pangkalan populer'), findsOneWidget);
    expect(find.text('Konfirmasi Titik Jemput'), findsOneWidget);
  });

  testWidgets('registration creates an account that can log in', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.ensureVisible(find.text('DAFTAR AKUN'));
    await tester.tap(find.text('DAFTAR AKUN'));
    await tester.pumpAndSettle();

    expect(find.text('Daftar Akun Mahasiswa'), findsOneWidget);
    final textFields = find.byType(TextFormField);

    // Fields: Nama, NIM, Email, Phone, Kata Sandi, Ulangi Kata Sandi
    await tester.enterText(textFields.at(0), 'Aisyah Putri');
    await tester.enterText(textFields.at(1), '22998877');
    await tester.enterText(textFields.at(2), 'aisyah@polinela.ac.id');
    await tester.enterText(textFields.at(3), '081234567890');
    await tester.enterText(textFields.at(4), 'rahasia123');
    await tester.enterText(textFields.at(5), 'rahasia123');

    await tester.ensureVisible(find.text('Daftar'));
    await tester.tap(find.text('Daftar'));
    await tester.pumpAndSettle();

    // Returned to LoginScreen with NIM filled
    expect(
      tester.widget<TextFormField>(find.byType(TextFormField).first).controller!.text,
      '22998877',
    );

    await tester.enterText(find.byType(TextFormField).at(1), 'rahasia123');
    await tester.ensureVisible(find.text('Masuk'));
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Halo, Aisyah Putri 👋'), findsOneWidget);
  });
}
