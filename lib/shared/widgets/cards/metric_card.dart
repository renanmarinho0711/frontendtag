mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Card de mtrica para dashboards
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool isPositiveTrend;
  final VoidCallback? onTap;
  final bool isCompact;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
    this.trend,
    this.isPositiveTrend = true,
    this.onTap,
    this.isCompact = false,
  });

  /// Factory para mtrica de produtos
  factory MetricCard.products({
    required String count,
    String? subtitle,
    VoidCallback? onTap,
    bool isCompact = false,
  }) =>
      MetricCard(
        title: 'Produtos',
        value: count,
        subtitle: subtitle,
        icon: Icons.inventory_2_outlined,
        color: ThemeColors.of(context).blueMaterial,
        onTap: onTap,
        isCompact: isCompact,
      );

  /// Factory para mtrica de tags
  factory MetricCard.tags({
    required String count,
    String? subtitle,
    VoidCallback? onTap,
    bool isCompact = false,
  }) =>
      MetricCard(
        title: 'Tags',
        value: count,
        subtitle: subtitle,
        icon: Icons.nfc_outlined,
        color: ThemeColors.of(context).greenMaterial,
        onTap: onTap,
        isCompact: isCompact,
      );

  /// Factory para mtrica de lucro
  factory MetricCard.profit({
    required String value,
    String? trend,
    bool isPositiveTrend = true,
    VoidCallback? onTap,
    bool isCompact = false,
  }) =>
      MetricCard(
        title: 'Lucro',
        value: value,
        icon: Icons.trending_up_outlined,
        color: ThemeColors.of(context).orangeMaterial,
        trend: trend,
        isPositiveTrend: isPositiveTrend,
        onTap: onTap,
        isCompact: isCompact,
      );

  /// Factory para mtrica de margem
  factory MetricCard.margin({
    required String value,
    String? trend,
    bool isPositiveTrend = true,
    VoidCallback? onTap,
    bool isCompact = false,
  }) =>
      MetricCard(
        title: 'Margem',
        value: value,
        icon: Icons.percent_outlined,
        color: ThemeColors.of(context).blueCyan,
        trend: trend,
        isPositiveTrend: isPositiveTrend,
        onTap: onTap,
        isCompact: isCompact,
      );

  /// Factory para mtrica de vendas
  factory MetricCard.sales({
    required String value,
    String? trend,
    bool isPositiveTrend = true,
    VoidCallback? onTap,
    bool isCompact = false,
  }) =>
      MetricCard(
        title: 'Vendas',
        value: value,
        icon: Icons.shopping_cart_outlined,
        color: ThemeColors.of(context).materialTeal,
        trend: trend,
        isPositiveTrend: isPositiveTrend,
        onTap: onTap,
        isCompact: isCompact,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isCompact) {
      return _buildCompact(context, theme);
    }

    return _buildFull(context, theme);
  }

  Widget _buildFull(BuildContext context, ThemeData theme) {
    return Material(
      color: ThemeColors.of(context).transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ThemeColors.of(context).grey200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.alphaBlend(color.withValues(alpha: 0.1), ThemeColors.of(context).surface),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 24, color: color),
                  ),
                  const Spacer(),
                  if (onTap != null)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: ThemeColors.of(context).grey400,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: ThemeColors.of(context).grey600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null || trend != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (trend != null) ...[
                      Icon(
                        isPositiveTrend
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 14,
                        color: isPositiveTrend ? ThemeColors.of(context).greenMaterial : ThemeColors.of(context).redMain,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trend!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isPositiveTrend ? ThemeColors.of(context).greenMaterial : ThemeColors.of(context).redMain,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (subtitle != null) ...[
                      if (trend != null) const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ThemeColors.of(context).grey500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompact(BuildContext context, ThemeData theme) {
    return Material(
      color: ThemeColors.of(context).transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Color.alphaBlend(ThemeColors.of(context).surface.withValues(alpha: 0.9), color),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: ThemeColors.of(context).grey600,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Grid de mtricas compactas
class MetricCardGrid extends StatelessWidget {
  final List<MetricCard> metrics;
  final int crossAxisCount;
  final double spacing;

  const MetricCardGrid({
    super.key,
    required this.metrics,
    this.crossAxisCount = 2,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.5,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) => metrics[index],
    );
  }
}





