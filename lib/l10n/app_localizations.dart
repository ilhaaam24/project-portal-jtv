import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @navHome.
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get navHome;

  /// No description provided for @navCategory.
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get navCategory;

  /// No description provided for @navLive.
  ///
  /// In id, this message translates to:
  /// **'Live TV'**
  String get navLive;

  /// No description provided for @navSave.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get navSave;

  /// No description provided for @navProfile.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @tabLatest.
  ///
  /// In id, this message translates to:
  /// **'TERBARU'**
  String get tabLatest;

  /// No description provided for @tabPopular.
  ///
  /// In id, this message translates to:
  /// **'TERPOPULER'**
  String get tabPopular;

  /// No description provided for @tabForYou.
  ///
  /// In id, this message translates to:
  /// **'FOR YOU'**
  String get tabForYou;

  /// No description provided for @search.
  ///
  /// In id, this message translates to:
  /// **'Pencarian'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari berita...'**
  String get searchHint;

  /// No description provided for @searchRecent.
  ///
  /// In id, this message translates to:
  /// **'Pencarian Terakhir'**
  String get searchRecent;

  /// No description provided for @searchLatest.
  ///
  /// In id, this message translates to:
  /// **'Cari berita terkini'**
  String get searchLatest;

  /// No description provided for @clearAll.
  ///
  /// In id, this message translates to:
  /// **'Hapus Semua'**
  String get clearAll;

  /// No description provided for @noResults.
  ///
  /// In id, this message translates to:
  /// **'Tidak ditemukan hasil untuk'**
  String get noResults;

  /// No description provided for @resultsFor.
  ///
  /// In id, this message translates to:
  /// **'Hasil untuk \"{keyword}\" ({count})'**
  String resultsFor(String keyword, int count);

  /// No description provided for @savedNews.
  ///
  /// In id, this message translates to:
  /// **'Berita Tersimpan'**
  String get savedNews;

  /// No description provided for @newsDeleted.
  ///
  /// In id, this message translates to:
  /// **'Berita dihapus'**
  String get newsDeleted;

  /// No description provided for @noSavedNews.
  ///
  /// In id, this message translates to:
  /// **'Belum ada berita tersimpan'**
  String get noSavedNews;

  /// No description provided for @saveHint.
  ///
  /// In id, this message translates to:
  /// **'Simpan berita favoritmu agar mudah\ndibaca kembali nanti'**
  String get saveHint;

  /// No description provided for @retry.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get retry;

  /// No description provided for @loadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data'**
  String get loadFailed;

  /// No description provided for @errorOccurred.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan'**
  String get errorOccurred;

  /// No description provided for @liveStreaming.
  ///
  /// In id, this message translates to:
  /// **'Live Streaming'**
  String get liveStreaming;

  /// No description provided for @noLiveBroadcast.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada siaran langsung saat ini'**
  String get noLiveBroadcast;

  /// No description provided for @stayTuned.
  ///
  /// In id, this message translates to:
  /// **'Nantikan siaran berikutnya'**
  String get stayTuned;

  /// No description provided for @profile.
  ///
  /// In id, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @account.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get account;

  /// No description provided for @editBio.
  ///
  /// In id, this message translates to:
  /// **'Edit Biodata'**
  String get editBio;

  /// No description provided for @settings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settings;

  /// No description provided for @notification.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi'**
  String get notification;

  /// No description provided for @language.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In id, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @others.
  ///
  /// In id, this message translates to:
  /// **'Lainnya'**
  String get others;

  /// No description provided for @faq.
  ///
  /// In id, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @rateUs.
  ///
  /// In id, this message translates to:
  /// **'Beri Rating'**
  String get rateUs;

  /// No description provided for @logout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin ingin keluar?'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @selectLanguage.
  ///
  /// In id, this message translates to:
  /// **'Pilih Bahasa'**
  String get selectLanguage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
