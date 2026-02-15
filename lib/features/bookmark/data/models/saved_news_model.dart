import 'package:portal_jtv/features/bookmark/domain/entities/saved_news_entity.dart';

class SavedNewsModel extends SavedNewsEntity {
  const SavedNewsModel({
    required super.id,
    required super.idUser,
    required super.idBerita,
    required super.createdAt,
    required super.berita,
  });

  factory SavedNewsModel.fromJson(Map<String, dynamic> json) {
    return SavedNewsModel(
      id: json['id'] ?? 0,
      idUser: json['id_user'] ?? 0,
      idBerita: json['id_berita'] ?? 0,
      createdAt: json['created_at'] ?? '',
      berita: SavedNewsBeritaModel.fromJson(json['berita'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_user': idUser,
      'id_berita': idBerita,
      'created_at': createdAt,
      'berita': (berita as SavedNewsBeritaModel).toJson(),
    };
  }

  SavedNewsEntity toEntity() => this;
}

/// Model untuk data berita yang ter-embed
/// Perhatikan: field dari database langsung (snake_case, nama kolom asli)
class SavedNewsBeritaModel extends SavedNewsBeritaEntity {
  const SavedNewsBeritaModel({
    required super.idBerita,
    required super.title,
    required super.seo,
    super.photo,
    super.summary,
    super.date,
    super.category,
    super.seoCategory,
    super.author,
    super.seoAuthor,
    super.picAuthor,
  });

  /// ⚠️ PENTING: Field names mengikuti KOLOM DATABASE (bukan Resource)
  /// Karena SavedNewsController pakai ->get() tanpa Resource transform
  factory SavedNewsBeritaModel.fromJson(Map<String, dynamic> json) {
    return SavedNewsBeritaModel(
      idBerita: json['id_berita'] ?? 0,
      title: json['judul_berita'] ?? '', // kolom DB
      seo: json['seo_berita'] ?? '', // kolom DB
      photo: json['gambar_berita'], // kolom DB
      summary: json['rangkuman_berita'], // kolom DB
      date: json['date_publish_berita'], // kolom DB
      category: json['nama_kategori_berita'], // kolom DB
      seoCategory: json['seo_kategori_berita'], // kolom DB
      author: json['nama_author'], // kolom DB
      seoAuthor: json['seo_pengguna'], // kolom DB
      picAuthor: json['gambar_pengguna'], // kolom DB
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_berita': idBerita,
      'judul_berita': title,
      'seo_berita': seo,
      'gambar_berita': photo,
      'rangkuman_berita': summary,
      'date_publish_berita': date,
      'nama_kategori_berita': category,
      'seo_kategori_berita': seoCategory,
      'nama_author': author,
      'seo_pengguna': seoAuthor,
      'gambar_pengguna': picAuthor,
    };
  }
}
