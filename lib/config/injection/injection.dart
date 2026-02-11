import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import 'package:portal_jtv/core/network/api_client.dart';
import 'package:portal_jtv/core/utils/text_size_preferences.dart';
import 'package:portal_jtv/core/utils/text_to_speech.dart';
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

// ============ DETAIL FEATURE ============
import 'package:portal_jtv/features/news_detail/data/datasources/detail_remote_datasource.dart';
import 'package:portal_jtv/features/news_detail/data/repositories/detail_repository_impl.dart';
import 'package:portal_jtv/features/news_detail/domain/repositories/detail_repository.dart';
import 'package:portal_jtv/features/news_detail/domain/usecases/get_news_detail.dart';
import 'package:portal_jtv/features/news_detail/domain/usecases/send_hit_counter.dart';
import 'package:portal_jtv/features/news_detail/domain/usecases/check_bookmark_status.dart';
import 'package:portal_jtv/features/news_detail/domain/usecases/save_bookmark.dart';
import 'package:portal_jtv/features/news_detail/domain/usecases/remove_bookmark.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_bloc.dart';
import 'package:portal_jtv/features/news_detail/presentation/cubit/text_size_cubit.dart';
import 'package:portal_jtv/features/news_detail/presentation/cubit/text_to_speech_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final flutterTts = FlutterTts();

  sl.registerLazySingleton<FlutterTts>(() => flutterTts);

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // shared preferences

  // sl.registerLazySingletonAsync(
  //   () async => await SharedPreferences.getInstance(),
  // );

  sl.registerLazySingleton<TextSizePreferences>(
    () => TextSizePreferences(sl()),
  );
  sl.registerLazySingleton<TextToSpeech>(() => TextToSpeech(sl()));

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

  //============================================================
  // DETAIL FEATURE
  //============================================================

  // Bloc
  sl.registerFactory<DetailBloc>(
    () => DetailBloc(
      getNewsDetail: sl(),
      sendHitCounter: sl(),
      checkBookmarkStatus: sl(),
      saveBookmark: sl(),
      removeBookmark: sl(),
    ),
  );

  // Cubit
  sl.registerFactory<TextSizeCubit>(() => TextSizeCubit(sl()));
  sl.registerFactory<TextToSpeechCubit>(() => TextToSpeechCubit(sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetNewsDetail(sl()));
  sl.registerLazySingleton(() => SendHitCounter(sl()));
  sl.registerLazySingleton(() => CheckBookmarkStatus(sl()));
  sl.registerLazySingleton(() => SaveBookmark(sl()));
  sl.registerLazySingleton(() => RemoveBookmark(sl()));

  // Repository
  sl.registerLazySingleton<DetailRepository>(
    () => DetailRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<DetailRemoteDataSource>(
    () => DetailRemoteDataSourceImpl(client: sl()),
  );
}
