import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/biro_entity.dart';

enum CategoryStatus { initial, loading, success, failure }

class CategoryState extends Equatable {
  final CategoryStatus status;
  final List<CategoryEntity> categories;
  final List<BiroEntity> biros;
  final String? errorMessage;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const [],
    this.biros = const [],
    this.errorMessage,
  });

  factory CategoryState.initial() => const CategoryState();

  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryEntity>? categories,
    List<BiroEntity>? biros,
    String? errorMessage,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      biros: biros ?? this.biros,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, categories, biros, errorMessage];
}
