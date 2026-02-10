
class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int? from;
  final int? to;

  PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.from,
    this.to,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      from: json['from'],
      to: json['to'],
    );
  }

  bool get hasNextPage => currentPage < lastPage;
}

class ApiResponse<T> {
  final List<T> data;
  final PaginationMeta? meta;
  final SectionInfo? section;

  ApiResponse({required this.data, this.meta, this.section});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse(
      data:
          (json['data'] as List?)
              ?.map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList() ??
          [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
      section: json['section'] != null
          ? SectionInfo.fromJson(json['section'])
          : null,
    );
  }
}

class SectionInfo {
  final String title;
  final String link;

  SectionInfo({required this.title, required this.link});

  factory SectionInfo.fromJson(Map<String, dynamic> json) {
    return SectionInfo(title: json['title'] ?? '', link: json['link'] ?? '');
  }
}
