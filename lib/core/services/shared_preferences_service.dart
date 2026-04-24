import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences prefs;
  const SharedPreferencesService(this.prefs);

  static const String notificationKey = "IS_NOTIFICATION_ACTIVE";
  static const String onboardingKey = "IS_ONBOARDING_COMPLETED";

  Future<void> saveNotificationSetting(bool value) async {
    try {
      print(value);
      print(prefs);
      await prefs.setBool(notificationKey, value);
    } catch (e) {
      throw ('Error saving notification setting: $e');
    }
  }

  bool getNotificationSetting() {
    return prefs.getBool(notificationKey) ?? true;
  }

  Future<void> setOnboardingCompleted() async {
    try {
      await prefs.setBool(onboardingKey, true);
    } catch (e) {
      throw ('Error saving onboarding status: $e');
    }
  }

  bool isOnboardingCompleted() {
    return prefs.getBool(onboardingKey) ?? false;
  }
}
