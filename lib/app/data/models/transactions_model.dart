import 'package:rodocalc/app/data/models/charge_type_model.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/specific_type_expense_model.dart';
import 'package:rodocalc/app/data/models/transaction_photos_model.dart';

class Transacoes {
  int? id;
  String? descricao;
  String? data;
  int? categoriaDespesaId;
  int? tipoEspecificoDespesaId;
  double? valor;
  String? empresa;
  String? cidade;
  String? uf;
  String? ddd;
  String? telefone;
  int? status;
  int? pessoaId;
  int? veiculoId;
  String? origem;
  String? destino;
  double? quantidadeTonelada;
  int? tipoCargaId;
  String? tipoTransacao; // 'entrada' ou 'saida'
  String? createdAt;
  String? updatedAt;
  ExpenseCategory? expenseCategory;
  SpecificTypeExpense? specificTypeExpense;
  ChargeType? chargeType;
  List<TransactionsPhotos>? photos;

  Transacoes({
    this.id,
    this.descricao,
    this.data,
    this.categoriaDespesaId,
    this.tipoEspecificoDespesaId,
    this.valor,
    this.empresa,
    this.cidade,
    this.uf,
    this.ddd,
    this.telefone,
    this.status,
    this.pessoaId,
    this.veiculoId,
    this.origem,
    this.destino,
    this.quantidadeTonelada,
    this.tipoCargaId,
    this.tipoTransacao,
    this.createdAt,
    this.updatedAt,
    this.expenseCategory,
    this.specificTypeExpense,
    this.chargeType,
    this.photos,
  });

  Transacoes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    data = json['data'];
    categoriaDespesaId = json['categoriadespesa_id'];
    tipoEspecificoDespesaId = json['tipoespecificodespesa_id'];
    valor = json['valor'];
    empresa = json['empresa'];
    cidade = json['cidade'];
    uf = json['uf'];
    ddd = json['ddd'];
    telefone = json['telefone'];
    status = json['status'];
    pessoaId = json['pessoa_id'];
    veiculoId = json['veiculo_id'];
    origem = json['origem'];
    destino = json['destino'];
    quantidadeTonelada = json['quantidade_tonelada'];
    tipoCargaId = json['tipocarga_id'];
    tipoTransacao = json['tipo_transacao'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    chargeType = json['tipocarga'] != null
        ? ChargeType.fromJson(json['tipocarga'])
        : null;
    expenseCategory = json['categoriadespesa'] != null
        ? ExpenseCategory.fromJson(json['categoriadespesa'])
        : null;
    specificTypeExpense = json['tipoespecificodespesa'] != null
        ? SpecificTypeExpense.fromJson(json['tipoespecificodespesa'])
        : null;

    if (json['fotos'] != null) {
      photos = <TransactionsPhotos>[];
      json['fotos'].forEach((v) {
        photos!.add(TransactionsPhotos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['data'] = data;
    data['categoriadespesa_id'] = categoriaDespesaId;
    data['tipoespecificodespesa_id'] = tipoEspecificoDespesaId;
    data['valor'] = valor;
    data['empresa'] = empresa;
    data['cidade'] = cidade;
    data['uf'] = uf;
    data['ddd'] = ddd;
    data['telefone'] = telefone;
    data['status'] = status;
    data['pessoa_id'] = pessoaId;
    data['veiculo_id'] = veiculoId;
    data['origem'] = origem;
    data['destino'] = destino;
    data['quantidade_tonelada'] = quantidadeTonelada;
    data['tipocarga_id'] = tipoCargaId;
    data['tipo_transacao'] = tipoTransacao;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    if (photos != null) {
      data['fotos'] = photos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
