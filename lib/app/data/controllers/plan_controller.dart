import 'package:get/get.dart';

class PlanController extends GetxController {
  var currentPlan = 'PLANO MENSAL'.obs;
  var licenses = 10.obs;

  List<Map<String, dynamic>> plans = [
    {
      'name': 'PLANO MENSAL',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque auctor, nibh vitae vehicula pretium, odio ligula varius urna, id tristique purus lacus ac ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'price': 'R\$ 59,90',
    },
    {
      'name': 'PLANO TRIMESTRAL',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque auctor, nibh vitae vehicula pretium, odio ligula varius urna, id tristique purus lacus ac ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'price': 'R\$ 59,90',
    },
    {
      'name': 'PLANO SEMESTRAL',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque auctor, nibh vitae vehicula pretium, odio ligula varius urna, id tristique purus lacus ac ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'price': 'R\$ 59,90',
    },
  ];
}
