import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/controllers/login_controller.dart';
// import 'package:rodocalc/app/data/controllers/city_state_controller.dart';
import 'package:rodocalc/app/data/controllers/perfil_controller.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/data/controllers/signup_controller.dart';
import 'package:rodocalc/app/data/models/user_plan_model.dart';
import 'package:rodocalc/app/data/models/user_type_model.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';
import 'package:rodocalc/app/utils/services.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:searchfield/searchfield.dart';

class PerfilView extends GetView<PerfilController> {
  const PerfilView({super.key});

  // final cityController = Get.put(CityStateController());

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
                          TextFormField(
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
                          const Divider(
                            color: Colors.orange,
                            thickness: 2,
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'CONTA ATUAL: ${ServiceStorage.getUserTypeName()}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Altere a opção abaixo apenas se desejar modificar seu tipo de conta. Essa ação cancelará sua assinatura atual e exigirá que você assine uma nova.',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Obx(
                            () => Card(
                              color: Colors.black,
                              surfaceTintColor: Colors.black,
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: DropdownButtonFormField<int?>(
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.people),
                                  labelText: 'ALTERAR TIPO DE CONTA',
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
                                  ...Get.put(SignUpController())
                                      .listUserTypes
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
                                  controller.userTypeUpdateController.value =
                                      newValue!;
                                },
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.orange,
                            thickness: 2,
                            height: 15,
                          ),
                          const SizedBox(height: 20),
                          CustomElevatedButton(
                            height: 50,
                            width: double.infinity,
                            onPressed: () async {
                              if (controller.userTypeUpdateController.value >
                                      0 &&
                                  controller.userTypeUpdateController.value !=
                                      ServiceStorage.getUserTypeId()) {
                                Get.defaultDialog(
                                  titlePadding: const EdgeInsets.all(16),
                                  contentPadding: const EdgeInsets.all(16),
                                  title: "Confirmação",
                                  content: const Text(
                                    textAlign: TextAlign.center,
                                    "Você está mudando seu TIPO DE CONTA, isso cancelará sua assinatura. Deseja continuar?",
                                    style: TextStyle(
                                      fontFamily: 'Inter-Regular',
                                      fontSize: 18,
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        Map<String, dynamic> retorno =
                                            await controller.updateUser();

                                        if (retorno['success'] == true) {
                                          final planController =
                                              Get.put(PlanController());

                                          planController.getMyPlans();
                                          List<UserPlan> userPlan =
                                              planController.myPlans;

                                          if (userPlan.isNotEmpty) {
                                            Map<String, dynamic>
                                                retornoCancelAssignature =
                                                await planController
                                                    .cancelSubscribe(userPlan
                                                        .first.assignatureId
                                                        .toString());
                                            Get.back();
                                            final loginController =
                                                Get.put(LoginController());
                                            loginController.logout();
                                          }

                                          Get.back();
                                          Get.snackbar('Sucesso!',
                                              retorno['message'].join('\n'),
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration:
                                                  const Duration(seconds: 2),
                                              snackPosition:
                                                  SnackPosition.BOTTOM);
                                        } else {
                                          Get.snackbar('Falha!',
                                              retorno['message'].join('\n'),
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                              duration:
                                                  const Duration(seconds: 2),
                                              snackPosition:
                                                  SnackPosition.BOTTOM);
                                        }
                                      },
                                      child: const Text(
                                        "CONFIRMAR",
                                        style: TextStyle(
                                            fontFamily: 'Poppinss',
                                            color: Colors.white),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text(
                                        "CANCELAR",
                                        style:
                                            TextStyle(fontFamily: 'Poppinss'),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
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
                            onPressed: () {
                              showDeleteDialog(context, controller);
                            },
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

  Future<void> showDeleteDialog(
      BuildContext context, PerfilController controller) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Atenção',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Inter-Bold',
                        fontSize: 20,
                        color: Colors.deepOrange),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    'Tem certeza que deseja excluir sua conta?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter-Regular',
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 110,
                        child: ElevatedButton(
                          onPressed: () async {
                            var retorno = await controller.deleteAccount();

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
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'EXCLUIR',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.white),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('CANCELAR',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
