import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/home/domain/entities/sorot_entity.dart';
import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';

class GetSorot implements UseCase<List<SorotEntity>, SorotParams> {
  final HomeRepository homeRepository;
  const GetSorot(this.homeRepository);

  @override
  Future<Either<Failure, List<SorotEntity>>> call(SorotParams params) {
    return homeRepository.getSorot(limit: params.limit);
  }
}

class SorotParams {
  final int limit;
  SorotParams({this.limit = 5});
}
