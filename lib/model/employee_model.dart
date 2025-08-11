class Employee {
  final int id;
  final String firstName;
  final String lastName;
  final String department;
  final List<String> wardsName;
  final String contactInfo;
  final List<String> assignedComplaints;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.wardsName,
    required this.contactInfo,
    required this.assignedComplaints,
  });

  /// Factory constructor to create Employee from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? 0,
      firstName: json['firstname'] ?? '',
      lastName: json['lastname'] ?? '',
      department: json['department'] ?? '',
      wardsName: json['wardsName'] ?? [],
      contactInfo: json['mobile'] ?? '',
      assignedComplaints: List<String>.from(json['assignedComplaints'] ?? []),
    );
  }

  /// Convert Employee object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'department': department,
      'wards': wardsName,
      'contactInfo': contactInfo,
      'assignedComplaints': assignedComplaints,
    };
  }

  /// CopyWith method for cloning/modifying fields
  Employee copyWith({
    String? firstName,
    String? lastName,
    String? department,
    List<String>? wards,
    String? contactInfo,
    List<String>? assignedComplaints,
  }) {
    return Employee(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      department: department ?? this.department,
      wardsName: wardsName ?? this.wardsName,
      contactInfo: contactInfo ?? this.contactInfo,
      assignedComplaints: assignedComplaints ?? this.assignedComplaints,
    );
  }

  /// Full name convenience getter
  String get fullName => '$firstName $lastName';
}
