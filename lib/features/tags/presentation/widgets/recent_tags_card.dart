import 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Status de uma tag recente
enum RecentTagStatus {
  vinculada,
  desvinculada,
  offline,
  bateriaBaixa,
}

/// Tag recente para exibi��o
class RecentTagItem {
  final String id;
  final String nfcId;
  final String? productName;
  final String? productSku;
  final RecentTagStatus status;
  final DateTime lastSync;
  final int? batteryLevel;

  const RecentTagItem({
    required this.id,
    required this.nfcId,
    this.productName,
    this.productSku,
    required this.status,
    required this.lastSync,
    this.batteryLevel,
  });
}

/// Card de tags recentes
class RecentTagsCard extends StatelessWidget {
  final List<RecentTagItem> recentTags;
  final VoidCallback? onViewAll;
  final void Function(RecentTagItem tag)? onTagTap;

  const RecentTagsCard({
    super.key,
    required this.recentTags,
    this.onViewAll,
    this.onTagTap,
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
                Icons.history_rounded,
                color: ThemeColors.of(context).brandPrimaryGreen,
                size: isMobile ? 20 : 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tags Recentes',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                ),
              ),
              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    'Ver todas',
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 13,
                      color: ThemeColors.of(context).brandPrimaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Lista de tags
          if (recentTags.isEmpty)
            _buildEmptyState(isMobile)
          else
            ...recentTags.take(5).map((tag) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildTagItem(context, tag, isMobile),
            )),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isMobile) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(
              Icons.nfc_rounded,
              color: ThemeColors.of(context).textSecondary,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhuma tag recente',
              style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagItem(BuildContext context, RecentTagItem tag, bool isMobile) {
    final statusColor = _getStatusColor(context, tag.status);
    final statusLabel = _getStatusLabel(tag.status);

    return Material(
      color: ThemeColors.of(context).transparent,
      child: InkWell(
        onTap: onTagTap != null ? () => onTagTap!(tag) : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 10 : 12),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: statusColor.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              // �cone NFC
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.nfc_rounded,
                  color: statusColor,
                  size: isMobile ? 18 : 20,
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            tag.nfcId,
                            style: TextStyle(
                              fontSize: isMobile ? 12 : 13,
                              fontWeight: FontWeight.w600,
                              color: ThemeColors.of(context).textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(
                              fontSize: isMobile ? 9 : 10,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tag.productName ?? 'Sem produto vinculado',
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 12,
                        color: tag.productName != null
                            ? ThemeColors.of(context).textSecondary
                            : ThemeColors.of(context).textTertiary,
                        fontStyle: tag.productName == null
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Bateria e tempo
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (tag.batteryLevel != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getBatteryIcon(tag.batteryLevel!),
                          color: _getBatteryColor(context, tag.batteryLevel!),
                          size: isMobile ? 14 : 16,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${tag.batteryLevel}%',
                          style: TextStyle(
                            fontSize: isMobile ? 10 : 11,
                            fontWeight: FontWeight.w600,
                            color: _getBatteryColor(context, tag.batteryLevel!),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  Text(
                    _getTimeAgo(tag.lastSync),
                    style: TextStyle(
                      fontSize: isMobile ? 9 : 10,
                      color: ThemeColors.of(context).textTertiary,
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

  Color _getStatusColor(BuildContext context, RecentTagStatus status) {
    switch (status) {
      case RecentTagStatus.vinculada:
        return ThemeColors.of(context).success;
      case RecentTagStatus.desvinculada:
        return ThemeColors.of(context).orangeMaterial;
      case RecentTagStatus.offline:
        return ThemeColors.of(context).textSecondary;
      case RecentTagStatus.bateriaBaixa:
        return ThemeColors.of(context).error;
    }
  }

  String _getStatusLabel(RecentTagStatus status) {
    switch (status) {
      case RecentTagStatus.vinculada:
        return 'VINCULADA';
      case RecentTagStatus.desvinculada:
        return 'LIVRE';
      case RecentTagStatus.offline:
        return 'OFFLINE';
      case RecentTagStatus.bateriaBaixa:
        return 'BATERIA';
    }
  }

  IconData _getBatteryIcon(int level) {
    if (level <= 10) return Icons.battery_alert_rounded;
    if (level <= 30) return Icons.battery_2_bar_rounded;
    if (level <= 50) return Icons.battery_4_bar_rounded;
    if (level <= 80) return Icons.battery_5_bar_rounded;
    return Icons.battery_full_rounded;
  }

  Color _getBatteryColor(BuildContext context, int level) {
    if (level <= 10) return ThemeColors.of(context).error;
    if (level <= 30) return ThemeColors.of(context).orangeMaterial;
    return ThemeColors.of(context).success;
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Agora';
    if (difference.inMinutes < 60) return '${difference.inMinutes}min atr�s';
    if (difference.inHours < 24) return '${difference.inHours}h� atr�s';
    if (difference.inDays < 7) return '${difference.inDays}d atr�s';
    return '${dateTime.day}/${dateTime.month}';
  }
}







