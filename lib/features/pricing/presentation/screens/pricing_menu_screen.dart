import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/pricing/presentation/screens/individual_adjustment_screen.dart';
import 'package:tagbean/features/pricing/presentation/screens/percentage_adjustment_screen.dart';
import 'package:tagbean/features/pricing/presentation/screens/fixed_value_screen.dart';
import 'package:tagbean/features/pricing/presentation/screens/margins_screen.dart';
import 'package:tagbean/features/pricing/presentation/screens/dynamic_pricing_screen.dart';
import 'package:tagbean/features/pricing/presentation/screens/adjustments_history_screen.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';

class PrecificacaoMenuScreen extends ConsumerStatefulWidget {
  const PrecificacaoMenuScreen({super.key});

  @override
  ConsumerState<PrecificacaoMenuScreen> createState() => _PrecificacaoMenuScreenState();
}

class _PrecificacaoMenuScreenState extends ConsumerState<PrecificacaoMenuScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  // NOTA: _selectedScreen e _selectedTitle removidos (mortos)

  // Opcoes de menu fixas (sem cores - serão aplicadas dinamicamente)
  static const List<Map<String, dynamic>> _opcoes = [
    {
      'titulo': 'Ajuste por Porcentagem',
      'subtitulo': 'Aumentar ou diminuir em %',
      'icone': Icons.percent_rounded,
      'colorKey': 'pricingPercentage',
      'destaque': false,
    },
    {
      'titulo': 'Ajuste por Valor Fixo',
      'subtitulo': 'Aumentar ou diminuir em R\$',
      'icone': Icons.attach_money_rounded,
      'colorKey': 'pricingFixedValue',
      'destaque': false,
    },
    {
      'titulo': 'Ajuste Individual',
      'subtitulo': 'Alterar produto especfico',
      'icone': Icons.edit_rounded,
      'colorKey': 'pricingIndividual',
      'destaque': false,
    },
    {
      'titulo': 'Reviso de Margens',
      'subtitulo': 'Analisar e ajustar margens',
      'icone': Icons.trending_up_rounded,
      'colorKey': 'pricingMarginReview',
      'destaque': false,
    },
    {
      'titulo': 'Precificao Dinmica',
      'subtitulo': 'Ajuste automtico por IA',
      'icone': Icons.auto_graph_rounded,
      'colorKey': 'pricingDynamic',
      'destaque': false,
    },
    {
      'titulo': 'Histrico de Ajustes',
      'subtitulo': 'Ver mudanas anteriores',
      'icone': Icons.history_rounded,
      'colorKey': 'pricingHistory',
      'destaque': false,
    },
  ];

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

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

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: PopScope(
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
                builder: (context) => Scaffold(
                  backgroundColor: ThemeColors.of(context).surface,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildModernHeader(),
                        SizedBox(
                          height: AppSizes.paddingMd.get(isMobile, isTablet),
                        ),
                        _buildInfoCard(),
                        SizedBox(
                          height: AppSizes.paddingMd.get(isMobile, isTablet),
                        ),
                        _buildAlertasCard(),
                        SizedBox(
                          height: AppSizes.paddingMd.get(isMobile, isTablet),
                        ),
                        _buildEstatisticasRapidas(),
                        SizedBox(
                          height: AppSizes.paddingMd.get(isMobile, isTablet),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mtodos de Ajuste',
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
                                  mobile: 7,
                                  tablet: 7.5,
                                  desktop: 8,
                                ),
                              ),
                              Text(
                                'Escolha a estratgia ideal para seu negcio',
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
                                height: AppSizes.paddingLg.get(isMobile, isTablet),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(
                                    context,
                                    mobile: 3,
                                    tablet: 4,
                                    desktop: 6,
                                  ),
                                  crossAxisSpacing: AppSizes.paddingBase.get(isMobile, isTablet),
                                  mainAxisSpacing: AppSizes.paddingBase.get(isMobile, isTablet),
                                  childAspectRatio: isMobile ? 0.9 : 1.1,
                                ),
                                itemCount: _opcoes.length,
                                itemBuilder: (context, index) {
                                  return _buildOptionCard(_opcoes[index], index);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.paddingXl.get(isMobile, isTablet),
                        ),
                        _buildDicasCard(),
                        SizedBox(
                          height: AppSizes.paddingXl.get(isMobile, isTablet),
                        ),
                        _buildAjudaRapida(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
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
              Icons.price_change_rounded,
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
                  'Precificao',
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
                  height: AppSizes.paddingXxs.get(isMobile, isTablet),
                ),
                Text(
                  'Gesto inteligente de preos',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 10,
                      tabletFontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).surfaceOverlay70,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
              vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).orangeAmber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(
                isMobile ? 8 : 10,
              ),
              border: Border.all(color: ThemeColors.of(context).orangeAmber.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: AppSizes.iconNano.get(isMobile, isTablet),
                  color: ThemeColors.of(context).orangeAmber,
                ),
                SizedBox(
                  width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                Text(
                  'IA',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10,
                      tabletFontSize: 10,
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

  Widget _buildInfoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ThemeColors.of(context).infoModuleBackground, ThemeColors.of(context).infoModuleBackgroundAlt],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 14,
        ),
        border: Border.all(
          color: ThemeColors.of(context).infoModuleBorder,
          width: isMobile ? 1.2 : 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(
              ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 9,
                tablet: 9.5,
                desktop: 10,
              ),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surface,
              borderRadius: BorderRadius.circular(
                isMobile ?  8 : 10,
              ),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: ThemeColors.of(context).infoModuleIcon,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
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
                  'Sobre este Mdulo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                      tabletFontSize: 12.5,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).infoModuleText,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveSpacing(
                    context,
                    mobile: 2,
                    tablet: 2.5,
                    desktop: 2,
                  ),
                ),
                Text(
                  'Ajuste preos de forma inteligente com ferramentas avanadas para otimizar margens.',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10,
                      tabletFontSize: 10.5,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).infoModuleText,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card de alertas de precificao (produtos sem preo, margem negativa)
  /// Usa dados reais do dashboard provider
  Widget _buildAlertasCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Obtm dados reais do dashboard
    final storeStats = ref.watch(storeStatsProvider);
    final dashboardAlerts = ref.watch(dashboardAlertsProvider);
    
    // Constri alertas baseado nos dados reais
    final alertas = <Map<String, dynamic>>[];
    
    // Alerta de produtos sem preo
    final produtosSemPreco = storeStats.productsWithoutPrice;
    if (produtosSemPreco > 0) {
      alertas.add({
        'tipo': 'warning',
        'titulo': 'Produtos sem preo',
        'descricao': '$produtosSemPreco ${produtosSemPreco == 1 ? 'produto precisa' : 'produtos precisam'} de preo definido',
        'icone': Icons.money_off_rounded,
        'cor': ThemeColors.of(context).warning,
        'acao': 'Ver Produtos',
        'actionType': 'sem_preco',
      });
    }
    
    // Alerta de margem negativa (busca nos alertas do dashboard)
    final margemNegativaAlert = dashboardAlerts.where(
      (alert) => alert.type.toLowerCase().contains('margem') || 
                 alert.type.toLowerCase().contains('margin')
    ).toList();
    
    if (margemNegativaAlert.isNotEmpty) {
      final count = margemNegativaAlert.fold(0, (sum, a) => sum + a.count);
      if (count > 0) {
        alertas.add({
          'tipo': 'error',
          'titulo': 'Margem negativa',
          'descricao': '$count ${count == 1 ? 'produto' : 'produtos'} com preo abaixo do custo',
          'icone': Icons.trending_down_rounded,
          'cor': ThemeColors.of(context).error,
          'acao': 'Corrigir',
          'actionType': 'margem_negativa',
        });
      }
    }

    // Se no h alertas, no mostra o card
    if (alertas.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      child: Column(
        children: alertas.map((alerta) => Container(
          margin: EdgeInsets.only(
            bottom: AppSizes.paddingSmAlt.get(isMobile, isTablet),
          ),
          padding: EdgeInsets.all(
            AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          decoration: BoxDecoration(
            color: (alerta['cor'] as Color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: (alerta['cor'] as Color).withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: (alerta['cor'] as Color).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  alerta['icone'] as IconData,
                  color: alerta['cor'] as Color,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alerta['titulo'] as String,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 13,
                        ),
                        fontWeight: FontWeight.bold,
                        color: alerta['cor'] as Color,
                      ),
                    ),
                    Text(
                      alerta['descricao'] as String,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 12,
                          mobileFontSize: 11,
                        ),
                        color: ThemeColors.of(context).textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navegar para lista filtrada
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Abrindo ${alerta['titulo']}...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: alerta['cor'] as Color,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                ),
                child: Text(
                  alerta['acao'] as String,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildEstatisticasRapidas() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    final estatisticas = [
      {'label': 'Produtos', 'valor': '1.247', 'icon': Icons.inventory_2_rounded, 'cor': ThemeColors.of(context).primary, 'mudanca': '+45', 'tipo': 'aumento'},
      {'label': 'Margem Mdia', 'valor': '32.4%', 'icon': Icons.percent_rounded, 'cor': ThemeColors.of(context).success, 'mudanca': '+2.3%', 'tipo': 'percentual'},
      {'label': 'Ajustes Hoje', 'valor': '83', 'icon': Icons.edit_rounded, 'cor': ThemeColors.of(context).blueCyan, 'mudanca': '+12', 'tipo': 'aumento'},
      {'label': 'Pendentes', 'valor': '24', 'icon': Icons.pending_actions_rounded, 'cor': ThemeColors.of(context).orangeMaterial, 'mudanca': 'Ateno', 'tipo': 'status'},
    ];

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
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
        children: [
          isMobile && !ResponsiveHelper.isLandscape(context)
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildEnhancedStatCard(estatisticas[0])),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                        Expanded(child: _buildEnhancedStatCard(estatisticas[1])),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                    Row(
                      children: [
                        Expanded(child: _buildEnhancedStatCard(estatisticas[2])),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                        Expanded(child: _buildEnhancedStatCard(estatisticas[3])),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: estatisticas.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stat = entry.value;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index < estatisticas.length - 1 ? 12 : 0),
                        child: _buildEnhancedStatCard(stat),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatCard(Map<String, dynamic> stat) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

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
          gradient: LinearGradient(
            colors: [
              (stat['cor'] as Color).withValues(alpha: 0.1),
              (stat['cor'] as Color).withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
          border: Border.all(
            color: (stat['cor'] as Color).withValues(alpha: 0.3),
            width: isMobile ? 1.25 : 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              stat['icon'],
              color: stat['cor'],
              size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
            Text(
              stat['valor'],
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: stat['cor'],
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
            Text(
              stat['label'],
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9, tabletFontSize: 9.5),
                overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).textSecondary,
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
                color: (stat['cor'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, isTablet)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (stat['tipo'] == 'aumento')
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 9, tablet: 9.5, desktop: 10),
                      color: stat['cor'],
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
                        color: stat['cor'],
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

  Widget _buildOptionCard(Map<String, dynamic> opcao, int index) {
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
            colors: opcao['gradiente'],
          ),
          borderRadius: BorderRadius.circular(
            isMobile ? 20 : (isTablet ? 22 : 24),
          ),
          boxShadow: [
            BoxShadow(
              color: (opcao['gradiente'][0] as Color).withValues(alpha: 0.3),
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
              final titulo = opcao['titulo'];
              Widget? destino;
              
              if (titulo == 'Ajuste por Porcentagem') {
                destino = const AjustePorcentagemScreen();
              } else if (titulo == 'Ajuste por Valor Fixo') {
                destino = const AjusteValorFixoScreen();
              } else if (titulo == 'Ajuste Individual') {
                destino = const AjusteIndividualScreen();
              } else if (titulo == 'Reviso de Margens') {
                destino = const RevisaoMargensScreen();
              } else if (titulo == 'Precificao Dinmica') {
                destino = const PrecificacaoDinamicaScreen();
              } else if (titulo == 'Histrico de Ajustes') {
                destino = const HistoricoAjustesScreen();
              }
              
              if (destino != null) {
                _navigatorKey.currentState?.push(
                  MaterialPageRoute(builder: (context) => destino! ),
                );
              }
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
                        opcao['icone'],
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
                      height: AppSizes.paddingBaseAlt.get(isMobile, isTablet),
                    ),
                    Text(
                      opcao['titulo'],
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
                      opcao['subtitulo'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 12,
                          mobileFontSize: 10,
                          tabletFontSize: 11,
                        ),
                        color: ThemeColors.of(context).surfaceOverlay90,
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

  Widget _buildDicasCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 18,
          tablet: 20,
          desktop: 22,
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).cyanMain.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 18 : 20,
        ),
        border: Border.all(
          color: ThemeColors.of(context).infoLight,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 9,
                    tablet: 9.5,
                    desktop: 10,
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).info, ThemeColors.of(context).cyanMain],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.lightbulb_rounded,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                  color: ThemeColors.of(context).surface,
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Dicas de Precificao',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 17,
                    mobileFontSize: 15,
                    tabletFontSize: 16,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).infoDark,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          ),
          _buildDicaItem('Sempre revise as sugestes antes de aplicar'),
          _buildDicaItem('Considere a sazonalidade dos produtos'),
          _buildDicaItem('Monitore a concorrncia regularmente'),
          _buildDicaItem('Margem ideal varia entre 25% e 45%'),
        ],
      ),
    );
  }

  Widget _buildDicaItem(String text) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 9,
          tablet: 9.5,
          desktop: 10,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: ResponsiveHelper.getResponsiveIconSize(
              context,
              mobile: 15,
              tablet: 15.5,
              desktop: 16,
            ),
            color: ThemeColors.of(context).infoDark,
          ),
          SizedBox(
            width: ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 9,
              tablet: 9.5,
              desktop: 10,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12.5,
                ),
              overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAjudaRapida() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingLgAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).infoModuleBackground, ThemeColors.of(context).infoModuleBackgroundAlt],
        ),
              borderRadius: BorderRadius.circular(
          isMobile ? 16 : 18,
        ),
        border: Border.all(color: ThemeColors.of(context).primaryLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.help_outline_rounded,
            color: ThemeColors.of(context).primaryDark,
            size: AppSizes.iconLargeAlt.get(isMobile, isTablet),
          ),
          SizedBox(
            width: AppSizes.paddingSm.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Precisa de Ajuda?',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 15,
                      mobileFontSize: 14,
                      tabletFontSize: 14.5,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).primaryDark,
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
                  'Veja o guia completo de precificao',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11.5,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(
              ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 9,
                tablet: 9.5,
                desktop: 10,
              ),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).primaryDark,
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            ),
          ),
        ],
      ),
    );
  }
}






