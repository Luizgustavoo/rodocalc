import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/freight_model.dart';
import 'package:rodocalc/app/data/repositories/freight_repository.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class FreightController extends GetxController {
  RxList<Freight> listFreight = RxList<Freight>([]);
  RxList<Freight> filteredFreights = RxList<Freight>([]);
  RxBool isLoading = true.obs;
  RxBool isLoadingData = true.obs;

  final freightKey = GlobalKey<FormState>();
  final originController = TextEditingController();
  final destinyController = TextEditingController();
  //final valueReceiveController = TextEditingController();
  final valueReceiveController = MoneyMaskedTextController(
    precision: 2,
    initialValue: 0.0,
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );
  final distanceController = TextEditingController();
  final averageController = TextEditingController();
  final priceDieselController = MoneyMaskedTextController(
    precision: 2,
    initialValue: 0.0,
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );
  final totalTiresController = TextEditingController();
  final priceTiresController = MoneyMaskedTextController(
    precision: 2,
    initialValue: 0.0,
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );
  final priceTollsController = MoneyMaskedTextController(
    precision: 2,
    initialValue: 0.0,
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );
  final othersExpensesController = MoneyMaskedTextController(
    precision: 2,
    initialValue: 0.0,
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );
  final searchFreightController = TextEditingController();

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

  @override
  void onInit() {
    super.onInit();
    filteredFreights.assignAll(listFreight);
  }

  String cleanValue(String value) {
    String cleanedValue = value.replaceAll(RegExp(r'R\$|\s'), '');
    cleanedValue = cleanedValue.replaceAll('.', '').replaceAll(',', '.');
    return cleanedValue;
  }

  calculateFreight() async {
    //print(states_map[selectedStateOrigin]);

    final RegExp cidadeUfRegex = RegExp(r'^[A-Za-zÀ-ÿ\s]+-[A-Z]{2}$');

    dynamic cidadeOrigemPartes;
    dynamic cidadeOrigem = "";
    dynamic ufOrigem = "";
    dynamic cidadeDestinoPartes;
    dynamic cidadeDestino = "";
    dynamic ufDestino = "";

    if (!cidadeUfRegex.hasMatch(originController.text)) {
      return {
        'success': false,
        'message': [
          'Formato de cidade (Origem) e UF inválido! Use "Cidade-UF".'
        ]
      };
    }

    cidadeOrigemPartes = originController.text.split('-');
    if (cidadeOrigemPartes.length != 2) {
      return {
        'success': false,
        'message': ['Formato de cidade inválido!']
      };
    }
    cidadeOrigem = cidadeOrigemPartes[0];
    ufOrigem = cidadeOrigemPartes[1];

    if (!cidadeUfRegex.hasMatch(destinyController.text)) {
      return {
        'success': false,
        'message': [
          'Formato de cidade (Destino) e UF inválido! Use "Cidade-UF".'
        ]
      };
    }

    cidadeDestinoPartes = destinyController.text.split('-');
    if (cidadeDestinoPartes.length != 2) {
      return {
        'success': false,
        'message': ['Formato de cidade inválido!']
      };
    }
    cidadeDestino = cidadeDestinoPartes[0];
    ufDestino = cidadeDestinoPartes[1];

    final double valueReceive =
        double.parse(cleanValue(valueReceiveController.text));

    final double D =
        double.parse(cleanValue(distanceController.text)); //distancia
    final double M =
        double.parse(cleanValue(averageController.text)); // media km/l

    final double P = double.parse(
        cleanValue(priceDieselController.text)); //preco litro diesel

    final int pn = int.parse(totalTiresController.text); //total de pneus
    final double T =
        double.parse(cleanValue(priceTiresController.text)); // preco dos pneus

    double tolls = cleanValue(priceTollsController.text).isNotEmpty
        ? double.parse(cleanValue(priceTollsController.text))
        : 0;
    double otherExpenses = 0;
    if (othersExpensesController.text.isNotEmpty) {
      otherExpenses = double.parse(cleanValue(othersExpensesController.text));
    }

    final double f1 = (D / M) * P;
    final double f2 = (((pn * D) / 800) / 100) * T;

    final double totalExpenses = f1 + f2 + otherExpenses;

    final double profit = valueReceive - totalExpenses - tolls;

    mensagem = await repository.insert(Freight(
      origem: cidadeOrigem,
      ufOrigem: ufOrigem,
      destino: cidadeDestino,
      ufDestino: ufDestino,
      valorPedagio: tolls,
      distanciaKm: D,
      mediaKmL: M,
      precoCombustivel: P,
      quantidadePneus: pn,
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

    final RegExp cidadeUfRegex = RegExp(r'^[A-Za-zÀ-ÿ\s]+-[A-Z]{2}$');

    dynamic cidadeOrigemPartes;
    dynamic cidadeOrigem = "";
    dynamic ufOrigem = "";
    dynamic cidadeDestinoPartes;
    dynamic cidadeDestino = "";
    dynamic ufDestino = "";

    if (!cidadeUfRegex.hasMatch(originController.text)) {
      return {
        'success': false,
        'message': [
          'Formato de cidade (Origem) e UF inválido! Use "Cidade-UF".'
        ]
      };
    }

    cidadeOrigemPartes = originController.text.split('-');
    if (cidadeOrigemPartes.length != 2) {
      return {
        'success': false,
        'message': ['Formato de cidade inválido!']
      };
    }
    cidadeOrigem = cidadeOrigemPartes[0];
    ufOrigem = cidadeOrigemPartes[1];

    if (!cidadeUfRegex.hasMatch(destinyController.text)) {
      return {
        'success': false,
        'message': [
          'Formato de cidade (Destino) e UF inválido! Use "Cidade-UF".'
        ]
      };
    }

    cidadeDestinoPartes = destinyController.text.split('-');
    if (cidadeDestinoPartes.length != 2) {
      return {
        'success': false,
        'message': ['Formato de cidade inválido!']
      };
    }
    cidadeDestino = cidadeDestinoPartes[0];
    ufDestino = cidadeDestinoPartes[1];

    final double valueReceive =
        double.parse(cleanValue(valueReceiveController.text));

    final double D =
        double.parse(cleanValue(distanceController.text)); //distancia
    final double M =
        double.parse(cleanValue(averageController.text)); // media km/l

    final double P = double.parse(
        cleanValue(priceDieselController.text)); //preco litro diesel

    final int pn = int.parse(totalTiresController.text); //total de pneus
    final double T =
        double.parse(cleanValue(priceTiresController.text)); // preco dos pneus

    double tolls = double.parse(cleanValue(priceTollsController.text));

    double otherExpenses =
        double.parse(cleanValue(othersExpensesController.text));

    final double f1 = (D / M) * P;
    final double f2 = (((pn * D) / 800) / 100) * T;

    final double totalExpenses = f1 + f2 + otherExpenses;

    final double profit = valueReceive - totalExpenses - tolls;

    mensagem = await repository.update(Freight(
      id: freight.id,
      origem: cidadeOrigem,
      ufOrigem: ufOrigem,
      destino: cidadeDestino,
      ufDestino: ufDestino,
      valorPedagio: tolls,
      distanciaKm: D,
      mediaKmL: M,
      precoCombustivel: P,
      quantidadePneus: pn,
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

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      searchFreightController.clear();
      listFreight.value = await repository.getAll();
      filteredFreights.assignAll(listFreight);
    } catch (e) {
      listFreight.clear();
      filteredFreights.clear();
      searchFreightController.clear();
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getTripData() async {
    isLoadingData.value = true;
    try {
      String origem = originController.text;
      String ufOrigem = statesMap[selectedStateOrigin.value]!;
      String destino = destinyController.text;
      String ufDestino = statesMap[selectedStateDestiny.value]!;

      var response =
          await repository.getTripData(origem, ufOrigem, destino, ufDestino);

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

  void filterFreights(String query) {
    if (query.isEmpty) {
      // Se a busca estiver vazia, mostra todos os fretes
      filteredFreights.assignAll(listFreight);
    } else {
      // Filtra os fretes com base no campo "origem", "destino" ou qualquer outro
      filteredFreights.assignAll(
        listFreight
            .where((freight) =>
                freight.origem!.toLowerCase().contains(query.toLowerCase()) ||
                freight.destino!.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  void fillInFields(Freight freight) {
    originController.text = "${freight.origem!}-${freight.ufOrigem!}";
    destinyController.text = "${freight.destino!}-${freight.ufDestino!}";
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
