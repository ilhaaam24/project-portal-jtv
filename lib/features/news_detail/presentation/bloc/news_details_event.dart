import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load detail berita + hit counter + cek bookmark (parallel)
class LoadDetail extends DetailEvent {
  final String seo;
  final int limit;
  final String seoCategory;

  const LoadDetail({required this.seo, this.limit = 10, this.seoCategory = ''});

  @override
  List<Object?> get props => [seo, seoCategory];
}

/// Toggle bookmark (simpan/hapus)
class ToggleBookmark extends DetailEvent {
  const ToggleBookmark();
}
