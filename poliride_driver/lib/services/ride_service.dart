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

  /// Pesanan Berlangsung (Active Order) - Dikosongkan untuk koneksi database
  static final RideOrder? activeOrder = null;

  /// Riwayat Selesai (Completed Orders) - Dikosongkan untuk koneksi database
  static final List<RideOrder> completedOrders = [];

  /// Riwayat Dibatalkan (Cancelled Orders) - Dikosongkan untuk koneksi database
  static final List<RideOrder> cancelledOrders = [];

  static double calculateFare(String pickup, String destination) {
    if (pickup == destination) return 0.0;
    return 5000.0; // Tarif PoliRide Kampus Rp 5.000
  }
}
