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
import 'package:portal_jtv/core/services/shared_preferences_service.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Pastikan Firebase diinisialisasi untuk background process
  await Firebase.initializeApp();
  debugPrint('[FCM] Handling background message: ${message.messageId}');

  // Jika Anda ingin melakukan sesuatu saat notifikasi masuk di background,
  // misalnya mengupdate database lokal atau memicu background fetch,
  // lakukan di sini.
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();
  final ApiClient _apiClient;
  final SharedPreferencesService _prefs;

  GoRouter? _router;

  NotificationService(this._apiClient, this._prefs);

  /// Channel ID untuk Android
  static const _androidChannel = AndroidNotificationChannel(
    'portal_jtv_news', // id
    'Berita Portal JTV', // name
    description: 'Notifikasi berita terbaru dari Portal JTV',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  /// Inisialisasi semua komponen notifikasi
  Future<void> init(GoRouter router) async {
    _router = router;

    // 1. Request permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
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
    await registerToken();

    // 6. Listen token refresh
    _messaging.onTokenRefresh.listen((_) => registerToken());

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
          final title = data['judul_berita'] as String?;
          if (seo != null && _router != null) {
            _navigateToDetail(seo, title);
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
  Future<void> registerToken() async {
    // Check if notification is active
    if (!_prefs.getNotificationSetting()) {
      debugPrint('[FCM] Notification is inactive, skip token registration');
      // Optional: Delete token if we want to be sure
      // await _messaging.deleteToken();
      return;
    }

    try {
      final token = await _messaging.getToken();
      if (token == null) {
        debugPrint('[FCM] Token null, skip register');
        return;
      }
      debugPrint('[FCM] Token obtained from Firebase: $token');

      final response = await _apiClient.post(
        ApiConstants.fcmRegister,
        data: {
          'token': token,
          'device_type': Platform.isAndroid ? 'android' : 'ios',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('[FCM] Token registered to backend ✅');
      } else {
        debugPrint(
          '[FCM] Token registration returned unexpected status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('[FCM] Gagal register token ke backend: $e');
    }
  }

  /// Handle pesan saat app di foreground → tampilkan local notif
  void _onForegroundMessage(RemoteMessage message) {
    // Check if notification is active
    if (!_prefs.getNotificationSetting()) {
      debugPrint(
        '[FCM] Notification is inactive, skip showing foreground message',
      );
      return;
    }

    debugPrint('[FCM] Foreground message: ${message.notification?.title}');

    final notification = message.notification;
    if (notification == null) return;

    // Ambil image URL dari notifikasi FCM
    final imageUrl =
        message.data['image'] ??
        notification.android?.imageUrl ??
        notification.apple?.imageUrl;

    if (imageUrl != null && imageUrl.trim().isNotEmpty) {
      // Tampilkan notif dengan gambar (async)
      _showNotificationWithImage(notification, message.data, imageUrl.trim());
    } else {
      // Tampilkan notif biasa tanpa gambar
      _showSimpleNotification(notification, message.data);
    }
  }

  /// Tampilkan local notification biasa (tanpa gambar)
  void _showSimpleNotification(
    RemoteNotification notification,
    Map<String, dynamic> data,
  ) {
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
      payload: jsonEncode(data),
    );
  }

  /// Tampilkan local notification dengan gambar (Big Picture)
  Future<void> _showNotificationWithImage(
    RemoteNotification notification,
    Map<String, dynamic> data,
    String imageUrl,
  ) async {
    try {
      // Download gambar dari URL dalam bentuk bytes
      final Uint8List bytes = await _apiClient.getByteArrayFromUrl(imageUrl);
      final bigPicture = ByteArrayAndroidBitmap(bytes);

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
            largeIcon: bigPicture,
            styleInformation: BigPictureStyleInformation(
              bigPicture,
              contentTitle: notification.title,
              summaryText: notification.body,
              hideExpandedLargeIcon: true,
            ),
          ),
        ),
        payload: jsonEncode(data),
      );
    } catch (e) {
      debugPrint('[FCM] Gagal download gambar notif: $e');
      // Fallback: tampilkan notif tanpa gambar
      _showSimpleNotification(notification, data);
    }
  }

  /// Handle tap pada notifikasi (background / terminated)
  void _onNotificationTap(RemoteMessage message) {
    debugPrint('[FCM] Notification tapped: ${message.data}');
    final seo = message.data['seo'] as String?;
    final title = message.data['judul_berita'] as String?;
    if (seo != null) {
      _navigateToDetail(seo, title);
    }
  }

  /// Navigate ke halaman detail berita
  void _navigateToDetail(String seo, String? title) {
    if (_router == null) return;

    final args = DetailArgsEntity(
      idBerita: 0,
      seo: seo,
      title: title ?? '',
      photo: '',
      date: '',
      category: '',
      seoCategory: '',
      author: '',
      picAuthor: '',
    );

    _router!.push(RouteNames.detail, extra: args);
  }

  /// Toggle notification active status
  Future<void> toggleNotifications(bool active) async {
    await _prefs.saveNotificationSetting(active);
    if (active) {
      await registerToken();
    } else {
      // If disabling, we can optionally delete the token from Firebase
      // so the backend can't send anything even if it tries.
      try {
        await _messaging.deleteToken();
        debugPrint('[FCM] Token deleted because notifications disabled');
      } catch (e) {
        debugPrint('[FCM] Failed to delete token: $e');
      }
    }
  }
}
