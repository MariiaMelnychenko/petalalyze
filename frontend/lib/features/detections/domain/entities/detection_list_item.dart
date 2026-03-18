/// Domain entity for detection list item
class DetectionListItem {
  const DetectionListItem({
    required this.id,
    required this.imageUrl,
    required this.resultImageUrl,
    required this.detectionsCount,
    required this.createdAt,
  });

  final int id;
  final String imageUrl;
  final String resultImageUrl;
  final int detectionsCount;
  final DateTime createdAt;
}
