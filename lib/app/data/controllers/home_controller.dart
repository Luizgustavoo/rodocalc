import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:rodocalc/app/data/models/abastecimentos_model.dart';
import 'package:rodocalc/app/data/models/last_expense_trip_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/repositories/plan_repository.dart';
import 'package:rodocalc/app/data/repositories/transaction_repository.dart';
import 'package:rodocalc/app/data/repositories/vehicle_repository.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class HomeController extends GetxController {
  var userPhoto = ServiceStorage.getUserPhoto().obs;
  var nomeUser = ServiceStorage.getUserName().obs;
  var userName = 'João Silva'.obs;
  var truckInfo = 'Scania Bitrem FCF-0827'.obs;
  var truckBalance = 10307.00.obs;

  var isLoading = true.obs;

  void updateUserPhoto() {
    userPhoto.value = ServiceStorage.getUserPhoto();
    nomeUser.value = ServiceStorage.getUserName();
  }

  RxList<Transacoes> listLastTransactions = RxList<Transacoes>([]);
  RxList<Abastecimento> listAbastecimentos = RxList<Abastecimento>([]);
  RxList<LastExpenseTrip> listLastExpenseTrip = RxList<LastExpenseTrip>([]);

  final repositoryTransaction = Get.put(TransactionRepository());
  final repositoryVehicle = Get.put(VehicleRepository());
  final repositoryPlan = Get.put(PlanRepository());

  RxBool isLoadingAbastecimentos = false.obs;
  RxBool isLoadingLast = true.obs;
  RxBool isLoadingDias = true.obs;

  RxDouble mediaConsumo = 0.0.obs;
  RxDouble totalKmPercorrido = 0.0.obs;

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
    isLoading.value = false;
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

  getAbastecimentos() async {
    isLoadingAbastecimentos.value = true;
    try {
      listAbastecimentos.value = await repositoryVehicle.getAbastecimentos();
      // Aqui você pode acessar a mediaConsumoTotal e somaKmPercorridos
      mediaConsumo.value = listAbastecimentos.isNotEmpty
          ? listAbastecimentos[0].mediaConsumoTotal
          : 0.0;
      totalKmPercorrido.value = listAbastecimentos.isNotEmpty
          ? listAbastecimentos[0].somaKmPercorridos
          : 0.0;
    } catch (e) {
      Exception(e);
    }
    isLoadingAbastecimentos.value = false;
  }

  getLastExpenseTrip() async {
    isLoadingLast.value = true;
    try {
      listLastExpenseTrip.value =
          await repositoryTransaction.getLastExpenseTrip();
    } catch (e) {
      Exception(e);
    }
    isLoadingLast.value = false;
  }
}
