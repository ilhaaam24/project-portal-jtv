import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';

abstract class UseCase<TypeResponse, Params> {
  Future<Either<Failure, TypeResponse>> call(Params params);
}

class NoParams {
  const NoParams();
}
