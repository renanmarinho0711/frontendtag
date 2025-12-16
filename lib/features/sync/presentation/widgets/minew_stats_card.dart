import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/features/sync/data/models/sync_models.dart';
import 'package:tagbean/features/sync/presentation/providers/sync_provider.dart';
import 'package:tagbean/features/sync/presentation/widgets/sync_card.dart';
import 'package:tagbean/features/sync/presentation/widgets/sync_stat_item.dart';

/// Card dedicado para exibição de estatísticas Minew Cloud.
/// Inclui stats em tempo real, botões de ação e refresh.
class MinewStatsCard extends ConsumerWidget {
  final String storeId;
  final VoidCallback? onSyncComplete;
  final VoidCallback? onImportTags;

  const MinewStatsCard({
    super.key,
    required this.storeId,
    this.onSyncComplete,
    this.onImportTags,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isSyncing = ref.watch(isSyncingProvider);
    final minewStatsAsync = ref.watch(minewStoreStatsProvider(storeId));

    return SyncSectionCard(
      title: 'Minew Cloud',
      subtitle: 'Status em tempo real',
      icon: Icons.cloud_sync_rounded,
      iconGradient: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],
      borderColor: ThemeColors.of(context).primary.withValues(alpha: 0.3),
      trailing: IconButton(
        onPressed: () {
          ref.read(minewStatsRefreshProvider.notifier).state++;
        },
        icon: Icon(
          Icons.refresh_rounded,
          color: ThemeColors.of(context).primary,
          size: AppSizes.iconSmall.get(isMobile, isTablet),
        ),
        tooltip: 'Atualizar estatísticas',
      ),
      child: Column(
        children: [
          // Stats Grid
          minewStatsAsync.when(
            data: (stats) {
              if (stats == null) {
                return const SyncStatsError(error: 'Nenhum dado disponível');
              }
              return _buildStatsGrid(stats);
            },
            loading: () => const SyncStatsLoading(message: 'Carregando estatísticas...'),
            error: (error, _) => SyncStatsError(
              error: error.toString(),
              onRetry: () => ref.read(minewStatsRefreshProvider.notifier).state++,
            ),
          ),
          SizedBox(height: AppSizes.spacingMd.get(isMobile, isTablet)),
          // Action buttons
          _buildActions(context, ref, isSyncing, isMobile, isTablet),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(MinewStoreStats stats) {
    return SyncStatsGrid(
      items: [
        SyncStatItemData(
          value: '${stats.totalTags}',
          label: 'Total Tags',
          icon: Icons.sell_rounded,
          color: ThemeColors.of(context).primary,
        ),
        SyncStatItemData(
          value: '${stats.onlineTags}',
          label: 'Online',
          icon: Icons.wifi_rounded,
          color: ThemeColors.of(context).success,
        ),
        SyncStatItemData(
          value: '${stats.boundTags}',
          label: 'Vinculadas',
          icon: Icons.link_rounded,
          color: ThemeColors.of(context).materialTeal,
        ),
        SyncStatItemData(
          value: '${stats.totalGateways}',
          label: 'Gateways',
          icon: Icons.router_rounded,
          color: ThemeColors.of(context).materialPurple,
        ),
        SyncStatItemData(
          value: '${stats.onlineGateways}',
          label: 'GW Online',
          icon: Icons.signal_wifi_4_bar_rounded,
          color: ThemeColors.of(context).success,
        ),
        SyncStatItemData(
          value: '${stats.lowBatteryTags}',
          label: 'Bat. Baixa',
          icon: Icons.battery_alert_rounded,
          color: ThemeColors.of(context).warning,
        ),
      ],
    );
  }

  Widget _buildActions(
    BuildContext context,
    WidgetRef ref,
    bool isSyncing,
    bool isMobile,
    bool isTablet,
  ) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isSyncing ? null : onSyncComplete,
            icon: Icon(
              Icons.cloud_sync_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            label: Text(
              'Sync Minew',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 12,
                  mobileFontSize: 11,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).primary,
              foregroundColor: ThemeColors.of(context).surface,
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isSyncing ? null : onImportTags,
            icon: Icon(
              Icons.download_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            label: Text(
              'Importar Tags',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 12,
                  mobileFontSize: 11,
                ),
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: ThemeColors.of(context).primary,
              side: BorderSide(color: ThemeColors.of(context).primary),
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

