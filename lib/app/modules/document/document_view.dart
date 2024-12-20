import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/document_controller.dart';
import 'package:rodocalc/app/data/models/document_model.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/modules/document/widgets/create_document_modal.dart';
import 'package:rodocalc/app/modules/document/widgets/custom_document_card.dart';
import 'package:rodocalc/app/modules/global/custom_search_field.dart';

import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class DocumentView extends GetView<DocumentController> {
  const DocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'DOCUMENTOS'),
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
                    controller.searchDocumentController.clear();
                    controller.listDocuments.clear();
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 5),
                            CustomSearchField(
                              labelText: 'PESQUISAR DOCUMENTO',
                              controller: controller.searchDocumentController,
                              onChanged: (value) {
                                controller.filterDocuments(value);
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
                                  controller.listDocuments.isNotEmpty) {
                                return Expanded(
                                    child: ListView.builder(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              .25),
                                  shrinkWrap: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount:
                                      controller.filteredDocuments.length,
                                  itemBuilder: (context, index) {
                                    DocumentModel document =
                                        controller.filteredDocuments[index];
                                    return CustomDocumentCard(
                                      document: document,
                                      removeDocument: () {
                                        showDialogDelete(
                                            context, document, controller);
                                      },
                                      editDocument: () {
                                        controller.selectedDocument = document;
                                        controller.getAllDocumentType();
                                        controller.fillInFields();
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) =>
                                              CreateDocumentModal(
                                            update: true,
                                            document: document,
                                          ),
                                        );
                                      },
                                      onTap: () {
                                        if (document.imagemPdf == 'IMAGEM') {
                                          // Exibir imagem
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    0), // Torna o Dialog quadrado
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15), // Borda arredondada do conteúdo
                                                ),
                                                padding:
                                                    const EdgeInsets.all(16),
                                                // Espaçamento interno
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.network(
                                                      '$urlImagem/storage/fotos/documentos/${document.arquivo}',
                                                      fit: BoxFit.contain,
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () async {
                                                            try {
                                                              // URL da imagem
                                                              final imageUrl =
                                                                  '$urlImagem/storage/fotos/documentos/${document.arquivo}';

                                                              // Fazer o download da imagem
                                                              final response =
                                                                  await http.get(
                                                                      Uri.parse(
                                                                          imageUrl));
                                                              if (response
                                                                      .statusCode ==
                                                                  200) {
                                                                // Diretório temporário para salvar a imagem
                                                                final tempDir =
                                                                    await getTemporaryDirectory();
                                                                final tempPath =
                                                                    '${tempDir.path}/${document.arquivo?.split('/').last}';

                                                                // Salvar a imagem como arquivo
                                                                final file = File(
                                                                    tempPath);
                                                                await file
                                                                    .writeAsBytes(
                                                                        response
                                                                            .bodyBytes);

                                                                // Compartilhar o arquivo
                                                                await Share
                                                                    .shareFiles([
                                                                  file.path
                                                                ], text: 'Confira esta imagem!');
                                                              } else {
                                                                throw Exception(
                                                                    'Falha ao baixar a imagem. Código: ${response.statusCode}');
                                                              }
                                                            } catch (e) {
                                                              // Tratar erro
                                                              Get.snackbar(
                                                                  'Erro',
                                                                  'Falha ao compartilhar a imagem: $e',
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  colorText:
                                                                      Colors
                                                                          .white);
                                                            }
                                                          },
                                                          child: const Text(
                                                            'COMPARTILHAR',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Inter-Bold',
                                                            ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Get.back(),
                                                          child: const Text(
                                                            'FECHAR',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Inter-Bold',
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        } else if (document.imagemPdf ==
                                            'PDF') {
                                          // Exibir PDF
                                          showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0), // Torna o Dialog quadrado
                                                  ),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                15), // Borda arredondada do conteúdo
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      // Espaçamento interno
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          SizedBox(
                                                            height: 500,
                                                            child: PdfViewPage(
                                                              pdfUrl:
                                                                  '$urlImagem/storage/fotos/documentos/${document.arquivo}',
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  try {
                                                                    // URL da imagem
                                                                    final imageUrl =
                                                                        '$urlImagem/storage/fotos/documentos/${document.arquivo}';

                                                                    // Fazer o download da imagem
                                                                    final response =
                                                                        await http
                                                                            .get(Uri.parse(imageUrl));
                                                                    if (response
                                                                            .statusCode ==
                                                                        200) {
                                                                      // Diretório temporário para salvar a imagem
                                                                      final tempDir =
                                                                          await getTemporaryDirectory();
                                                                      final tempPath =
                                                                          '${tempDir.path}/${document.arquivo?.split('/').last}';

                                                                      // Salvar a imagem como arquivo
                                                                      final file =
                                                                          File(
                                                                              tempPath);
                                                                      await file
                                                                          .writeAsBytes(
                                                                              response.bodyBytes);

                                                                      // Compartilhar o arquivo
                                                                      await Share
                                                                          .shareFiles([
                                                                        file.path
                                                                      ], text: 'Confira esta imagem!');
                                                                    } else {
                                                                      throw Exception(
                                                                          'Falha ao baixar a imagem. Código: ${response.statusCode}');
                                                                    }
                                                                  } catch (e) {
                                                                    // Tratar erro
                                                                    Get.snackbar(
                                                                        'Erro',
                                                                        'Falha ao compartilhar a imagem: $e',
                                                                        backgroundColor:
                                                                            Colors
                                                                                .red,
                                                                        colorText:
                                                                            Colors.white);
                                                                  }
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'COMPARTILHAR',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Inter-Bold',
                                                                  ),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Get.back(),
                                                                child:
                                                                    const Text(
                                                                  'FECHAR',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Inter-Bold',
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ))));
                                        }
                                      },
                                    );
                                  },
                                ));
                              } else {
                                return const Center(
                                  child: Text('NENHUM DOCUMENTO CADASTRADO!'),
                                );
                              }
                            })
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFFF6B00),
          onPressed: () {
            controller.clearAllFields();
            controller.getAllDocumentType();
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => const CreateDocumentModal(
                update: false,
              ),
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

  void showDialogDelete(
      context, DocumentModel document, DocumentController controller) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "Confirmação",
      content: Text(
        textAlign: TextAlign.center,
        "Tem certeza que deseja excluir o registro ${document.descricao}?",
        style: const TextStyle(
          fontFamily: 'Inter-Regular',
          fontSize: 18,
        ),
      ),
      actions: [
        Obx(() {
          return controller.isLoadingCRUD.value
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> retorno =
                        await controller.deleteDocument(document.id!);

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
                    style:
                        TextStyle(fontFamily: 'Poppinss', color: Colors.white),
                  ),
                );
        }),
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
}

class PdfViewPage extends StatelessWidget {
  final String pdfUrl;

  const PdfViewPage({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(materialModel.descricao!),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const PDF().cachedFromUrl(
        pdfUrl,
        placeholder: (double progress) => Center(
          child: Text('$progress %'),
        ),
        errorWidget: (dynamic error) => Center(
          child: Text(error.toString()),
        ),
      ),
    );
  }
}
