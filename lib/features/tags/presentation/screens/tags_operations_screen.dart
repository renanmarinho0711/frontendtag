import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/features/categories/presentation/providers/categories_provider.dart';

class TagsOperacoesLoteScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  
  const TagsOperacoesLoteScreen({super.key, this.onBack});

  @override
  ConsumerState<TagsOperacoesLoteScreen> createState() => _TagsOperacoesLoteScreenState();
}

class _TagsOperacoesLoteScreenState extends ConsumerState<TagsOperacoesLoteScreen> with ResponsiveCache {
  String _operacaoSelecionada = 'atualizar';
  String _filtroSelecionado = 'todas';
  List<String> _categoriasSelecionadas = [];
  
  /// Obt?m a lista de categorias do backend via provider
  List<String> get _categorias {
    final categoriesState = ref.watch(categoriesProvider);
    return categoriesState.categories.map((c) => c.nome).toList();
  }
  
  @override
  void initState() {
    super.initState();
    // Inicializa o provider de categorias para carregar do backend
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(
                    AppSizes.paddingMdAlt.get(isMobile, isTablet),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOperacaoCard(),
                      SizedBox(
                        height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                      ),
                      _buildFiltroCard(),
                      if (_filtroSelecionado == 'categorias') ...[
                        SizedBox(
                          height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                        ),
                        _buildCategoriasCard(),
                      ],
                      SizedBox(
                        height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                      ),
                      _buildResumoCard(),
                      SizedBox(
                        height: ResponsiveHelper.getResponsivePadding(
                          context,
                          mobile: 70,
                          tablet: 75,
                          desktop: 80,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _executarOperacao,
        backgroundColor: ThemeColors.of(context).primaryDark,
        icon: Icon(
          Icons.play_arrow_rounded,
          size: AppSizes.iconMediumAlt2.get(isMobile, isTablet),
        ),
        label: Text(
          'Executar Opera??o',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
              tabletFontSize: 13,
            ),
          ),
          overflow: TextOverflow.ellipsis,
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
          // Bot?o de voltar
          if (widget.onBack != null) ...[            Container(
              decoration: BoxDecoration(
                color: ThemeColors.of(context).blueCyan,
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
                colors: [ThemeColors.of(context).mintPastel, ThemeColors.of(context).primaryPastel],
              ),
              borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).mintPastelLight,
                  blurRadius: isMobile ? 10 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.layers_rounded,
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
                  'Opera??es em Lote',
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
                  'Gerenciar M?ltiplas Tags',
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
              color: ThemeColors.of(context).primaryPastel,
              borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
              border: Border.all(color: ThemeColors.of(context).primaryLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sell_rounded,
                  size: AppSizes.iconTiny.get(isMobile, isTablet),
                  color: ThemeColors.of(context).primaryDark,
                ),
                SizedBox(
                  width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                Text(
                  '1.248',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                      tabletFontSize: 12,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperacaoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
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
                  color: ThemeColors.of(context).primaryPastel,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.settings_suggest_rounded,
                  color: ThemeColors.of(context).primaryDark,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Selecione a Opera??o',
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
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          ),
          _buildOperacaoOption(
            'atualizar',
            'Atualizar Dados',
            'Sincronizar pre?os e informa??es',
            Icons.refresh_rounded,
            ThemeColors.of(context).info,
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildOperacaoOption(
            'reconfigurar',
            'Reconfigurar',
            'Restaurar configura??es padr?o',
            Icons.settings_backup_restore_rounded,
            ThemeColors.of(context).warning,
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildOperacaoOption(
            'desativar',
            'Desativar',
            'Colocar tags em modo sleep',
            Icons.power_settings_new_rounded,
            ThemeColors.of(context).error,
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildOperacaoOption(
            'testar',
            'Testar Conex?o',
            'Verificar comunica??o WiFi',
            Icons.wifi_tethering_rounded,
            ThemeColors.of(context).success,
          ),
        ],
      ),
    );
  }

  Widget _buildOperacaoOption(
    String value,
    String titulo,
    String descricao,
    IconData icon,
    Color color,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isSelected = _operacaoSelecionada == value;
    
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 200),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double animValue, child) {
        return InkWell(
          onTap: () => setState(() => _operacaoSelecionada = value),
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(
              AppSizes.paddingMdAlt.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [colorLight, colorLight],
                    )
                  : null,
              color: isSelected ? null : ThemeColors.of(context).textSecondary,
              border: Border.all(
                color: isSelected ? color : ThemeColors.of(context).textSecondary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colorLight,
                        blurRadius: isMobile ? 10 : 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(
                    AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(colors: [color, color.withValues(alpha: 0.7)])
                        : null,
                    color: isSelected ? null : ThemeColors.of(context).textSecondary,
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
                    size: AppSizes.iconMediumLargeFloat.get(isMobile, isTablet),
                  ),
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
                        titulo,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 15,
                            mobileFontSize: 14,
                            tabletFontSize: 14,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? color : ThemeColors.of(context).textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.paddingMicro.get(isMobile, isTablet),
                      ),
                      Text(
                        descricao,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 12,
                            mobileFontSize: 11,
                            tabletFontSize: 11,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: EdgeInsets.all(
                      AppSizes.paddingXsAlt.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconTiny.get(isMobile, isTablet),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFiltroCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
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
                  color: ThemeColors.of(context).infoPastel,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.filter_list_rounded,
                  color: ThemeColors.of(context).infoDark,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Aplicar Opera??o Em',
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
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          ),
          _buildRadioOption(
            'todas',
            'Todas as Tags',
            'Aplicar em todas as 1.248 tags do sistema',
            Icons.select_all_rounded,
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildRadioOption(
            'categorias',
            'Por Categoria',
            'Selecionar categorias espec?ficas',
            Icons.category_rounded,
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildRadioOption(
            'problemas',
            'Tags com Problemas',
            'Apenas tags com erros identificados (28)',
            Icons.warning_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String value, String titulo, String descricao, IconData icon) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isSelected = _filtroSelecionado == value;
    
    return InkWell(
      onTap: () => setState(() => _filtroSelecionado = value),
      borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
      child: Container(
        padding: EdgeInsets.all(
          AppSizes.paddingSm.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: isSelected ? ThemeColors.of(context).infoPastel : ThemeColors.of(context).textSecondary,
          border: Border.all(
            color: isSelected ?  ThemeColors.of(context).info : ThemeColors.of(context).textSecondary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? ThemeColors.of(context).info.withValues(alpha: 0.7) : ThemeColors.of(context).textSecondaryOverlay70,
              size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
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
                    titulo,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                        tabletFontSize: 13,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? ThemeColors.of(context).infoDark : ThemeColors.of(context).textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.paddingMicro.get(isMobile, isTablet),
                  ),
                  Text(
                    descricao,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 12,
                        mobileFontSize: 11,
                        tabletFontSize: 11,
                      ),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: ResponsiveHelper.getResponsiveWidth(context, mobile: 18, tablet: 19, desktop: 20),
              height: ResponsiveHelper.getResponsiveHeight(context, mobile: 18, tablet: 19, desktop: 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? ThemeColors.of(context).infoDark : ThemeColors.of(context).textSecondary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: ResponsiveHelper.getResponsiveWidth(context, mobile: 9, tablet: 10, desktop: 10),
                        height: ResponsiveHelper.getResponsiveHeight(context, mobile: 9, tablet: 10, desktop: 10),
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).infoDark,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriasCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
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
                  Icons.apps_rounded,
                  color: ThemeColors.of(context).warningDark,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Selecione as Categorias (${_categoriasSelecionadas.length})',
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
              if (_categoriasSelecionadas.isNotEmpty)
                TextButton(
                  onPressed: () => setState(() => _categoriasSelecionadas.clear()),
                  child: Text(
                    'Limpar',
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
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          ),
          Wrap(
            spacing: AppSizes.paddingSmAlt.get(isMobile, isTablet),
            runSpacing: AppSizes.paddingSmAlt.get(isMobile, isTablet),
            children: _categorias.map((categoria) {
              final isSelected = _categoriasSelecionadas.contains(categoria);
              return InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _categoriasSelecionadas.remove(categoria);
                    } else {
                      _categoriasSelecionadas.add(categoria);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                    vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [ThemeColors.of(context).mintPastel, ThemeColors.of(context).primaryPastel],
                          )
                        : null,
                    color: isSelected ? null : ThemeColors.of(context).textSecondary,
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                    border: Border.all(
                      color: isSelected ? ThemeColors.of(context).mintPastel : ThemeColors.of(context).textSecondary,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                        size: AppSizes.iconSmall.get(isMobile, isTablet),
                        color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
                      ),
                      SizedBox(width: AppSizes.paddingXs.get(isMobile, isTablet)),
                      Text(
                        categoria,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    int tagsAfetadas = 0;
    if (_filtroSelecionado == 'todas') {
      tagsAfetadas = 1248;
    } else if (_filtroSelecionado == 'problemas') {
      tagsAfetadas = 28;
    } else {
      tagsAfetadas = _categoriasSelecionadas.length * 150;
    }

    final tempoEstimado = (tagsAfetadas / 10).ceil();

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXl.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).blueLight],
        ),
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
                  'Resumo da Opera??o',
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
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingLgAlt3.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay15,
              borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
              border: Border.all(color: ThemeColors.of(context).surfaceOverlay30, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildResumoItem('Opera??o', _getOperacaoTexto(), Icons.settings_rounded),
                SizedBox(height: AppSizes.paddingSm.get(isMobile, isTablet)),
                Container(height: 1, color: ThemeColors.of(context).surfaceOverlay30),
                SizedBox(height: AppSizes.paddingSm.get(isMobile, isTablet)),
                _buildResumoItem('Tags Afetadas', '$tagsAfetadas unidades', Icons.sell_rounded),
                SizedBox(height: AppSizes.paddingSm.get(isMobile, isTablet)),
                Container(height: 1, color: ThemeColors.of(context).surfaceOverlay30),
                SizedBox(height: AppSizes.paddingSm.get(isMobile, isTablet)),
                _buildResumoItem('Tempo Estimado', '$tempoEstimado minutos', Icons.access_time_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoItem(String label, String valor, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: ThemeColors.of(context).surfaceOverlay90,
          size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
        ),
        SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13),
          overflow: TextOverflow.ellipsis,
            color: ThemeColors.of(context).surfaceOverlay90,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          valor,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14),
          overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            color: ThemeColors.of(context).surface,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  String _getOperacaoTexto() {
    switch (_operacaoSelecionada) {
      case 'atualizar':
        return 'Atualizar Dados';
      case 'reconfigurar':
        return 'Reconfigurar';
      case 'desativar':
        return 'Desativar';
      case 'testar':
        return 'Testar Conex?o';
      default:
        return '';
    }
  }

  void _executarOperacao() {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    if (_filtroSelecionado == 'categorias' && _categoriasSelecionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMediumSmall.get(isMobile, isTablet)),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Text('Selecione ao menos uma categoria', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
            ],
          ),
          backgroundColor: ThemeColors.of(context).warningDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet))),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow_rounded, color: ThemeColors.of(context).primaryDark, size: AppSizes.iconMediumLargeAlt.get(isMobile, isTablet)),
            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
            Text('Confirmar Opera??o', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deseja executar "${_getOperacaoTexto()}" em massa?', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
            SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
            Container(
              padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
              decoration: BoxDecoration(color: ThemeColors.of(context).primaryPastel, borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Esta opera??o ? irrevers?vel! ', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11), fontWeight: FontWeight.bold, color: ThemeColors.of(context).primaryDark)),
                  SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                  Text('Certifique-se de ter selecionado as op??es corretas. ', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13)))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [SizedBox(width: ResponsiveHelper.getResponsiveWidth(context, mobile: 18, tablet: 19, desktop: 20), height: ResponsiveHelper.getResponsiveHeight(context, mobile: 18, tablet: 19, desktop: 20), child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface))), SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)), Expanded(child: Text('Opera??o em andamento... ', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))))]), backgroundColor: ThemeColors.of(context).primaryDark, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))), duration: const Duration(seconds: 3)));
            },
            style: ElevatedButton.styleFrom(backgroundColor: ThemeColors.of(context).primaryDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12))),
            child: Text('Confirmar', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
          ),
        ],
      ),
    );
  }
}








