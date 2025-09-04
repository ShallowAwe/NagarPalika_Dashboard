class Location {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String categoryName;

  Location({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.categoryName,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      categoryName: json['categoryName'],
    );
  }
}
