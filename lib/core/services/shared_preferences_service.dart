import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences prefs;
  const SharedPreferencesService(this.prefs);

  static const String notificationKey = "IS_NOTIFICATION_ACTIVE";

  Future<void> saveNotificationSetting(bool value) async {
    try {
      await prefs.setBool(notificationKey, value);
    } catch (e) {
      throw ('Error saving notification setting: $e');
    }
  }

  bool getNotificationSetting() {
    return prefs.getBool(notificationKey) ?? true;
  }
}
