import 'package:portal_jtv/features/comment/domain/entities/toggle_like_result_entity.dart';

class ToggleLikeResultModel extends ToggleLikeResultEntity {
  const ToggleLikeResultModel({
    required super.liked,
    required super.totalLikes,
  });

  factory ToggleLikeResultModel.fromJson(Map<String, dynamic> json) {
    return ToggleLikeResultModel(
      liked: json['liked'] ?? false,
      totalLikes: json['total_likes'] ?? 0,
    );
  }
}
