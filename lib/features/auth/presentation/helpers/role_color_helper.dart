import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// ==============================================================================
/// ROLE COLOR HELPER - Isolador de Cores para Roles/Permissões
/// ==============================================================================
/// 
/// Mapeia UserRole (String) para cor dinâmica usando BuildContext.
/// Antes: UserModel.color getter (sem context, hardcoded)
/// Depois: RoleColorHelper.getColor(context, role) - dinâmico
/// 
/// BENEFÍCIOS:
/// - ✅ Cores dinâmicas por tema
/// - ✅ Lógica visual fora de models
/// - ✅ Fácil de testar
/// - ✅ Reutilizável em qualquer widget
/// 
/// ==============================================================================

class RoleColorHelper {
  RoleColorHelper._();

  // Constantes de role
  static const String rolePlatformAdmin = 'PlatformAdmin';
  static const String roleClientAdmin = 'ClientAdmin';
  static const String roleStoreManager = 'StoreManager';
  static const String roleOperator = 'Operator';
  static const String roleGuest = 'Guest';

  /// Retorna a cor dinâmica para um role específico (String)
  static Color getColor(BuildContext context, String role) {
    final colors = ThemeColors.of(context);
    
    switch (role) {
      case rolePlatformAdmin:
        return colors.roleSuperAdmin;
      case roleClientAdmin:
        return colors.roleAdmin; // Mapeado para roleAdmin disponível
      case roleStoreManager:
        return colors.roleManager; // Mapeado para roleManager disponível
      case roleOperator:
        return colors.roleOperator;
      case roleGuest:
        return colors.roleViewer; // Mapeado para roleViewer disponível
      default:
        return colors.textSecondary;
    }
  }

  /// Retorna um ícone apropriado para o role
  static IconData getIcon(String role) {
    switch (role) {
      case rolePlatformAdmin:
        return Icons.admin_panel_settings;
      case roleClientAdmin:
        return Icons.business;
      case roleStoreManager:
        return Icons.store;
      case roleOperator:
        return Icons.person;
      case roleGuest:
        return Icons.visibility;
      default:
        return Icons.account_circle;
    }
  }

  /// Retorna label de texto para o role
  static String getLabel(String role) {
    switch (role) {
      case rolePlatformAdmin:
        return 'Super Admin';
      case roleClientAdmin:
        return 'Admin Cliente';
      case roleStoreManager:
        return 'Gerente Loja';
      case roleOperator:
        return 'Operador';
      case roleGuest:
        return 'Convidado';
      default:
        return role;
    }
  }
}
