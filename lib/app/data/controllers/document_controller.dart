import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/models/document_model.dart';
import 'package:rodocalc/app/data/models/document_type_model.dart';
import 'package:rodocalc/app/data/repositories/document_repository.dart';

class DocumentController extends GetxController {
  RxBool isLoading = true.obs;
  var selectedImagePath = ''.obs;
  var selectedPdfPath = ''.obs;

  final formKeyDocument = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final nameController = TextEditingController();
  RxInt selectedTipoDocumento = 1.obs;

  RxList<DocumentModel> listDocuments = RxList<DocumentModel>([]);
  RxList<DocumentType> listDocumentsType = RxList<DocumentType>([]);

  final repository = Get.put(DocumentRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  List<String> tiposDocumento = ['CNH', 'RG', 'CPF'];

  void clearAllFields() {
    final textControllers = [
      descriptionController,
    ];

    selectedImagePath.value = '';
    selectedPdfPath.value = '';

    for (final controller in textControllers) {
      controller.clear();
    }
  }

  void pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recortar Imagem',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
            title: 'Recortar Imagem',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
        ],
      );
      if (croppedFile != null) {
        selectedImagePath.value = croppedFile.path;
      }
    } else {
      Get.snackbar('Erro', 'Nenhuma imagem selecionada');
    }
  }

  void pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      selectedPdfPath.value = result.files.single.path!;
    } else {
      Get.snackbar('Erro', 'Nenhum arquivo PDF selecionado');
    }
  }

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      listDocuments.value = await repository.getAll();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getAllDocumentType() async {
    isLoading.value = true;
    try {
      listDocumentsType.value = await repository.getAllDocumentType();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>> insertDocument() async {
    if (formKeyDocument.currentState!.validate()) {
      String imagemPdf = '';
      String arquivo = '';

      if (selectedImagePath.value.isNotEmpty) {
        imagemPdf = 'imagem';
        arquivo = selectedImagePath.value;
      } else if (selectedPdfPath.value.isNotEmpty) {
        imagemPdf = 'pdf';
        arquivo = selectedPdfPath.value;
      }

      mensagem = await repository.insert(DocumentModel(
        descricao: descriptionController.text,
        status: "1",
        tipoDocumentoId: selectedTipoDocumento.value.toString(),
        imagemPdf: imagemPdf,
        arquivo: arquivo,
      ));

      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getAll();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  Future<Map<String, dynamic>> updateDocument(int id) async {
    if (formKeyDocument.currentState!.validate()) {
      String imagemPdf = '';
      String arquivo = '';

      if (selectedImagePath.value.isNotEmpty) {
        imagemPdf = 'imagem';
        arquivo = selectedImagePath.value;
      } else if (selectedPdfPath.value.isNotEmpty) {
        imagemPdf = 'pdf';
        arquivo = selectedPdfPath.value;
      }

      mensagem = await repository.insert(DocumentModel(
        id: id,
        descricao: descriptionController.text,
        status: "1",
        tipoDocumentoId: selectedTipoDocumento.value.toString(),
        imagemPdf: imagemPdf,
        arquivo: arquivo,
      ));

      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getAll();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  Future<Map<String, dynamic>> deleteDocument(int id) async {
    if (id > 0) {
      mensagem = await repository.delete(DocumentModel(id: id));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
    } else {
      retorno = {
        'success': false,
        'message': ['Falha ao realizar a operação!']
      };
    }

    return retorno;
  }
}
