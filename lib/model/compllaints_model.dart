class ComplaintModel {
  final int id;
  final String description;
  final String departmentName;
  final int? wardId; // Nullable since it can be null in API
  final String location;
  final List<String> imageUrls;
  final String submittedBy;
  final String status;
  final String? assignedEmployeeName; // Nullable since it can be null in API
  final DateTime createdAt;

  ComplaintModel({
    required this.id,
    required this.description,
    required this.departmentName,
    this.wardId,
    required this.location,
    required this.imageUrls,
    required this.submittedBy,
    required this.status,
    this.assignedEmployeeName,
    required this.createdAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] as int,
      description: json['description'] as String,
      departmentName: json['departmentName'] as String,
      wardId: json['wardId'] as int?,
      location: json['location'] as String,
      imageUrls: List<String>.from(json['imageUrls'] as List),
      submittedBy: json['submittedBy'] as String,
      status: json['status'] as String,
      assignedEmployeeName: json['assignedEmployeeName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'departmentName': departmentName,
      'wardId': wardId,
      'location': location,
      'imageUrls': imageUrls,
      'submittedBy': submittedBy,
      'status': status,
      'assignedEmployeeName': assignedEmployeeName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ComplaintModel{id: $id, description: $description, departmentName: $departmentName, wardId: $wardId, location: $location, imageUrls: $imageUrls, submittedBy: $submittedBy, status: $status, assignedEmployeeName: $assignedEmployeeName, createdAt: $createdAt}';
  }
}

// Helper method to parse a list of complaints from JSON array
class ComplaintListResponse {
  static List<ComplaintModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray
        .map((json) => ComplaintModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
