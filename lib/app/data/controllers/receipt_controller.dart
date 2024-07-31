import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/models/charge_type_model.dart';
import 'package:rodocalc/app/data/models/expense_model.dart';
import 'package:rodocalc/app/data/models/receipt_model.dart';
import 'package:rodocalc/app/data/models/receipt_photos_model.dart';
import 'package:rodocalc/app/data/repositories/receipt_repository.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class ReceiptController extends GetxController {
  RxBool trailerCheckboxValue = false.obs;

  var selectedImagesPaths = <String>[].obs;

  //CONTROLLER E KEY DESPESA

  final formKeyReceipt = GlobalKey<FormState>();
  final formKeyChargeType = GlobalKey<FormState>();

  final txtDescriptionController = TextEditingController();
  final txtDescriptionCgargeController = TextEditingController();
  final txtOriginController = TextEditingController();
  final txtDestinyController = TextEditingController();
  final txtAmountController = TextEditingController();
  final txtTonController = TextEditingController();
  final txtReceiptDate = TextEditingController();

  RxBool isLoading = true.obs;

  late Receipt selectedReceipt;

  RxList<Expense> listReceipt = RxList<Expense>([]);

  final repository = Get.put(ReceiptRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  var selectedCategory = Rxn<int>();

  var cargoTypes = ['Tipo 1', 'Tipo 2', 'Tipo 3', 'Tipo 4'].obs;
  var selectedCargoType = 'Tipo 1'.obs;

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      listReceipt.value = await repository.getAll();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  // RxList<ExpenseCategory> expenseCategories = <ExpenseCategory>[].obs;
  RxList<ChargeType> chargeTypes = <ChargeType>[].obs;

  Future<void> getMyChargeTypes() async {
    isLoading.value = true;
    try {
      chargeTypes.value = await repository.getMyChargeTypes();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
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

  Future<Map<String, dynamic>> insertReceipt() async {
    if (formKeyReceipt.currentState!.validate()) {
      List<ReceiptPhotos>? photos = [];
      if (selectedImagesPaths.isNotEmpty) {
        for (var element in selectedImagesPaths) {
          photos.add(ReceiptPhotos(arquivo: element));
        }
      }

      mensagem = await repository.insert(Receipt(
        descricao: txtDescriptionController.text,
        origem: txtOriginController.text,
        destino: txtDestinyController.text,
        valor: FormattedInputers.convertToDouble(txtAmountController.text),
        quantidadeTonelada:
            FormattedInputers.convertToDouble(txtTonController.text),
        veiculoId: ServiceStorage.idSelectedVehicle(),
        tipoCargaId: 1,
        receiptDate: txtReceiptDate.text,
        photos: photos,
      ));
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
//        getAll();
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

  Future<Map<String, dynamic>> insertChargeType(String type) async {
    if (formKeyChargeType.currentState!.validate()) {
      mensagem = await repository.insertChargeType(ChargeType(
        descricao: txtDescriptionCgargeController.text,
        status: 1,
      ));
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getMyChargeTypes();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  Future<Map<String, dynamic>> deleteReceipt(int id) async {
    if (id > 0) {
      mensagem = await repository.delete(Receipt(id: id));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
    }
    return retorno;
  }

// void fillInFields() {
//   descriptionController.text = selectedExpense.descricao.toString();
//   expenseCategoryIdController.text =
//       selectedExpense.categoriadespesaId.toString();
//   specificTypeExpenseIdController.text =
//       selectedExpense.tipoespecificodespesaId.toString();
//   valueController.text = selectedExpense.valor.toString();
//   companyController.text = selectedExpense.empresa.toString();
//   cityController.text = selectedExpense.cidade.toString();
//   ufController.text = selectedExpense.uf.toString();
//   dddController.text = selectedExpense.ddd.toString();
//   phoneController.text = selectedExpense.telefone.toString();
//   commetnsController.text = selectedExpense.observacoes.toString();
//   peopleIdController.text = selectedExpense.pessoaId.toString();
//   vehicleIdController.text = selectedExpense.veiculoId.toString();
//   statusController.text = selectedExpense.status.toString();
// }
//
  void clearAllFields() {
    final textControllers = [
      txtDescriptionController,
      txtDescriptionCgargeController,
      txtOriginController,
      txtDestinyController,
      txtAmountController,
      txtTonController,
      txtReceiptDate,
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
    selectedImagesPaths = <String>[].obs;
  }
}
