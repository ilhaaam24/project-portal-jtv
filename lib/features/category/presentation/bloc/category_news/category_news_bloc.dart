import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/features/category/domain/usecases/get_news_by_category.dart';
import 'category_news_event.dart';
import 'category_news_state.dart';

class CategoryNewsBloc extends Bloc<CategoryNewsEvent, CategoryNewsState> {
  final GetNewsByCategory getNewsByCategory;

  CategoryNewsBloc({required this.getNewsByCategory})
    : super(CategoryNewsState.initial()) {
    on<LoadCategoryNews>(_onLoad);
    on<LoadMoreCategoryNews>(_onLoadMore);
  }

  Future<void> _onLoad(
    LoadCategoryNews event,
    Emitter<CategoryNewsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CategoryNewsStatus.loading,
        title: event.title,
        seo: event.seo,
        isBiro: event.isBiro,
      ),
    );

    final result = await getNewsByCategory(
      CategoryNewsParams(
        seo: event.seo,
        page: 1,
        limit: 10,
        isBiro: event.isBiro,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryNewsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (paginated) => emit(
        state.copyWith(
          status: paginated.news.isEmpty
              ? CategoryNewsStatus.empty
              : CategoryNewsStatus.success,
          news: paginated.news,
          currentPage: paginated.currentPage,
          hasReachedMax: paginated.lastPage <= paginated.currentPage,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    LoadMoreCategoryNews event,
    Emitter<CategoryNewsState> emit,
  ) async {
    if (state.hasReachedMax) return;

    final nextPage = state.currentPage + 1;

    final result = await getNewsByCategory(
      CategoryNewsParams(
        seo: state.seo,
        page: nextPage,
        limit: 10,
        isBiro: state.isBiro,
      ),
    );

    result.fold(
      (_) {},
      (paginated) => emit(
        state.copyWith(
          news: [...state.news, ...paginated.news],
          currentPage: paginated.currentPage,
          hasReachedMax: paginated.lastPage <= paginated.currentPage,
        ),
      ),
    );
  }
}
