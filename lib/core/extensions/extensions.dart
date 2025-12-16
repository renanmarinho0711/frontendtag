import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Extens�es �teis para String
extension StringExtensions on String {
  /// Capitaliza a primeira letra
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitaliza todas as palavras
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Verifica se � um email v�lido
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Verifica se � um CPF v�lido (formato)
  bool get isValidCPF {
    return RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$').hasMatch(this) ||
        RegExp(r'^\d{11}$').hasMatch(this);
  }

  /// Verifica se � um CNPJ v�lido (formato)
  bool get isValidCNPJ {
    return RegExp(r'^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$').hasMatch(this) ||
        RegExp(r'^\d{14}$').hasMatch(this);
  }

  /// Remove todos os caracteres n�o num�ricos
  String get onlyNumbers {
    return replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Formata como moeda BRL
  String toCurrency() {
    final value = double.tryParse(this) ?? 0.0;
    return value.toCurrency();
  }
}

/// Extens�es �teis para double
extension DoubleExtensions on double {
  /// Formata como moeda BRL
  String toCurrency() {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    return formatter.format(this);
  }

  /// Formata como percentual
  String toPercentage({int decimals = 1}) {
    return '${toStringAsFixed(decimals)}%';
  }

  /// Arredonda para 2 casas decimais
  double roundTo2Decimals() {
    return (this * 100).round() / 100;
  }
}

/// Extens�es �teis para DateTime
extension DateTimeExtensions on DateTime {
  /// Formata como dd/MM/yyyy
  String toFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  /// Formata como dd/MM/yyyy HH:mm
  String toFormattedDateTime() {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }

  /// Formata como HH:mm
  String toFormattedTime() {
    return DateFormat('HH:mm').format(this);
  }

  /// Retorna tempo relativo (ex: "h� 2 horas")
  String toRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'h� $years ${years == 1 ? 'ano' : 'anos'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'h� $months ${months == 1 ? 'm�s' : 'meses'}';
    } else if (difference.inDays > 0) {
      return 'h� ${difference.inDays} ${difference.inDays == 1 ? 'dia' : 'dias'}';
    } else if (difference.inHours > 0) {
      return 'h� ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inMinutes > 0) {
      return 'h� ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'agora';
    }
  }

  /// Verifica se � hoje
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Verifica se � ontem
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }
}

/// Extens�es �teis para BuildContext
extension ContextExtensions on BuildContext {
  /// Obt�m o MediaQueryData
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Obt�m o Theme
  ThemeData get theme => Theme.of(this);

  /// Obt�m o TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Obt�m o ColorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Obt�m a largura da tela
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Obt�m a altura da tela
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Verifica se � mobile
  bool get isMobile => screenWidth < 600;

  /// Verifica se � tablet
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  /// Verifica se � desktop
  bool get isDesktop => screenWidth >= 1024;

  /// Mostra SnackBar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppThemeColors.error : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Navega para uma rota
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Substitui a rota atual
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(Widget page, {TO? result}) {
    return Navigator.of(this).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Volta para a rota anterior
  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }

  /// Remove todas as rotas e navega para uma nova
  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  /// Oculta o teclado
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}

/// Extens�es �teis para List
extension ListExtensions<T> on List<T> {
  /// Retorna o elemento no �ndice ou null se n�o existir
  T? getOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }

  /// Divide a lista em chunks
  List<List<T>> chunk(int size) {
    return [
      for (var i = 0; i < length; i += size)
        sublist(i, i + size > length ? length : i + size)
    ];
  }
}

/// Extens�es �teis para Color
extension ColorExtensions on Color {
  /// Retorna uma vers�o mais escura da cor
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }

  /// Retorna uma vers�o mais clara da cor
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightened = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lightened.toColor();
  }
}




