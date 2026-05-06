import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/core/services/notification_service.dart';
import 'package:portal_jtv/core/services/shared_preferences_service.dart';

class NotificationCubit extends Cubit<bool> {
  final SharedPreferencesService _prefs;
  final NotificationService _notificationService;

  NotificationCubit(this._prefs, this._notificationService)
    : super(_prefs.getNotificationSetting());

  Future<void> toggle() async {
    final newValue = !state;
    emit(newValue);
    await _notificationService.toggleNotifications(newValue);
  }

  Future<void> setEnabled(bool enabled) async {
    emit(enabled);
    await _notificationService.toggleNotifications(enabled);
  }

  bool getNotificationSetting() {
    return _prefs.getNotificationSetting();
  }
}
