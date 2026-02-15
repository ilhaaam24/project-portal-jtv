import 'package:portal_jtv/features/news_detail/domain/entities/tag_entity.dart';

class TagModel extends TagEntity {
  const TagModel({required super.name, required super.seo});

  /// Perhatikan: dari backend, field-nya adalah 'namatag' dan 'seo_tag'
  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(name: json['title'] ?? '', seo: json['seo'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'title': name, 'seo': seo};
  }

  TagEntity toEntity() => this;
}
