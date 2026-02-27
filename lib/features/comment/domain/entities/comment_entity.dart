import 'package:equatable/equatable.dart';
import 'comment_user_entity.dart';

class CommentEntity extends Equatable {
  final int id;
  final int? idBerita;
  final int userId;
  final String content;
  final int? parentId;
  final String status;
  final String createdAt;
  final CommentUserEntity? user;
  final int likesCount;
  final bool isLiked;

  const CommentEntity({
    required this.id,
    this.idBerita,
    required this.userId,
    required this.content,
    this.parentId,
    required this.status,
    required this.createdAt,
    this.user,
    required this.likesCount,
    required this.isLiked,
  });

  CommentEntity copyWith({
    int? likesCount,
    bool? isLiked,
  }) {
    return CommentEntity(
      id: id,
      idBerita: idBerita,
      userId: userId,
      content: content,
      parentId: parentId,
      status: status,
      createdAt: createdAt,
      user: user,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        idBerita,
        userId,
        content,
        parentId,
        status,
        createdAt,
        user,
        likesCount,
        isLiked,
      ];
}
