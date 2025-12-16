import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/enums/loading_status.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/reports/presentation/providers/reports_provider.dart';
import 'package:tagbean/features/reports/data/models/report_models.dart';

class relatoriosVendasScreen extends ConsumerStatefulWidget {
  const relatoriosVendasScreen({super.key});

  @override
  ConsumerState<relatoriosVendasScreen> createState() => _relatoriosVendasScreenState();
}

class _relatoriosVendasScreenState extends ConsumerState<relatoriosVendasScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  late AnimationController _chartController;

  // Getters conectados ao Provider
  SalesReportsState get _salesState => ref.watch(salesReportsProvider);
  String get _periodoSelecionado => _salesState.periodoSelecionado;
  String get _visualizacao => _salesState.visualizacao;
  List<SalesReportModel> get _relatorios => _salesState.reports;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animationController.forward();
    _chartController.forward();
    
    // Inicializa provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(salesReportsProvider);
      if (state.status == LoadingStatus.initial) {
        ref.read(salesReportsProvider.notifier).loadReports();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _chartController.dispose();
    super.dispose();
  }

  /// Resolve colorKey do modelo em uma Color dinâmica
  /// ESSENCIAL: Converte string semântica em cor real usando tema atual
  Color _resolveColorFromKey(String colorKey) {
    final themeColors = ThemeColors.of(context);
    return themeColors.getColorByKey(colorKey) ?? themeColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildEnhancedSummaryHeader(),
                      _buildEnhancedFilterBar(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: ResponsiveHelper.getResponsiveEdgeInsetsSymmetric(
                          context,
                          mobileHorizontal: 16,
                          mobileVertical: 16,
                          tabletHorizontal: 20,
                          tabletVertical: 20,
                          desktopHorizontal: 24,
                          desktopVertical: 24,
                        ),
                        itemCount: _relatorios.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _relatorios.length) {
                            return _buildComparisonChart();
                          }
                          return _buildEnhancedReportCard(_relatorios[index], index);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      )
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
        vertical: AppSizes.paddingMdLg.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 20 : (isTablet ? 22 : 24),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.08),
            blurRadius: isMobile ? 20 : (isTablet ? 22 : 25),
            offset: Offset(0, isMobile ? 5 : 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textSecondary,
                size: ResponsiveHelper.getResponsiveIconSize(
                  context,
                  mobile: 19,
                  tablet: 19.5,
                  desktop: 20,
                ),
              ),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 7,
                  tablet: 7.5,
                  desktop: 8,
                ),
              ),
              constraints: const BoxConstraints(),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).success, ThemeColors.of(context).materialTeal.withValues(alpha: 0.6)],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 12 : (isTablet ? 13 : 14),
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).successLight,
                  blurRadius: isMobile ? 10 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.assessment_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconLarge.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'relatorios de Vendas',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 20,
                      mobileFontSize: 17,
                      tabletFontSize: 18.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 3,
                    tablet: 3.5,
                    desktop: 4,
                  ),
                ),
                Text(
                  'Análise de Performance Comercial',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 11,
                      tabletFontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile || ResponsiveHelper.isLandscape(context))
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                vertical: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 5,
                  tablet: 5.5,
                  desktop: 6,
                ),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).successPastel,
                borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                border: Border.all(color: ThemeColors.of(context).success),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: AppSizes.iconTiny.get(isMobile, isTablet),
                    color: ThemeColors.of(context).successIcon,
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 5,
                      tablet: 5.5,
                      desktop: 6,
                    ),
                  ),
                  Text(
                    'Guia',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                        tabletFontSize: 10.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.of(context).successIcon,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEnhancedSummaryHeader() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.fromLTRB(
        AppSizes.paddingMd.get(isMobile, isTablet),
        0,
        AppSizes.paddingMd.get(isMobile, isTablet),
        AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ThemeColors.of(context).success, ThemeColors.of(context).materialTeal.withValues(alpha: 0.6)],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).success.withValues(alpha: 0.4),
            blurRadius: isMobile ? 20 : 25,
            offset: Offset(0, isMobile ? 8 : 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context, mobile: 9, tablet: 9.5, desktop: 10)),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  border: Border.all(color: ThemeColors.of(context).surfaceOverlay30, width: isMobile ? 1.25 : 1.5),
                ),
                child: Icon(
                  Icons.attach_money_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total de Vendas',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
                      overflow: TextOverflow.ellipsis,
                        color: ThemeColors.of(context).surfaceOverlay70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 1.5, tablet: 1.75, desktop: 2)),
                    Text(
                      _salesState.totalVendasFormatted,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 24, mobileFontSize: 21, tabletFontSize: 22.5),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
                  border: Border.all(color: ThemeColors.of(context).surfaceOverlay30, width: isMobile ? 1.25 : 1.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6)),
                    Text(
                      _salesState.crescimentoMedio,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15, tabletFontSize: 15.5),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                      ),
                    ),
                    Text(
                      'vs. anterior',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 9, mobileFontSize: 8, tabletFontSize: 8.5),
                      overflow: TextOverflow.ellipsis,
                        color: ThemeColors.of(context).surfaceOverlay90,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ResponsiveSpacing.verticalMedium(context),
          Container(
            padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay15,
              borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
              border: Border.all(color: ThemeColors.of(context).surfaceOverlay30, width: isMobile ? 1.25 : 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniStat(_salesState.ticketMedioFormatted, 'Ticket Médio', Icons.receipt_long_rounded),
                Container(
                  width: 1,
                  height: ResponsiveHelper.getResponsiveHeight(context, mobile: 36, tablet: 38, desktop: 40),
                  color: ThemeColors.of(context).surfaceOverlay30,
                ),
                _buildMiniStat('${_salesState.totalItensVendidos}', 'Itens/dia', Icons.shopping_cart_rounded),
                Container(
                  width: 1,
                  height: ResponsiveHelper.getResponsiveHeight(context, mobile: 36, tablet: 38, desktop: 40),
                  color: ThemeColors.of(context).surfaceOverlay30,
                ),
                _buildMiniStat('${_salesState.totalProdutosVendidos}', 'Produtos', Icons.inventory_2_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String value, String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: ThemeColors.of(context).surface,
          size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
        ),
        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6)),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15, tabletFontSize: 15.5),
          overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            color: ThemeColors.of(context).surface,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9, tabletFontSize: 9.5),
          overflow: TextOverflow.ellipsis,
            color: ThemeColors.of(context).surfaceOverlay90,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedFilterBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.fromLTRB(
        AppSizes.paddingMd.get(isMobile, isTablet),
        0,
        AppSizes.paddingMd.get(isMobile, isTablet),
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet),
        vertical: AppSizes.paddingSm.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 12 : 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context, mobile: 7, tablet: 7.5, desktop: 8)),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).successPastel,
                  borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.date_range_rounded,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                  color: ThemeColors.of(context).successIcon,
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Text(
                'Período:',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _periodoSelecionado,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                    color: ThemeColors.of(context).textPrimary,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                      borderSide: BorderSide(color: ThemeColors.of(context).successLight),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                      vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 9, tablet: 9.5, desktop: 10),
                    ),
                    isDense: true,
                  ),
                  items: ['Hoje', '7 dias', '15 dias', '30 dias', '90 dias', '1 ano']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(salesReportsProvider.notifier).setPeriodo(value);
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: _buildViewButton('cards', 'Cards', Icons.view_agenda_rounded)),
              SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
              Expanded(child: _buildViewButton('lista', 'Lista', Icons.list_rounded)),
              SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
              Expanded(child: _buildViewButton('grafico', 'Gráfico', Icons.bar_chart_rounded)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewButton(String view, String label, IconData icon) {
    final isSelected = _visualizacao == view;
    final isMobile = ResponsiveHelper.isMobile(context);

    return InkWell(
      onTap: () => ref.read(salesReportsProvider.notifier).setVisualizacao(view),
      borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 9, tablet: 9.5, desktop: 10),
        ),
        decoration: BoxDecoration(
          gradient: isSelected ?  LinearGradient(colors: [ThemeColors.of(context).success, ThemeColors.of(context).successDark]) : null,
          color: isSelected ? null : ThemeColors.of(context).textSecondary,
          borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 15, tablet: 15.5, desktop: 16),
              color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
            ),
            SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6)),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10.5),
              overflow: TextOverflow.ellipsis,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ?  ThemeColors.of(context).surface : ThemeColors.of(context).textSecondaryOverlay80,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedReportCard(SalesReportModel relatorio, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 60)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: AppSizes.spacingMdAlt.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(isMobile ? 20 : (isTablet ? 22 : 24)),
          border: Border.all(color: relatorio.corLight, width: isMobile ?  1.5 : 2),
          boxShadow: [
            BoxShadow(
              color: relatorio.corLight,
              blurRadius: isMobile ? 20 : 25,
              offset: Offset(0, isMobile ? 6 : 8),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: ThemeColors.of(context).transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.all(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
            childrenPadding: EdgeInsets.fromLTRB(
              AppSizes.paddingLgAlt.get(isMobile, isTablet),
              0,
              AppSizes.paddingLgAlt.get(isMobile, isTablet),
              AppSizes.paddingLgAlt.get(isMobile, isTablet),
            ),
            leading: Container(
              width: ResponsiveHelper.getResponsiveWidth(context, mobile: 60, tablet: 64, desktop: 68),
              height: ResponsiveHelper.getResponsiveHeight(context, mobile: 60, tablet: 64, desktop: 68),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [relatorio.cor, relatorio.cor.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(isMobile ? 16 : 18),
                boxShadow: [
                  BoxShadow(
                    color: relatorio.cor.withValues(alpha: 0.4),
                    blurRadius: isMobile ? 12 : 15,
                    offset: Offset(0, isMobile ? 5 : 6),
                  ),
                ],
              ),
              child: Icon(
                relatorio.icone,
                color: ThemeColors.of(context).surface,
                size: AppSizes.iconExtraLarge.get(isMobile, isTablet),
              ),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    relatorio.titulo,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 17, mobileFontSize: 15, tabletFontSize: 16),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 9, tablet: 9.5, desktop: 10),
                    vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 4, tablet: 4.5, desktop: 5),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        relatorio.corLight,
                        relatorio.corLight,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                    border: Border.all(color: relatorio.corLight),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        relatorio.trend == ReportTrend.up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 11, tablet: 11.5, desktop: 12),
                        color: relatorio.cor,
                      ),
                      SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
                      Text(
                        relatorio.crescimento,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10.5),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: relatorio.cor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
                Text(
                  relatorio.subtitulo,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
                SizedBox(height: AppSizes.spacingSm.get(isMobile, isTablet)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              relatorio.corLight,
                              relatorio.corLight,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                          border: Border.all(color: relatorio.corLight),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              relatorio.valor,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
                              overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: relatorio.cor,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
                            Text(
                              relatorio.quantidade,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10.5),
                              overflow: TextOverflow.ellipsis,
                                color: ThemeColors.of(context).textSecondary,
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
                            if (relatorio.badge != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 7, tablet: 7.5, desktop: 8),
                                vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 3.5, tablet: 3.75, desktop: 4),
                              ),
                              decoration: BoxDecoration(
                                color: relatorio.corLight,
                                borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, isTablet)),
                              ),
                              child: Text(
                                relatorio.badge!,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 9, mobileFontSize: 8, tabletFontSize: 8.5),
                                overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  color: relatorio.cor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 9, tablet: 9.5, desktop: 10)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 9, tablet: 9.5, desktop: 10),
                    vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 5, tablet: 5.5, desktop: 6),
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).textSecondary,
                    borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.flag_rounded,
                        size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 11, tablet: 11.5, desktop: 12),
                        color: ThemeColors.of(context).textSecondary,
                      ),
                      SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6)),
                      Text(
                        relatorio.meta,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10.5),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).textSecondary, ThemeColors.of(context).textSecondaryOverlay50],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
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
                            color: relatorio.corLight,
                            borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                          ),
                          child: Icon(
                            Icons.analytics_rounded,
                            size: AppSizes.iconSmall.get(isMobile, isTablet),
                            color: relatorio.cor,
                          ),
                        ),
                        SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                        Text(
                          'Breakdown Detalhado',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14.5),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).textPrimary,
                          ),
                        ),
                      ],
                    ),
                    ResponsiveSpacing.verticalMedium(context),
                    Container(
                      padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).surface,
                        borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                        border: Border.all(color: ThemeColors.of(context).textSecondary),
                      ),
                      child: Text(
                        relatorio.detalhes,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                          height: 1.7,
                        ),
                      ),
                    ),
                    ResponsiveSpacing.verticalMedium(context),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _exportarrelatorio(relatorio),
                            icon: Icon(
                              Icons.file_download_rounded,
                              size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 15, tablet: 15.5, desktop: 16),
                              color: relatorio.cor,
                            ),
                            label: Text(
                              'Exportar',
                              style: TextStyle(
                                color: relatorio.cor,
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
                              overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: AppSizes.paddingSm.get(isMobile, isTablet),
                              ),
                              side: BorderSide(color: relatorio.cor, width: isMobile ? 1.25 : 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _verDetalhesrelatorio(relatorio),
                            icon: Icon(
                              Icons.open_in_new_rounded,
                              size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 15, tablet: 15.5, desktop: 16),
                            ),
                            label: Text(
                              'Detalhes',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
                              overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: AppSizes.paddingSm.get(isMobile, isTablet),
                              ),
                              backgroundColor: relatorio.cor,
                              foregroundColor: ThemeColors.of(context).surface,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonChart() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.only(top: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
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
                  gradient: LinearGradient(colors: [ThemeColors.of(context).success, ThemeColors.of(context).successDark]),
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Text(
                'Comparativo de Per�odos',
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
          _buildChartBar('Mês Atual', 103500, 103500, ThemeColors.of(context).success),
          SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
          _buildChartBar('Mês Anterior', 90000, 103500, ThemeColors.of(context).primary),
          SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
          _buildChartBar('Há 2 Meses', 85000, 103500, ThemeColors.of(context).greenMaterial),
          ResponsiveSpacing.verticalMedium(context),
          Container(
            padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).successPastel,
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.insights_rounded,
                  color: ThemeColors.of(context).successIcon,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
                SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                Expanded(
                  child: Text(
                    'Crescimento consistente de 15% ao m�s',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).successIcon,
                      fontWeight: FontWeight.bold,
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

  Widget _buildChartBar(String label, double value, double maxValue, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: ResponsiveHelper.getResponsiveWidth(context, mobile: 90, tablet: 95, desktop: 100),
          child: Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: _chartController,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                child: LinearProgressIndicator(
                  value: (value / maxValue) * _chartController.value,
                  minHeight: ResponsiveHelper.getResponsiveHeight(context, mobile: 28, tablet: 30, desktop: 32),
                  backgroundColor: ThemeColors.of(context).textSecondary,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              );
            },
          ),
        ),
        SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
        SizedBox(
          width: ResponsiveHelper.getResponsiveWidth(context, mobile: 70, tablet: 75, desktop: 80),
          child: Text(
            'R\$ ${(value / 1000).toStringAsFixed(1)}K',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  /// Exporta relatorio em formato selecionado
  void _exportarrelatorio(SalesReportModel relatorio) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeColors.of(context).transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: relatorio.corLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.file_download_rounded, color: relatorio.cor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Exportar relatorio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(relatorio.titulo, style: TextStyle(fontSize: 13, color: ThemeColors.of(context).grey600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildExportOption('PDF', Icons.picture_as_pdf_rounded, ThemeColors.of(context).errorDark),
            const SizedBox(height: 12),
            _buildExportOption('Excel', Icons.table_chart_rounded, ThemeColors.of(context).green700),
            const SizedBox(height: 12),
            _buildExportOption('CSV', Icons.description_rounded, ThemeColors.of(context).blueDark),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption(String format, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: ThemeColors.of(context).surfaceOverlay20, borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: ThemeColors.of(context).surface, size: 18),
                ),
                const SizedBox(width: 12),
                Text('Exportando para $format...'),
              ],
            ),
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorLight),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Text(format, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colorLight),
          ],
        ),
      ),
    );
  }

  /// Ver detalhes do relatorio
  void _verDetalhesrelatorio(SalesReportModel relatorio) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: ThemeColors.of(context).surfaceOverlay20, borderRadius: BorderRadius.circular(8)),
              child: Icon(relatorio.icone, color: ThemeColors.of(context).surface, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text('Abrindo ${relatorio.titulo}...')),
          ],
        ),
        backgroundColor: relatorio.cor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}









