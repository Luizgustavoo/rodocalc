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

  static bool validEmail(String email) {
    if (email == null || email.isEmpty) {
      return false;
    }

    // Regex para validar email
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);

    return regex.hasMatch(email);
  }
}
