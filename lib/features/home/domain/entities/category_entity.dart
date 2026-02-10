import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String title;
  final String seo;
  final int sequence;
  final int? rubrik;
  final List<SubMenuEntity>? submenu;

  const CategoryEntity({
    required this.id,
    required this.title,
    required this.seo,
    required this.sequence,
    this.rubrik,
    this.submenu,
  });

  @override
  List<Object?> get props => [id, title, seo, sequence, rubrik, submenu];
}

class SubMenuEntity extends Equatable {
  final int id;
  final String title;
  final String seo;

  const SubMenuEntity({
    required this.id,
    required this.title,
    required this.seo,
  });

  @override
  List<Object?> get props => [id, title, seo];
}
