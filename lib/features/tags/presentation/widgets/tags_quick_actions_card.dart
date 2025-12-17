import 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Ação rãpida para tags
class TagQuickAction {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final int? badgeCount;
  final VoidCallback onTap;

  const TagQuickAction({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    this.badgeCount,
    required this.onTap,
  });
}

/// Card de ações Rápidas para tags
class TagsQuickActionsCard extends StatelessWidget {
  final List<TagQuickAction> actions;

  const TagsQuickActionsCard({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
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
                Icons.touch_app_rounded,
                color: ThemeColors.of(context).brandPrimaryGreen,
                size: isMobile ? 20 : 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Ações Rápidas',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Grid de ações
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: actions.map((action) => _buildActionButton(
              context: context,
              action: action,
              isMobile: isMobile,
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required TagQuickAction action,
    required bool isMobile,
  }) {
    return Material(
      color: ThemeColors.of(context).transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: isMobile ? 100 : 110,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 14,
            vertical: isMobile ? 14 : 16,
          ),
          decoration: BoxDecoration(
            color: action.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: action.color.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(isMobile ? 10 : 12),
                    decoration: BoxDecoration(
                      color: action.color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      action.icon,
                      color: action.color,
                      size: isMobile ? 22 : 24,
                    ),
                  ),
                  if (action.badgeCount != null && action.badgeCount! > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).error,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: ThemeColors.of(context).error.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          action.badgeCount! > 99 
                              ? '99+' 
                              : action.badgeCount.toString(),
                          style: TextStyle(
                            color: ThemeColors.of(context).surface,
                            fontSize: isMobile ? 10 : 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                action.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isMobile ? 11 : 12,
                  fontWeight: FontWeight.w600,
                  color: ThemeColors.of(context).textPrimary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





