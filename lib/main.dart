import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rodocalc/app/data/bindings/initial_binding.dart';
import 'package:rodocalc/app/routes/app_pages.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/theme/app_theme.dart';
import 'package:rodocalc/app/utils/dynamic_link_handler.dart';

void main() async {
  await GetStorage.init('rodocalc');
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  DynamicLinkHandler.instance.initialize();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark));

  runApp(GetMaterialApp(
    locale: const Locale('pt', 'BR'),
    supportedLocales: const [
      Locale('pt', 'BR'), // Suporte para pt-BR
      Locale('en', 'US'), // Suporte para en-US (padrão)
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
