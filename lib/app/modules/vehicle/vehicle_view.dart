import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/vehicle_controller.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/modules/vehicle/widgets/create_vehicle_modal.dart';
import 'package:rodocalc/app/modules/vehicle/widgets/custom_vehicle_card.dart';

class VehiclesView extends GetView<VehiclesController> {
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
                SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: const Icon(Icons.search_rounded),
                              labelText: 'PESQUISAR VEÍCULO',
                            ),
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
                            } else if (!controller.isLoading.value && controller.listVehicles.isNotEmpty) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: controller.listVehicles.length,
                                itemBuilder: (context, index) {
                                  final Vehicle vehicle = controller.listVehicles[index];
                                  return InkWell(
                                    onTap: (){
                                      controller.selectedVehicle = vehicle;
                                      controller.fillInFields();
                                      controller.isLoading.value = false;
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => CreateVehicleModal(
                                          vehicle: vehicle,
                                          update: true,
                                        ),
                                      );

                                    },
                                    child: CustomVehicleCard(
                                      foto: vehicle.foto!,
                                      modelo: vehicle.modelo!,
                                      placa: vehicle.placa!,
                                      ano: vehicle.ano!,
                                      fipe: vehicle.fipe!,
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: Text('Nenhum veículo encontrado!'),
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFFF6B00),
          onPressed: () {
            controller.isLoading.value = false;
            controller.selectedImagePath.value = "";
            controller.clearAllFields();
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => CreateVehicleModal(update: false,),
            );
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
