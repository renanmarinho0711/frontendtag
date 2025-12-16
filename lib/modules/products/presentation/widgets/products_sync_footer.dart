mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
class ProductsSyncFooter extends StatelessWidget {
  final DateTime? lastSync;
  final bool isOnline;
  final bool isSyncing;
  final VoidCallback onSync;

  const ProductsSyncFooter({
    super.key,
    this.lastSync,
    this.isOnline = true,
    this.isSyncing = false,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 16, tablet: 20, desktop: 24),
        vertical: 8,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 16, tablet: 20, desktop: 24),
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        border: Border.all(color: ThemeColors.of(context).border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: isOnline
                  ? ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.1)
                  : ThemeColors.of(context).textTertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isOnline ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
              color: isOnline ? ThemeColors.of(context).brandPrimaryGreen : ThemeColors.of(context).textTertiary,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOnline ? 'Conectado ao servidor' : 'Modo offline',
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                ),
                Text(
                  _getLastSyncText(),
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isOnline)
            TextButton.icon(
              onPressed: isSyncing ? null : onSync,
              icon: isSyncing
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ThemeColors.of(context).brandPrimaryGreen,
                      ),
                    )
                  : const Icon(Icons.sync_rounded, size: 18),
              label: Text(isSyncing ? 'Sincronizando...' : 'Sincronizar'),
              style: TextButton.styleFrom(
                foregroundColor: ThemeColors.of(context).brandPrimaryGreen,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
        ],
      ),
    );
  }

  String _getLastSyncText() {
    if (lastSync == null) {
      return 'Nunca sincronizado';
    }

    final now = DateTime.now();
    final difference = now.difference(lastSync!);

    if (difference.inMinutes < 1) {
      return 'Sincronizado agora';
    } else if (difference.inMinutes < 60) {
      return 'Última sincroniza��o: h� ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Última sincroniza��o: h� ${difference.inHours}h�';
    } else {
      return 'Última sincroniza��o: ${lastSync!.day}/${lastSync!.month} às ${lastSync!.hour}:${lastSync!.minute.toString().padLeft(2, '0')}';
    }
  }
}




