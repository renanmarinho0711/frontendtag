import 'package:flutter/material.dart';
import 'package:tagbean/features/dashboard/presentation/widgets/navigation/dashboard_navigation_rail.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
/// Drawer mobile para navegação do Dashboard
/// 
/// Extraído de dashboard_screen.dart para modularização
class DashboardMobileDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final AnimationController? fadeController;

  const DashboardMobileDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.fadeController,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeColors.of(context).grey50,
              ThemeColors.of(context).grey100,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildMenuList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).moduleDashboard, ThemeColors.of(context).moduleDashboardDark],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.storefront_rounded,
              color: ThemeColors.of(context).moduleDashboard,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SolTag',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                  ),
                ),
                Text(
                  'Sistema de Gestão',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: ThemeColors.of(context).white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: DashboardNavigationRail.menuItems.length,
      itemBuilder: (context, index) {
        final item = DashboardNavigationRail.menuItems[index];
        final isSelected = selectedIndex == index;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: _DrawerMenuItem(
            item: item,
            isSelected: isSelected,
            onTap: () {
              Navigator.pop(context);
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

/// Item individual do Drawer
class _DrawerMenuItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: List<Color>.from(item['gradient']))
              : null,
          color: isSelected ? null : ThemeColors.of(context).transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item['icon'],
              color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).grey600,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item['title'],
                style: TextStyle(
                  color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).grey700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
