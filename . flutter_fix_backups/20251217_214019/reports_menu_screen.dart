import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/reports/presentation/screens/operational_report_screen.dart';
import 'package:tagbean/features/reports/presentation/screens/sales_report_screen.dart';
import 'package:tagbean/features/reports/presentation/screens/performance_report_screen.dart';
import 'package:tagbean/features/reports/presentation/screens/audit_report_screen.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';

class RelatoriosMenuScreen extends ConsumerStatefulWidget {
  const RelatoriosMenuScreen({super.key});

  @override
  ConsumerState<RelatoriosMenuScreen> createState() => _RelatoriosMenuScreenState();
}

class _RelatoriosMenuScreenState extends ConsumerState<RelatoriosMenuScreen> with TickerProviderStateMixin, ResponsiveCache {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late AnimationController _animationController;
  late AnimationController _pulseController;
  // ignore: unused_field
  int?  _hoveredIndex;

  List<Map<String, dynamic>> _getRelatorios(BuildContext context) => [
    {
      'title': 'Operacionais',
      'subtitle': 'Status de tags e sincronizaes',
      'description': 'Monitore o status das ESLs em tempo real',
      'icon': Icons.settings_rounded,
      'gradient': [ThemeColors.of(context).reportOperacional, ThemeColors.of(context).reportOperacionalDark],
      'screen': const RelatoriosOperacionaisScreen(),
      'stats': '142 tags online',
      'badge': 'Tempo Real',
      'alertas': 3,
    },
    {
      'title': 'Vendas',
      'subtitle': 'Anlise de performance de vendas',
      'description': 'Produtos mais e menos vendidos do perodo',
      'icon': Icons.shopping_cart_rounded,
      'gradient': [ThemeColors.of(context).reportVendas, ThemeColors.of(context).reportVendasDark],
      'screen': const RelatoriosVendasScreen(),
      'stats': 'R\$ 103.5K',
      'badge': '+15%',
      'alertas': 0,
    },
    {
      'title': 'Performance',
      'subtitle': 'Produtos acima e abaixo da mdia',
      'description': 'Anlise de performance e oportunidades',
      'icon': Icons.trending_up_rounded,
      'gradient': [ThemeColors.of(context).reportPerformance, ThemeColors.of(context).reportPerformanceDark],
      'screen': const RelatoriosPerformanceScreen(),
      'stats': '80 insights',
      'badge': 'IA',
      'alertas': 18,
    },
    {
      'title': 'Auditoria',
      'subtitle': 'Log de ações e alteraes',
      'description': 'Histórico completo de operações do sistema',
      'icon': Icons.fact_check_rounded,
      'gradient': [ThemeColors.of(context).reportAuditoria, ThemeColors.of(context).reportAuditoriaDark],
      'screen': const RelatoriosAuditoriaScreen(),
      'stats': '1.247 logs',
      'badge': 'Seguro',
      'alertas': 0,
    },
  ];

  List<Map<String, dynamic>> _getEstatisticas(BuildContext context) => [
    {
      'label': 'Tags',
      'valor': '142',
      'icon': Icons.label_rounded,
      'cor': ThemeColors.of(context).statTagsIcon,
      'background': ThemeColors.of(context).statTagsBackground,
      'border': ThemeColors.of(context).statTagsBorder,
      'mudanca': '+5',
      'tipo': 'aumento',
    },
    {
      'label': 'Vendas',
      'valor': 'R\$ 103K',
      'icon': Icons.attach_money_rounded,
      'cor': ThemeColors.of(context).statVendasIcon,
      'background': ThemeColors.of(context).statVendasBackground,
      'border': ThemeColors.of(context).statVendasBorder,
      'mudanca': '+15%',
      'tipo': 'percentual',
    },
    {
      'label': 'Insights',
      'valor': '80',
      'icon': Icons.lightbulb_rounded,
      'cor': ThemeColors.of(context).statInsightsIcon,
      'background': ThemeColors.of(context).statInsightsBackground,
      'border': ThemeColors.of(context).statInsightsBorder,
      'mudanca': '+12',
      'tipo': 'aumento',
    },
    {
      'label': 'Logs',
      'valor': '1.2K',
      'icon': Icons.history_rounded,
      'cor': ThemeColors.of(context).statLogsIcon,
      'background': ThemeColors.of(context).statLogsBackground,
      'border': ThemeColors.of(context).statLogsBorder,
      'mudanca': 'Online',
      'tipo': 'status',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final isMobile = ResponsiveHelper.isMobile(context);
    // ignore: unused_local_variable
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
          return MaterialPageRoute(
            builder: (context) => _buildMainMenu(context),
          );
        },
      ),
    );
  }

  Widget _buildMainMenu(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPremiumHeader(),
            _buildModuleDescription(),
            SizedBox(
              height: AppSizes.spacingMd.get(isMobile, isTablet),
            ),
            _buildEnhancedStatsOverview(),
            SizedBox(
              height: AppSizes.spacingMd.get(isMobile, isTablet),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Relatrios Disponveis',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 22,
                        mobileFontSize: 19,
                        tabletFontSize: 20.5,
                      ),
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.8,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(
                      context,
                      mobile: 3,
                      tablet: 3.5,
                      desktop: 4,
                    ),
                  ),
                  Text(
                    'Anlises inteligentes do negcio',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                        tabletFontSize: 13.5,
                      ),
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.spacingLg.get(isMobile, isTablet),
                  ),
                  _buildResponsiveReportsGrid(),
                ],
              ),
            ),
            ResponsiveSpacing.verticalLarge(context),
            _buildEnhancedQuickActions(),
            ResponsiveSpacing.verticalLarge(context),
            _buildRecentReports(),
          ],
        ),
      ),
      floatingActionButton: _buildSpeedDial(context),
    );
  }

  Widget _buildPremiumHeader() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
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
                  Icons.assessment_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.spacingSm.get(isMobile, isTablet)),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Relatrios & Anlises',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
                    Text(
                      'Insights Inteligentes do seu Negcio',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 10, tabletFontSize: 11),
                        color: ThemeColors.of(context).surfaceOverlay70,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!isMobile) ...[
                SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                Flexible(
                  child: Wrap(
                    spacing: AppSizes.spacingXs.get(isMobile, isTablet),
                    children: _buildInlineFilters(),
                  ),
                ),
              ],
              if (!isMobile) SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              if (!isMobile)
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                        vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 7, tablet: 7.5, desktop: 8),
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).success.withValues(alpha: 0.2 + (0.1 * _pulseController.value)),
                        borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                        border: Border.all(
                          color: ThemeColors.of(context).success.withValues(alpha: 0.4 + (0.2 * _pulseController.value)),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            color: ThemeColors.of(context).success,
                            size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 15, tablet: 15.5, desktop: 16),
                          ),
                          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
                          Text(
                            '30 dias',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9, tabletFontSize: 9.5),
                              overflow: TextOverflow.ellipsis,
                              color: ThemeColors.of(context).surface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          ResponsiveSpacing.verticalMedium(context),
          Container(
            padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay10,
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  color: ThemeColors.of(context).surfaceOverlay80,
                  size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 15, tablet: 15.5, desktop: 16),
                ),
                SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
                Expanded(
                  child: Text(
                    'Última atualizao: H 2 minutos',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
                      overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).surfaceOverlay90,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 7, tablet: 7.5, desktop: 8),
                      vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 3.5, tablet: 3.75, desktop: 4),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).primary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, isTablet)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_done_rounded,
                          color: ThemeColors.of(context).surface,
                          size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 11, tablet: 11.5, desktop: 12),
                        ),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
                        Text(
                          'Sincronizado',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9, tabletFontSize: 9.5),
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).surface,
                          ),
                        ),
                      ],
                    ),
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
          colors: [ThemeColors.of(context).primaryPastel, ThemeColors.of(context).greenLightMaterial.withValues(alpha: 0.3)],
        ),
        borderRadius: BorderRadius.circular(
          AppSizes.paddingLg.get(isMobile, isTablet),
        ),
        border: Border.all(color: ThemeColors.of(context).primaryLight),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_rounded,
            color: ThemeColors.of(context).primaryDark,
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
                    color: ThemeColors.of(context).primaryDark,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(
                  height: AppSizes.extraSmallPadding.get(isMobile, isTablet),
                ),
                Text(
                  'Anlises inteligentes do negcio com relatrios operacionais, vendas, performance e auditoria para insights estratgicos.',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
                    ),
                    color: ThemeColors.of(context).primaryDark,
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

  Widget _buildEnhancedStatsOverview() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeColors.of(context).statsOverviewBackground1,
            ThemeColors.of(context).statsOverviewBackground2,
          ],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 16 : (isTablet ? 18 : 20)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).statsOverviewBackground2.withValues(alpha: 0.5),
            blurRadius: isMobile ? 25 : 30,
            offset: Offset(0, isMobile ? 10 : 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context, mobile: 9, tablet: 9.5, desktop: 10)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.dashboard_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Flexible(
                child: Text(
                  'Viso Geral',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15, tabletFontSize: 15.5),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: ThemeColors.of(context).surface,
                  ),
                ),
              ),
            ],
          ),
          ResponsiveSpacing.verticalMedium(context),
          isMobile && !ResponsiveHelper.isLandscape(context)
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildEnhancedMiniStat(_getEstatisticas(context)[0])),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                        Expanded(child: _buildEnhancedMiniStat(_getEstatisticas(context)[1])),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                    Row(
                      children: [
                        Expanded(child: _buildEnhancedMiniStat(_getEstatisticas(context)[2])),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                        Expanded(child: _buildEnhancedMiniStat(_getEstatisticas(context)[3])),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: _getEstatisticas(context).asMap().entries.map((entry) {
                    final index = entry.key;
                    final stat = entry.value;
                    
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index < _getEstatisticas(context).length - 1 ? 12 : 0),
                        child: _buildEnhancedMiniStat(stat),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildEnhancedMiniStat(Map<String, dynamic> stat) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          color: stat['background'],
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
          border: Border.all(
            color: stat['border'],
            width: isMobile ? 2 : 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (stat['background'] as Color).withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).surfaceOverlay20,
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
              child: Icon(
                stat['icon'],
                color: ThemeColors.of(context).surface,
                size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
            Text(
              stat['valor'],
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).surface,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
            Text(
              stat['label'],
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9, tabletFontSize: 9.5),
                overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).surfaceOverlay90,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 5, tablet: 5.5, desktop: 6),
                vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 2.5, tablet: 2.75, desktop: 3),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).surfaceOverlay20,
                borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, isTablet)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (stat['tipo'] == 'aumento')
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 9, tablet: 9.5, desktop: 10),
                      color: ThemeColors.of(context).surface,
                    ),
                  if (stat['tipo'] == 'aumento')
                    SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 2.5, tablet: 2.75, desktop: 3)),
                  Flexible(
                    child: Text(
                      stat['mudanca'],
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 9, mobileFontSize: 8, tabletFontSize: 8.5),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                      ),
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

  // ignore: unused_element
  Widget _buildQuickFilters() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).primaryPastel],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
        border: Border.all(color: ThemeColors.of(context).infoLight),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune_rounded,
                size: AppSizes.iconSmall.get(isMobile, isTablet),
                color: ThemeColors.of(context).infoDark,
              ),
              SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
              Text(
                'Filtros Rpidos',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).infoDark,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
          Wrap(
            spacing: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8),
            runSpacing: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8),
            children: [
              _buildFilterChip('Hoje', Icons.today_rounded, false),
              _buildFilterChip('7 dias', Icons.date_range_rounded, false),
              _buildFilterChip('30 dias', Icons.calendar_month_rounded, true),
              _buildFilterChip('Customizado', Icons.tune_rounded, false),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInlineFilters() {
    return [
      _buildCompactFilterChip('Hoje', Icons.today_rounded, false),
      SizedBox(width: AppSizes.spacingXs.get(isMobile, isTablet)),
      _buildCompactFilterChip('7 dias', Icons.date_range_rounded, false),
      SizedBox(width: AppSizes.spacingXs.get(isMobile, isTablet)),
      _buildCompactFilterChip('30 dias', Icons.calendar_month_rounded, true),
      SizedBox(width: AppSizes.spacingXs.get(isMobile, isTablet)),
      _buildCompactFilterChip('Customizado', Icons.tune_rounded, false),
    ];
  }

  Widget _buildCompactFilterChip(String label, IconData icon, bool isSelected) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
        vertical: AppSizes.paddingXs.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: isSelected ? LinearGradient(colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark]) : null,
        color: isSelected ? null : ThemeColors.of(context).surfaceOverlay20,
        borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
        border: Border.all(
          color: isSelected ? ThemeColors.of(context).transparent : ThemeColors.of(context).surfaceOverlay30,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
            color: ThemeColors.of(context).surface,
          ),
          SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6)),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10.5),
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).surface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, bool isSelected) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
        vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 7, tablet: 7.5, desktop: 8),
      ),
      decoration: BoxDecoration(
        gradient: isSelected ?  LinearGradient(colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark]) : null,
        color: isSelected ? null : ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
        border: Border.all(
          color: isSelected ? ThemeColors.of(context).transparent : ThemeColors.of(context).textSecondary,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 13, tablet: 13.5, desktop: 14),
            color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
          ),
          SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6)),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10.5),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveReportsGrid() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 3 : 6,
        crossAxisSpacing: AppSizes.spacingBase.get(isMobile, isTablet),
        mainAxisSpacing: AppSizes.spacingBase.get(isMobile, isTablet),
        childAspectRatio: isMobile ? 0.9 : 1.1,
      ),
      itemCount: _getRelatorios(context).length,
      itemBuilder: (context, index) {
        return _buildEnhancedReportCard(_getRelatorios(context)[index], index);
      },
    );
  }

  Widget _buildEnhancedReportCard(Map<String, dynamic> relatorio, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 80)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.85 + (0.15 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: relatorio['gradient'],
          ),
          borderRadius: BorderRadius.circular(
            isMobile ? 20 : (isTablet ? 22 : 24),
          ),
          boxShadow: [
            BoxShadow(
              color: (relatorio['gradient'][0] as Color).withValues(alpha: 0.3),
              blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
                context,
                mobile: 12,
                tablet: 14,
                desktop: 16,
              ),
              offset: Offset(
                0,
                ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 4,
                  tablet: 5,
                  desktop: 6,
                ),
              ),
            ),
          ],
        ),
        child: Material(
          color: ThemeColors.of(context).transparent,
          child: InkWell(
            onTap: () {
              _navigatorKey.currentState?.push(
                MaterialPageRoute(builder: (context) => relatorio['screen']),
              );
            },
            borderRadius: BorderRadius.circular(
              isMobile ? 20 : (isTablet ? 22 : 24),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 8,
                  tablet: 13,
                  desktop: 14,
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (relatorio['alertas'] > 0)
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.getResponsivePadding(
                              context,
                              mobile: 7,
                              tablet: 8,
                              desktop: 9,
                            ),
                            vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
                          ),
                          decoration: BoxDecoration(
                            color: ThemeColors.of(context).error,
                            borderRadius: BorderRadius.circular(
                              isMobile ? 10 : 12,
                            ),
                          ),
                          child: Text(
                            '${relatorio['alertas']}',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 10,
                                mobileFontSize: 9,
                                tabletFontSize: 9.5,
                              ),
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.of(context).surface,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        mobile: relatorio['alertas'] > 0 ? 6 : 0,
                        tablet: relatorio['alertas'] > 0 ? 8 : 0,
                        desktop: relatorio['alertas'] > 0 ? 10 : 0,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(
                        ResponsiveHelper.getResponsivePadding(
                          context,
                          mobile: 4,
                          tablet: 8,
                          desktop: 10,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).surfaceOverlay20,
                        borderRadius: BorderRadius.circular(
                          isMobile ? 6 : 10,
                        ),
                      ),
                      child: Icon(
                        relatorio['icon'],
                        color: ThemeColors.of(context).surface,
                        size: ResponsiveHelper.getResponsiveIconSize(
                          context,
                          mobile: 22,
                          tablet: 28,
                          desktop: 32,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.spacingBaseAlt.get(isMobile, isTablet),
                    ),
                    Text(
                      relatorio['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 11,
                        ),
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        mobile: 1,
                        tablet: 3.5,
                        desktop: 4,
                      ),
                    ),
                    Text(
                      relatorio['subtitle'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 11,
                          mobileFontSize: 9,
                        ),
                        color: ThemeColors.of(context).surfaceOverlay90,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedQuickActions() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeColors.of(context).quickActionsReportsBackground1,
            ThemeColors.of(context).quickActionsReportsBackground2,
          ],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 16 : (isTablet ? 18 : 20)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).quickActionsReportsBackground2.withValues(alpha: 0.5),
            blurRadius: isMobile ? 25 : 30,
            offset: Offset(0, isMobile ? 10 : 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context, mobile: 9, tablet: 9.5, desktop: 10)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).blueLight],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.bolt_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Ações Rápidas',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15, tabletFontSize: 15.5),
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                ),
              ),
            ],
          ),
          ResponsiveSpacing.verticalMedium(context),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: _buildQuickActionButton('Exportar Tudo', Icons.download_rounded, ThemeColors.of(context).quickActionExportarTudo)),
              SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
              Expanded(child: _buildQuickActionButton('Agendar', Icons.schedule_rounded, ThemeColors.of(context).quickActionAgendar)),
              SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
              Expanded(child: _buildQuickActionButton('Email', Icons.email_rounded, ThemeColors.of(context).quickActionEmail)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String label, IconData icon, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return InkWell(
      onTap: () => _mostrarSnackbar(context, '$label - em desenvolvimento'),
      borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSizes.paddingSm.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6)),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10.5),
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentReports() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 16 : (isTablet ? 18 : 20)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context, mobile: 9, tablet: 9.5, desktop: 10)),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).warningPastel,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.access_time_rounded,
                  color: ThemeColors.of(context).warningDark,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Text(
                'Relatrios Recentes',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15, tabletFontSize: 15.5),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          ResponsiveSpacing.verticalMedium(context),
          _buildRecentItem('Vendas - ltimos 30 dias', 'H 5 min', Icons.shopping_cart_rounded, ThemeColors.of(context).success),
          _buildRecentItem('Performance - Anlise IA', 'H 1 hora', Icons.trending_up_rounded, ThemeColors.of(context).success),
          _buildRecentItem('Auditoria - Log completo', 'H 2 horas', Icons.fact_check_rounded, ThemeColors.of(context).primary),
        ],
      ),
    );
  }

  Widget _buildRecentItem(String title, String time, IconData icon, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.spacingBase.get(isMobile, isTablet)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context, mobile: 7, tablet: 7.5, desktop: 8)),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
            ),
            child: Icon(
              icon,
              color: color,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
          ),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10.5),
                    overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 13, tablet: 13.5, desktop: 14),
            color: ThemeColors.of(context).textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedDial(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _mostrarSnackbar(context, 'Menu de ações'),
      backgroundColor: ThemeColors.of(context).success,
      child: Icon(
        Icons.add_rounded,
        size: AppSizes.iconLargeAlt.get(isMobile, isTablet),
      ),
    );
  }

  void _mostrarSnackbar(BuildContext context, String mensagem) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
            const SizedBox(width: 12),
            Expanded(child: Text(mensagem)),
          ],
        ),
        backgroundColor: ThemeColors.of(context).success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}







