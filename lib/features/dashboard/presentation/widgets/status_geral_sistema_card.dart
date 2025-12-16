import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

/// BLOCO 1: Status Geral do Sistema
/// Mostra o estado geral do sistema em um único olhar
class StatusGeralSistemaCard extends ConsumerWidget {
  final VoidCallback? onForcarSincronizacao;
  final VoidCallback? onVerTagsOffline;
  final VoidCallback? onCorrigirProdutos;
  final VoidCallback? onVerErpStatus;

  const StatusGeralSistemaCard({
    super.key,
    this.onForcarSincronizacao,
    this.onVerTagsOffline,
    this.onCorrigirProdutos,
    this.onVerErpStatus,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final dashboardState = ref.watch(dashboardProvider);
    
    // Dados do dashboard
    final storeStats = dashboardState.data.storeStats;
    final syncStatus = dashboardState.data.syncStatus;
    
    final tagsOnline = storeStats.boundTagsCount;
    final tagsTotal = storeStats.tagsCount;
    final tagsPercentage = tagsTotal > 0 ? ((tagsOnline / tagsTotal) * 100).round() : 0;
    final produtosSemPreco = storeStats.productsWithoutPrice;
    final ultimaSync = syncStatus?.lastSync;
    final erpConectado = syncStatus?.isConnected ?? false;

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Row(
            children: [
              Icon(
                Icons.monitor_heart_rounded,
                color: ThemeColors.of(context).greenMaterial,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'STATUS GERAL DO SISTEMA',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Cards de status
          if (isMobile)
            _buildMobileLayout(
              context,
              erpConectado: erpConectado,
              ultimaSync: ultimaSync,
              tagsPercentage: tagsPercentage,
              tagsOnline: tagsOnline,
              tagsTotal: tagsTotal,
              produtosSemPreco: produtosSemPreco,
            )
          else
            _buildDesktopLayout(
              context,
              erpConectado: erpConectado,
              ultimaSync: ultimaSync,
              tagsPercentage: tagsPercentage,
              tagsOnline: tagsOnline,
              tagsTotal: tagsTotal,
              produtosSemPreco: produtosSemPreco,
            ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context, {
    required bool erpConectado,
    required DateTime? ultimaSync,
    required int tagsPercentage,
    required int tagsOnline,
    required int tagsTotal,
    required int produtosSemPreco,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildStatusCard(
          context,
          icon: erpConectado ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
          iconColor: erpConectado ? ThemeColors.of(context).greenMaterial : ThemeColors.of(context).redMain,
          title: erpConectado ? 'Online' : 'Offline',
          subtitle: 'ERP ${erpConectado ? "OK" : "Desconectado"}',
          onTap: onVerErpStatus,
          isMobile: true,
        ),
        _buildStatusCard(
          context,
          icon: Icons.sync_rounded,
          iconColor: ThemeColors.of(context).blueMaterial,
          title: 'Sincronização',
          subtitle: _formatLastSync(ultimaSync),
          actionLabel: 'Forçar',
          onAction: onForcarSincronizacao,
          isMobile: true,
        ),
        _buildStatusCard(
          context,
          icon: Icons.sell_rounded,
          iconColor: tagsPercentage >= 90 ? ThemeColors.of(context).greenMaterial : ThemeColors.of(context).orangeMaterial,
          title: 'Tags',
          subtitle: '$tagsPercentage% Online',
          actionLabel: 'Ver off',
          onAction: onVerTagsOffline,
          isMobile: true,
        ),
        _buildStatusCard(
          context,
          icon: Icons.inventory_2_rounded,
          iconColor: produtosSemPreco > 0 ? ThemeColors.of(context).orangeMaterial : ThemeColors.of(context).greenMaterial,
          title: 'Produtos',
          subtitle: produtosSemPreco > 0 ? '$produtosSemPreco sem preço' : 'Todos OK',
          actionLabel: produtosSemPreco > 0 ? 'Corrigir' : null,
          onAction: produtosSemPreco > 0 ? onCorrigirProdutos : null,
          isMobile: true,
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context, {
    required bool erpConectado,
    required DateTime? ultimaSync,
    required int tagsPercentage,
    required int tagsOnline,
    required int tagsTotal,
    required int produtosSemPreco,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildStatusCard(
              context,
              icon: erpConectado ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
              iconColor: erpConectado ? ThemeColors.of(context).greenMaterial : ThemeColors.of(context).redMain,
              title: erpConectado ? 'Online' : 'Offline',
              subtitle: 'ERP ${erpConectado ? "OK" : "Desconectado"}',
              onTap: onVerErpStatus,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatusCard(
              context,
              icon: Icons.sync_rounded,
              iconColor: ThemeColors.of(context).blueMaterial,
              title: 'Sincronização',
              subtitle: _formatLastSync(ultimaSync),
              actionLabel: 'Forçar',
              onAction: onForcarSincronizacao,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatusCard(
              context,
              icon: Icons.sell_rounded,
              iconColor: tagsPercentage >= 90 ? ThemeColors.of(context).greenMaterial : ThemeColors.of(context).orangeMaterial,
              title: 'Tags',
            subtitle: '$tagsPercentage% Online ($tagsOnline/$tagsTotal)',
            actionLabel: 'Ver offline',
            onAction: onVerTagsOffline,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatusCard(
            context,
            icon: Icons.inventory_2_rounded,
            iconColor: produtosSemPreco > 0 ? ThemeColors.of(context).orangeMaterial : ThemeColors.of(context).greenMaterial,
            title: 'Produtos',
            subtitle: produtosSemPreco > 0 ? '$produtosSemPreco sem preço' : 'Todos com preço',
            actionLabel: produtosSemPreco > 0 ? 'Corrigir' : null,
            onAction: produtosSemPreco > 0 ? onCorrigirProdutos : null,
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onTap,
    bool isMobile = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: isMobile ? null : null,
        constraints: isMobile ? const BoxConstraints(minWidth: 140) : null,
        padding: EdgeInsets.all(isMobile ? 10 : 12),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: iconColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: isMobile ? 18 : 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: isMobile ? 10 : 12,
                color: ThemeColors.of(context).textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 8),
              InkWell(
                onTap: onAction,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    actionLabel,
                    style: TextStyle(
                      fontSize: isMobile ? 10 : 11,
                      fontWeight: FontWeight.w600,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatLastSync(DateTime? lastSync) {
    if (lastSync == null) return 'Nunca';
    
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    
    if (difference.inMinutes < 1) return 'Agora mesmo';
    if (difference.inMinutes < 60) return 'Há ${difference.inMinutes} min';
    if (difference.inHours < 24) return 'Há ${difference.inHours}há';
    return 'Há ${difference.inDays}d';
  }
}




