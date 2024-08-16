class Address {
  final String logradouro;
  final String bairro;
  final String cidade;
  final String uf;

  Address(
      {required this.logradouro,
      required this.bairro,
      required this.cidade,
      required this.uf});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
      cidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
    );
  }
}
