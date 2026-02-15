
import 'package:portal_jtv/features/live/domain/entities/livestream_entity.dart';

class LivestreamModel extends LivestreamEntity {
  const LivestreamModel({
    required super.youtube,
    required super.facebook,
    required super.vidio,
    required super.jtv,
    required super.liveStatus,
    required super.liveTitle,
    required super.liveLink,
  });

  factory LivestreamModel.fromJson(Map<String, dynamic> json) {
    // Parse data array (ambil item pertama)
    final dataList = json['data'] as List? ?? [];
    final data = dataList.isNotEmpty ? dataList[0] : {};

    // Parse live info
    final live = json['live'] ?? {};

    return LivestreamModel(
      youtube: data['youtube'] ?? '-',
      facebook: data['facebook'] ?? '-',
      vidio: data['vidio'] ?? '-',
      jtv: data['jtv'] ?? '-',
      liveStatus: live['status'] ?? 0,
      liveTitle: live['title'] ?? '',
      liveLink: live['link'] ?? '',
    );
  }

  LivestreamEntity toEntity() => this;
}
