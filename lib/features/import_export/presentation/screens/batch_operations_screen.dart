import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/import_export/presentation/providers/import_export_provider.dart';
import 'package:tagbean/features/import_export/data/models/import_export_models.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

class ImportacaoOperacoesLoteScreen extends ConsumerStatefulWidget {
  const ImportacaoOperacoesLoteScreen({super.key});

  @override
  ConsumerState<ImportacaoOperacoesLoteScreen> createState() => _ImportacaoOperacoesLoteScreenState();
}

class _ImportacaoOperacoesLoteScreenState extends ConsumerState<ImportacaoOperacoesLoteScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;

  // Acesso ao provider
  BatchOperationsState get _state => ref.watch(batchOperationsProvider);
  BatchOperationsNotifier get _notifier => ref.read(batchOperationsProvider.notifier);

  // Opera??es via provider (com fallback para lista est?tica enquanto carrega)
  List<Map<String, dynamic>> get _operacoes {
    final ops = _state.operations;
    if (ops.isEmpty) {
      // Opera??es est?ticas dispon?veis
      return [
        {
          'titulo': 'Atualizar Pre?os em Lote',
          'subtitulo': 'Upload planilha: C?digo | Novo Pre?o',
          'descricao': 'Altere m?ltiplos pre?os simultaneamente via Excel/CSV',
          'descricaoDetalhada': 'Permite atualizar pre?os de centenas de produtos de uma s? vez. Ideal para reajustes gerais ou promo??es em massa.',
          'icone': Icons.attach_money_rounded,
          'gradiente': [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd],
          'template': true,
          'colunas': ['C?digo de Barras', 'Novo Pre?o', 'Pre?o/Kg (opcional)'],
          'exemplo': 'Ex: 7891234567890 | 12.99 | 15.50',
          'tipo': OperationType.updatePrices,
        },
        {
          'titulo': 'Excluir Produtos em Lote',
          'subtitulo': 'Upload lista de c?digos de barras',
          'descricao': 'Remova m?ltiplos produtos do sistema de uma s? vez',
          'descricaoDetalhada': 'Exclus?o massiva de produtos. ?til para limpeza de cadastros antigos ou produtos descontinuados.',
          'icone': Icons.delete_sweep_rounded,
          'gradiente': [ThemeColors.of(context).error, ThemeColors.of(context).redDark],
          'template': true,
          'colunas': ['C?digo de Barras'],
          'exemplo': 'Ex: 7891234567890',
          'tipo': OperationType.deleteProducts,
        },
        {
          'titulo': 'Associar Tags em Lote',
          'subtitulo': 'Upload: ID Tag | C?digo Produto',
          'descricao': 'Vincule tags ESL aos produtos massivamente',
          'descricaoDetalhada': 'Associa??o r?pida entre etiquetas eletr?nicas e produtos. Perfeito para instala??o inicial ou reorganiza??o.',
          'icone': Icons.link_rounded,
          'gradiente': [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],
          'template': true,
          'colunas': ['ID da Tag', 'C?digo de Barras do Produto'],
          'exemplo': 'Ex: TAG-001 | 7891234567890',
          'tipo': OperationType.associateTags,
        },
        {
          'titulo': 'Atualizar Categorias',
          'subtitulo': 'Reclassificar produtos em massa',
          'descricao': 'Mude categorias de m?ltiplos produtos',
          'descricaoDetalhada': 'Reorganize o cat?logo alterando categorias de v?rios produtos simultaneamente.',
          'icone': Icons.category_rounded,
          'gradiente': [ThemeColors.of(context).primary, ThemeColors.of(context).info],
          'template': true,
          'colunas': ['C?digo de Barras', 'Nova Categoria'],
          'exemplo': 'Ex: 7891234567890 | Alimentos/Cereais',
          'tipo': OperationType.updateCategories,
        },
        {
          'titulo': 'Desassociar Tags em Lote',
          'subtitulo': 'Remover v?nculos tag-produto',
          'descricao': 'Desvincula m?ltiplas tags dos produtos',
          'descricaoDetalhada': 'Remove a associa??o entre tags e produtos. ?til para manuten??o ou reorganiza??o do sistema.',
          'icone': Icons.link_off_rounded,
          'gradiente': [ThemeColors.of(context).orangeMaterial, ThemeColors.of(context).warning],
          'template': true,
          'colunas': ['ID da Tag'],
          'exemplo': 'Ex: TAG-001',
          'tipo': OperationType.disassociateTags,
        },
        {
          'titulo': 'Atualizar Estoque em Lote',
          'subtitulo': 'Ajustar quantidades dispon?veis',
          'descricao': 'Atualize estoque de m?ltiplos produtos',
          'descricaoDetalhada': 'Sincronize estoque massivamente ap?s invent?rios ou recebimentos grandes.',
          'icone': Icons.inventory_rounded,
          'gradiente': [ThemeColors.of(context).cyanMain, ThemeColors.of(context).cyanDark],
          'template': true,
          'colunas': ['C?digo de Barras', 'Quantidade'],
          'exemplo': 'Ex: 7891234567890 | 150',
          'tipo': OperationType.updateStock,
        },
      ];
    }
    return ops.map((o) => {
      'titulo': o.title,
      'subtitulo': o.subtitle,
      'descricao': o.description,
      'descricaoDetalhada': o.detailedDescription,
      'icone': o.icon,
      'gradiente': o.gradientColors,
      'template': o.hasTemplate,
      'colunas': o.columns,
      'exemplo': o.example,
      'tipo': o.type,
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
    
    // Carregar opera??es dispon?veis
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifier.loadOperations();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                Padding(
                  padding: ResponsiveHelper.getResponsiveEdgeInsetsSymmetric(
                    context,
                    mobileHorizontal: 12,
                    mobileVertical: 12,
                    tabletHorizontal: 16,
                    tabletVertical: 16,
                    desktopHorizontal: 20,
                    desktopVertical: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAlertCard(),
                      ResponsiveSpacing.verticalMedium(context),
                      Text(
                        'Opera??es Dispon?veis',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 20,
                            mobileFontSize: 18,
                            tabletFontSize: 19,
                          ),
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.8,
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.spacingXs.get(isMobile, isTablet),
                      ),
                      Text(
                        'Escolha a opera??o que deseja executar',
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
                      ResponsiveSpacing.verticalMedium(context),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _operacoes.length,
                        itemBuilder: (context, index) {
                          return _buildOperationCard(_operacoes[index], index);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
              borderRadius: BorderRadius.circular(
                isMobile ? 9 : 10,
              ),
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
                colors: [ThemeColors.of(context).urgent, ThemeColors.of(context).urgentDark],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 12 : (isTablet ? 13 : 14),
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).urgentLight,
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
            width: AppSizes.paddingMd.get(isMobile, isTablet),
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
                  'A??es Massivas no Sistema',
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
                color: ThemeColors.of(context).errorLight,
                borderRadius: BorderRadius.circular(
                  isMobile ? 9 : 10,
                ),
                border: Border.all(color: ThemeColors.of(context).error),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield_rounded,
                    size: AppSizes.iconTiny.get(isMobile, isTablet),
                    color: ThemeColors.of(context).errorDark,
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
                    'Avan?ado',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                        tabletFontSize: 10.5,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.of(context).errorDark,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAlertCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).orangeAmberLight, ThemeColors.of(context).warningPastel],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        border: Border.all(
          color: ThemeColors.of(context).orangeAmber.withValues(alpha: 0.4),
          width: isMobile ? 1.5 : 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).orangeAmberLight,
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.warning_rounded,
              color: ThemeColors.of(context).orangeAmberDark,
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
                  'Aten??o - Opera??es Irrevers?veis',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 16,
                      mobileFontSize: 14,
                      tabletFontSize: 15,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).orangeDark,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 5,
                    tablet: 5.5,
                    desktop: 6,
                  ),
                ),
                Text(
                  'As opera??es em lote s?o permanentes. Revise os dados antes de executar.',
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationCard(Map<String, dynamic> operacao, int index) {
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
          bottom: AppSizes.spacingMd.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
          border: Border.all(
            color: (operacao['gradiente'][0] as Color)Light,
            width: isMobile ? 1.5 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (operacao['gradiente'][0] as Color)Light,
              blurRadius: isMobile ? 15 : 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: ThemeColors.of(context).transparent,
          child: InkWell(
            onTap: () => _showOperationDialog(operacao),
            borderRadius: BorderRadius.circular(
              isMobile ? 16 : (isTablet ? 18 : 20),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: ResponsiveHelper.getResponsiveWidth(
                      context,
                      mobile: 56,
                      tablet: 60,
                      desktop: 64,
                    ),
                    height: ResponsiveHelper.getResponsiveHeight(
                      context,
                      mobile: 56,
                      tablet: 60,
                      desktop: 64,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: operacao['gradiente']),
                      borderRadius: BorderRadius.circular(
                        isMobile ?  14 : 16,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (operacao['gradiente'][0] as Color)Light,
                          blurRadius: isMobile ? 10 : 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      operacao['icone'],
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconExtraLarge.get(isMobile, isTablet),
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
                          operacao['titulo'],
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
                        SizedBox(
                          height: ResponsiveHelper.getResponsivePadding(
                            context,
                            mobile: 5,
                            tablet: 5.5,
                            desktop: 6,
                          ),
                        ),
                        Text(
                          operacao['subtitulo'],
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 12,
                              mobileFontSize: 11,
                              tabletFontSize: 11.5,
                            ),
                          overflow: TextOverflow.ellipsis,
                            color: ThemeColors.of(context).textSecondaryOverlay70,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsivePadding(
                            context,
                            mobile: 7,
                            tablet: 7.5,
                            desktop: 8,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                            vertical: ResponsiveHelper.getResponsivePadding(
                              context,
                              mobile: 4,
                              tablet: 4.5,
                              desktop: 5,
                            ),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: operacao['gradiente'],
                            ),
                            borderRadius: BorderRadius.circular(
                              isMobile ?  7 : 8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.download_rounded,
                                color: ThemeColors.of(context).surface,
                                size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
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
                                'Template dispon?vel',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 10,
                                    mobileFontSize: 9,
                                    tabletFontSize: 9.5,
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
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: AppSizes.iconSmall.get(isMobile, isTablet),
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOperationDialog(Map<String, dynamic> operacao) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 20 : (isTablet ? 22 : 24)),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : (isTablet ? 450 : 500),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(
                AppSizes.paddingXxl.get(isMobile, isTablet),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      AppSizes.cardPadding.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: operacao['gradiente']),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      operacao['icone'],
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconHeroSm.get(isMobile, isTablet),
                    ),
                  ),
                  ResponsiveSpacing.verticalMedium(context),
                  Text(
                    operacao['titulo'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 22,
                        mobileFontSize: 19,
                        tabletFontSize: 20.5,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.8,
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.spacingBase.get(isMobile, isTablet),
                  ),
                  Text(
                    operacao['descricaoDetalhada'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                        tabletFontSize: 13.5,
                      ),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).textSecondaryOverlay70,
                      height: 1.5,
                    ),
                  ),
                  ResponsiveSpacing.verticalMedium(context),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(
                      AppSizes.paddingMdAlt.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: (operacao['gradiente'][0] as Color)Light,
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.table_chart_rounded,
                              size: AppSizes.iconSmall.get(isMobile, isTablet),
                              color: operacao['gradiente'][0],
                            ),
                            SizedBox(
                              width: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                mobile: 7,
                                tablet: 7.5,
                                desktop: 8,
                              ),
                            ),
                            Text(
                              'Colunas do Template:',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 13,
                                  mobileFontSize: 12,
                                  tabletFontSize: 12.5,
                                ),
                              overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppSizes.spacingBase.get(isMobile, isTablet),
                        ),
                        ...(operacao['colunas'] as List<String>).map((coluna) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                mobile: 5,
                                tablet: 5.5,
                                desktop: 6,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: ResponsiveHelper.getResponsiveIconSize(
                                    context,
                                    mobile: 13,
                                    tablet: 13.5,
                                    desktop: 14,
                                  ),
                                  color: operacao['gradiente'][0],
                                ),
                                SizedBox(
                                  width: ResponsiveHelper.getResponsiveSpacing(
                                    context,
                                    mobile: 7,
                                    tablet: 7.5,
                                    desktop: 8,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    coluna,
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                                        context,
                                        baseFontSize: 12,
                                        mobileFontSize: 11,
                                        tabletFontSize: 11.5,
                                      ),
                                    overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        SizedBox(
                          height: AppSizes.spacingBase.get(isMobile, isTablet),
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
                            color: ThemeColors.of(context).textSecondary,
                            borderRadius: BorderRadius.circular(
                              isMobile ? 7 : 8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: ResponsiveHelper.getResponsiveIconSize(
                                  context,
                                  mobile: 13,
                                  tablet: 13.5,
                                  desktop: 14,
                                ),
                                color: ThemeColors.of(context).textSecondary,
                              ),
                              SizedBox(
                                width: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  mobile: 7,
                                  tablet: 7.5,
                                  desktop: 8,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  operacao['exemplo'],
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      baseFontSize: 11,
                                      mobileFontSize: 10,
                                      tabletFontSize: 10.5,
                                    ),
                                  overflow: TextOverflow.ellipsis,
                                    color: ThemeColors.of(context).textSecondary,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ResponsiveSpacing.verticalMedium(context),
                  if (operacao['template']) ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.download_rounded, color: operacao['gradiente'][0]),
                                  const SizedBox(width: 12),
                                  const Text('Baixando template... '),
                                ],
                              ),
                              backgroundColor: ThemeColors.of(context).surface,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.download_rounded,
                          size: AppSizes.iconSmall.get(isMobile, isTablet),
                        ),
                        label: Text(
                          'Baixar Template',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 14,
                              mobileFontSize: 13,
                              tabletFontSize: 13.5,
                            ),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSizes.paddingSm.get(isMobile, isTablet),
                          ),
                          side: BorderSide(
                            color: operacao['gradiente'][0],
                            width: isMobile ? 1.5 : 2,
                          ),
                          foregroundColor: operacao['gradiente'][0],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              isMobile ? 12 : 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.spacingBase.get(isMobile, isTablet),
                    ),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _mostrarUploadDialog(operacao);
                      },
                      icon: Icon(
                        Icons.upload_file_rounded,
                        size: AppSizes.iconSmall.get(isMobile, isTablet),
                      ),
                      label: Text(
                        'Upload Arquivo',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 13,
                            tabletFontSize: 13.5,
                          ),
                        overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.paddingSm.get(isMobile, isTablet),
                        ),
                        backgroundColor: operacao['gradiente'][0],
                        foregroundColor: ThemeColors.of(context).surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isMobile ? 12 : 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.spacingBase.get(isMobile, isTablet),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 13,
                          tabletFontSize: 13.5,
                        ),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarUploadDialog(Map<String, dynamic> operacao) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.upload_file_rounded, color: operacao['gradiente'][0]),
            const SizedBox(width: 12),
            const Expanded(child: Text('Selecionar Arquivo')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 32,
                  tablet: 36,
                  desktop: 40,
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: operacao['gradiente'][0], width: 2),
                borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
                color: (operacao['gradiente'][0] as Color)Light,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_upload_rounded,
                    size: AppSizes.iconHeroXl.get(isMobile, isTablet),
                    color: operacao['gradiente'][0],
                  ),
                  ResponsiveSpacing.verticalMedium(context),
                  Text(
                    'Clique para selecionar',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 16,
                        mobileFontSize: 15,
                        tabletFontSize: 15.5,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
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
                    'Excel ou CSV',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 13,
                        mobileFontSize: 12,
                        tabletFontSize: 12.5,
                      ),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).textSecondary,
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
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _executarOperacao(operacao);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: operacao['gradiente'][0],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
            ),
            child: const Text('Processar'),
          ),
        ],
      ),
    );
  }

  void _executarOperacao(Map<String, dynamic> operacao) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_rounded, color: operacao['gradiente'][0]),
            const SizedBox(width: 12),
            const Text('Confirmar Opera??o'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Voc? est? prestes a executar:'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (operacao['gradiente'][0] as Color)Light,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    operacao['titulo'],
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 15,
                        mobileFontSize: 14,
                        tabletFontSize: 14.5,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Esta opera??o ? irrevers?vel! ',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 12,
                        mobileFontSize: 11,
                        tabletFontSize: 11.5,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.of(context).error,
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
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(operacao['gradiente'][0]),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Processando opera??o...',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 16,
                            mobileFontSize: 15,
                            tabletFontSize: 15.5,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
              
              // Executar opera??o em lote via provider
              final operationIds = <String>[operacao['id'] as String? ?? operacao['nome'] as String];
              await _notifier.executeOperation(operationIds);
              
              final result = _state.lastResult;
              
              if (mounted) {
                Navigator.pop(context);
                
                if (result != null && _state.errorMessage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              'Opera??o conclu?da: ${result.successCount} de ${result.totalRecords} registros',
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: ThemeColors.of(context).success.withValues(alpha: 0.7),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_state.errorMessage ?? 'Erro ao executar opera??o'),
                      backgroundColor: ThemeColors.of(context).errorIcon,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: operacao['gradiente'][0],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}












