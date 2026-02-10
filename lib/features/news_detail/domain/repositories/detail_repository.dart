import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/news_detail_entity.dart';
import '../entities/tag_entity.dart';

abstract class DetailRepository {
  Future<Either<Failure, DetailResult>> getNewsDetail(String seo);

  /// Kirim hit counter (tambah views)
  Future<Either<Failure, bool>> sendHitCounter({
    required String seo,
    required String tipe,
  });

  Future<Either<Failure, bool>> checkBookmarkStatus(int idBerita);

  Future<Either<Failure, bool>> saveBookmark(int idBerita);

  Future<Either<Failure, bool>> removeBookmark(int idBerita);
}

/// Wrapper yang menggabungkan detail berita + tags
class DetailResult extends Equatable {
  final NewsDetailEntity detail;
  final List<TagEntity> tags;

  const DetailResult({required this.detail, required this.tags});

  @override
  List<Object?> get props => [detail, tags];
}
