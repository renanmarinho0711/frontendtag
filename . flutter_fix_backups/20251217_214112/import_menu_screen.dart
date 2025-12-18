import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/import_export/presentation/screens/import_products_screen.dart';
import 'package:tagbean/features/import_export/presentation/screens/import_tags_screen.dart';
import 'package:tagbean/features/import_export/presentation/screens/export_products_screen.dart';
import 'package:tagbean/features/import_export/presentation/screens/export_tags_screen.dart';
import 'package:tagbean/features/import_export/presentation/screens/batch_operations_screen.dart';
import 'package:tagbean/features/import_export/presentation/providers/import_export_provider.dart';
import 'package:tagbean/features/import_export/data/models/import_export_models.dart';
import 'package:tagbean/features/products/presentation/providers/products_state_provider.dart';
import 'package:tagbean/features/tags/presentation/providers/tags_provider.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';

class ImportacaoMenuScreen extends ConsumerStatefulWidget {
  const ImportacaoMenuScreen({super.key});

  @override
  ConsumerState<ImportacaoMenuScreen> createState() => _ImportacaoMenuScreenState();
}

class _ImportacaoMenuScreenState extends ConsumerState<ImportacaoMenuScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  int _hoveredIndex = -1;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  /// Opes de menu dinmicas baseadas nos dados dos providers
  List<Map<String, dynamic>> get _opcoes {
    // Busca dados dos providers
    final productsState = ref.watch(productsListRiverpodProvider);
    final tagsState = ref.watch(tagsNotifierProvider);
    final importHistory = ref.watch(importHistoryProvider);
    
    final totalProdutos = productsState.products.length;
    final totalTags = tagsState.tags.length;
    final totalHistorico = importHistory.maybeWhen(
      data: (history) => history.length,
      orElse: () => 0,
    );
    
    return [
      {
        'titulo': 'Importar Produtos',
        'subtitulo': 'Upload via Excel/CSV',
        'descricao': 'Cadastre mltiplos produtos de uma vez',
        'icone': Icons.upload_rounded,
        'gradiente': [ThemeColors.of(context).importProdutos, ThemeColors.of(context).importProdutosDark],
        'badge': 'Rápido',
        'tagsCount': totalProdutos > 0 ? '$totalProdutos produtos' : 'Nenhum produto',
        'ultimaAcao': _menuState.lastProductImport ?? 'Nunca',
      },
      {
        'titulo': 'Importar Tags',
        'subtitulo': 'Cadastro em lote',
        'descricao': 'Adicione etiquetas ESL massivamente',
        'icone': Icons.upload_file_rounded,
        'gradiente': [ThemeColors.of(context).importTags, ThemeColors.of(context).importTagsDark],
        'badge': 'Popular',
        'tagsCount': totalTags > 0 ? '$totalTags tags' : 'Nenhuma tag',
        'ultimaAcao': _menuState.lastTagImport ?? 'Nunca',
      },
      {
        'titulo': 'Exportar Produtos',
        'subtitulo': 'Excel, CSV ou PDF',
        'descricao': 'Baixe relatrio completo de produtos',
        'icone': Icons.download_rounded,
        'gradiente': [ThemeColors.of(context).exportProdutos, ThemeColors.of(context).exportProdutosDark],
        'badge': null,
        'tagsCount': '3 formatos',
        'ultimaAcao': _menuState.lastProductExport ?? 'Nunca',
      },
      {
        'titulo': 'Exportar Tags',
        'subtitulo': 'Relatrio completo',
        'descricao': 'Exporte dados das etiquetas',
        'icone': Icons.download_for_offline_rounded,
        'gradiente': [ThemeColors.of(context).exportTags, ThemeColors.of(context).exportTagsDark],
        'badge': null,
        'tagsCount': 'Multi-formato',
        'ultimaAcao': _menuState.lastTagExport ?? 'Nunca',
      },
      {
        'titulo': 'Operações em Lote',
        'subtitulo': 'Ações massivas',
        'descricao': 'Atualize, delete ou modifique em massa',
        'icone': Icons.layers_rounded,
        'gradiente': [ThemeColors.of(context).batchOperations, ThemeColors.of(context).batchOperationsDark],
        'badge': 'Avanado',
        'tagsCount': '6 operações',
        'ultimaAcao': _menuState.lastBatchOperation ?? 'Nunca',
      },
      {
        'titulo': 'Histórico',
        'subtitulo': 'Ver todas as ações',
        'descricao': 'Consulte histórico completo de operações',
        'icone': Icons.history_rounded,
        'gradiente': [ThemeColors.of(context).importHistorico, ThemeColors.of(context).importHistoricoDark],
        'badge': totalHistorico > 0 ? 'Novo' : null,
        'tagsCount': totalHistorico > 0 ? '$totalHistorico registros' : 'Sem registros',
        'ultimaAcao': 'Agora',
      },
    ];
  }

  // Estatsticas carregadas via provider
  ImportMenuState get _menuState => ref.watch(importMenuProvider);
  ImportMenuNotifier get _menuNotifier => ref.read(importMenuProvider.notifier);
  
  List<Map<String, dynamic>> get _estatisticas {
    final stats = _menuState.statistics;
    if (stats.isEmpty) {
      // Retorna estatsticas padro enquanto carrega do backend
      return [
        {'label': 'Produtos', 'valor': '-', 'icon': Icons.inventory_2_rounded, 'cor': ThemeColors.of(context).statProdutosIcon, 'mudanca': '-', 'tipo': 'status'},
        {'label': 'Tags ESL', 'valor': '-', 'icon': Icons.sell_rounded, 'cor': ThemeColors.of(context).statTagsESLIcon, 'mudanca': '-', 'tipo': 'status'},
        {'label': 'Última Sync', 'valor': '-', 'icon': Icons.sync_rounded, 'cor': ThemeColors.of(context).statSyncIcon, 'mudanca': 'Aguardando', 'tipo': 'status'},
        {'label': 'Pendentes', 'valor': '-', 'icon': Icons.pending_actions_rounded, 'cor': ThemeColors.of(context).statPendentesIcon, 'mudanca': '-', 'tipo': 'status'},
      ];
    }
    return stats.map((s) => {
      'label': s.label,
      'valor': s.value,
      'icon': s.icon,
      'cor': s.color,
      'mudanca': s.change,
      'tipo': s.changeType,
    }).toList();
  }

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
    
    // Carregar estatsticas do backend
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _menuNotifier.loadStatistics();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => _buildMainMenu(),
        );
      },
    );
  }

  Widget _buildMainMenu() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SingleChildScrollView(
        child: Column(
                  children: [
                    _buildPremiumHeader(),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    _buildInfoCard(),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    _buildEnhancedStatusCards(),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    _buildQuickActions(),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ferramentas Disponveis',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 22,
                                    mobileFontSize: 18,
                                    tabletFontSize: 20,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.8,
                                ),
                              ),
                              SizedBox(
                                height: AppSizes.paddingXxs.get(isMobile, isTablet),
                              ),
                              Text(
                                'Escolha uma opo para comear',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 14,
                                    mobileFontSize: 12,
                                    tabletFontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  color: ThemeColors.of(context).textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                              vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                            ),
                            decoration: BoxDecoration(
                              color: ThemeColors.of(context).primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                              border: Border.all(color: ThemeColors.of(context).primary.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.apps_rounded,
                                  size: AppSizes.iconTiny.get(isMobile, isTablet),
                                  color: ThemeColors.of(context).primary.withValues(alpha: 0.8),
                                ),
                                SizedBox(
                                  width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                                ),
                                Text(
                                  '${_opcoes.length} tools',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      baseFontSize: 12,
                                      mobileFontSize: 10,
                                      tabletFontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    color: ThemeColors.of(context).primary.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.cardPadding.get(isMobile, isTablet),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 3 : 6,
                          crossAxisSpacing: AppSizes.spacingBase.get(isMobile, isTablet),
                          mainAxisSpacing: AppSizes.spacingBase.get(isMobile, isTablet),
                          childAspectRatio: isMobile ? 0.9 : 1.1,
                        ),
                        itemCount: _opcoes.length,
                        itemBuilder: (gridContext, index) {
                          return _buildEnhancedCard(_opcoes[index], index);
                        },
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.paddingXl.get(isMobile, isTablet),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                      ),
                      child: _buildEnhancedTipsCard(),
                    ),
                    SizedBox(
                      height: AppSizes.paddingXl.get(isMobile, isTablet),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                      ),
                      child: _buildRecentActivity(),
                    ),
                    SizedBox(
                      height: AppSizes.paddingXl.get(isMobile, isTablet),
                    ),
                  ],
                ),
              ),
            );
  }

  Widget _buildPremiumHeader() {
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
              Icons.swap_vert_rounded,
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
                  'Importação / Exportação',
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
                  height: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 3,
                    tablet: 4,
                    desktop: 4,
                  ),
                ),
                Text(
                  'Gerenciamento de Dados em Massa',
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
              color: ThemeColors.of(context).success.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(
                isMobile ? 8 : 10,
              ),
              border: Border.all(color: ThemeColors.of(context).success.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  size: AppSizes.iconNano.get(isMobile, isTablet),
                  color: ThemeColors.of(context).success,
                ),
                SizedBox(
                  width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                Text(
                  'Online',
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

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).cyanMain.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 14,
        ),
        border: Border.all(
          color: ThemeColors.of(context).infoLight,
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
              color: ThemeColors.of(context).surface,
              borderRadius: BorderRadius.circular(
                isMobile ?  8 : 10,
              ),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: ThemeColors.of(context).infoDark,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 10,
              tablet: 11,
              desktop: 12,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sobre este Módulo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                      tabletFontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).primary,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 2,
                    tablet: 2,
                    desktop: 2,
                  ),
                ),
                Text(
                  'Importe e exporte produtos e etiquetas em lote com estatsticas em tempo real.',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10,
                      tabletFontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).infoDark,
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

  Widget _buildEnhancedStatusCards() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      child: Row(
        children: _estatisticas.asMap().entries.map((entry) {
          final index = entry.key;
          final stat = entry.value;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index < _estatisticas.length - 1
                    ? ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 10,
                        tablet: 11,
                        desktop: 12,
                      )
                    : 0,
              ),
              child: _buildEnhancedStatusCard(stat),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEnhancedStatusCard(Map<String, dynamic> stat) {
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
          gradient: LinearGradient(
            colors: [
              (stat['cor'] as Color).withValues(alpha: 0.25),
              (stat['cor'] as Color).withValues(alpha: 0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
          border: Border.all(
            color: (stat['cor'] as Color).withValues(alpha: 0.5),
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

  Widget _buildQuickActions() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeColors.of(context).quickActionsImportBackground1,
            ThemeColors.of(context).quickActionsImportBackground2,
          ],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).quickActionsImportBackground2.withValues(alpha: 0.5),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 8 : 10,
                  ),
                ),
                child: Icon(
                  Icons.flash_on_rounded,
                  color: ThemeColors.of(context).surface,
                  size: ResponsiveHelper.getResponsiveIconSize(
                    context,
                    mobile: 18,
                    tablet: 19,
                    desktop: 20,
                  ),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Ações Rápidas',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 14,
                    tabletFontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Template',
                  Icons.download_rounded,
                  ThemeColors.of(context).quickActionTemplateBackground,
                  ThemeColors.of(context).quickActionTemplateBorder,
                  _downloadTemplate,
                ),
              ),
              SizedBox(
                width: AppSizes.paddingSmAlt.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildQuickActionButton(
                  'Upload',
                  Icons.upload_rounded,
                  ThemeColors.of(context).quickActionUploadBackground,
                  ThemeColors.of(context).quickActionUploadBorder,
                  _startUpload,
                ),
              ),
              SizedBox(
                width: AppSizes.paddingSmAlt.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildQuickActionButton(
                  'Histórico',
                  Icons.history_rounded,
                  ThemeColors.of(context).quickActionHistoricoBackground,
                  ThemeColors.of(context).quickActionHistoricoBorder,
                  _showHistory,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _downloadTemplate() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).success, size: 48),
        title: const Text('Baixar Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selecione o tipo de template:'),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.inventory_2_rounded, color: ThemeColors.of(context).blueCyan),
              title: const Text('Template de Produtos'),
              subtitle: const Text('CSV com colunas de produtos'),
              onTap: () {
                Navigator.pop(context);
                _executarDownloadTemplate('products');
              },
            ),
            ListTile(
              leading: Icon(Icons.check_rounded, color: ThemeColors.of(context).primary),
              title: const Text('Template de Tags'),
              subtitle: const Text('CSV com colunas de tags'),
              onTap: () {
                Navigator.pop(context);
                _executarDownloadTemplate('tags');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Future<void> _executarDownloadTemplate(String type) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: ThemeColors.of(context).surface),
            ),
            const SizedBox(width: 16),
            Text('Baixando template de $type...'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Simula tempo de download - TODO: integrar com endpoint de templates quando disponvel
    await Future.delayed(const Duration(seconds: 1));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Template baixado com sucesso!'),
        backgroundColor: ThemeColors.of(context).success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _startUpload() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).primary, size: 48),
        title: const Text('Iniciar Upload'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('O que deseja importar?'),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.inventory_2_rounded, color: ThemeColors.of(context).blueCyan),
              title: const Text('Produtos'),
              subtitle: const Text('Importar via Excel/CSV'),
              onTap: () {
                Navigator.pop(context);
                _navegarPara('Importar Produtos');
              },
            ),
            ListTile(
              leading: Icon(Icons.check_rounded, color: ThemeColors.of(context).primary),
              title: const Text('Tags/ESL'),
              subtitle: const Text('Importar via Excel/CSV'),
              onTap: () {
                Navigator.pop(context);
                _navegarPara('Importar Tags');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showHistory() {
    final importHistory = ref.read(importHistoryProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.history_rounded, color: ThemeColors.of(context).orangeMaterial, size: 48),
        title: const Text('Histórico de Importações'),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: importHistory.when(
            data: (history) => history.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history_rounded, size: 48, color: ThemeColors.of(context).textSecondary),
                        const SizedBox(height: 16),
                        Text('Nenhuma importação realizada', style: TextStyle(color: ThemeColors.of(context).textSecondary)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      final isCompleted = item.status == ImportStatus.completed;
                      final statusColor = isCompleted
                          ? ThemeColors.of(context).success
                          : item.status == ImportStatus.failed
                              ? ThemeColors.of(context).error
                              : ThemeColors.of(context).orangeMaterial;
                      
                      return ListTile(
                        leading: Icon(
                          isCompleted ? Icons.check_circle : Icons.error,
                          color: statusColor,
                        ),
                        title: Text(item.fileName),
                        subtitle: Text('${item.totalRecords} registros'),
                        trailing: Text(
                          '${item.dateTime.day}/${item.dateTime.month}',
                          style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textSecondary),
                        ),
                      );
                    },
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text('Erro ao carregar histórico: $e', style: TextStyle(color: ThemeColors.of(context).error)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String label, IconData icon, Color backgroundColor, Color borderColor, VoidCallback onTap) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        isMobile ? 10 : 12,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(
            isMobile ?  10 : 12,
          ),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.paddingXsAlt.get(isMobile, isTablet)),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).surfaceOverlay20,
                borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
              ),
              child: Icon(
                icon,
                color: ThemeColors.of(context).surface,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
            ),
            SizedBox(
              height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
            ),
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
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).surface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedCard(Map<String, dynamic> opcao, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 400 + (index * 70)),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: 0.85 + (0.15 * value),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            // ignore: deprecated_member_use
            ..translate(0.0, _hoveredIndex == index ? -8.0 : 0.0),
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
                color: (opcao['gradiente'][0] as Color).withValues(alpha: 
                  _hoveredIndex == index ? 0.35 : 0.3,
                ),
                blurRadius: _hoveredIndex == index
                    ? (isMobile ? 18 : 22)
                    : (isMobile ? 12 : 16),
                offset: Offset(0, _hoveredIndex == index ? 8 : 6),
              ),
            ],
          ),
          child: Material(
            color: ThemeColors.of(context).transparent,
            child: InkWell(
              onTap: () => _navegarPara(opcao['titulo']),
              borderRadius: BorderRadius.circular(
                isMobile ? 20 : (isTablet ? 22 : 24),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                  AppSizes.paddingSm.get(isMobile, isTablet),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                          AppSizes.paddingSmAlt.get(isMobile, isTablet),
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).surfaceOverlay20,
                          borderRadius: BorderRadius.circular(
                            isMobile ? 10 : 12,
                          ),
                        ),
                        child: Icon(
                          opcao['icone'],
                          color: ThemeColors.of(context).surface,
                          size: AppSizes.iconLarge.get(isMobile, isTablet),
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.paddingBase.get(isMobile, isTablet),
                      ),
                      Text(
                        opcao['titulo'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 12,
                            tabletFontSize: 13,
                          ),
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).surface,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsivePadding(
                          context,
                          mobile: 3,
                          tablet: 4,
                          desktop: 4,
                        ),
                      ),
                      Text(
                        opcao['subtitulo'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 10,
                            mobileFontSize: 9,
                            tabletFontSize: 9,
                          ),
                          color: ThemeColors.of(context).surfaceOverlay90,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedTipsCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXl.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ?  16 : (isTablet ? 18 : 20),
        ),
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
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).orangeAmber, ThemeColors.of(context).orangeMaterial],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 12 : 14,
                  ),
                ),
                child: Icon(
                  Icons.lightbulb_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Dicas de Importação/Exportação',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 18,
                      mobileFontSize: 15,
                      tabletFontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: ThemeColors.of(context).textSecondary,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
                onPressed: () => _mostrarSnackbar('Ver todas as dicas'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),
          _buildTipItem(
            '??',
            'Templates Disponveis',
            'Baixe modelos prontos para facilitar a importação',
            ThemeColors.of(context).primary,
            '12 templates',
          ),
          SizedBox(
            height: AppSizes.paddingSm.get(isMobile, isTablet),
          ),
          _buildTipItem(
            '?',
            'Processamento Rápido',
            'Processe at 10. 000 registros por vez',
            ThemeColors.of(context).blueCyan,
            'Alta performance',
          ),
          SizedBox(
            height: AppSizes.paddingSm.get(isMobile, isTablet),
          ),
          _buildTipItem(
            '??',
            'Backup Automtico',
            'Todos os dados so salvos antes de qualquer operação',
            ThemeColors.of(context).success,
            'Segurança total',
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(
      String emoji, String titulo, String desc, Color color, String badge) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingSm.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(
          isMobile ? 10 : 12,
        ),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveHelper.getResponsiveWidth(
              context,
              mobile: 42,
              tablet: 45,
              desktop: 48,
            ),
            height: ResponsiveHelper.getResponsiveHeight(
              context,
              mobile: 42,
              tablet: 45,
              desktop: 48,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                isMobile ?  10 : 12,
              ),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 24,
                    mobileFontSize: 20,
                    tabletFontSize: 22,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 12,
              tablet: 14,
              desktop: 16,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        titulo,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 15,
                            mobileFontSize: 13,
                            tabletFontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
                        vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          isMobile ? 5 : 6,
                        ),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 10,
                            mobileFontSize: 8,
                            tabletFontSize: 9,
                          ),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSizes.paddingXxs.get(isMobile, isTablet),
                ),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 11,
                      tabletFontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
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

  Widget _buildRecentActivity() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Busca histórico de importação do provider
    final historyAsync = ref.watch(importHistoryProvider);
    
    // Gera atividades recentes baseadas no histórico
    final activities = historyAsync.maybeWhen(
      data: (history) {
        if (history.isEmpty) {
          return <Map<String, dynamic>>[
            {
              'title': 'Nenhuma atividade',
              'time': 'Faa sua primeira operação',
              'icon': Icons.history_rounded,
              'color': ThemeColors.of(context).textSecondary,
            }
          ];
        }
        
        // Retorna as 3 atividades mais recentes
        return history.take(3).map((h) {
          IconData icon;
          Color color;
          
          // Determina tipo baseado no status
          switch (h.status) {
            case ImportStatus.completed:
              icon = Icons.check_circle_rounded;
              color = ThemeColors.of(context).success;
              break;
            case ImportStatus.failed:
              icon = Icons.error_rounded;
              color = ThemeColors.of(context).error;
              break;
            case ImportStatus.processing:
              icon = Icons.sync_rounded;
              color = ThemeColors.of(context).primary;
              break;
            default:
              icon = Icons.upload_rounded;
              color = ThemeColors.of(context).orangeMaterial;
          }
          
          return {
            'title': 'Importação: ${h.fileName}',
            'time': _formatarTempoRelativo(h.dateTime),
            'icon': icon,
            'color': color,
          };
        }).toList();
      },
      orElse: () => <Map<String, dynamic>>[
        {
          'title': 'Carregando...',
          'time': '',
          'icon': Icons.hourglass_empty_rounded,
          'color': ThemeColors.of(context).textSecondary,
        }
      ],
    );

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
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
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).successPastel,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 8 : 10,
                  ),
                ),
                child: Icon(
                  Icons.access_time_rounded,
                  color: ThemeColors.of(context).success.withValues(alpha: 0.7),
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Atividade Recente',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 14,
                    tabletFontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          ...activities.map((activity) => _buildActivityItem(
            activity['title'] as String,
            activity['time'] as String,
            activity['icon'] as IconData,
            activity['color'] as Color,
          )),
        ],
      ),
    );
  }
  
  // ignore: unused_element
  // ignore: unused_element
  /// Formata o tipo de operação para exibio
  String _formatOperationType(String operation) {
    switch (operation) {
      case 'import':
        return 'Importação';
      case 'export':
        return 'Exportação';
      case 'bulk':
        return 'Operação em lote';
      default:
        return operation;
    }
  }
  
  /// Formata data/hora em tempo relativo (ex: "H 5 min", "H 2 horas")
  String _formatarTempoRelativo(DateTime? dataHora) {
    if (dataHora == null) return 'Recente';
    
    final agora = DateTime.now();
    final diferenca = agora.difference(dataHora);
    
    if (diferenca.inMinutes < 1) return 'Agora';
    if (diferenca.inMinutes < 60) return 'H ${diferenca.inMinutes} min';
    if (diferenca.inHours < 24) {
      return diferenca.inHours == 1 ? 'H 1 hora' : 'H ${diferenca.inHours} horas';
    }
    if (diferenca.inDays < 7) {
      return diferenca.inDays == 1 ? 'Ontem' : 'H ${diferenca.inDays} dias';
    }
    if (diferenca.inDays < 30) {
      final semanas = (diferenca.inDays / 7).floor();
      return semanas == 1 ? 'H 1 semana' : 'H $semanas semanas';
    }
    return 'H mais de 1 ms';
  }

  Widget _buildActivityItem(
      String title, String time, IconData icon, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingXs.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                isMobile ? 6 : 8,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: AppSizes.iconTiny.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 10,
              tablet: 11,
              desktop: 12,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                      tabletFontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
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
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
            color: ThemeColors.of(context).textSecondary,
          ),
        ],
      ),
    );
  }

  void _navegarPara(String titulo) {
    ScaffoldMessenger.of(context).clearSnackBars();

    Widget?  destino;

    switch (titulo) {
      case 'Importar Produtos':
        destino = const ImportacaoProdutosScreen();
        break;
      case 'Importar Tags':
        destino = const ImportacaoTagsScreen();
        break;
      case 'Exportar Produtos':
        destino = const ExportacaoProdutosScreen();
        break;
      case 'Exportar Tags':
        destino = const ExportacaoTagsScreen();
        break;
      case 'Operações em Lote':
        destino = const ImportacaoOperacoesLoteScreen();
        break;
      case 'Histórico':
        _showHistory();
        return;
    }

    if (destino != null) {
      _navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => destino! ),
      );
    }
  }

  void _mostrarSnackbar(String mensagem) {
    final isMobile = ResponsiveHelper.isMobile(context);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensagem,
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
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 10 : 12,
          ),
        ),
      ),
    );
  }
}








