import 'package:rodocalc/app/data/models/comission_indicator_model.dart';
import 'package:rodocalc/app/data/models/people_model.dart';
import 'package:rodocalc/app/data/models/user_plan_model.dart';
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
  String? tokenFirebase;

  String? cupomParaIndicar;
  String? cupomRecebido;

  int? status;
  int? userTypeId;
  String? contato;
  People? people;
  List<UserPlan>? planos;

  List<Vehicle>? vehicles;

  List<ComissionIndicator>? comissoesIndicador;

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
    this.comissoesIndicador,
    this.planos,
    this.tokenFirebase,
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
    tokenFirebase = json['token_firebase'];
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

    if (json['comissoes_indicador'] != null) {
      comissoesIndicador = <ComissionIndicator>[];
      json['comissoes_indicador'].forEach((v) {
        comissoesIndicador!.add(ComissionIndicator.fromJson(v));
      });
    }

    if (json['planos'] != null) {
      planos = [];
      json['planos'].forEach((v) {
        planos!.add(UserPlan.fromJson(v));
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
    data['token_firebase'] = tokenFirebase;
    if (people != null) {
      data['pessoa'] = people!.toJson();
    }
    if (vehicles != null) {
      data['veiculoschefe'] = vehicles!.map((v) => v.toJson()).toList();
    }

    if (comissoesIndicador != null) {
      data['comissoes_indicador'] =
          comissoesIndicador!.map((v) => v.toJson()).toList();
    }
    if (planos != null) {
      data['planos'] = planos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
