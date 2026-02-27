import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/config/routes/route_names.dart';
import 'package:portal_jtv/core/constants/api_constants.dart';
import 'package:portal_jtv/core/network/api_client.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';

/// Top-level function — WAJIB top-level (bukan method di class)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('[FCM] Background message: ${message.messageId}');
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();
  final ApiClient _apiClient;

  GoRouter? _router;

  NotificationService(this._apiClient);

  /// Channel ID untuk Android
  static const _androidChannel = AndroidNotificationChannel(
    'portal_jtv_news', // id
    'Berita Portal JTV', // name
    description: 'Notifikasi berita terbaru dari Portal JTV',
    importance: Importance.high,
  );

  /// Inisialisasi semua komponen notifikasi
  Future<void> init(GoRouter router) async {
    _router = router;

    // 1. Request permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('[FCM] Permission: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('[FCM] Notifikasi ditolak oleh user');
      return;
    }

    // 2. Tampilkan notif saat foreground (iOS & Android 10+)
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 3. Setup local notifications (Android)
    await _setupLocalNotifications();
    debugPrint('[FCM] Local notifications setup done');

    // 4. Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 5. Get & register FCM token
    await _registerToken();

    // 6. Listen token refresh
    _messaging.onTokenRefresh.listen((_) => _registerToken());

    // 7. Listen foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('[FCM] ===== FOREGROUND MESSAGE RECEIVED =====');
      debugPrint('[FCM] Title: ${message.notification?.title}');
      debugPrint('[FCM] Body: ${message.notification?.body}');
      debugPrint('[FCM] Data: ${message.data}');
      _onForegroundMessage(message);
    });
    debugPrint('[FCM] Foreground listener registered ✅');

    // 8. Handle notification tap (app in background → opened)
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationTap);

    // 9. Handle initial message (app terminated → opened via notif)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _onNotificationTap(initialMessage),
      );
    }

    debugPrint('[FCM] ===== INIT COMPLETE =====');
  }

  /// Setup Flutter Local Notifications
  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotif.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Tap pada local notification (foreground)
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          final seo = data['seo'] as String?;
          if (seo != null && _router != null) {
            _navigateToDetail(seo);
          }
        }
      },
    );

    // Buat notification channel di Android
    if (Platform.isAndroid) {
      await _localNotif
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_androidChannel);
    }
  }

  /// Dapatkan FCM token dan kirim ke backend
  Future<void> _registerToken() async {
    try {
      final token = await _messaging.getToken();
      if (token == null) {
        debugPrint('[FCM] Token null, skip register');
        return;
      }
      debugPrint('[FCM] Token: $token');

      await _apiClient.post(
        ApiConstants.fcmRegister,
        data: {
          'token': token,
          'device_type': Platform.isAndroid ? 'android' : 'ios',
        },
      );
      debugPrint('[FCM] Token registered to backend ✅');
    } catch (e) {
      debugPrint('[FCM] Gagal register token: $e');
    }
  }

  /// Handle pesan saat app di foreground → tampilkan local notif
  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('[FCM] Foreground message: ${message.notification?.title}');

    final notification = message.notification;
    if (notification == null) return;

    _localNotif.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  /// Handle tap pada notifikasi (background / terminated)
  void _onNotificationTap(RemoteMessage message) {
    debugPrint('[FCM] Notification tapped: ${message.data}');
    final seo = message.data['seo'] as String?;
    if (seo != null) {
      _navigateToDetail(seo);
    }
  }

  /// Navigate ke halaman detail berita
  void _navigateToDetail(String seo) {
    if (_router == null) return;

    final args = DetailArgsEntity(
      idBerita: 0,
      seo: seo,
      title: '',
      photo: '',
      date: '',
      category: '',
      author: '',
      picAuthor: '',
    );

    _router!.push(RouteNames.detail, extra: args);
  }
}
