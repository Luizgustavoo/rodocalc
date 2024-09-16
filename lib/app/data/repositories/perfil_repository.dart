import 'package:rodocalc/app/data/models/people_model.dart';
import 'package:rodocalc/app/data/models/user_model.dart';
import 'package:rodocalc/app/data/providers/auth_provider.dart';

class PerfilRepository {
  final AuthApiClient apiClient = AuthApiClient();

  updateUser(People people, User user) async {
    try {
      var response = await apiClient.updateUser(people, user);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  deleteUser() async {
    try {
      var response = await apiClient.deleteUser();

      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
