import 'package:portal_jtv/features/home/domain/entities/sorot_entity.dart';

class SorotModel extends SorotEntity {
  const SorotModel({
    required super.title,
    required super.seo,
    super.date,
    required super.photo,
  });

  factory SorotModel.fromJson(Map<String, dynamic> json) {
    return SorotModel(
      title: json['title'] ?? '',
      seo: json['seo'] ?? '',
      date: json['date'],
      photo: json['photo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'seo': seo, 'date': date, 'photo': photo};
  }

  SorotEntity toEntity() => this;
}
