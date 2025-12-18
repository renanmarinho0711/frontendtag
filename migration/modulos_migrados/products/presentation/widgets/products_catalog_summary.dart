import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';

class CatalogStat {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isWarning;
  final String? trend;

  CatalogStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
    this.isWarning = false,
    this.trend,
  });
}

class ProductsCatalogSummary extends StatelessWidget {
  final List<CatalogStat> stats;

  const ProductsCatalogSummary({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    // ignore: unused_local_variable
    final isTablet = ResponsiveHelper.isTablet(context);

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
              Text(
                'Visão Geral',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).textPrimary,
                ),
              ),
              Icon(
                Icons.insights_rounded,
                color: ThemeColors.of(context).textTertiary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildStatsGrid(context),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final crossAxisCount = isMobile ? 3 : (isTablet ? 3 : 6);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: isMobile ? 0.75 : 1.0,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => _buildStatCard(context, stats[index]),
    );
  }

  Widget _buildStatCard(BuildContext context, CatalogStat stat) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Material(
      color: ThemeColors.of(context).transparent,
      child: InkWell(
        onTap: stat.onTap,
        borderRadius: BorderRadius.circular(16),
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 600),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: 0.9 + (0.1 * value),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Container(
            padding: EdgeInsets.all(isMobile ? 8 : 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.alphaBlend(stat.color.withValues(alpha: 0.12), ThemeColors.of(context).surface),
                  Color.alphaBlend(stat.color.withValues(alpha: 0.04), ThemeColors.of(context).surface),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: stat.isWarning
                    ? Color.alphaBlend(stat.color.withValues(alpha: 0.5), ThemeColors.of(context).surface)
                    : Color.alphaBlend(stat.color.withValues(alpha: 0.25), ThemeColors.of(context).surface),
                width: stat.isWarning ? 2 : 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 2,
                  child: Icon(stat.icon, color: stat.color, size: isMobile ? 14 : 18),
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Flexible(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      stat.value,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 16,
                        fontWeight: FontWeight.bold,
                        color: stat.color,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 1 : 2),
                Flexible(
                  flex: 1,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      stat.label,
                      style: TextStyle(
                        fontSize: isMobile ? 8 : 10,
                        color: ThemeColors.of(context).textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

