import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/data/models/viagens_model.dart';
import 'package:rodocalc/app/modules/trip/widgets/create_trip_modal.dart';
import 'package:rodocalc/app/modules/trip/widgets/custom_trip_card.dart';
import 'package:rodocalc/app/modules/trip/widgets/view_list_expense_trip_modal.dart';
import 'package:rodocalc/app/utils/service_storage.dart';
import 'package:share_plus/share_plus.dart';

class CustomTravelCard extends StatelessWidget {
  final Viagens travel;
  final VoidCallback functionEdit;
  final VoidCallback functionRemove;
  final VoidCallback functionClose;
  final VoidCallback functionAddTrip;

  final TripController controller;

  const CustomTravelCard({
    super.key,
    required this.travel,
    required this.functionEdit,
    required this.functionRemove,
    required this.functionClose,
    required this.functionAddTrip,
    required this.controller,
  });

  bool todosTrechosFechados(Map<String, dynamic> viagem) {
    final trechos = viagem['trechos'] as List<dynamic>;
    return trechos.every((trecho) => trecho['situacao'] == 'close');
  }

  @override
  Widget build(BuildContext context) {
    bool closedTravel = (travel.situacao?.toUpperCase() ?? "") == "CLOSED";

    String motorista = "S/M";
    if (travel.motorista != null && travel.motorista!.people != null) {
      motorista = travel.motorista!.people!.nome!;
    }

    String situacao = travel.situacao == 'OPENED' ? "ABERTA" : "FECHADA";

    return Card(
      color: closedTravel ? Colors.orange.shade50 : Colors.green.shade50,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    closedTravel
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: functionAddTrip,
                            icon: const Icon(Icons.add, color: Colors.green),
                          ),
                    closedTravel
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: functionEdit,
                            icon: const Icon(Icons.edit,
                                color: Colors.blueAccent),
                          ),
                    closedTravel || ServiceStorage.getUserTypeId() == 4
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: functionClose,
                            icon: const Icon(Icons.lock_open_sharp,
                                color: Color.fromARGB(255, 2, 97, 51)),
                          ),
                    closedTravel && ServiceStorage.getUserTypeId() == 4
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: functionRemove,
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                          ),
                  ],
                ),
                _buildInfoRow(
                    'Viagem', '${travel.numeroViagem} - ${travel.titulo}'),
                _buildInfoRow("Motorista", motorista),
                _buildInfoRow("Situação", situacao),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                travel.trechos == null
                    ? const Text("Nenhum trecho nessa viagem!")
                    : SizedBox(
                        height: 400,
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * .30),
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: travel.trechos == null
                              ? 0
                              : travel.trechos!.length,
                          itemBuilder: (context, index) {
                            Trip trip = travel.trechos![index];
                            return CustomTripCard(
                              travel: travel,
                              trip: trip,
                              functionRemove: () {
                                controller.isDialogOpen.value = false;
                                showDialogTrip(context, trip, controller);
                              },
                              functionPhoto: () async {
                                Get.back();
                                controller.selectedImagesPaths.value = [];
                                controller.txtFileDescriptionController.clear();

                                //_showPicker(context, controller, trip);
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: [
                                    'pdf',
                                    'jpg',
                                    'png',
                                    'jpeg'
                                  ],
                                );
                                if (result != null) {
                                  controller.selectedImagesPaths
                                      .add(result.files.single.path!);
                                }

                                _showImagePreviewModalTrip(
                                    controller, trip.id!);
                              },
                              functionExpense: () {
                                Get.back();
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
                                    trip.dataHoraChegada.toString().isEmpty ||
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
                                  showDialogCloseTrip(
                                      context, trip, controller);
                                }
                              },
                              functionEdit: () {
                                Get.back();
                                controller.getMyChargeTypes();
                                controller.fillInFields(trip);
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => CreateTripModal(
                                    travel: travel,
                                    isUpdate: true,
                                    trip: trip,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {Color cor = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: cor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: cor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

void showDialogTrip(context, Trip trip, TripController controller) {
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

void showDialogCloseTrip(context, Trip trip, TripController controller) {
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

void _showPickerTrip(
    BuildContext context, TripController controller, Trip trip) {
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
                _showImagePreviewModalTrip(controller, trip.id!);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Câmera'),
              onTap: () async {
                await controller.pickImage(ImageSource.camera);
                Navigator.of(context).pop();
                _showImagePreviewModalTrip(controller, trip.id!);
              },
            ),
          ],
        ),
      );
    },
  );
}

void _showImagePreviewModalTrip(TripController controller, int tripId) {
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

void showPdfDialogTrip(String pdfPath) {
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
