class DriverModel {
  final String id;
  final String mitraId;
  final String name;
  final String phone;
  final String email;
  final double rating;
  final int totalTrips;
  final double acceptanceRate;
  final String joinedYear;
  final String vehicleModel;
  final String vehiclePlate;
  final String vehicleTaxDate;
  final bool isSimVerified;
  final bool isUjiKelayakanVerified;
  final bool isSkckVerified;
  final bool isAutoAccept;
  final bool isLoudAlert;
  final bool isOnline;

  const DriverModel({
    this.id = 'DRV-2024-001',
    this.mitraId = '247012',
    this.name = 'Daskiva',
    this.phone = '+62 812-7890-1234',
    this.email = 'daskiva.driver@polinela.ac.id',
    this.rating = 4.9,
    this.totalTrips = 67,
    this.acceptanceRate = 99.1,
    this.joinedYear = '2023',
    this.vehicleModel = 'Honda PCX Putih (2024)',
    this.vehiclePlate = 'BE 2790 BDD',
    this.vehicleTaxDate = 'Aktif s/d Nov 2025',
    this.isSimVerified = true,
    this.isUjiKelayakanVerified = true,
    this.isSkckVerified = true,
    this.isAutoAccept = true,
    this.isLoudAlert = true,
    this.isOnline = true,
  });

  DriverModel copyWith({
    String? id,
    String? mitraId,
    String? name,
    String? phone,
    String? email,
    double? rating,
    int? totalTrips,
    double? acceptanceRate,
    String? joinedYear,
    String? vehicleModel,
    String? vehiclePlate,
    String? vehicleTaxDate,
    bool? isSimVerified,
    bool? isUjiKelayakanVerified,
    bool? isSkckVerified,
    bool? isAutoAccept,
    bool? isLoudAlert,
    bool? isOnline,
  }) {
    return DriverModel(
      id: id ?? this.id,
      mitraId: mitraId ?? this.mitraId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      rating: rating ?? this.rating,
      totalTrips: totalTrips ?? this.totalTrips,
      acceptanceRate: acceptanceRate ?? this.acceptanceRate,
      joinedYear: joinedYear ?? this.joinedYear,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      vehicleTaxDate: vehicleTaxDate ?? this.vehicleTaxDate,
      isSimVerified: isSimVerified ?? this.isSimVerified,
      isUjiKelayakanVerified: isUjiKelayakanVerified ?? this.isUjiKelayakanVerified,
      isSkckVerified: isSkckVerified ?? this.isSkckVerified,
      isAutoAccept: isAutoAccept ?? this.isAutoAccept,
      isLoudAlert: isLoudAlert ?? this.isLoudAlert,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
