import 'package:shared_preferences/shared_preferences.dart';

class TextSizePreferences {
  static const String _key = 'article_text_size';
  static const double defaultSize = 16.0;
  static const double minSize = 12.0;
  static const double maxSize = 28.0;

  final SharedPreferences _prefs;

  TextSizePreferences(this._prefs);

  double getTextSize() {
    return _prefs.getDouble(_key) ?? defaultSize;
  }

  Future<void> setTextSize(double size) async {
    await _prefs.setDouble(_key, size.clamp(minSize, maxSize));
  }
}
