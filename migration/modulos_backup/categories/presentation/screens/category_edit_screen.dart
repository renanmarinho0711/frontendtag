import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/features/categories/presentation/providers/categories_provider.dart';
import 'package:tagbean/features/categories/data/models/category_models.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

class CategoriasEditarScreen extends ConsumerStatefulWidget {
  final CategoryModel categoria;

  const CategoriasEditarScreen({super.key, required this.categoria});

  @override
  ConsumerState<CategoriasEditarScreen> createState() => _CategoriasEditarScreenState();
}

class _CategoriasEditarScreenState extends ConsumerState<CategoriasEditarScreen>
    with ResponsiveCache {
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late String? _iconeSelecionadoString;
  late IconData _iconeSelecionado;
  late Color _corSelecionada;
  bool _alteracoesFeitas = false;
  bool _salvando = false;

  final List<IconData> _iconesDisponiveis = [
    Icons.local_drink_rounded,
    Icons.shopping_basket_rounded,
    Icons.restaurant_rounded,
    Icons.cleaning_services_rounded,
    Icons.wash_rounded,
    Icons.bakery_dining_rounded,
    Icons.ac_unit_rounded,
    Icons.set_meal_rounded,
    Icons.pets_rounded,
    Icons.kitchen_rounded,
  ];

  final List<Color> _coresDisponiveis = [
    AppThemeColors.blueMaterial,
    AppThemeColors.greenMaterial,
    AppThemeColors.yellowGold,
    AppThemeColors.blueCyan,
    AppThemeColors.blueLight,
    AppThemeColors.brownMain,
    AppThemeColors.cyanMain,
    AppThemeColors.error,
  ];

  // Mapeamento de ícones para strings
  final Map<IconData, String> _iconeParaString = {
    Icons.local_drink_rounded: 'local_drink_rounded',
    Icons.shopping_basket_rounded: 'shopping_basket_rounded',
    Icons.restaurant_rounded: 'restaurant_rounded',
    Icons.cleaning_services_rounded: 'cleaning_services_rounded',
    Icons.wash_rounded: 'wash_rounded',
    Icons.bakery_dining_rounded: 'bakery_dining_rounded',
    Icons.ac_unit_rounded: 'ac_unit_rounded',
    Icons.set_meal_rounded: 'set_meal_rounded',
    Icons.pets_rounded: 'pets_rounded',
    Icons.kitchen_rounded: 'kitchen_rounded',
    Icons.category_rounded: 'category_rounded',
  };

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.categoria.nome);
    _descricaoController = TextEditingController(
      text: widget.categoria.descricao ?? '',
    );
    _iconeSelecionadoString = widget.categoria.icone;
    _iconeSelecionado = widget.categoria.iconData;
    _corSelecionada = widget.categoria.cor;

    _nomeController.addListener(() => setState(() => _alteracoesFeitas = true));
    _descricaoController
        .addListener(() => setState(() => _alteracoesFeitas = true));
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return PopScope(
      canPop: !_alteracoesFeitas,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_alteracoesFeitas) {
          final shouldPop = await _mostrarDialogoSaida();
          if (shouldPop == true && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppThemeColors.surface,
        body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                AppSizes.paddingXlAlt.get(isMobile, isTablet),
              ),
              child: Column(
                children: [
                  _buildModernAppBar(),
                  SizedBox(
                    height: AppSizes.paddingMd.get(isMobile, isTablet),
                  ),
                  _buildInfoCard(),
                  SizedBox(
                    height: AppSizes.paddingMd.get(isMobile, isTablet),
                  ),
                  _buildVisualCustomization(),
                  SizedBox(
                    height: AppSizes.paddingMd.get(isMobile, isTablet),
                  ),
                  _buildProductsCard(),
                  SizedBox(
                    height: AppSizes.paddingMd.get(isMobile, isTablet),
                  ),
                  _buildSubcategoriesCard(),
                  SizedBox(
                    height: AppSizes.paddingXlLg.get(isMobile, isTablet),
                  ),
                  _buildActionButtons(),
                ],
              ),
            ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar() {
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
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimaryOverlay05,
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppThemeColors.textSecondary,
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: AppThemeColors.textSecondary,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              onPressed: () async {
                if (_alteracoesFeitas) {
                  final sair = await _mostrarDialogoSaida();
                  if (sair == true && mounted) {
                    Navigator.pop(context);
                  }
                } else {
                  Navigator.pop(context);
                }
              },
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
                  'Editar Categoria',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 20,
                      mobileFontSize: 18,
                      tabletFontSize: 19,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  widget.categoria.nome,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: AppThemeColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (_alteracoesFeitas)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: AppThemeColors.yellowGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  isMobile ? 7 : 8,
                ),
                border: Border.all(color: AppThemeColors.warningLight),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_rounded,
                    size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                    color: AppThemeColors.warningDark,
                  ),
                  SizedBox(
                    width: AppSizes.paddingXxs.get(isMobile, isTablet),
                  ),
                  Text(
                    'Editando',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                      color: AppThemeColors.warningDark,
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
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimaryOverlay05,
            blurRadius: isMobile ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informações Básicas',
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
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          TextField(
            controller: _nomeController,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
              ),
            ),
            decoration: InputDecoration(
              labelText: 'Nome da Categoria',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                ),
              ),
              prefixIcon: Icon(
                Icons.label_rounded,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              filled: true,
              fillColor: AppThemeColors.textSecondary,
            ),
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          TextField(
            controller: _descricaoController,
            maxLines: 3,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
              ),
            ),
            decoration: InputDecoration(
              labelText: 'Descrição',
              hintText: 'Descreva esta categoria',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                ),
              ),
              hintStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                ),
              ),
              prefixIcon: Icon(
                Icons.description_rounded,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              filled: true,
              fillColor: AppThemeColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualCustomization() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimaryOverlay05,
            blurRadius: isMobile ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personalização Visual',
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
            height: AppSizes.paddingXs.get(isMobile, isTablet),
          ),
          Text(
            'Escolha um ícone e uma cor para identificar sua categoria',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                mobileFontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
              color: AppThemeColors.textSecondary,
            ),
          ),
          Divider(
            height: AppSizes.padding2Xl.get(isMobile, isTablet),
          ),
          Text(
            'Ícone',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _iconesDisponiveis.map((icone) {
              final isSelected = _iconeSelecionado == icone;
              return InkWell(
                onTap: () {
                  setState(() {
                    _iconeSelecionado = icone;
                    _iconeSelecionadoString = _iconeParaString[icone];
                    _alteracoesFeitas = true;
                  });
                },
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(
                    AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _corSelecionada.withValues(alpha: 0.1)
                        : AppThemeColors.textSecondary,
                    border: Border.all(
                      color: isSelected
                          ? _corSelecionada
                          : AppThemeColors.textSecondary,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      isMobile ? 10 : 12,
                    ),
                  ),
                  child: Icon(
                    icone,
                    color: isSelected
                        ? _corSelecionada
                        : AppThemeColors.textSecondary,
                    size: AppSizes.iconLarge.get(isMobile, isTablet),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(
            height: AppSizes.paddingXlLg.get(isMobile, isTablet),
          ),
          Text(
            'Cor',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _coresDisponiveis.map((cor) {
              final isSelected = _corSelecionada == cor;
              final size = AppSizes.iconHeroMd.get(isMobile, isTablet);
              return InkWell(
                onTap: () {
                  setState(() {
                    _corSelecionada = cor;
                    _alteracoesFeitas = true;
                  });
                },
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: cor,
                    borderRadius: BorderRadius.circular(
                      isMobile ? 10 : 12,
                    ),
                    border: Border.all(
                      color: isSelected
                          ? AppThemeColors.textPrimary
                          : AppThemeColors.textSecondary,
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: cor.withValues(alpha: 0.5),
                              blurRadius: isMobile ? 8 : 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          color: AppThemeColors.surface,
                          size: AppSizes.iconLarge.get(isMobile, isTablet),
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimaryOverlay05,
            blurRadius: isMobile ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Produtos Vinculados',
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
                      'Produtos nesta categoria',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 12,
                          mobileFontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                        color: AppThemeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                  vertical: AppSizes.paddingXs.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_corSelecionada, _corSelecionada.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Text(
                  '${widget.categoria.quantidadeProdutos} produtos',
                  style: TextStyle(
                    color: AppThemeColors.surface,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 12,
                      tabletFontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingMd.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: AppThemeColors.textSecondary,
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppThemeColors.textSecondary,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
                SizedBox(
                  width: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                Expanded(
                  child: Text(
                    'Para gerenciar produtos, acesse a tela de produtos',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 12,
                        mobileFontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                      color: AppThemeColors.textSecondary,
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

  Widget _buildSubcategoriesCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Buscar subcategorias do provider
    final categoriesState = ref.watch(categoriesProvider);
    final subcategorias = categoriesState.getSubcategories(widget.categoria.id);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimaryOverlay05,
            blurRadius: isMobile ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subcategorias',
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
                      'Organize produtos em subcategorias',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 12,
                          mobileFontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                        color: AppThemeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Adicionar subcategoria'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          isMobile ? 10 : 12,
                        ),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.add_rounded,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                ),
                label: Text(
                  isMobile ? '' : 'Adicionar',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      tabletFontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: isMobile ? 12 : 16,
                      tablet: 14,
                      desktop: 16,
                    ),
                    vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      isMobile ? 10 : 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: subcategorias.map((sub) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                  vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _corSelecionada.withValues(alpha: 0.1),
                      _corSelecionada.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                  border: Border.all(
                    color: _corSelecionada.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.label_rounded,
                      size: AppSizes.iconTiny.get(isMobile, isTablet),
                      color: _corSelecionada,
                    ),
                    SizedBox(
                      width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                    ),
                    Text(
                      sub.nome,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 13,
                          mobileFontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                        color: _corSelecionada,
                      ),
                    ),
                    SizedBox(
                      width: AppSizes.paddingXxs.get(isMobile, isTablet),
                    ),
                    Icon(
                      Icons.close_rounded,
                      size: AppSizes.iconTiny.get(isMobile, isTablet),
                      color: _corSelecionada.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return isMobile
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    if (_alteracoesFeitas) {
                      final sair = await _mostrarDialogoSaida();
                      if (sair == true && mounted) {
                        Navigator.pop(context);
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                  ),
                  label: Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.paddingLgAlt3.get(isMobile, isTablet),
                    ),
                    side: BorderSide(color: AppThemeColors.textSecondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isMobile ? 12 : 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvarAlteracoes,
                  icon: Icon(
                    Icons.check_rounded,
                    size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                  ),
                  label: Text(
                    'Salvar Alterações',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.paddingLgAlt3.get(isMobile, isTablet),
                    ),
                    backgroundColor: _corSelecionada,
                    foregroundColor: AppThemeColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isMobile ? 12 : 16,
                      ),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    if (_alteracoesFeitas) {
                      final sair = await _mostrarDialogoSaida();
                      if (sair == true && mounted) {
                        Navigator.pop(context);
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    size: ResponsiveHelper.getResponsiveIconSize(
                      context,
                      tablet: 19,
                      desktop: 20,
                    ),
                  ),
                  label: Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        tabletFontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveHelper.getResponsivePadding(
                        context,
                        tablet: 17,
                        desktop: 18,
                      ),
                    ),
                    side: BorderSide(
                        color: AppThemeColors.textSecondaryOverlay60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _salvarAlteracoes,
                  icon: Icon(
                    Icons.check_rounded,
                    size: ResponsiveHelper.getResponsiveIconSize(
                      context,
                      tablet: 19,
                      desktop: 20,
                    ),
                  ),
                  label: Text(
                    'Salvar Alterações',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        tabletFontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveHelper.getResponsivePadding(
                        context,
                        tablet: 17,
                        desktop: 18,
                      ),
                    ),
                    backgroundColor: _corSelecionada,
                    foregroundColor: AppThemeColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          );
  }

  Future<bool?> _mostrarDialogoSaida() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
        ),
        icon: Icon(
          Icons.warning_rounded,
          color: AppThemeColors.yellowGold,
          size: ResponsiveHelper.getResponsiveIconSize(
            context,
            mobile: 40,
            tablet: 44,
            desktop: 48,
          ),
        ),
        title: Text(
          'Descartar Alterações?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 18,
              mobileFontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Você fez alterações que não foram salvas.\n\n'
          'Deseja realmente sair sem salvar? ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Continuar Editando',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemeColors.redMain,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
            ),
            child: Text(
              'Descartar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _salvarAlteracoes() async {
    final isMobile = ResponsiveHelper.isMobile(context);

    if (_nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_rounded,
                color: AppThemeColors.surface,
                size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'O nome da categoria é obrigatório',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: AppThemeColors.redMain,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                AppSizes.paddingBase.get(isMobile, isTablet)),
          ),
        ),
      );
      return;
    }

    if (_salvando) return;

    setState(() => _salvando = true);

    try {
      // Cria CategoryModel atualizado
      final categoriaAtualizada = widget.categoria.copyWith(
        nome: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim().isEmpty 
            ? null 
            : _descricaoController.text.trim(),
        icone: _iconeSelecionadoString,
        cor: _corSelecionada,
        updatedAt: DateTime.now(),
      );

      // Chama a API via provider
      await ref.read(categoriesProvider.notifier).updateCategory(categoriaAtualizada);

      if (!mounted) return;

      Navigator.pop(context, true); // Retorna true para indicar que houve atualização
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingXs.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: AppThemeColors.surfaceOverlay20,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: AppThemeColors.surface,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
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
                      'Sucesso!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Categoria atualizada com sucesso',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 12,
                          mobileFontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: AppThemeColors.greenMaterial,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
          ),
          padding: EdgeInsets.all(
            AppSizes.paddingMdAlt.get(isMobile, isTablet),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_rounded,
                color: AppThemeColors.surface,
                size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Erro ao atualizar categoria: ${e.toString()}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 13,
                    ),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: AppThemeColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                AppSizes.paddingBase.get(isMobile, isTablet)),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }
}


