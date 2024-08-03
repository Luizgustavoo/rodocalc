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

  var selectedImagesPaths = <String>[].obs;
  var selectedImagesPathsApi = <String>[].obs;
  var selectedImagesPathsApiRemove = <String>[].obs;

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
  RxBool isLoadingChargeTypes = true.obs;
  RxBool isLoadingBalance = true.obs;

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

  var balance = 0.0.obs;

  var entradasMesAtual = 0.0.obs;
  var saidasMesAtual = 0.0.obs;
  var entradasMesAnterior = 0.0.obs;
  var saidasMesAnterior = 0.0.obs;
  var variacaoEntradas = "".obs;
  var variacaoSaidas = "".obs;

  var transactions = <Transacoes>[].obs;
  var filteredTransactions = <Transacoes>[].obs;
  var searchQuery = ''.obs;

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

  Future<void> getSaldo() async {
    isLoadingBalance.value = true;
    try {
      final balanceVehicle = await repository.getSaldo();
      if (balanceVehicle != null) {
        balance.value = (balanceVehicle.saldoTotal as num).toDouble();
        entradasMesAtual.value = balanceVehicle.entradasMesAtual;
        saidasMesAtual.value = balanceVehicle.saidasMesAtual;
        entradasMesAnterior.value = balanceVehicle.entradasMesAnterior;
        saidasMesAnterior.value = balanceVehicle.saidasMesAnterior;
        variacaoEntradas.value = balanceVehicle.variacaoEntradas;
        variacaoSaidas.value = balanceVehicle.variacaoSaidas;
      }
    } catch (e) {
      Exception(e);
    }
    isLoadingBalance.value = false;
  }

  RxList<ExpenseCategory> expenseCategories = <ExpenseCategory>[].obs;
  RxList<SpecificTypeExpense> specificTypes = <SpecificTypeExpense>[].obs;
  RxList<ChargeType> listChargeTypes = <ChargeType>[].obs;

  Future<void> getMyChargeTypes() async {
    isLoadingChargeTypes.value = true;
    try {
      listChargeTypes.value = await repository.getMyChargeTypes();
    } catch (e) {
      Exception(e);
    }
    isLoadingChargeTypes.value = false;
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

  Future<Map<String, dynamic>> insertTransaction(String typeTransaction) async {
    if (formKeyTransaction.currentState!.validate()) {
      List<TransactionsPhotos>? photos = [];
      if (selectedImagesPaths.isNotEmpty) {
        for (var element in selectedImagesPaths) {
          photos.add(TransactionsPhotos(arquivo: element));
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
        getSaldo();
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

  Future<Map<String, dynamic>> updateTransaction(
      String typeTransaction, int $id) async {
    if (formKeyTransaction.currentState!.validate()) {
      List<TransactionsPhotos>? photos = [];
      if (selectedImagesPaths.isNotEmpty) {
        for (var element in selectedImagesPaths) {
          photos.add(TransactionsPhotos(arquivo: element));
        }
      }

      mensagem = await repository.update(
          Transacoes(
            id: $id,
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
          ),
          selectedImagesPathsApiRemove.value);
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

  void fillInFields(Transacoes selected) {
    txtDescriptionController.text = selected.descricao!;

    if (selected.data != null && selected.data!.isNotEmpty) {
      try {
        DateTime date = DateFormat('yyyy-MM-dd').parse(selected.data!);
        txtDateController.text = DateFormat('dd/MM/yyyy').format(date);
      } catch (e) {
        txtDateController.clear();
      }
    } else {
      txtDateController.clear();
    }

    txtValueController.text =
        FormattedInputers.formatValuePTBR(selected.valor!.toString());
    txtCityController.text =
        selected.cidade != null ? selected.cidade.toString() : "";
    txtCompanyController.text =
        selected.empresa != null ? selected.empresa.toString() : "";
    txtDDDController.text = selected.ddd != null ? selected.ddd.toString() : "";
    txtPhoneController.text =
        selected.telefone != null ? selected.telefone.toString() : "";
    txtOriginController.text =
        selected.origem != null ? selected.origem.toString() : "";
    txtDestinyController.text =
        selected.destino != null ? selected.destino.toString() : "";
    txtTonController.text = selected.quantidadeTonelada != null
        ? selected.quantidadeTonelada.toString()
        : "";

    selectedCategory.value = selected.categoriaDespesaId!;
    selectedCargoType.value = selected.tipoCargaId;
    selectedSpecificType.value = selected.tipoEspecificoDespesaId;

    if (selected.photos!.isNotEmpty) {
      selectedImagesPathsApiRemove.clear();
      selectedImagesPathsApi.clear();
      for (var photo in selected.photos!) {
        selectedImagesPathsApi.add(photo.arquivo!.toString());
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
    selectedImagesPathsApi.clear();
    selectedImagesPathsApiRemove.clear();
  }

  void clearDescriptionModal() {
    final textControllers = [
      txtDescriptionExpenseCategoryController,
    ];
    for (final controller in textControllers) {
      controller.clear();
    }
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
