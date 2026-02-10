import 'package:equatable/equatable.dart';

class SorotEntity extends Equatable {
  final String title;
  final String seo;
  final String? date;
  final String photo;

  const SorotEntity({
    required this.title,
    required this.seo,
    this.date,
    required this.photo,
  });

  @override
  List<Object?> get props => [title, seo, date, photo];
}
