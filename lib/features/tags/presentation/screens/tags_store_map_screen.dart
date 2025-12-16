import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/categories/presentation/providers/categories_provider.dart';

class TagsMapaLojaScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  
  const TagsMapaLojaScreen({super.key, this.onBack});

  @override
  ConsumerState<TagsMapaLojaScreen> createState() => _TagsMapaLojaScreenState();
}

class _TagsMapaLojaScreenState extends ConsumerState<TagsMapaLojaScreen> with ResponsiveCache {
  String _filtroStatus = 'todas';
  int _setorSelecionado = -1;
  
  // Setores so derivados das categorias do backend
  List<Map<String, dynamic>> get _setores {
    final categoriesState = ref.watch(categoriesProvider);
    
    if (categoriesState.categories.isEmpty) {
      // Se no h categorias, mostrar lista vazia
      return [];
    }
    
    // Mapeamento de cones baseado no cone da categoria
    final iconMap = {
      'local_drink': Icons.local_drink_rounded,
      'shopping_basket': Icons.shopping_basket_rounded,
      'restaurant': Icons.restaurant_rounded,
      'cleaning_services': Icons.cleaning_services_rounded,
      'wash': Icons.wash_rounded,
      'bakery_dining': Icons.bakery_dining_rounded,
      'ac_unit': Icons.ac_unit_rounded,
      'set_meal': Icons.set_meal_rounded,
      'eco': Icons.eco_rounded,
      'kitchen': Icons.kitchen_rounded,
      'fastfood': Icons.fastfood_rounded,
      'pets': Icons.pets_rounded,
    };
    
    return categoriesState.categories.asMap().entries.map((entry) {
      final cat = entry.value;
      return {
        'nome': cat.nome,
        'total': cat.quantidadeProdutos,
        'ativas': (cat.quantidadeProdutos * 0.95).round(), // Estimativa: 95% ativas
        'problemas': (cat.quantidadeProdutos * 0.05).round(), // Estimativa: 5% com problemas
        'cor': cat.cor,
        'icone': iconMap[cat.icone] ?? Icons.category_rounded,
        'produtos': cat.descricao ?? cat.nome,
      };
    }).toList();
  }
  
  @override
  void initState() {
    super.initState();
    // Carregar categorias do backend
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoriesProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surfaceSecondary,
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                Padding(
                  padding: EdgeInsets.all(
                    AppSizes.paddingMdAlt.get(isMobile, isTablet),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildResumoCard(),
                      SizedBox(
                        height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                      ),
                      _buildFiltroChips(),
                      SizedBox(
                        height: AppSizes.paddingLgAlt.get(isMobile, isTablet),
                      ),
                      Text(
                        'Layout da Loja',
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
                        height: AppSizes.paddingBase.get(isMobile, isTablet),
                      ),
                      _buildMapaVisual(),
                      SizedBox(
                        height: AppSizes.paddingLgAlt.get(isMobile, isTablet),
                      ),
                      Text(
                        'Detalhes por Setor',
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
                        height: AppSizes.paddingBase.get(isMobile, isTablet),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _setores.length,
                        itemBuilder: (context, index) => _buildSetorCard(_setores[index], index),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _escanearArea,
        backgroundColor: ThemeColors.of(context).blueCyan,
        icon: Icon(
          Icons.qr_code_scanner_rounded,
          size: AppSizes.iconMediumAlt2.get(isMobile, isTablet),
        ),
        label: Text(
          'Escanear rea',
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
            blurRadius: isMobile ? 20 : 25,
            offset: Offset(0, isMobile ? 5 : 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Boto de voltar
          if (widget.onBack != null) ...[            Container(
              decoration: BoxDecoration(
                color: ThemeColors.of(context).primary,
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
                onPressed: widget.onBack,
              ),
            ),
            SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          ],
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).yellowGold, ThemeColors.of(context).warning],
              ),
              borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).yellowGoldLight,
                  blurRadius: isMobile ? 10 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.map_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconLarge.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mapa da Loja',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 20,
                      mobileFontSize: 18,
                      tabletFontSize: 19,
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
                  'Distribuio de Etiquetas',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
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
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
              vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).infoPastel,
              borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
              border: Border.all(color: ThemeColors.of(context).infoLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.layers_rounded,
                  size: AppSizes.iconTiny.get(isMobile, isTablet),
                  color: ThemeColors.of(context).infoDark,
                ),
                SizedBox(
                  width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                Text(
                  '6 setores',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                      tabletFontSize: 12,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).infoDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final totalTags = _setores.fold(0, (sum, s) => sum + (s['total'] as int));
    final tagsAtivas = _setores.fold(0, (sum, s) => sum + (s['ativas'] as int));
    final tagsProblemas = _setores.fold(0, (sum, s) => sum + (s['problemas'] as int));
    final percentualAtivo = ((tagsAtivas / totalTags) * 100).toStringAsFixed(1);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXl.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryHeader(context),
        borderRadius: BorderRadius.circular(
          isMobile ? 20 : (isTablet ? 22 : 24),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.4),
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
                  AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.analytics_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconLarge.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Viso Geral',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 20,
                      mobileFontSize: 18,
                      tabletFontSize: 19,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.8,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _buildResumoItem('$totalTags', 'Total', Icons.sell_rounded),
              ),
              Container(
                width: 1,
                height: ResponsiveHelper.getResponsiveHeight(
                  context,
                  mobile: 46,
                  tablet: 48,
                  desktop: 50,
                ),
                color: ThemeColors.of(context).surfaceOverlay30,
              ),
              Expanded(
                child: _buildResumoItem('$tagsAtivas', 'Ativas', Icons.check_circle_rounded),
              ),
              Container(
                width: 1,
                height: ResponsiveHelper.getResponsiveHeight(
                  context,
                  mobile: 46,
                  tablet: 48,
                  desktop: 50,
                ),
                color: ThemeColors.of(context).surfaceOverlay30,
              ),
              Expanded(
                child: _buildResumoItem('$tagsProblemas', 'Problemas', Icons.warning_rounded),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingLgAlt3.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingSm.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay15,
              borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
              border: Border.all(color: ThemeColors.of(context).surfaceOverlay30, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.speed_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
                SizedBox(
                  width: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                Text(
                  'Taxa de Funcionamento: $percentualAtivo%',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 15,
                      mobileFontSize: 14,
                      tabletFontSize: 14,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoItem(String valor, String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: ThemeColors.of(context).surface,
          size: AppSizes.iconMediumLargeFloat.get(isMobile, isTablet),
        ),
        SizedBox(
          height: AppSizes.paddingXs.get(isMobile, isTablet),
        ),
        Text(
          valor,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 24,
              mobileFontSize: 20,
              tabletFontSize: 22,
            ),
          overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            color: ThemeColors.of(context).surface,
            letterSpacing: -0.8,
          ),
        ),
        SizedBox(
          height: AppSizes.paddingXxs.get(isMobile, isTablet),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 12,
              mobileFontSize: 11,
              tabletFontSize: 11,
            ),
          overflow: TextOverflow.ellipsis,
            color: ThemeColors.of(context).surfaceOverlay90,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFiltroChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFiltroChip('todas', 'Todas', Icons.grid_view_rounded),
          SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
          _buildFiltroChip('ativas', 'Ativas', Icons.check_circle_rounded),
          SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
          _buildFiltroChip('problemas', 'Problemas', Icons.warning_rounded),
          SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
          _buildFiltroChip('bateria', 'Bateria Baixa', Icons.battery_alert_rounded),
        ],
      ),
    );
  }

  Widget _buildFiltroChip(String value, String label, IconData icon) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isSelected = _filtroStatus == value;
    
    return InkWell(
      onTap: () => setState(() => _filtroStatus = value),
      borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark])
              : null,
          color: isSelected ? null : ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
          border: Border.all(
            color: isSelected ? ThemeColors.of(context).transparent : ThemeColors.of(context).textSecondary,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ThemeColors.of(context).blueCyanLight,
                    blurRadius: isMobile ? 10 : 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
              color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
            ),
            SizedBox(width: AppSizes.paddingXs.get(isMobile, isTablet)),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12),
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

  Widget _buildMapaVisual() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      height: ResponsiveHelper.getResponsiveHeight(
        context,
        mobile: 280,
        tablet: 300,
        desktop: 320,
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingLgAlt.get(isMobile, isTablet),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).warningPastel,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.view_in_ar_rounded,
                  color: ThemeColors.of(context).warningDark,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Visualizao 3D do Layout',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 17,
                      mobileFontSize: 16,
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
                  Icons.fullscreen_rounded,
                  color: ThemeColors.of(context).textSecondary,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
                onPressed: () => _mostrarTelaCheia(),
                tooltip: 'Tela cheia',
                padding: EdgeInsets.all(
                  AppSizes.paddingXs.get(isMobile, isTablet),
                ),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          ),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: ResponsiveHelper.isMobile(context) ? 1.5 : 1.1,
                crossAxisSpacing: AppSizes.paddingBase.get(isMobile, isTablet),
                mainAxisSpacing: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                final setor = _setores[index];
                final percentualAtivo = (setor['ativas'] / setor['total'] * 100).round();
                final isSelected = _setorSelecionado == index;
                
                return TweenAnimationBuilder(
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: InkWell(
                    onTap: () => setState(() => _setorSelecionado = isSelected ? -1 : index),
                    borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            setor['cor'].withValues(alpha: isSelected ? 1.0 : 0.7),
                            setor['cor'],
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
                        border: Border.all(
                          color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (setor['cor'] as Color).withValues(alpha: isSelected ?  0.5 : 0.3),
                            blurRadius: isSelected ? (isMobile ? 12 : 15) : (isMobile ? 8 : 10),
                            offset: Offset(0, isSelected ? (isMobile ? 5 : 6) : (isMobile ? 3 : 4)),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                          AppSizes.paddingBase.get(isMobile, isTablet),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              setor['icone'],
                              color: ThemeColors.of(context).surface,
                              size: AppSizes.iconLarge.get(isMobile, isTablet),
                            ),
                            SizedBox(
                              height: AppSizes.paddingXs.get(isMobile, isTablet),
                            ),
                            Text(
                              setor['nome'],
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 12,
                                  mobileFontSize: 11,
                                  tabletFontSize: 11,
                                ),
                                fontWeight: FontWeight.bold,
                                color: ThemeColors.of(context).surface,
                                letterSpacing: -0.3,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                            ),
                            Text(
                              '${setor['ativas']}/${setor['total']}',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 15,
                                  mobileFontSize: 14,
                                  tabletFontSize: 14,
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
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
                                vertical: AppSizes.paddingMicro.get(isMobile, isTablet),
                              ),
                              decoration: BoxDecoration(
                                color: ThemeColors.of(context).surfaceOverlay25,
                                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                              ),
                              child: Text(
                                '$percentualAtivo%',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10),
                                overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeColors.of(context).surfaceOverlay95,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetorCard(Map<String, dynamic> setor, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final percentual = (setor['ativas'] / setor['total']).clamp(0.0, 1.0);
    
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
          bottom: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        padding: EdgeInsets.all(
          AppSizes.paddingLgAlt3.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(isMobile ? 16 : (isTablet ? 18 : 20)),
          border: Border.all(color: (setor['cor'] as Color)Light, width: 2),
          boxShadow: [
            BoxShadow(
              color: (setor['cor'] as Color)Light,
              blurRadius: isMobile ? 12 : 15,
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
                  padding: EdgeInsets.all(
                    AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [setor['cor'], (setor['cor'] as Color).withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
                  ),
                  child: Icon(
                    setor['icone'],
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMedium.get(isMobile, isTablet),
                  ),
                ),
                SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        setor['nome'],
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 17, mobileFontSize: 16, tabletFontSize: 16),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingMicro.get(isMobile, isTablet)),
                      Text(
                        setor['produtos'],
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (setor['problemas'] > 0)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                      vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).errorPastel,
                      borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                      border: Border.all(color: ThemeColors.of(context).error),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_rounded, size: AppSizes.iconTiny.get(isMobile, isTablet), color: ThemeColors.of(context).errorDark),
                        SizedBox(width: AppSizes.paddingXsAlt5.get(isMobile, isTablet)),
                        Text('${setor['problemas']}', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12), fontWeight: FontWeight.bold, color: ThemeColors.of(context).errorDark)),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Status das Tags', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12), color: ThemeColors.of(context).textSecondary, fontWeight: FontWeight.w600)),
                          Text('${setor['ativas']} / ${setor['total']}', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13), fontWeight: FontWeight.bold, color: setor['cor'])),
                        ],
                      ),
                      SizedBox(height: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                        child: LinearProgressIndicator(
                          value: percentual,
                          minHeight: ResponsiveHelper.getResponsiveHeight(context, mobile: 9, tablet: 10, desktop: 10),
                          backgroundColor: ThemeColors.of(context).textSecondary,
                          valueColor: AlwaysStoppedAnimation<Color>(setor['cor']),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingSm.get(isMobile, isTablet)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _verDetalhesSetor(setor),
                    icon: Icon(Icons.info_outline_rounded, size: AppSizes.iconTiny.get(isMobile, isTablet), color: setor['cor']),
                    label: Text('Ver Detalhes', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11), color: setor['cor'])),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: (setor['cor'] as Color)Light),
                      padding: EdgeInsets.symmetric(vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _escanearArea() {
    final isMobile = ResponsiveHelper.isMobile(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet))),
        title: Row(children: [Icon(Icons.qr_code_scanner_rounded, color: ThemeColors.of(context).blueCyan, size: AppSizes.iconMediumLargeAlt.get(isMobile, isTablet)), SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)), Text('Escanear rea', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17)))]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Use o scanner QR para identificar rapidamente um setor da loja.', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
            SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
            Icon(Icons.qr_code_2_rounded, size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 100, tablet: 110, desktop: 120), color: ThemeColors.of(context).blueCyan),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13)))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMediumSmall.get(isMobile, isTablet)), SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)), Expanded(child: Text('Scanner ativado! ', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))))]), backgroundColor: ThemeColors.of(context).success.withValues(alpha: 0.7), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)))));
            },
            style: ElevatedButton.styleFrom(backgroundColor: ThemeColors.of(context).blueCyan, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)))),
            child: Text('Iniciar Scanner', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
          ),
        ],
      ),
    );
  }

  void _verDetalhesSetor(Map<String, dynamic> setor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeColors.of(context).transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.sizeOf(context).height * 0.7,
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: AppSizes.paddingBase.get(isMobile, isTablet)),
              width: ResponsiveHelper.getResponsiveWidth(context, mobile: 36, tablet: 38, desktop: 40),
              height: ResponsiveHelper.getResponsiveHeight(context, mobile: 3, tablet: 4, desktop: 4),
              decoration: BoxDecoration(color: ThemeColors.of(context).textSecondary, borderRadius: AppRadius.xxxs),
            ),
            Padding(
              padding: EdgeInsets.all(AppSizes.paddingXl.get(isMobile, isTablet)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [setor['cor'], (setor['cor'] as Color).withValues(alpha: 0.7)]), borderRadius: BorderRadius.circular(ResponsiveHelper.isMobile(context) ? 14 : 16)),
                    child: Icon(setor['icone'], color: ThemeColors.of(context).surface, size: AppSizes.iconLarge.get(isMobile, isTablet)),
                  ),
                  SizedBox(width: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(setor['nome'], style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 22, mobileFontSize: 20, tabletFontSize: 21), fontWeight: FontWeight.bold, letterSpacing: -0.8)),
                        Text(setor['produtos'], style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13), color: ThemeColors.of(context).textSecondaryOverlay70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingXl.get(isMobile, isTablet)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Total de Tags', '${setor['total']}', Icons.sell_rounded),
                    _buildInfoRow('Tags Ativas', '${setor['ativas']}', Icons.check_circle_rounded),
                    _buildInfoRow('Com Problemas', '${setor['problemas']}', Icons.warning_rounded),
                    _buildInfoRow('Categoria', setor['produtos'], Icons.category_rounded),
                    SizedBox(height: AppSizes.paddingLgAlt.get(isMobile, isTablet)),
                    Text('Aes Rpidas', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15, tabletFontSize: 15), fontWeight: FontWeight.bold)),
                    SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                    _buildActionButton('Atualizar Todas', Icons.refresh_rounded, ThemeColors.of(context).info),
                    SizedBox(height: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                    _buildActionButton('Verificar Problemas', Icons.troubleshoot_rounded, ThemeColors.of(context).warning),
                    SizedBox(height: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                    _buildActionButton('Exportar Relatório', Icons.file_download_rounded, ThemeColors.of(context).success),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSizes.iconMediumSmall.get(isMobile, isTablet), color: ThemeColors.of(context).textSecondary),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          Expanded(child: Text(label, style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13), color: ThemeColors.of(context).textSecondary))),
          Text(value, style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _executarAcao(label),
        icon: Icon(icon, size: AppSizes.iconSmall.get(isMobile, isTablet)),
        label: Text(label, style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: ThemeColors.of(context).surface,
          padding: EdgeInsets.symmetric(vertical: AppSizes.paddingSm.get(isMobile, isTablet)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
        ),
      ),
    );
  }

  /// Mostra visualizao em tela cheia
  void _mostrarTelaCheia() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.construction_rounded, color: ThemeColors.of(context).surface, size: 20),
            SizedBox(width: 12),
            Text('Visualizao 3D estar disponvel em breve!'),
          ],
        ),
        backgroundColor: ThemeColors.of(context).blueCyan,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Executa ao do boto baseado no label
  void _executarAcao(String label) {
    if (label.contains('Sincronizar')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(ThemeColors.of(context).surface)),
              ),
              SizedBox(width: 12),
              Text('Sincronizando tags...'),
            ],
          ),
          backgroundColor: ThemeColors.of(context).primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (label.contains('Exportar')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.file_download_rounded, color: ThemeColors.of(context).surface, size: 20),
              SizedBox(width: 12),
              Text('Exportando relatório...'),
            ],
          ),
          backgroundColor: ThemeColors.of(context).success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 20),
              const SizedBox(width: 12),
              Text('$label em desenvolvimento'),
            ],
          ),
          backgroundColor: ThemeColors.of(context).blueCyan,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
}












