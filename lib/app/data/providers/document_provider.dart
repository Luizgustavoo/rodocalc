import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/document_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class DocumentApiClient {
  final http.Client httpClient = http.Client();

  gettAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri documentUrl;
      String url =
          '$baseUrl/v1/documento/${ServiceStorage.getUserId().toString()}';
      documentUrl = Uri.parse(url);
      var response = await httpClient.get(
        documentUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      print(json.decode(response.body));
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      Exception(e);
    }
    return null;
  }

  gettAllDocumentType() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri documentUrl;
      String url = '$baseUrl/v1/tipodocumento';
      documentUrl = Uri.parse(url);
      var response = await httpClient.get(
        documentUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      print(json.decode(response.body));
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      Exception(e);
    }
    return null;
  }

  insert(DocumentModel document) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var documentUrl = Uri.parse('$baseUrl/v1/documento');

      var request = http.MultipartRequest('POST', documentUrl);

      if (document.arquivo!.isNotEmpty) {
        String fileExtension = path.extension(document.arquivo!).toLowerCase();

        if (fileExtension == '.pdf') {
          request.files.add(await http.MultipartFile.fromPath(
              'arquivo', document.arquivo!,
              contentType: MediaType('application', 'pdf')));
        } else if (fileExtension == '.jpg' ||
            fileExtension == '.jpeg' ||
            fileExtension == '.png') {
          request.files.add(
              await http.MultipartFile.fromPath('arquivo', document.arquivo!));
        }
      }
      request.fields.addAll({
        "descricao": document.descricao.toString(),
        "tipodocumento_id": document.tipoDocumentoId.toString(),
        "pessoa_id": ServiceStorage.getUserId().toString(),
        "status": "1"
      });

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
      });

      var response = await request.send();

      var responseStream = await response.stream.bytesToString();
      var httpResponse = http.Response(responseStream, response.statusCode);

      if (httpResponse.statusCode == 201 ||
          httpResponse.statusCode == 422 ||
          httpResponse.statusCode == 404) {
        return json.decode(httpResponse.body);
      } else {
        return null;
      }
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  update(DocumentModel document) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var documentUrl = Uri.parse('$baseUrl/v1/documento/${document.id}');

      var request = http.MultipartRequest('PUT', documentUrl);

      if (document.arquivo!.isNotEmpty) {
        String fileExtension = path.extension(document.arquivo!).toLowerCase();

        if (fileExtension == '.pdf') {
          request.files.add(await http.MultipartFile.fromPath(
              'arquivo', document.arquivo!,
              contentType: MediaType('application', 'pdf')));
        } else if (fileExtension == '.jpg' ||
            fileExtension == '.jpeg' ||
            fileExtension == '.png') {
          request.files.add(
              await http.MultipartFile.fromPath('arquivo', document.arquivo!));
        }
      }

      request.fields.addAll({
        "descricao": document.descricao.toString(),
        "tipodocumento_id": document.tipoDocumentoId.toString(),
        "pessoa_id": ServiceStorage.getUserId().toString(),
        "status": "1"
      });

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
      });

      var response = await request.send();

      var responseStream = await response.stream.bytesToString();
      var httpResponse = http.Response(responseStream, response.statusCode);

      return json.decode(httpResponse.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  delete(DocumentModel document) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var documentUrl = Uri.parse('$baseUrl/v1/documento/${document.id}');

      var response = await httpClient.delete(
        documentUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );

      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }
}
