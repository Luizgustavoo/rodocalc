import 'package:rodocalc/app/data/models/classified_photos_model.dart';
import 'package:rodocalc/app/data/models/user_model.dart';

class Classifieds {
  int? id;
  String? descricao;
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
    valor = json['valor'] != null ? json['valor'].toDouble() : null;
    status = json['status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['fotosclassificados'] != null) {
      fotosclassificados = <ClassifiedsPhotos>[];
      json['fotosclassificados'].forEach((v) {
        fotosclassificados!.add(new ClassifiedsPhotos.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['valor'] = this.valor;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.fotosclassificados != null) {
      data['fotosclassificados'] =
          this.fotosclassificados!.map((v) => v.toJson()).toList();
    }

    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
