// Removed dart:convert and dart:typed_data imports

class Fragrance {
  final String id;
  final String name;
  final String house;
  final String picture; // Now stores the asset path

  Fragrance({
    required this.id,
    required this.name,
    required this.house,
    required this.picture,
  });

  // Removed pictureBytes getter

  factory Fragrance.fromJson(Map<String, dynamic> json) {
    return Fragrance(
      id: json['id'] as String,
      name: json['name'] as String,
      house: json['house'] as String,
      picture: json['picture'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'house': house,
      'picture': picture,
    };
  }
}
