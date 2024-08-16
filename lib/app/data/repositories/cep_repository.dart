import 'package:rodocalc/app/data/models/address_model.dart';
import 'package:rodocalc/app/data/providers/cep_provider.dart';

class CepRepository {
  final CepApiClient _cepProvider = CepApiClient();

  Future<Address?> getAddressByCep(String cep) async {
    try {
      final data = await _cepProvider.fetchAddressByCep(cep);
      return Address.fromJson(data);
    } catch (e) {
      // Handle error
      return null;
    }
  }
}
