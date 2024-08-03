import 'package:rodocalc/app/data/models/charge_type_model.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/specific_type_expense_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/models/vehicle_balance_model.dart';
import 'package:rodocalc/app/data/providers/transaction_provider.dart';

class TransactionRepository {
  final TransactionApiClient apiClient = TransactionApiClient();

  getAll() async {
    List<Transacoes> list = <Transacoes>[];

    var response = await apiClient.gettAll();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Transacoes.fromJson(e));
      });
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
