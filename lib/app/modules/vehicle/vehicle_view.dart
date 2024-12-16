// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rodocalc/app/data/controllers/vehicle_controller.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/modules/global/custom_search_field.dart';
import 'package:rodocalc/app/modules/vehicle/widgets/create_vehicle_modal.dart';
import 'package:rodocalc/app/modules/vehicle/widgets/custom_vehicle_card.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class VehiclesView extends GetView<VehicleController> {
  const VehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'VEÍCULOS'),
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
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    controller.searchController.clear();
                    controller.listVehicles.clear();
                    controller.getAll();
                  },
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.all(12.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 5),
                            CustomSearchField(
                              labelText: 'PESQUISAR CAMINHÕES',
                              controller: controller.searchController,
                              onChanged: (value) {
                                controller.filterVehicles(value);
                              },
                            ),
                            const SizedBox(height: 16),
                            Obx(() {
                              if (controller.isLoading.value) {
                                return const Column(
                                  children: [
                                    Text('Carregando...'),
                                    SizedBox(height: 20.0),
                                    CircularProgressIndicator(),
                                  ],
                                );
                              } else if (!controller.isLoading.value &&
                                  controller.listVehicles.isNotEmpty) {
                                return Expanded(
                                    child: ListView.builder(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              .25),
                                  shrinkWrap: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: controller.filteredVehicles.length,
                                  itemBuilder: (context, index) {
                                    final Vehicle vehicle =
                                        controller.filteredVehicles[index];
                                    return InkWell(
                                      onTap: () {
                                        final box = GetStorage('rodocalc');
                                        box.write('vehicle', vehicle.toJson());

                                        Get.offAllNamed(Routes.home);
                                      },
                                      child: CustomVehicleCard(
                                        removeVehicle: () {
                                          if (ServiceStorage.getUserTypeId() !=
                                              4) {
                                            showDialog(
                                                context, vehicle, controller);
                                          } else {
                                            Get.snackbar(
                                              "Atenção",
                                              "Você não tem permissão para realizar esta ação",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.orange,
                                              duration:
                                                  const Duration(seconds: 2),
                                            );
                                          }
                                        },
                                        editVehicle: () {
                                          controller.isLoading.value = true;
                                          controller.selectedVehicle = vehicle;
                                          controller.getAllUserPlans();

                                          controller.fillInFields();
                                          controller.isLoading.value = false;
                                          controller.setImage.value = true;
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) =>
                                                CreateVehicleModal(
                                              vehicle: vehicle,
                                              update: true,
                                            ),
                                          );
                                        },
                                        vehicle: vehicle,
                                      ),
                                    );
                                  },
                                ));
                              } else {
                                return const Center(
                                  child: Text('NENHUM VEÍCULO CADASTRADO!'),
                                );
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ServiceStorage.getUserTypeId() == 4
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: FloatingActionButton(
                backgroundColor: const Color(0xFFFF6B00),
                onPressed: () async {
                  await controller.getQuantityLicences();
                  if (controller.vehiclesRegistered.value >=
                      controller.licences.value) {
                    Get.snackbar('Atenção!',
                        'A quantidade de licenças do seu plano estourou!',
                        backgroundColor: Colors.orange,
                        colorText: Colors.black,
                        duration: const Duration(seconds: 2),
                        snackPosition: SnackPosition.BOTTOM);
                  } else {
                    controller.isLoading.value = false;
                    controller.isLoadingPlate.value = false;
                    controller.areFieldsVisible.value = false;
                    controller.clearAllFields();
                    controller.getAllUserPlans();
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => const CreateVehicleModal(
                        update: false,
                      ),
                    );
                  }
                },
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}

void showDialog(context, Vehicle vehicle, VehicleController controller) {
  Get.defaultDialog(
    titlePadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.all(16),
    title: "Confirmação",
    content: Text(
      textAlign: TextAlign.center,
      "Tem certeza que deseja excluir o veículo ${vehicle.marca}?",
      style: const TextStyle(
        fontFamily: 'Inter-Regular',
        fontSize: 18,
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () async {
          Map<String, dynamic> retorno =
              await controller.deleteVehicle(vehicle.id!);

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
        child: const Text(
          "CONFIRMAR",
          style: TextStyle(fontFamily: 'Poppinss', color: Colors.white),
        ),
      ),
      TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text(
          "CANCELAR",
          style: TextStyle(fontFamily: 'Poppinss'),
        ),
      ),
    ],
  );
}
