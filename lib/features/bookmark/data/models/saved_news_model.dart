import 'package:portal_jtv/features/bookmark/domain/entities/saved_news_entity.dart';

class SavedNewsModel extends SavedNewsEntity {
  const SavedNewsModel({
    required super.idSaved,
    required super.idBerita,
    required super.savedAt,
    required super.title,
    required super.seo,
    super.seoBiro,
    super.status,
    super.photo,
    super.summary,
    super.caption,
    super.city,
    super.date,
    super.category,
    super.seoCategory,
    super.tag,
    super.author,
    super.jabatanAuthor,
    super.seoAuthor,
    super.editor,
    super.picAuthor,
    super.isYoutube,
  });

  factory SavedNewsModel.fromJson(Map<String, dynamic> json) {
    return SavedNewsModel(
      idSaved: json['id_saved'] ?? 0,
      idBerita: json['id_berita'] ?? 0,
      savedAt: json['saved_at'] ?? '',
      title: json['title'] ?? '',
      seo: json['seo'] ?? '',
      seoBiro: json['seo_biro'],
      status: json['status'],
      photo: json['photo'],
      summary: json['summary'],
      caption: json['caption'],
      city: json['city'],
      date: json['date'],
      category: json['category'],
      seoCategory: json['seo_category'],
      tag: json['tag'],
      author: json['author'],
      jabatanAuthor: json['jabatan_author'],
      seoAuthor: json['seo_author'],
      editor: json['editor'],
      picAuthor: json['pic_author'],
      isYoutube: json['is_youtube'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_saved': idSaved,
      'id_berita': idBerita,
      'saved_at': savedAt,
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

  SavedNewsEntity toEntity() => this;
}
