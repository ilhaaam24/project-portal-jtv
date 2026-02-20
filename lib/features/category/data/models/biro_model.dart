
import 'package:portal_jtv/features/category/domain/entities/biro_entity.dart';

class BiroModel extends BiroEntity {
  const BiroModel({required super.title, required super.seo, super.link});

  factory BiroModel.fromJson(Map<String, dynamic> json) {
    return BiroModel(
      title: json['title'] ?? '',
      seo: json['seo'] ?? '',
      link: json['link'],
    );
  }

  BiroEntity toEntity() => this;
}
