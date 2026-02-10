
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
      idBerita: json['id_berita'] ?? 0,
      title: json['title'] ?? '',
      seoBiro: json['seo_biro'] ?? '',
      seo: json['seo'] ?? '',
      content: json['content'] ?? '',
      summary: json['summary'] ?? '',
      photo: json['photo'] ?? '',
      caption: json['caption'] ?? '',
      tag: json['tag'],
      status: json['status'] ?? '',
      city: json['city'] ?? '',
      date: json['date'] ?? '',
      category: json['category'] ?? '',
      seoCategory: json['seo_category'] ?? '',
      user: json['user'],
      navbar: json['navbar'],
      seoNavbar: json['seo_navbar'],
      author: json['author'] ?? '',
      jabatanAuthor: json['jabatan_author'],
      seoAuthor: json['seo_author'] ?? '',
      picAuthor: json['pic_author'],
      descAuthor: json['desc_author'],
      hit: json['hit'] ?? 0,
      editorBerita: json['editor_berita'],
      tipeGambarUtama: json['tipe_gambar_utama'],
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
