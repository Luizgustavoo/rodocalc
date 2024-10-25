import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/controllers/signup_controller.dart';
import 'package:rodocalc/app/data/models/user_type_model.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
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
              height: 40,
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
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: controller.formSignupKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        children: [
                          GestureDetector(
                            onTap: () => _showPicker(context),
                            child: Obx(() => ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey,
                                    child:
                                        controller.selectedImagePath.value != ''
                                            ? Image.file(
                                                File(controller
                                                    .selectedImagePath.value),
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
                            maxLength: 18,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.contacts_rounded),
                                labelText: 'CPF/CNPJ',
                                counterText: ''),
                            onChanged: (value) {
                              FormattedInputers.onCPFCNPJChanged(
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
                              onChanged: (value) =>
                                  controller.onCEPChanged(value),
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
                                    value:
                                        controller.selectedState.value.isEmpty
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
                            controller: controller.houseNumberController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.numbers),
                              labelText: 'NÚMERO',
                            ),
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
                          Obx(
                            () => DropdownButtonFormField<int?>(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.people),
                                labelText: 'TIPO DE REGISTRO',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                    // Borda cinza clara
                                    width:
                                        1.0, // Ajuste a espessura da borda se necessário
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Ajuste o raio da borda
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                    // Borda cinza mais escura ao focar
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              items: [
                                const DropdownMenuItem<int?>(
                                  value: 0,
                                  child: Text('Selecione um tipo'),
                                ),
                                ...controller.listUserTypes
                                    .map((UserType type) {
                                  // Verifique se plan.id é nulo e use um valor padrão se necessário
                                  if (type.id == null) {
                                    return DropdownMenuItem<int?>(
                                      value: null,
                                      // Ou qualquer outro valor que não conflite
                                      child: Text(type.descricao ??
                                          'Descrição não disponível'),
                                    );
                                  }

                                  return DropdownMenuItem<int?>(
                                    value: type.id,
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: Get.width * .7),
                                      child: Text(
                                        "${type.descricao}",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                              onChanged: (newValue) {
                                controller.selectedUserType.value = newValue!;
                              },
                              value: controller.selectedUserType.value,
                              validator: (value) {
                                if (value == null) {
                                  return 'Por favor, selecione um tipo de registro';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => TextFormField(
                              controller:
                                  controller.txtCodigoIndicadorController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade400,
                                  prefixIcon: const Icon(Icons.code_sharp),
                                  labelText:
                                      'CÓDIGO DO INDICADOR: ${controller.indicatorName.value}',
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        if (await controller.getIndicador() ==
                                            false) {
                                          controller
                                              .txtCodigoIndicadorController
                                              .text = "";
                                        }
                                      },
                                      icon: const Icon(Icons.add_circle))),
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomElevatedButton(
                            height: 50,
                            width: double.infinity,
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
                            child: const Text(
                              'SALVAR',
                              style: TextStyle(
                                  fontFamily: 'Inter-Bold',
                                  fontSize: 18,
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
