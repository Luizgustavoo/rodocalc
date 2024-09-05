import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rodocalc/app/data/models/expense_trip_model.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/data/repositories/trip_repository.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class TripController extends GetxController {
  final tripFormKey = GlobalKey<FormState>();
  final originController = TextEditingController();
  final destinyController = TextEditingController();
  final valueReceiveController = TextEditingController();
  final distanceController = TextEditingController();
  final averageController = TextEditingController();
  final priceDieselController = TextEditingController();
  final totalTiresController = TextEditingController();
  final priceTiresController = TextEditingController();
  final priceTollsController = TextEditingController();
  final othersExpensesController = TextEditingController();
  final txtDateController = TextEditingController();

  final expenseTripFormKey = GlobalKey<FormState>();
  final txtDateExpenseTripController = TextEditingController();
  final txtDescriptionExpenseTripController = TextEditingController();
  final txtAmountExpenseTripController = TextEditingController();

  final selectedStateOrigin = ''.obs;
  final selectedStateDestiny = ''.obs;
  var result = ''.obs;

  var selectedOption = 'Saída'.obs;

  final options = ['Saída', 'Chegada'];

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };

  dynamic mensagem;

  final repository = Get.put(TripRepository());

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

  RxList<Trip> listTrip = RxList<Trip>([]);
  RxBool isLoading = true.obs;
  RxBool isLoadingData = true.obs;

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      listTrip.value = await repository.getAll();
    } catch (e) {
      listTrip.clear();
      Exception(e);
    }
    isLoading.value = false;
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

    originController.text = trip.origem.toString();
    selectedStateOrigin.value = trip.ufOrigem.toString();
    destinyController.text = trip.destino.toString();
    selectedStateDestiny.value = trip.ufDestino.toString();
    distanceController.text =
        FormattedInputers.formatDoubleForDecimal(trip.distancia!);
  }

  void clearAllFields() {
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
      originController,
      txtDateExpenseTripController,
      txtAmountExpenseTripController,
      txtDescriptionExpenseTripController,
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
    selectedStateOrigin.value = '';
    selectedStateDestiny.value = '';
    selectedOption.value = '';
  }

  Future<Map<String, dynamic>> insertTrip() async {
    if (tripFormKey.currentState!.validate()) {
      mensagem = await repository.insert(Trip(
        userId: ServiceStorage.getUserId(),
        veiculoId: ServiceStorage.idSelectedVehicle(),
        dataHora: txtDateController.text,
        tipoSaidaChegada: selectedOption.value,
        origem: originController.text,
        ufOrigem: selectedStateOrigin.value,
        destino: destinyController.text,
        ufDestino: selectedStateDestiny.value,
        distancia: FormattedInputers.convertToDouble(distanceController.text),
        status: 1,
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

  Future<Map<String, dynamic>> insertExpenseTrip(int trechoPercorridoId) async {
    if (tripFormKey.currentState!.validate()) {
      mensagem = await repository.insertExpenseTrip(ExpenseTrip(
        trechoPercorridoId: trechoPercorridoId,
        dataHora: txtDateExpenseTripController.text,
        descricao: txtDescriptionExpenseTripController.text,
        valorDespesa: FormattedInputers.convertForCents(
            txtAmountExpenseTripController.text),
        status: 1,
      ));

      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getAll();
        //clearAllFields();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  Future<Map<String, dynamic>> updateExpenseTrip(
      int trechoPercorridoId, int expenseTripId) async {
    if (tripFormKey.currentState!.validate()) {
      mensagem = await repository.updateExpenseTrip(ExpenseTrip(
        id: expenseTripId,
        trechoPercorridoId: trechoPercorridoId,
        dataHora: txtDateExpenseTripController.text,
        descricao: txtDescriptionExpenseTripController.text,
        valorDespesa: int.parse(txtAmountExpenseTripController.text),
        status: 1,
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

  Future<Map<String, dynamic>> deleteExpenseTrip(int id) async {
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

    return retorno;
  }

  Future<Map<String, dynamic>> updateTrip(int id) async {
    if (tripFormKey.currentState!.validate()) {
      mensagem = await repository.update(Trip(
        id: id,
        userId: ServiceStorage.getUserId(),
        veiculoId: ServiceStorage.idSelectedVehicle(),
        dataHora: txtDateController.text,
        tipoSaidaChegada: selectedOption.value,
        origem: originController.text,
        ufOrigem: selectedStateOrigin.value,
        destino: destinyController.text,
        ufDestino: selectedStateDestiny.value,
        distancia: FormattedInputers.convertToDouble(distanceController.text),
        status: 1,
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

  Future<Map<String, dynamic>> deleteTrip(int id) async {
    if (id > 0) {
      mensagem = await repository.delete(Trip(id: id));
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
