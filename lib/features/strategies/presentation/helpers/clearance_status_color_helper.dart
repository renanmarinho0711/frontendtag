import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// ==============================================================================
/// CLEARANCE STATUS COLOR HELPER - Isolador de Cores para Status de Liberação
/// ==============================================================================
/// 
/// Mapeia ClearanceStatus para cor dinâmica usando BuildContext.
/// Antes: clearance_models.dart ClearanceStatus.color getter (sem context)
/// Depois: ClearanceStatusColorHelper.getColor(context, status) - dinâmico
/// 
/// BENEFÍCIOS:
/// - ✅ Cores dinâmicas por tema
/// - ✅ Lógica visual fora de models
/// - ✅ Fácil de testar
/// - ✅ Reutilizável em widgets
/// 
/// ==============================================================================

// Enum para status de liberação
enum ClearanceStatus {
  pending('Pendente'),
  approved('Aprovado'),
  rejected('Rejeitado'),
  expired('Expirado');

  final String label;
  const ClearanceStatus(this.label);
}

class ClearanceStatusColorHelper {
  ClearanceStatusColorHelper._();

  /// Retorna a cor dinâmica para um ClearanceStatus específico
  static Color getColor(BuildContext context, ClearanceStatus status) {
    final colors = ThemeColors.of(context);
    
    switch (status) {
      case ClearanceStatus.pending:
        return colors.clearancePending;
      case ClearanceStatus.approved:
        return colors.clearanceApproved;
      case ClearanceStatus.rejected:
        return colors.clearanceRejected;
      case ClearanceStatus.expired:
        return colors.clearanceExpired;
    }
  }

  /// Retorna um ícone apropriado para o status
  static IconData getIcon(ClearanceStatus status) {
    switch (status) {
      case ClearanceStatus.pending:
        return Icons.pending_actions;
      case ClearanceStatus.approved:
        return Icons.check_circle;
      case ClearanceStatus.rejected:
        return Icons.cancel;
      case ClearanceStatus.expired:
        return Icons.schedule;
    }
  }

  /// Retorna label de texto para o status
  static String getLabel(ClearanceStatus status) {
    return status.label;
  }

  /// Retorna se o status é considerado "ativo" (pode ser alterado)
  static bool isActive(ClearanceStatus status) {
    return status == ClearanceStatus.pending;
  }
}

