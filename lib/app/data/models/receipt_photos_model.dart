import 'package:rodocalc/app/data/models/expense_model.dart';

class ReceiptPhotos {
  int? id;
  int? receiptId;
  Expense? expense;
  String? arquivo;
  String? createdAt;
  String? updatedAt;

  ReceiptPhotos({
    this.id,
    this.receiptId,
    this.expense,
    this.arquivo,
    this.createdAt,
    this.updatedAt,
  });

  ReceiptPhotos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiptId = json['receita_id'];
    expense =
        json['despesa'] != null ? Expense.fromJson(json['despesa']) : null;
    arquivo = json['arquivo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['receita_id'] = receiptId;
    if (expense != null) {
      data['despesa'] = expense!.toJson();
    }
    data['arquivo'] = arquivo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
