import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/expense_category_controller.dart';

class ExpenseCategoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseCategoryController>(() => ExpenseCategoryController());
  }
}
