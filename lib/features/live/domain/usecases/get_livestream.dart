// lib/features/live/domain/usecases/get_livestream.dart

import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/live/domain/entities/livestream_entity.dart';
import 'package:portal_jtv/features/live/domain/repositories/live_repository.dart';

class GetLivestream implements UseCase<LivestreamEntity, NoParams> {
  final LiveRepository repository;

  GetLivestream(this.repository);

  @override
  Future<Either<Failure, LivestreamEntity>> call(NoParams params) {
    return repository.getLivestream();
  }
}
