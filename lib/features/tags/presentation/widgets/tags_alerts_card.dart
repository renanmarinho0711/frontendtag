import 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Prioridade do alerta - compatível com tags_dashboard_screen.dart
enum TagAlertPriority { critical, attention, info }

/// Modelo de alerta de tags - compatível com tags_dashboard_screen.dart
class TagAlert {
  final String id;
  final TagAlertPriority priority;
  final String message;
  final IconData icon;
  final int count;
  final String actionLabel;
  final VoidCallback onAction;
  final VoidCallback? onDismiss;

  const TagAlert({
    required this.id,
    required this.priority,
    required this.message,
    required this.icon,
    required this.count,
    required this.actionLabel,
    required this.onAction,
    this.onDismiss,
  });
}

/// Card de alertas acioníveis para o módulo Tags
class TagsAlertsCard extends StatelessWidget {
  final List<TagAlert> alerts;
  final VoidCallback? onResolveAll;

  const TagsAlertsCard({
    super.key,
    required this.alerts,
    this.onResolveAll,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: ThemeColors.of(context).orangeMaterial,
                size: isMobile ? 20 : 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Alertas Importantes',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                ),
              ),
              if (onResolveAll != null)
                TextButton(
                  onPressed: onResolveAll,
                  child: Text(
                    'Resolver Todos',
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 13,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.of(context).orangeMaterial,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Lista de alertas
          ...alerts.map((alert) => _buildAlertItem(context, alert, isMobile)),
        ],
      ),
    );
  }

  Widget _buildAlertItem(BuildContext context, TagAlert alert, bool isMobile) {
    final backgroundColor = _getBackgroundColor(context, alert.priority);
    final borderColor = _getBorderColor(context, alert.priority);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(isMobile ? 12 : 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: borderColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(alert.icon, color: borderColor, size: isMobile ? 18 : 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${alert.count} ${alert.message}',
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Clique para resolver',
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: alert.onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: borderColor,
              foregroundColor: ThemeColors.of(context).surface,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 10 : 12,
                vertical: isMobile ? 6 : 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              alert.actionLabel,
              style: TextStyle(
                fontSize: isMobile ? 11 : 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context, TagAlertPriority priority) {
    switch (priority) {
      case TagAlertPriority.critical:
        return ThemeColors.of(context).error.withValues(alpha: 0.1);
      case TagAlertPriority.attention:
        return ThemeColors.of(context).orangeMaterial.withValues(alpha: 0.1);
      case TagAlertPriority.info:
        return ThemeColors.of(context).primary.withValues(alpha: 0.1);
    }
  }

  Color _getBorderColor(BuildContext context, TagAlertPriority priority) {
    switch (priority) {
      case TagAlertPriority.critical:
        return ThemeColors.of(context).error;
      case TagAlertPriority.attention:
        return ThemeColors.of(context).orangeMaterial;
      case TagAlertPriority.info:
        return ThemeColors.of(context).primary;
    }
  }
}




