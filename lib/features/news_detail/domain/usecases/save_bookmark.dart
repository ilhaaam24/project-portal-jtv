import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/news_detail/domain/repositories/detail_repository.dart';

class SaveBookmark implements UseCase<bool, int> {
  final DetailRepository repository;

  SaveBookmark(this.repository);

  @override
  Future<Either<Failure, bool>> call(int idBerita) {
    return repository.saveBookmark(idBerita);
  }
}
