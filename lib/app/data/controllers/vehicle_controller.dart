import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';
import 'package:rodocalc/app/data/repositories/vehicle_repository.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class VehiclesController extends GetxController {
  var selectedImagePath = ''.obs;
  RxBool trailerCheckboxValue = false.obs;

  late Vehicle selectedVehicle;

  final formKeyVehicle = GlobalKey<FormState>();
  final plateController = TextEditingController();
  final brandController = TextEditingController();
  final yearController = TextEditingController();
  final modelController = TextEditingController();
  final fipeController = TextEditingController();
  final trailerController = TextEditingController();

  RxBool isLoading = true.obs;

  RxList<Vehicle> listCompany = RxList<Vehicle>([]);

  final repository = Get.find<VehicleRepository>();

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

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  var photoUrlPath = ''.obs;

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      listCompany.value = await repository.getAll();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>> insertVehicle() async {
    if (formKeyVehicle.currentState!.validate()) {
      mensagem = await repository.insert(
          Vehicle(
            pessoaId: ServiceStorage.getUserId(),
            marca: brandController.text,
            ano: yearController.text,
            modelo: modelController.text,
            placa: plateController.text,
            fipe: fipeController.text,
            reboque: trailerController.text,
            status: 1,
          ),
          File(photoUrlPath.value));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
    }
    return retorno;
  }

  void fillInFields() {
    plateController.text = selectedVehicle.placa.toString();
    brandController.text = selectedVehicle.marca.toString();
    yearController.text = selectedVehicle.ano.toString();
    modelController.text = selectedVehicle.modelo.toString();
    fipeController.text = selectedVehicle.fipe.toString();
    trailerController.text = selectedVehicle.reboque.toString();
  }

  void clearAllFields() {
    final textControllers = [
      plateController,
      brandController,
      yearController,
      modelController,
      fipeController,
      trailerController
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
  }

  Future<Map<String, dynamic>> updateVehicle(int id) async {
    if (formKeyVehicle.currentState!.validate()) {
      mensagem = await repository.update(
          Vehicle(
            id: id,
            pessoaId: ServiceStorage.getUserId(),
            marca: brandController.text,
            ano: yearController.text,
            modelo: modelController.text,
            placa: plateController.text,
            fipe: fipeController.text,
            reboque: trailerController.text,
            status: 1,
          ),
          File(photoUrlPath.value));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
    }
    return retorno;
  }

  Future<Map<String, dynamic>> deleteVehicle(int id) async {
    if (formKeyVehicle.currentState!.validate()) {
      mensagem = await repository.delete(Vehicle(id: id));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
    }
    return retorno;
  }
}
