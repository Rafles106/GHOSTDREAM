import '../models/ride_model.dart';

class CampusLocation {
  final String id;
  final String name;
  final String category;
  final String description;
  final String distance;
  final double fare;
  final bool isPopular;

  const CampusLocation({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.distance = '500 m',
    this.fare = 3000.0,
    this.isPopular = false,
  });
}

class RideService {
  /// Daftar spot populer di lingkungan Kampus Politeknik (Polineks / Polinela)
  static final List<CampusLocation> campusSpots = [
    const CampusLocation(
      id: 'LOC-01',
      name: 'Gedung Kuliah Bersama (GKB)',
      category: 'Perkuliahan',
      description: '450 m dari posisi Anda • Parkiran Timur GKB',
      distance: '450 m',
      fare: 3000.0,
      isPopular: true,
    ),
    const CampusLocation(
      id: 'LOC-02',
      name: 'Gedung Ki Hajar Dewantara',
      category: 'Gedung Kuliah & Lab',
      description: '620 m dari posisi Anda • Lobby Gedung',
      distance: '620 m',
      fare: 3000.0,
      isPopular: true,
    ),
    const CampusLocation(
      id: 'LOC-03',
      name: 'GSD Polineks',
      category: 'Fasilitas Mahasiswa',
      description: '300 m dari posisi Anda • Pintu Masuk Hall',
      distance: '300 m',
      fare: 3000.0,
      isPopular: true,
    ),
    const CampusLocation(
      id: 'LOC-04',
      name: 'Kantin Perikanan',
      category: 'Kuliner & Istirahat',
      description: '850 m dari posisi Anda • Pangkalan Ojek Kantin',
      distance: '850 m',
      fare: 3000.0,
      isPopular: true,
    ),
    const CampusLocation(
      id: 'LOC-05',
      name: 'Gerbang Depan',
      category: 'Pintu Masuk Utama',
      description: '1.2 km dari posisi Anda • Pos Satpam Utama',
      distance: '1.2 km',
      fare: 3000.0,
      isPopular: true,
    ),
    const CampusLocation(
      id: 'LOC-06',
      name: 'Gedung GFS',
      category: 'Gedung Administrasi',
      description: 'Depan lobby utama • Tersedia ruang tunggu berteduh',
      distance: '150 m',
      fare: 3000.0,
      isPopular: true,
    ),
    const CampusLocation(
      id: 'LOC-07',
      name: 'Gerbang Samping',
      category: 'Akses Kampus',
      description: 'Pintu keluar arah kos mahasiswa',
      distance: '350 m',
      fare: 3000.0,
      isPopular: false,
    ),
    const CampusLocation(
      id: 'LOC-08',
      name: 'Kantin Pusat Polineks',
      category: 'Pusat Kuliner',
      description: 'Area pujasera & stand makanan mahasiswa',
      distance: '500 m',
      fare: 3000.0,
      isPopular: false,
    ),
    const CampusLocation(
      id: 'LOC-09',
      name: 'Lobby Gedung Rektorat',
      category: 'Layanan Rektorat',
      description: 'Pusat birokrasi & akademik kampus',
      distance: '700 m',
      fare: 3000.0,
      isPopular: false,
    ),
  ];

  /// Backward compatibility for existing references
  static List<CampusLocation> get polinelaSpotList => campusSpots;

  /// Pesanan Berlangsung (Active Order) matching Figma Design (Screen 5 & 7)
  static final RideOrder activeOrder = RideOrder(
    id: 'ORD-2024-098',
    type: RideType.poliRide,
    title: 'PoliRide Motor',
    pickup: 'Gerbang Samping',
    destination: 'Gedung GFS',
    dateTime: 'Hari ini • 09:15',
    fare: 3000.0,
    driverName: 'Badaruddin',
    vehicleInfo: 'Honda Beat • BK 1902 AB',
    driverRating: 4.9,
    status: RideStatus.dalamProses,
    paymentMethod: 'Saldo PoliRIDE (Non-tunai)',
  );

  /// Riwayat Selesai (Completed Orders) matching Figma Design (Screen 5 & 6)
  static final List<RideOrder> completedOrders = [
    const RideOrder(
      id: 'ORD-2024-097',
      type: RideType.poliRide,
      title: 'PoliRide Motor',
      pickup: 'Gerbang Samping',
      destination: 'Gedung GFS',
      dateTime: 'Hari ini, 09:15',
      fare: 3000.0,
      driverName: 'Badar',
      vehicleInfo: 'Honda Beat • BK 1902 AB',
      driverRating: 5.0,
      status: RideStatus.selesai,
      review: 'Driver ramah dan helm wangi',
    ),
    const RideOrder(
      id: 'ORD-2024-096',
      type: RideType.poliRide,
      title: 'PoliRide Motor',
      pickup: 'GSD Polineks',
      destination: 'Gedung Utama & Rektorat',
      dateTime: 'Kemarin, 16:30',
      fare: 3000.0,
      driverName: 'Rizki',
      vehicleInfo: 'Honda Vario • BK 4521 KL',
      driverRating: 4.9,
      status: RideStatus.selesai,
    ),
    const RideOrder(
      id: 'ORD-2024-095',
      type: RideType.poliRide,
      title: 'PoliRide Motor',
      pickup: 'Kantin Perikanan',
      destination: 'Gedung Kuliah Bersama (GKB)',
      dateTime: '12 Okt • 14:20',
      fare: 3000.0,
      driverName: 'Hendra',
      vehicleInfo: 'Yamaha Mio • BM 1209 GH',
      driverRating: 5.0,
      status: RideStatus.selesai,
      review: 'Tepat waktu dan cepat sampai tujuan',
    ),
    const RideOrder(
      id: 'ORD-2024-094',
      type: RideType.poliFood,
      title: 'PoliFood',
      pickup: 'Kantin Pusat Polineks',
      destination: 'Gedung GFS Lantai 2',
      dateTime: '11 Okt • 12:40',
      fare: 18000.0,
      driverName: 'Dedi Saputra',
      vehicleInfo: 'Honda Supra • BK 8765 AB',
      driverRating: 4.8,
      status: RideStatus.selesai,
      foodItems: 'Nasi Ayam Geprek + Es Teh Jumbo',
    ),
    const RideOrder(
      id: 'ORD-2024-093',
      type: RideType.poliRide,
      title: 'PoliRide Motor',
      pickup: 'Kantin Perikanan',
      destination: 'Gerbang Depan',
      dateTime: '10 Okt 2024 • 11:00',
      fare: 3000.0,
      driverName: 'Bang Hendra',
      vehicleInfo: 'Yamaha NMAX • BK 3321 CD',
      driverRating: 4.9,
      status: RideStatus.selesai,
    ),
  ];

  /// Riwayat Dibatalkan (Cancelled Orders)
  static final List<RideOrder> cancelledOrders = [
    const RideOrder(
      id: 'ORD-2024-090',
      type: RideType.poliRide,
      title: 'PoliRide Motor',
      pickup: 'Kantin Pusat Polineks',
      destination: 'Lobby Gedung Rektorat',
      dateTime: '08 Okt • 10:15',
      fare: 3000.0,
      driverName: 'Badaruddin',
      vehicleInfo: 'Honda Beat • BK 1902 AB',
      status: RideStatus.dibatalkan,
      review: 'Dibatalkan oleh mahasiswa - perubahan jadwal kuliah',
    ),
  ];

  static double calculateFare(String pickup, String destination) {
    if (pickup == destination) return 0.0;
    return 3000.0; // Flat rate hemat kampus Polineks Rp 3.000
  }
}
