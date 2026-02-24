// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navCategory => 'Category';

  @override
  String get navLive => 'Live TV';

  @override
  String get navSave => 'Saved';

  @override
  String get navProfile => 'Profile';

  @override
  String get tabLatest => 'LATEST';

  @override
  String get tabPopular => 'POPULAR';

  @override
  String get tabForYou => 'FOR YOU';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search news...';

  @override
  String get searchRecent => 'Recent Searches';

  @override
  String get searchLatest => 'Search latest news';

  @override
  String get clearAll => 'Clear All';

  @override
  String get noResults => 'No results found for';

  @override
  String resultsFor(String keyword, int count) {
    return 'Results for \"$keyword\" ($count)';
  }

  @override
  String get savedNews => 'Saved News';

  @override
  String get newsDeleted => 'News deleted';

  @override
  String get noSavedNews => 'No saved news yet';

  @override
  String get saveHint => 'Save your favorite news for\neasy reading later';

  @override
  String get retry => 'Try Again';

  @override
  String get loadFailed => 'Failed to load data';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get liveStreaming => 'Live Streaming';

  @override
  String get noLiveBroadcast => 'No live broadcast at the moment';

  @override
  String get stayTuned => 'Stay tuned for the next broadcast';

  @override
  String get profile => 'Profile';

  @override
  String get account => 'Account';

  @override
  String get editBio => 'Edit Profile';

  @override
  String get settings => 'Settings';

  @override
  String get notification => 'Notifications';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get others => 'Others';

  @override
  String get faq => 'FAQ';

  @override
  String get rateUs => 'Rate Us';

  @override
  String get logout => 'Log Out';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get selectLanguage => 'Select Language';
}
