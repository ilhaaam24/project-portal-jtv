import 'package:equatable/equatable.dart';

class SavedNewsEntity extends Equatable {
  final int idSaved;
  final int idBerita;
  final String savedAt;
  final String title;
  final String seo;
  final String? seoBiro;
  final String? status;
  final String? photo;
  final String? summary;
  final String? caption;
  final String? city;
  final String? date;
  final String? category;
  final String? seoCategory;
  final String? tag;
  final String? author;
  final String? jabatanAuthor;
  final String? seoAuthor;
  final String? editor;
  final String? picAuthor;
  final String? isYoutube;

  const SavedNewsEntity({
    required this.idSaved,
    required this.idBerita,
    required this.savedAt,
    required this.title,
    required this.seo,
    this.seoBiro,
    this.status,
    this.photo,
    this.summary,
    this.caption,
    this.city,
    this.date,
    this.category,
    this.seoCategory,
    this.tag,
    this.author,
    this.jabatanAuthor,
    this.seoAuthor,
    this.editor,
    this.picAuthor,
    this.isYoutube,
  });

  @override
  List<Object?> get props => [
    idSaved,
    idBerita,
    savedAt,
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
