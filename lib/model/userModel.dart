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
}



enum Role {
 // ignore: constant_identifier_names
 ADMIN,
  // ignore: constant_identifier_names
  USER,
  // ignore: constant_identifier_names
  EMPLOYEE,
}