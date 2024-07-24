import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/document_controller.dart';

class DocumentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentController>(() => DocumentController());
  }
}
