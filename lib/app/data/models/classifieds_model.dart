import 'package:rodocalc/app/data/models/classified_photos_model.dart';
import 'package:rodocalc/app/data/models/user_model.dart';

class Classifieds {
  int? id;
  String? descricao;
  String? observacoes;
  double? valor;
  int? status;
  int? userId;
  String? createdAt;
  String? updatedAt;
  List<ClassifiedsPhotos>? fotosclassificados;
  User? user;

  Classifieds({
    this.id,
    this.descricao,
    this.observacoes,
    this.valor,
    this.status,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.fotosclassificados,
    this.user,
  });

  Classifieds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    observacoes = json['observacoes'];
    valor = json['valor']?.toDouble();
    status = json['status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['fotosclassificados'] != null) {
      fotosclassificados = <ClassifiedsPhotos>[];
      json['fotosclassificados'].forEach((v) {
        fotosclassificados!.add(ClassifiedsPhotos.fromJson(v));
      });
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['observacoes'] = observacoes;
    data['valor'] = valor;
    data['status'] = status;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (fotosclassificados != null) {
      data['fotosclassificados'] =
          fotosclassificados!.map((v) => v.toJson()).toList();
    }

    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
