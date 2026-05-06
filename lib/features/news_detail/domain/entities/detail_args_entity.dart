class DetailArgsEntity {
  final int idBerita; // Untuk fetch komentar
  final String seo; // Untuk fetch API detail
  final String title;
  final String photo;
  final String date;
  final String category;
  final String seoCategory; // Untuk fetch related news by kategori
  final String author;
  final String picAuthor;

  const DetailArgsEntity({
    required this.idBerita,
    required this.seo,
    required this.title,
    required this.photo,
    required this.date,
    required this.category,
    required this.seoCategory,
    required this.author,
    required this.picAuthor,
  });

  /// Factory dari NewsEntity (dari Home)
  /// Panggil saat navigasi: DetailArgsEntity.fromNews(newsEntity)
  factory DetailArgsEntity.fromNewsEntity(dynamic news) {
    return DetailArgsEntity(
      idBerita: news.idBerita,
      seo: news.seo,
      title: news.title,
      photo: news.photo,
      date: news.date,
      category: news.category,
      seoCategory: news.seoCategory,
      author: news.author,
      picAuthor: news.picAuthor,
    );
  }
}
