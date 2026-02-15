import 'package:equatable/equatable.dart';

class ForYouEntity extends Equatable {
  final int id;
  final String title;
  final String seo;
  final String photo;
  final String date;
  final String categoryName;
  final int score;

  const ForYouEntity({
    required this.id,
    required this.title,
    required this.seo,
    required this.photo,
    required this.date,
    required this.categoryName,
    required this.score,
  });

  @override
  List<Object?> get props => [id, title, seo, photo, date, categoryName, score];
}
