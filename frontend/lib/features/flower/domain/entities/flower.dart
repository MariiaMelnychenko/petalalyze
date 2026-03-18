import 'package:equatable/equatable.dart';

/// Pure Dart business entity for Flower
class Flower extends Equatable {
  const Flower({
    required this.id,
    required this.name,
    this.latinName,
    this.imageUrl,
    this.description,
    this.season,
  });

  final int id;
  final String name;
  final String? latinName;
  final String? imageUrl;
  final String? description;
  final String? season;

  @override
  List<Object?> get props => [id, name, latinName, imageUrl, description, season];
}
