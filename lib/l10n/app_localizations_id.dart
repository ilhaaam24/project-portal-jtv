// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get navHome => 'Beranda';

  @override
  String get navCategory => 'Kategori';

  @override
  String get navLive => 'Live TV';

  @override
  String get navSave => 'Simpan';

  @override
  String get navProfile => 'Profil';

  @override
  String get tabLatest => 'TERBARU';

  @override
  String get tabPopular => 'TERPOPULER';

  @override
  String get tabForYou => 'FOR YOU';

  @override
  String get search => 'Pencarian';

  @override
  String get searchHint => 'Cari berita...';

  @override
  String get searchRecent => 'Pencarian Terakhir';

  @override
  String get searchLatest => 'Cari berita terkini';

  @override
  String get clearAll => 'Hapus Semua';

  @override
  String get noResults => 'Tidak ditemukan hasil untuk';

  @override
  String resultsFor(String keyword, int count) {
    return 'Hasil untuk \"$keyword\" ($count)';
  }

  @override
  String get savedNews => 'Berita Tersimpan';

  @override
  String get newsDeleted => 'Berita dihapus';

  @override
  String get noSavedNews => 'Belum ada berita tersimpan';

  @override
  String get saveHint =>
      'Simpan berita favoritmu agar mudah\ndibaca kembali nanti';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get loadFailed => 'Gagal memuat data';

  @override
  String get errorOccurred => 'Terjadi kesalahan';

  @override
  String get liveStreaming => 'Live Streaming';

  @override
  String get noLiveBroadcast => 'Tidak ada siaran langsung saat ini';

  @override
  String get stayTuned => 'Nantikan siaran berikutnya';

  @override
  String get profile => 'Profile';

  @override
  String get account => 'Akun';

  @override
  String get editBio => 'Edit Biodata';

  @override
  String get settings => 'Pengaturan';

  @override
  String get notification => 'Notifikasi';

  @override
  String get language => 'Bahasa';

  @override
  String get theme => 'Tema';

  @override
  String get others => 'Lainnya';

  @override
  String get faq => 'FAQ';

  @override
  String get rateUs => 'Beri Rating';

  @override
  String get logout => 'Keluar';

  @override
  String get logoutConfirm => 'Apakah Anda yakin ingin keluar?';

  @override
  String get cancel => 'Batal';

  @override
  String get selectLanguage => 'Pilih Bahasa';
}
