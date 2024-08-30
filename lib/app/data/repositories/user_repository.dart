import 'package:rodocalc/app/data/models/people_model.dart';
import 'package:rodocalc/app/data/models/user_model.dart';
import 'package:rodocalc/app/data/providers/user_provider.dart';

class UserRepository {
  final UserApiClient apiClient = UserApiClient();

  insertUser(People people, User user, int vehicleId) async {
    try {
      var response = await apiClient.insertUser(people, user, vehicleId);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
