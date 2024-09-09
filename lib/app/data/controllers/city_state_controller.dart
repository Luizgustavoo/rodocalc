import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/city_state_model.dart';
import 'package:rodocalc/app/data/repositories/city_state_repository.dart';

class CityStateController extends GetxController {
  final repository = Get.put(CityStateRepository());

  RxList<CityState> listCities = RxList<CityState>([]);
  RxBool isLoading = true.obs;

  Future<void> getCities() async {
    isLoading.value = true;
    try {
      listCities.value = await repository.getCities();
    } catch (e) {
      listCities.clear();
      Exception(e);
    }
    isLoading.value = false;
  }
}
