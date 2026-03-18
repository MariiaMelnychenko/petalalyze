import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/flower_model.dart';

/// Remote data source for flowers API
abstract class FlowersRemoteDatasource {
  Future<List<FlowerModel>> getFlowers();
  Future<FlowerModel> getFlowerById(int id);
}

class FlowersRemoteDatasourceImpl implements FlowersRemoteDatasource {
  FlowersRemoteDatasourceImpl({Dio? dio}) : _dio = dio ?? ApiClient.client.dio;

  final Dio _dio;

  @override
  Future<List<FlowerModel>> getFlowers() async {
    try {
      final response = await _dio.get(ApiEndpoints.flowers);
      final list = response.data as List<dynamic>;
      return list.map((e) => FlowerModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw e.error is Exception ? e.error as Exception : ServerException(e.message);
    }
  }

  @override
  Future<FlowerModel> getFlowerById(int id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.flowers}/$id');
      return FlowerModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException('Flower not found');
      }
      throw e.error is Exception ? e.error as Exception : ServerException(e.message);
    }
  }
}
