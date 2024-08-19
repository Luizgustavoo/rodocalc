import 'package:rodocalc/app/data/models/plan_model.dart';

class UserPlan {
  int? id;
  int? usuarioId;
  int? planoId;
  String? dataAssinaturaPlano;
  String? dataVencimentoPlano;
  String? assignatureId;
  int? quantidadeLicencas;
  Plan? plano;

  UserPlan(
      {this.id,
      this.usuarioId,
      this.planoId,
      this.dataAssinaturaPlano,
      this.dataVencimentoPlano,
      this.quantidadeLicencas,
      this.assignatureId,
      this.plano});

  UserPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usuarioId = json['usuario_id'];
    planoId = json['plano_id'];
    dataAssinaturaPlano = json['data_assinatura_plano'];
    dataVencimentoPlano = json['data_vencimento_plano'];
    quantidadeLicencas = json['quantidade_licencas'];
    assignatureId = json['assignature_id'];
    plano = json['plano'] != null ? new Plan.fromJson(json['plano']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['usuario_id'] = this.usuarioId;
    data['plano_id'] = this.planoId;
    data['data_assinatura_plano'] = this.dataAssinaturaPlano;
    data['data_vencimento_plano'] = this.dataVencimentoPlano;
    data['quantidade_licencas'] = this.quantidadeLicencas;
    data['assignature_id'] = this.assignatureId;
    if (this.plano != null) {
      data['plano'] = this.plano!.toJson();
    }
    return data;
  }
}
