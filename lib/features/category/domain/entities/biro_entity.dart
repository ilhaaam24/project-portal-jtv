import 'package:equatable/equatable.dart';

class BiroEntity extends Equatable {
  final String title;
  final String seo;
  final String? link;

  const BiroEntity({required this.title, required this.seo, this.link});

  @override
  List<Object?> get props => [title, seo, link];
}
