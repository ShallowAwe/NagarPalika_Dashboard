class ComplaintModel {
  final int id;
  final String description;
  final String departmentName;
  final int? wardId; // Nullable since it can be null in API
  final String? wardName; // Optional: present in API response
  final String location;
  final List<String> imageUrls;
  final List<String> videoUrls; // Optional: present in API response
  final String submittedBy;
  final String status;
  final String? assignedEmployeeName; // Nullable since it can be null in API
  final DateTime createdAt;
  final String? employeeRemark; // Optional: remarks from employee
  final List<String> employeeImages; // Optional: images from employee
  final DateTime? completedAt; // Optional: completion timestamp

  ComplaintModel({
    required this.id,
    required this.description,
    required this.departmentName,
    this.wardId,
    this.wardName,
    required this.location,
    required this.imageUrls,
    this.videoUrls = const [],
    required this.submittedBy,
    required this.status,
    this.assignedEmployeeName,
    required this.createdAt,
    this.employeeRemark,
    this.employeeImages = const [],
    this.completedAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] as int,
      description: json['description'] as String,
      departmentName: json['departmentName'] as String,
      wardId: json['wardId'] as int?,
      wardName: json['wardName'] as String?,
      location: json['location'] as String,
      imageUrls: (json['imageUrls'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      videoUrls: (json['videoUrls'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      submittedBy: json['submittedBy'] as String,
      status: json['status'] as String,
      assignedEmployeeName: json['assignedEmployeeName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      employeeRemark: json['employeeRemark'] as String?,
      employeeImages: (json['employeeImages'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      completedAt: (json['completedAt'] != null && (json['completedAt'] as String).isNotEmpty)
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'departmentName': departmentName,
      'wardId': wardId,
      'wardName': wardName,
      'location': location,
      'imageUrls': imageUrls,
      'videoUrls': videoUrls,
      'submittedBy': submittedBy,
      'status': status,
      'assignedEmployeeName': assignedEmployeeName,
      'createdAt': createdAt.toIso8601String(),
      'employeeRemark': employeeRemark,
      'employeeImages': employeeImages,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ComplaintModel{id: $id, description: $description, departmentName: $departmentName, wardId: $wardId, wardName: $wardName, location: $location, imageUrls: $imageUrls, videoUrls: $videoUrls, submittedBy: $submittedBy, status: $status, assignedEmployeeName: $assignedEmployeeName, createdAt: $createdAt, employeeRemark: $employeeRemark, employeeImages: $employeeImages, completedAt: $completedAt}';
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
