import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load detail berita + hit counter + cek bookmark (parallel)
class LoadDetail extends DetailEvent {
  final String seo;

  const LoadDetail({required this.seo});

  @override
  List<Object?> get props => [seo];
}

/// Toggle bookmark (simpan/hapus)
class ToggleBookmark extends DetailEvent {
  const ToggleBookmark();
}
