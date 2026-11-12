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
    this.phone = '+62 858-3920-1844',
    this.gender = 'Laki-laki',
    this.angkatan = '2024',
    this.semester = 'Semester 5',
    this.status = 'Mahasiswa Aktif',
    this.profilePicture = '',
    this.balance = 25750.0,
    this.points = 1250,
    this.tier = 'Gold',
    this.rating = 5.0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      npm: json['npm'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      major: json['major'] ?? '',
      phone: json['phone'] ?? '+62 858-3920-1844',
      gender: json['gender'] ?? 'Laki-laki',
      angkatan: json['angkatan'] ?? '2024',
      semester: json['semester'] ?? 'Semester 5',
      status: json['status'] ?? 'Mahasiswa Aktif',
      profilePicture: json['profilePicture'] ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 25750.0,
      points: (json['points'] as num?)?.toInt() ?? 1250,
      tier: json['tier'] ?? 'Gold',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
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
