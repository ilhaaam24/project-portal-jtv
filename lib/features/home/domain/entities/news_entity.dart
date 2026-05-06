import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final int idBerita;
  final String title;
  final String seo;
  final String seoBiro;
  final String status;
  final String photo;
  final String summary;
  final String caption;
  final String city;
  final String date;
  final String category;
  final String seoCategory;
  final String? tag;
  final String author;
  final String? jabatanAuthor;
  final String seoAuthor;
  final String? editor;
  final String picAuthor;
  final bool isYoutube;

  const NewsEntity({
    required this.idBerita,
    required this.title,
    required this.seo,
    required this.seoBiro,
    required this.status,
    required this.photo,
    required this.summary,
    required this.caption,
    required this.city,
    required this.date,
    required this.category,
    required this.seoCategory,
    this.tag,
    required this.author,
    this.jabatanAuthor,
    required this.seoAuthor,
    this.editor,
    required this.picAuthor,
    required this.isYoutube,
  });

  @override
  List<Object?> get props => [
    idBerita,
    title,
    seo,
    seoBiro,
    status,
    photo,
    summary,
    caption,
    city,
    date,
    category,
    seoCategory,
    tag,
    author,
    jabatanAuthor,
    seoAuthor,
    editor,
    picAuthor,
    isYoutube,
  ];
}
