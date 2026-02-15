import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/bookmark/domain/entities/saved_news_entity.dart';
import 'package:portal_jtv/features/bookmark/domain/repositories/bookmark_repository.dart';

class GetSavedNewsList implements UseCase<List<SavedNewsEntity>, NoParams> {
  final BookmarkRepository repository;

  GetSavedNewsList(this.repository);

  @override
  Future<Either<Failure, List<SavedNewsEntity>>> call(NoParams params) {
    return repository.getSavedNewsList();
  }
}
