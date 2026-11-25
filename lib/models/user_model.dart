class UserModel {
  final String id;
  final String npm;
  final String name;
  final String email;
  final String major; // e.g. Teknologi Informasi / TRPL
  final String phone;
  final String gender;
  final String angkatan;
  final String semester;
  final String status;
  final String profilePicture;
  final double balance;
  final int points;
  final String tier;
  final double rating;

  UserModel({
    required this.id,
    required this.npm,
    required this.name,
    required this.email,
    required this.major,
    this.phone = '',
    this.gender = '',
    this.angkatan = '',
    this.semester = '',
    this.status = '',
    this.profilePicture = '',
    this.balance = 25000.0,
    this.points = 120,
    this.tier = 'Silver Mahasiswa',
    this.rating = 4.9,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      npm: json['npm'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      major: json['major'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      angkatan: json['angkatan'] ?? '',
      semester: json['semester'] ?? '',
      status: json['status'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 25000.0,
      points: (json['points'] as num?)?.toInt() ?? 120,
      tier: json['tier'] ?? 'Silver Mahasiswa',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'npm': npm,
      'name': name,
      'email': email,
      'major': major,
      'phone': phone,
      'gender': gender,
      'angkatan': angkatan,
      'semester': semester,
      'status': status,
      'profilePicture': profilePicture,
      'balance': balance,
      'points': points,
      'tier': tier,
      'rating': rating,
    };
  }

  UserModel copyWith({
    String? id,
    String? npm,
    String? name,
    String? email,
    String? major,
    String? phone,
    String? gender,
    String? angkatan,
    String? semester,
    String? status,
    String? profilePicture,
    double? balance,
    int? points,
    String? tier,
    double? rating,
  }) {
    return UserModel(
      id: id ?? this.id,
      npm: npm ?? this.npm,
      name: name ?? this.name,
      email: email ?? this.email,
      major: major ?? this.major,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      angkatan: angkatan ?? this.angkatan,
      semester: semester ?? this.semester,
      status: status ?? this.status,
      profilePicture: profilePicture ?? this.profilePicture,
      balance: balance ?? this.balance,
      points: points ?? this.points,
      tier: tier ?? this.tier,
      rating: rating ?? this.rating,
    );
  }
}
