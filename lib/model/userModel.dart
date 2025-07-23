class UserModel {
  final int id;
  final String name;
  final String username;
  final String mobile;
  final String email;
  final int complaints;
  final bool isActive;
  final String? address;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.mobile,
    required this.email,
    required this.complaints,
    required this.isActive,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      mobile: json['mobile'],
      email: json['email'],
      complaints: json['complaints'] ?? 0,
      isActive: json['is_active'] ?? true,
      address: json['address'] ?? '',
    );
  }

  // To convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'mobile': mobile,
      'email': email,
      'complaints': complaints,
      'is_active': isActive,
      'address': address,
    };
  }

  // Copy with method for updating specific fields
  UserModel copyWith({
    int? id,
    String? name,
    String? username,
    String? mobile,
    String? email,
    int? complaints,
    bool? isActive,
    String? address,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      complaints: complaints ?? this.complaints,
      isActive: isActive ?? this.isActive,
      address: address ?? this.address,
    );
  }
}

enum Role {
  // ignore: constant_identifier_names
  ADMIN,
  // ignore: constant_identifier_names
  USER,
  // ignore: constant_identifier_names
  EMPLOYEE,
}
