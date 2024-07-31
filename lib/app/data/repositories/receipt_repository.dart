import 'package:rodocalc/app/data/models/charge_type_model.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/receipt_model.dart';
import 'package:rodocalc/app/data/providers/receipt_provider.dart';

class ReceiptRepository {
  final ReceiptApiClient apiClient = ReceiptApiClient();

  getAll() async {
    List<Receipt> list = <Receipt>[];

    var response = await apiClient.gettAll();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Receipt.fromJson(e));
      });
    }

    return list;
  }

  getMyChargeTypes() async {
    List<ExpenseCategory> list = <ExpenseCategory>[];

    var response = await apiClient.getMyChargeTypes();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(ExpenseCategory.fromJson(e));
      });
    }

    return list;
  }

  insert(Receipt receipt) async {
    try {
      var response = await apiClient.insert(receipt);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  insertChargeType(ChargeType type) async {
    try {
      var response = await apiClient.insertChargeType(type);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  update(Receipt receipt) async {
    try {
      var response = await apiClient.update(receipt);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  delete(Receipt receipt) async {
    try {
      var response = await apiClient.delete(receipt);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
