import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';

class QuickAction {
  final String label;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int? badge;
  final bool isUrgent;

  QuickAction({
    required this.label,
    this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.badge,
    this.isUrgent = false,
  });
}

class ProductsQuickActionsCard extends StatelessWidget {
  final List<QuickAction> actions;

  const ProductsQuickActionsCard({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context, mobile: 16, tablet: 20, desktop: 24)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ações Rápidas',
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 18,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'O que você mais faz',
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 13,
                        color: ThemeColors.of(context).textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.flash_on_rounded,
                color: ThemeColors.of(context).textTertiary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Column(
            children: actions.asMap().entries.map((entry) {
              final index = entry.key;
              final action = entry.value;
              return _buildActionItem(context, action, isFirst: index == 0);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, QuickAction action, {bool isFirst = false}) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: ThemeColors.of(context).transparent,
        child: InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 14 : 16,
              vertical: isMobile ? 12 : 14,
            ),
            decoration: BoxDecoration(
              color: action.isUrgent
                  ? action.color.withValues(alpha: 0.12)
                  : ThemeColors.of(context).backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: action.isUrgent
                    ? action.color.withValues(alpha: 0.4)
                    : ThemeColors.of(context).border,
                width: action.isUrgent ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: action.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(action.icon, color: action.color, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        action.label,
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 15,
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.of(context).textPrimary,
                        ),
                      ),
                      if (action.subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          action.subtitle!,
                          style: TextStyle(
                            fontSize: isMobile ? 11 : 12,
                            color: ThemeColors.of(context).textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (action.badge != null && action.badge! > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: action.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${action.badge}',
                      style: TextStyle(
                        color: action.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ThemeColors.of(context).textTertiary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
