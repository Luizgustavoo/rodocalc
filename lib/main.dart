import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rodocalc/app/data/bindings/initial_binding.dart';
import 'package:rodocalc/app/routes/app_pages.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/theme/app_theme.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark));
  await GetStorage.init('rodocalc');
  runApp(GetMaterialApp(
    title: 'RodoCalc',
    debugShowCheckedModeBanner: false,
    theme: appThemeData,
    initialRoute: Routes.initial,
    initialBinding: InitialBinding(),
    getPages: AppPages.routes,
  ));
}
