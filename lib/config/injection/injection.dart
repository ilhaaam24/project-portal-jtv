import 'package:get_it/get_it.dart';
import 'package:portal_jtv/core/network/api_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Data source
  // Repository
  // Usecase
  // Bloc
}
