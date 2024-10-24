import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/vehicle_controller.dart';
import 'package:rodocalc/app/data/models/user_plan_dropdown.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class CreateVehicleModal extends GetView<VehicleController> {
  const CreateVehicleModal({super.key, this.vehicle, required this.update});

  final Vehicle? vehicle;
  final bool update;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
          key: controller.formKeyVehicle,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                    vehicle == null
                        ? 'CADASTRO DE VEÍCULO'
                        : 'ALTERAR VEÍCULO: ${vehicle!.marca!.toUpperCase()}',
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
                                  "$urlImagem/storage/fotos/veiculos/${controller.selectedImagePath.value}")
                              : controller.selectedImagePath.value != ''
                                  ? Image.file(
                                      File(controller.selectedImagePath.value),
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
                const SizedBox(height: 10),
                Obx(() => TextFormField(
                      controller: controller.txtPlateController,
                      onChanged: (text) {
                        controller.txtPlateController.value = TextEditingValue(
                          text: text.toUpperCase(),
                          selection: controller.txtPlateController.selection,
                        );
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.abc_rounded,
                          size: 25,
                        ),
                        labelText: 'PLACA',
                        suffixIcon: controller.isLoading.value
                            ? const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(),
                              )
                            : IconButton(
                                onPressed: () {
                                  if (FormattedInputers.validatePlate(
                                      controller.txtPlateController.text)) {
                                    controller.isLoading.value = true;
                                    controller.searchPlates().then((_) {
                                      controller.isLoading.value = false;
                                    });
                                  } else {
                                    Get.snackbar('Atenção!',
                                        'Por favor, insira uma placa válida',
                                        backgroundColor: Colors.orange,
                                        colorText: Colors.white,
                                        duration: const Duration(seconds: 2),
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                },
                                icon: const Icon(Icons.search),
                              ),
                      ),
                      validator: (value) {
                        if (!FormattedInputers.validatePlate(value!)) {
                          return 'Por favor, insira uma placa válida';
                        }
                        return null;
                      },
                    )),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.txtBrandController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.local_offer,
                    ),
                    labelText: 'MARCA',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a marca';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.txtYearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.calendar_month_outlined,
                    ),
                    labelText: 'ANO',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o ano';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.txtModelController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.directions_car_filled,
                    ),
                    labelText: 'MODELO',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o modelo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.txtFipeController,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  decoration: const InputDecoration(
                    counterText: '',
                    prefixIcon: Icon(Icons.star_border),
                    labelText: 'CÓDIGO FIPE',
                  ),
                  onChanged: (value) {
                    FormattedInputers.onFipeCodeChanged(
                        value, controller.txtFipeController);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o código FIPE';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Obx(
                  () => DropdownButtonFormField<int?>(
                    decoration: const InputDecoration(
                      labelText: 'Plano',
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: 0,
                        child: Text('Selecione um plano'),
                      ),
                      ...controller.listMyPlans.map((UserPlanDropdown plan) {
                        String subtitulo = "";
                        if (plan.totalVeiculosAtivos! > 0) {
                          subtitulo =
                              "- ${plan.totalVeiculosAtivos} veículo(s) cadastrado(s)";
                        }
                        return DropdownMenuItem<int?>(
                          value: plan.planousuarioId,
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: Get.width * .7),
                            child: Text(
                              "${plan.descricao} $subtitulo",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }),
                    ],
                    onChanged: (newValue) {
                      controller.selectedPlanDropDown.value = newValue ?? 0;
                    },
                    value: controller.listMyPlans.any((plan) =>
                            plan.planousuarioId ==
                            controller.selectedPlanDropDown.value)
                        ? controller.selectedPlanDropDown.value
                        : 0,
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Por favor, selecione um plano';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Obx(() => Switch(
                          activeColor: Colors.orange.shade700,
                          inactiveThumbColor: Colors.orange.shade500,
                          inactiveTrackColor: Colors.orange.shade100,
                          value: controller.trailerCheckboxValue.value,
                          onChanged: (value) {
                            controller.trailerCheckboxValue.value = value;
                          },
                        )),
                    const SizedBox(width: 10),
                    const Text(
                      'REBOQUE',
                      style: TextStyle(
                          fontFamily: 'Inter-Bold', color: Colors.black54),
                    ),
                  ],
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
                      onPressed: () async {
                        if (controller.selectedImagePath.value.isEmpty) {
                          Get.snackbar('Atenção!',
                              "Selecione uma imagem para o veículo!",
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                              snackPosition: SnackPosition.BOTTOM);
                        } else {
                          Map<String, dynamic> retorno = update
                              ? await controller.updateVehicle(vehicle!.id!)
                              : await controller.insertVehicle();

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
                      child: Text(
                        vehicle == null ? 'CADASTRAR' : 'ALTERAR',
                        style: const TextStyle(
                            fontFamily: 'Inter-Bold', color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
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
