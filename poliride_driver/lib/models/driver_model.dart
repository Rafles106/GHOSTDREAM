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
  final String? profileImagePath;

  const DriverModel({
    this.id = '',
    this.mitraId = '',
    this.name = '',
    this.phone = '',
    this.email = '',
    this.rating = 0.0,
    this.totalTrips = 0,
    this.acceptanceRate = 0.0,
    this.joinedYear = '',
    this.vehicleModel = '',
    this.vehiclePlate = '',
    this.vehicleTaxDate = '',
    this.isSimVerified = false,
    this.isUjiKelayakanVerified = false,
    this.isSkckVerified = false,
    this.isAutoAccept = false,
    this.isLoudAlert = false,
    this.isOnline = false,
    this.profileImagePath,
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
    String? profileImagePath,
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
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}
