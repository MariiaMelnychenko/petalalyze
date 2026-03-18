/// Status of gallery permission
enum GalleryPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
}

/// Exception when gallery permission is permanently denied
class ImagePickerPermissionException implements Exception {
  const ImagePickerPermissionException({
    required this.status,
    required this.message,
  });

  final GalleryPermissionStatus status;
  final String message;

  bool get isPermanentlyDenied => status == GalleryPermissionStatus.permanentlyDenied;

  @override
  String toString() => 'ImagePickerPermissionException: $message';
}

/// Generic exception for image picker errors
class ImagePickerException implements Exception {
  ImagePickerException(this.message);

  final String message;

  @override
  String toString() => 'ImagePickerException: $message';
}
