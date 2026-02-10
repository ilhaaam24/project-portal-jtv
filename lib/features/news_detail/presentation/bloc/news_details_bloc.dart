import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'news_details_event.dart';
part 'news_details_state.dart';

class NewsDetailsBloc extends Bloc<NewsDetailsEvent, NewsDetailsState> {
  NewsDetailsBloc() : super(NewsDetailsInitial()) {
    on<NewsDetailsEvent>((event, emit) {
    });
  }
}
