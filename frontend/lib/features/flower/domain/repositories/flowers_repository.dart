import '../entities/flower.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/error/failures.dart';

/// Abstract contract for flowers repository
abstract class FlowersRepository {
  Future<Either<Failure, List<Flower>>> getFlowers();
  Future<Either<Failure, Flower>> getFlowerById(int id);
}
