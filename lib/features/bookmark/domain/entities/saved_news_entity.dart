import 'package:equatable/equatable.dart';

class SavedNewsEntity extends Equatable {
  final int id;
  final int idUser;
  final int idBerita;
  final String createdAt;
  final SavedNewsBeritaEntity berita; // Data berita yang ter-embed

  const SavedNewsEntity({
    required this.id,
    required this.idUser,
    required this.idBerita,
    required this.createdAt,
    required this.berita,
  });

  @override
  List<Object?> get props => [id, idUser, idBerita, createdAt, berita];
}

/// Data berita yang ter-embed dari relasi `with('berita')`
/// Hanya field yang dibutuhkan untuk tampilan card di list bookmark
class SavedNewsBeritaEntity extends Equatable {
  final int idBerita;
  final String title;
  final String seo;
  final String? photo;
  final String? summary;
  final String? date;
  final String? category;
  final String? seoCategory;
  final String? author;
  final String? seoAuthor;
  final String? picAuthor;

  const SavedNewsBeritaEntity({
    required this.idBerita,
    required this.title,
    required this.seo,
    this.photo,
    this.summary,
    this.date,
    this.category,
    this.seoCategory,
    this.author,
    this.seoAuthor,
    this.picAuthor,
  });

  @override
  List<Object?> get props => [
    idBerita,
    title,
    seo,
    photo,
    summary,
    date,
    category,
    seoCategory,
    author,
    seoAuthor,
    picAuthor,
  ];
}
