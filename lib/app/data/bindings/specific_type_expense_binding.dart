import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/specific_type_expense_controller.dart';

class SpecificTypeExpenseBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpecificTypeExpenseController>(
        () => SpecificTypeExpenseController());
  }
}
