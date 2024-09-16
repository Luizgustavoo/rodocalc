import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/controllers/city_state_controller.dart';
import 'package:rodocalc/app/data/controllers/perfil_controller.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/services.dart';
import 'package:searchfield/searchfield.dart';

class PerfilView extends GetView<PerfilController> {
  PerfilView({super.key});

  final cityController = Get.put(CityStateController());

  String? _validateSenha(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Senha não é obrigatória
    }
    return null;
  }

  String? _validateConfirmaSenha(String? value) {
    if (controller.txtSenhaController.text.isNotEmpty) {
      if (value == null || value.isEmpty) {
        return 'Confirme sua senha';
      }
      if (value != controller.txtSenhaController.text) {
        return 'As senhas não coincidem';
      }
    }
    return null;
  }

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
                    'PERFIL',
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: controller.perfilKey,
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
                                            ? controller.selectedImagePath.value
                                                    .startsWith('http')
                                                ? Image.network(
                                                    controller.selectedImagePath
                                                        .value,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.file(
                                                    File(controller
                                                        .selectedImagePath
                                                        .value),
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
                                prefixIcon: Icon(Icons.phone),
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
                                prefixIcon: Icon(Icons.credit_card),
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
                              prefixIcon: Icon(Icons.business),
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
                          Obx(
                            () => SearchField<String>(
                              controller: controller.txtCidadeController,
                              suggestions: cityController.listCities
                                  .map((city) => SearchFieldListItem<String>(
                                      city.cidadeEstado!))
                                  .toList(),
                              searchInputDecoration: InputDecoration(
                                  labelText: cityController.isLoading.value
                                      ? "CARREGANDO"
                                      : "CIDADE",
                                  hintText: "Digite o nome da cidade",
                                  prefixIcon: Icon(Icons.location_city)),
                              onSuggestionTap: (suggestion) {
                                controller.txtCidadeController.text =
                                    suggestion.searchKey;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, selecione a origem';
                                }
                                // Verifica se a cidade está na lista de sugestões
                                bool isValidCity = cityController.listCities
                                    .any((city) => city.cidadeEstado == value);
                                if (cityController.listCities.isNotEmpty &&
                                    !isValidCity) {
                                  return 'Cidade não encontrada na lista';
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
                            validator: _validateSenha,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: controller.txtConfirmaSenhaController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.key),
                              labelText: 'CONFIRME SUA SENHA',
                            ),
                            validator: _validateConfirmaSenha,
                          ),
                          const SizedBox(height: 20),
                          CustomElevatedButton(
                            height: 50,
                            width: double.infinity,
                            onPressed: () async {
                              Map<String, dynamic> retorno =
                                  await controller.updateUser();

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
                          const SizedBox(height: 20),
                          CustomElevatedButton(
                            height: 40,
                            gradient: LinearGradient(colors: [
                              Colors.red,
                              Colors.redAccent.shade100
                            ]),
                            width: double.infinity,
                            onPressed: () {},
                            child: const Text(
                              'DELETAR CONTA',
                              style: TextStyle(
                                  fontFamily: 'Inter-Bold',
                                  fontSize: 15,
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
