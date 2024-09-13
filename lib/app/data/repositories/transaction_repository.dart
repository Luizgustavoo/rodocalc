import 'package:rodocalc/app/data/models/charge_type_model.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/specific_type_expense_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/models/vehicle_balance_model.dart';
import 'package:rodocalc/app/data/providers/transaction_provider.dart';
import 'package:rodocalc/app/utils/services.dart';

class TransactionRepository {
  final TransactionApiClient apiClient = TransactionApiClient();

  getAll() async {
    List<Transacoes> list = <Transacoes>[];

    var response = await apiClient.gettAll();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Transacoes.fromJson(e));
      });

      if (response['data'] != null) {
        // Converte os valores para double e usa zero se nulo
        Services.totalRecebimentos.value = 0;
        Services.totalGastos.value = 0;
        double totalRecebimentosValue = response['total_recebimentos'] != null
            ? double.tryParse(response['total_recebimentos'].toString()) ?? 0.0
            : 0.0;

        double totalGastosValue = response['total_gastos'] != null
            ? double.tryParse(response['total_gastos'].toString()) ?? 0.0
            : 0.0;

        Services.totalRecebimentos.value = totalRecebimentosValue;
        Services.totalGastos.value = totalGastosValue;
      } else {
        Services.totalRecebimentos.value = 0;
        Services.totalGastos.value = 0;
      }
    }

    return list;
  }

  getTransactionsWithFilter(
      String? dataInicial, String? dataFinal, String? descricao) async {
    List<Transacoes> list = <Transacoes>[];
    try {
      var response = await apiClient.getTransactionsWithFilter(
          dataInicial, dataFinal, descricao);

      if (response != null &&
          response['data'] != null &&
          response['data'] != "null") {
        response['data'].forEach((e) {
          list.add(Transacoes.fromJson(e));
        });

        // Converte os valores para double e usa zero se nulo
        Services.totalRecebimentos.value = 0;
        Services.totalGastos.value = 0;
        double totalRecebimentosValue = response['total_recebimentos'] != null
            ? double.tryParse(response['total_recebimentos'].toString()) ?? 0.0
            : 0.0;

        double totalGastosValue = response['total_gastos'] != null
            ? double.tryParse(response['total_gastos'].toString()) ?? 0.0
            : 0.0;

        Services.totalRecebimentos.value = totalRecebimentosValue;
        Services.totalGastos.value = totalGastosValue;
      } else {
        Services.totalRecebimentos.value = 0;
        Services.totalGastos.value = 0;
      }
    } catch (e) {
      Exception(e);
    }
    return list;
  }

  getLast() async {
    List<Transacoes> list = <Transacoes>[];

    try {
      var response = await apiClient.getLast();

      if (response != null) {
        response['data'].forEach((e) {
          list.add(Transacoes.fromJson(e));
        });
      }
    } catch (e) {
      Exception(e);
    }

    return list;
  }

  getSaldo() async {
    VehicleBalance balance = VehicleBalance();
    var response = await apiClient.gettSaldo();
    if (response != null) {
      balance = VehicleBalance.fromJson(response['data']);
    }
    return balance;
  }

  getMyCategories() async {
    List<ExpenseCategory> list = <ExpenseCategory>[];

    var response = await apiClient.getMyCategories();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(ExpenseCategory.fromJson(e));
      });
    }

    return list;
  }

  getMyChargeTypes() async {
    List<ChargeType> list = <ChargeType>[];

    var response = await apiClient.getMyChargeTypes();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(ChargeType.fromJson(e));
      });
    }

    return list;
  }

  getMySpecifics() async {
    List<SpecificTypeExpense> list = <SpecificTypeExpense>[];

    var response = await apiClient.getMySpecifics();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(SpecificTypeExpense.fromJson(e));
      });
    }

    return list;
  }

  insert(Transacoes transaction) async {
    try {
      var response = await apiClient.insert(transaction);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  insertCategory(ExpenseCategory category, String type) async {
    try {
      var response = await apiClient.insertCategory(category, type);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  insertChargeType(ChargeType chargeType) async {
    try {
      var response = await apiClient.insertChargeType(chargeType);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  update(Transacoes transaction, List<String> photosRemove) async {
    try {
      var response = await apiClient.update(transaction, photosRemove);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  delete(Transacoes transaction) async {
    try {
      var response = await apiClient.delete(transaction);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
