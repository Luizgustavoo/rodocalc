import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/financial_controller.dart';

class FinancialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinancialController>(() => FinancialController());
  }
}
