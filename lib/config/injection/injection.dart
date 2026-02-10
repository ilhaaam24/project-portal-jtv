import 'package:get_it/get_it.dart';
import 'package:portal_jtv/core/network/api_client.dart';
import 'package:portal_jtv/features/home/data/datasources/home_remote_datasource.dart';
import 'package:portal_jtv/features/home/data/repositories/home_repository_impl.dart';
import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';
import 'package:portal_jtv/features/home/domain/usecases/get_breaking_news.dart';
import 'package:portal_jtv/features/home/domain/usecases/get_headlines.dart';
import 'package:portal_jtv/features/home/domain/usecases/get_latest_news.dart';
import 'package:portal_jtv/features/home/domain/usecases/get_popular_news.dart';
import 'package:portal_jtv/features/home/domain/usecases/get_sorot.dart';
import 'package:portal_jtv/features/home/domain/usecases/get_videos.dart';
import 'package:portal_jtv/features/home/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  //============================================================
  // HOME FEATURE
  //============================================================
  // Bloc (Factory - instance baru setiap kali dipanggil)
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(
      getHeadlines: sl(),
      getBreakingNews: sl(),
      getLatestNews: sl(),
      getPopularNews: sl(),
      getSorot: sl(),
      getVideos: sl(),
    ),
  );
  // Use Cases (Lazy Singleton)
  sl.registerLazySingleton(() => GetHeadlines(sl()));
  sl.registerLazySingleton(() => GetBreakingNews(sl()));
  sl.registerLazySingleton(() => GetLatestNews(sl()));
  sl.registerLazySingleton(() => GetPopularNews(sl()));
  sl.registerLazySingleton(() => GetSorot(sl()));
  sl.registerLazySingleton(() => GetVideos(sl()));
  // Repository (Lazy Singleton)
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );
  // Data Sources (Lazy Singleton)
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(client: sl()),
  );
}
