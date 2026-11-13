enum RideType { poliRide, poliFood }

enum RideStatus { dalamProses, selesai, dibatalkan }

class RideOrder {
  final String id;
  final RideType type;
  final String title;
  final String pickup;
  final String destination;
  final String dateTime;
  final double fare;
  final String driverName;
  final String vehicleInfo;
  final double driverRating;
  final RideStatus status;
  final String? review;
  final String paymentMethod;
  final String? foodItems;
  final String? pickupNote;
  final String? destinationNote;
  final String? plateNumber;
  final int? driverTrips;
  final String? cancellationReason;
  final String? cancellationType;
  final String? driverNote;

  const RideOrder({
    required this.id,
    required this.type,
    required this.title,
    required this.pickup,
    required this.destination,
    required this.dateTime,
    required this.fare,
    required this.driverName,
    required this.vehicleInfo,
    this.driverRating = 4.9,
    required this.status,
    this.review,
    this.paymentMethod = 'Tunai (Bayar Langsung ke Driver)',
    this.foodItems,
    this.pickupNote,
    this.destinationNote,
    this.plateNumber,
    this.driverTrips,
    this.cancellationReason,
    this.cancellationType,
    this.driverNote,
  });
}
