import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Pode adicionar lógica para exibir apenas em certas rotas se quiser
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.rawSnackbar(
        title: "Aviso Importante",
        message: "Esta é uma mensagem global exibida em todas as páginas.",
        backgroundColor: Colors.blueAccent,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    });
    return null;
  }
}
