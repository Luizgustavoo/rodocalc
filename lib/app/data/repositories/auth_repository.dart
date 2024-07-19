import 'package:rodocalc/app/data/models/auth_model.dart';
import 'package:rodocalc/app/data/providers/auth_provider.dart';

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
}
