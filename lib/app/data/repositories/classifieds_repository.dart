import 'package:rodocalc/app/data/models/classifieds_model.dart';
import 'package:rodocalc/app/data/providers/classifieds_provider.dart';

class ClassifiedsRepository {
  final ClassifiedsApiClient apiClient = ClassifiedsApiClient();

  getAll() async {
    List<Classifieds> list = <Classifieds>[];

    var response = await apiClient.getAll();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Classifieds.fromJson(e));
      });
    }

    return list;
  }

  insert(Classifieds classificados) async {
    try {
      var response = await apiClient.insert(classificados);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  update(Classifieds classificados, List<String> photosRemove) async {
    try {
      var response = await apiClient.update(classificados, photosRemove);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  delete(Classifieds classificados) async {
    try {
      var response = await apiClient.delete(classificados);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
