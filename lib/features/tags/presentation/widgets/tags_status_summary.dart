import 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Item de estat�stica para o resumo
class TagsStatItem {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const TagsStatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });
}

/// Card de resumo de status das tags (similar ao ProductsStatusSummary)
class TagsStatusSummary extends StatelessWidget {
  final int totalTags;
  final int vinculadas;
  final int livres;
  final int offline;
  final int bateriaBaixa;
  final VoidCallback? onTotalTap;
  final VoidCallback? onVinculadasTap;
  final VoidCallback? onLivresTap;
  final VoidCallback? onOfflineTap;
  final VoidCallback? onBateriaTap;

  const TagsStatusSummary({
    super.key,
    this.totalTags = 0,
    this.vinculadas = 0,
    this.livres = 0,
    this.offline = 0,
    this.bateriaBaixa = 0,
    this.onTotalTap,
    this.onVinculadasTap,
    this.onLivresTap,
    this.onOfflineTap,
    this.onBateriaTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    final stats = [
      TagsStatItem(
        label: 'Total',
        value: totalTags,
        icon: Icons.nfc_rounded,
        color: ThemeColors.of(context).brandPrimaryGreen,
        onTap: onTotalTap,
      ),
      TagsStatItem(
        label: 'Vinculadas',
        value: vinculadas,
        icon: Icons.link_rounded,
        color: ThemeColors.of(context).success,
        onTap: onVinculadasTap,
      ),
      TagsStatItem(
        label: 'Livres',
        value: livres,
        icon: Icons.link_off_rounded,
        color: ThemeColors.of(context).orangeMaterial,
        onTap: onLivresTap,
      ),
      TagsStatItem(
        label: 'Offline',
        value: offline,
        icon: Icons.cloud_off_rounded,
        color: ThemeColors.of(context).textSecondary,
        onTap: onOfflineTap,
      ),
      TagsStatItem(
        label: 'Bateria Baixa',
        value: bateriaBaixa,
        icon: Icons.battery_alert_rounded,
        color: ThemeColors.of(context).error,
        onTap: onBateriaTap,
      ),
    ];

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
                Icons.pie_chart_rounded,
                color: ThemeColors.of(context).brandPrimaryGreen,
                size: isMobile ? 20 : 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Resumo das Tags',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Grid de stats
          isMobile
              ? _buildMobileGrid(stats, context)
              : isTablet
                  ? _buildTabletGrid(stats, context)
                  : _buildDesktopGrid(stats, context),
        ],
      ),
    );
  }

  Widget _buildMobileGrid(List<TagsStatItem> stats, BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: stats.map((stat) => _buildStatCard(context, stat, true)).toList(),
    );
  }

  Widget _buildTabletGrid(List<TagsStatItem> stats, BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: stats.map((stat) => _buildStatCard(context, stat, false)).toList(),
    );
  }

  Widget _buildDesktopGrid(List<TagsStatItem> stats, BuildContext context) {
    return Row(
      children: stats.map((stat) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: _buildStatCard(context, stat, false),
        ),
      )).toList(),
    );
  }

  Widget _buildStatCard(BuildContext context, TagsStatItem stat, bool isMobile) {
    return Material(
      color: ThemeColors.of(context).transparent,
      child: InkWell(
        onTap: stat.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: isMobile ? null : null,
          constraints: BoxConstraints(
            minWidth: isMobile ? 85 : 100,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10 : 12,
            vertical: isMobile ? 12 : 14,
          ),
          decoration: BoxDecoration(
            color: stat.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: stat.color.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 6 : 8),
                decoration: BoxDecoration(
                  color: stat.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  stat.icon,
                  color: stat.color,
                  size: isMobile ? 16 : 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                stat.value.toString(),
                style: TextStyle(
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  color: stat.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isMobile ? 10 : 11,
                  color: ThemeColors.of(context).textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






