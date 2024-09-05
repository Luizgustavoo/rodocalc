import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rodocalc/app/data/controllers/vehicle_controller.dart';
import 'package:rodocalc/app/data/models/auth_model.dart';
import 'package:rodocalc/app/data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginKey = GlobalKey<FormState>();
  final RxBool isImageLoaded = false.obs;
  var isPasswordHidden = true.obs;

  final repository = Get.put(AuthRepository());
  final box = GetStorage('rodocalc');
  RxBool loading = false.obs;

  Auth? auth;
  RxBool showErrorSnackbar = false.obs;

  @override
  void onInit() {
    preloadImage();
    super.onInit();
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
        Get.offAllNamed('/home');

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
