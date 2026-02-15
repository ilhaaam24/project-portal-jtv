
import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/bookmark/domain/repositories/bookmark_repository.dart';

class DeleteSavedNews implements UseCase<bool, int> {
  final BookmarkRepository repository;

  DeleteSavedNews(this.repository);

  @override
  Future<Either<Failure, bool>> call(int idBerita) {
    return repository.deleteSavedNews(idBerita);
  }
}
