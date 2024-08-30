import 'package:rodocalc/app/data/models/people_model.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';

class User {
  int? id;
  String? name;
  String? email;
  String? password;
  Null emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? dataInicio;

  String? cupomParaIndicar;
  String? cupomRecebido;

  int? status;
  int? userTypeId;
  String? contato;
  People? people;

  List<Vehicle>? vehicles;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.dataInicio,
    this.status,
    this.contato,
    this.people,
    this.cupomParaIndicar,
    this.cupomRecebido,
    this.userTypeId,
    this.vehicles,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    dataInicio = json['data_inicio'];
    cupomParaIndicar = json['cupom_para_indicar'];
    cupomRecebido = json['cupom_recebido'];
    status =
        json['status'] != null ? int.tryParse(json['status'].toString()) : null;
    userTypeId = json['usertype_id'] != null
        ? int.tryParse(json['usertype_id'].toString())
        : null;
    contato = json['contato'];
    people = json['pessoa'] != null ? People.fromJson(json['pessoa']) : null;

    if (json['veiculoschefe'] != null) {
      vehicles = <Vehicle>[];
      json['veiculoschefe'].forEach((v) {
        vehicles!.add(Vehicle.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['data_inicio'] = dataInicio;
    data['status'] = status;
    data['usertype_id'] = userTypeId;
    data['contato'] = contato;
    data['cupom_para_indicar'] = cupomParaIndicar;
    data['cupom_recebido'] = cupomRecebido;
    if (people != null) {
      data['pessoa'] = people!.toJson();
    }
    if (vehicles != null) {
      data['veiculoschefe'] = vehicles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
