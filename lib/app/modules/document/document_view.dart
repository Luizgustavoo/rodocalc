import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/document_controller.dart';
import 'package:rodocalc/app/data/models/document_model.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/modules/document/widgets/create_document_modal.dart';
import 'package:rodocalc/app/modules/document/widgets/custom_document_card.dart';

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
                SizedBox(
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
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: const Icon(Icons.search_rounded),
                              labelText: 'PESQUISAR DOCUMENTO',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: controller.listDocuments.length,
                              itemBuilder: (context, index) {
                                DocumentModel document =
                                    controller.listDocuments[index];
                                return Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.endToStart,
                                    confirmDismiss:
                                        (DismissDirection direction) async {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        showDialogDelete(
                                            context, document, controller);
                                      }
                                      return false;
                                    },
                                    background: Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red,
                                      ),
                                      child: const Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  Icons.check_rounded,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  'EXCLUIR',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                    child: CustomDocumentCard(
                                      document: document,
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
                                            builder: (context) => AlertDialog(
                                              content: Image.network(
                                                '$urlImagem/storage/fotos/documentos/${document.arquivo}',
                                                fit: BoxFit.contain,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: const Text(
                                                    'FECHAR',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Inter-Bold'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else if (document.imagemPdf ==
                                            'PDF') {
                                          // Exibir PDF
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              content: SizedBox(
                                                height: 500,
                                                child: PdfViewPage(
                                                  pdfUrl:
                                                      '$urlImagem/storage/fotos/documentos/${document.arquivo}',
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: const Text(
                                                    'FECHAR',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Inter-Bold'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ));
                              },
                            ),
                          )
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
        "Tem certeza que deseja excluir o veículo ${document.descricao}?",
        style: const TextStyle(
          fontFamily: 'Inter-Regular',
          fontSize: 18,
        ),
      ),
      actions: [
        ElevatedButton(
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
