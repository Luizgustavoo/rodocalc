import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/models/document_model.dart';

class DocumentController extends GetxController {
  var selectedImagePath = ''.obs;
  var selectedPdfPath = ''.obs;

  final formKeyDocument = GlobalKey<FormState>();
  final descriptionController = TextEditingController();

  var selectedTipoDocumento = ''.obs;
  var selectedVeiculo = ''.obs;

  List<String> tiposDocumento = ['CNH', 'RG', 'CPF'];
  List<String> veiculos = ['Scania P360', 'Volvo FH', 'Mercedes Actros'];

  void setTipoDocumento(String tipo) {
    selectedTipoDocumento.value = tipo;
  }

  void setVeiculo(String veiculo) {
    selectedVeiculo.value = veiculo;
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

  var documents =
      <Document>[].obs; // Inicializa a lista de documentos como uma lista vazia

  @override
  void onInit() {
    super.onInit();
    fetchDocuments(); // Método para buscar documentos, se necessário
  }

  void fetchDocuments() {
    // Simulação de busca de documentos
    documents.value = [
      Document(id: "1", nomeDocumento: "RG")
    ]; // Certifique-se de que a lista não é nula
  }

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
}
