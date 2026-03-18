import 'package:get_it/get_it.dart';

import '../network/network_client.dart';
import '../../features/detections/coordinators/detections_coordinator.dart';
import '../../features/flower/coordinators/flower_catalog_coordinator.dart';
import '../../features/home/coordinators/home_coordinator.dart';

/// Dependency injection container
final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton<NetworkClient>(() => NetworkClient());

  // Feature coordinators
  FlowerCatalogCoordinator().register(sl);
  HomeCoordinator().register(sl);
  DetectionsCoordinator().register(sl);
}
