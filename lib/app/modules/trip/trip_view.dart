import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/city_state_controller.dart';
import 'package:rodocalc/app/data/controllers/home_controller.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/data/models/viagens_model.dart';
import 'package:rodocalc/app/modules/trip/widgets/create_travel_modal.dart';
import 'package:rodocalc/app/modules/trip/widgets/create_trip_modal.dart';
import 'package:rodocalc/app/modules/trip/widgets/custom_travel_card.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';
import 'package:share_plus/share_plus.dart';

class TripView extends GetView<TripController> {
  const TripView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('VIAGENS',
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
              onPressed: () {
                Get.find<HomeController>().verificarExibicaoImagem();
                Get.back();
              },
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
                  controller.listViagens.clear();
                  controller.getAllViagens();
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

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        controller.txtInitialDateController,
                                    decoration: const InputDecoration(
                                      hintText: 'Data inicial',
                                      prefixIcon: Icon(Icons.calendar_today,
                                          size: 18, color: Colors.grey),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blueGrey),
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 10),
                                    ),
                                    style: const TextStyle(fontSize: 14),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: Get.context!,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                        locale: const Locale('pt', 'BR'),
                                      );
                                      if (pickedDate != null) {
                                        controller
                                                .txtInitialDateController.text =
                                            FormattedInputers.formatDate2(
                                                pickedDate);
                                        if (controller.txtFinishDateController
                                            .text.isNotEmpty) {
                                          DateTime endDate =
                                              FormattedInputers.parseDate(
                                                  controller
                                                      .txtFinishDateController
                                                      .text);
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
                                    controller:
                                        controller.txtFinishDateController,
                                    decoration: const InputDecoration(
                                      hintText: 'Data final',
                                      prefixIcon: Icon(Icons.calendar_today,
                                          size: 18, color: Colors.grey),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blueGrey),
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 10),
                                    ),
                                    style: const TextStyle(fontSize: 14),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: Get.context!,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                        locale: const Locale('pt', 'BR'),
                                      );
                                      if (pickedDate != null) {
                                        if (controller.txtInitialDateController
                                            .text.isNotEmpty) {
                                          DateTime startDate =
                                              FormattedInputers.parseDate(
                                                  controller
                                                      .txtInitialDateController
                                                      .text);
                                          if (pickedDate.isBefore(startDate)) {
                                            Get.snackbar('Erro',
                                                'A data final não pode ser menor que a data inicial',
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white);
                                            controller.txtFinishDateController
                                                .clear();
                                            return;
                                          }
                                        }
                                        controller
                                                .txtFinishDateController.text =
                                            FormattedInputers.formatDate2(
                                                pickedDate);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () {
                                  if ((controller.txtInitialDateController.text
                                              .isNotEmpty &&
                                          controller.txtFinishDateController
                                              .text.isNotEmpty) ||
                                      controller.searchTripController.text
                                          .isNotEmpty) {
                                    controller.getTripsWithFilter();
                                    controller.clearSearchFilter();
                                  } else {
                                    controller.getAll();
                                    Get.snackbar(
                                        'Atenção!', 'Nenhum filtro aplicado!',
                                        backgroundColor: Colors.orange,
                                        colorText: Colors.black,
                                        duration: const Duration(seconds: 2),
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                },
                                icon: const Icon(Icons.search,
                                    size: 18,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                label: const Text(
                                  'Procurar',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 19, 19, 19)),
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  foregroundColor:
                                      const Color.fromARGB(255, 74, 74, 74),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Obx(() => controller.searchFilter.value.isNotEmpty
                            ? Text(controller.searchFilter.value)
                            : const SizedBox.shrink()),
                        const SizedBox(height: 16),
                        Obx(() {
                          if (controller.isLoadingViagens.value) {
                            return const Column(
                              children: [
                                Text('Carregando...'),
                                SizedBox(height: 20.0),
                                CircularProgressIndicator(),
                              ],
                            );
                          } else if (!controller.isLoadingViagens.value &&
                              controller.listViagens.isNotEmpty) {
                            return Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height *
                                        .30),
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: controller.filteredViagens.length,
                                itemBuilder: (context, index) {
                                  Viagens travel =
                                      controller.filteredViagens[index];
                                  return CustomTravelCard(
                                    controller: controller,
                                    travel: travel,
                                    functionAddTrip: () {
                                      final cityController =
                                          Get.put(CityStateController());
                                      cityController.getCities();

                                      controller.clearAllFields();
                                      controller.getMyChargeTypes();
                                      controller.tripNumberController.text =
                                          travel.numeroViagem.toString();
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => CreateTripModal(
                                          isUpdate: false,
                                          travel: travel,
                                        ),
                                      );
                                    },
                                    functionRemove: () {
                                      controller.isDialogOpen.value = false;
                                      showDialogRemoveTravel(
                                          context, travel, controller);
                                    },
                                    functionClose: () {
                                      if (travel.situacao == 'OPENED') {
                                        controller.isDialogOpen.value = false;
                                        showDialogClose(
                                            context, travel, controller);
                                      }
                                    },
                                    functionEdit: () {
                                      controller.fillInFieldsViagens(travel);
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => CreateTravelModal(
                                          isUpdate: true,
                                          travel: travel,
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: FloatingActionButton(
                heroTag: 'create_pdf',
                mini: true,
                backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                onPressed: controller.isLoadingPDF.value
                    ? () {}
                    : () async {
                        if (ServiceStorage.idSelectedVehicle() <= 0) {
                          Get.snackbar(
                            'Atenção',
                            'Selecione um veículo antes!',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          String? pdfPath = await controller.generatePDF();

                          if (pdfPath != null) {
                            showPdfDialog(pdfPath);
                          } else {
                            Get.snackbar('Erro', 'Falha ao gerar PDF!',
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                          }
                        }
                      },
                child: controller.isLoadingPDF.value
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3.0,
                        ),
                      )
                    : const Icon(
                        Icons.picture_as_pdf_rounded,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: FloatingActionButton(
              heroTag: 'create_trip',
              backgroundColor: const Color(0xFFFF6B00),
              onPressed: () {
                if (ServiceStorage.idSelectedVehicle() <= 0) {
                  Get.snackbar('Atenção', 'Selecione um veículo antes!',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                      snackPosition: SnackPosition.BOTTOM);
                } else {
                  controller.clearAllFields();
                  controller.clearAllFieldsExpense();
                  controller.clearAllFieldsViagens();
                  showModalBottomSheet(
                    isScrollControlled: false,
                    context: context,
                    builder: (context) => CreateTravelModal(isUpdate: false),
                  );
                }
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showDialogRemoveTravel(
    context, Viagens travel, TripController controller) {
  if (controller.isDialogOpen.value) return;

  controller.isDialogOpen.value = true;
  Get.defaultDialog(
    titlePadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.all(16),
    title: "REMOVER VIAGEM",
    content: const Text(
      textAlign: TextAlign.center,
      "Tem certeza que deseja excluir a viagem selecionada?",
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
          Map<String, dynamic> retorno =
              await controller.deleteViagens(travel.id!);

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

void showDialogClose(context, Viagens travel, TripController controller) {
  if (controller.isDialogOpen.value) return;

  controller.isDialogOpen.value = true;
  Get.defaultDialog(
    titlePadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.all(16),
    title: "FINALIZAR VIAGEM",
    content: const Text(
      textAlign: TextAlign.center,
      "Tem certeza que deseja fechar a viagem selecionada? ESSA AÇÃO NÃO PODERÁ SER DESFEITA.",
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
          Map<String, dynamic> retorno =
              await controller.closeViagens(travel.id!);

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        // Adicionado para permitir o scroll
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pré-visualização",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Obx(() {
              if (controller.selectedImagesPaths.isEmpty) {
                return const Text("Nenhuma imagem selecionada.");
              }

              String filePath = controller.selectedImagesPaths[0];
              String fileExtension = filePath.split('.').last.toLowerCase();
              bool isImage = ['jpg', 'jpeg', 'png'].contains(fileExtension);

              return Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: isImage
                            ? Image.file(
                                File(filePath),
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 200,
                                height: 200,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.insert_drive_file,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () {
                            controller.selectedImagesPaths.clear();
                            controller.txtFileDescriptionController.clear();
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
                  ),
                  const SizedBox(height: 10),
                  // Campo de descrição
                  TextFormField(
                    controller: controller.txtFileDescriptionController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.monetization_on),
                      labelText: 'DESCRIÇÃO',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma descrição';
                      }
                      return null;
                    },
                  ),
                ],
              );
            }),
            const SizedBox(height: 10),
            Obx(() {
              return Row(
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
                                if (controller.txtFileDescriptionController.text
                                    .isNotEmpty) {
                                  Map<String, dynamic> retorno =
                                      await controller.insertTripPhotos(tripId);

                                  if (retorno['success'] == true) {
                                    Get.back();
                                    Get.snackbar('Sucesso!',
                                        retorno['message'].join('\n'),
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
                                } else {
                                  Get.snackbar('Atenção!',
                                      "Adicione uma descrição para o arquivo",
                                      backgroundColor: Colors.orange,
                                      colorText: Colors.black,
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
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
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
    title: "REMOVER ANEXO DO TRECHO",
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

void showPdfDialog(String pdfPath) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0)), // Bordas arredondadas
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AppBar personalizada dentro do Dialog
          Container(
            decoration: const BoxDecoration(
              color: Colors.deepOrange, // Cor da barra superior
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Relatório de trechos',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),

          // Corpo do PDF
          SizedBox(
            height: 400,
            width: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  12), // Bordas arredondadas na visualização do PDF
              child: PDFView(filePath: pdfPath),
            ),
          ),

          const SizedBox(height: 10),

          IconButton(
            icon: const Icon(Icons.share, color: Colors.blue, size: 30),
            onPressed: () async {
              await Share.shareXFiles([XFile(pdfPath)]);
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    ),
    barrierDismissible: false, // Impede fechamento ao tocar fora
  );
}
