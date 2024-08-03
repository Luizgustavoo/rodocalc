import 'package:rodocalc/app/data/models/indication_model.dart';
import 'package:rodocalc/app/data/providers/indication_provider.dart';
import 'package:rodocalc/app/data/providers/vehicle_provider.dart';

class IndicationRepository {
  final IndicationApiClient apiClient = IndicationApiClient();

  getAll() async {
    List<Indication> list = <Indication>[];

    var response = await apiClient.gettAll();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Indication.fromJson(e));
      });
    } else {
      return null;
    }
    return list;
  }

  insert(Indication indicator) async {
    try {
      var response = await apiClient.insert(indicator);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  update(Indication indicator) async {
    try {
      var response = await apiClient.update(indicator);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  delete(Indication indicator) async {
    try {
      var response = await apiClient.delete(indicator);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
