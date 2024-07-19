import 'package:rodocalc/app/data/models/specific_type_expense_model.dart';
import 'package:rodocalc/app/data/providers/specific_type_expense_provider.dart';

class SpecificTypeExpenseRepository {
  final SpecificTypeExpenseApiClient apiClient = SpecificTypeExpenseApiClient();

  getAll() async {
    List<SpecificTypeExpense> list = <SpecificTypeExpense>[];

    var response = await apiClient.gettAll();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(SpecificTypeExpense.fromJson(e));
      });
    }

    return list;
  }

  insert(SpecificTypeExpense specificTypeExpense) async {
    try {
      var response = await apiClient.insert(specificTypeExpense);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  update(SpecificTypeExpense specificTypeExpense) async {
    try {
      var response = await apiClient.update(specificTypeExpense);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  delete(SpecificTypeExpense specificTypeExpense) async {
    try {
      var response = await apiClient.delete(specificTypeExpense);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
