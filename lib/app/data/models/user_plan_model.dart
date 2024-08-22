import 'package:rodocalc/app/data/models/plan_model.dart';

class UserPlan {
  int? id;
  int? usuarioId;
  int? planoId;
  int? valorPlano;
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
      this.valorPlano,
      this.plano});

  UserPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usuarioId = json['usuario_id'];
    planoId = json['plano_id'];
    dataAssinaturaPlano = json['data_assinatura_plano'];
    dataVencimentoPlano = json['data_vencimento_plano'];
    quantidadeLicencas = json['quantidade_licencas'];
    assignatureId = json['assignature_id'];
    valorPlano = json['valor_plano'];
    plano = json['plano'] != null ? Plan.fromJson(json['plano']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['usuario_id'] = usuarioId;
    data['plano_id'] = planoId;
    data['data_assinatura_plano'] = dataAssinaturaPlano;
    data['data_vencimento_plano'] = dataVencimentoPlano;
    data['quantidade_licencas'] = quantidadeLicencas;
    data['assignature_id'] = assignatureId;
    data['valor_plano'] = valorPlano;
    if (plano != null) {
      data['plano'] = plano!.toJson();
    }
    return data;
  }
}
