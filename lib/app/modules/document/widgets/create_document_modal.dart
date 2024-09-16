// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/controllers/document_controller.dart';
import 'package:rodocalc/app/data/models/document_model.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';

class CreateDocumentModal extends GetView<DocumentController> {
  const CreateDocumentModal({super.key, required this.update, this.document});

  final bool update;
  final DocumentModel? document;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
          key: controller.formKeyDocument,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                    'CADASTRO DE DOCUMENTO',
                    style: TextStyle(
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
                Obx(() {
                  if (controller.selectedPdfPath.value.isNotEmpty) {
                    return Column(
                      children: [
                        const Text(
                          'PDF Selecionado:',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          controller.selectedPdfPath.value.split('/').last,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if (result != null) {
                              controller.selectedPdfPath.value =
                                  result.files.single.path!;
                            }
                          },
                          child: const Text(
                            'ENVIAR NOVO PDF',
                            style: TextStyle(
                                fontFamily: 'Inter-Bold', color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return GestureDetector(
                      onTap: () => _showPicker(context),
                      child: Obx(() => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey,
                              child: controller.selectedImagePath.value != ''
                                  ? controller.selectedImagePath.value
                                          .startsWith('http')
                                      ? Image.network(
                                          controller.selectedImagePath.value,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(controller
                                              .selectedImagePath.value),
                                          fit: BoxFit.cover,
                                        )
                                  : const Icon(
                                      Icons.camera_alt,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                            ),
                          )),
                    );
                  }
                }),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.descriptionController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.message,
                      size: 25,
                    ),
                    labelText: 'DESCRIÇÃO',
                  ),
                  onChanged: (text) {
                    controller.descriptionController.value = TextEditingValue(
                      text: text.toUpperCase(),
                      selection: controller.descriptionController.selection,
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a descrição do documento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Obx(
                  () => DropdownButtonFormField<int>(
                    menuMaxHeight: Get.height / 2,
                    value: controller.selectedTipoDocumento.value,
                    onChanged: (value) {
                      controller.selectedTipoDocumento.value = value!;
                    },
                    items: controller.listDocumentsType
                        .map<DropdownMenuItem<int>>((item) {
                      return DropdownMenuItem<int>(
                        value: item.id,
                        child: SizedBox(
                          width: Get.width * .7,
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              Text(
                                item.descricao.toString().toUpperCase() ?? '',
                                overflow: TextOverflow.clip,
                              ),
                              const Divider()
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Inter-Bold',
                          fontSize: 12,
                        ),
                        prefixIcon: const Icon(
                          Icons.description,
                          size: 25,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'TIPO DE DOCUMENTO'),
                  ),
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
                    Obx(() {
                      return controller.isLoadingCRUD.value
                          ? const CircularProgressIndicator()
                          : CustomElevatedButton(
                              onPressed: () async {
                                if (controller
                                        .selectedImagePath.value.isEmpty &&
                                    controller.selectedPdfPath.value.isEmpty) {
                                  Get.snackbar(
                                    'Falha!',
                                    'Por favor, selecione uma imagem ou um PDF.',
                                    backgroundColor: Colors.orange,
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 2),
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }
                                Map<String, dynamic> retorno = update
                                    ? await controller
                                        .updateDocument(document!.id!)
                                    : await controller.insertDocument();

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
                              child: Text(
                                update ? 'ATUALIZAR' : 'CADASTRAR',
                                style: const TextStyle(
                                    fontFamily: 'Inter-Bold',
                                    color: Colors.white),
                              ),
                            );
                    }),
                  ],
                ),
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
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  controller.pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  controller.pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Escolher PDF'),
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  Navigator.pop(context);
                  if (result != null) {
                    controller.selectedPdfPath.value =
                        result.files.single.path!;
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
