import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/freight_model.dart';
import 'package:rodocalc/app/data/repositories/freight_repository.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class FreightController extends GetxController {
  final freightKey = GlobalKey<FormState>();
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

  final selectedStateOrigin = ''.obs;
  final selectedStateDestiny = ''.obs;
  var result = ''.obs;

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };

  dynamic mensagem;

  final repository = Get.put(FreightRepository());

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

  final states_map = {
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

  calculateFreight() async {
    //print(states_map[selectedStateOrigin]);

    final double valueReceive =
        double.parse(cleanValue(valueReceiveController.text));

    final double D =
        double.parse(cleanValue(distanceController.text)); //distancia
    final double M =
        double.parse(cleanValue(averageController.text)); // media km/l

    final double P = double.parse(
        cleanValue(priceDieselController.text)); //preco litro diesel

    final int Pn = int.parse(totalTiresController.text); //total de pneus
    final double T =
        double.parse(cleanValue(priceTiresController.text)); // preco dos pneus

    double tolls = double.parse(cleanValue(priceTollsController.text));

    double otherExpenses =
        double.parse(cleanValue(othersExpensesController.text));

    final double F1 = (D / M) * P;
    final double F2 = (((Pn * D) / 800) / 100) * T;

    final double totalExpenses = F1 + F2 + otherExpenses;

    final double profit = valueReceive - totalExpenses - tolls;

    mensagem = await repository.insert(Freight(
      origem: originController.text,
      ufOrigem: selectedStateOrigin.value,
      destino: destinyController.text,
      ufDestino: selectedStateDestiny.value,
      valorPedagio: tolls,
      distanciaKm: D,
      mediaKmL: M,
      precoCombustivel: P,
      quantidadePneus: Pn,
      valorPneu: T,
      valorRecebido: valueReceive,
      totalGastos: totalExpenses,
      lucro: profit,
      outrosGastos: otherExpenses,
      status: 1,
      userId: ServiceStorage.getUserId(),
    ));
    if (mensagem != null) {
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message'],
        'lucro': profit
      };
      getAll();
    } else {
      retorno = {
        'success': false,
        'message': ['Falha ao realizar a operação!'],
        'lucro': 0
      };
    }

    return retorno;
  }

  calculateFreightUpdate(Freight freight) async {
    //print(states_map[selectedStateOrigin]);

    final double valueReceive =
        double.parse(cleanValue(valueReceiveController.text));

    final double D =
        double.parse(cleanValue(distanceController.text)); //distancia
    final double M =
        double.parse(cleanValue(averageController.text)); // media km/l

    final double P = double.parse(
        cleanValue(priceDieselController.text)); //preco litro diesel

    final int Pn = int.parse(totalTiresController.text); //total de pneus
    final double T =
        double.parse(cleanValue(priceTiresController.text)); // preco dos pneus

    double tolls = double.parse(cleanValue(priceTollsController.text));

    double otherExpenses =
        double.parse(cleanValue(othersExpensesController.text));

    final double F1 = (D / M) * P;
    final double F2 = (((Pn * D) / 800) / 100) * T;

    final double totalExpenses = F1 + F2 + otherExpenses;

    final double profit = valueReceive - totalExpenses - tolls;

    mensagem = await repository.update(Freight(
      id: freight.id,
      origem: originController.text,
      ufOrigem: selectedStateOrigin.value,
      destino: destinyController.text,
      ufDestino: selectedStateDestiny.value,
      valorPedagio: tolls,
      distanciaKm: D,
      mediaKmL: M,
      precoCombustivel: P,
      quantidadePneus: Pn,
      valorPneu: T,
      valorRecebido: valueReceive,
      totalGastos: totalExpenses,
      lucro: profit,
      outrosGastos: otherExpenses,
      status: 1,
      userId: ServiceStorage.getUserId(),
    ));
    if (mensagem != null) {
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message'],
        'lucro': profit
      };
      getAll();
    } else {
      retorno = {
        'success': false,
        'message': ['Falha ao realizar a operação!'],
        'lucro': 0
      };
    }

    return retorno;
  }

  RxList<Freight> listFreight = RxList<Freight>([]);
  RxBool isLoading = true.obs;
  RxBool isLoadingData = true.obs;

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      listFreight.value = await repository.getAll();
      print(listFreight.value);
    } catch (e) {
      listFreight.clear();
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getTripData() async {
    isLoadingData.value = true;
    try {
      String origem = originController.text;
      String uf_origem = states_map[selectedStateOrigin.value]!;
      String destino = destinyController.text;
      String uf_destino = states_map[selectedStateDestiny.value]!;

      var response =
          await repository.getTripData(origem, uf_origem, destino, uf_destino);

      if (response != null) {
        distanceController.text =
            FormattedInputers.formatValuePTBR(response[0]['distancia']);
        priceTollsController.text =
            FormattedInputers.formatValuePTBR(response[0]['valorPedagio']);
      }
    } catch (e) {
      listFreight.clear();
      Exception(e);
    }
    isLoadingData.value = false;
  }

  void fillInFields(Freight freight) {
    originController.text = freight.origem!;
    destinyController.text = freight.destino!;
    valueReceiveController.text =
        "R\$ ${FormattedInputers.formatValuePTBR(freight.valorRecebido!.toString())}";
    distanceController.text =
        FormattedInputers.formatDoubleForDecimal(freight.distanciaKm!);
    averageController.text =
        FormattedInputers.formatDoubleForDecimal(freight.mediaKmL!);
    priceDieselController.text =
        "R\$ ${FormattedInputers.formatValuePTBR(freight.precoCombustivel!.toString())}";
    totalTiresController.text = freight.quantidadePneus.toString();
    priceTiresController.text =
        "R\$ ${FormattedInputers.formatValuePTBR(freight.valorPneu!.toString())}";
    priceTollsController.text =
        "R\$ ${FormattedInputers.formatValuePTBR(freight.valorPedagio!.toString())}";

    othersExpensesController.text =
        "R\$ ${FormattedInputers.formatValuePTBR(freight.outrosGastos!.toString())}";
    selectedStateOrigin.value = freight.ufOrigem.toString();
    selectedStateDestiny.value = freight.ufDestino.toString();
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
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
    selectedStateOrigin.value = '';
    selectedStateDestiny.value = '';
  }

  Future<Map<String, dynamic>> deleteFreight(int id) async {
    if (id > 0) {
      mensagem = await repository.delete(Freight(id: id));
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
