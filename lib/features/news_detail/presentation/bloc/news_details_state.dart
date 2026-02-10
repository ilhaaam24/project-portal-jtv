part of 'news_details_bloc.dart';

abstract class NewsDetailsState extends Equatable {
  const NewsDetailsState();  

  @override
  List<Object> get props => [];
}
class NewsDetailsInitial extends NewsDetailsState {}
