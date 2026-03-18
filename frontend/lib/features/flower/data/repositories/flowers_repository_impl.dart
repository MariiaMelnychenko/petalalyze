import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/flower.dart';
import '../../domain/repositories/flowers_repository.dart';
import '../datasources/flowers_remote_datasource.dart';
import '../models/flower_model.dart';

class FlowersRepositoryImpl implements FlowersRepository {
  FlowersRepositoryImpl({FlowersRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? FlowersRemoteDatasourceImpl();

  final FlowersRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, List<Flower>>> getFlowers() async {
    try {
      final models = await _remoteDatasource.getFlowers();
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on DioException catch (_) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Flower>> getFlowerById(int id) async {
    try {
      final FlowerModel model = await _remoteDatasource.getFlowerById(id);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on DioException catch (_) {
      return const Left(NetworkFailure());
    }
  }
}
