import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/controllers/user_controller.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/services.dart';

class CreateUserModal extends GetView<UserController> {
  const CreateUserModal({super.key, required this.update});

  final bool update;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        key: controller.formUserKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 5),
                        child: Text(
                          'CADASTRO DE USUÁRIO',
                          style: TextStyle(
                              fontFamily: 'Inter-Bold',
                              fontSize: 17,
                              color: Color(0xFFFF6B00)),
                        ),
                      ),
                      const Divider(
                        endIndent: 20,
                        indent: 20,
                        height: 5,
                        thickness: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => _showPicker(context),
                        child: Obx(() => ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey,
                                child: controller.selectedImagePath.value != ''
                                    ? Image.file(
                                        File(
                                            controller.selectedImagePath.value),
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(
                                        Icons.camera_alt,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                              ),
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
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.txtTelefoneController,
                        maxLength: 15,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone_android_rounded),
                            labelText: 'TELEFONE',
                            counterText: ''),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          FormattedInputers.onContactChanged(
                              value, controller.txtTelefoneController);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Digite o telefone";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.txtCpfController,
                        maxLength: 14,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.contacts_rounded),
                            labelText: 'CPF',
                            counterText: ''),
                        onChanged: (value) {
                          FormattedInputers.onCpfChanged(
                              value, controller.txtCpfController);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Digite seu cpf ou cnpj";
                          }
                          if (!Services.validCPF(value) &&
                              !Services.validCNPJ(value)) {
                            return "Digite um cpf ou cnpj válido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.txtApelidoController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.message_rounded),
                          labelText: 'APELIDO OU TRANSPORTADORA',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Focus(
                        onFocusChange: (hasFocus) async {
                          if (!hasFocus) {
                            controller.fetchAddressFromCep(
                                controller.cepController.text);
                          }
                        },
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controller.cepController,
                          onChanged: (value) => controller.onCEPChanged(value),
                          maxLength: 9,
                          decoration: InputDecoration(
                            counterText: '',
                            suffixIcon: IconButton(
                                splashRadius: 2,
                                iconSize: 20,
                                onPressed: () {
                                  controller.fetchAddressFromCep(
                                      controller.cepController.text);
                                },
                                icon: const Icon(
                                  Icons.search_rounded,
                                )),
                            labelText: 'CEP',
                            prefixIcon: const Icon(Icons.location_pin),
                          ),
                          validator: (value) {
                            if (!controller.validateCEP()) {
                              return 'CEP inválido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.addressController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.home),
                          labelText: 'ENDEREÇO',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite o endereço';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.neighborhoodController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.location_city),
                          labelText: 'BAIRRO',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite o bairro';
                          }
                          return null;
                        },
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Digite a sua cidade";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Obx(() {
                              return DropdownButtonFormField<String>(
                                value: controller.selectedState.value.isEmpty
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
                                      'ESTADO',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
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
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.houseNumberController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.numbers),
                          labelText: 'NÚMERO',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite o número da casa';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.txtEmailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'E-MAIL',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu email';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Por favor, insira um email válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.txtSenhaController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.key),
                          labelText: 'SENHA',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua senha';
                          }
                          if (value.length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.txtConfirmaSenhaController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.key),
                          labelText: 'CONFIRME SUA SENHA',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, confirme sua senha';
                          }
                          if (value != controller.txtSenhaController.text) {
                            return 'As senhas não coincidem';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 120,
                            child: TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text(
                                  'CANCELAR',
                                  style: TextStyle(
                                      fontFamily: 'Inter-Bold',
                                      color: Color(0xFFFF6B00)),
                                )),
                          ),
                          const SizedBox(width: 10),
                          CustomElevatedButton(
                            onPressed: () async {},
                            child: const Text(
                              'CADASTRAR',
                              style: TextStyle(
                                  fontFamily: 'Inter-Bold',
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
