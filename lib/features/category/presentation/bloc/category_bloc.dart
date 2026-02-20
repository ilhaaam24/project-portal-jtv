import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import '../../domain/usecases/get_categories.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories getCategories;

  CategoryBloc({required this.getCategories}) : super(CategoryState.initial()) {
    on<LoadCategories>(_onLoad);
  }

  Future<void> _onLoad(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));

    final result = await getCategories(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: CategoryStatus.success,
          categories: data.categories,
          biros: data.biros,
        ),
      ),
    );
  }
}
