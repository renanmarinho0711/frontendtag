import 'package:intl/intl.dart';

/// Formatadores de dados
/// 
/// Funções de formatação reutilizáveis para exibição
class Formatters {
  Formatters._();

  /// Formato de moeda brasileira
  static final _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  /// Formato de número decimal
  static final _decimalFormat = NumberFormat.decimalPattern('pt_BR');

  /// Formato de data curta
  static final _dateFormat = DateFormat('dd/MM/yyyy');

  /// Formato de hora
  static final _timeFormat = DateFormat('HH:mm');

  /// Formato de data e hora
  static final _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');

  /// Formato de data completa
  static final _fullDateFormat = DateFormat('dd \'de\' MMMM \'de\' yyyy', 'pt_BR');

  // ===== MOEDA =====

  /// Formata valor como moeda brasileira (R$ 1.234,56)
  static String currency(double value) {
    return _currencyFormat.format(value);
  }

  /// Formata valor como moeda compacta (R$ 1,2K ou R$ 1,5M)
  static String currencyCompact(double value) {
    if (value >= 1000000) {
      return 'R\$ ${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return 'R\$ ${(value / 1000).toStringAsFixed(1)}K';
    }
    return currency(value);
  }

  /// Converte string formatada para double
  static double? parseCurrency(String value) {
    try {
      String cleanValue = value
          .replaceAll('R\$', '')
          .replaceAll(' ', '')
          .replaceAll('.', '')
          .replaceAll(',', '.');
      return double.tryParse(cleanValue);
    } catch (_) {
      return null;
    }
  }

  // ===== NÚMEROS =====

  /// Formata número decimal (1.234,56)
  static String decimal(double value, {int decimalDigits = 2}) {
    return value.toStringAsFixed(decimalDigits).replaceAll('.', ',');
  }

  /// Formata número com separador de milhar
  static String number(num value) {
    return _decimalFormat.format(value);
  }

  /// Formata número compacto (1,2K ou 1,5M)
  static String numberCompact(num value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  /// Formata percentual
  static String percent(double value, {int decimalDigits = 1}) {
    return '${(value * 100).toStringAsFixed(decimalDigits)}%';
  }

  /// Formata percentual a partir de valor já em percentual
  static String percentValue(double value, {int decimalDigits = 1}) {
    return '${value.toStringAsFixed(decimalDigits)}%';
  }

  // ===== DATAS =====

  /// Formata data (dd/MM/yyyy)
  static String date(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Formata hora (HH:mm)
  static String time(DateTime date) {
    return _timeFormat.format(date);
  }

  /// Formata data e hora (dd/MM/yyyy HH:mm)
  static String dateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  /// Formata data completa (01 de janeiro de 2025)
  static String fullDate(DateTime date) {
    return _fullDateFormat.format(date);
  }

  /// Formata data relativa (hoje, ontem, há 2 dias, etc.)
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final difference = today.difference(dateOnly).inDays;

    if (difference == 0) {
      return 'Hoje às ${time(date)}';
    } else if (difference == 1) {
      return 'Ontem às ${time(date)}';
    } else if (difference == -1) {
      return 'Amanhã às ${time(date)}';
    } else if (difference > 0 && difference < 7) {
      return 'Há $difference dias';
    } else if (difference < 0 && difference > -7) {
      return 'Em ${-difference} dias';
    } else {
      return Formatters.date(date);
    }
  }

  /// Formata duração (1h 30min)
  static String duration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}min';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}min';
    }
    return '${duration.inSeconds}s';
  }

  /// Formata tempo decorrido
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'agora';
    } else if (difference.inMinutes < 60) {
      return 'há ${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return 'há ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'há ${difference.inDays}d';
    } else if (difference.inDays < 30) {
      return 'há ${(difference.inDays / 7).floor()} sem';
    } else if (difference.inDays < 365) {
      return 'há ${(difference.inDays / 30).floor()} mês(es)';
    } else {
      return 'há ${(difference.inDays / 365).floor()} ano(s)';
    }
  }

  // ===== DOCUMENTOS =====

  /// Formata CPF (000.000.000-00)
  static String cpf(String value) {
    final clean = value.replaceAll(RegExp(r'\D'), '');
    if (clean.length != 11) return value;

    return '${clean.substring(0, 3)}.${clean.substring(3, 6)}.${clean.substring(6, 9)}-${clean.substring(9)}';
  }

  /// Formata CNPJ (00.000.000/0000-00)
  static String cnpj(String value) {
    final clean = value.replaceAll(RegExp(r'\D'), '');
    if (clean.length != 14) return value;

    return '${clean.substring(0, 2)}.${clean.substring(2, 5)}.${clean.substring(5, 8)}/${clean.substring(8, 12)}-${clean.substring(12)}';
  }

  /// Formata CPF ou CNPJ automaticamente
  static String cpfCnpj(String value) {
    final clean = value.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 11) return cpf(value);
    if (clean.length == 14) return cnpj(value);
    return value;
  }

  // ===== TELEFONE =====

  /// Formata telefone ((00) 00000-0000 ou (00) 0000-0000)
  static String phone(String value) {
    final clean = value.replaceAll(RegExp(r'\D'), '');

    if (clean.length == 11) {
      return '(${clean.substring(0, 2)}) ${clean.substring(2, 7)}-${clean.substring(7)}';
    } else if (clean.length == 10) {
      return '(${clean.substring(0, 2)}) ${clean.substring(2, 6)}-${clean.substring(6)}';
    }

    return value;
  }

  // ===== CEP =====

  /// Formata CEP (00000-000)
  static String cep(String value) {
    final clean = value.replaceAll(RegExp(r'\D'), '');
    if (clean.length != 8) return value;

    return '${clean.substring(0, 5)}-${clean.substring(5)}';
  }

  // ===== TEXTOS =====

  /// Capitaliza primeira letra
  static String capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  /// Capitaliza primeira letra de cada palavra
  static String titleCase(String value) {
    if (value.isEmpty) return value;
    return value.split(' ').map(capitalize).join(' ');
  }

  /// Trunca texto com reticências
  static String truncate(String value, int maxLength) {
    if (value.length <= maxLength) return value;
    return '${value.substring(0, maxLength - 3)}...';
  }

  /// Formata nome de arquivo com tamanho
  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // ===== ESPECÍFICOS DO TAGBEAN =====

  /// Formata MAC address (XX:XX:XX:XX:XX:XX)
  static String macAddress(String value) {
    final clean = value.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '').toUpperCase();
    if (clean.length != 12) return value;

    return [
      clean.substring(0, 2),
      clean.substring(2, 4),
      clean.substring(4, 6),
      clean.substring(6, 8),
      clean.substring(8, 10),
      clean.substring(10, 12),
    ].join(':');
  }

  /// Formata GTIN/EAN
  static String gtin(String value) {
    final clean = value.replaceAll(RegExp(r'\D'), '');
    return clean;
  }

  /// Formata código de produto
  static String productCode(String value) {
    return value.toUpperCase().trim();
  }

  /// Formata status de sincronização
  static String syncStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pendente';
      case 'syncing':
        return 'Sincronizando';
      case 'synced':
        return 'Sincronizado';
      case 'error':
        return 'Erro';
      case 'conflict':
        return 'Conflito';
      default:
        return status;
    }
  }

  /// Formata margem de lucro com cor indicativa
  static String margin(double marginPercent) {
    final formatted = percentValue(marginPercent, decimalDigits: 1);
    return formatted;
  }

  /// Formata quantidade de estoque
  static String stock(int quantity, {int? minimum}) {
    if (minimum != null && quantity <= minimum) {
      return '$quantity (baixo)';
    }
    return quantity.toString();
  }

  /// Formata saudação baseada na hora
  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) return 'Bom dia';
    if (hour >= 12 && hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }
}



