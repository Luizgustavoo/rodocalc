import 'package:get/get.dart';

class HomeController extends GetxController {
  var userName = 'João Silva'.obs;
  var truckInfo = 'Scania Bitrem FCF-0827'.obs;
  var truckBalance = 10307.00.obs;
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
