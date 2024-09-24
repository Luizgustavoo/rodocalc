import 'package:rodocalc/app/data/providers/comission_provider.dart';

import '../models/comission_indicator_model.dart';

class ComissionRepository {
  final ComissionApiClient apiClient = ComissionApiClient();

  getAllToReceive() async {
    List<ComissionIndicator> list = <ComissionIndicator>[];

    var response = await apiClient.getAllToReceive();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(ComissionIndicator.fromJson(e));
      });
    } else {
      return null;
    }
    return list;
  }

  getExistsPedidoSaque() async {
    // List<ComissionIndicator> list = <ComissionIndicator>[];

    var response = await apiClient.getExistsPedidoSaque();

    return response['data']['total_saque_requests'];
  }

  solicitarSaque(String chavePix, String descricao) async {
    try {
      var response = await apiClient.solicitarSaque(chavePix, descricao);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
