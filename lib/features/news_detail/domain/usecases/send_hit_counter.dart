import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/news_detail/domain/repositories/detail_repository.dart';

class SendHitCounter implements UseCase<bool, HitCounterParams> {
  final DetailRepository repository;

  SendHitCounter(this.repository);

  @override
  Future<Either<Failure, bool>> call(HitCounterParams params) {
    return repository.sendHitCounter(seo: params.seo, tipe: params.tipe);
  }
}

class HitCounterParams {
  final String seo;
  final String tipe;

  const HitCounterParams({required this.seo, this.tipe = 'mobile'});
}
