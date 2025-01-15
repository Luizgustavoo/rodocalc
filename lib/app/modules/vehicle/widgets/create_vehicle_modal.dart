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
                          child: controller.editMode.value &&
                                  controller.setImage.value == true &&
                                  controller.selectedImagePath.value != "" &&
                                  !controller.newImage.value
                              ? Image.network(
                                  "$urlImagem/storage/fotos/veiculos/${controller.selectedImagePath.value}")
                              : controller.selectedImagePath.value != '' &&
                                      controller.newImage.value
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
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max, // Ajuste aqui
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.txtPlateController,
                          onChanged: (text) {
                            final sanitizedText =
                                FormattedInputers.sanitizePlate(text);
                            controller.txtPlateController.value =
                                TextEditingValue(
                              text: sanitizedText,
                              selection: TextSelection.collapsed(
                                  offset: sanitizedText.length),
                            );
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.abc_rounded,
                              size: 25,
                            ),
                            labelText: 'PLACA',
                          ),
                          validator: (value) {
                            if (!FormattedInputers.validatePlate(value!)) {
                              return 'Por favor, insira uma placa válida';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                          width: 10), // Espaço entre o campo e o botão
                      CustomElevatedButton(
                        onPressed: controller.isLoadingPlate.value
                            ? () {}
                            : () async {
                                if (FormattedInputers.validatePlate(
                                    controller.txtPlateController.text)) {
                                  controller.isLoadingPlate.value = true;
                                  controller.searchPlates().then((_) {
                                    controller.isLoadingPlate.value = false;
                                    controller.areFieldsVisible.value = true;
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
                        child: controller.isLoadingPlate.value
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Buscar',
                                style: TextStyle(
                                  fontFamily: 'Inter-Bold',
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),

                Obx(() => !controller.isLoadingPlate.value
                    ? const SizedBox.shrink()
                    : const SizedBox(height: 40)),

                //CAMPOS INVISIVEIS

                Obx(
                  () => Visibility(
                    visible: controller.areFieldsVisible.value ||
                        controller.editMode.value,
                    child: Column(
                      children: [
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
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: controller.txtFipeValueController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.monetization_on),
                            labelText: 'VALOR FIPE',
                          ),
                          onChanged: (value) {
                            FormattedInputers.onformatValueChanged(
                                value, controller.txtFipeValueController);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o valor FIPE';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: controller.txtKmInicialController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            counterText: '',
                            prefixIcon: Icon(Icons.add_road_sharp),
                            labelText: 'KM INICIAL',
                          ),
                          onChanged: (value) {
                            FormattedInputers.formatAndUpdateText(
                                controller.txtKmInicialController);
                          },
                        ),
                        const SizedBox(height: 10),
                        Obx(
                          () {
                            // Configura o primeiro item como selecionado automaticamente
                            if (controller.listMyPlans.isNotEmpty &&
                                controller.selectedPlanDropDown.value == 0) {
                              controller.selectedPlanDropDown.value =
                                  controller.listMyPlans.first.planousuarioId!;
                            }

                            return Visibility(
                              visible: false, // Torna o campo invisível
                              child: DropdownButtonFormField<int?>(
                                decoration: const InputDecoration(
                                  labelText: 'Plano',
                                ),
                                items: controller.listMyPlans
                                    .map((UserPlanDropdown plan) {
                                  String subtitulo = "";
                                  if (plan.totalVeiculosAtivos! > 0) {
                                    subtitulo =
                                        "- ${plan.totalVeiculosAtivos} veículo(s) cadastrado(s)";
                                  }
                                  return DropdownMenuItem<int?>(
                                    value: plan.planousuarioId,
                                    child: Text(
                                      "${plan.descricao} $subtitulo",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  controller.selectedPlanDropDown.value =
                                      newValue ?? 0;
                                },
                                value: controller.selectedPlanDropDown.value,
                                validator: (value) {
                                  if (value == null || value == 0) {
                                    return 'Por favor, selecione um plano';
                                  }
                                  return null;
                                },
                              ),
                            );
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
                              onPressed: controller.isLoadingCRUD.value
                                  ? () {}
                                  : () async {
                                      // if (controller
                                      //     .selectedImagePath.value.isEmpty) {
                                      //   Get.snackbar('Atenção!',
                                      //       "Selecione uma imagem para o veículo!",
                                      //       backgroundColor: Colors.orange,
                                      //       colorText: Colors.white,
                                      //       duration: const Duration(seconds: 2),
                                      //       snackPosition: SnackPosition.BOTTOM);
                                      // }
                                      Map<String, dynamic> retorno = update
                                          ? await controller
                                              .updateVehicle(vehicle!.id!)
                                          : await controller.insertVehicle();

                                      if (retorno['success'] == true) {
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
                              child: controller.isLoadingCRUD.value
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      vehicle == null ? 'CADASTRAR' : 'ALTERAR',
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

                const SizedBox(height: 20),
                //FIM CAMPOS INVISIVEIS
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
