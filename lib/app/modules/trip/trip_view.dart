import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/city_state_controller.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/modules/global/custom_search_field.dart';
import 'package:rodocalc/app/modules/trip/widgets/create_trip_modal.dart';
import 'package:rodocalc/app/modules/trip/widgets/custom_trip_card.dart';
import 'package:rodocalc/app/modules/trip/widgets/view_list_expense_trip_modal.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class TripView extends GetView<TripController> {
  const TripView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('TRECHOS',
                style: TextStyle(
                  fontFamily: 'Inter-Black',
                )),
            Text(
              ServiceStorage.titleSelectedVehicle(),
              style: const TextStyle(fontFamily: 'Inter-Regular', fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              "MOTORISTA: ${ServiceStorage.motoristaSelectedVehicle()}"
                  .toUpperCase(),
              style: const TextStyle(fontFamily: 'Inter-Regular', fontSize: 14),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50, right: 20),
            child: Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 100,
        flexibleSpace: Stack(
          children: [
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6),
                  BlendMode.darken,
                ),
                child: (!ServiceStorage.existsSelectedVehicle() ||
                        ServiceStorage.photoSelectedVehicle() == "")
                    ? Image.asset(
                        'assets/images/caminhao.jpg',
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        "$urlImagem/storage/fotos/veiculos/${ServiceStorage.photoSelectedVehicle()}",
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ),
      body: Stack(children: [
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              RefreshIndicator(
                onRefresh: () async {
                  controller.searchTripController.clear();
                  controller.listTrip.clear();
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
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const SizedBox(height: 5),
                        CustomSearchField(
                          labelText: 'PESQUISAR TRECHOS',
                          controller: controller.searchTripController,
                          onChanged: (value) {
                            controller.filterTrips(value);
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
                              controller.listTrip.isNotEmpty) {
                            return Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height *
                                        .30),
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: controller.filteredTrips.length,
                                itemBuilder: (context, index) {
                                  Trip trip = controller.filteredTrips[index];
                                  return CustomTripCard(
                                    trip: trip,
                                    functionRemove: () {
                                      controller.isDialogOpen.value = false;
                                      showDialog(context, trip, controller);
                                    },
                                    functionExpense: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) =>
                                            ViewListExpenseTripModal(
                                          trip: trip,
                                        ),
                                      );
                                    },
                                    functionClose: () {
                                      if (trip.dataHoraChegada == null ||
                                          trip.kmFinal == null ||
                                          trip.dataHoraChegada
                                              .toString()
                                              .isEmpty ||
                                          trip.kmFinal!.isEmpty) {
                                        Get.snackbar(
                                          'Falha!',
                                          'Preencha uma data/hora de chegada e o km final do veículo.',
                                          backgroundColor: Colors.orangeAccent,
                                          colorText: Colors.black,
                                          duration: const Duration(seconds: 3),
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      } else {
                                        controller.isDialogOpen.value = false;
                                        showDialogClose(
                                            context, trip, controller);
                                      }
                                    },
                                    functionEdit: () {
                                      controller.fillInFields(trip);
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => CreateTripModal(
                                          isUpdate: true,
                                          trip: trip,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text('NENHUM TRECHO CADASTRADO!'),
                            );
                          }
                        }),
                      ]),
                    ),
                  ),
                ),
              )
            ])),
      ]),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFFF6B00),
          onPressed: () {
            if (ServiceStorage.idSelectedVehicle() <= 0) {
              Get.snackbar('Atenção', 'Selecione um veículo antes!',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                  snackPosition: SnackPosition.BOTTOM);
            } else {
              final cityController = Get.put(CityStateController());
              cityController.getCities();

              controller.clearAllFields();
              controller.getMyChargeTypes();
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => CreateTripModal(isUpdate: false),
              );
            }
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

void showDialog(context, Trip trip, TripController controller) {
  if (controller.isDialogOpen.value) return;

  controller.isDialogOpen.value = true;
  Get.defaultDialog(
    titlePadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.all(16),
    title: "REMOVER TRECHO",
    content: const Text(
      textAlign: TextAlign.center,
      "Tem certeza que deseja excluir o trecho selecionado?",
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () async {
          Get.back(); // Fecha o diálogo atual primeiro
          await Future.delayed(const Duration(milliseconds: 500));
          Map<String, dynamic> retorno = await controller.deleteTrip(trip.id!);

          if (retorno['success'] == true) {
            Get.snackbar('Sucesso!', retorno['message'].join('\n'),
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 1),
                snackPosition: SnackPosition.BOTTOM);
          } else {
            Get.snackbar('Falha!', retorno['message'].join('\n'),
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 1),
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

void showDialogClose(context, Trip trip, TripController controller) {
  if (controller.isDialogOpen.value) return;

  controller.isDialogOpen.value = true;
  Get.defaultDialog(
    titlePadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.all(16),
    title: "FINALIZAR TRECHO",
    content: const Text(
      textAlign: TextAlign.center,
      "Tem certeza que deseja fechar o trecho selecionado? ESSA AÇÃO NÃO PODERÁ SER DESFEITA.",
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () async {
          Get.back(); // Fecha o diálogo atual primeiro
          await Future.delayed(const Duration(milliseconds: 500));
          Map<String, dynamic> retorno = await controller.closeTrip(trip.id!);

          if (retorno['success'] == true) {
            Get.snackbar('Sucesso!', retorno['message'].join('\n'),
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 1),
                snackPosition: SnackPosition.BOTTOM);
          } else {
            Get.snackbar('Falha!', retorno['message'].join('\n'),
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 1),
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
