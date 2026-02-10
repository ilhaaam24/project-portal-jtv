
import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final int id;
  final String youtubeId;
  final String title;
  final String thumbnail;
  final String date;

  const VideoEntity({
    required this.id,
    required this.youtubeId,
    required this.title,
    required this.thumbnail,
    required this.date,
  });

  @override
  List<Object?> get props => [id, youtubeId, title, thumbnail, date];
}
