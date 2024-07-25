import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/controllers/signup_controller.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/phone_mask.dart';
import 'package:rodocalc/app/utils/services.dart';

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
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Digite o nome completo";
                              }
                              List<String> nameParts = value.split(' ');
                              if (nameParts.length < 2) {
                                return "Digite o nome completo (nome e sobrenome)";
                              }
                              return null; // Return null if the input is valid
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: controller.txtTelefoneController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              labelText: 'TELEFONE',
                            ),
                            keyboardType: TextInputType.phone,
                            onChanged: (value){
                              FormattedInputers.onContactChanged(value, controller.txtTelefoneController);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Digite o telefone";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: controller.txtCidadeController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.location_city),
                                  labelText: 'CIDADE',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Digite a sua cidade natal";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              Obx(() {
                                return DropdownButtonFormField<String>(
                                  value: controller.selectedState.value == ''
                                      ? null
                                      : controller.selectedState.value,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.map),
                                    labelText: 'UF',
                                  ),
                                  items: [
                                    const DropdownMenuItem<String>(
                                      value: null,
                                      child: Text(
                                        'SELECIONE',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    ...controller.states.map((String state) {
                                      return DropdownMenuItem<String>(
                                        value: state,
                                        child: Text(state),
                                      );
                                    }),
                                  ],
                                  onChanged: (newValue) {
                                    controller.selectedState.value = newValue!;
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return "Selecione uma UF";
                                    }
                                    return null;
                                  },
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: controller.txtCpfController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.credit_card),
                              labelText: 'CPF',
                            ),
                            onChanged: (value){
                              FormattedInputers.onCpfChanged(value, controller.txtCpfController);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Digite seu cpf ou cnpj";
                              }
                              if (!Services.validCPF(value) && !Services.validCNPJ(value)) {
                                return "Digite um cpf ou cnpj válido";
                              }
                              return null;
                            },
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
                            onPressed: () async {
                              Map<String, dynamic> retorno =
                                  await controller.insertUser();

                              if (retorno['success'] == true) {
                                Get.back();
                                Get.snackbar(
                                    'Sucesso!', retorno['message'].join('\n'),
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 2),
                                    snackPosition: SnackPosition.BOTTOM);
                              } else {
                                Get.snackbar(
                                    'Falha!', retorno['message'].join('\n'),
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 2),
                                    snackPosition: SnackPosition.BOTTOM);
                              }
                            },
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
