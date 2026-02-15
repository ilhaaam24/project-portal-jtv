// lib/features/profile/presentation/cubit/notification_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationCubit extends Cubit<bool> {
  final SharedPreferences _prefs;
  static const String _key = 'notification_enabled';

  NotificationCubit(this._prefs) : super(_prefs.getBool(_key) ?? true);

  void toggle() {
    final newValue = !state;
    emit(newValue);
    _prefs.setBool(_key, newValue);

    // todo: Subscribe/unsubscribe dari FCM topic
    // if (newValue) {
    //   FirebaseMessaging.instance.subscribeToTopic('news');
    // } else {
    //   FirebaseMessaging.instance.unsubscribeFromTopic('news');
    // }
  }

  void setEnabled(bool enabled) {
    emit(enabled);
    _prefs.setBool(_key, enabled);
  }
}
