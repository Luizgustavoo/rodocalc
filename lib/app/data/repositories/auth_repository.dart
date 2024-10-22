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

  forgotPassword(String username) async {
    var response = await apiClient.forgotPassword(username);
    return response;
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

  Future<People> getIndicador(String id) async {
    People people = People();
    try {
      var response = await apiClient.getIndicador(id);

      if (response != null && response['data'] != null) {
        if (response['data'] is List && response['data'].isNotEmpty) {
          // Acessa o primeiro item da lista e converte para People
          people = People.fromJson(response['data'][0]);
        }
      }
    } catch (e) {
      print('Erro: $e');
      throw Exception(e);
    }

    return people; // Retorna o objeto People preenchido ou vazio se não houver dados
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
