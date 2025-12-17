import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/auth/presentation/providers/auth_provider.dart';
import 'package:tagbean/features/settings/presentation/screens/store_settings_screen.dart';
import 'package:tagbean/features/settings/presentation/screens/erp_settings_screen.dart';
import 'package:tagbean/features/settings/presentation/screens/users_screen.dart';
import 'package:tagbean/features/settings/presentation/screens/notifications_screen.dart';
import 'package:tagbean/features/settings/presentation/screens/backup_screen.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';

class ConfiguracoesMenuScreen extends ConsumerStatefulWidget {
  const ConfiguracoesMenuScreen({super.key});

  @override
  ConsumerState<ConfiguracoesMenuScreen> createState() => _ConfiguracoesMenuScreenState();
}

class _ConfiguracoesMenuScreenState extends ConsumerState<ConfiguracoesMenuScreen> with SingleTickerProviderStateMixin, ResponsiveCache {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late AnimationController _animationController;

  // ============================================================================
  // MENU ITEMS DINMICO (baseado na role do usuário)
  // ============================================================================
  List<Map<String, dynamic>> _getMenuItems() {
    final user = ref.read(authProvider).user;
    final isPlatformAdmin = user?.isPlatformAdmin ?? false;
    final isClientAdmin = user?.isClientAdmin ?? false;
    final isStoreManager = user?.isStoreManager ?? false;
    
    final List<Map<String, dynamic>> items = [];
    
    // === OPES EXCLUSIVAS PARA PLATFORMADMIN ===
    if (isPlatformAdmin) {
      items.add({
        'icon': Icons.business_rounded,
        'title': 'Gerenciar Clientes',
        'subtitle': 'Cadastrar e gerenciar empresas clientes',
        'gradient': [ThemeColors.of(context).moduleDashboard, ThemeColors.of(context).moduleDashboardDark], // Vermelho
        'screen': const _ClientsManagementPlaceholder(), // TODO: Implementar tela real
        'platformAdminOnly': true,
      });
      
      items.add({
        'icon': Icons.storefront_rounded,
        'title': 'Todas as Lojas',
        'subtitle': 'Gerenciar lojas de todos os clientes',
        'gradient': [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark], // Azul
        'screen': const _StoresManagementPlaceholder(), // TODO: Implementar tela real
        'platformAdminOnly': true,
      });
    }
    
    // === DADOS DA LOJA (ClientAdmin e StoreManager) ===
    if (isClientAdmin || isStoreManager || isPlatformAdmin) {
      items.add({
        'icon': Icons.store_rounded,
        'title': 'Dados da Loja',
        'subtitle': 'Nome, CNPJ, endereo e logo',
        'gradient': [ThemeColors.of(context).moduleProdutos, ThemeColors.of(context).moduleProdutosDark], // Verde
        'screen': const ConfiguracoesLojaScreen(),
      });
    }
    
    // === INTEGRAO ERP (ClientAdmin e acima) ===
    if (isClientAdmin || isPlatformAdmin) {
      items.add({
        'icon': Icons.integration_instructions_rounded,
        'title': 'Integração ERP',
        'subtitle': 'Conexão Totvs e sincronização',
        'gradient': [ThemeColors.of(context).moduleSincronizacao, ThemeColors.of(context).moduleSincronizacaoDark], // Azul Cyan
        'screen': const ConfiguracoesERPScreen(),
      });
    }
    
    // === Usuários E Permissões (StoreManager e acima) ===
    if (isStoreManager || isClientAdmin || isPlatformAdmin) {
      items.add({
        'icon': Icons.people_rounded,
        'title': 'Usuários e Permissões',
        'subtitle': 'Gerenciar acessos ao sistema',
        'gradient': [ThemeColors.of(context).moduleEstrategias, ThemeColors.of(context).moduleEstrategiasDark], // Dourado
        'screen': const ConfiguracoesUsuariosScreen(),
      });
    }
    
    // === NOTIFICAES (todos os nveis) ===
    items.add({
      'icon': Icons.notifications_rounded,
      'title': 'Notificações',
      'subtitle': 'Email, SMS e alertas push',
      'gradient': [ThemeColors.of(context).moduleRelatorios, ThemeColors.of(context).moduleRelatoriosDark], // Laranja/Vermelho
      'screen': const ConfiguracoesNotificacoesScreen(),
    });
    
    // === BACKUP E SEGURANA (ClientAdmin e acima) ===
    if (isClientAdmin || isPlatformAdmin) {
      items.add({
        'icon': Icons.backup_rounded,
        'title': 'Backup e Segurança',
        'subtitle': 'Backups automáticos e logs',
        'gradient': [ThemeColors.of(context).blueCyan, ThemeColors.of(context).blueLight], // Ciano
        'screen': const ConfiguracoesBackupScreen(),
      });
    }
    
    return items;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return PopScope(
      canPop: !(_navigatorKey.currentState?.canPop() ?? false),
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_navigatorKey.currentState?.canPop() ?? false) {
          _navigatorKey.currentState?.pop();
        }
      },
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          final menuItems = _getMenuItems();
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              backgroundColor: ThemeColors.of(context).surface,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildModuleDescription(),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                      ),
                      child: Column(
                        children: [
                          ...menuItems.asMap().entries.map((entry) {
                            return _buildMenuItem(entry.value, entry.key);
                          }),
                          SizedBox(
                            height: AppSizes.paddingMd.get(isMobile, isTablet),
                          ),
                          _buildAboutCard(),
                          SizedBox(
                            height: AppSizes.paddingMd.get(isMobile, isTablet),
                          ),
                          _buildDangerZone(),
                          SizedBox(
                            height: AppSizes.paddingMd.get(isMobile, isTablet),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
        vertical: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: AppGradients.darkBackground(context),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.4),
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 15,
              tablet: 18,
              desktop: 20,
            ),
            offset: Offset(0, isMobile ? 6 : (isTablet ? 7 : 8)),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay20,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getResponsiveBorderRadius(
                  context,
                  mobile: 12,
                  tablet: 13,
                  desktop: 14,
                ),
              ),
            ),
            child: Icon(
              Icons.settings_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.spacingSm.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configurações',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 18,
                      mobileFontSize: 16,
                      tabletFontSize: 17,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(
                  height: AppSizes.paddingMicro.get(isMobile, isTablet),
                ),
                Text(
                  'Personalize e configure o sistema',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 10,
                      tabletFontSize: 11,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).surfaceOverlay70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
              vertical: AppSizes.extraSmallPadding.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).success.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getResponsiveBorderRadius(
                  context,
                  mobile: 8,
                  tablet: 9,
                  desktop: 10,
                ),
              ),
              border: Border.all(color: ThemeColors.of(context).success.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: ThemeColors.of(context).success,
                  size: AppSizes.iconTiny.get(isMobile, isTablet),
                ),
                SizedBox(
                  width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                Text(
                  'OK',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10,
                      tabletFontSize: 10.5,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleDescription() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).blueIndigo.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(
          AppSizes.paddingLg.get(isMobile, isTablet),
        ),
        border: Border.all(color: ThemeColors.of(context).infoLight),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_rounded,
            color: ThemeColors.of(context).infoDark,
            size: AppSizes.iconMedium.get(isMobile, isTablet),
          ),
          SizedBox(
            width: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sobre este Módulo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 13,
                      tabletFontSize: 13,
                    ),
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).infoDark,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(
                  height: AppSizes.extraSmallPadding.get(isMobile, isTablet),
                ),
                Text(
                  'Personalize preferncias do sistema, gerencie perfil, aparncia, notificaes e configurações avanadas.',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
                    ),
                    color: ThemeColors.of(context).infoDark,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: item['gradient'],
          ),
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: (item['gradient'][0] as Color).withValues(alpha: 0.3),
              blurRadius: isMobile ? 18 : 22,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: ThemeColors.of(context).transparent,
          child: InkWell(
            onTap: () {
              _navigatorKey.currentState?.push(
                MaterialPageRoute(builder: (context) => item['screen']),
              );
            },
            borderRadius: BorderRadius.circular(
              isMobile ? 16 : (isTablet ? 18 : 20),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                vertical: AppSizes.paddingSmLg.get(isMobile, isTablet),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).surfaceOverlay20,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getResponsiveBorderRadius(
                          context,
                          mobile: 12,
                          tablet: 13,
                          desktop: 14,
                        ),
                      ),
                    ),
                    child: Icon(
                      item['icon'],
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconMedium.get(isMobile, isTablet),
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.paddingBaseLg.get(isMobile, isTablet),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 16,
                              mobileFontSize: 14,
                              tabletFontSize: 15,
                            ),
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).surface,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.paddingMicro.get(isMobile, isTablet),
                        ),
                        Text(
                          item['subtitle'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 12,
                              mobileFontSize: 10,
                              tabletFontSize: 11,
                            ),
                            color: ThemeColors.of(context).surfaceOverlay90,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: AppSizes.iconTiny.get(isMobile, isTablet),
                    color: ThemeColors.of(context).surfaceOverlay90,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        border: Border.all(color: ThemeColors.of(context).textSecondary),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingMd.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              gradient: AppGradients.darkBackground(context),
              borderRadius: BorderRadius.circular(
                isMobile ? 12 : (isTablet ? 14 : 16),
              ),
            ),
            child: Icon(
              Icons.info_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconExtraLarge.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Text(
            'TagBeans System',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 18,
                mobileFontSize: 16,
                tabletFontSize: 17,
              ),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(
            height: AppSizes.paddingXxs.get(isMobile, isTablet),
          ),
          Text(
            'Verso 1.0.0  Build 2025.11.23',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                mobileFontSize: 10,
                tabletFontSize: 11,
              ),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Wrap(
            spacing: AppSizes.paddingXs.get(isMobile, isTablet),
            runSpacing: AppSizes.paddingXs.get(isMobile, isTablet),
            alignment: WrapAlignment.center,
            children: [
              _buildInfoChip(Icons.update_rounded, 'Atualizado', ThemeColors.of(context).success),
              _buildInfoChip(Icons.shield_rounded, 'Seguro', ThemeColors.of(context).primary),
              _buildInfoChip(Icons.support_rounded, 'Suporte 24/7', ThemeColors.of(context).success),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showLicenseDialog();
                  },
                  icon: Icon(
                    Icons.description_rounded,
                    size: AppSizes.iconTiny.get(isMobile, isTablet),
                  ),
                  label: Text(
                    'Licena',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 12,
                        tabletFontSize: 13,
                      ),
                    overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingXs.get(isMobile, isTablet),
              ),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showSupportDialog();
                  },
                  icon: Icon(
                    Icons.help_rounded,
                    size: AppSizes.iconTiny.get(isMobile, isTablet),
                  ),
                  label: Text(
                    'Ajuda',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 12,
                        tabletFontSize: 13,
                      ),
                    overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
        vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : 20,
        ),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
            color: color,
          ),
          SizedBox(
            width: AppSizes.paddingXxs.get(isMobile, isTablet),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 11,
                mobileFontSize: 9,
                tabletFontSize: 10,
              ),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isMobile ? 280 : (isTablet ? 350 : 400),
        ),
        child: Container(
          padding: EdgeInsets.all(
            AppSizes.paddingBaseLg.get(isMobile, isTablet),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ThemeColors.of(context).errorPastel, ThemeColors.of(context).warningPastel],
            ),
            borderRadius: BorderRadius.circular(
              isMobile ? 12 : (isTablet ? 14 : 16),
            ),
            border: Border.all(color: ThemeColors.of(context).errorLight),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: ThemeColors.of(context).errorDark,
                    size: AppSizes.iconSmallMedium.get(isMobile, isTablet),
                  ),
                  SizedBox(
                    width: AppSizes.paddingXs.get(isMobile, isTablet),
                  ),
                  Flexible(
                    child: Text(
                      'Zona de Perigo',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 16,
                          mobileFontSize: 12,
                          tabletFontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).errorDark,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppSizes.paddingXs.get(isMobile, isTablet),
              ),
          Text(
            'Ações irreversveis que afetam todo o sistema',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                mobileFontSize: 9,
                tabletFontSize: 10,
              ),
              overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).errorDark,
            ),
          ),
          SizedBox(
            height: AppSizes.paddingBaseLg.get(isMobile, isTablet),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).errorDark, ThemeColors.of(context).errorDark],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).error.withValues(alpha: 0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: ThemeColors.of(context).transparent,
              child: InkWell(
                onTap: () {
                  _showResetDialog();
                },
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingSmLg.get(isMobile, isTablet),
                    horizontal: AppSizes.paddingMdLg.get(isMobile, isTablet),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restore_rounded,
                        color: ThemeColors.of(context).surface,
                        size: AppSizes.iconTiny.get(isMobile, isTablet),
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getResponsivePadding(
                          context,
                          mobile: 5,
                          tablet: 6,
                          desktop: 7,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          'Resetar Configurações',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 14,
                              mobileFontSize: 10,
                              tabletFontSize: 11,
                            ),
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).surface,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLicenseDialog() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
        ),
        icon: Icon(
          Icons.description_rounded,
          color: ThemeColors.of(context).infoDark,
          size: AppSizes.iconHeroSm.get(isMobile, isTablet),
        ),
        title: Text(
          'Licena de Uso',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 20,
              mobileFontSize: 18,
              tabletFontSize: 19,
            ),
          overflow: TextOverflow.ellipsis,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            'TagBeans System v1.0.0\n\n'
            ' 2025 TagBeans Technologies\n\n'
            'Este software  licenciado para uso comercial.   '
            'Todos os direitos reservados.\n\n'
            'Licena vlida at: 31/12/2026\n'
            'Usuários permitidos: Ilimitado\n'
            'Estabelecimentos: 1',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 13,
                mobileFontSize: 12,
                tabletFontSize: 12,
              ),
            overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fechar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSupportDialog() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
        ),
        icon: Icon(
          Icons.support_agent_rounded,
          color: ThemeColors.of(context).successIcon,
          size: AppSizes.iconHeroSm.get(isMobile, isTablet),
        ),
        title: Text(
          'Suporte e Ajuda',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 20,
              mobileFontSize: 18,
              tabletFontSize: 19,
            ),
          overflow: TextOverflow.ellipsis,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactItem(Icons.email_rounded, 'Email', 'suporte@tagbeans.com'),
            SizedBox(
              height: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            _buildContactItem(Icons.phone_rounded, 'Telefone', '(11) 9999-9999'),
            SizedBox(
              height: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            _buildContactItem(Icons.language_rounded, 'Site', 'www.tagbeans.com'),
            SizedBox(
              height: AppSizes.paddingMd.get(isMobile, isTablet),
            ),
            Container(
              padding: EdgeInsets.all(
                AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).infoPastel,
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: AppSizes.iconTiny.get(isMobile, isTablet),
                    color: ThemeColors.of(context).infoDark,
                  ),
                  SizedBox(
                    width: AppSizes.paddingXs.get(isMobile, isTablet),
                  ),
                  Expanded(
                    child: Text(
                      'Atendimento 24/7',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 12,
                          mobileFontSize: 11,
                          tabletFontSize: 11,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.of(context).infoDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fechar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(
            AppSizes.paddingXs.get(isMobile, isTablet),
          ),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).textSecondary,
            borderRadius: BorderRadius.circular(
              isMobile ? 6 : 8,
            ),
          ),
          child: Icon(
            icon,
            size: AppSizes.iconSmall.get(isMobile, isTablet),
            color: ThemeColors.of(context).textSecondary,
          ),
        ),
        SizedBox(
          width: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 11,
                    mobileFontSize: 10,
                    tabletFontSize: 10,
                  ),
                overflow: TextOverflow.ellipsis,
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                    tabletFontSize: 12,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showResetDialog() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ?  18 : 20),
          ),
        ),
        icon: Icon(
          Icons.warning_rounded,
          color: ThemeColors.of(context).error,
          size: AppSizes.iconHeroSm.get(isMobile, isTablet),
        ),
        title: Text(
          'Resetar Configurações? ',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 20,
              mobileFontSize: 18,
              tabletFontSize: 19,
            ),
          overflow: TextOverflow.ellipsis,
          ),
        ),
        content: Text(
          'Esta ao ir restaurar todas as configurações para os valores padro.\n\n'
          'Seus dados (produtos, tags, etc.) no sero afetados.\n\n'
          'Deseja continuar?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
              tabletFontSize: 13,
            ),
          overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: ThemeColors.of(context).surface,
                        size: AppSizes.iconMedium.get(isMobile, isTablet),
                      ),
                      SizedBox(
                        width: AppSizes.paddingBase.get(isMobile, isTablet),
                      ),
                      Text(
                        'Configurações resetadas com sucesso',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 13,
                            tabletFontSize: 13,
                          ),
                        overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: ThemeColors.of(context).success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      isMobile ? 10 : 12,
                    ),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXlAlt2.get(isMobile, isTablet),
                vertical: AppSizes.paddingBaseAlt.get(isMobile, isTablet),
              ),
            ),
            child: Text(
              'Resetar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PLACEHOLDER SCREENS (Para PlatformAdmin)
// TODO: Implementar telas completas de gerenciamento
// ============================================================================

/// Placeholder para tela de gerenciamento de clientes
class _ClientsManagementPlaceholder extends StatelessWidget {
  const _ClientsManagementPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      appBar: AppBar(
        title: const Text('Gerenciar Clientes'),
        backgroundColor: ThemeColors.of(context).success,
        foregroundColor: ThemeColors.of(context).surface,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_rounded,
              size: 80,
              color: ThemeColors.of(context).success.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Gerenciamento de Clientes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Esta funcionalidade est em desenvolvimento.\nEm breve voc poder cadastrar e gerenciar\ntodos os clientes da plataforma TagBean.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    size: 20,
                    color: ThemeColors.of(context).success,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Exclusivo para PlatformAdmin',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.of(context).success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder para tela de gerenciamento de lojas (todas)
class _StoresManagementPlaceholder extends StatelessWidget {
  const _StoresManagementPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      appBar: AppBar(
        title: const Text('Todas as Lojas'),
        backgroundColor: ThemeColors.of(context).success,
        foregroundColor: ThemeColors.of(context).surface,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storefront_rounded,
              size: 80,
              color: ThemeColors.of(context).success.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Gerenciamento Global de Lojas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Esta funcionalidade est em desenvolvimento.\nEm breve voc poder visualizar e gerenciar\ntodas as lojas de todos os clientes.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    size: 20,
                    color: ThemeColors.of(context).success,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Exclusivo para PlatformAdmin',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.of(context).success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



