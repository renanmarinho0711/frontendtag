import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// ==============================================================================
/// SYNC STATUS COLOR HELPER - Isolador de Cores para Status de Sincronização
/// ==============================================================================
/// 
/// Mapeia SyncStatus para cor dinâmica usando BuildContext.
/// Antes: sync_models.dart SyncStatus.color extension getter (sem context)
/// Depois: SyncStatusColorHelper.getColor(context, status) - dinâmico
/// 
/// BENEFÍCIOS:
/// - ✅ Cores dinâmicas por tema
/// - ✅ Lógica visual fora de models
/// - ✅ Fácil de testar
/// - ✅ Reutilizável em widgets
/// 
/// ==============================================================================

// Enum para status de sincronização
enum SyncStatus {
  pending('Pendente'),
  success('Sucesso'),
  error('Erro'),
  warning('Aviso');

  final String label;
  const SyncStatus(this.label);
}

class SyncStatusColorHelper {
  SyncStatusColorHelper._();

  /// Retorna a cor dinâmica para um SyncStatus específico
  static Color getColor(BuildContext context, SyncStatus status) {
    final colors = ThemeColors.of(context);
    
    switch (status) {
      case SyncStatus.pending:
        return colors.syncPending;
      case SyncStatus.success:
        return colors.syncSuccess;
      case SyncStatus.error:
        return colors.syncError;
      case SyncStatus.warning:
        return colors.syncWarning;
    }
  }

  /// Retorna um ícone apropriado para o status
  static IconData getIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.pending:
        return Icons.hourglass_bottom;
      case SyncStatus.success:
        return Icons.check_circle;
      case SyncStatus.error:
        return Icons.error;
      case SyncStatus.warning:
        return Icons.warning;
    }
  }

  /// Retorna label de texto para o status
  static String getLabel(SyncStatus status) {
    return status.label;
  }

  /// Retorna se o status é considerado "final" (não muda mais)
  static bool isFinal(SyncStatus status) {
    return status == SyncStatus.success || status == SyncStatus.error;
  }
}

