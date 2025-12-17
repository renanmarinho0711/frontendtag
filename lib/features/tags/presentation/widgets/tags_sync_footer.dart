import 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Status de sincronização das tags
enum TagsSyncStatus {
  syncing,
  synced,
  error,
  offline,
}

/// Footer de sincronização das tags
class TagsSyncFooter extends StatelessWidget {
  final TagsSyncStatus status;
  final DateTime? lastSync;
  final int? pendingCount;
  final VoidCallback? onSyncTap;
  final bool isSyncing;

  const TagsSyncFooter({
    super.key,
    required this.status,
    this.lastSync,
    this.pendingCount,
    this.onSyncTap,
    this.isSyncing = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final statusColor = _getStatusColor(context);
    final statusIcon = _getStatusIcon();
    final statusText = _getStatusText();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 20,
        vertical: isMobile ? 12 : 14,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // ícone de status
          if (isSyncing)
            SizedBox(
              width: isMobile ? 18 : 20,
              height: isMobile ? 18 : 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            )
          else
            Icon(
              statusIcon,
              color: statusColor,
              size: isMobile ? 18 : 20,
            ),
          const SizedBox(width: 10),

          // Texto de status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 13,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
                if (lastSync != null && status == TagsSyncStatus.synced)
                  Text(
                    'Última sincronização: ${_formatLastSync(lastSync!)}',
                    style: TextStyle(
                      fontSize: isMobile ? 10 : 11,
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
              ],
            ),
          ),

          // Badge de pendentes
          if (pendingCount != null && pendingCount! > 0 && !isSyncing)
            Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).orangeMaterial.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.pending_outlined,
                    size: isMobile ? 12 : 14,
                    color: ThemeColors.of(context).orangeMaterial,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$pendingCount pendentes',
                    style: TextStyle(
                      fontSize: isMobile ? 10 : 11,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.of(context).orangeMaterial,
                    ),
                  ),
                ],
              ),
            ),

          // Botão de sincronizar
          if (onSyncTap != null && !isSyncing)
            InkWell(
              onTap: onSyncTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 14,
                  vertical: isMobile ? 6 : 8,
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).brandPrimaryGreen,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sync_rounded,
                      color: ThemeColors.of(context).surface,
                      size: isMobile ? 14 : 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Sincronizar',
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 12,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.of(context).surface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    switch (status) {
      case TagsSyncStatus.syncing:
        return ThemeColors.of(context).primary;
      case TagsSyncStatus.synced:
        return ThemeColors.of(context).success;
      case TagsSyncStatus.error:
        return ThemeColors.of(context).error;
      case TagsSyncStatus.offline:
        return ThemeColors.of(context).textSecondary;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case TagsSyncStatus.syncing:
        return Icons.sync_rounded;
      case TagsSyncStatus.synced:
        return Icons.cloud_done_rounded;
      case TagsSyncStatus.error:
        return Icons.cloud_off_rounded;
      case TagsSyncStatus.offline:
        return Icons.wifi_off_rounded;
    }
  }

  String _getStatusText() {
    switch (status) {
      case TagsSyncStatus.syncing:
        return 'Sincronizando tags...';
      case TagsSyncStatus.synced:
        return 'Tags sincronizadas';
      case TagsSyncStatus.error:
        return 'Erro na sincronização';
      case TagsSyncStatus.offline:
        return 'Sem conexão';
    }
  }

  String _formatLastSync(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Agora mesmo';
    if (difference.inMinutes < 60) return 'hã ${difference.inMinutes} min';
    if (difference.inHours < 24) return 'hã ${difference.inHours}hã';
    if (difference.inDays == 1) return 'Ontem';
    return '${dateTime.day}/${dateTime.month} às ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}




