import 'package:flutter/material.dart';
import 'package:smart_nagarpalika_dashboard/model/userModel.dart';

class ComplaintModel {
  final int id;
  final String description;
  final String category;
  final String location;
  final List<String> imageUrls;
  final DateTime createdAt;
  final String submittedBy;
  final double latitude;
  final double longitude;
  final ComplaintStatus status;
  final UserModel? user; // Optional user relationship

  ComplaintModel({
    required this.id,
    required this.description,
    required this.category,
    required this.location,
    required this.imageUrls,
    required this.createdAt,
    required this.submittedBy,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.user, // Optional user relationship
  });

  // Factory constructor to parse from JSON
  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'],
      description: json['description'],
      category: json['category'],
      location: json['location'],
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      submittedBy: json['submittedBy'],
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      status: ComplaintStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == json['status'].toString().toLowerCase(),
        orElse: () => ComplaintStatus.PENDING,
      ),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  // To convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'category': category,
      'location': location,
      'imageUrls': imageUrls,
      'createdAt': createdAt.toIso8601String(),
      'submittedBy': submittedBy,
      'latitude': latitude,
      'longitude': longitude,
      'status': status.name,
      'user': user?.toJson(),
    };
  }

  // Copy with method for updating specific fields
  ComplaintModel copyWith({
    int? id,
    String? description,
    String? category,
    String? location,
    List<String>? imageUrls,
    DateTime? createdAt,
    String? submittedBy,
    double? latitude,
    double? longitude,
    ComplaintStatus? status,
    UserModel? user,
  }) {
    return ComplaintModel(
      id: id ?? this.id,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      submittedBy: submittedBy ?? this.submittedBy,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  // Get status display name
  String get statusDisplayName {
    switch (status) {
      case ComplaintStatus.PENDING:
        return 'Pending';
      case ComplaintStatus.IN_PROGRESS:
        return 'In Progress';
      case ComplaintStatus.RESOLVED:
        return 'Resolved';
    }
  }

  // Get status color
  Color get statusColor {
    switch (status) {
      case ComplaintStatus.PENDING:
        return const Color(0xFFFF6B6B); // Red
      case ComplaintStatus.IN_PROGRESS:
        return const Color(0xFF4ECDC4); // Blue
      case ComplaintStatus.RESOLVED:
        return const Color(0xFF45B7D1); // Green
    }
  }

  // Get category display name
  String get categoryDisplayName {
    switch (category.toLowerCase()) {
      case 'water_supply':
        return 'Water Supply';
      case 'road_maintenance':
        return 'Road Maintenance';
      case 'street_lighting':
        return 'Street Lighting';
      case 'garbage_collection':
        return 'Garbage Collection';
      case 'drainage':
        return 'Drainage';
      case 'public_health':
        return 'Public Health';
      case 'traffic_management':
        return 'Traffic Management';
      case 'parks_recreation':
        return 'Parks & Recreation';
      case 'law_enforcement':
        return 'Law Enforcement';
      case 'public_facilities':
        return 'Public Facilities';
      case 'animal_control':
        return 'Animal Control';
      case 'public_transport':
        return 'Public Transport';
      case 'construction_management':
        return 'Construction Management';
      default:
        return category
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (word) => word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                  : '',
            )
            .join(' ');
    }
  }
}

enum ComplaintStatus { PENDING, IN_PROGRESS, RESOLVED }
