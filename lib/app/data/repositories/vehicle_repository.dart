import 'package:rodocalc/app/data/models/abastecimentos_model.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';
import 'package:rodocalc/app/data/providers/vehicle_provider.dart';

import '../models/user_plan_dropdown.dart';

class VehicleRepository {
  final VehicleApiClient apiClient = VehicleApiClient();

  getAllUserPlans() async {
    List<UserPlanDropdown> list = <UserPlanDropdown>[];

    var response = await apiClient.getAllUserPlans();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(UserPlanDropdown.fromJson(e));
      });
    } else {
      return null;
    }
    return list;
  }

  getAll() async {
    List<Vehicle> list = <Vehicle>[];

    var response = await apiClient.gettAll();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Vehicle.fromJson(e));
      });
    } else {
      return null;
    }
    return list;
  }

  getAbastecimentos() async {
    List<Abastecimento> list = <Abastecimento>[];

    try {
      var response = await apiClient.getAbastecimentos();

      if (response != null) {
        // Adicionando os valores de média e soma na resposta
        // Garantindo que os valores sejam do tipo double
        double mediaConsumoTotal =
            (response['data']['media_consumo_total'] ?? 0.0).toDouble();
        double somaKmPercorridos =
            (response['data']['soma_km_percorridos'] ?? 0.0).toDouble();

        response['data']['abastecimentos'].forEach((e) {
          list.add(Abastecimento.fromMap({
            ...e,
            'media_consumo_total': mediaConsumoTotal,
            'soma_km_percorridos': somaKmPercorridos,
          }));
        });
        return list;
      }
    } catch (e) {
      print(e);
      return null;
    }

    return null;
  }

  getQuantityLicences() async {
    var response = await apiClient.getQuantityLicences();
    return response['data'];
  }

  getAllDropDown() async {
    List<Vehicle> list = <Vehicle>[];

    var response = await apiClient.getAllDropDown();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Vehicle.fromJson(e));
      });
    } else {
      return null;
    }
    return list;
  }

  insert(Vehicle vehicle) async {
    try {
      var response = await apiClient.insert(vehicle);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  update(Vehicle vehicle) async {
    try {
      var response = await apiClient.update(vehicle);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  delete(Vehicle vehicle) async {
    try {
      var response = await apiClient.delete(vehicle);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  searchPlate(String plate) async {
    try {
      var response = await apiClient.searchPlate(plate);
      if (response["data"] != null) {
        return response["data"];
      }
    } catch (e) {
      Exception(e);
    }

    return null;
  }
}
