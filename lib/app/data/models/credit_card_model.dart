class CreditCard {
  int? id;
  String? cardNumber;
  String? validate;
  String? cvv;
  String? cardName;
  String? cpf;
  int? valor;

  CreditCard(
      {this.id,
      this.cardNumber,
      this.validate,
      this.cvv,
      this.cardName,
      this.cpf,
      this.valor});

  CreditCard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardNumber = json['numero_cartao'];
    validate = json['validade'];
    cvv = json['cvv'];
    cardName = json['nome_cartao'];
    cpf = json['cpf'];
    valor = json['valor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['numero_cartao'] = cardNumber;
    data['validade'] = validate;
    data['cvv'] = cvv;
    data['nome_cartao'] = cardName;
    data['cpf'] = cpf;
    data['valor'] = valor;
    return data;
  }
}
