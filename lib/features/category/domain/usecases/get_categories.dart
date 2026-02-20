
import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/category_repository.dart';

class GetCategories implements UseCase<CategoryPageData, NoParams> {
  final CategoryRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, CategoryPageData>> call(NoParams params) {
    return repository.getCategories();
  }
}
