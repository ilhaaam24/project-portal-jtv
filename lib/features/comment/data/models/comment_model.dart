import 'package:portal_jtv/features/comment/domain/entities/comment_entity.dart';
import 'comment_user_model.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    super.idBerita,
    required super.userId,
    required super.content,
    super.parentId,
    required super.status,
    required super.createdAt,
    super.user,
    required super.likesCount,
    required super.isLiked,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      idBerita: json['id_berita'],
      userId: json['user_id'] ?? 0,
      content: json['content'] ?? '',
      parentId: json['parent_id'],
      status: json['status'] ?? 'active',
      createdAt: json['created_at'] ?? '',
      user: json['user'] != null
          ? CommentUserModel.fromJson(json['user'])
          : null,
      likesCount: json['likes_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
    );
  }

  CommentEntity toEntity() {
    return CommentEntity(
      id: id,
      idBerita: idBerita,
      userId: userId,
      content: content,
      parentId: parentId,
      status: status,
      createdAt: createdAt,
      user: user,
      likesCount: likesCount,
      isLiked: isLiked,
    );
  }
}
