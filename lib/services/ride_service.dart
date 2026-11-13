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

  /// Pesanan Berlangsung (Active Order) matching Figma Design (Screen 5)
  static final RideOrder activeOrder = RideOrder(
    id: '# 24708910',
    type: RideType.poliRide,
    title: 'PoliRide Motor',
    pickup: 'Gerbang Samping',
    pickupNote: 'Gerbang samping samping...',
    destination: 'Gedung SFS',
    destinationNote: 'Depan Gedung',
    dateTime: 'Hari ini • 08:35 WIB',
    fare: 5000.0,
    driverName: 'Raden R.',
    vehicleInfo: 'Honda Vario 125',
    plateNumber: 'N 4602 GA',
    driverRating: 4.9,
    driverTrips: 248,
    status: RideStatus.dalamProses,
    paymentMethod: 'Tunai (Bayar Langsung ke Driver)',
    driverNote: 'Driver sudah siap di lokasi jemput depan gerbang!',
  );

  /// Riwayat Selesai (Completed Orders) matching Figma Design (Screen 5 & 6)
  static final List<RideOrder> completedOrders = [
    const RideOrder(
      id: '# 24708892',
      type: RideType.poliRide,
      title: 'PoliRide Motor',
      pickup: 'Gerbang Samping',
      pickupNote: 'Gerbang samping samping...',
      destination: 'Gedung SFS',
      destinationNote: 'Depan Gedung',
      dateTime: '12 Nov 2024, 08:30 WIB',
      fare: 5000.0,
      driverName: 'Raden R',
      plateNumber: 'N 4602 GA',
      vehicleInfo: 'Honda Vario 125',
      driverRating: 5.0,
      status: RideStatus.selesai,
      review: 'Helm wangi dan bersih, terima kasih kak!',
    ),
    const RideOrder(
      id: '# 24708750',
      type: RideType.poliRide,
      title: 'PoliRide Motor',
      pickup: 'GKS Polinema',
      destination: 'Kantin Perikanan',
      dateTime: '11 Nov 2024, 12:15 WIB',
      fare: 6000.0,
      driverName: 'Ahmad Fauzi',
      plateNumber: 'N 5122 XY',
      vehicleInfo: 'Yamaha Mio M3',
      driverRating: 4.9,
      status: RideStatus.selesai,
    ),
    const RideOrder(
      id: '# 24708611',
      type: RideType.poliRide,
      title: 'PoliRide Motor',
      pickup: 'Asrama Mahasiswa Putri',
      destination: 'Gedung Graha Polinema',
      dateTime: '10 Nov 2024, 07:45 WIB',
      fare: 5500.0,
      driverName: 'Dimas Setiawan',
      plateNumber: 'N 3341 KL',
      vehicleInfo: 'Honda Beat Street',
      driverRating: 5.0,
      status: RideStatus.selesai,
    ),
    const RideOrder(
      id: '# 24708502',
      type: RideType.poliFood,
      title: 'PoliFood Kantin',
      pickup: 'Kantin Gedung D',
      destination: 'Gedung SFS',
      dateTime: '09 Nov 2024, 13:00 WIB',
      fare: 18000.0,
      driverName: 'Rian Hidayat',
      plateNumber: 'N 2940 AB',
      vehicleInfo: 'Honda Supra X 125',
      driverRating: 4.8,
      status: RideStatus.selesai,
      foodItems: 'Nasi Ayam Geprek + Es Jeruk',
    ),
  ];

  /// Riwayat Dibatalkan (Cancelled Orders) matching Figma Design (Screen 7)
  static final List<RideOrder> cancelledOrders = [
    const RideOrder(
      id: '# 24708420',
      type: RideType.poliRide,
      title: 'PoliRide Motor',
      pickup: 'Kantin Pusat Polinema',
      destination: 'Lapangan Voli',
      dateTime: '07 Nov 2024 • 14:10 WIB',
      fare: 5000.0,
      driverName: 'Budi Santoso',
      vehicleInfo: 'Yamaha Jupiter Z',
      plateNumber: 'N 6721 GH',
      status: RideStatus.dibatalkan,
      cancellationType: 'Batal Pengemudi',
      cancellationReason: 'Driver ban bocor saat menuju lokasi jemput. Anda tidak dikenakan denda apapun.',
    ),
    const RideOrder(
      id: '# 24708304',
      type: RideType.poliRide,
      title: 'PoliRide Motor',
      pickup: 'Gedung Belakang Polinema',
      destination: 'GKS Polinema',
      dateTime: '05 Nov 2024 • 09:15 WIB',
      fare: 5000.0,
      driverName: 'Faisal Akbar',
      vehicleInfo: 'Honda Vario 150',
      plateNumber: 'N 4019 PQ',
      status: RideStatus.dibatalkan,
      cancellationType: 'Batal Pemesan',
      cancellationReason: 'Dibatalkan oleh pemesan karena salah titik jemput. Pembatalan < 2 menit bebas biaya.',
    ),
  ];

  static double calculateFare(String pickup, String destination) {
    if (pickup == destination) return 0.0;
    return 5000.0; // Tarif PoliRide Kampus Rp 5.000
  }
}
