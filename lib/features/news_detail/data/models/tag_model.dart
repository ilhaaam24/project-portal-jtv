import 'package:portal_jtv/features/news_detail/domain/entities/tag_entity.dart';

class TagModel extends TagEntity {
  const TagModel({required super.name, required super.seo});

  /// Perhatikan: dari backend, field-nya adalah 'namatag' dan 'seo_tag'
  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(name: json['namatag'] ?? '', seo: json['seo_tag'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'namatag': name, 'seo_tag': seo};
  }

  TagEntity toEntity() => this;
}
