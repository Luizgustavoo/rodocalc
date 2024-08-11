import 'package:rodocalc/app/data/models/document_model.dart';
import 'package:rodocalc/app/data/models/document_type_model.dart';
import 'package:rodocalc/app/data/providers/document_provider.dart';

class DocumentRepository {
  final DocumentApiClient apiClient = DocumentApiClient();

  getAll() async {
    List<DocumentModel> list = <DocumentModel>[];

    var response = await apiClient.gettAll();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(DocumentModel.fromJson(e));
      });
    } else {
      return null;
    }
    return list;
  }

  getAllDocumentType() async {
    List<DocumentType> list = <DocumentType>[];

    var response = await apiClient.gettAllDocumentType();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(DocumentType.fromJson(e));
      });
    } else {
      return null;
    }
    return list;
  }

  insert(DocumentModel document) async {
    try {
      var response = await apiClient.insert(document);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  update(DocumentModel document) async {
    try {
      var response = await apiClient.update(document);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  delete(DocumentModel document) async {
    try {
      var response = await apiClient.delete(document);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
