class Employee {
  final String firstName;
  final String lastName;
  final String department;
  final List<String> wards;
  final String contactInfo;
  final List<String> assignedComplaints;

  Employee({
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.wards,
    required this.contactInfo,
    required this.assignedComplaints,
  });

  /// Factory constructor to create Employee from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      firstName: json['firstname'] ?? '',
      lastName: json['lastname'] ?? '',
      department: json['department'] ?? '',
      wards: [], // Assuming this is not sent by API
      contactInfo: json['mobile'] ?? '',
      assignedComplaints: List<String>.from(json['assignedComplaints'] ?? []),
    );
  }

  /// Convert Employee object to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'department': department,
      'wards': wards,
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
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      department: department ?? this.department,
      wards: wards ?? this.wards,
      contactInfo: contactInfo ?? this.contactInfo,
      assignedComplaints: assignedComplaints ?? this.assignedComplaints,
    );
  }

  /// Full name convenience getter
  String get fullName => '$firstName $lastName';
}
