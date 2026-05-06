import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/live/domain/entities/schedule_entity.dart';
import 'package:portal_jtv/features/live/domain/repositories/live_repository.dart';

class GetLiveSchedule implements UseCase<List<ScheduleEntity>, int> {
  final LiveRepository repository;

  GetLiveSchedule(this.repository);

  @override
  Future<Either<Failure, List<ScheduleEntity>>> call(int dayIndex) {
    return repository.getLiveSchedule(dayIndex);
  }
}
