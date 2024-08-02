import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/login_controller.dart';

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
            Positioned(
              top: 40,
              left: 120,
              child: Image.asset(
                'assets/images/logo_laranja.png',
                height: 100,
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height /
                          2), // Ajuste a altura conforme necessário
                  Card(
                    color: Colors.white,
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
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Obx(
                                    () => Visibility(
                                      visible: !controller.loading.value,
                                      child: ElevatedButton(
                                        child: const Text(
                                          'ENTRAR',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Inter-Black',
                                              color: Colors.white),
                                        ),
                                        onPressed: () {
                                          controller.login();
                                        },
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => Visibility(
                                      visible: controller.loading.value,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 5,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
