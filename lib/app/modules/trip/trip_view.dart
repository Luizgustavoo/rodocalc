import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/city_state_controller.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/modules/global/custom_search_field.dart';
import 'package:rodocalc/app/modules/trip/widgets/create_trip_modal.dart';
import 'package:rodocalc/app/modules/trip/widgets/custom_trip_card.dart';
import 'package:rodocalc/app/modules/trip/widgets/view_list_expense_trip_modal.dart';
import 'package:rodocalc/app/utils/formatter.dart';
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
                        // CustomSearchField(
                        //   labelText: 'PESQUISAR TRECHOS',
                        //   controller: controller.searchTripController,
                        //   onChanged: (value) {
                        //     controller.filterTrips(value);
                        //   },
                        // ),

//inicio filtro entre datas

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller.txtInitialDateController,
                                decoration: const InputDecoration(
                                  hintText: 'DATA INICIAL',
                                  prefixIcon: Icon(Icons.date_range),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  fillColor: Colors.transparent,
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: Get.context!,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                    locale: const Locale('pt', 'BR'),
                                  );
                                  if (pickedDate != null) {
                                    controller.txtInitialDateController.text =
                                        FormattedInputers.formatDate2(
                                            pickedDate);
                                    if (controller.txtFinishDateController.text
                                        .isNotEmpty) {
                                      DateTime endDate =
                                          FormattedInputers.parseDate(controller
                                              .txtFinishDateController.text);
                                      if (pickedDate.isAfter(endDate)) {
                                        Get.snackbar('Erro',
                                            'A data inicial não pode ser maior que a data final',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white);
                                        controller.txtInitialDateController
                                            .clear();
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: controller.txtFinishDateController,
                                decoration: const InputDecoration(
                                  hintText: 'DATA FINAL',
                                  prefixIcon: Icon(Icons.date_range),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  fillColor: Colors.transparent,
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: Get.context!,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                  );
                                  if (pickedDate != null) {
                                    if (controller.txtFinishDateController.text
                                        .isNotEmpty) {
                                      DateTime startDate =
                                          FormattedInputers.parseDate(controller
                                              .txtFinishDateController.text);
                                      if (pickedDate.isBefore(startDate)) {
                                        Get.snackbar('Erro',
                                            'A data final não pode ser menor que a data inicial',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white);
                                        controller.txtFinishDateController
                                            .clear();
                                      } else {
                                        controller
                                                .txtFinishDateController.text =
                                            FormattedInputers.formatDate2(
                                                pickedDate);
                                      }
                                    } else {
                                      controller.txtFinishDateController.text =
                                          FormattedInputers.formatDate2(
                                              pickedDate);
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

//final filtro datas

                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 45,
                          child: TextFormField(
                            controller: controller.searchTripController,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade200,
                              labelText: 'Motorista',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  if ((controller.txtInitialDateController.text
                                              .isNotEmpty &&
                                          controller.txtFinishDateController
                                              .text.isNotEmpty) ||
                                      controller.searchTripController.text
                                          .isNotEmpty) {
                                    // controller.getTransactionsWithFilter();
                                  } else {
                                    Get.snackbar('Atenção!',
                                        'Selecione data inicial e final, ou um motorista!',
                                        backgroundColor: Colors.orange,
                                        colorText: Colors.black,
                                        duration: const Duration(seconds: 2),
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                },
                                icon: const Icon(Icons.search),
                              ),
                            ),
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
                                    functionPhoto: () {
                                      controller.selectedImagesPaths.value = [];
                                      _showPicker(context, controller, trip);
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

void _showPicker(BuildContext context, TripController controller, Trip trip) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () async {
                await controller.pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
                _showImagePreviewModal(controller, trip.id!);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Câmera'),
              onTap: () async {
                await controller.pickImage(ImageSource.camera);
                Navigator.of(context).pop();
                _showImagePreviewModal(controller, trip.id!);
              },
            ),
          ],
        ),
      );
    },
  );
}

void _showImagePreviewModal(TripController controller, int tripId) {
  Get.bottomSheet(
    Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pré-visualização",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Obx(() => Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.selectedImagesPaths.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(controller.selectedImagesPaths[index]),
                              width: 100,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              controller.selectedImagesPaths.removeAt(index);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )),
          const SizedBox(height: 10),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Cancelar")),
                controller.selectedImagesPaths.isEmpty
                    ? const SizedBox.shrink()
                    : (controller.isLoadingInsertPhotos.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              Map<String, dynamic> retorno =
                                  await controller.insertTripPhotos(tripId);

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
                              "SALVAR",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

void showDialogDeleteTripPhoto(context, int id, TripController controller) {
  if (controller.isDialogOpen.value) return;

  controller.isDialogOpen.value = true;
  Get.defaultDialog(
    titlePadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.all(16),
    title: "REMOVER FOTO do TRECHO",
    content: const Text(
      textAlign: TextAlign.center,
      "Tem certeza que deseja excluir a foto selecionada?",
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
          Map<String, dynamic> retorno = await controller.deletePhotoTrip(id);

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
