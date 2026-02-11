import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/core/utils/text_size_preferences.dart';

class TextSizeCubit extends Cubit<double> {
  final TextSizePreferences _preferences;

  TextSizeCubit(this._preferences) : super(_preferences.getTextSize());

  void increase() {
    final newSize = (state + 2).clamp(
      TextSizePreferences.minSize,
      TextSizePreferences.maxSize,
    );
    _save(newSize);
  }

  void decrease() {
    final newSize = (state - 2).clamp(
      TextSizePreferences.minSize,
      TextSizePreferences.maxSize,
    );
    _save(newSize);
  }

  void setSize(double size) {
    _save(size.clamp(TextSizePreferences.minSize, TextSizePreferences.maxSize));
  }

  void reset() {
    _save(TextSizePreferences.defaultSize);
  }

  void _save(double size) {
    emit(size);
    _preferences.setTextSize(size);
  }
}
