import 'package:rodocalc/app/data/models/expense_model.dart';
import 'package:rodocalc/app/data/providers/expense_provider.dart';

class ExpenseRepository {
  final ExpenseApiClient apiClient = ExpenseApiClient();

  getAll() async {
    List<Expense> list = <Expense>[];

    var response = await apiClient.gettAll();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Expense.fromJson(e));
      });
    }

    return list;
  }

  insert(Expense expense) async {
    try {
      var response = await apiClient.insert(expense);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  update(Expense expense) async {
    try {
      var response = await apiClient.update(expense);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  delete(Expense expense) async {
    try {
      var response = await apiClient.delete(expense);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
