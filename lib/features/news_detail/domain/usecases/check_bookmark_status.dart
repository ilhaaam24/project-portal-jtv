import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/news_detail/domain/repositories/detail_repository.dart';

class CheckBookmarkStatus implements UseCase<bool, int> {
  final DetailRepository repository;

  CheckBookmarkStatus(this.repository);

  @override
  Future<Either<Failure, bool>> call(int idBerita) {
    return repository.checkBookmarkStatus(idBerita);
  }
}
