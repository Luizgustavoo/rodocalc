import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/models/transaction_photos_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/modules/trip/widgets/create_expense_trip_modal.dart';
import 'package:rodocalc/app/utils/formatter.dart';

import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class ViewListExpenseTripModal extends GetView<TripController> {
  const ViewListExpenseTripModal({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'LANCAMENTOS DO TRECHO',
                    style: TextStyle(
                        fontFamily: 'Inter-Bold',
                        fontSize: 17,
                        color: Color(0xFFFF6B00)),
                  ),
                  trip.situacao!.toUpperCase() == "CLOSE"
                      ? const SizedBox.shrink()
                      : IconButton(
                          onPressed: () {
                            Get.back();
                            controller.clearAllFieldsExpense();
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => CreateExpenseTripModal(
                                isUpdate: false,
                                trip: trip,
                              ),
                            );
                          },
                          icon: const Icon(Icons.add))
                ],
              ),
            ),
            const Divider(
              endIndent: 20,
              indent: 20,
              height: 5,
              thickness: 2,
              color: Colors.black,
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: Get.height / 2,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: trip.transactions!.length,
                itemBuilder: (ctx, index) {
                  final Transacoes transacao = trip.transactions![index];
                  return Card(
                    elevation: 1,
                    color: transacao.tipoTransacao == 'saida'
                        ? Colors.red.shade100
                        : Colors.green.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (trip.situacao!.toUpperCase() != "CLOSE")
                                IconButton(
                                  onPressed: () {
                                    showViewDialog(
                                        context, transacao, controller);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              if (trip.situacao!.toUpperCase() != "CLOSE")
                                IconButton(
                                  onPressed: () {
                                    Get.back();
                                    controller.clearAllFieldsExpense();
                                    controller
                                        .fillInFieldsExpenseTrip(transacao);
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) =>
                                          CreateExpenseTripModal(
                                        isUpdate: true,
                                        trip: trip,
                                        transaction: transacao,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              trip.situacao!.toUpperCase() == "CLOSE"
                                  ? const SizedBox.shrink()
                                  : IconButton(
                                      onPressed: () {
                                        controller
                                            .selectedImagesPathsTransactions
                                            .value = [];
                                        _showPickerTransactions(
                                            context, controller, transacao);
                                      },
                                      icon: const Icon(Icons.camera_alt),
                                    ),
                            ],
                          ),
                        ),
                        ListTile(
                          leading: (transacao.photos != null &&
                                  transacao.photos!.isNotEmpty)
                              ? IconButton(
                                  icon: const Icon(Icons.image,
                                      color: Colors.blue),
                                  onPressed: () {
                                    _showImageModal(context, transacao.photos!);
                                  },
                                )
                              : null,
                          title: Text(
                              "${transacao.tipoTransacao!.toUpperCase()}: ${transacao.descricao}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "DESCRIÇÃO: ${transacao.descricao.toString()}"),
                              Text(
                                  "DATA: ${FormattedInputers.formatApiDateHour(transacao.data!)}"),
                              Text(
                                  "VALOR: R\$${FormattedInputers.formatValuePTBR((transacao.valor!).toString())}"),
                              Text("KM: ${transacao.km} Km"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

void _showImageModal(BuildContext context, List<TransactionsPhotos> photos) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(16), // Espaçamento ao redor do modal
        child: SizedBox(
          width: double.infinity, // Largura total disponível
          height: MediaQuery.of(context).size.height * 0.5, // Metade da tela
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // Bordas arredondadas
              color: Colors.white, // Cor de fundo do modal
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Exibe as imagens com as ações flutuantes
                  Expanded(
                    child: ListView.builder(
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              children: [
                                // Exibe a imagem
                                Image.network(
                                  "$urlImagem/storage/fotos/trechopercorrido/transactions/${photos[index].arquivo}",
                                  width: double.infinity,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                                // Ícones de ação sobre a imagem
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Row(
                                    children: [
                                      // Botão de compartilhar
                                      GestureDetector(
                                        onTap: () async {
                                          try {
                                            // URL da imagem
                                            final imageUrl =
                                                '$urlImagem/storage/fotos/trechopercorrido/transactions/${photos[index].arquivo}';

                                            // Fazer o download da imagem
                                            final response = await http
                                                .get(Uri.parse(imageUrl));
                                            if (response.statusCode == 200) {
                                              // Diretório temporário para salvar a imagem
                                              final tempDir =
                                                  await getTemporaryDirectory();
                                              final tempPath =
                                                  '${tempDir.path}/${photos[index].arquivo?.split('/').last}';

                                              // Salvar a imagem como arquivo
                                              final file = File(tempPath);
                                              await file.writeAsBytes(
                                                  response.bodyBytes);

                                              // Compartilhar o arquivo
                                              await Share.shareFiles(
                                                  [file.path],
                                                  text: 'Confira esta imagem!');
                                            } else {
                                              throw Exception(
                                                  'Falha ao baixar a imagem. Código: ${response.statusCode}');
                                            }
                                          } catch (e) {
                                            // Tratar erro
                                            Get.snackbar('Erro',
                                                'Falha ao compartilhar a imagem: $e',
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.share,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      // Botão de excluir
                                      GestureDetector(
                                        onTap: () {
                                          showDialogDeleteExpenseTripPhoto(
                                              context, photos[index].id!);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

void _showPickerTransactions(
    BuildContext context, TripController controller, Transacoes transaction) {
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
                await controller.pickImageTransactions(ImageSource.gallery);
                Navigator.of(context).pop();
                _showImagePreviewModalTransactions(controller, transaction.id!);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Câmera'),
              onTap: () async {
                await controller.pickImageTransactions(ImageSource.camera);
                Navigator.of(context).pop();
                _showImagePreviewModalTransactions(controller, transaction.id!);
              },
            ),
          ],
        ),
      );
    },
  );
}

void _showImagePreviewModalTransactions(
    TripController controller, int transactionId) {
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
                  itemCount: controller.selectedImagesPathsTransactions.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(controller
                                  .selectedImagesPathsTransactions[index]),
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
                              controller.selectedImagesPathsTransactions
                                  .removeAt(index);
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
                controller.selectedImagesPathsTransactions.isEmpty
                    ? const SizedBox.shrink()
                    : (controller.isLoadingInsertPhotos.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              Map<String, dynamic> retorno = await controller
                                  .insertTripPhotosTransactions(transactionId);

                              if (retorno['success'] == true) {
                                Get.back();
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

void showViewDialog(context, Transacoes transacao, TripController controller) {
  Get.defaultDialog(
    titlePadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.all(16),
    title: "Confirmação",
    content: const Text(
      textAlign: TextAlign.center,
      "Tem certeza que deseja excluir a transação selecionada?",
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () async {
          Map<String, dynamic> retorno =
              await controller.deleteTransactionTrip(transacao.id!);
          Get.back();
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

void showDialogDeleteExpenseTripPhoto(context, int id) {
  TripController controller = Get.put(TripController());

  if (controller.isDialogOpen.value) return;

  controller.isDialogOpen.value = true;

  // Fecha todos os modais abertos antes de abrir o diálogo
  // Fecha apenas os dois modais anteriores

  Future.delayed(const Duration(milliseconds: 300), () {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "REMOVER FOTO DA TRANSAÇÃO",
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
            Get.back(); // Fecha o diálogo

            Map<String, dynamic> retorno =
                await controller.deleteExpensePhotoTrip(id);

            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }

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
  });
}
