import 'package:equatable/equatable.dart';

class CommentUserEntity extends Equatable {
  final int idPenulis;
  final String nama;
  final String? pic;

  const CommentUserEntity({
    required this.idPenulis,
    required this.nama,
    this.pic,
  });

  @override
  List<Object?> get props => [idPenulis, nama, pic];
}
