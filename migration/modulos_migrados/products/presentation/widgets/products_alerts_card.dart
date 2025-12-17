import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
enum AlertPriority { critical, attention, info, success }

class ProductAlert {
  final String id;
  final AlertPriority priority;
  final String message;
  final IconData icon;
  final String actionLabel;
  final VoidCallback onAction;
  final int? count;

  ProductAlert({
    required this.id,
    required this.priority,
    required this.message,
    required this.icon,
    required this.actionLabel,
    required this.onAction,
    this.count,
  });

  Color get color {
    switch (priority) {
      case AlertPriority.critical:
        return ThemeColors.of(context).redMain;
      case AlertPriority.attention:
        return ThemeColors.of(context).orangeMain;
      case AlertPriority.info:
        return ThemeColors.of(context).blueMaterial;
      case AlertPriority.success:
        return ThemeColors.of(context).brandPrimaryGreen;
    }
  }
}

class ProductsAlertsCard extends StatefulWidget {
  final List<ProductAlert> alerts;
  final VoidCallback? onResolveAll;

  const ProductsAlertsCard({
    super.key,
    required this.alerts,
    this.onResolveAll,
  });

  @override
  State<ProductsAlertsCard> createState() => _ProductsAlertsCardState();
}

class _ProductsAlertsCardState extends State<ProductsAlertsCard> {
  bool _isMinimized = false;

  @override
  Widget build(BuildContext context) {
    if (widget.alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    final isMobile = ResponsiveHelper.isMobile(context);
    final sortedAlerts = List<ProductAlert>.from(widget.alerts)
      ..sort((a, b) => a.priority.index.compareTo(b.priority.index));

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 16, tablet: 20, desktop: 24),
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(
          color: Color.alphaBlend(sortedAlerts.first.color.withValues(alpha: 0.3), ThemeColors.of(context).surface),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.alphaBlend(sortedAlerts.first.color.withValues(alpha: 0.1), ThemeColors.of(context).surface),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _isMinimized = !_isMinimized),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(isMobile ? 16 : 20),
              bottom: _isMinimized ? Radius.circular(isMobile ? 16 : 20) : Radius.zero,
            ),
            child: Padding(
              padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context, mobile: 14, tablet: 16, desktop: 18)),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: sortedAlerts.first.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: sortedAlerts.first.color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ações Pendentes',
                          style: TextStyle(
                            fontSize: isMobile ? 15 : 16,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).textPrimary,
                          ),
                        ),
                        Text(
                          '${widget.alerts.length} ${widget.alerts.length == 1 ? 'item requer' : 'itens requerem'} atenção',
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 13,
                            color: ThemeColors.of(context).textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.alerts.length > 1 && widget.onResolveAll != null)
                    TextButton(
                      onPressed: widget.onResolveAll,
                      child: Text(
                        'Resolver todos',
                        style: TextStyle(
                          color: sortedAlerts.first.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  Icon(
                    _isMinimized ? Icons.expand_more : Icons.expand_less,
                    color: ThemeColors.of(context).textTertiary,
                  ),
                ],
              ),
            ),
          ),
          
          // Alerts List
          if (!_isMinimized)
            Container(
              decoration: BoxDecoration(
                color: ThemeColors.of(context).backgroundLight,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(isMobile ? 16 : 20),
                ),
              ),
              child: Column(
                children: sortedAlerts.asMap().entries.map((entry) {
                  final index = entry.key;
                  final alert = entry.value;
                  return _buildAlertItem(context, alert, isLast: index == sortedAlerts.length - 1);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(BuildContext context, ProductAlert alert, {bool isLast = false}) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 14, tablet: 16, desktop: 18),
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: ThemeColors.of(context).border, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: alert.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(alert.icon, color: alert.color, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Row(
              children: [
                if (alert.count != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: alert.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${alert.count}',
                      style: TextStyle(
                        color: alert.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    alert.message,
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 14,
                      color: ThemeColors.of(context).textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          TextButton(
            onPressed: alert.onAction,
            style: TextButton.styleFrom(
              foregroundColor: alert.color,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              alert.actionLabel,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}


