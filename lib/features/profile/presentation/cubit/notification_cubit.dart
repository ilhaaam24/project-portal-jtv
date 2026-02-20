
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/core/services/shared_preferences_service.dart';

class NotificationCubit extends Cubit<bool> {
  final SharedPreferencesService _prefs;

  NotificationCubit(this._prefs) : super(_prefs.getNotificationSetting());

  void toggle() {
    final newValue = !state;
    emit(newValue);
    _prefs.saveNotificationSetting( newValue);
  }

  void setEnabled(bool enabled) {
    emit(enabled);
    _prefs.saveNotificationSetting( enabled);
  }

  bool getNotificationSetting() {
    return _prefs.getNotificationSetting();
  }
}
