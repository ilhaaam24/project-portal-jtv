// lib/features/live/data/repositories/live_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/livestream_entity.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../domain/repositories/live_repository.dart';
import '../datasources/live_remote_datasource.dart';

class LiveRepositoryImpl implements LiveRepository {
  final LiveRemoteDataSource remoteDataSource;

  LiveRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LivestreamEntity>> getLivestream() async {
    try {
      final result = await remoteDataSource.getLivestream();
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<ScheduleEntity>>> getLiveSchedule(
    int dayIndex,
  ) async {
    try {
      final result = await remoteDataSource.getLiveSchedule(dayIndex);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }
}
