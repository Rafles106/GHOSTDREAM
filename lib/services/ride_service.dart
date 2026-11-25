import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../models/campus_spot_model.dart';
import '../models/ride_model.dart';

class RideService extends ChangeNotifier {
  static final RideService _instance = RideService._internal();
  factory RideService() => _instance;

  RideService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _ordersRef => _firestore.collection('orders');

  /// Koordinat Pusat Polinela
  static const LatLng polinelaCenter = LatLng(-5.3578, 105.2335);

  /// Daftar Spot Kampus Politeknik Negeri Lampung (Polinela)
  static final List<CampusSpot> campusSpots = [
    const CampusSpot(
      id: 'LOC-01',
      name: 'Gedung Kuliah Bersama (GKB)',
      category: 'Perkuliahan',
      description: 'Lobby & Parkiran Timur GKB • Pos Satpam',
      distance: '250 m',
      fare: 5000.0,
      isPopular: true,
      coordinate: LatLng(-5.3582, 105.2341),
    ),
    const CampusSpot(
      id: 'LOC-02',
      name: 'Gedung GFS (Graha Faperta Sain)',
      category: 'Gedung Administrasi & Kuliah',
      description: 'Depan lobby utama • Ruang tunggu berteduh',
      distance: '150 m',
      fare: 5000.0,
      isPopular: true,
      coordinate: LatLng(-5.3570, 105.2330),
    ),
    const CampusSpot(
      id: 'LOC-03',
      name: 'GSD Polineks / GSG Polinela',
      category: 'Fasilitas & Acara',
      description: 'Lobby gedung serba guna • Pangkalan ojek aktif',
      distance: '300 m',
      fare: 5000.0,
      isPopular: true,
      coordinate: LatLng(-5.3565, 105.2325),
    ),
    const CampusSpot(
      id: 'LOC-04',
      name: 'Kantin Perikanan / Pujasera',
      category: 'Kuliner Kampus',
      description: 'Samping stand jus • Area tunggu mahasiswa',
      distance: '450 m',
      fare: 5000.0,
      isPopular: true,
      coordinate: LatLng(-5.3595, 105.2350),
    ),
    const CampusSpot(
      id: 'LOC-05',
      name: 'Gerbang Utama (Jl. Soekarno Hatta)',
      category: 'Pintu Masuk Utama',
      description: 'Pos satpam gerbang depan kampus',
      distance: '900 m',
      fare: 5000.0,
      isPopular: true,
      coordinate: LatLng(-5.3550, 105.2315),
    ),
    const CampusSpot(
      id: 'LOC-06',
      name: 'Gerbang Samping (Kos Mahasiswa Barat)',
      category: 'Akses Kos',
      description: 'Pintu keluar arah gang kos mahasiswa Rajabasa',
      distance: '500 m',
      fare: 5000.0,
      isPopular: true,
      coordinate: LatLng(-5.3605, 105.2320),
    ),
    const CampusSpot(
      id: 'LOC-07',
      name: 'Jurusan Teknologi Informasi (Lab TI)',
      category: 'Gedung Jurusan',
      description: 'Lab TRPL & MI • Parkiran barat TI',
      distance: '350 m',
      fare: 5000.0,
      isPopular: true,
      coordinate: LatLng(-5.3575, 105.2355),
    ),
    const CampusSpot(
      id: 'LOC-08',
      name: 'Gedung Rektorat Polinela',
      category: 'Birokrasi & Layanan',
      description: 'Lobby Rektorat & Gedung Pengelola Kampus',
      distance: '400 m',
      fare: 5000.0,
      isPopular: false,
      coordinate: LatLng(-5.3560, 105.2338),
    ),
    const CampusSpot(
      id: 'LOC-09',
      name: 'Gedung Ki Hajar Dewantara',
      category: 'Gedung Kuliah & Lab',
      description: 'Lobby tengah lantai dasar',
      distance: '320 m',
      fare: 5000.0,
      isPopular: false,
      coordinate: LatLng(-5.3588, 105.2328),
    ),
  ];

  RideOrder? _activeOrder;
  RideOrder? get activeOrder => _activeOrder;

  /// Stream real-time 1 dokumen order di koleksi `orders`
  Stream<DocumentSnapshot> watchOrder(String orderId) {
    return _ordersRef.doc(orderId).snapshots();
  }

  /// Stream daftar order milik penumpang saat ini
  Stream<QuerySnapshot> watchMyOrders() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return _ordersRef.orderBy('createdAt', descending: true).snapshots();
    }
    return _ordersRef
        .where('passengerId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Buat Pesanan Baru ke Cloud Firestore (`orders`)
  Future<RideOrder> createOrder({
    required String pickup,
    required LatLng pickupCoord,
    required String destination,
    required LatLng destinationCoord,
    required RideType type,
    required String paymentMethod,
    String? pickupNote,
  }) async {
    final distanceKm = _calculateDistance(pickupCoord, destinationCoord);
    const fare = 5000.0;
    final durationMin = max(2, (distanceKm * 4).round());
    final user = _auth.currentUser;

    final docRef = _ordersRef.doc();
    final orderId = docRef.id;

    debugPrint('DEBUG CREATE ORDER START: $orderId | uid=${user?.uid}');

    try {
      String passengerName = user?.displayName ?? 'Penumpang';
      String passengerPhone = user?.phoneNumber ?? '';

      if (user != null) {
        try {
          final passengerDoc =
          await _firestore.collection('passengers').doc(user.uid).get();
          if (passengerDoc.exists) {
            final rawData = passengerDoc.data();
            if (rawData is Map<String, dynamic>) {
              passengerName = (rawData['name'] ?? passengerName).toString();
              passengerPhone = (rawData['phone'] ?? passengerPhone).toString();
            }
          }
        } catch (e) {
          debugPrint('DEBUG READ PASSENGER DOC WARN: $e');
        }
      }

      final orderData = <String, dynamic>{
        'id': orderId,
        'passengerId': user?.uid,
        'passengerName': passengerName,
        'passengerPhone': passengerPhone,
        'driverId': null,
        'driverName': null,
        'driverPhone': null,
        'vehicleInfo': null,
        'plateNumber': null,
        'driverRating': null,
        'driverTrips': null,
        'driverCurrentLat': null,
        'driverCurrentLng': null,
        'type': type.name,
        'title': 'Perjalanan PoliRide',
        'pickup': pickup,
        'pickupLat': pickupCoord.latitude,
        'pickupLng': pickupCoord.longitude,
        'destination': destination,
        'destinationLat': destinationCoord.latitude,
        'destinationLng': destinationCoord.longitude,
        'fare': fare,
        'distance': '$distanceKm km',
        'duration': '$durationMin menit',
        'paymentMethod': paymentMethod,
        'pickupNote': pickupNote,
        'status': 'menunggu',
        'cancellationReason': null,
        'ratingGiven': null,
        'review': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await docRef.set(orderData);
      debugPrint('DEBUG CREATE ORDER SUCCESS: $orderId');

      final newOrder = RideOrder(
        id: orderId,
        type: type,
        title: 'Perjalanan PoliRide',
        pickup: pickup,
        pickupCoord: pickupCoord,
        destination: destination,
        destinationCoord: destinationCoord,
        dateTime: 'Baru saja',
        fare: fare,
        status: RideStatus.menujuJemput,
        paymentMethod: paymentMethod,
        pickupNote: pickupNote,
        distance: '$distanceKm km',
        duration: '$durationMin menit',
      );

      _activeOrder = newOrder;
      notifyListeners();
      return newOrder;
    } catch (e, stack) {
      debugPrint('DEBUG CREATE ORDER ERROR: $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  /// Update posisi driver di dokumen order Firestore
  Future<void> updateDriverPosition(String orderId, LatLng newPosition) async {
    await _ordersRef.doc(orderId).update({
      'driverCurrentLat': newPosition.latitude,
      'driverCurrentLng': newPosition.longitude,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Ubah status pesanan di Firestore
  Future<void> setOrderStatus(String orderId, String newStatus) async {
    await _ordersRef.doc(orderId).update({
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    notifyListeners();
  }

  /// Selesaikan Pesanan di Firestore
  Future<void> completeActiveOrder({
    required String orderId,
    double rating = 5.0,
    String? review,
  }) async {
    await _ordersRef.doc(orderId).update({
      'status': 'selesai',
      'ratingGiven': rating,
      'review': review ?? 'Sangat memuaskan, ramah dan cepat!',
      'updatedAt': FieldValue.serverTimestamp(),
    });
    if (_activeOrder?.id == orderId) {
      _activeOrder = null;
    }
    notifyListeners();
  }

  /// Batalkan Pesanan di Firestore
  Future<void> cancelActiveOrder({
    required String orderId,
    required String reason,
  }) async {
    await _ordersRef.doc(orderId).update({
      'status': 'dibatalkan',
      'cancellationReason': reason,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    if (_activeOrder?.id == orderId) {
      _activeOrder = null;
    }
    notifyListeners();
  }

  /// Hitung Jarak Geodesic Euclidean sederhana
  double _calculateDistance(LatLng p1, LatLng p2) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((p2.latitude - p1.latitude) * p) / 2 +
        cos(p1.latitude * p) *
            cos(p2.latitude * p) *
            (1 - cos((p2.longitude - p1.longitude) * p)) /
            2;
    final d = 12742 * asin(sqrt(a));
    return double.parse(max(0.4, d).toStringAsFixed(1));
  }
}