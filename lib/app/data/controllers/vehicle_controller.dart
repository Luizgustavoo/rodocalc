import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class VehiclesController extends GetxController {
  var selectedImagePath = ''.obs;
  RxBool trailerCheckboxValue = false.obs;

  final vehicleFormKey = GlobalKey<FormState>();
  final plateController = TextEditingController();
  final brandController = TextEditingController();
  final yearController = TextEditingController();
  final modelController = TextEditingController();
  final fipeController = TextEditingController();

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
}
