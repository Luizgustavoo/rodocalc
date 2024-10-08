import 'package:rodocalc/app/data/models/freight_model.dart';
import 'package:rodocalc/app/data/providers/freight_provider.dart';

class FreightRepository {
  final FreightApiClient apiClient = FreightApiClient();

  getAll() async {
    List<Freight> list = <Freight>[];

    try {
      var response = await apiClient.gettAll();

      if (response != null) {
        response['data'].forEach((e) {
          list.add(Freight.fromJson(e));
        });
      } else {
        return null;
      }
    } catch (e) {
      Exception(e);
    }

    return list;
  }

  getTripData(
      String origem, String ufOrigem, String destino, String ufDestino) async {
    var response =
        await apiClient.getTripData(origem, ufOrigem, destino, ufDestino);
    return response['rotas'];
  }

  insert(Freight freight) async {
    try {
      var response = await apiClient.insert(freight);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  update(Freight freight) async {
    try {
      var response = await apiClient.update(freight);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  delete(Freight freight) async {
    try {
      var response = await apiClient.delete(freight);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
