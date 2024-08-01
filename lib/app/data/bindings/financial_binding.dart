import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/transaction_controller.dart';

class TransactionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionController>(() => TransactionController());
  }
}
