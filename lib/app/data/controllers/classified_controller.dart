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
  final searchClassifiedController = TextEditingController();

  RxBool isLoading = true.obs;
  RxList<Classifieds> listClassifieds = RxList<Classifieds>([]);
  RxList<Classifieds> filteredClassifieds = RxList<Classifieds>([]);

  final repository = Get.put(ClassifiedsRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  @override
  void onInit() {
    super.onInit();
    filteredClassifieds.assignAll(listClassifieds);
  }

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
      searchClassifiedController.clear();
      listClassifieds.value = await repository.getAll();
      filteredClassifieds.assignAll(listClassifieds);
    } catch (e) {
      listClassifieds.clear();
      filteredClassifieds.clear();
      Exception(e);
    }
    isLoading.value = false;
  }

  void filterClassifieds(String query) {
    if (query.isEmpty) {
      // Se a busca estiver vazia, mostra todos os fretes
      filteredClassifieds.assignAll(listClassifieds);
    } else {
      // Filtra os fretes com base no campo "origem", "destino" ou qualquer outro
      filteredClassifieds.assignAll(
        listClassifieds
            .where((classified) =>
                classified.descricao!
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                classified.observacoes!
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  RxBool isLoadingQuantityLicences = true.obs;
  RxInt postsPermitidos = 0.obs;
  RxInt classificadosCadastrados = 0.obs;

  Future<void> getQuantityLicences() async {
    isLoadingQuantityLicences.value = true;
    try {
      var data = await repository.getQuantityLicences();
      postsPermitidos.value = data['posts_permitidos'];
      classificadosCadastrados.value = data['classificados_cadastrados'];
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
          status: 2,
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
            status: 2,
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
