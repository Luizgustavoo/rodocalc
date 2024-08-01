import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rodocalc/app/data/models/charge_type_model.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/specific_type_expense_model.dart';
import 'package:rodocalc/app/data/models/transaction_photos_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/repositories/transaction_repository.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class TransactionController extends GetxController {
  RxBool trailerCheckboxValue = false.obs;

  var selectedImagesPaths = <Map<String, dynamic>>[{}].obs;

  //CONTROLLER E KEY DESPESA

  final formKeyTransaction = GlobalKey<FormState>();
  final formKeyExpenseCategory = GlobalKey<FormState>();
  final txtDescriptionController = TextEditingController();
  final txtDescriptionExpenseCategoryController = TextEditingController();
  final txtCityController = TextEditingController();
  final txtCompanyController = TextEditingController();
  final txtDDDController = TextEditingController();
  final txtPhoneController = TextEditingController();
  final txtValueController = TextEditingController();
  final txtDateController = TextEditingController();

//RECEBIMENTO
  final txtOriginController = TextEditingController();
  final txtDestinyController = TextEditingController();
  final txtTonController = TextEditingController();

  RxBool isLoading = true.obs;

  late Transacoes selectedTransaction;

  RxList<Transacoes> listTransactions = RxList<Transacoes>([]);

  final repository = Get.put(TransactionRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  var ufs = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ].obs;
  var selectedUf = 'AC'.obs;

  var selectedSpecificType = Rxn<int>();
  var selectedCategory = Rxn<int>();
  var selectedCargoType = Rxn<int>();

  var balance = 10000.0.obs;
  var transactions = <Transacoes>[].obs;
  var filteredTransactions = <Transacoes>[].obs;
  var searchQuery = ''.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   getAll();
  // }

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      listTransactions.value = await repository.getAll();
      filteredTransactions.value = listTransactions;
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  RxList<ExpenseCategory> expenseCategories = <ExpenseCategory>[].obs;
  RxList<SpecificTypeExpense> specificTypes = <SpecificTypeExpense>[].obs;
  RxList<ChargeType> listChargeTypes = <ChargeType>[].obs;

  Future<void> getMyChargeTypes() async {
    isLoading.value = true;
    try {
      listChargeTypes.value = await repository.getMyChargeTypes();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getMyCategories() async {
    isLoading.value = true;
    try {
      expenseCategories.value = await repository.getMyCategories();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getMySpecifics() async {
    isLoading.value = true;
    try {
      specificTypes.value = await repository.getMySpecifics();
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
          Map<String, dynamic> foto = {
            "arquivo": croppedFile.path,
            "tipo": "insert"
          };
          selectedImagesPaths.add(foto);
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
          Map<String, dynamic> foto = {
            "arquivo": croppedFile.path,
            "tipo": "insert"
          };
          selectedImagesPaths.add(foto);
        }
      } else {
        Get.snackbar('Erro', 'Nenhuma imagem selecionada');
      }
    }
  }

  void removeImage(String path) {
    selectedImagesPaths.remove(path);
  }

  Future<Map<String, dynamic>> insertTransaction(String typeTransaction) async {
    if (formKeyTransaction.currentState!.validate()) {
      List<TransactionsPhotos>? photos = [];
      if (selectedImagesPaths.isNotEmpty) {
        for (var element in selectedImagesPaths) {
          photos.add(TransactionsPhotos(arquivo: element['arquivo']));
        }
      }

      mensagem = await repository.insert(Transacoes(
        descricao: txtDescriptionController.text,
        data: txtDateController.text,
        categoriaDespesaId: 1,
        tipoEspecificoDespesaId: 1,
        valor: FormattedInputers.convertToDouble(txtValueController.text),
        empresa: txtCompanyController.text,
        cidade: txtCityController.text,
        uf: selectedUf.value,
        ddd: txtDDDController.text,
        telefone: txtPhoneController.text,
        status: 1,
        pessoaId: ServiceStorage.getUserId(),
        veiculoId: ServiceStorage.idSelectedVehicle(),
        origem: txtOriginController.text,
        destino: txtDestinyController.text,
        quantidadeTonelada:
            FormattedInputers.convertToDouble(txtTonController.text),
        tipoCargaId: 1,
        tipoTransacao: typeTransaction,
        photos: photos,
      ));
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

  Future<Map<String, dynamic>> updateTransaction(String typeTransaction) async {
    if (formKeyTransaction.currentState!.validate()) {
      List<TransactionsPhotos>? photos = [];
      if (selectedImagesPaths.isNotEmpty) {
        for (var element in selectedImagesPaths) {
          if (element[1] == 'insert') {
            photos.add(TransactionsPhotos(arquivo: element['arquivo']));
          }
        }
      }

      /* mensagem = await repository.insert(Transacoes(
        descricao: txtDescriptionController.text,
        data: txtDateController.text,
        categoriaDespesaId: 1,
        tipoEspecificoDespesaId: 1,
        valor: FormattedInputers.convertToDouble(txtValueController.text),
        empresa: txtCompanyController.text,
        cidade: txtCityController.text,
        uf: selectedUf.value,
        ddd: txtDDDController.text,
        telefone: txtPhoneController.text,
        status: 1,
        pessoaId: ServiceStorage.getUserId(),
        veiculoId: ServiceStorage.idSelectedVehicle(),
        origem: txtOriginController.text,
        destino: txtDestinyController.text,
        quantidadeTonelada:
            FormattedInputers.convertToDouble(txtTonController.text),
        tipoCargaId: 1,
        tipoTransacao: typeTransaction,
        photos: photos,
      ));*/
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

  Future<Map<String, dynamic>> insertExpenseCategory(String type) async {
    if (formKeyExpenseCategory.currentState!.validate()) {
      mensagem = await repository.insertCategory(
          ExpenseCategory(
            descricao: txtDescriptionExpenseCategoryController.text,
            status: 1,
            userId: ServiceStorage.getUserId(),
          ),
          type);
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getMyCategories();
        getMySpecifics();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  Future<Map<String, dynamic>> deleteTransaction(int id) async {
    if (formKeyTransaction.currentState!.validate()) {
      mensagem = await repository.delete(Transacoes(id: id));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
    }
    return retorno;
  }

  void fillInFields() {
    txtDescriptionController.text = selectedTransaction.descricao!;

    if (selectedTransaction!.data != null &&
        selectedTransaction!.data!.isNotEmpty) {
      try {
        DateTime date =
            DateFormat('yyyy-MM-dd').parse(selectedTransaction.data!);
        txtDateController.text = DateFormat('dd/MM/yyyy').format(date);
      } catch (e) {
        txtDateController.clear();
      }
    } else {
      txtDateController.clear();
    }

    txtValueController.text = FormattedInputers.formatValuePTBR(
        selectedTransaction.valor!.toString());
    txtCityController.text = selectedTransaction.cidade != null
        ? selectedTransaction.cidade.toString()
        : "";
    txtCompanyController.text = selectedTransaction.empresa != null
        ? selectedTransaction.empresa.toString()
        : "";
    txtDDDController.text = selectedTransaction.ddd != null
        ? selectedTransaction.ddd.toString()
        : "";
    txtPhoneController.text = selectedTransaction.telefone != null
        ? selectedTransaction.telefone.toString()
        : "";
    txtOriginController.text = selectedTransaction.origem != null
        ? selectedTransaction.origem.toString()
        : "";
    txtDestinyController.text = selectedTransaction.destino != null
        ? selectedTransaction.destino.toString()
        : "";
    txtTonController.text = selectedTransaction.quantidadeTonelada != null
        ? selectedTransaction.quantidadeTonelada.toString()
        : "";

    selectedCategory.value = selectedTransaction.categoriaDespesaId!;
    selectedCargoType.value = selectedTransaction.tipoCargaId;
    selectedSpecificType.value = selectedTransaction.tipoEspecificoDespesaId;

    if (selectedTransaction.photos!.isNotEmpty) {
      selectedImagesPaths.clear();
      for (var photo in selectedTransaction!.photos!) {
        Map<String, dynamic> foto = {
          "arquivo": photo.arquivo,
          "tipo": "update",
        };
        selectedImagesPaths.add(foto);
      }
    }
  }

  void clearAllFields() {
    final textControllers = [
      txtDescriptionController,
      txtDescriptionExpenseCategoryController,
      txtCityController,
      txtCompanyController,
      txtDDDController,
      txtPhoneController,
      txtValueController,
      txtDateController,
      txtOriginController,
      txtDestinyController,
      txtTonController,
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
    selectedImagesPaths.clear();
  }

  void filterTransactions(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredTransactions.value = transactions;
    } else {
      filteredTransactions.value = transactions.where((transaction) {
        return transaction.descricao!
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    }
  }
}
