import 'package:rodocalc/app/data/models/auth_model.dart';
import 'package:rodocalc/app/data/models/people_model.dart';
import 'package:rodocalc/app/data/models/user_model.dart';
import 'package:rodocalc/app/data/models/user_type_model.dart';
import 'package:rodocalc/app/data/providers/auth_provider.dart';
import 'package:rodocalc/app/utils/error_handler.dart';

class AuthRepository {
  final AuthApiClient apiClient = AuthApiClient();

  Future<Auth?> getLogin(String email, String password) async {
    Map<String, dynamic>? json = await apiClient.getLogin(email, password);

    if (json != null) {
      return Auth.fromJson(json);
    } else {
      return null;
    }
  }

  getUserTypes() async {
    List<UserType> list = <UserType>[];
    try {
      var response = await apiClient.getUserTypes();
      if (response != null) {
        response['data'].forEach((e) {
          list.add(UserType.fromJson(e));
        });
      }
    } catch (e) {
      Exception(e);
    }

    return list;
  }

  Future<void> getLogout() async {
    try {
      await apiClient.getLogout();
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }

  insertUser(People people, User user) async {
    try {
      var response = await apiClient.insertUser(people, user);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
