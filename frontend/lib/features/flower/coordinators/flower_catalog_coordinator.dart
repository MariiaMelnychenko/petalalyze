import 'package:petalalyze/core/di/injection.dart';
import 'package:petalalyze/core/network/network_client.dart';
import 'package:petalalyze/core/service_coordinators/feature_coordinator.dart';
import 'package:petalalyze/core/service_coordinators/dependency_registration.dart';
import 'package:petalalyze/features/flower/data/datasources/flowers_remote_datasource.dart';
import 'package:petalalyze/features/flower/data/repositories/flowers_repository_impl.dart';
import 'package:petalalyze/features/flower/domain/repositories/flowers_repository.dart';
import 'package:petalalyze/features/flower/presentation/cubit/flower_details_cubit.dart';
import 'package:petalalyze/features/flower/presentation/cubit/flowers_catalog_cubit.dart';

/// Coordinator for Flower Catalog feature.
/// Manages dependency injection for catalog and flower details.
class FlowerCatalogCoordinator extends BaseFeatureCoordinator {
  @override
  List<DependencyRegistration> get dependencies => [
        // Data sources
        DependencyRegistration<FlowersRemoteDatasource>(
          () => FlowersRemoteDatasourceImpl(dio: sl<NetworkClient>().dio),
        ),

        // Repositories
        DependencyRegistration<FlowersRepository>(
          () => FlowersRepositoryImpl(remoteDatasource: sl()),
        ),

        // Cubits
        DependencyRegistration<FlowersCatalogCubit>(
          () => FlowersCatalogCubit(sl<FlowersRepository>()),
          isFactory: true,
        ),
        DependencyRegistration<FlowerDetailsCubit>(
          () => FlowerDetailsCubit(sl<FlowersRepository>()),
          isFactory: true,
        ),
      ];
}
