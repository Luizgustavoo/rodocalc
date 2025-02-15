import 'package:rodocalc/app/data/models/indication_model.dart';
import 'package:rodocalc/app/data/models/indicators_details.dart';
import 'package:rodocalc/app/data/providers/indication_provider.dart';

import '../models/user_model.dart';

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

  getMyIndications() async {
    List<User> list = <User>[];

    var response = await apiClient.getMyIndications();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(User.fromJson(e));
      });
    } else {
      return null;
    }
    return list;
  }

  getMyIndicationsDetails() async {
    List<IndicacoesComDetalhes> list = <IndicacoesComDetalhes>[];

    var response = await apiClient.getMyIndicationsDetails();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(IndicacoesComDetalhes.fromJson(e));
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
