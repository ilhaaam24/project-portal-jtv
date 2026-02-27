import 'package:equatable/equatable.dart';

class ToggleLikeResultEntity extends Equatable {
  final bool liked;
  final int totalLikes;

  const ToggleLikeResultEntity({
    required this.liked,
    required this.totalLikes,
  });

  @override
  List<Object?> get props => [liked, totalLikes];
}
