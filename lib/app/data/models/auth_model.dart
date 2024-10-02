import 'package:rodocalc/app/data/models/people_model.dart';
import 'package:rodocalc/app/data/models/rota_model.dart';
import 'package:rodocalc/app/data/models/user_model.dart';

class Auth {
  User? user;
  People? people;
  String? accessToken;
  String? tokenType;
  String? expiresIn;
  List<Rota>? rotas;

  Auth({
    this.user,
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.people,
    this.rotas,
  });

  Auth.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    people = json['pessoa'] != null ? People.fromJson(json['pessoa']) : null;
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'].toString();
    if (json['rotas'] != null) {
      rotas = [];
      json['rotas'].forEach((v) {
        rotas!.add(Rota.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (people != null) {
      data['pessoa'] = people!.toJson();
    }
    data['access_token'] = accessToken;
    data['token_type'] = tokenType as String;
    data['expires_in'] = expiresIn as String;
    // Convertendo as rotas para JSON se existirem
    if (rotas != null) {
      data['rotas'] = rotas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
