class Employee {
  final int id;
  final String firstName;
  final String lastName;
  final String department;
  final List<String> wardsName;
  final String contactInfo;
  final String role;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.wardsName,
    required this.contactInfo,
    required this.role,
  });

  /// Factory constructor to create Employee from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      department: json['departmentName'] ?? '',
      wardsName: List<String>.from(json['wardNames'] ?? []),
      contactInfo: json['phoneNumber'] ?? '',
      role: json['role'] ?? '',
    );
  }

  /// Convert Employee object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'departmentName': department,
      'wardNames': wardsName,
      'phoneNumber': contactInfo,
      'role': role,
    };
  }

  /// CopyWith method
  Employee copyWith({
    String? firstName,
    String? lastName,
    String? department,
    List<String>? wardsName,
    String? contactInfo,
    String? role,
  }) {
    return Employee(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      department: department ?? this.department,
      wardsName: wardsName ?? this.wardsName,
      contactInfo: contactInfo ?? this.contactInfo,
      role: role ?? this.role,
    );
  }

  /// Full name
  String get fullName => '$firstName $lastName';

  @override
  String toString() {
    return 'Employee{id: $id, name: $firstName $lastName, '
        'department: $department, phone: $contactInfo, '
        'wards: $wardsName, role: $role}';
  }
}
