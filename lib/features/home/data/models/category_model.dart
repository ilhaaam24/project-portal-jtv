import 'package:portal_jtv/features/home/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.title,
    required super.seo,
    required super.sequence,
    super.rubrik,
    super.submenu,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<SubMenuModel>? submenus;
    if (json['submenu'] != null) {
      submenus = (json['submenu'] as List)
          .map((item) => SubMenuModel.fromJson(item))
          .toList();
    }

    return CategoryModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      seo: json['seo'] ?? '',
      sequence: json['seq'] ?? 0,
      rubrik: json['rubrik'],
      submenu: submenus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'seo': seo,
      'seq': sequence,
      'rubrik': rubrik,
      'submenu': submenu?.map((e) => (e as SubMenuModel).toJson()).toList(),
    };
  }

  CategoryEntity toEntity() => this;
}

class SubMenuModel extends SubMenuEntity {
  const SubMenuModel({
    required super.id,
    required super.title,
    required super.seo,
  });

  factory SubMenuModel.fromJson(Map<String, dynamic> json) {
    return SubMenuModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      seo: json['seo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'seo': seo};
  }
}
