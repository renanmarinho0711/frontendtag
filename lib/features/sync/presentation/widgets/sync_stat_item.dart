import 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

/// Item de estatística individual com ícone, valor e label.
/// Usado para exibir métricas como total de tags, online, etc.
class SyncStatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const SyncStatItem({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    final content = Container(
      padding: EdgeInsets.all(
        AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: colorLight,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 10,
            tablet: 11,
            desktop: 12,
          ),
        ),
        border: Border.all(color: colorLight),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
          ),
          SizedBox(height: AppSizes.spacingXsAlt.get(isMobile, isTablet)),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 16,
                mobileFontSize: 14,
                tabletFontSize: 15,
              ),
              fontWeight: FontWeight.bold,
              color: color,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 10,
                mobileFontSize: 9,
              ),
              color: ThemeColors.of(context).textSecondary,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 10,
            tablet: 11,
            desktop: 12,
          ),
        ),
        child: content,
      );
    }

    return content;
  }
}

/// Grid de estatísticas com layout responsivo.
class SyncStatsGrid extends StatelessWidget {
  final List<SyncStatItemData> items;
  final int crossAxisCount;

  const SyncStatsGrid({
    super.key,
    required this.items,
    this.crossAxisCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Divide items em rows de crossAxisCount itens
    final List<List<SyncStatItemData>> rows = [];
    for (var i = 0; i < items.length; i += crossAxisCount) {
      final end = (i + crossAxisCount > items.length) ? items.length : i + crossAxisCount;
      rows.add(items.sublist(i, end));
    }

    return Column(
      children: rows.asMap().entries.map((entry) {
        final rowIndex = entry.key;
        final rowItems = entry.value;
        
        return Column(
          children: [
            if (rowIndex > 0)
              SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
            Row(
              children: rowItems.asMap().entries.map((itemEntry) {
                final itemIndex = itemEntry.key;
                final item = itemEntry.value;
                
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: itemIndex > 0 
                          ? AppSizes.spacingBase.get(isMobile, isTablet) / 2 
                          : 0,
                      right: itemIndex < rowItems.length - 1 
                          ? AppSizes.spacingBase.get(isMobile, isTablet) / 2 
                          : 0,
                    ),
                    child: SyncStatItem(
                      value: item.value,
                      label: item.label,
                      icon: item.icon,
                      color: item.color,
                      onTap: item.onTap,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }
}

/// Dados para um item de estatística.
class SyncStatItemData {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const SyncStatItemData({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });
}

/// Widget de loading para stats.
class SyncStatsLoading extends StatelessWidget {
  final String? message;

  const SyncStatsLoading({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: ThemeColors.of(context).primary,
              strokeWidth: 2,
            ),
            const SizedBox(height: 12),
            Text(
              message ?? 'Carregando...',
              style: TextStyle(
                color: ThemeColors.of(context).textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget de erro para stats.
class SyncStatsError extends StatelessWidget {
  final String error;
  final String? title;
  final VoidCallback? onRetry;

  const SyncStatsError({
    super.key,
    required this.error,
    this.title,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              color: ThemeColors.of(context).error,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title ?? 'Erro ao carregar',
              style: TextStyle(
                color: ThemeColors.of(context).error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              error,
              style: TextStyle(
                color: ThemeColors.of(context).textSecondary,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Tentar novamente'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


