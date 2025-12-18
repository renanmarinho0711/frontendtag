import 'package:tagbean/core/enums/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/reports/presentation/providers/reports_provider.dart';
import 'package:tagbean/features/reports/data/models/report_models.dart';
import 'package:tagbean/features/auth/presentation/providers/auth_provider.dart';
import 'package:tagbean/features/tags/presentation/providers/tags_provider.dart';

class RelatoriosOperacionaisScreen extends ConsumerStatefulWidget {
  const RelatoriosOperacionaisScreen({super.key});

  @override
  ConsumerState<RelatoriosOperacionaisScreen> createState() => _RelatoriosOperacionaisScreenState();
}

class _RelatoriosOperacionaisScreenState extends ConsumerState<RelatoriosOperacionaisScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  late AnimationController _refreshController;
  String _periodoSelecionado = '30 dias';
  bool _autoRefresh = true;

  /// Obtãm o storeId do Usuário logado
  String get _storeId {
    final authState = ref.read(authProvider);
    return authState.user?.storeId ?? authState.user?.clientId ?? 'default';
  }

  // Getter conectado ao Provider - dados reais do backend
  OperationalReportsState get _operationalState => ref.watch(operationalReportsProvider);
  
  // Converte os modelos do provider para o formato Map esperado pelos widgets
  List<Map<String, dynamic>> get _relatorios {
    if (_operationalState.reports.isEmpty) {
      return [];
    }
    return _operationalState.reports.map((report) {
      return {
        'titulo': report.titulo,
        'subtitulo': report.categoria,
        'icone': report.icone,
        'cor': report.cor,
        'valor': report.valor,
        'valorNumerico': report.percentualMeta,
        'total': 100,
        'percentual': report.percentualMeta,
        'detalhes': 'ã ${report.titulo}\nã Perãodo: ${report.periodo}\nã Meta: ${report.percentualMeta.toStringAsFixed(1)}%',
        'trend': report.trend == ReportTrend.up ? 'up' : (report.trend == ReportTrend.down ? 'down' : 'stable'),
        'change': report.trend == ReportTrend.up ? '+5%' : (report.trend == ReportTrend.down ? '-5%' : '0%'),
        'prioridade': report.percentualMeta >= 80 ? 'normal' : 'alta',
        'ultimaAtualizacao': 'Atualizado agora',
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController.forward();
    
    if (_autoRefresh) {
      _startAutoRefresh();
    }
    
    // Carregar dados do backend
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(operationalReportsProvider);
      if (state.status == LoadingStatus.initial) {
        ref.read(operationalReportsProvider.notifier).loadReports();
      }
    });
  }

  void _startAutoRefresh() {
    Future.delayed(const Duration(seconds: 30), () async {
      if (mounted && _autoRefresh) {
        _refreshController.repeat();
        
        // Recarregar dados do backend
        await ref.read(operationalReportsProvider.notifier).loadReports();
        
        _refreshController.reset();
        _startAutoRefresh();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _refreshController.dispose();
    super.dispose();
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
                child: _buildContent(),
              ),
            ],
          ),
      )
    );
  }

  Widget _buildContent() {
    // Tratamento de estados de loading e erro
    if (_operationalState.status == LoadingStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_operationalState.status == LoadingStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: ThemeColors.of(context).error),
            const SizedBox(height: 16),
            Text(
              _operationalState.error ?? 'Erro ao carregar dados',
              textAlign: TextAlign.center,
              style: TextStyle(color: ThemeColors.of(context).textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(operationalReportsProvider.notifier).loadReports(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }
    
    if (_relatorios.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard_outlined, size: 64, color: ThemeColors.of(context).textSecondary),
            const SizedBox(height: 16),
            Text(
              'Nenhum dado operacional disponível',
              style: TextStyle(color: ThemeColors.of(context).textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Os dados operacionais serão exibidos quando houver atividade',
              style: TextStyle(color: ThemeColors.of(context).textSecondaryOverlay70, fontSize: 14),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEnhancedHeader(),
            _buildFilterBar(),
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
                  return _buildFooterInfo();
                }
                return _buildEnhancedReportCard(_relatorios[index], index);
              },
            ),
          ],
        ),
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
                colors: [ThemeColors.of(context).info, ThemeColors.of(context).infoDark],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 12 : (isTablet ? 13 : 14),
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).primary.withValues(alpha: 0.3),
                  blurRadius: isMobile ? 10 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.display_settings_rounded,
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
                  'Relatórios Operacionais',
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
                  'Monitoramento de Tags e Sincronização',
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

  Widget _buildEnhancedHeader() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.fromLTRB(
        AppSizes.paddingMd.get(isMobile, isTablet),
        0,
        AppSizes.paddingMd.get(isMobile, isTablet),
        AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingMdAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).info, ThemeColors.of(context).infoDark],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).primary.withValues(alpha: 0.4),
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
                padding: EdgeInsets.all(
                  ResponsiveHelper.getResponsivePadding(context, mobile: 9, tablet: 9.5, desktop: 10),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  border: Border.all(
                    color: ThemeColors.of(context).surfaceOverlay30,
                    width: isMobile ? 1.25 : 1.5,
                  ),
                ),
                child: AnimatedBuilder(
                  animation: _refreshController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _refreshController.value * 2 * math.pi,
                      child: Icon(
                        Icons.settings_rounded,
                        color: ThemeColors.of(context).surface,
                        size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status Operacional',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 16,
                          mobileFontSize: 14,
                          tabletFontSize: 15,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
                    Text(
                      'Monitoramento em Tempo Real',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 13,
                          mobileFontSize: 11,
                          tabletFontSize: 12,
                        ),
                      overflow: TextOverflow.ellipsis,
                        color: ThemeColors.of(context).surfaceOverlay70,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() => _autoRefresh = !_autoRefresh);
                  if (_autoRefresh) _startAutoRefresh();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                    vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 7, tablet: 7.5, desktop: 8),
                  ),
                  decoration: BoxDecoration(
                    color: _autoRefresh ? ThemeColors.of(context).success.withValues(alpha: 0.3) : ThemeColors.of(context).surfaceOverlay20,
                    borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                    border: Border.all(
                      color: _autoRefresh ? ThemeColors.of(context).success : ThemeColors.of(context).surfaceOverlay40,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _autoRefresh ? Icons.autorenew_rounded : Icons.pause_circle_outline_rounded,
                        size: AppSizes.iconTiny.get(isMobile, isTablet),
                        color: ThemeColors.of(context).surface,
                      ),
                      SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6)),
                      Text(
                        _autoRefresh ? 'Auto' : 'Manual',
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
              ),
            ],
          ),
          ResponsiveSpacing.verticalMedium(context),
          // Estatãsticas de tags do backend
          Consumer(
            builder: (context, ref, child) {
              final statsAsync = ref.watch(tagStatsProvider(_storeId));
              final stats = statsAsync.valueOrNull;
              
              final online = stats?.online ?? 0;
              final offline = stats?.offline ?? 0;
              final lowBattery = stats?.lowBattery ?? 0;
              
              return Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingMdAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay15,
                  borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
                  border: Border.all(
                    color: ThemeColors.of(context).surfaceOverlay30,
                    width: isMobile ? 1.25 : 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMiniMetric('$online', 'Online', Icons.check_circle_rounded),
                    Container(
                      width: 1,
                      height: ResponsiveHelper.getResponsiveHeight(context, mobile: 36, tablet: 38, desktop: 40),
                      color: ThemeColors.of(context).surfaceOverlay30,
                    ),
                    _buildMiniMetric('$offline', 'Offline', Icons.cancel_rounded),
                    Container(
                      width: 1,
                      height: ResponsiveHelper.getResponsiveHeight(context, mobile: 36, tablet: 38, desktop: 40),
                      color: ThemeColors.of(context).surfaceOverlay30,
                    ),
                    _buildMiniMetric('$lowBattery', 'Bateria', Icons.battery_alert_rounded),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(String value, String label, IconData icon) {
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
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 20, mobileFontSize: 18, tabletFontSize: 19),
          overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            color: ThemeColors.of(context).surface,
            letterSpacing: -0.8,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10.5),
          overflow: TextOverflow.ellipsis,
            color: ThemeColors.of(context).surfaceOverlay90,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context, mobile: 7, tablet: 7.5, desktop: 8)),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).infoPastel,
              borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
            ),
            child: Icon(
              Icons.filter_list_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
              color: ThemeColors.of(context).infoDark,
            ),
          ),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          Text(
            'Perãodo:',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: _periodoSelecionado,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                color: ThemeColors.of(context).textPrimary,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isMobile ? 9 : 10),
                  borderSide: BorderSide(color: ThemeColors.of(context).infoLight),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                  vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 9, tablet: 9.5, desktop: 10),
                ),
                isDense: true,
              ),
              items: ['Hoje', '7 dias', '15 dias', '30 dias', '90 dias', 'Customizado']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() => _periodoSelecionado = value! );
              },
            ),
          ),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: ThemeColors.of(context).infoDark,
              size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
            ),
            onPressed: () => _refreshData(),
            tooltip: 'Atualizar dados',
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedReportCard(Map<String, dynamic> relatorio, int index) {
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
          border: Border.all(
            color: (relatorio['cor'] as Color).withValues(alpha: 0.3),
            width: isMobile ? 1.5 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (relatorio['cor'] as Color).withValues(alpha: 0.15),
              blurRadius: isMobile ? 20 : 25,
              offset: Offset(0, isMobile ? 6 : 8),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: ThemeColors.of(context).transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.all(
              AppSizes.paddingLgAlt.get(isMobile, isTablet),
            ),
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
                  colors: [
                    // ignore: list_element_type_not_assignable
                    relatorio['cor'],
                    (relatorio['cor'] as Color).withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSizes.paddingXl.get(isMobile, isTablet)),
                boxShadow: [
                  BoxShadow(
                    color: (relatorio['cor'] as Color).withValues(alpha: 0.4),
                    blurRadius: isMobile ? 12 : 15,
                    offset: Offset(0, isMobile ? 5 : 6),
                  ),
                ],
              ),
              child: Icon(
                relatorio['icone'],
                color: ThemeColors.of(context).surface,
                size: AppSizes.iconExtraLarge.get(isMobile, isTablet),
              ),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        relatorio['titulo'],
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 17,
                            mobileFontSize: 15,
                            tabletFontSize: 16,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 11, tablet: 11.5, desktop: 12),
                            color: ThemeColors.of(context).textSecondaryOverlay60,
                          ),
                          SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
                          Text(
                            relatorio['ultimaAtualizacao'],
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 10,
                                mobileFontSize: 9,
                                tabletFontSize: 9.5,
                              ),
                            overflow: TextOverflow.ellipsis,
                              color: ThemeColors.of(context).textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTrendIndicator(relatorio['trend'], relatorio['change']),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
                    _buildPriorityBadge(relatorio['prioridade']),
                  ],
                ),
              ],
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
                Text(
                  relatorio['subtitulo'],
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
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              (relatorio['cor'] as Color).withValues(alpha: 0.15),
                              (relatorio['cor'] as Color).withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                          border: Border.all(
                            color: (relatorio['cor'] as Color).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              relatorio['valor'],
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 16,
                                  mobileFontSize: 14,
                                  tabletFontSize: 15,
                                ),
                              overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: relatorio['cor'],
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
                            Text(
                              'de ${relatorio['total']} total',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 10,
                                  mobileFontSize: 9,
                                  tabletFontSize: 9.5,
                                ),
                              overflow: TextOverflow.ellipsis,
                                color: ThemeColors.of(context).textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Taxa',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 10,
                                    mobileFontSize: 9,
                                    tabletFontSize: 9.5,
                                  ),
                                overflow: TextOverflow.ellipsis,
                                  color: ThemeColors.of(context).textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${relatorio['percentual'].toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 11,
                                    mobileFontSize: 10,
                                    tabletFontSize: 10.5,
                                  ),
                                overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  color: relatorio['cor'],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6)),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                            child: LinearProgressIndicator(
                              value: relatorio['percentual'] / 100,
                              backgroundColor: ThemeColors.of(context).textSecondary,
                              valueColor: AlwaysStoppedAnimation<Color>(relatorio['cor']),
                              minHeight: isMobile ? 7 : 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ThemeColors.of(context).textSecondary,
                      ThemeColors.of(context).textSecondaryOverlay50,
                    ],
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
                            color: (relatorio['cor'] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                          ),
                          child: Icon(
                            Icons.analytics_rounded,
                            size: AppSizes.iconSmall.get(isMobile, isTablet),
                            color: relatorio['cor'],
                          ),
                        ),
                        SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                        Text(
                          'Anãlise Detalhada',
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
                        relatorio['detalhes'],
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
                            onPressed: () => _exportarRelatorio(relatorio['titulo']),
                            icon: Icon(
                              Icons.download_rounded,
                              size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 15, tablet: 15.5, desktop: 16),
                              color: relatorio['cor'],
                            ),
                            label: Text(
                              'Exportar',
                              style: TextStyle(
                                color: relatorio['cor'],
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
                              overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: AppSizes.paddingSm.get(isMobile, isTablet),
                              ),
                              side: BorderSide(color: relatorio['cor'], width: isMobile ? 1.25 : 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _verMaisDetalhes(relatorio['titulo']),
                            icon: Icon(
                              Icons.visibility_rounded,
                              size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 15, tablet: 15.5, desktop: 16),
                            ),
                            label: Text(
                              'Ver Mais',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
                              overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: AppSizes.paddingSm.get(isMobile, isTablet),
                              ),
                              backgroundColor: relatorio['cor'],
                              foregroundColor: ThemeColors.of(context).surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                              ),
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

  Widget _buildTrendIndicator(String trend, String change) {
    final isMobile = ResponsiveHelper.isMobile(context);
    Color trendColor;
    IconData trendIcon;

    switch (trend) {
      case 'up':
        trendColor = ThemeColors.of(context).success;
        trendIcon = Icons.trending_up_rounded;
        break;
      case 'down':
        trendColor = ThemeColors.of(context).error;
        trendIcon = Icons.trending_down_rounded;
        break;
      default:
        trendColor = ThemeColors.of(context).textSecondary;
        trendIcon = Icons.trending_flat_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 9, tablet: 9.5, desktop: 10),
        vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 5, tablet: 5.5, desktop: 6),
      ),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
        border: Border.all(color: trendColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            trendIcon,
            size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 13, tablet: 13.5, desktop: 14),
            color: trendColor,
          ),
          SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
          Text(
            change,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10.5),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: trendColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(String prioridade) {
    final isMobile = ResponsiveHelper.isMobile(context);
    Color badgeColor;
    String badgeText;

    switch (prioridade) {
      case 'alta':
        badgeColor = ThemeColors.of(context).error;
        badgeText = 'ALTA';
        break;
      case 'media':
        badgeColor = ThemeColors.of(context).yellowGold;
        badgeText = 'MãDIA';
        break;
      case 'baixa':
        badgeColor = ThemeColors.of(context).primary;
        badgeText = 'BAIXA';
        break;
      default:
        badgeColor = ThemeColors.of(context).textSecondary;
        badgeText = 'NORMAL';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 7, tablet: 7.5, desktop: 8),
        vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 3.5, tablet: 3.75, desktop: 4),
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, isTablet)),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 9, mobileFontSize: 8, tabletFontSize: 8.5),
        overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold,
          color: badgeColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFooterInfo() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.only(top: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
      padding: EdgeInsets.all(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ThemeColors.of(context).relatoriosGradient,
        ),
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: AppSizes.iconExtraLarge.get(isMobile, isTablet),
            color: ThemeColors.of(context).textSecondary,
          ),
          SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
          Text(
            'Dados atualizados automaticamente',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6)),
          Text(
            'Próxima atualizAção em 30 segundos',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10.5),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    _refreshController.repeat();
    
    // Recarregar dados do backend
    await ref.read(operationalReportsProvider.notifier).loadReports();
    
    _refreshController.reset();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface),
              const SizedBox(width: 12),
              const Text('Dados atualizados com sucesso!'),
            ],
          ),
          backgroundColor: ThemeColors.of(context).success.withValues(alpha: 0.7),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
        ),
      );
    }
  }

  void _exportarRelatorio(String titulo) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
            const SizedBox(width: 12),
            Expanded(child: Text('Exportando: $titulo...')),
          ],
        ),
        backgroundColor: ThemeColors.of(context).infoDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
      ),
    );
  }

  void _verMaisDetalhes(String titulo) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
            const SizedBox(width: 12),
            Expanded(child: Text('Abrindo: $titulo...')),
          ],
        ),
        backgroundColor: ThemeColors.of(context).primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
      ),
    );
  }
}







