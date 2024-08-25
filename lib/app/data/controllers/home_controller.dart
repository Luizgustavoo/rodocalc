import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/repositories/plan_repository.dart';
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
  final repositoryPlan = Get.put(PlanRepository());

  RxBool isLoadingLast = true.obs;
  RxBool isLoadingDias = true.obs;

  RxInt diasRestantes = 0.obs;
  RxString dataVencimento = "".obs;

  @override
  void onInit() async {
    await getLast();
    await getExistsPlanActive();
    super.onInit();
  }

  getExistsPlanActive() async {
    isLoadingDias.value = true;
    try {
      var response = await repositoryPlan.getExistsPlanActive();
      diasRestantes.value = response["dias_restantes"];
      dataVencimento.value = response["data_vencimento"];
      update();
    } catch (e) {
      Exception(e);
    }
    isLoadingDias.value = false;
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
