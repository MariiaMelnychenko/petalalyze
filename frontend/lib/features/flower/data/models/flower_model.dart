import '../../domain/entities/flower.dart';

/// DTO for Flower from API
class FlowerModel extends Flower {
  const FlowerModel({
    required super.id,
    required super.name,
    super.latinName,
    super.imageUrl,
    super.description,
    super.season,
  });

  factory FlowerModel.fromJson(Map<String, dynamic> json) {
    return FlowerModel(
      id: json['id'] as int,
      name: json['name'] as String,
      latinName: json['latin_name'] as String?,
      imageUrl: json['image_url'] as String?,
      description: json['description'] as String?,
      season: json['season'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latin_name': latinName,
      'image_url': imageUrl,
      'description': description,
      'season': season,
    };
  }
}
