import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/expense_photos_model.dart';
import 'package:rodocalc/app/data/models/specific_type_expense_model.dart';

class Expense {
  int? id;
  String? descricao;
  int? categoriadespesaId;
  int? tipoespecificodespesaId;
  double? valor;
  String? empresa;
  String? cidade;
  String? uf;
  String? ddd;
  String? telefone;
  String? observacoes;
  int? status;
  int? pessoaId;
  int? veiculoId;
  String? createdAt;
  String? updatedAt;
  String? expenseDate;
  ExpenseCategory? expenseCategory;
  SpecificTypeExpense? specificTypeExpense;
  List<ExpensePhotos>? photos;

  Expense({
    this.id,
    this.descricao,
    this.categoriadespesaId,
    this.tipoespecificodespesaId,
    this.valor,
    this.empresa,
    this.cidade,
    this.uf,
    this.ddd,
    this.telefone,
    this.observacoes,
    this.status,
    this.pessoaId,
    this.veiculoId,
    this.createdAt,
    this.updatedAt,
    this.expenseDate,
    this.expenseCategory,
    this.photos,
  });

  Expense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    categoriadespesaId = json['categoriadespesa_id'];
    tipoespecificodespesaId = json['tipoespecificodespesa_id'];
    valor = json['valor'];
    empresa = json['empresa'];
    cidade = json['cidade'];
    uf = json['uf'];
    ddd = json['ddd'];
    telefone = json['telefone'];
    observacoes = json['observacoes'];
    status = json['status'];
    pessoaId = json['pessoa_id'];
    veiculoId = json['veiculo_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    expenseDate = json['data_despesa'];
    expenseCategory = json['categoriadespesa'] != null
        ? ExpenseCategory.fromJson(json['categoriadespesa'])
        : null;
    specificTypeExpense = json['tipoespecificodespesa'] != null
        ? SpecificTypeExpense.fromJson(json['tipoespecificodespesa'])
        : null;

    if (json['fotos'] != null) {
      photos = <ExpensePhotos>[];
      json['fotos'].forEach((v) {
        photos!.add(ExpensePhotos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['categoriadespesa_id'] = categoriadespesaId;
    data['tipoespecificodespesa_id'] = tipoespecificodespesaId;
    data['valor'] = valor;
    data['empresa'] = empresa;
    data['cidade'] = cidade;
    data['uf'] = uf;
    data['ddd'] = ddd;
    data['telefone'] = telefone;
    data['observacoes'] = observacoes;
    data['status'] = status;
    data['pessoa_id'] = pessoaId;
    data['veiculo_id'] = veiculoId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['data_despesa'] = expenseDate;
    if (photos != null) {
      data['fotos'] = photos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
