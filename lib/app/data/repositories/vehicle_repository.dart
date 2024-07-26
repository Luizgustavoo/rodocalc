import 'package:rodocalc/app/data/models/search_plate.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';
import 'package:rodocalc/app/data/providers/vehicle_provider.dart';

class VehicleRepository {
  final VehicleApiClient apiClient = VehicleApiClient();

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
      if (response != null) {
        return SearchPlate.fromJson(response['Veiculo']);
      }
    } catch (e) {
      Exception(e);
    }

    return null;
  }
}
