import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.title,
    required super.seo,
    required super.seq,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      seo: json['seo'] ?? '',
      seq: json['seq'] ?? 0,
    );
  }

  CategoryEntity toEntity() => this;
}
