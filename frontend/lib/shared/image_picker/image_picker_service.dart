import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'image_picker_exceptions.dart';

/// Centralized service for picking and capturing images
class ImagePickerService {
  ImagePickerService({
    ImagePicker? picker,
    DeviceInfoPlugin? deviceInfo,
  })  : _picker = picker ?? ImagePicker(),
        _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  final ImagePicker _picker;
  final DeviceInfoPlugin _deviceInfo;

  /// Request gallery permission. Returns granted, denied, or permanentlyDenied.
  Future<GalleryPermissionStatus> _requestGalleryPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      final sdk = androidInfo.version.sdkInt;
      final permission = sdk >= 33 ? Permission.photos : Permission.storage;
      final status = await permission.status;
      if (status.isGranted) return GalleryPermissionStatus.granted;
      if (status.isPermanentlyDenied) return GalleryPermissionStatus.permanentlyDenied;
      final result = await permission.request();
      if (result.isGranted) return GalleryPermissionStatus.granted;
      if (result.isPermanentlyDenied) return GalleryPermissionStatus.permanentlyDenied;
      return GalleryPermissionStatus.denied;
    }
    if (Platform.isIOS) {
      final status = await Permission.photos.status;
      if (status.isGranted) return GalleryPermissionStatus.granted;
      if (status.isPermanentlyDenied) return GalleryPermissionStatus.permanentlyDenied;
      final result = await Permission.photos.request();
      if (result.isGranted) return GalleryPermissionStatus.granted;
      if (result.isPermanentlyDenied) return GalleryPermissionStatus.permanentlyDenied;
      return GalleryPermissionStatus.denied;
    }
    return GalleryPermissionStatus.granted;
  }

  /// Request camera permission
  Future<GalleryPermissionStatus> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return GalleryPermissionStatus.granted;
    if (status.isPermanentlyDenied) return GalleryPermissionStatus.permanentlyDenied;
    final result = await Permission.camera.request();
    if (result.isGranted) return GalleryPermissionStatus.granted;
    if (result.isPermanentlyDenied) return GalleryPermissionStatus.permanentlyDenied;
    return GalleryPermissionStatus.denied;
  }

  /// Pick a single image from gallery.
  /// Returns file path or null if user cancelled.
  /// Throws [ImagePickerPermissionException] when permission permanently denied.
  /// Throws [ImagePickerException] on other errors.
  Future<String?> pickSingleImage({int imageQuality = 85}) async {
    final permissionStatus = await _requestGalleryPermission();
    switch (permissionStatus) {
      case GalleryPermissionStatus.granted:
        break;
      case GalleryPermissionStatus.denied:
        return null;
      case GalleryPermissionStatus.permanentlyDenied:
        throw const ImagePickerPermissionException(
          status: GalleryPermissionStatus.permanentlyDenied,
          message: 'Gallery permission permanently denied',
        );
    }
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
      );
      return picked?.path;
    } catch (e) {
      throw ImagePickerException('Failed to pick image: $e');
    }
  }

  /// Take a photo with camera.
  /// Returns file path or null if user cancelled.
  /// Throws [ImagePickerPermissionException] when permission permanently denied.
  /// Throws [ImagePickerException] on other errors.
  Future<String?> takePhoto({int imageQuality = 85}) async {
    final permissionStatus = await _requestCameraPermission();
    switch (permissionStatus) {
      case GalleryPermissionStatus.granted:
        break;
      case GalleryPermissionStatus.denied:
        return null;
      case GalleryPermissionStatus.permanentlyDenied:
        throw const ImagePickerPermissionException(
          status: GalleryPermissionStatus.permanentlyDenied,
          message: 'Camera permission permanently denied',
        );
    }
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
      );
      return picked?.path;
    } catch (e) {
      throw ImagePickerException('Failed to take photo: $e');
    }
  }
}
