import 'package:rodocalc/app/data/models/people_model.dart';
import 'package:rodocalc/app/data/models/user_model.dart';
import 'package:rodocalc/app/data/providers/user_provider.dart';

class UserRepository {
  final UserApiClient apiClient = UserApiClient();

  getMyEmployees() async {
    List<User> list = <User>[];

    var response = await apiClient.getMyEmployees();
    if (response != null) {
      response['data'].forEach((e) {
        list.add(User.fromJson(e));
      });
    }

    return list;
  }

  insertUser(People people, User user, int vehicleId) async {
    try {
      var response = await apiClient.insertUser(people, user, vehicleId);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  updateUser(People people, User user, int vehicleId) async {
    try {
      var response = await apiClient.updateUser(people, user, vehicleId);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  getQuantityLicences() async {
    var response = await apiClient.getQuantityLicences();
    return response['data'];
  }

  delete(User user) async {
    try {
      var response = await apiClient.delete(user);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
