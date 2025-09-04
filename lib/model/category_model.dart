class Categories {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> locations;

  Categories({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.locations,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      locations: List<String>.from(json['locations'] ?? []),
    );
  }
}
