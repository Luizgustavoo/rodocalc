import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/perfil_controller.dart';

class PerfilBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PerfilController>(() => PerfilController());
  }
}
