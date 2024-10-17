import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/models/classified_photos_model.dart';
import 'package:rodocalc/app/data/models/classifieds_model.dart';
import 'package:rodocalc/app/data/repositories/classifieds_repository.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class ClassifiedController extends GetxController {
  var selectedImagesPaths = <String>[].obs;
  var selectedImagesPathsApi = <String>[].obs;
  var selectedImagesPathsApiRemove = <String>[].obs;

  final formKeyClassified = GlobalKey<FormState>();
  final valueController = TextEditingController();
  final descriptionController = TextEditingController();
  final modelController = TextEditingController();

  RxBool isLoading = true.obs;
  RxList<Classifieds> listClassifieds = RxList<Classifieds>([]);

  final repository = Get.put(ClassifiedsRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  void pickImage(ImageSource source) async {
    if (source == ImageSource.gallery) {
      final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
      for (var pickedFile in pickedFiles) {
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
          selectedImagesPaths.add(croppedFile.path);
        }
      }
    } else {
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
          selectedImagesPaths.add(croppedFile.path);
        }
      } else {
        Get.snackbar('Erro', 'Nenhuma imagem selecionada');
      }
    }
  }

  void removeImage(String path) {
    selectedImagesPaths.remove(path);
  }

  void removeImageApi(String path) {
    selectedImagesPathsApiRemove.add(path);
    selectedImagesPathsApi.remove(path);
  }

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      listClassifieds.value = await repository.getAll();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  RxBool isLoadingQuantityLicences = true.obs;
  RxInt posts_permitidos = 0.obs;
  RxInt classificados_cadastrados = 0.obs;

  Future<void> getQuantityLicences() async {
    isLoadingQuantityLicences.value = true;
    try {
      var data = await repository.getQuantityLicences();
      posts_permitidos.value = data['posts_permitidos'];
      classificados_cadastrados.value = data['classificados_cadastrados'];
    } catch (e) {
      Exception(e);
    }
    isLoadingQuantityLicences.value = false;
  }

  Future<Map<String, dynamic>> insertClassificado() async {
    if (formKeyClassified.currentState!.validate()) {
      List<ClassifiedsPhotos>? photos = [];
      if (selectedImagesPaths.isNotEmpty) {
        for (var element in selectedImagesPaths) {
          photos.add(ClassifiedsPhotos(arquivo: element));
        }
      }

      mensagem = await repository.insert(
        Classifieds(
          descricao: descriptionController.text,
          valor: FormattedInputers.convertToDouble(valueController.text),
          status: 1,
          fotosclassificados: photos,
          userId: ServiceStorage.getUserId(),
        ),
      );
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getAll();
        clearAllFields();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  Future<Map<String, dynamic>> updateClassificado(int id) async {
    if (formKeyClassified.currentState!.validate()) {
      List<ClassifiedsPhotos>? photos = [];
      if (selectedImagesPaths.isNotEmpty) {
        for (var element in selectedImagesPaths) {
          photos.add(ClassifiedsPhotos(arquivo: element));
        }
      }
      mensagem = await repository.update(
          Classifieds(
            id: id,
            descricao: descriptionController.text,
            valor: FormattedInputers.convertToDouble(valueController.text),
            status: 1,
            fotosclassificados: photos,
            userId: ServiceStorage.getUserId(),
          ),
          selectedImagesPathsApiRemove);
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getAll();
        clearAllFields();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  void clearAllFields() {
    final textControllers = [
      valueController,
      descriptionController,
      modelController,
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
    selectedImagesPaths.clear();
    selectedImagesPathsApi.clear();
    selectedImagesPathsApiRemove.clear();
  }

  void fillInFields(Classifieds selected) {
    valueController.text =
        FormattedInputers.formatValuePTBR(selected.valor!.toString());
    descriptionController.text = selected.descricao!;

    if (selected.fotosclassificados!.isNotEmpty) {
      selectedImagesPathsApiRemove.clear();
      selectedImagesPathsApi.clear();
      for (var photo in selected.fotosclassificados!) {
        selectedImagesPathsApi.add(photo.arquivo!.toString());
      }
    }
  }

  Future<Map<String, dynamic>> deleteClassificado(int id) async {
    if (id > 0) {
      mensagem = await repository.delete(Classifieds(id: id));
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
