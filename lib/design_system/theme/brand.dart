import 'package:flutter/material.dart';

/// Esquema de cores TAG BEAN - Verde Esmeralda
/// 
/// Baseado na identidade visual da logo TAG BEAN.
/// Contém as cores primárias da marca, gradientes, cores de superfície,
/// texto e sombras específicas da marca.
/// 
/// Uso: TagBeanColors.primaryGreen, TagBeanColors.primaryGradient, etc.
class TagBeanColors {
  TagBeanColors._();

  // Cores primárias da marca (extraídas da logo)
  static const Color primaryGreen = Color(0xFF00A86B); // Verde esmeralda principal
  static const Color primaryGreenDark = Color(0xFF008B5A); // Verde esmeralda escuro
  static const Color primaryGreenLight = Color(0xFF90EE90); // Verde lima claro
  static const Color accentLime = Color(0xFFB4FF9F); // Lima brilhante (destaque)
  
  // Gradientes da marca
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00A86B), // Verde esmeralda
      Color(0xFF008B5A), // Verde esmeralda escuro
    ],
  );
  
  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF90EE90), // Verde lima claro
      Color(0xFF00A86B), // Verde esmeralda
    ],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFB4FF9F), // Lima brilhante
      Color(0xFF90EE90), // Verde lima claro
    ],
  );
  
  // Gradiente profundo para tela de login (contraste alto)
  static const LinearGradient loginGradientDeep = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF041528), // Deep navy (azul-marinho escuro)
      Color(0xFF023E2D), // Deep teal (verde-azulado escuro)
    ],
  );
  
  // Cores neutras complementares
  static const Color darkBackground = Color(0xFF1A2F2A); // Verde escuro profundo
  static const Color mediumBackground = Color(0xFF2D4A42); // Verde médio
  static const Color lightBackground = Color(0xFFF0FFF4); // Verde muito claro (quase branco)
  
  // Cores de texto
  static const Color textDark = Color(0xFF1A2F2A);
  static const Color textMedium = Color(0xFF4A5F5A);
  static const Color textLight = Color(0xFF7A8F8A);
  static const Color textOnPrimary = Colors.white;
  
  // Cores de status
  static const Color success = Color(0xFF00A86B);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);
  
  // Cores de superfície
  static const Color cardBackground = Colors.white;
  static const Color inputBackground = Color(0xFFF5F5F5);
  static const Color divider = Color(0xFFE0E0E0);
  
  // Sombras
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: primaryGreen.withValues(alpha: 0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primaryGreen.withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  // Método auxiliar para obter cor com opacidade
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}




