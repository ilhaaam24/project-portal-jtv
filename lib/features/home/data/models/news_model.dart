import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';

class NewsModel extends NewsEntity {
  const NewsModel({
    required super.idBerita,
    required super.title,
    required super.seo,
    required super.seoBiro,
    required super.status,
    required super.photo,
    required super.summary,
    required super.caption,
    required super.city,
    required super.date,
    required super.category,
    required super.seoCategory,
    super.tag,
    required super.author,
    super.jabatanAuthor,
    required super.seoAuthor,
    super.editor,
    required super.picAuthor,
    required super.isYoutube,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      idBerita: json['id_berita'] is int
          ? json['id_berita']
          : int.tryParse(json['id_berita']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      seo: json['seo']?.toString() ?? '',
      seoBiro: json['seo_biro']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      caption: json['caption']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      seoCategory: json['seo_category']?.toString() ?? '',
      tag: json['tag']?.toString(),
      author: json['author']?.toString() ?? '',
      jabatanAuthor: json['jabatan_author']?.toString(),
      seoAuthor: json['seo_author']?.toString() ?? '',
      editor: json['editor']?.toString(),
      picAuthor: json['pic_author']?.toString() ?? '',
      isYoutube: json['is_youtube'] == 1 ||
          json['is_youtube'] == true ||
          json['is_youtube']?.toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_berita': idBerita,
      'title': title,
      'seo': seo,
      'seo_biro': seoBiro,
      'status': status,
      'photo': photo,
      'summary': summary,
      'caption': caption,
      'city': city,
      'date': date,
      'category': category,
      'seo_category': seoCategory,
      'tag': tag,
      'author': author,
      'jabatan_author': jabatanAuthor,
      'seo_author': seoAuthor,
      'editor': editor,
      'pic_author': picAuthor,
      'is_youtube': isYoutube,
    };
  }

  // Convert to Entity
  NewsEntity toEntity() => this;
}
