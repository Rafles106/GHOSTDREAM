import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../models/campus_spot_model.dart';
import '../models/ride_model.dart';

class RideService extends ChangeNotifier {
  static final RideService _instance = RideService._internal();
  factory RideService() => _instance;

  RideService._internal() {
    _initDefaultHistory();
  }

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

  final List<RideOrder> _completedOrders = [];
  List<RideOrder> get completedOrders => List.unmodifiable(_completedOrders);

  final List<RideOrder> _cancelledOrders = [];
  List<RideOrder> get cancelledOrders => List.unmodifiable(_cancelledOrders);

  void _initDefaultHistory() {
    _completedOrders.addAll([
      RideOrder(
        id: 'POLI-8921',
        type: RideType.poliRide,
        title: 'Perjalanan PoliRide',
        pickup: 'Gerbang Utama (Jl. Soekarno Hatta)',
        pickupCoord: const LatLng(-5.3550, 105.2315),
        destination: 'Gedung Kuliah Bersama (GKB)',
        destinationCoord: const LatLng(-5.3582, 105.2341),
        dateTime: 'Hari ini, 08:30 WIB',
        fare: 5000.0,
        driverName: 'Rian Saputra',
        vehicleInfo: 'Honda Beat • Hitam',
        plateNumber: 'BE 3412 YA',
        driverRating: 4.9,
        status: RideStatus.selesai,
        paymentMethod: 'PoliPay (Saldo)',
        ratingGiven: 5.0,
        review: 'Driver ramah dan tepat waktu sampai ke depan lobi GKB!',
        distance: '950 m',
        duration: '3 menit',
      ),
      RideOrder(
        id: 'POLI-8744',
        type: RideType.poliRide,
        title: 'Perjalanan PoliRide',
        pickup: 'Gedung GFS',
        pickupCoord: const LatLng(-5.3570, 105.2330),
        destination: 'Kantin Perikanan',
        destinationCoord: const LatLng(-5.3595, 105.2350),
        dateTime: 'Kemarin, 12:15 WIB',
        fare: 5000.0,
        driverName: 'Ahmad Fauzi',
        vehicleInfo: 'Yamaha NMAX • Abu-abu',
        plateNumber: 'BE 5521 CD',
        driverRating: 4.8,
        status: RideStatus.selesai,
        paymentMethod: 'Tunai',
        ratingGiven: 5.0,
        review: 'Mantap, cepat sampai tidak telat kuliah siang.',
        distance: '500 m',
        duration: '2 menit',
      ),
    ]);

    _cancelledOrders.add(
      RideOrder(
        id: 'POLI-8630',
        type: RideType.poliRide,
        title: 'Perjalanan PoliRide',
        pickup: 'Gedung GFS',
        pickupCoord: const LatLng(-5.3570, 105.2330),
        destination: 'Gerbang Samping',
        destinationCoord: const LatLng(-5.3605, 105.2320),
        dateTime: '19 Nov 2026, 17:00 WIB',
        fare: 5000.0,
        driverName: 'Bambang Irawan',
        vehicleInfo: 'Honda Vario • Merah',
        plateNumber: 'BE 7719 AA',
        status: RideStatus.dibatalkan,
        cancellationReason: 'Jadwal kuliah mendadak diganti daring',
        distance: '600 m',
        duration: '3 menit',
      ),
    );
  }

  /// Buat Pesanan Baru
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
    final fare = type == RideType.poliCar ? 12000.0 : 5000.0;
    final durationMin = max(2, (distanceKm * 4).round());

    final orderId = 'POLI-${1000 + Random().nextInt(9000)}';

    // Mock driver initial position slightly away
    final driverCoord = LatLng(
      pickupCoord.latitude + 0.0015,
      pickupCoord.longitude - 0.0012,
    );

    final newOrder = RideOrder(
      id: orderId,
      type: type,
      title: type == RideType.poliCar ? 'Perjalanan PoliCar' : 'Perjalanan PoliRide',
      pickup: pickup,
      pickupCoord: pickupCoord,
      destination: destination,
      destinationCoord: destinationCoord,
      dateTime: 'Baru saja',
      fare: fare,
      driverName: 'Budi Santoso',
      driverPhone: '0812-7890-4321',
      vehicleInfo: type == RideType.poliCar ? 'Toyota Avanza • Hitam' : 'Honda Vario 160 • Hitam',
      plateNumber: type == RideType.poliCar ? 'BE 1902 BB' : 'BE 4892 AF',
      driverRating: 4.9,
      driverTrips: 342,
      driverCurrentCoord: driverCoord,
      status: RideStatus.menujuJemput,
      paymentMethod: paymentMethod,
      pickupNote: pickupNote,
      distance: '${distanceKm.toStringAsFixed(1)} km',
      duration: '$durationMin menit',
    );

    _activeOrder = newOrder;
    notifyListeners();
    return newOrder;
  }

  /// Update Driver Position (Simulasi pergerakan driver)
  void updateDriverPosition(LatLng newPosition) {
    if (_activeOrder != null) {
      _activeOrder = _activeOrder!.copyWith(
        driverCurrentCoord: newPosition,
      );
      notifyListeners();
    }
  }

  /// Ubah Status Pesanan Aktif
  void setOrderStatus(RideStatus newStatus) {
    if (_activeOrder != null) {
      _activeOrder = _activeOrder!.copyWith(status: newStatus);
      notifyListeners();
    }
  }

  /// Selesaikan Pesanan
  void completeActiveOrder({double rating = 5.0, String? review}) {
    if (_activeOrder != null) {
      final finished = _activeOrder!.copyWith(
        status: RideStatus.selesai,
        ratingGiven: rating,
        review: review ?? 'Sangat memuaskan, ramah dan cepat!',
        dateTime: 'Hari ini, ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} WIB',
      );
      _completedOrders.insert(0, finished);
      _activeOrder = null;
      notifyListeners();
    }
  }

  /// Batalkan Pesanan Aktif
  void cancelActiveOrder({required String reason}) {
    if (_activeOrder != null) {
      final cancelled = _activeOrder!.copyWith(
        status: RideStatus.dibatalkan,
        cancellationReason: reason,
        dateTime: 'Hari ini, ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} WIB',
      );
      _cancelledOrders.insert(0, cancelled);
      _activeOrder = null;
      notifyListeners();
    }
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
