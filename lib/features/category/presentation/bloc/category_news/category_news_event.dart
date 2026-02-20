import 'package:equatable/equatable.dart';

abstract class CategoryNewsEvent extends Equatable {
  const CategoryNewsEvent();
  @override
  List<Object?> get props => [];
}

class LoadCategoryNews extends CategoryNewsEvent {
  final String seo;
  final String title;
  final bool isBiro;

  const LoadCategoryNews({
    required this.seo,
    required this.title,
    this.isBiro = false,
  });

  @override
  List<Object?> get props => [seo, title, isBiro];
}

class LoadMoreCategoryNews extends CategoryNewsEvent {
  const LoadMoreCategoryNews();
}
