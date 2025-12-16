import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/features/categories/presentation/screens/categories_list_screen.dart';
import 'package:tagbean/features/categories/presentation/screens/category_add_screen.dart';
import 'package:tagbean/features/categories/presentation/screens/categories_admin_screen.dart';
import 'package:tagbean/features/categories/presentation/screens/category_products_screen.dart';
import 'package:tagbean/features/categories/presentation/screens/categories_stats_screen.dart';
import 'package:tagbean/features/categories/presentation/providers/categories_provider.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
class CategoriasMenuScreen extends ConsumerStatefulWidget {
  const CategoriasMenuScreen({super.key});

  @override
  ConsumerState<CategoriasMenuScreen> createState() => _CategoriasMenuScreenState();
}

class _CategoriasMenuScreenState extends ConsumerState<CategoriasMenuScreen> with ResponsiveCache {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Inicializa o provider de categorias
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoriesProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Responsividade disponível via ResponsiveHelper se necessário
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
            _buildHeader(context),
            SizedBox(
              height: AppSizes.paddingMd.get(isMobile, isTablet),
            ),
            _buildInfoCard(context),
            SizedBox(
              height: AppSizes.paddingMd.get(isMobile, isTablet),
            ),
            _buildStatsCards(context),
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
                    'Gerenciamento de Categorias',
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
                    'Organize e controle suas categorias de produtos',
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
                  _buildMenuGrid(context),
                ],
              ),
            ),
            SizedBox(
              height: AppSizes.paddingXl.get(isMobile, isTablet),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
        gradient: AppGradients.darkBackground,
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
              Icons.category_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.spacingSm.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Categorias',
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
                  'Hub central de gerenciamento',
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
              color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getResponsiveBorderRadius(
                  context,
                  mobile: 8,
                  tablet: 9,
                  desktop: 10,
                ),
              ),
              border: Border.all(color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.folder_rounded,
                  color: ThemeColors.of(context).blueCyan,
                  size: AppSizes.iconTiny.get(isMobile, isTablet),
                ),
                SizedBox(
                  width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                Text(
                  '6',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10.5,
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

  Widget _buildInfoCard(BuildContext context) {
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
          colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).primaryPastel],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 14,
        ),
        border: Border.all(
          color: ThemeColors.of(context).infoLight,
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
                isMobile ? 8 : 10,
              ),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: ThemeColors.of(context).infoDark,
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
                  'Sobre este Módulo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                      tabletFontSize: 12.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).infoDark,
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
                  'Organize produtos em categorias para facilitar a gestão e navegação do seu catálogo.',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10,
                      tabletFontSize: 10.5,
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

  Widget _buildStatsCards(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    final estatisticas = [
      {'label': 'Bebidas', 'valor': '247', 'icon': Icons.local_drink_rounded, 'cor': ThemeColors.of(context).blueMaterial, 'mudanca': '+5', 'tipo': 'aumento'},
      {'label': 'Mercearia', 'valor': '532', 'icon': Icons.shopping_basket_rounded, 'cor': ThemeColors.of(context).brownMain, 'mudanca': '+18', 'tipo': 'aumento'},
      {'label': 'Perecíveis', 'valor': '189', 'icon': Icons.dining_rounded, 'cor': ThemeColors.of(context).greenMaterial, 'mudanca': '+7', 'tipo': 'aumento'},
      {'label': 'Limpeza', 'valor': '156', 'icon': Icons.clean_hands_rounded, 'cor': ThemeColors.of(context).blueCyan, 'mudanca': '+3', 'tipo': 'aumento'},
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
                        Expanded(child: _buildEnhancedStatCard(context, estatisticas[0])),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                        Expanded(child: _buildEnhancedStatCard(context, estatisticas[1])),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                    Row(
                      children: [
                        Expanded(child: _buildEnhancedStatCard(context, estatisticas[2])),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                        Expanded(child: _buildEnhancedStatCard(context, estatisticas[3])),
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
                        child: _buildEnhancedStatCard(context, stat),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatCard(BuildContext context, Map<String, dynamic> stat) {
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
            width: AppSizes.borderWidthResponsive.get(isMobile, isTablet),
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

  Widget _buildMenuGrid(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return GridView.builder(
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
      itemCount: 6,
      itemBuilder: (context, index) {
        final opcoes = [
          {
            'titulo': 'Visualizar Categorias',
            'subtitulo': 'Lista completa com detalhes',
            'icone': Icons.list_alt_rounded,
            'gradiente': [ThemeColors.of(context).categoryVisualizar, ThemeColors.of(context).categoryVisualizarDark],
            'destino': const CategoriasListaScreen(),
          },
          {
            'titulo': 'Nova Categoria',
            'subtitulo': 'Adicionar ao sistema',
            'icone': Icons.add_circle_rounded,
            'gradiente': [ThemeColors.of(context).categoryNova, ThemeColors.of(context).categoryNovaDark],
            'destino': const CategoriasAdicionarScreen(),
          },
          {
            'titulo': 'Gerenciar Produtos',
            'subtitulo': 'Vincular e organizar',
            'icone': Icons.inventory_2_rounded,
            'gradiente': [ThemeColors.of(context).categoryProdutos, ThemeColors.of(context).categoryProdutosDark],
            'destino': const CategoriasProdutosScreen(),
          },
          {
            'titulo': 'Administração Completa',
            'subtitulo': 'Controle total e avançado',
            'icone': Icons.settings_rounded,
            'gradiente': [ThemeColors.of(context).categoryAdmin, ThemeColors.of(context).categoryAdminDark],
            'destino': const CategoriasAdminScreen(),
            'badge': 'PRO',
          },
          {
            'titulo': 'Estatísticas',
            'subtitulo': 'Análises e relatórios',
            'icone': Icons.analytics_rounded,
            'gradiente': [ThemeColors.of(context).categoryStats, ThemeColors.of(context).categoryStatsDark],
            'destino': const CategoriasEstatisticasScreen(),
          },
          {
            'titulo': 'Importar/Exportar',
            'subtitulo': 'Gestão em lote',
            'icone': Icons.import_export_rounded,
            'gradiente': [ThemeColors.of(context).categoryImportExport, ThemeColors.of(context).categoryImportExportDark],
            'destino': null,
          },
        ];
        return _buildOptionCard(context, opcoes[index], index);
      },
    );
  }

  Widget _buildOptionCard(BuildContext context, Map<String, dynamic> opcao, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
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
            if (opcao['destino'] != null) {
              _navigatorKey.currentState?.push(
                MaterialPageRoute(builder: (context) => opcao['destino']),
              );
            } else {
              _showImportExportDialog();
            }
          },
          borderRadius: BorderRadius.circular(
            isMobile ? 20 : (isTablet ? 22 : 24),
          ),
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(
                        ResponsiveHelper.getResponsivePadding(
                          context,
                          mobile: 12,
                          tablet: 16,
                          desktop: 18,
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SizedBox(
                          width: constraints.maxWidth - 24,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                  AppSizes.paddingSmLg.get(isMobile, isTablet),
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
                                  size: ResponsiveHelper.getResponsiveIconSize(
                                    context,
                                    mobile: 28,
                                    tablet: 32,
                                    desktop: 36,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                opcao['titulo'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 15,
                                    mobileFontSize: 13,
                                    tabletFontSize: 14,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: ThemeColors.of(context).surface,
                                  letterSpacing: -0.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                opcao['subtitulo'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 12,
                                    mobileFontSize: 11,
                                    tabletFontSize: 11.5,
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
                  );
                },
              ),
              if (opcao['badge'] != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.extraSmallPadding.get(isMobile, isTablet), vertical: 4),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).surfaceOverlay30,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ThemeColors.of(context).surfaceOverlay50),
                    ),
                    child: Text(
                      opcao['badge'],
                      style: TextStyle(
                        color: ThemeColors.of(context).surface,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
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

  void _showImportExportDialog() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(const ResponsiveSize(mobile: 20, tablet: 22, desktop: 24).get(isMobile, isTablet))),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ThemeColors.of(context).yellowGold, ThemeColors.of(context).warning],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.import_export_rounded, color: ThemeColors.of(context).surface, size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Importar/Exportar',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).infoPastel,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.upload_rounded, color: ThemeColors.of(context).infoDark),
              ),
              title: const Text('Importar Categorias'),
              subtitle: const Text('Carregar de arquivo'),
              onTap: () {
                Navigator.pop(context);
                // Implementar importação
              },
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).successPastel,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.download_rounded, color: ThemeColors.of(context).successIcon),
              ),
              title: const Text('Exportar Categorias'),
              subtitle: const Text('Salvar em arquivo'),
              onTap: () {
                Navigator.pop(context);
                // Implementar exportação
              },
            ),
          ],
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
}

