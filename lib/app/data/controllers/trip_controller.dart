import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rodocalc/app/data/controllers/transaction_controller.dart';
import 'package:rodocalc/app/data/models/charge_type_model.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/expense_trip_model.dart';
import 'package:rodocalc/app/data/models/specific_type_expense_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/data/models/trip_photos.dart';
import 'package:rodocalc/app/data/repositories/transaction_repository.dart';
import 'package:rodocalc/app/data/repositories/trip_repository.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class TripController extends GetxController {
  RxList<Trip> listTrip = RxList<Trip>([]);
  RxList<Trip> filteredTrips = RxList<Trip>([]);
  RxBool isLoading = true.obs;
  RxBool isLoadingCRUD = false.obs;
  RxBool isLoadingData = true.obs;
  RxBool isLoadingInsertPhotos = false.obs;

  final tripFormKey = GlobalKey<FormState>();
  final viewTripFormKey = GlobalKey<FormState>();
  final originController = TextEditingController();
  final destinyController = TextEditingController();
  final valueReceiveController = TextEditingController();
  final distanceController = TextEditingController();
  final tripNumberController = TextEditingController();
  final averageController = TextEditingController();
  final priceDieselController = TextEditingController();
  final totalTiresController = TextEditingController();
  final priceTiresController = TextEditingController();
  final priceTollsController = TextEditingController();
  final othersExpensesController = TextEditingController();
  final txtDateController = TextEditingController();
  final txtDateFinishedController = TextEditingController();
  final txtKmController = TextEditingController();
  final txtKmInicialTrechoController = TextEditingController();
  final txtToneladasTrechoController = TextEditingController();
  final txtKmFinalTrechoController = TextEditingController();

  final txtInitialDateController = TextEditingController();
  final txtFinishDateController = TextEditingController();

  var selectedImagesPaths = <String>[].obs;
  var selectedImagesPathsApi = <String>[].obs;
  var selectedImagesPathsApiRemove = <String>[].obs;

  RxList<ExpenseCategory> expenseCategories = <ExpenseCategory>[].obs;
  RxList<SpecificTypeExpense> specificTypes = <SpecificTypeExpense>[].obs;
  RxList<ChargeType> listChargeTypes = <ChargeType>[].obs;
  RxBool isLoadingChargeTypes = true.obs;

  var selectedSpecificType = Rxn<int>();
  var selectedCategory = Rxn<int>();
  var selectedCategoryCadSpecificType = Rxn<int>(0);
  var selectedCargoType = Rxn<int>();

  final expenseTripFormKey = GlobalKey<FormState>();
  final txtDateExpenseTripController = TextEditingController();
  final txtDescriptionExpenseTripController = TextEditingController();
  final txtTipoLancamentoTripController =
      TextEditingController(text: "entrada");
  var txtAmountExpenseTripController = MoneyMaskedTextController(
    precision: 2,
    initialValue: 0.0,
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );

  final searchTripController = TextEditingController();

  final selectedStateOrigin = ''.obs;
  final selectedStateDestiny = ''.obs;
  var result = ''.obs;

  var selectedOption = ''.obs;

  RxBool isDialogOpen = false.obs;

  final options = {'Saída', 'Chegada'}.toList();

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };

  dynamic mensagem;

  final repository = Get.put(TripRepository());
  final repositoryTransaction = Get.put(TransactionRepository());

  final states = [
    'AC',
    'AL',
    'AM',
    'AP',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MG',
    'MS',
    'MT',
    'PA',
    'PB',
    'PE',
    'PI',
    'PR',
    'RJ',
    'RN',
    'RO',
    'RR',
    'RS',
    'SC',
    'SE',
    'SP',
    'TO'
  ];

  final statesMap = {
    'AC': 'acre',
    'AL': 'alagoas',
    'AM': 'amazonas',
    'AP': 'amapa',
    'BA': 'bahia',
    'CE': 'ceara',
    'DF': 'distrito federal',
    'ES': 'espirito santo',
    'GO': 'goias',
    'MA': 'maranhao',
    'MG': 'minas gerais',
    'MS': 'mato grosso do sul',
    'MT': 'mato grosso',
    'PA': 'para',
    'PB': 'paraiba',
    'PE': 'pernambuco',
    'PI': 'piaui',
    'PR': 'parana',
    'RJ': 'rio de janeiro',
    'RN': 'rio grande do norte',
    'RO': 'rondonia',
    'RR': 'roraima',
    'RS': 'rio grande do sul',
    'SC': 'santa catarina',
    'SE': 'sergipe',
    'SP': 'sao paulo',
    'TO': 'tocantins'
  };

  pickImage(ImageSource source) async {
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
              doneButtonTitle: 'Concluir',
              cancelButtonTitle: 'Cancelar',
            ),
          ],
        );
        if (croppedFile != null) {
          final compressedFile = await FlutterImageCompress.compressAndGetFile(
            croppedFile.path,
            '${croppedFile.path}_compressed.jpg',
            quality: 50, // Adjust quality as needed to get under 2 MB
          );

          if (compressedFile != null) {
            selectedImagesPaths.add(compressedFile.path);

            // Optional: Check the size of the compressed file
            final fileSize = await compressedFile.length();
            if (fileSize > 2 * 1024 * 1024) {
              // 2 MB in bytes
              Get.snackbar('Erro', 'Imagem ainda maior que 2 MB');
            }
          } else {
            Get.snackbar('Erro', 'Falha na compressão da imagem');
          }
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
          final compressedFile = await FlutterImageCompress.compressAndGetFile(
            croppedFile.path,
            '${croppedFile.path}_compressed.jpg',
            quality: 50, // Adjust quality as needed to get under 2 MB
          );

          if (compressedFile != null) {
            selectedImagesPaths.add(compressedFile.path);

            // Optional: Check the size of the compressed file
            final fileSize = await compressedFile.length();
            if (fileSize > 2 * 1024 * 1024) {
              // 2 MB in bytes
              Get.snackbar('Erro', 'Imagem ainda maior que 2 MB');
            }
          } else {
            Get.snackbar('Erro', 'Falha na compressão da imagem');
          }
        }
      } else {
        Get.snackbar('Erro', 'Nenhuma imagem selecionada');
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    filteredTrips.assignAll(listTrip);
  }

  String cleanValue(String value) {
    String cleanedValue = value.replaceAll(RegExp(r'R\$|\s'), '');
    cleanedValue = cleanedValue.replaceAll('.', '').replaceAll(',', '.');
    return cleanedValue;
  }

  Future<void> selectDateTime(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        controller.text = "${fullDateTime.day.toString().padLeft(2, '0')}/"
            "${fullDateTime.month.toString().padLeft(2, '0')}/"
            "${fullDateTime.year} "
            "${pickedTime.hour.toString().padLeft(2, '0')}:"
            "${pickedTime.minute.toString().padLeft(2, '0')}";
      }
    }
  }

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      searchTripController.clear();
      listTrip.value = await repository.getAll();
      filteredTrips.assignAll(listTrip);
    } catch (e) {
      listTrip.clear();
      filteredTrips.clear();
      Exception(e);
    }
    isLoading.value = false;
  }

  void filterTrips(String query) {
    if (query.isEmpty) {
      // Se a busca estiver vazia, mostra todos os fretes
      filteredTrips.assignAll(listTrip);
    } else {
      // Filtra os fretes com base no campo "origem", "destino" ou qualquer outro
      filteredTrips.assignAll(
        listTrip
            .where((trip) =>
                trip.origem!.toLowerCase().contains(query.toLowerCase()) ||
                trip.destino!.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  void fillInFieldsExpenseTrip(Transacoes transacao) {
    if (transacao.data != null && transacao.data!.isNotEmpty) {
      try {
        DateTime date = DateTime.parse(transacao.data!);
        txtDateExpenseTripController.text =
            DateFormat('dd/MM/yyyy H:mm').format(date);
      } catch (e) {
        txtDateExpenseTripController.clear();
      }
    } else {
      txtDateExpenseTripController.clear();
    }

    txtTipoLancamentoTripController.text = transacao.tipoTransacao!;

    txtDescriptionExpenseTripController.text = transacao.descricao.toString();
    txtKmController.text = transacao.km.toString();

    txtAmountExpenseTripController.text =
        'R\$${FormattedInputers.formatValuePTBR((transacao.valor).toString())}';
  }

  void fillInFields(Trip trip) {
    selectedOption.value = trip.tipoSaidaChegada.toString();

    if (trip.dataHora != null && trip.dataHora!.isNotEmpty) {
      try {
        DateTime date = DateTime.parse(trip.dataHora!);
        txtDateController.text = DateFormat('dd/MM/yyyy H:mm').format(date);
      } catch (e) {
        txtDateController.clear();
      }
    } else {
      txtDateController.clear();
    }

    if (trip.dataHoraChegada != null && trip.dataHoraChegada!.isNotEmpty) {
      try {
        DateTime dateFinished = DateTime.parse(trip.dataHoraChegada!);
        txtDateFinishedController.text =
            DateFormat('dd/MM/yyyy H:mm').format(dateFinished);
      } catch (e) {
        txtDateFinishedController.clear();
      }
    } else {
      txtDateFinishedController.clear();
    }

    originController.text =
        "${trip.origem.toString()}-${trip.ufOrigem.toString()}";
    destinyController.text =
        "${trip.destino.toString()}-${trip.ufDestino.toString()}";
    distanceController.text =
        FormattedInputers.formatDoubleForDecimal(trip.distancia!);

    txtKmInicialTrechoController.text = trip.km ?? '';
    tripNumberController.text = trip.numeroViagem ?? '';
  }

  void clearAllFields() {
    isDialogOpen.value = false;
    final textControllers = [
      originController,
      destinyController,
      valueReceiveController,
      distanceController,
      averageController,
      priceDieselController,
      totalTiresController,
      priceTiresController,
      priceTollsController,
      othersExpensesController,
      txtDateController,
      txtDateFinishedController,
      originController,
      txtDateExpenseTripController,
      txtTipoLancamentoTripController,
      txtDescriptionExpenseTripController,
      txtKmInicialTrechoController,
      txtKmFinalTrechoController,
      tripNumberController,
      txtDescriptionExpenseCategoryController,
      txtChargeTypeController,
      txtToneladasTrechoController,
      txtInitialDateController,
      txtFinishDateController,
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
    selectedStateOrigin.value = '';
    selectedStateDestiny.value = '';
    selectedOption.value = '';
    selectedCargoType.value = null;

    txtAmountExpenseTripController = MoneyMaskedTextController(
      precision: 2,
      initialValue: 0.0,
      decimalSeparator: ',',
      thousandSeparator: '.',
      leftSymbol: 'R\$ ',
    );
  }

  void clearAllFieldsExpense() {
    final textControllers = [
      txtDateExpenseTripController,
      txtTipoLancamentoTripController,
      txtDescriptionExpenseTripController,
      txtAmountExpenseTripController,
    ];
    for (final controller in textControllers) {
      controller.clear();
    }
  }

  Future<Map<String, dynamic>> insertTrip() async {
    isLoadingCRUD(true);
    if (tripFormKey.currentState!.validate()) {
      // Define a expressão regular para validar o formato "Cidade-UF"
      final RegExp cidadeUfRegex = RegExp(r'^[A-Za-zÀ-ÿ\s]+-[A-Z]{2}$');

      // Valida e separa as strings de origem e destino
      if (!cidadeUfRegex.hasMatch(originController.text) ||
          !cidadeUfRegex.hasMatch(destinyController.text)) {
        isLoadingCRUD(false);
        return {
          'success': false,
          'message': ['Formato de cidade e UF inválido! Use "Cidade-UF".']
        };
      }

      // Separa a cidade e UF de origem
      final origemPartes = originController.text.split('-');
      if (origemPartes.length != 2) {
        isLoadingCRUD(false);
        return {
          'success': false,
          'message': ['Formato de origem inválido!']
        };
      }
      final cidadeOrigem = origemPartes[0];
      final ufOrigem = origemPartes[1];

      // Separa a cidade e UF de destino
      final destinoPartes = destinyController.text.split('-');
      if (destinoPartes.length != 2) {
        isLoadingCRUD(false);
        return {
          'success': false,
          'message': ['Formato de destino inválido!']
        };
      }
      final cidadeDestino = destinoPartes[0];
      final ufDestino = destinoPartes[1];

      mensagem = await repository.insert(Trip(
        userId: ServiceStorage.getUserId(),
        veiculoId: ServiceStorage.idSelectedVehicle(),
        dataHora: txtDateController.text,
        dataHoraChegada: txtDateFinishedController.text,
        tipoSaidaChegada: selectedOption.value,
        origem: cidadeOrigem,
        ufOrigem: ufOrigem,
        destino: cidadeDestino,
        ufDestino: ufDestino,
        distancia: FormattedInputers.convertToDouble(distanceController.text),
        status: 1,
        km: txtKmInicialTrechoController.text,
        kmFinal: txtKmFinalTrechoController.text,
        numeroViagem: tripNumberController.text,
        quantidadeTonelada: txtToneladasTrechoController.text,
        tipoCargaId: selectedCargoType.value,
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
    isLoadingCRUD(false);
    return retorno;
  }

  Future<Map<String, dynamic>> insertExpenseTrip(int trechoPercorridoId) async {
    isLoadingCRUD(false);

    Transacoes transaction = Transacoes();

    transaction.data = txtDateExpenseTripController.text;
    transaction.valor =
        FormattedInputers.convertToDouble(txtAmountExpenseTripController.text);
    transaction.descricao = txtDescriptionExpenseTripController.text;
    transaction.status = 1;
    transaction.tipoTransacao = txtTipoLancamentoTripController.text.isEmpty
        ? "entrada"
        : txtTipoLancamentoTripController.text;

    transaction.km = txtKmController.text;
    transaction.origemTransacao = "TRECHO";
    transaction.trechoId = trechoPercorridoId;
    transaction.pessoaId = ServiceStorage.getUserId();
    transaction.veiculoId = ServiceStorage.idSelectedVehicle();

    mensagem = await repositoryTransaction.insert(transaction);

    // mensagem = await repository.insertExpenseTrip(ExpenseTrip(
    //   trechoPercorridoId: trechoPercorridoId,
    //   dataHora: txtDateExpenseTripController.text,
    //   descricao: txtDescriptionExpenseTripController.text,
    //   valorDespesa: FormattedInputers.convertForCents(
    //       txtAmountExpenseTripController.text),
    //   status: 1,
    //   km: txtKmController.text,
    // ));

    if (mensagem != null) {
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
      Get.find<TransactionController>().getSaldo();
      //clearAllFields();
    } else {
      retorno = {
        'success': false,
        'message': ['Falha ao realizar a operação!']
      };
    }

    isLoadingCRUD(false);
    return retorno;
  }

  Future<Map<String, dynamic>> updateExpenseTrip(
      int trechoPercorridoId, int expenseTripId) async {
    isLoadingCRUD(false);

    mensagem = await repository.updateExpenseTrip(ExpenseTrip(
      id: expenseTripId,
      trechoPercorridoId: trechoPercorridoId,
      dataHora: txtDateExpenseTripController.text,
      descricao: txtDescriptionExpenseTripController.text,
      valorDespesa: FormattedInputers.convertForCents(
          txtAmountExpenseTripController.text),
      status: 1,
      km: txtKmController.text,
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

    isLoadingCRUD(false);
    return retorno;
  }

  Future<Map<String, dynamic>> deleteExpenseTrip(int id) async {
    isLoadingCRUD(false);
    if (id > 0) {
      mensagem = await repository.deleteExpenseTrip(ExpenseTrip(id: id));
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
    isLoadingCRUD(false);
    return retorno;
  }

  Future<Map<String, dynamic>> updateTrip(int id) async {
    isLoadingCRUD(false);
    if (tripFormKey.currentState!.validate()) {
      // Define a expressão regular para validar o formato "Cidade-UF"
      final RegExp cidadeUfRegex = RegExp(r'^[A-Za-zÀ-ÿ\s]+-[A-Z]{2}$');

      // Valida e separa as strings de origem e destino
      if (!cidadeUfRegex.hasMatch(originController.text) ||
          !cidadeUfRegex.hasMatch(destinyController.text)) {
        isLoadingCRUD(false);
        return {
          'success': false,
          'message': ['Formato de cidade e UF inválido! Use "Cidade-UF".']
        };
      }

      // Separa a cidade e UF de origem
      final origemPartes = originController.text.split('-');
      if (origemPartes.length != 2) {
        isLoadingCRUD(false);
        return {
          'success': false,
          'message': ['Formato de origem inválido!']
        };
      }
      final cidadeOrigem = origemPartes[0];
      final ufOrigem = origemPartes[1];

      // Separa a cidade e UF de destino
      final destinoPartes = destinyController.text.split('-');
      if (destinoPartes.length != 2) {
        isLoadingCRUD(false);
        return {
          'success': false,
          'message': ['Formato de destino inválido!']
        };
      }
      final cidadeDestino = destinoPartes[0];
      final ufDestino = destinoPartes[1];

      mensagem = await repository.update(Trip(
        id: id,
        userId: ServiceStorage.getUserId(),
        veiculoId: ServiceStorage.idSelectedVehicle(),
        dataHora: txtDateController.text,
        dataHoraChegada: txtDateFinishedController.text,
        tipoSaidaChegada: selectedOption.value,
        origem: cidadeOrigem,
        ufOrigem: ufOrigem,
        destino: cidadeDestino,
        ufDestino: ufDestino,
        distancia: FormattedInputers.convertToDouble(distanceController.text),
        status: 1,
        km: txtKmInicialTrechoController.text,
        kmFinal: txtKmFinalTrechoController.text,
        numeroViagem: tripNumberController.text,
        quantidadeTonelada: txtToneladasTrechoController.text,
        tipoCargaId: selectedCargoType.value,
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
    isLoadingCRUD(false);
    return retorno;
  }

  Future<Map<String, dynamic>> deleteTrip(int id) async {
    isLoadingCRUD(false);
    if (id > 0) {
      mensagem = await repository.delete(Trip(id: id));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
      isDialogOpen.value = false;
    } else {
      retorno = {
        'success': false,
        'message': ['Falha ao realizar a operação!']
      };
    }
    isLoadingCRUD(false);
    return retorno;
  }

  Future<Map<String, dynamic>> deletePhotoTrip(int id) async {
    isLoadingCRUD(false);
    if (id > 0) {
      mensagem = await repository.deletePhotoTrip(id);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
      isDialogOpen.value = false;
    } else {
      retorno = {
        'success': false,
        'message': ['Falha ao realizar a operação!']
      };
    }
    isLoadingCRUD(false);
    return retorno;
  }

  Future<Map<String, dynamic>> closeTrip(int id) async {
    isLoadingCRUD(false);
    if (id > 0) {
      mensagem = await repository.close(Trip(id: id));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
      isDialogOpen.value = false;
    } else {
      retorno = {
        'success': false,
        'message': ['Falha ao realizar a operação!']
      };
    }
    isLoadingCRUD(false);
    return retorno;
  }

  final txtDescriptionExpenseCategoryController = TextEditingController();
  final txtChargeTypeController = TextEditingController();
  final formkeyChargeType = GlobalKey<FormState>();

  void clearDescriptionModal() {
    final textControllers = [
      txtDescriptionExpenseCategoryController,
      txtChargeTypeController,
    ];
    for (final controller in textControllers) {
      controller.clear();
    }
  }

  final repositoryChargeType = Get.put(TransactionRepository());

  Future<Map<String, dynamic>> insertChargeType() async {
    if (formkeyChargeType.currentState!.validate()) {
      mensagem = await repositoryChargeType.insertChargeType(
        ChargeType(descricao: txtChargeTypeController.text, status: 1),
      );
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        if (mensagem['success'] == true) {
          selectedCargoType.value = mensagem['data']['id'];
        }
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

  Future<void> getMyChargeTypes() async {
    isLoadingChargeTypes.value = true;
    try {
      listChargeTypes.value = await repositoryChargeType.getMyChargeTypes();
    } catch (e) {
      Exception(e);
    }
    isLoadingChargeTypes.value = false;
  }

  Future<Map<String, dynamic>> insertTripPhotos(int tripId) async {
    isLoadingInsertPhotos.value = true;

    List<TripPhotos>? photos = [];
    if (selectedImagesPaths.isNotEmpty) {
      for (var element in selectedImagesPaths) {
        photos.add(TripPhotos(arquivo: element));
      }
    }

    Trip trip = Trip();
    trip.id = tripId;
    trip.photos = photos;

    mensagem = await repository.insertFotoTrecho(trip);

    if (mensagem != null) {
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };

      if (mensagem['success'] == true) {
        getAll();
        clearAllFields();
      }
    } else {
      retorno = {
        'success': false,
        'message': ['Falha ao realizar a operação!']
      };
    }

    isLoadingInsertPhotos.value = false;
    return retorno;
  }
}
