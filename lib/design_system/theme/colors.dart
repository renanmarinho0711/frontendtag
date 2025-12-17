import 'package:flutter/material.dart';

/// Cores do tema da aplicação
/// 
/// Centraliza todas as cores utilizadas no app, incluindo:
/// - Cores primárias e secundárias
/// - Cores de status (sucesso, erro, warning, info)
/// - Cores neutras (background, superfície, texto, divisores)
/// 
/// Uso: AppColors.primary, AppColors.success, etc.
class AppColors {
  // Prevent instantiation
  AppColors._();

  // Cores primárias
  static const Color primary = Color(0xFF667eea);
  static const Color primaryDark = Color(0xFF764ba2);
  static const Color secondary = Color(0xFF764ba2);

  // Gradientes comuns
  static const List<Color> primaryGradient = [primary, primaryDark];
  static const List<Color> successGradient = [Color(0xFF11998e), Color(0xFF38ef7d)];
  static const List<Color> warningGradient = [Color(0xFFFFB74D), Color(0xFFFF9800)];
  static const List<Color> errorGradient = [Color(0xFFf093fb), Color(0xFFf5576c)];
  static const List<Color> infoGradient = [Color(0xFF4facfe), Color(0xFF00f2fe)];

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Neutros
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFE0E0E0);

  // Gradientes por módulo
  static const List<Color> produtosGradient = [Color(0xFF11998e), Color(0xFF38ef7d)];
  static const List<Color> etiquetasGradient = [Color(0xFFf093fb), Color(0xFFf5576c)];
  static const List<Color> estrategiasGradient = [Color(0xFFFFB74D), Color(0xFFFF9800)];
  static const List<Color> sincronizacaoGradient = [Color(0xFF4facfe), Color(0xFF00f2fe)];
  static const List<Color> precificacaoGradient = [Color(0xFFfa709a), Color(0xFFfee140)];
  static const List<Color> categoriasGradient = [Color(0xFF30cfd0), Color(0xFF330867)];
  static const List<Color> importacaoGradient = [Color(0xFFa8edea), Color(0xFFfed6e3)];
  static const List<Color> relatoriosGradient = [Color(0xFFff9a56), Color(0xFFff6a88)];
  static const List<Color> configuracoesGradient = [Color(0xFF434343), Color(0xFF000000)];
}



