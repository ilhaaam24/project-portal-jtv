import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import 'package:portal_jtv/core/network/api_client.dart';
import 'package:portal_jtv/core/services/notification_service.dart';
import 'package:portal_jtv/core/services/shared_preferences_service.dart';
import 'package:portal_jtv/core/utils/text_size_preferences.dart';
import 'package:portal_jtv/core/utils/text_to_speech.dart';
import 'package:portal_jtv/features/bookmark/data/datasources/bookmark_remote_datasource.dart';
import 'package:portal_jtv/features/bookmark/data/repositories/bookmark_repository_impl.dart';
import 'package:portal_jtv/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:portal_jtv/features/bookmark/domain/usecases/delete_saved_news.dart';
import 'package:portal_jtv/features/bookmark/domain/usecases/get_saved_news_list.dart';
import 'package:portal_jtv/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:portal_jtv/features/category/data/datasources/category_remote_datasource.dart';
import 'package:portal_jtv/features/category/data/repositories/category_repository_impl.dart';
import 'package:portal_jtv/features/category/domain/repositories/category_repository.dart';
import 'package:portal_jtv/features/category/domain/usecases/get_categories.dart';
import 'package:portal_jtv/features/category/domain/usecases/get_news_by_category.dart';
import 'package:portal_jtv/features/category/presentation/bloc/category_bloc.dart';
import 'package:portal_jtv/features/category/presentation/bloc/category_news/category_news_bloc.dart';
import 'package:portal_jtv/features/home/data/datasources/home_remote_datasource.dart';
import 'package:portal_jtv/features/home/data/repositories/home_repository_impl.dart';
import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';
import 'package:portal_jtv/features/home/domain/usecases/get_breaking_news.dart';
import 'package:portal_jtv/features/home/domain/usecases/get_for_you.dart';
import 'package:portal_jtv/features/home/domain/usecases/get_headlines.dart';
import 'package:portal_jtv/features/home/domain/usecases/get_latest_news.dart';
import 'package:portal_jtv/features/home/domain/usecases/get_popular_news.dart';
import 'package:portal_jtv/features/home/domain/usecases/get_sorot.dart';
import 'package:portal_jtv/features/home/domain/usecases/get_videos.dart';
import 'package:portal_jtv/features/home/presentation/bloc/foryou/for_you_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/populer/populer_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_bloc.dart';
import 'package:portal_jtv/features/live/data/datasources/live_remote_datasource.dart';
import 'package:portal_jtv/features/live/data/repositories/live_repository_impl.dart';
import 'package:portal_jtv/features/live/domain/repositories/live_repository.dart';
import 'package:portal_jtv/features/live/domain/usecases/get_livestream.dart';
import 'package:portal_jtv/features/live/domain/usecases/get_live_schedule.dart';
import 'package:portal_jtv/features/live/presentation/bloc/live_bloc.dart';

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
import 'package:portal_jtv/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:portal_jtv/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:portal_jtv/features/profile/domain/repositories/profile_repository.dart';
import 'package:portal_jtv/features/profile/domain/usecases/get_profile.dart';
import 'package:portal_jtv/features/profile/domain/usecases/logout.dart';
import 'package:portal_jtv/features/profile/domain/usecases/update_profile.dart';
import 'package:portal_jtv/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:portal_jtv/features/profile/presentation/cubit/language_cubit.dart';
import 'package:portal_jtv/features/profile/presentation/cubit/notification_cubit.dart';
import 'package:portal_jtv/features/profile/presentation/cubit/theme_cubit.dart';
import 'package:portal_jtv/features/search/data/datasources/search_remote_datasource.dart';
import 'package:portal_jtv/features/search/data/repositories/search_repository_impl.dart';
import 'package:portal_jtv/features/search/domain/repositories/search_repository.dart';
import 'package:portal_jtv/features/search/domain/usecases/search_news.dart';
import 'package:portal_jtv/features/search/presentation/bloc/search_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============ VIDEO DETAIL FEATURE ============
import 'package:portal_jtv/features/video_detail/data/datasources/video_remote_datasource.dart';
import 'package:portal_jtv/features/video_detail/data/repositories/video_repository_impl.dart';
import 'package:portal_jtv/features/video_detail/domain/repositories/video_repository.dart';
import 'package:portal_jtv/features/video_detail/domain/usecases/get_paginated_videos.dart';
import 'package:portal_jtv/features/video_detail/presentation/bloc/video_detail_bloc.dart';

// ============ COMMENT FEATURE ============
import 'package:portal_jtv/features/comment/data/datasources/comment_remote_datasource.dart';
import 'package:portal_jtv/features/comment/data/repositories/comment_repository_impl.dart';
import 'package:portal_jtv/features/comment/domain/repositories/comment_repository.dart';
import 'package:portal_jtv/features/comment/domain/usecases/get_comments.dart';
import 'package:portal_jtv/features/comment/domain/usecases/post_comment.dart';
import 'package:portal_jtv/features/comment/domain/usecases/update_comment.dart';
import 'package:portal_jtv/features/comment/domain/usecases/delete_comment.dart';
import 'package:portal_jtv/features/comment/domain/usecases/toggle_comment_like.dart';
import 'package:portal_jtv/features/comment/presentation/bloc/comment_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final flutterTts = FlutterTts();

  sl.registerLazySingleton<FlutterTts>(() => flutterTts);

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(sl()),
  );
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

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
  sl.registerFactory<PopulerBloc>(() => PopulerBloc(getPopuler: sl()));
  sl.registerFactory<ForYouBloc>(() => ForYouBloc(getForYou: sl()));

  // Use Cases (Lazy Singleton)
  sl.registerLazySingleton(() => GetHeadlines(sl()));
  sl.registerLazySingleton(() => GetBreakingNews(sl()));
  sl.registerLazySingleton(() => GetLatestNews(sl()));
  sl.registerLazySingleton(() => GetPopuler(sl()));
  sl.registerLazySingleton(() => GetSorot(sl()));
  sl.registerLazySingleton(() => GetVideos(sl()));
  sl.registerLazySingleton(() => GetForYou(sl()));
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

  //============================================================
  // BOOKMARK FEATURE
  //============================================================
  // Bloc
  sl.registerFactory<BookmarkBloc>(
    () => BookmarkBloc(getSavedNewsList: sl(), deleteSavedNews: sl()),
  );
  // Use Cases
  sl.registerLazySingleton(() => GetSavedNewsList(sl()));
  sl.registerLazySingleton(() => DeleteSavedNews(sl()));
  // Repository
  sl.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(remoteDataSource: sl()),
  );
  // Data Sources
  sl.registerLazySingleton<BookmarkRemoteDataSource>(
    () => BookmarkRemoteDataSourceImpl(client: sl()),
  );

  //============================================================
  // PROFILE FEATURE
  //============================================================

  // Bloc
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getProfile: sl(),
      updateProfile: sl(),
      logout: sl(),
      prefs: sl(),
    ),
  );
  // Cubits (Singleton — shared across app)
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()));
  sl.registerLazySingleton<LanguageCubit>(() => LanguageCubit(sl()));
  sl.registerLazySingleton<NotificationCubit>(() => NotificationCubit(sl()));
  // Use Cases
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );
  // Data Sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(client: sl()),
  );

  //============================================================
  // SEARCH FEATURE
  //============================================================

  // Bloc
  sl.registerFactory<SearchBloc>(
    () => SearchBloc(searchNews: sl(), prefs: sl()),
  );
  // Use Cases
  sl.registerLazySingleton(() => SearchNews(sl()));
  // Repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl()),
  );
  // Data Sources
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(client: sl()),
  );

  // Tambahkan di injection.dart

  // ============ LIVE FEATURE ============

  sl.registerFactory<LiveBloc>(
    () => LiveBloc(getLivestream: sl(), getLiveSchedule: sl()),
  );

  sl.registerLazySingleton(() => GetLivestream(sl()));
  sl.registerLazySingleton(() => GetLiveSchedule(sl()));

  sl.registerLazySingleton<LiveRepository>(
    () => LiveRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<LiveRemoteDataSource>(
    () => LiveRemoteDataSourceImpl(client: sl()),
  );

  // ============ CATEGORY FEATURE ============
  sl.registerFactory<CategoryBloc>(() => CategoryBloc(getCategories: sl()));
  sl.registerFactory<CategoryNewsBloc>(
    () => CategoryNewsBloc(getNewsByCategory: sl()),
  );
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetNewsByCategory(sl()));
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(client: sl()),
  );

  // ============ VIDEO DETAIL FEATURE ============

  sl.registerFactory<VideoDetailBloc>(
    () => VideoDetailBloc(getPaginatedVideos: sl()),
  );
  sl.registerLazySingleton(() => GetPaginatedVideos(sl()));
  sl.registerLazySingleton<VideoRepository>(
    () => VideoRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<VideoRemoteDataSource>(
    () => VideoRemoteDataSourceImpl(client: sl()),
  );

  // ============ NOTIFICATION SERVICE ============
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(sl()),
  );

  // ============ COMMENT FEATURE ============

  // Bloc
  sl.registerFactory<CommentBloc>(
    () => CommentBloc(
      getComments: sl(),
      postComment: sl(),
      deleteComment: sl(),
      toggleCommentLike: sl(),
    ),
  );
  // Use Cases
  sl.registerLazySingleton(() => GetComments(sl()));
  sl.registerLazySingleton(() => PostComment(sl()));
  sl.registerLazySingleton(() => UpdateComment(sl()));
  sl.registerLazySingleton(() => DeleteComment(sl()));
  sl.registerLazySingleton(() => ToggleCommentLike(sl()));
  // Repository
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(remoteDataSource: sl()),
  );
  // Data Sources
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSourceImpl(client: sl()),
  );
}
