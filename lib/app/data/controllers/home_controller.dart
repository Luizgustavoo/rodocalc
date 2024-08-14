import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/repositories/transaction_repository.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class HomeController extends GetxController {
  var userPhoto = ServiceStorage.getUserPhoto().obs;
  var nomeUser = ServiceStorage.getUserName().obs;
  var userName = 'João Silva'.obs;
  var truckInfo = 'Scania Bitrem FCF-0827'.obs;
  var truckBalance = 10307.00.obs;

  void updateUserPhoto() {
    userPhoto.value = ServiceStorage.getUserPhoto();
    nomeUser.value = ServiceStorage.getUserName();
  }

  RxList<Transacoes> listLastTransactions = RxList<Transacoes>([]);

  final repositoryTransaction = Get.put(TransactionRepository());

  RxBool isLoadingLast = true.obs;

  @override
  void onInit() {
    getLast();
    super.onInit();
  }

  getLast() async {
    isLoadingLast.value = true;
    try {
      listLastTransactions.value = await repositoryTransaction.getLast();
    } catch (e) {
      Exception(e);
    }
    isLoadingLast.value = false;
  }
}
