import 'package:portal_jtv/features/comment/domain/entities/comment_user_entity.dart';

class CommentUserModel extends CommentUserEntity {
  const CommentUserModel({
    required super.idPenulis,
    required super.nama,
    super.pic,
  });

  factory CommentUserModel.fromJson(Map<String, dynamic> json) {
    return CommentUserModel(
      idPenulis: json['id_penulis'] ?? 0,
      nama: json['nama_lengkap'] ?? json['nama'] ?? 'Anonim',
      pic: json['pic'],
    );
  }
}
