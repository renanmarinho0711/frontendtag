import 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

/// Widget que renderiza a Navigation Rail para desktop/tablet
/// 
/// Extraído de dashboard_screen.dart para modularização
class DashboardNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final bool isExpanded;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onToggleExpand;
  final AnimationController? fadeController;

  /// Itens do menu - definido como static const para performance
  static const List<Map<String, dynamic>> menuItems = [
    {
      'icon': Icons.dashboard_rounded,
      'title': 'Dashboard',
      'gradient': [AppThemeColors.moduleDashboard, AppThemeColors.moduleDashboardDark]
    },
    {
      'icon': Icons.inventory_2_rounded,
      'title': 'Produtos',
      'gradient': [AppThemeColors.moduleProdutos, AppThemeColors.moduleProdutosDark]
    },
    {
      'icon': Icons.label_rounded,
      'title': 'Etiquetas',
      'gradient': [AppThemeColors.moduleEtiquetas, AppThemeColors.moduleEtiquetasDark]
    },
    {
      'icon': Icons.auto_awesome_rounded,
      'title': 'Estratégias',
      'gradient': [AppThemeColors.moduleEstrategias, AppThemeColors.moduleEstrategiasDark]
    },
    {
      'icon': Icons.sync_rounded,
      'title': 'Sincronização',
      'gradient': [AppThemeColors.moduleSincronizacao, AppThemeColors.moduleSincronizacaoDark]
    },
    {
      'icon': Icons.monetization_on_rounded,
      'title': 'Precificação',
      'gradient': [AppThemeColors.modulePrecificacao, AppThemeColors.modulePrecificacaoDark]
    },
    {
      'icon': Icons.category_rounded,
      'title': 'Categorias',
      'gradient': [AppThemeColors.moduleCategorias, AppThemeColors.moduleCategoriasDark]
    },
    {
      'icon': Icons.import_export_rounded,
      'title': 'Importação',
      'gradient': [AppThemeColors.moduleImportacao, AppThemeColors.moduleImportacaoDark]
    },
    {
      'icon': Icons.assessment_rounded,
      'title': 'Relatórios',
      'gradient': [AppThemeColors.moduleRelatorios, AppThemeColors.moduleRelatoriosDark]
    },
    {
      'icon': Icons.settings_rounded,
      'title': 'Configurações',
      'gradient': [AppThemeColors.moduleConfiguracoes, AppThemeColors.moduleConfiguracoesDark]
    },
  ];

  const DashboardNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.isExpanded,
    required this.onItemSelected,
    required this.onToggleExpand,
    this.fadeController,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final railWidth = isTablet 
        ? (isExpanded ? 200.0 : 70.0) 
        : (isExpanded ? 240.0 : 80.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: railWidth,
      margin: EdgeInsets.only(
        left: ResponsiveHelper.getResponsivePadding(
          context,
          tablet: 12,
          desktop: 16,
        ),
        right: ResponsiveHelper.getResponsivePadding(
          context,
          tablet: 6,
          desktop: 8,
        ),
        bottom: ResponsiveHelper.getResponsivePadding(
          context,
          tablet: 12,
          desktop: 16,
        ),
      ),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.neutralBlack.withValues(alpha: 0.08),
            blurRadius: isTablet ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: ResponsiveHelper.getResponsivePadding(
              context,
              tablet: 12,
              desktop: 16,
            ),
          ),
          _buildMenuToggle(context, isTablet),
          SizedBox(
            height: ResponsiveHelper.getResponsivePadding(
              context,
              tablet: 6,
              desktop: 8,
            ),
          ),
          Expanded(
            child: _buildMenuList(context, isTablet),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuToggle(BuildContext context, bool isTablet) {
    return InkWell(
      onTap: onToggleExpand,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getResponsivePadding(
            context,
            tablet: 12,
            desktop: 16,
          ),
          vertical: ResponsiveHelper.getResponsivePadding(
            context,
            tablet: 6,
            desktop: 8,
          ),
        ),
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsivePadding(
            context,
            tablet: 10,
            desktop: 12,
          ),
        ),
        decoration: BoxDecoration(
          color: AppThemeColors.grey100,
          borderRadius: BorderRadius.circular(isTablet ? 10 : 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isExpanded ? Icons.menu_open_rounded : Icons.menu_rounded,
              color: AppThemeColors.grey700,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                tablet: 22,
                desktop: 24,
              ),
            ),
            if (isExpanded) ...[
              SizedBox(
                width: ResponsiveHelper.getResponsivePadding(
                  context,
                  tablet: 6,
                  desktop: 8,
                ),
              ),
              Text(
                'Menu',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppThemeColors.grey700,
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    tabletFontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList(BuildContext context, bool isTablet) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(
          context,
          tablet: 10,
          desktop: 12,
        ),
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        final isSelected = selectedIndex == index;

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.getResponsivePadding(
              context,
              tablet: 3,
              desktop: 4,
            ),
          ),
          child: _NavigationRailItem(
            item: item,
            isSelected: isSelected,
            isExpanded: isExpanded,
            isTablet: isTablet,
            onTap: () {
              if (selectedIndex != index) {
                onItemSelected(index);
                fadeController?.reset();
                fadeController?.forward();
              }
            },
          ),
        );
      },
    );
  }
}

/// Item individual da Navigation Rail
class _NavigationRailItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isSelected;
  final bool isExpanded;
  final bool isTablet;
  final VoidCallback onTap;

  const _NavigationRailItem({
    required this.item,
    required this.isSelected,
    required this.isExpanded,
    required this.isTablet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isTablet ? 10 : 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getResponsivePadding(
            context,
            tablet: 12,
            desktop: 16,
          ),
          vertical: ResponsiveHelper.getResponsivePadding(
            context,
            tablet: 12,
            desktop: 14,
          ),
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              // ignore: argument_type_not_assignable
              ? LinearGradient(colors: List<Color>.from(item['gradient']))
              : null,
          borderRadius: BorderRadius.circular(isTablet ? 10 : 12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              // ignore: argument_type_not_assignable
              item['icon'],
              color: isSelected ? AppThemeColors.surface : AppThemeColors.grey600,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                tablet: 20,
                desktop: 22,
              ),
            ),
            if (isExpanded) ...[
              SizedBox(
                width: ResponsiveHelper.getResponsivePadding(
                  context,
                  tablet: 12,
                  desktop: 16,
                ),
              ),
              Expanded(
                child: Text(
                  (item['title']).toString(),
                  style: TextStyle(
                    color: isSelected ? AppThemeColors.surface : AppThemeColors.grey700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      tabletFontSize: 13,
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
