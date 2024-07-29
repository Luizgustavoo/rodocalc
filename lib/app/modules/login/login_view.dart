import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/login_controller.dart';
import 'package:rodocalc/app/routes/app_routes.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.5),
          BlendMode.darken,
        ),
        image: const AssetImage(
          'assets/images/background.jpg',
        ),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo_laranja.png',
                        height: 100,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: controller.loginKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controller.emailController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined),
                                labelText: 'E-MAIL',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira seu email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Por favor, insira um email válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Obx(() {
                              return TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira sua senha';
                                  }
                                  if (value.length < 6) {
                                    return 'A senha deve ter pelo menos 6 caracteres';
                                  }
                                  return null;
                                },
                                controller: controller.passwordController,
                                obscureText: controller.isPasswordHidden.value,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.key_outlined),
                                  labelText: 'SENHA',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isPasswordHidden.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      controller.isPasswordHidden.value =
                                          !controller.isPasswordHidden.value;
                                    },
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'ESQUECEU A SENHA?',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Obx(
                              () => Visibility(
                                //visible: !controller.loading.value,
                                visible: true,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.login();
                                      Get.offAllNamed(Routes.home);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 100,
                                        vertical: 15,
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                    child: controller.isLoading.value
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text(
                                            'ENTRAR',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontFamily: 'Inter-Bold'),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed('/signup');
                              },
                              child: const Text(
                                'CRIAR UMA CONTA',
                                style: TextStyle(
                                    color: Color(0xFFFF6B00),
                                    fontFamily: 'Inter-Bold'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
