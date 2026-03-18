import 'package:get_it/get_it.dart';

/// Registration descriptor for a dependency in GetIt
class DependencyRegistration<T extends Object> {
  const DependencyRegistration(
    this.factory, {
    this.isFactory = false,
  });

  final T Function() factory;
  final bool isFactory;

  /// Register this dependency in [sl]
  void register(GetIt sl) {
    if (isFactory) {
      sl.registerFactory<T>(factory);
    } else {
      sl.registerLazySingleton<T>(factory);
    }
  }
}
