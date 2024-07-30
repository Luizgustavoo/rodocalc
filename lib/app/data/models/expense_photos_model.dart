import 'package:rodocalc/app/data/models/expense_model.dart';

class ExpensePhotos {
  int? id;
  int? despesaId;
  Expense? expense;
  String? arquivo;
  String? createdAt;
  String? updatedAt;

  ExpensePhotos({
    this.id,
    this.despesaId,
    this.expense,
    this.arquivo,
    this.createdAt,
    this.updatedAt,
  });

  ExpensePhotos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    despesaId = json['pessoa_id'];
    expense =
        json['despesa'] != null ? Expense.fromJson(json['despesa']) : null;
    arquivo = json['arquivo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['despesa_id'] = despesaId;
    if (expense != null) {
      data['despesa'] = expense!.toJson();
    }
    data['arquivo'] = arquivo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
