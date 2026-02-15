import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/livestream_entity.dart';

abstract class LiveRepository {
  Future<Either<Failure, LivestreamEntity>> getLivestream();
}
