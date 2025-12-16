import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/features/auth/presentation/widgets/store_selector.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_selector_dialog.dart';
import 'package:tagbean/design_system/theme/theme_provider.dart';

/// AppBar moderna do Dashboard
/// 
/// Extraído de dashboard_screen.dart para modularização
class DashboardAppBar extends ConsumerWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onLogout;
  final VoidCallback? onProfileTap;
  final VoidCallback? onHelpTap;

  const DashboardAppBar({
    super.key,
    this.onNotificationTap,
    this.onLogout,
    this.onProfileTap,
    this.onHelpTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      height: isMobile ? 60 : (isTablet ? 65 : 70),
      margin: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 12,
          tablet: 14,
          desktop: 16,
        ),
      ),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.neutralBlack.withValues(alpha: 0.08),
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 12,
            tablet: 16,
            desktop: 20,
          ),
        ),
        child: Row(
          children: [
            // Menu button para mobile
            if (isMobile) ...[
              IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () => Scaffold.of(context).openDrawer(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ] else ...[
              // Logo (apenas desktop/tablet)
              _buildLogo(context, isMobile),
              const SizedBox(width: 8),
              // Nome do app (apenas desktop grande)
              if (!isTablet) Flexible(
                flex: 0,
                child: _buildAppName(context),
              ),
            ],
            // Seletor de Loja - usa Expanded para ocupar espaço disponível
            if (!isMobile) const SizedBox(width: 8),
            Expanded(
              child: const StoreSelector(),
            ),
            
            // Search bar apenas para desktop grande
            if (!isMobile && !isTablet) ...[
              const SizedBox(width: 8),
              Flexible(
                flex: 0,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: _buildSearchBar(context),
                ),
              ),
            ],
            const SizedBox(width: 8),
            // Theme selector button
            _AppBarThemeButton(),
            const SizedBox(width: 8),
            // Notification button
            _AppBarNotificationButton(
              onTap: onNotificationTap,
            ),
            // Connection status (apenas desktop)
            if (!isMobile && !isTablet) ...[
              const SizedBox(width: 8),
              Flexible(
                flex: 0,
                child: _buildConnectionStatus(context, isTablet),
              ),
            ],
            const SizedBox(width: 8),
            // User menu
            _AppBarUserMenu(
              onLogout: onLogout,
              onProfileTap: onProfileTap,
              onHelpTap: onHelpTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 6,
          tablet: 7,
          desktop: 8,
        ),
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppThemeColors.moduleDashboard, AppThemeColors.moduleDashboardDark],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
      ),
      child: Icon(
        Icons.storefront_rounded,
        color: AppThemeColors.surface,
        size: ResponsiveHelper.getResponsiveIconSize(
          context,
          mobile: 20,
          tablet: 22,
          desktop: 24,
        ),
      ),
    );
  }

  Widget _buildAppName(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TagBeans',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 18,
              tabletFontSize: 17,
            ),
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'Sistema de Gestão',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 11,
              tabletFontSize: 10,
            ),
            overflow: TextOverflow.ellipsis,
            color: AppThemeColors.grey600,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300, minWidth: 100),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: AppThemeColors.grey100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Buscar produtos, tags...',
            hintStyle: TextStyle(fontSize: 13, color: AppThemeColors.grey500),
            prefixIcon: Icon(Icons.search_rounded, color: AppThemeColors.grey400, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatus(BuildContext context, bool isTablet) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getResponsivePadding(
            context,
            tablet: 10,
            desktop: 12,
          ),
          vertical: ResponsiveHelper.getResponsivePadding(
            context,
            tablet: 6,
            desktop: 8,
          ),
        ),
        decoration: BoxDecoration(
          color: AppThemeColors.green50,
          borderRadius: BorderRadius.circular(isTablet ? 10 : 12),
          border: Border.all(color: AppThemeColors.green200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isTablet ? 7 : 8,
              height: isTablet ? 7 : 8,
              decoration: BoxDecoration(
                color: AppThemeColors.greenMaterial,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppThemeColors.greenMaterial.withValues(alpha: 0.5),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: ResponsiveHelper.getResponsivePadding(
                context,
                tablet: 6,
                desktop: 8,
              ),
            ),
            Text(
              'ERP Conectado',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 12,
                  tabletFontSize: 11,
                ),
                fontWeight: FontWeight.w600,
                color: AppThemeColors.green700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Botão de notificações da AppBar
class _AppBarNotificationButton extends ConsumerWidget {
  final VoidCallback? onTap;

  const _AppBarNotificationButton({this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final alerts = ref.watch(dashboardAlertsProvider);
    final alertCount = alerts.length;

    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.errorPastel,
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
      ),
      child: IconButton(
        icon: Badge(
          label: Text(
            '$alertCount',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 10,
                mobileFontSize: 9,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          backgroundColor: AppThemeColors.redMain,
          child: Icon(
            Icons.notifications_rounded,
            color: AppThemeColors.errorLight,
            size: ResponsiveHelper.getResponsiveIconSize(
              context,
              mobile: 20,
              tablet: 21,
              desktop: 22,
            ),
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}

/// Menu de usuário da AppBar
class _AppBarUserMenu extends StatelessWidget {
  final VoidCallback? onLogout;
  final VoidCallback? onProfileTap;
  final VoidCallback? onHelpTap;

  const _AppBarUserMenu({
    this.onLogout,
    this.onProfileTap,
    this.onHelpTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
      ),
      child: _buildMenuTrigger(context, isMobile),
      itemBuilder: (context) => [
        _buildMenuItem(Icons.person_rounded, 'Meu Perfil', 'profile'),
        _buildMenuItem(Icons.help_rounded, 'Ajuda & Suporte', 'help'),
        const PopupMenuDivider(),
        _buildMenuItem(Icons.logout_rounded, 'Sair', 'logout', isDestructive: true),
      ],
      onSelected: (value) {
        switch (value) {
          case 'profile':
            onProfileTap?.call();
            break;
          case 'help':
            onHelpTap?.call();
            break;
          case 'logout':
            onLogout?.call();
            break;
        }
      },
    );
  }

  Widget _buildMenuTrigger(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 6,
          tablet: 8,
          desktop: 10,
        ),
        vertical: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 4,
          tablet: 5,
          desktop: 6,
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppThemeColors.grey200, AppThemeColors.grey300],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: isMobile ? 12 : 14,
            backgroundColor: AppThemeColors.surface,
            child: Text(
              'A',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 12,
                  mobileFontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: AppThemeColors.grey700,
              ),
            ),
          ),
          if (!isMobile) ...[
            SizedBox(
              width: ResponsiveHelper.getResponsivePadding(
                context,
                tablet: 5,
                desktop: 6,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      tabletFontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Administrador',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 9,
                      tabletFontSize: 8,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: AppThemeColors.grey600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 3),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                tablet: 15,
                desktop: 16,
              ),
              color: AppThemeColors.grey600,
            ),
          ],
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    IconData icon,
    String text,
    String value, {
    bool isDestructive = false,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isDestructive ? AppThemeColors.redMain : AppThemeColors.grey700,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isDestructive ? AppThemeColors.redMain : AppThemeColors.grey800,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Botão de seleção de tema na AppBar
class _AppBarThemeButton extends ConsumerWidget {
  const _AppBarThemeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final themeColors = ref.watch(dynamicThemeColorsProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeColors.primaryColor.withValues(alpha: 0.15),
            themeColors.secondaryColor.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
        border: Border.all(
          color: themeColors.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(
          Icons.palette_rounded,
          color: themeColors.primaryColor,
          size: ResponsiveHelper.getResponsiveIconSize(
            context,
            mobile: 20,
            tablet: 21,
            desktop: 22,
          ),
        ),
        tooltip: 'Selecionar Tema',
        onPressed: () => ThemeSelectorDialog.show(context),
      ),
    );
  }
}