import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/controllers/user_controller.dart';
import 'package:rodocalc/app/data/controllers/vehicle_controller.dart';
import 'package:rodocalc/app/data/models/user_model.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/services.dart';

import '../../../data/base_url.dart';

class CreateUserModal extends GetView<UserController> {
  const CreateUserModal(
      {super.key,
      required this.isUpdate,
      required this.vehicleController,
      this.user});

  final bool isUpdate;
  final VehicleController vehicleController;
  final User? user;

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
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 5),
                        child: Text(
                          isUpdate ? 'EDITAR USUÁRIO' : 'CADASTRO DE USUÁRIO',
                          style: const TextStyle(
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
                                child: controller.setImage.value == true
                                    ? Image.network(
                                        "$urlImagem/storage/fotos/users/${controller.selectedImagePath.value}")
                                    : controller.selectedImagePath.value != ''
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
                        onChanged: (text) {
                          controller.txtNomeController.value = TextEditingValue(
                            text: text.toUpperCase(),
                            selection: controller.txtNomeController.selection,
                          );
                        },
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
                        onChanged: (text) {
                          controller.txtApelidoController.value =
                              TextEditingValue(
                            text: text.toUpperCase(),
                            selection:
                                controller.txtApelidoController.selection,
                          );
                        },
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
                        keyboardType: TextInputType.number,
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
                          if (isUpdate) {
                            return null;
                          }
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
                          if (isUpdate) {
                            return null;
                          }
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
                          decoration: const InputDecoration(
                            labelText: 'VEÍCULO',
                          ),
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('Selecione um Veículo'),
                            ),
                            ...vehicleController.listVehiclesDropDown
                                .map((Vehicle vehicle) {
                              // Verifique se plan.id é nulo e use um valor padrão se necessário
                              if (vehicle.id == null) {
                                return DropdownMenuItem<int?>(
                                  value: null,
                                  // Ou qualquer outro valor que não conflite
                                  child: Text(vehicle.modelo ??
                                      'Descrição não disponível'),
                                );
                              }

                              return DropdownMenuItem<int?>(
                                value: vehicle.id,
                                child: Container(
                                  constraints:
                                      BoxConstraints(maxWidth: Get.width * .7),
                                  child: Text(
                                    "${vehicle.modelo} - ${vehicle.placa}",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }),
                          ],
                          onChanged: (newValue) {
                            controller.selectedVehicleDropDown.value =
                                newValue!;
                          },
                          // value: controller.selectedVehicleDropDown.value,
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor, selecione um veículo';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "VEÍCULOS DO MOTORISTA SELECIONADO:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Obx(() => Text(
                            controller.tituloVeiculosDoMotorista.value,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                      if (user != null && user!.vehicles != null) ...[
                        const SizedBox(height: 16),
                        ...user!.vehicles!.map((vehicle) => ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              leading: const Icon(Icons.directions_car,
                                  color: Colors.blue),
                              title: Text(
                                '${vehicle.marca} ${vehicle.modelo}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Placa: ${vehicle.placa}',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => {
                                  _confirmarRemocao(
                                      context, vehicle.id!, user!.id!)
                                },
                              ),
                            )),
                      ],
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
                            onPressed: () async {
                              Map<String, dynamic> retorno = isUpdate
                                  ? await controller.updateUser(user!.id!)
                                  : await controller.insertUser();
                              if (retorno['success'] == true) {
                                controller.clearAllFields();
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
                            child: Text(
                              isUpdate ? 'ALTERAR' : 'CADASTRAR',
                              style: const TextStyle(
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

  void _confirmarRemocao(BuildContext context, int veiculoId, int userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Exclusão"),
          content: const Text("Tem certeza que deseja excluir?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Fechar o diálogo
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Map<String, dynamic> retorno =
                    await controller.deleteVehicleUser(veiculoId, userId);
                if (retorno['success'] == true) {
                  Get.back();
                  Get.snackbar('Sucesso!', retorno['message'].join('\n'),
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                      snackPosition: SnackPosition.BOTTOM);
                } else {
                  Get.snackbar('Falha!', retorno['message'].join('\n'),
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
              child: const Text("Excluir", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
