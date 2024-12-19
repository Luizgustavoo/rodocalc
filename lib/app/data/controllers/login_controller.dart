import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rodocalc/app/data/controllers/user_controller.dart';
import 'package:rodocalc/app/data/controllers/vehicle_controller.dart';
import 'package:rodocalc/app/data/models/auth_model.dart';
import 'package:rodocalc/app/data/repositories/auth_repository.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final forgotPasswordEmailController = TextEditingController();
  final loginKey = GlobalKey<FormState>();
  final forgotKey = GlobalKey<FormState>();
  final RxBool isImageLoaded = false.obs;
  var isPasswordHidden = true.obs;

  final repository = Get.put(AuthRepository());
  final box = GetStorage('rodocalc');
  RxBool loading = false.obs;
  RxBool isLoadingForgot = false.obs;

  Auth? auth;
  RxBool showErrorSnackbar = false.obs;

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  @override
  void onInit() {
    preloadImage();
    super.onInit();
  }

  void clearAllFields() {
    final textControllers = [
      emailController,
      passwordController,
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
  }

  Future<void> preloadImage() async {
    await precacheImage(
        const AssetImage('assets/images/background.jpg'), Get.context!);
    isImageLoaded.value = true;
  }

  void login() async {
    if (loginKey.currentState!.validate()) {
      loading.value = true;

      auth = await repository.getLogin(
          emailController.text, passwordController.text);

      if (auth != null) {
        box.write('auth', auth?.toJson());
        clearAllFields();
        Get.offAllNamed('/home');

        String? tokenFirebase = (Platform.isAndroid
            ? await FirebaseMessaging.instance.getToken()
            : await FirebaseMessaging.instance.getAPNSToken());

        if (tokenFirebase!.trim().isNotEmpty) {
          await Get.find<UserController>()
              .updateFirebaseTokenUser(tokenFirebase: tokenFirebase);
        }

        final vehicleController = Get.put(VehicleController());
        vehicleController.getAll();
        if (vehicleController.listVehicles.isNotEmpty) {
          box.write('vehicle', vehicleController.listVehicles.first.toJson());
        }
      } else {
        showErrorSnackbar.value = true;
        showErrorMessage();
      }

      loading.value = false;
    }
  }

  Future<Map<String, dynamic>> forgotPassword() async {
    isLoadingForgot(true);
    mensagem =
        await repository.forgotPassword(forgotPasswordEmailController.text);
    if (mensagem != null) {
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
    } else {
      retorno = {
        'success': false,
        'message': ['Falha ao realizar a operação!']
      };
    }
    isLoadingForgot(false);
    return retorno;
  }

  void showErrorMessage() {
    if (showErrorSnackbar.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Erro de Autenticação',
          'Usuário e/ou senha inválidos',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        showErrorSnackbar.value = false;
      });
    }
  }

  void logout() async {
    loading.value = true;
    //await FirebaseMessaging.instance.deleteToken();
    repository.getLogout();
    loading.value = false;
  }
}
