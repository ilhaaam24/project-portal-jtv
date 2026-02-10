import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';

class NewsModel extends NewsEntity {
  const NewsModel({
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
      title: json['title'] ?? '',
      seo: json['seo'] ?? '',
      seoBiro: json['seo_biro'] ?? '',
      status: json['status'] ?? '',
      photo: json['photo'] ?? '',
      summary: json['summary'] ?? '',
      caption: json['caption'] ?? '',
      city: json['city'] ?? '',
      date: json['date'] ?? '',
      category: json['category'] ?? '',
      seoCategory: json['seo_category'] ?? '',
      tag: json['tag'],
      author: json['author'] ?? '',
      jabatanAuthor: json['jabatan_author'],
      seoAuthor: json['seo_author'] ?? '',
      editor: json['editor'],
      picAuthor: json['pic_author'] ?? '',
      isYoutube: json['is_youtube'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
