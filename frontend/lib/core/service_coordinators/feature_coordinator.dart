import 'package:get_it/get_it.dart';

import 'dependency_registration.dart';

/// Base class for feature coordinators.
/// Each feature has its own coordinator that declares its dependencies.
abstract class BaseFeatureCoordinator {
  /// List of dependency registrations for this feature
  List<DependencyRegistration> get dependencies;

  /// Register all dependencies in [sl]
  void register(GetIt sl) {
    for (final dep in dependencies) {
      dep.register(sl);
    }
  }
}
