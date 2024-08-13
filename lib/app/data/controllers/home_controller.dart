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
  void inInit() async {
    super.onInit();
    await getLast();
  }

  Future<void> getLast() async {
    isLoadingLast.value = true;
    try {
      listLastTransactions.value = await repositoryTransaction.getLast();
      //filteredTransactions.value = listTransactions;
    } catch (e) {
      Exception(e);
    }
    isLoadingLast.value = false;
  }

  var recentTransactions = <Map<String, dynamic>>[
    {
      'title': 'MANUTENÇÃO PREV.',
      'description': 'Filtro de ar Oficina DieselPar',
      'amount': -530.00,
      'date': '10/06/2024',
    },
    {
      'title': 'ALIMENTAÇÃO.',
      'description': 'Almoço posto Mendes',
      'amount': -45.00,
      'date': '07/06/2024',
    },
    {
      'title': 'FRETE - MARINGÁ/BAHIA',
      'description': 'Entrega de farelo',
      'amount': 8600.00,
      'date': '08/06/2024',
    },
    {
      'title': 'MANUTENÇÃO PREV.',
      'description': 'Limpador de para-brisas',
      'amount': -120.00,
      'date': '05/06/2024',
    },
    {
      'title': 'FRETE - BAHIA/ASSIS',
      'description': 'Retorno com grãos',
      'amount': 12000.00,
      'date': '06/06/2024',
    },
    {
      'title': 'SEGURO',
      'description': 'Mensalidade',
      'amount': -780.00,
      'date': '02/06/2024',
    },
  ].obs;
}
