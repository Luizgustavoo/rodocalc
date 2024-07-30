import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/expense_model.dart';
import 'package:rodocalc/app/data/models/specific_type_expense_model.dart';
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

  insert(Expense expense) async {
    try {
      var response = await apiClient.insert(expense);
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
