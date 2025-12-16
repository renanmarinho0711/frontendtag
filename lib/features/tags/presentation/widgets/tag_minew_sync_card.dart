import 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/tags/data/models/tag_model.dart';

/// Estat�sticas de sincroniza��o Minew das tags
class MinewSyncStats {
  final int totalTags;
  final int synced;
  final int pending;
  final int errors;
  final int online;
  final int offline;
  final DateTime? lastGlobalSync;

  const MinewSyncStats({
    this.totalTags = 0,
    this.synced = 0,
    this.pending = 0,
    this.errors = 0,
    this.online = 0,
    this.offline = 0,
    this.lastGlobalSync,
  });

  /// Percentual sincronizado
  double get syncPercentage => totalTags > 0 ? (synced / totalTags) * 100 : 0;

  /// Percentual online
  double get onlinePercentage => totalTags > 0 ? (online / totalTags) * 100 : 0;

  /// Tem tags com erro
  bool get hasErrors => errors > 0;

  /// Tem tags pendentes
  bool get hasPending => pending > 0;

  /// Cria a partir de uma lista de tags
  factory MinewSyncStats.fromTags(List<TagModel> tags) {
    int synced = 0;
    int pending = 0;
    int errors = 0;
    int online = 0;
    int offline = 0;
    DateTime? lastSync;

    for (final tag in tags) {
      // Contagem por status de sincroniza��o
      switch (tag.minewSyncStatus) {
        case 'synced':
          synced++;
          break;
        case 'pending':
          pending++;
          break;
        case 'error':
          errors++;
          break;
      }

      // Contagem por status online
      if (tag.isOnline) {
        online++;
      } else {
        offline++;
      }

      // Encontrar �ltima sincroniza��o
      if (tag.lastSync != null) {
        if (lastSync == null || tag.lastSync!.isAfter(lastSync)) {
          lastSync = tag.lastSync;
        }
      }
    }

    return MinewSyncStats(
      totalTags: tags.length,
      synced: synced,
      pending: pending,
      errors: errors,
      online: online,
      offline: offline,
      lastGlobalSync: lastSync,
    );
  }
}

/// Card para exibir status de sincroniza��o Minew das tags
class TagMinewSyncCard extends StatelessWidget {
  final MinewSyncStats stats;
  final bool isSyncing;
  final VoidCallback? onSyncAll;
  final VoidCallback? onViewErrors;
  final VoidCallback? onViewPending;

  const TagMinewSyncCard({
    super.key,
    required this.stats,
    this.isSyncing = false,
    this.onSyncAll,
    this.onViewErrors,
    this.onViewPending,
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.cloud_sync_rounded,
                  color: ThemeColors.of(context).brandPrimaryGreen,
                  size: isMobile ? 20 : 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sincroniza��o Minew',
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).textPrimary,
                      ),
                    ),
                    if (stats.lastGlobalSync != null)
                      Text(
                        'Última: ${_formatLastSync(stats.lastGlobalSync!)}',
                        style: TextStyle(
                          fontSize: isMobile ? 11 : 12,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              if (onSyncAll != null)
                ElevatedButton.icon(
                  onPressed: isSyncing ? null : onSyncAll,
                  icon: isSyncing
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ThemeColors.of(context).surface,
                          ),
                        )
                      : Icon(Icons.sync_rounded, size: 18),
                  label: Text(isSyncing ? 'Sincronizando...' : 'Sincronizar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
                    foregroundColor: ThemeColors.of(context).surface,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 16,
                      vertical: 8,
                    ),
                    textStyle: TextStyle(
                      fontSize: isMobile ? 12 : 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress bar geral
          _buildProgressSection(context, isMobile),

          const SizedBox(height: 16),

          // Status cards
          Row(
            children: [
              Expanded(
                child: _buildStatusItem(
                  context,
                  icon: Icons.check_circle_rounded,
                  label: 'Sincronizadas',
                  value: stats.synced.toString(),
                  color: ThemeColors.of(context).success,
                  isMobile: isMobile,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusItem(
                  context,
                  icon: Icons.wifi_rounded,
                  label: 'Online',
                  value: stats.online.toString(),
                  color: ThemeColors.of(context).primary,
                  isMobile: isMobile,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStatusItem(
                  context,
                  icon: Icons.schedule_rounded,
                  label: 'Pendentes',
                  value: stats.pending.toString(),
                  color: ThemeColors.of(context).orangeMaterial,
                  isMobile: isMobile,
                  onTap: stats.hasPending ? onViewPending : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusItem(
                  context,
                  icon: Icons.error_rounded,
                  label: 'Erros',
                  value: stats.errors.toString(),
                  color: ThemeColors.of(context).error,
                  isMobile: isMobile,
                  onTap: stats.hasErrors ? onViewErrors : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progresso de Sincroniza��o',
              style: TextStyle(
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w500,
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
            Text(
              '${stats.syncPercentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.bold,
                color: _getSyncProgressColor(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: stats.syncPercentage / 100,
            backgroundColor: ThemeColors.of(context).grey300,
            valueColor: AlwaysStoppedAnimation<Color>(_getSyncProgressColor(context)),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isMobile,
    VoidCallback? onTap,
  }) {
    final content = Container(
      padding: EdgeInsets.all(isMobile ? 12 : 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: isMobile ? 20 : 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.chevron_right_rounded,
              color: ThemeColors.of(context).textSecondary,
              size: 20,
            ),
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: ThemeColors.of(context).transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: content,
        ),
      );
    }

    return content;
  }

  Color _getSyncProgressColor(BuildContext context) {
    if (stats.hasErrors) return ThemeColors.of(context).error;
    if (stats.syncPercentage >= 90) return ThemeColors.of(context).success;
    if (stats.syncPercentage >= 50) return ThemeColors.of(context).orangeMaterial;
    return ThemeColors.of(context).error;
  }

  String _formatLastSync(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Agora';
    if (diff.inMinutes < 60) return 'h� ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'h� ${diff.inHours}h�';
    if (diff.inDays < 7) return 'h� ${diff.inDays} dias';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

/// Widget para exibir status de uma tag individual
class TagSyncStatusBadge extends StatelessWidget {
  final String? minewSyncStatus;
  final bool isOnline;
  final DateTime? lastSeen;
  final bool compact;

  const TagSyncStatusBadge({
    super.key,
    this.minewSyncStatus,
    this.isOnline = false,
    this.lastSeen,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(context);
    final icon = _getStatusIcon();
    final label = _getStatusLabel();

    if (compact) {
      return Tooltip(
        message: label,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    if (minewSyncStatus == 'error') return ThemeColors.of(context).error;
    if (minewSyncStatus == 'pending') return ThemeColors.of(context).orangeMaterial;
    if (!isOnline) return ThemeColors.of(context).textSecondary;
    if (minewSyncStatus == 'synced') return ThemeColors.of(context).success;
    return ThemeColors.of(context).primary;
  }

  IconData _getStatusIcon() {
    if (minewSyncStatus == 'error') return Icons.error_rounded;
    if (minewSyncStatus == 'pending') return Icons.schedule_rounded;
    if (!isOnline) return Icons.cloud_off_rounded;
    if (minewSyncStatus == 'synced') return Icons.check_circle_rounded;
    return Icons.help_outline_rounded;
  }

  String _getStatusLabel() {
    if (minewSyncStatus == 'error') return 'Erro';
    if (minewSyncStatus == 'pending') return 'Pendente';
    if (!isOnline) return 'Offline';
    if (minewSyncStatus == 'synced') return 'Sincronizado';
    return 'Desconhecido';
  }
}

/// Widget para exibir informa��es de temperatura da tag
class TagTemperatureIndicator extends StatelessWidget {
  final int? temperature;
  final bool compact;

  const TagTemperatureIndicator({
    super.key,
    this.temperature,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (temperature == null) {
      return const SizedBox.shrink();
    }

    final color = _getTemperatureColor(context);
    final icon = _getTemperatureIcon();

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 2),
          Text(
            '$temperature°C',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            '$temperature°C',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  Color _getTemperatureColor(BuildContext context) {
    if (temperature == null) return ThemeColors.of(context).textSecondary;
    if (temperature! < 0) return ThemeColors.of(context).primary; // Muito frio
    if (temperature! < 10) return ThemeColors.of(context).cyanMain; // Frio
    if (temperature! < 30) return ThemeColors.of(context).success; // Normal
    if (temperature! < 40) return ThemeColors.of(context).orangeMain; // Quente
    return ThemeColors.of(context).errorDark; // Muito quente
  }

  IconData _getTemperatureIcon() {
    if (temperature == null) return Icons.device_thermostat_rounded;
    if (temperature! < 10) return Icons.ac_unit_rounded;
    if (temperature! < 30) return Icons.thermostat_rounded;
    return Icons.local_fire_department_rounded;
  }
}






