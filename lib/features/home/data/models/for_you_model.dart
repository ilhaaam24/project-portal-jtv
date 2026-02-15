
import 'package:portal_jtv/features/home/domain/entities/for_you_entity.dart';

class ForYouModel extends ForYouEntity {
  const ForYouModel({
    required super.id,
    required super.title,
    required super.seo,
    required super.photo,
    required super.date,
    required super.categoryName,
    required super.score,
  });

  /// Mapping dari ForYouController response
  /// Fields: id, title, seo, photo, date, category_name, score
  factory ForYouModel.fromJson(Map<String, dynamic> json) {
    return ForYouModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      seo: json['seo'] ?? '',
      photo: json['photo'] ?? '',
      date: json['date'] ?? '',
      categoryName: json['category_name'] ?? 'Umum',
      score: json['score'] ?? 0,
    );
  }

  ForYouEntity toEntity() => this;
}
