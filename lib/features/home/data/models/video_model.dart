import 'package:portal_jtv/features/home/domain/entities/video_entity.dart';

class VideoModel extends VideoEntity {
  const VideoModel({
    required super.id,
    required super.youtubeId,
    required super.title,
    required super.thumbnail,
    required super.date,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? 0,
      youtubeId: json['youtube'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'youtube': youtubeId,
      'title': title,
      'thumbnail': thumbnail,
      'date': date,
    };
  }

  VideoEntity toEntity() => this;
}
