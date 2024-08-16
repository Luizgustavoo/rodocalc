class Address {
  final String logradouro;
  final String bairro;

  Address({required this.logradouro, required this.bairro});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
    );
  }
}
