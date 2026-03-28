import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/device_id_service.dart';
import '../models/detection_detail_model.dart';
import '../models/detection_list_item_model.dart';
import '../models/predict_response_model.dart';

abstract class DetectionsRemoteDatasource {
  Future<List<DetectionListItemModel>> getDetections();
  Future<DetectionDetailModel> getDetectionById(int id);
  Future<PredictResponseModel> predictImage(String imagePath);
  Future<void> deleteDetection(int id);
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
  Future<DetectionDetailModel> getDetectionById(int id) async {
    try {
      final response =
          await _dio.get<Map<String, dynamic>>('${ApiEndpoints.detections}/$id');
      final data = response.data;
      if (data == null) {
        throw ServerException('Empty response from detection details API');
      }
      return DetectionDetailModel.fromJson(data);
    } on DioException catch (e) {
      throw e.error is Exception
          ? e.error as Exception
          : ServerException(e.message ?? 'Load detection details failed');
    }
  }

  @override
  Future<PredictResponseModel> predictImage(String imagePath) async {
    try {
      final deviceId = await _deviceIdService.getOrCreate();
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split(RegExp(r'[/\\]')).last,
        ),
        'device_id': deviceId,
      });
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.predict,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final data = response.data;
      if (data == null) {
        throw ServerException('Empty response from predict API');
      }
      return PredictResponseModel.fromJson(data);
    } on DioException catch (e) {
      throw e.error is Exception
          ? e.error as Exception
          : ServerException(e.message ?? 'Prediction failed');
    }
  }

  @override
  Future<void> deleteDetection(int id) async {
    try {
      await _dio.delete('${ApiEndpoints.detections}/$id');
    } on DioException catch (e) {
      throw e.error is Exception
          ? e.error as Exception
          : ServerException(e.message ?? 'Delete failed');
    }
  }
}
