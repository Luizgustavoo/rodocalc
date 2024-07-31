import 'package:rodocalc/app/data/models/financial_model.dart';
import 'package:rodocalc/app/data/providers/financial_provider.dart';

class FinancialRepository {
  final FinancialApiClient apiClient = FinancialApiClient();

  getAll() async {
    List<Financial> list = <Financial>[];
    var response = await apiClient.getAll();
    if (response != null) {
      response['data'].forEach((e) {
        list.add(Financial.fromJson(e));
      });
    }
    return list;
  }
}
