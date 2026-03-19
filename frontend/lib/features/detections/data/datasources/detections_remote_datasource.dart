import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/device_id_service.dart';
import '../models/detect_response_model.dart';
import '../models/detection_list_item_model.dart';

abstract class DetectionsRemoteDatasource {
  Future<List<DetectionListItemModel>> getDetections();
  Future<DetectResponseModel> detectImage(String imagePath);
}

class DetectionsRemoteDatasourceImpl implements DetectionsRemoteDatasource {
  DetectionsRemoteDatasourceImpl({
    required Dio dio,
    required DeviceIdService deviceIdService,
  })  : _dio = dio,
        _deviceIdService = deviceIdService;

  final Dio _dio;
  final DeviceIdService _deviceIdService;

  @override
  Future<List<DetectionListItemModel>> getDetections() async {
    try {
      final deviceId = await _deviceIdService.getOrCreate();
      final response = await _dio.get(
        ApiEndpoints.detections,
        queryParameters: {'device_id': deviceId},
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) =>
              DetectionListItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }     on DioException catch (e) {
      throw e.error is Exception
          ? e.error as Exception
          : ServerException(e.message);
    }
  }

  @override
  Future<DetectResponseModel> detectImage(String imagePath) async {
    try {
      final deviceId = await _deviceIdService.getOrCreate();
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split(RegExp(r'[/\\]')).last,
        ),
        'device_id': deviceId,
      });
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.detect,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final data = response.data;
      if (data == null) {
        throw ServerException('Empty response from detect API');
      }
      return DetectResponseModel.fromJson(data);
    } on DioException catch (e) {
      throw e.error is Exception
          ? e.error as Exception
          : ServerException(e.message ?? 'Detect failed');
    }
  }
}
