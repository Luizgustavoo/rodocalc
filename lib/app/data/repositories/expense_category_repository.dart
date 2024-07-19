import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/providers/expense_category_provider.dart';

class ExpenseCategoryRepository {
  final ExpenseCategoryApiClient apiClient = ExpenseCategoryApiClient();

  getAll() async {
    List<ExpenseCategory> list = <ExpenseCategory>[];

    var response = await apiClient.gettAll();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(ExpenseCategory.fromJson(e));
      });
    }

    return list;
  }

  insert(ExpenseCategory expenseCategory) async {
    try {
      var response = await apiClient.insert(expenseCategory);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  update(ExpenseCategory expenseCategory) async {
    try {
      var response = await apiClient.update(expenseCategory);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  delete(ExpenseCategory expenseCategory) async {
    try {
      var response = await apiClient.delete(expenseCategory);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
