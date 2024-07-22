import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/controllers/signup_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 30,
            ),
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 90),
                  child: Text(
                    'CRIAR CONTA',
                    style: TextStyle(
                        fontFamily: 'Inter-Regular', color: Color(0xFFFF6B00)),
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
              child: Image.asset(
                'assets/images/signup.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formSignupKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _showPicker(context),
                            child: Obx(() => CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: controller
                                              .selectedImagePath.value !=
                                          ''
                                      ? FileImage(File(
                                          controller.selectedImagePath.value))
                                      : null,
                                  child:
                                      controller.selectedImagePath.value == ''
                                          ? const Icon(
                                              Icons.camera_alt,
                                              size: 50,
                                              color: Colors.white,
                                            )
                                          : null,
                                )),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: controller.txtNomeController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'NOME COMPLETO',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: controller.txtTelefoneController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              labelText: 'TELEFONE',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: controller.txtCidadeController,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.location_city),
                                    labelText: 'CIDADE',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: Obx(() {
                                  return DropdownButtonFormField<String>(
                                    value: controller.selectedState.value == ''
                                        ? null
                                        : controller.selectedState.value,
                                    decoration: const InputDecoration(
                                      labelText: 'UF',
                                    ),
                                    items:
                                        controller.states.map((String state) {
                                      return DropdownMenuItem<String>(
                                        value: state,
                                        child: Text(state),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      controller.selectedState.value =
                                          newValue!;
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: controller.txtCpfController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.credit_card),
                              labelText: 'CPF',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: controller.txtApelidoController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.business),
                              labelText: 'APELIDO OU TRANSPORTADORA',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: controller.txtEmailController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'E-MAIL',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: controller.txtSenhaController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.key),
                              labelText: 'SENHA',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: controller.txtConfirmaSenhaController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.key),
                              labelText: 'CONFIRME SUA SENHA',
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 100,
                                vertical: 15,
                              ),
                              backgroundColor: Colors.orange,
                            ),
                            child: const Text(
                              'SALVAR',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Inter-Bold',
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  controller.pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  controller.pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
