// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
//import 'package:package_info_plus/package_info_plus.dart';
import 'package:rodocalc/app/data/bindings/initial_binding.dart';
import 'package:rodocalc/app/routes/app_pages.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/theme/app_theme.dart';
import 'package:rodocalc/app/utils/dynamic_link_handler.dart';
import 'package:rodocalc/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handler para mensagens recebidas em segundo plano
  print('Mensagem recebida em segundo plano: ${message.messageId}');
}

void main() async {
  await GetStorage.init('rodocalc');
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  DynamicLinkHandler.instance.initialize();

  final storage = GetStorage('rodocalc');
  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version;
  final storedVersion = storage.read('app_version');

  if (storedVersion != currentVersion) {
    await storage.erase();

    storage.write('app_version', currentVersion);
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String? token = (Platform.isAndroid
      ? await FirebaseMessaging.instance.getToken()
      : await FirebaseMessaging.instance.getAPNSToken());

  print("-------------");
  print(token);
  print("-------------");

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark));

  runApp(GetMaterialApp(
    locale: const Locale('pt', 'BR'),
    supportedLocales: const [
      Locale('pt', 'BR'),
      Locale('en', 'US'),
    ],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    title: 'RodoCalc',
    debugShowCheckedModeBanner: false,
    theme: appThemeData,
    initialRoute: Routes.initial,
    initialBinding: InitialBinding(),
    getPages: AppPages.routes,
  ));
}
