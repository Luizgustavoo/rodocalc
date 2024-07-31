import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/expense_controller.dart';
import 'package:rodocalc/app/data/controllers/financial_controller.dart';
import 'package:rodocalc/app/data/controllers/receipt_controller.dart';

class FinancialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinancialController>(() => FinancialController());
    Get.lazyPut<ExpenseController>(() => ExpenseController());
    Get.lazyPut<ReceiptController>(() => ReceiptController());
  }
}
