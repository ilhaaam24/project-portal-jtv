import 'package:portal_jtv/features/news_detail/domain/entities/news_detail_entity.dart';

class NewsDetailModel extends NewsDetailEntity {
  const NewsDetailModel({
    required super.idBerita,
    required super.title,
    required super.seoBiro,
    required super.seo,
    required super.content,
    required super.summary,
    required super.photo,
    required super.caption,
    super.tag,
    required super.status,
    required super.city,
    required super.date,
    required super.category,
    required super.seoCategory,
    super.user,
    super.navbar,
    super.seoNavbar,
    required super.author,
    super.jabatanAuthor,
    required super.seoAuthor,
    super.picAuthor,
    super.descAuthor,
    required super.hit,
    super.editorBerita,
    super.tipeGambarUtama,
  });

  factory NewsDetailModel.fromJson(Map<String, dynamic> json) {
    return NewsDetailModel(
      idBerita: json['id_berita'] is int
          ? json['id_berita']
          : int.tryParse(json['id_berita']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      seoBiro: json['seo_biro']?.toString() ?? '',
      seo: json['seo']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
      caption: json['caption']?.toString() ?? '',
      tag: json['tag']?.toString(),
      status: json['status']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      seoCategory: json['seo_category']?.toString() ?? '',
      user: json['user']?.toString(),
      navbar: json['navbar']?.toString(),
      seoNavbar: json['seo_navbar']?.toString(),
      author: json['author']?.toString() ?? '',
      jabatanAuthor: json['jabatan_author']?.toString(),
      seoAuthor: json['seo_author']?.toString() ?? '',
      picAuthor: json['pic_author']?.toString(),
      descAuthor: json['desc_author']?.toString(),
      hit: json['hit'] is int
          ? json['hit']
          : int.tryParse(json['hit']?.toString() ?? '0') ?? 0,
      editorBerita: json['editor_berita']?.toString(),
      tipeGambarUtama: json['tipe_gambar_utama']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_berita': idBerita,
      'title': title,
      'seo_biro': seoBiro,
      'seo': seo,
      'content': content,
      'summary': summary,
      'photo': photo,
      'caption': caption,
      'tag': tag,
      'status': status,
      'city': city,
      'date': date,
      'category': category,
      'seo_category': seoCategory,
      'user': user,
      'navbar': navbar,
      'seo_navbar': seoNavbar,
      'author': author,
      'jabatan_author': jabatanAuthor,
      'seo_author': seoAuthor,
      'pic_author': picAuthor,
      'desc_author': descAuthor,
      'hit': hit,
      'editor_berita': editorBerita,
      'tipe_gambar_utama': tipeGambarUtama,
    };
  }

  NewsDetailEntity toEntity() => this;
}
