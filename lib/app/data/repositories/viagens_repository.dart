import 'package:rodocalc/app/data/models/expense_trip_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/models/viagens_model.dart';
import 'package:rodocalc/app/data/providers/viagens_provider.dart';

class ViagensRepository {
  final ViagensApiClient apiClient = ViagensApiClient();

  getAll() async {
    List<Viagens> list = <Viagens>[];

    try {
      var response = await apiClient.getAll();

      if (response != null) {
        response['data'].forEach((e) {
          list.add(Viagens.fromJson(e));
        });
      } else {
        return null;
      }
    } catch (e) {
      Exception(e);
    }

    return list;
  }

  insert(Viagens viagem) async {
    try {
      var response = await apiClient.insert(viagem);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  update(Viagens viagem) async {
    try {
      var response = await apiClient.update(viagem);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  delete(Viagens viagem) async {
    try {
      var response = await apiClient.delete(viagem);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  close(Viagens viagem) async {
    try {
      var response = await apiClient.close(viagem);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
