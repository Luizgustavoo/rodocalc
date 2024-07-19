import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:rodocalc/app/routes/app_pages.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/theme/app_theme.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark));
  runApp(GetMaterialApp(
    title: 'Rodo Calc',
    debugShowCheckedModeBanner: false,
    theme: appThemeData,
    initialRoute: Routes.login,
    getPages: AppPages.routes,
  ));
}
