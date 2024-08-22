// ignore_for_file: unnecessary_null_comparison

class Services {
  static String _route = '/home';

  static String getRoute() {
    return _route;
  }

  static void setRoute(String route) {
    _route = route;
  }

  static bool validCPF(String cpf) {
    if (cpf == null || cpf.isEmpty) {
      return false;
    }

    // Remover caracteres não numéricos
    cpf = cpf.replaceAll(RegExp(r'\D'), '');

    // Verificar se o CPF tem 11 dígitos
    if (cpf.length != 11) {
      return false;
    }

    // Verificar se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
      return false;
    }

    // Validar dígitos verificadores
    List<int> numbers = cpf.split('').map((d) => int.parse(d)).toList();
    int sum1 = 0, sum2 = 0;

    for (int i = 0; i < 9; i++) {
      sum1 += numbers[i] * (10 - i);
      sum2 += numbers[i] * (11 - i);
    }

    int digit1 = (sum1 * 10 % 11) % 10;
    sum2 += digit1 * 2;
    int digit2 = (sum2 * 10 % 11) % 10;

    return numbers[9] == digit1 && numbers[10] == digit2;
  }

  static bool validCNPJ(String cnpj) {
    if (cnpj == null || cnpj.isEmpty) {
      return false;
    }

    // Remover caracteres não numéricos
    cnpj = cnpj.replaceAll(RegExp(r'\D'), '');

    // Verificar se o CNPJ tem 14 dígitos
    if (cnpj.length != 14) {
      return false;
    }

    // Verificar se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cnpj)) {
      return false;
    }

    // Validar dígitos verificadores
    List<int> numbers = cnpj.split('').map((d) => int.parse(d)).toList();
    List<int> weight1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    List<int> weight2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

    int sum1 = 0, sum2 = 0;

    for (int i = 0; i < 12; i++) {
      sum1 += numbers[i] * weight1[i];
      sum2 += numbers[i] * weight2[i];
    }

    int digit1 = sum1 % 11 < 2 ? 0 : 11 - (sum1 % 11);
    sum2 += digit1 * weight2[12];
    int digit2 = sum2 % 11 < 2 ? 0 : 11 - (sum2 % 11);

    return numbers[12] == digit1 && numbers[13] == digit2;
  }

  static bool validEmail(String email) {
    if (email == null || email.isEmpty) {
      return false;
    }

    // Regex para validar email
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);

    return regex.hasMatch(email);
  }

  static String limparCPF(String cpf) {
    return cpf.replaceAll(RegExp(r'\D'), '');
  }

  static String limparCEP(String cep) {
    // Remove tudo que não é número
    return cep.replaceAll(RegExp(r'\D'), '');
  }

  static Map<String, String> separarDDD(String telefone) {
    // Remove tudo que não é número
    String telefoneLimpo = telefone.replaceAll(RegExp(r'\D'), '');

    // O DDD são os dois primeiros dígitos
    String ddd = telefoneLimpo.substring(0, 2);

    // O restante é o número do telefone
    String numero = telefoneLimpo.substring(2);

    return {'ddd': ddd, 'numero': numero};
  }

  static String obterDataHoraAtualISO() {
    DateTime now = DateTime.now().toUtc();
    return now.toIso8601String().split('.').first + 'Z';
  }

  static int converterParaCentavos(String valor) {
    String valorSanitizado = valor.replaceAll("R\$", "").trim();
    valorSanitizado = valorSanitizado.replaceAll(",", ".");
    double valorEmReais = double.parse(valorSanitizado);
    int valorEmCentavos = (valorEmReais * 100).round();
    return valorEmCentavos;
  }

  static Map<String, String> mesAnoValidateCreditCart(String dataValidate) {
    List<String> partes = dataValidate.split('/');
    int expMonth = int.parse(partes[0]);
    int expYear = int.parse(partes[1]);
    return {'mes': expMonth.toString(), 'ano': expYear.toString()};
  }

  static String sanitizarCartaoCredito(String numeroCartao) {
    String cartaoSanitizado = numeroCartao.replaceAll(RegExp(r'\D'), '');
    return cartaoSanitizado;
  }
}
