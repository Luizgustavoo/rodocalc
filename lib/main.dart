import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  DynamicLinkHandler.instance.initialize();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark));

  runApp(GetMaterialApp(
    title: 'RodoCalc',
    debugShowCheckedModeBanner: false,
    theme: appThemeData,
    initialRoute: Routes.initial,
    initialBinding: InitialBinding(),
    getPages: AppPages.routes,
  ));
}
