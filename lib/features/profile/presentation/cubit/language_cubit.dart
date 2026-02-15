import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  final SharedPreferences _prefs;
  static const String _key = 'language_code';

  // Bahasa yang tersedia
  static const supportedLocales = [
    Locale('id'), // Indonesia
    Locale('en'), // English
  ];

  static const localeNames = {'id': 'Indonesia', 'en': 'English'};

  LanguageCubit(this._prefs) : super(_loadLocale(_prefs));

  static Locale _loadLocale(SharedPreferences prefs) {
    final code = prefs.getString(_key) ?? 'id';
    return Locale(code);
  }

  void changeLanguage(String languageCode) {
    final locale = Locale(languageCode);
    emit(locale);
    _prefs.setString(_key, languageCode);
  }

  String get currentLanguageName =>
      localeNames[state.languageCode] ?? 'Indonesia';
}
