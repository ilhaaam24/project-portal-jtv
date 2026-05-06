import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/error/exceptions.dart';
import 'package:portal_jtv/features/auth/domain/entities/auth_entity.dart';
import 'package:portal_jtv/features/auth/domain/repositories/auth_repository.dart';
import 'package:portal_jtv/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:portal_jtv/features/auth/data/datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final remoteAuth = await remoteDataSource.login(
        email: email,
        password: password,
      );
      // Save token and user info locally upon successful login
      await localDataSource.saveAuth(remoteAuth);
      return Right(remoteAuth);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      // Typically handling network/connection errors, assuming NetworkFailure exists or using ServerFailure
      return const Left(
        ServerFailure(message: 'Terjadi kesalahan tidak terduga'),
      );
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getSavedAuth() async {
    try {
      final localAuth = await localDataSource.getAuth();
      if (localAuth != null) {
        return Right(localAuth);
      } else {
        return const Left(CacheFailure(message: 'Data sesi tidak ditemukan'));
      }
    } catch (e) {
      return const Left(
        CacheFailure(message: 'Gagal membaca sesi penyimpanan'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearAuth();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure(message: 'Gagal menghapus data sesi'));
    }
  }
}
