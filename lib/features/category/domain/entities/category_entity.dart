import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String title;
  final String seo;
  final int seq;

  const CategoryEntity({
    required this.id,
    required this.title,
    required this.seo,
    required this.seq,
  });

  @override
  List<Object?> get props => [id, title, seo, seq];
}
