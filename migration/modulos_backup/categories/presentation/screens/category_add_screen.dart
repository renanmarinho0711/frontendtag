import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/enums/loading_status.dart';
import 'package:tagbean/features/categories/presentation/providers/categories_provider.dart';
import 'package:tagbean/features/categories/data/models/category_models.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';

class CategoriasAdicionarScreen extends ConsumerStatefulWidget {
  const CategoriasAdicionarScreen({super.key});

  @override
  ConsumerState<CategoriasAdicionarScreen> createState() =>
      _CategoriasAdicionarScreenState();
}

class _CategoriasAdicionarScreenState extends ConsumerState<CategoriasAdicionarScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  int _tipoCategoria = 0; // 0: Sugerida, 1: Personalizada
  String? _categoriaSugerida;
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  String? _categoriaPai;
  IconData _iconeSelecionado = Icons.category_rounded;
  Color _corSelecionada = AppThemeColors.blueMaterial;
  late TabController _tabController;

  // Categorias sugeridas carregadas do backend
  List<SuggestedCategoryModel> _categoriasSugeridas = [];
  bool _isLoadingSuggestions = true;
  String? _suggestionsError;

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
    Icons.eco_rounded,
    Icons.fastfood_rounded,
    Icons.cake_rounded,
    Icons.sports_bar_rounded,
    Icons.coffee_rounded,
    Icons.local_pizza_rounded,
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
    AppThemeColors.greenLightMaterial,
    AppThemeColors.gold,
    AppThemeColors.blueIndigo,
    AppThemeColors.tealMain,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tipoCategoria = _tabController.index;
      });
    });
    
    // Carregar categorias sugeridas do backend após o build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSuggestedCategories();
    });
  }
  
  Future<void> _loadSuggestedCategories() async {
    setState(() {
      _isLoadingSuggestions = true;
      _suggestionsError = null;
    });
    
    try {
      // Carrega via provider
      await ref.read(suggestedCategoriesProvider.notifier).loadSuggestions();
      final state = ref.read(suggestedCategoriesProvider);
      
      setState(() {
        _isLoadingSuggestions = false;
        if (state.status == LoadingStatus.success) {
          _categoriasSugeridas = state.suggestions;
        } else {
          _suggestionsError = state.error ?? 'Erro ao carregar categorias sugeridas';
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingSuggestions = false;
        _suggestionsError = 'Erro ao carregar: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Nova Categoria',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 18,
              mobileFontSize: 16,
              tabletFontSize: 17,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: AppThemeColors.greenMaterial,
      ),
      backgroundColor: AppThemeColors.surface,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(
                    AppSizes.paddingXlAlt.get(isMobile, isTablet),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTabSelector(),
                      SizedBox(
                        height: AppSizes.paddingXlLg.get(isMobile, isTablet),
                      ),
                      if (_tipoCategoria == 0) ...[
                        _buildSuggestedCategories(),
                      ] else ...[
                        _buildCustomCategoryForm(),
                      ],
                      SizedBox(
                        height: AppSizes.paddingXlLg.get(isMobile, isTablet),
                      ),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget _buildTabSelector() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : (isTablet ? 14 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimaryOverlay05,
            blurRadius: isMobile ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppThemeColors.greenMaterial, AppThemeColors.greenDark],
          ),
          borderRadius: BorderRadius.circular(
            isMobile ? 10 : 12,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppThemeColors.transparent,
        labelColor: AppThemeColors.surface,
        unselectedLabelColor: AppThemeColors.textSecondary,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            baseFontSize: 14,
            mobileFontSize: 13,
          ),
        ),
        tabs: [
          Tab(
            icon: Icon(
              Icons.recommend_rounded,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            ),
            text: 'Sugerida',
          ),
          Tab(
            icon: Icon(
              Icons.edit_rounded,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            ),
            text: 'Personalizada',
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedCategories() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final crossAxisCount = ResponsiveHelper.getGridCrossAxisCount(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 2,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(
            ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 14,
              tablet: 17,
              desktop: 20,
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppThemeColors.blueCyan.withValues(alpha: 0.1),
                AppThemeColors.blueMaterial.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(
              isMobile ? 12 : 16,
            ),
            border: Border.all(
              color: AppThemeColors.blueCyan.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lightbulb_rounded,
                color: AppThemeColors.yellowGold.withValues(alpha: 0.8),
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Escolha uma categoria otimizada para supermercados',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: AppThemeColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: AppSizes.cardPadding.get(isMobile, isTablet),
        ),
        _isLoadingSuggestions
            ? const Center(child: CircularProgressIndicator())
            : _suggestionsError != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, color: AppThemeColors.error, size: 48),
                        const SizedBox(height: 12),
                        Text(_suggestionsError!, style: const TextStyle(color: AppThemeColors.error)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _loadSuggestedCategories,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: isMobile ? 1.5 : 1.5,
            crossAxisSpacing: AppSizes.paddingBase.get(isMobile, isTablet),
            mainAxisSpacing: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          itemCount: _categoriasSugeridas.length,
          itemBuilder: (context, index) {
            final cat = _categoriasSugeridas[index];
            final isSelected = _categoriaSugerida == cat.nome;
            
            return InkWell(
              onTap: () {
                setState(() {
                  _categoriaSugerida = cat.nome;
                });
              },
              borderRadius: BorderRadius.circular(
                isMobile ? 12 : 16,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(
                  AppSizes.paddingMd.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: AppThemeColors.surface,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 12 : 16,
                  ),
                  border: Border.all(
                    color: isSelected ? cat.cor : AppThemeColors.textSecondaryOverlay30,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: cat.cor.withValues(alpha: 0.3),
                            blurRadius: isMobile ? 8 : 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                          AppSizes.paddingBase.get(isMobile, isTablet),
                        ),
                        decoration: BoxDecoration(
                          color: cat.cor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            isMobile ? 10 : 12,
                          ),
                        ),
                        child: Icon(
                          cat.iconData,
                          color: cat.cor,
                          size: AppSizes.iconLarge.get(isMobile, isTablet),
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.paddingXs.get(isMobile, isTablet),
                      ),
                      Text(
                        cat.nome,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 13,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? cat.cor : AppThemeColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: AppSizes.paddingXxs.get(isMobile, isTablet),
                      ),
                      Text(
                        cat.descricao ?? '',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 10,
                            mobileFontSize: 9,
                          ),
                          color: AppThemeColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCustomCategoryForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormCard(),
        SizedBox(
          height: AppSizes.paddingMd.get(isMobile, isTablet),
        ),
        _buildVisualCustomization(),
        SizedBox(
          height: AppSizes.paddingMd.get(isMobile, isTablet),
        ),
        _buildPreviewCard(),
      ],
    );
  }

  Widget _buildFormCard() {
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
              labelText: 'Nome da Categoria *',
              hintText: 'Ex: Bebidas',
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
              labelText: 'Descrição (opcional)',
              hintText: 'Descreva o tipo de produtos desta categoria',
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
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          DropdownButtonFormField<String>(
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
              ),
              color: AppThemeColors.textPrimary,
            ),
            decoration: InputDecoration(
              labelText: 'Categoria Pai (opcional)',
              hintText: 'Selecione para criar subcategoria',
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
                Icons.folder_rounded,
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
            initialValue: _categoriaPai,
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Nenhuma'),
              ),
              ..._categoriasSugeridas.map((e) => DropdownMenuItem<String>(
                    value: e.nome,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          e.iconData,
                          size: AppSizes.iconSmall.get(isMobile, isTablet),
                          color: e.cor,
                        ),
                        const SizedBox(width: 8),
                        Text(e.nome),
                      ],
                    ),
                  )),
            ],
            onChanged: (value) {
              setState(() => _categoriaPai = value);
            },
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
                  setState(() => _iconeSelecionado = icone);
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
                        : AppThemeColors.textSecondaryOverlay20,
                    border: Border.all(
                      color: isSelected ?  _corSelecionada : AppThemeColors.textSecondary,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      isMobile ? 10 : 12,
                    ),
                  ),
                  child: Icon(
                    icone,
                    color: isSelected ? _corSelecionada : AppThemeColors.textSecondary,
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
                  setState(() => _corSelecionada = cor);
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
                      color: isSelected ? AppThemeColors.textPrimary : AppThemeColors.textSecondary,
                      width: isSelected ?  3 : 1,
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

  Widget _buildPreviewCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final nome = _nomeController.text.isEmpty ? 'Sua Categoria' : _nomeController.text;
    final descricao = _descricaoController.text.isEmpty
        ? 'Descrição da categoria'
        : _descricaoController.text;

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _corSelecionada.withValues(alpha: 0.1),
            _corSelecionada.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        border: Border.all(color: _corSelecionada.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.visibility_rounded,
                size: AppSizes.iconSmall.get(isMobile, isTablet),
                color: AppThemeColors.textSecondary,
              ),
              SizedBox(
                width: AppSizes.paddingXs.get(isMobile, isTablet),
              ),
              Text(
                'Prévia',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                  color: AppThemeColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingMd.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_corSelecionada, _corSelecionada.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 12 : 16,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _corSelecionada.withValues(alpha: 0.3),
                      blurRadius: isMobile ? 8 : 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _iconeSelecionado,
                  color: AppThemeColors.surface,
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
                      nome,
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
                      descricao,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 12,
                          mobileFontSize: 11,
                        ),
                        color: AppThemeColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
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
                  onPressed: () => Navigator.pop(context),
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
                    side: const BorderSide(color: AppThemeColors.textSecondary),
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
                  onPressed: _salvarCategoria,
                  icon: Icon(
                    Icons.check_rounded,
                    size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                  ),
                  label: Text(
                    'Criar Categoria',
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
                    backgroundColor: AppThemeColors.greenMaterial,
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
                  onPressed: () => Navigator.pop(context),
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
                    side: const BorderSide(color: AppThemeColors.textSecondaryOverlay60),
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
                  onPressed: _salvarCategoria,
                  icon: Icon(
                    Icons.check_rounded,
                    size: ResponsiveHelper.getResponsiveIconSize(
                      context,
                      tablet: 19,
                      desktop: 20,
                    ),
                  ),
                  label: Text(
                    'Criar Categoria',
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
                    backgroundColor: AppThemeColors.greenMaterial,
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

  void _salvarCategoria() {
    final isMobile = ResponsiveHelper.isMobile(context);

    if (_tipoCategoria == 0 && _categoriaSugerida == null) {
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
                'Selecione uma categoria',
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
            borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
          ),
        ),
      );
      return;
    }
    
    if (_tipoCategoria == 1 && _nomeController.text.isEmpty) {
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
                'Informe o nome da categoria',
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
            borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
          ),
        ),
      );
      return;
    }

    Navigator.pop(context);
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
                    'Categoria criada com sucesso',
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
  }
}


