import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/features/bookmark/domain/entities/saved_news_entity.dart';

abstract class BookmarkRepository {
  Future<Either<Failure, List<SavedNewsEntity>>> getSavedNewsList();

  Future<Either<Failure, bool>> deleteSavedNews(int idBerita);
}
