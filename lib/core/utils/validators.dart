/// Validadores de formulários
library;

/// 

/// Funções de validação reutilizáveis para campos de formulário

class Validators {

  Validators._();



  /// Valida se o campo não está vazio

  static String? required(String? value, [String? fieldName]) {

    if (value == null || value.trim().isEmpty) {

      return fieldName != null ? '$fieldName é obrigatório' : 'Campo obrigatório';

    }

    return null;

  }



  /// Valida e-mail

  static String? email(String? value) {

    if (value == null || value.isEmpty) {

      return 'E-mail é obrigatório';

    }



    final emailRegex = RegExp(

      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',

    );



    if (!emailRegex.hasMatch(value)) {

      return 'E-mail inválido';

    }



    return null;

  }



  /// Valida senha

  static String? password(String? value, {int minLength = 6}) {

    if (value == null || value.isEmpty) {

      return 'Senha é obrigatória';

    }



    if (value.length < minLength) {

      return 'Senha deve ter pelo menos $minLength caracteres';

    }



    return null;

  }



  /// Valida senha forte

  static String? strongPassword(String? value) {

    if (value == null || value.isEmpty) {

      return 'Senha é obrigatória';

    }



    if (value.length < 8) {

      return 'Senha deve ter pelo menos 8 caracteres';

    }



    if (!RegExp(r'[A-Z]').hasMatch(value)) {

      return 'Senha deve conter pelo menos uma letra maiúscula';

    }



    if (!RegExp(r'[a-z]').hasMatch(value)) {

      return 'Senha deve conter pelo menos uma letra minúscula';

    }



    if (!RegExp(r'[0-9]').hasMatch(value)) {

      return 'Senha deve conter pelo menos um número';

    }



    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {

      return 'Senha deve conter pelo menos um caractere especial';

    }



    return null;

  }



  /// Valida confirmação de senha

  static String? confirmPassword(String? value, String password) {

    if (value == null || value.isEmpty) {

      return 'Confirmação de senha é obrigatória';

    }



    if (value != password) {

      return 'As senhas não coincidem';

    }



    return null;

  }



  /// Valida CPF

  static String? cpf(String? value) {

    if (value == null || value.isEmpty) {

      return 'CPF é obrigatório';

    }



    // Remove caracteres não numéricos

    final cleanValue = value.replaceAll(RegExp(r'\D'), '');



    if (cleanValue.length != 11) {

      return 'CPF inválido';

    }



    // Verifica se todos os dígitos são iguais

    if (RegExp(r'^(\d)\1{10}$').hasMatch(cleanValue)) {

      return 'CPF inválido';

    }



    // Validação dos dígitos verificadores

    int sum = 0;

    for (int i = 0; i < 9; i++) {

      sum += int.parse(cleanValue[i]) * (10 - i);

    }

    int firstDigit = (sum * 10) % 11;

    if (firstDigit == 10) firstDigit = 0;



    if (firstDigit != int.parse(cleanValue[9])) {

      return 'CPF inválido';

    }



    sum = 0;

    for (int i = 0; i < 10; i++) {

      sum += int.parse(cleanValue[i]) * (11 - i);

    }

    int secondDigit = (sum * 10) % 11;

    if (secondDigit == 10) secondDigit = 0;



    if (secondDigit != int.parse(cleanValue[10])) {

      return 'CPF inválido';

    }



    return null;

  }



  /// Valida CNPJ

  static String? cnpj(String? value) {

    if (value == null || value.isEmpty) {

      return 'CNPJ é obrigatório';

    }



    // Remove caracteres não numéricos

    final cleanValue = value.replaceAll(RegExp(r'\D'), '');



    if (cleanValue.length != 14) {

      return 'CNPJ inválido';

    }



    // Verifica se todos os dígitos são iguais

    if (RegExp(r'^(\d)\1{13}$').hasMatch(cleanValue)) {

      return 'CNPJ inválido';

    }



    // Validação dos dígitos verificadores

    List<int> multipliers1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

    List<int> multipliers2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];



    int sum = 0;

    for (int i = 0; i < 12; i++) {

      sum += int.parse(cleanValue[i]) * multipliers1[i];

    }

    int remainder = sum % 11;

    int firstDigit = remainder < 2 ? 0 : 11 - remainder;



    if (firstDigit != int.parse(cleanValue[12])) {

      return 'CNPJ inválido';

    }



    sum = 0;

    for (int i = 0; i < 13; i++) {

      sum += int.parse(cleanValue[i]) * multipliers2[i];

    }

    remainder = sum % 11;

    int secondDigit = remainder < 2 ? 0 : 11 - remainder;



    if (secondDigit != int.parse(cleanValue[13])) {

      return 'CNPJ inválido';

    }



    return null;

  }



  /// Valida telefone brasileiro

  static String? phone(String? value) {

    if (value == null || value.isEmpty) {

      return 'Telefone é obrigatório';

    }



    final cleanValue = value.replaceAll(RegExp(r'\D'), '');



    if (cleanValue.length < 10 || cleanValue.length > 11) {

      return 'Telefone inválido';

    }



    return null;

  }



  /// Valida CEP

  static String? cep(String? value) {

    if (value == null || value.isEmpty) {

      return 'CEP é obrigatório';

    }



    final cleanValue = value.replaceAll(RegExp(r'\D'), '');



    if (cleanValue.length != 8) {

      return 'CEP inválido';

    }



    return null;

  }



  /// Valida número inteiro

  static String? integer(String? value, [String? fieldName]) {

    if (value == null || value.isEmpty) {

      return fieldName != null ? '$fieldName é obrigatório' : 'Campo obrigatório';

    }



    if (int.tryParse(value) == null) {

      return 'Informe um número inteiro válido';

    }



    return null;

  }



  /// Valida número decimal

  static String? decimal(String? value, [String? fieldName]) {

    if (value == null || value.isEmpty) {

      return fieldName != null ? '$fieldName é obrigatório' : 'Campo obrigatório';

    }



    // Aceita vírgula ou ponto como separador decimal

    final normalizedValue = value.replaceAll(',', '.');



    if (double.tryParse(normalizedValue) == null) {

      return 'Informe um número válido';

    }



    return null;

  }



  /// Valida valor monetário

  static String? currency(String? value, [String? fieldName]) {

    if (value == null || value.isEmpty) {

      return fieldName != null ? '$fieldName é obrigatório' : 'Campo obrigatório';

    }



    // Remove R$, espaços e pontos de milhar

    String cleanValue = value

        .replaceAll('R\$', '')

        .replaceAll(' ', '')

        .replaceAll('.', '')

        .replaceAll(',', '.');



    final number = double.tryParse(cleanValue);



    if (number == null) {

      return 'Valor inválido';

    }



    if (number < 0) {

      return 'Valor não pode ser negativo';

    }



    return null;

  }



  /// Valida valor mínimo

  static String? Function(String?) minValue(double min, [String? fieldName]) {

    return (String? value) {

      if (value == null || value.isEmpty) {

        return fieldName != null ? '$fieldName é obrigatório' : 'Campo obrigatório';

      }



      final normalizedValue = value.replaceAll(',', '.');

      final number = double.tryParse(normalizedValue);



      if (number == null) {

        return 'Valor inválido';

      }



      if (number < min) {

        return 'Valor mínimo é $min';

      }



      return null;

    };

  }



  /// Valida valor máximo

  static String? Function(String?) maxValue(double max, [String? fieldName]) {

    return (String? value) {

      if (value == null || value.isEmpty) {

        return null; // Não validar se vazio (use required para isso)

      }



      final normalizedValue = value.replaceAll(',', '.');

      final number = double.tryParse(normalizedValue);



      if (number == null) {

        return 'Valor inválido';

      }



      if (number > max) {

        return 'Valor máximo é $max';

      }



      return null;

    };

  }



  /// Valida tamanho mínimo de texto

  static String? Function(String?) minLength(int min, [String? fieldName]) {

    return (String? value) {

      if (value == null || value.isEmpty) {

        return fieldName != null ? '$fieldName é obrigatório' : 'Campo obrigatório';

      }



      if (value.length < min) {

        return 'Mínimo de $min caracteres';

      }



      return null;

    };

  }



  /// Valida tamanho máximo de texto

  static String? Function(String?) maxLength(int max, [String? fieldName]) {

    return (String? value) {

      if (value == null || value.isEmpty) {

        return null;

      }



      if (value.length > max) {

        return 'Máximo de $max caracteres';

      }



      return null;

    };

  }



  /// Valida código de produto (alfanumérico)

  static String? productCode(String? value) {

    if (value == null || value.isEmpty) {

      return 'Código é obrigatório';

    }



    if (!RegExp(r'^[a-zA-Z0-9\-_]+$').hasMatch(value)) {

      return 'Código deve conter apenas letras, números, hífen ou underscore';

    }



    return null;

  }



  /// Valida GTIN (EAN-13, EAN-8, UPC-A)

  static String? gtin(String? value) {

    if (value == null || value.isEmpty) {

      return null; // GTIN é opcional

    }



    final cleanValue = value.replaceAll(RegExp(r'\D'), '');



    if (![8, 12, 13, 14].contains(cleanValue.length)) {

      return 'GTIN deve ter 8, 12, 13 ou 14 dígitos';

    }



    // Validação do dígito verificador

    int sum = 0;

    final length = cleanValue.length;

    

    for (int i = 0; i < length - 1; i++) {

      final digit = int.parse(cleanValue[i]);

      final position = length - 1 - i;

      sum += digit * (position.isEven ? 3 : 1);

    }

    

    final checkDigit = (10 - (sum % 10)) % 10;

    final lastDigit = int.parse(cleanValue[length - 1]);

    

    if (checkDigit != lastDigit) {

      return 'GTIN inválido (dígito verificador incorreto)';

    }



    return null;

  }



  /// Valida MAC address

  static String? macAddress(String? value) {

    if (value == null || value.isEmpty) {

      return 'MAC address é obrigatório';

    }



    // Formatos aceitos: XX:XX:XX:XX:XX:XX ou XX-XX-XX-XX-XX-XX ou XXXXXXXXXXXX

    final macRegex = RegExp(

      r'^([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}$|^[0-9A-Fa-f]{12}$',

    );



    if (!macRegex.hasMatch(value)) {

      return 'MAC address inválido';

    }



    return null;

  }



  /// Combina múltiplos validadores

  static String? Function(String?) combine(

    List<String? Function(String?)> validators,

  ) {

    return (String? value) {

      for (final validator in validators) {

        final error = validator(value);

        if (error != null) {

          return error;

        }

      }

      return null;

    };

  }



  /// Valida código de barras (EAN-13)

  static String? barcode(String? value) {

    if (value == null || value.isEmpty) return null;

    if (value.length != 13) return 'Código deve ter 13 dígitos';

    if (!RegExp(r'^\d{13}$').hasMatch(value)) {

      return 'Código deve conter apenas números';

    }

    return null;

  }



  /// Valida preço

  static String? price(String? value) {

    if (value == null || value.isEmpty) return null;

    final cleaned = value

        .replaceAll('R\$', '')

        .replaceAll('.', '')

        .replaceAll(',', '.')

        .trim();

    final number = double.tryParse(cleaned);

    if (number == null) return 'Preço inválido';

    if (number < 0) return 'Preço não pode ser negativo';

    return null;

  }



  /// Valida número positivo

  static String? positiveNumber(String? value) {

    if (value == null || value.isEmpty) return null;

    final number = double.tryParse(value.replaceAll(',', '.'));

    if (number == null) return 'Valor inválido';

    if (number <= 0) return 'Valor deve ser maior que zero';

    return null;

  }



  /// Valida porcentagem (0-100)

  static String? percentage(String? value) {

    if (value == null || value.isEmpty) return null;

    final number = double.tryParse(value.replaceAll(',', '.').replaceAll('%', ''));

    if (number == null) return 'Porcentagem inválida';

    if (number < 0 || number > 100) return 'Porcentagem deve ser entre 0 e 100';

    return null;

  }



  /// Validação opcional (só valida se tiver valor)

  static String? Function(String?) optional(String? Function(String?) validator) {

    return (String? value) {

      if (value == null || value.isEmpty) return null;

      return validator(value);

    };

  }

}







