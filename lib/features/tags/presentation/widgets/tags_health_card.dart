import 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Mãtricas de saãde das tags
class TagsHealthMetrics {
  final double avgBatteryLevel;
  final int criticalBatteryCount;
  final int lowBatteryCount;
  final String avgSignalStrength;
  final int weakSignalCount;
  final DateTime? lastGlobalSync;

  const TagsHealthMetrics({
    this.avgBatteryLevel = 0.0,
    this.criticalBatteryCount = 0,
    this.lowBatteryCount = 0,
    this.avgSignalStrength = 'Bom',
    this.weakSignalCount = 0,
    this.lastGlobalSync,
  });
}

/// Card de saãde das tags (bateria e sinal)
class TagsHealthCard extends StatelessWidget {
  final TagsHealthMetrics metrics;
  final VoidCallback? onBatteryTap;
  final VoidCallback? onSignalTap;

  const TagsHealthCard({
    super.key,
    required this.metrics,
    this.onBatteryTap,
    this.onSignalTap,
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
                Icons.monitor_heart_rounded,
                color: ThemeColors.of(context).brandPrimaryGreen,
                size: isMobile ? 20 : 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Saãde das Tags',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Bateria
          _buildHealthItem(
            context: context,
            icon: Icons.battery_std_rounded,
            label: 'Bateria Mãdia',
            value: '${metrics.avgBatteryLevel.toStringAsFixed(0)}%',
            progress: metrics.avgBatteryLevel / 100,
            progressColor: _getBatteryColor(context, metrics.avgBatteryLevel),
            subtitle: metrics.criticalBatteryCount > 0
                ? '${metrics.criticalBatteryCount} crãticas (<5%)'
                : metrics.lowBatteryCount > 0
                    ? '${metrics.lowBatteryCount} baixas (<20%)'
                    : 'Todas com boa carga',
            subtitleColor: metrics.criticalBatteryCount > 0
                ? ThemeColors.of(context).error
                : metrics.lowBatteryCount > 0
                    ? ThemeColors.of(context).orangeMaterial
                    : ThemeColors.of(context).success,
            onTap: onBatteryTap,
            isMobile: isMobile,
          ),

          const SizedBox(height: 12),

          // Sinal
          _buildHealthItem(
            context: context,
            icon: Icons.signal_cellular_alt_rounded,
            label: 'Qualidade do Sinal',
            value: metrics.avgSignalStrength,
            progress: _getSignalProgress(metrics.avgSignalStrength),
            progressColor: _getSignalColor(context, metrics.avgSignalStrength),
            subtitle: metrics.weakSignalCount > 0
                ? '${metrics.weakSignalCount} com sinal fraco'
                : 'Todas com bom sinal',
            subtitleColor: metrics.weakSignalCount > 0
                ? ThemeColors.of(context).orangeMaterial
                : ThemeColors.of(context).success,
            onTap: onSignalTap,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required double progress,
    required Color progressColor,
    required String subtitle,
    required Color subtitleColor,
    required bool isMobile,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 12 : 14),
        decoration: BoxDecoration(
          color: progressColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: progressColor.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: progressColor, size: isMobile ? 18 : 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 14,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.of(context).textPrimary,
                    ),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: progressColor.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: subtitleColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    color: subtitleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getBatteryColor(BuildContext context, double level) {
    if (level < 20) return ThemeColors.of(context).error;
    if (level < 50) return ThemeColors.of(context).orangeMaterial;
    return ThemeColors.of(context).success;
  }

  double _getSignalProgress(String strength) {
    switch (strength.toLowerCase()) {
      case 'excelente':
        return 1.0;
      case 'bom':
        return 0.75;
      case 'regular':
        return 0.5;
      case 'fraco':
        return 0.25;
      default:
        return 0.5;
    }
  }

  Color _getSignalColor(BuildContext context, String strength) {
    switch (strength.toLowerCase()) {
      case 'excelente':
        return ThemeColors.of(context).success;
      case 'bom':
        return ThemeColors.of(context).primary;
      case 'regular':
        return ThemeColors.of(context).orangeMaterial;
      case 'fraco':
        return ThemeColors.of(context).error;
      default:
        return ThemeColors.of(context).primary;
    }
  }
}





