import 'package:latlong2/latlong.dart';

enum RideType { poliRide, poliCar, poliSend, poliFood }

enum RideStatus { mencariDriver, menujuJemput, dalamPerjalanan, selesai, dibatalkan }

class RideOrder {
  final String id;
  final RideType type;
  final String title;
  final String pickup;
  final LatLng pickupCoord;
  final String destination;
  final LatLng destinationCoord;
  final String dateTime;
  final double fare;
  final String driverName;
  final String driverPhone;
  final String vehicleInfo;
  final String plateNumber;
  final double driverRating;
  final int driverTrips;
  final LatLng? driverCurrentCoord;
  final RideStatus status;
  final String? review;
  final double? ratingGiven;
  final String paymentMethod;
  final String? pickupNote;
  final String? destinationNote;
  final String? cancellationReason;
  final String distance;
  final String duration;

  RideOrder({
    required this.id,
    this.type = RideType.poliRide,
    required this.title,
    required this.pickup,
    required this.pickupCoord,
    required this.destination,
    required this.destinationCoord,
    required this.dateTime,
    required this.fare,
    this.driverName = 'Budi Santoso',
    this.driverPhone = '0812-7890-4321',
    this.vehicleInfo = 'Honda Vario 160 • Hitam',
    this.plateNumber = 'BE 4892 AF',
    this.driverRating = 4.9,
    this.driverTrips = 342,
    this.driverCurrentCoord,
    this.status = RideStatus.menujuJemput,
    this.review,
    this.ratingGiven,
    this.paymentMethod = 'PoliPay (Saldo)',
    this.pickupNote,
    this.destinationNote,
    this.cancellationReason,
    this.distance = '1.2 km',
    this.duration = '4 menit',
  });

  RideOrder copyWith({
    String? id,
    RideType? type,
    String? title,
    String? pickup,
    LatLng? pickupCoord,
    String? destination,
    LatLng? destinationCoord,
    String? dateTime,
    double? fare,
    String? driverName,
    String? driverPhone,
    String? vehicleInfo,
    String? plateNumber,
    double? driverRating,
    int? driverTrips,
    LatLng? driverCurrentCoord,
    RideStatus? status,
    String? review,
    double? ratingGiven,
    String? paymentMethod,
    String? pickupNote,
    String? destinationNote,
    String? cancellationReason,
    String? distance,
    String? duration,
  }) {
    return RideOrder(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      pickup: pickup ?? this.pickup,
      pickupCoord: pickupCoord ?? this.pickupCoord,
      destination: destination ?? this.destination,
      destinationCoord: destinationCoord ?? this.destinationCoord,
      dateTime: dateTime ?? this.dateTime,
      fare: fare ?? this.fare,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      plateNumber: plateNumber ?? this.plateNumber,
      driverRating: driverRating ?? this.driverRating,
      driverTrips: driverTrips ?? this.driverTrips,
      driverCurrentCoord: driverCurrentCoord ?? this.driverCurrentCoord,
      status: status ?? this.status,
      review: review ?? this.review,
      ratingGiven: ratingGiven ?? this.ratingGiven,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      pickupNote: pickupNote ?? this.pickupNote,
      destinationNote: destinationNote ?? this.destinationNote,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
    );
  }
}
