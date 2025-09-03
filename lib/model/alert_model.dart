class AlertModel {
  final int id;
  final String title;
  final String description;
  final String type;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isActive;

  AlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.imageUrl,
    required this.createdAt,
    this.isActive = true,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  AlertModel copyWith({
    int? id,
    String? title,
    String? description,
    String? type,
    String? imageUrl,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return AlertModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
