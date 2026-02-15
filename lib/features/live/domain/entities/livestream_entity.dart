import 'package:equatable/equatable.dart';

class LivestreamEntity extends Equatable {
  // Sumber streaming
  final String youtube;
  final String facebook;
  final String vidio;
  final String jtv;

  // Live info
  final int liveStatus; // 1 = live, 0 = offline
  final String liveTitle;
  final String liveLink; // URL utama yang sedang live

  const LivestreamEntity({
    required this.youtube,
    required this.facebook,
    required this.vidio,
    required this.jtv,
    required this.liveStatus,
    required this.liveTitle,
    required this.liveLink,
  });

  bool get isLive => liveStatus == 1;

  /// Cek apakah sumber tersedia (bukan "-" atau kosong)
  bool get hasYoutube => youtube != '-' && youtube.isNotEmpty;
  bool get hasFacebook => facebook != '-' && facebook.isNotEmpty;
  bool get hasVidio => vidio != '-' && vidio.isNotEmpty;
  bool get hasJtv => jtv != '-' && jtv.isNotEmpty;

  @override
  List<Object?> get props => [
    youtube,
    facebook,
    vidio,
    jtv,
    liveStatus,
    liveTitle,
    liveLink,
  ];
}
