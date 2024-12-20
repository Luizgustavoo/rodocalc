// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/routes/app_routes.dart';

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print("Notificação em segundo plano!");

  String status = message.data['status'] ?? '';
  if (status == 'paid') {
    await Get.find<PlanController>().updateStorageUserPlan();
    Get.offAllNamed(Routes.home);
  }
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );

  void _handleMessage(RemoteMessage message) {
    print("Notificação clicou!");

    //Get.toNamed('/list-message');
  }

  Future<void> _initLocalNotifications() async {
    const android =
        AndroidInitializationSettings('@drawable/launch_background');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(settings,
        onSelectNotification: (payload) {
      if (payload != null) {
        final message = RemoteMessage.fromMap(jsonDecode(payload));
        _handleMessage(message);
      }
    });

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> _initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((message) async {
      print("Primeiro plano");

      String status = message.data['status'] ?? '';
      if (status == 'paid') {
        await Get.find<PlanController>().updateStorageUserPlan();
        Get.offAllNamed(Routes.home);
      }

      if (message.notification != null) {
        _localNotifications.show(
          message.hashCode,
          message.notification!.title,
          message.notification!.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              // icon: '@drawable/ic_launcher',
            ),
            iOS: const IOSNotificationDetails(),
          ),
          payload: jsonEncode(message.toMap()),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Abriu a notificação");
      _handleMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }

  Future<void> initNotifications() async {
    final permission = await _firebaseMessaging.requestPermission();
    // print("Notification Permission: \${permission.authorizationStatus}");

    await _initLocalNotifications();
    await _initPushNotifications();

    // print("Notification System Initialized");
  }
}
