import 'dart:io';

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
    }

    return list;
  }

  insert(Vehicle vehicle, File imageFile) async {
    try {
      var response = await apiClient.insert(vehicle, imageFile);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  update(Vehicle vehicle, File imageFile) async {
    try {
      var response = await apiClient.update(vehicle, imageFile);
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
}
