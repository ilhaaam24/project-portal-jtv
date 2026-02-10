import 'package:equatable/equatable.dart';

class NewsDetailEntity extends Equatable {
  final int idBerita;
  final String title;
  final String seoBiro;
  final String seo;
  final String content;
  final String summary;
  final String photo;
  final String caption;
  final String? tag;
  final String status;
  final String city;
  final String date;
  final String category;
  final String seoCategory;
  final String? user;
  final String? navbar;
  final String? seoNavbar;
  final String author;
  final String? jabatanAuthor;
  final String seoAuthor;
  final String? picAuthor;
  final String? descAuthor;
  final int hit;
  final String? editorBerita;
  final String? tipeGambarUtama;

  const NewsDetailEntity({
    required this.idBerita,
    required this.title,
    required this.seoBiro,
    required this.seo,
    required this.content,
    required this.summary,
    required this.photo,
    required this.caption,
    this.tag,
    required this.status,
    required this.city,
    required this.date,
    required this.category,
    required this.seoCategory,
    this.user,
    this.navbar,
    this.seoNavbar,
    required this.author,
    this.jabatanAuthor,
    required this.seoAuthor,
    this.picAuthor,
    this.descAuthor,
    required this.hit,
    this.editorBerita,
    this.tipeGambarUtama,
  });

  @override
  List<Object?> get props => [
    idBerita,
    title,
    seoBiro,
    seo,
    content,
    summary,
    photo,
    caption,
    tag,
    status,
    city,
    date,
    category,
    seoCategory,
    user,
    navbar,
    seoNavbar,
    author,
    jabatanAuthor,
    seoAuthor,
    picAuthor,
    descAuthor,
    hit,
    editorBerita,
    tipeGambarUtama,
  ];
}
