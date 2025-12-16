import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/pricing/data/models/pricing_models.dart';
import 'package:tagbean/features/pricing/presentation/providers/pricing_provider.dart';

class PrecificacaoAjustePorcentagemScreen extends ConsumerStatefulWidget {
  const PrecificacaoAjustePorcentagemScreen({super.key});

  @override
  ConsumerState<PrecificacaoAjustePorcentagemScreen> createState() =>
      _PrecificacaoAjustePorcentagemScreenState();
}

class _PrecificacaoAjustePorcentagemScreenState
    extends ConsumerState<PrecificacaoAjustePorcentagemScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  final _porcentagemController = TextEditingController();

  // Getters conectados ao Provider
  PricingAdjustmentState get _pricingState => ref.watch(pricingAdjustmentProvider);
  PricingAdjustmentConfigModel get _config => _pricingState.config;
  PricingSimulationResultModel? get _simulationResult => _pricingState.simulationResult;
  bool get _calculando => _pricingState.calculando;
  bool get _mostrarPrevia => _simulationResult != null;

  int get _tipoAjuste => _config.tipoOperacao == OperationType.aumento ? 0 : 1;
  int get _selecaoProdutos => _config.aplicarEm == ApplyScope.todos ? 0 :
                              (_config.aplicarEm == ApplyScope.categoria ? 1 : 2);
  String get _categoriaSelecionada => _config.categoriaSelecionada ?? 'Bebidas';

  final List<String> _categorias = [
    'Bebidas',
    'Alimentos',
    'Higiene',
    'Limpeza',
    'Congelados',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pricingAdjustmentProvider.notifier).setTipoAjuste(AdjustmentType.porcentagem);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _porcentagemController.dispose();
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
              _buildModernAppBar(),
              Padding(
                padding: EdgeInsets.all(
                  AppSizes.paddingLgAlt.get(isMobile, isTablet),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildConfigCard(),
                    SizedBox(
                      height: AppSizes.spacingMdAlt.get(isMobile, isTablet),
                    ),
                    _buildSelecaoProdutosCard(),
                    if (_mostrarPrevia) ...[
                      SizedBox(
                        height: AppSizes.spacingMdAlt.get(isMobile, isTablet),
                      ),
                      _buildPreviaCard(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar() {
    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMdAlt.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingLgAlt.get(isMobile, isTablet),
        vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 18 : (isTablet ? 19 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondaryOverlay10,
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textSecondary,
                size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(
            width: AppSizes.spacingMdAlt.get(isMobile, isTablet),
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
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.percent_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ajuste por Porcentagem',
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
                Text(
                  'Alterar pre�os em %',
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
        ],
      ),
    );
  }

  Widget _buildConfigCard() {
    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXl.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 18 : (isTablet ? 19 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
            offset: const Offset(0, 2),
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
                  ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 7,
                    tablet: 7.5,
                    desktop: 8,
                  ),
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
                  Icons.settings_rounded,
                  color: ThemeColors.of(context).surface,
                  size: ResponsiveHelper.getResponsiveIconSize(
                    context,
                    mobile: 17,
                    tablet: 17.5,
                    desktop: 18,
                  ),
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Text(
                'Configura��o do Ajuste',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 15,
                    tabletFontSize: 15.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.spacingLg.get(isMobile, isTablet),
          ),
          Text(
            'Tipo de Ajuste',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
                tabletFontSize: 13.5,
              ),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _buildTipoButton(
                  'Aumento',
                  Icons.trending_up_rounded,
                  0,
                  ThemeColors.of(context).success,
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildTipoButton(
                  'Redu��o',
                  Icons.trending_down_rounded,
                  1,
                  ThemeColors.of(context).error,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.spacingLg.get(isMobile, isTablet),
          ),
          TextFormField(
            controller: _porcentagemController,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
                tabletFontSize: 13.5,
              ),
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Porcentagem de Ajuste',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 12,
                  mobileFontSize: 11,
                  tabletFontSize: 11.5,
                ),
              ),
              hintText: 'Ex: 10',
              suffixText: '%',
              prefixIcon: Icon(
                Icons.percent_rounded,
                size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
              ),
              helperText: _tipoAjuste == 0
                  ? 'Valor que ser� acrescido aos pre�os'
                  : 'Valor que ser� descontado dos pre�os',
              helperStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 11,
                  mobileFontSize: 10,
                  tabletFontSize: 10.5,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                vertical: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              isDense: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            onChanged: (value) {
              final valor = double.tryParse(value) ?? 0.0;
              ref.read(pricingAdjustmentProvider.notifier).setValor(valor);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTipoButton(String label, IconData icon, int value, Color color) {
    final isSelected = _tipoAjuste == value;

    return InkWell(
      onTap: () {
        ref.read(pricingAdjustmentProvider.notifier).setTipoOperacao(
          value == 0 ? OperationType.aumento : OperationType.reducao,
        );
      },
      borderRadius: BorderRadius.circular(
        isMobile ? 10 : 12,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingSm.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : ThemeColors.of(context).textSecondaryOverlay10,
          borderRadius: BorderRadius.circular(
            isMobile ? 10 : 12,
          ),
          border: Border.all(
            color: isSelected ? color : ThemeColors.of(context).textSecondaryOverlay40,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : ThemeColors.of(context).textSecondary,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
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
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13.5,
                ),
                overflow: TextOverflow.ellipsis,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? color : ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelecaoProdutosCard() {
    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXl.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 18 : (isTablet ? 19 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
            offset: const Offset(0, 2),
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
                  ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 7,
                    tablet: 7.5,
                    desktop: 8,
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).primary, ThemeColors.of(context).cyanMain],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 8 : 10,
                  ),
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  color: ThemeColors.of(context).surface,
                  size: ResponsiveHelper.getResponsiveIconSize(
                    context,
                    mobile: 17,
                    tablet: 17.5,
                    desktop: 18,
                  ),
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Text(
                'Sele��o de Produtos',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 15,
                    tabletFontSize: 15.5,
                  ),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.spacingLg.get(isMobile, isTablet),
          ),
          _buildSelecaoOption('Todos os produtos', 0, Icons.select_all_rounded),
          SizedBox(height: AppSizes.spacingSm.get(isMobile, isTablet)),
          _buildSelecaoOption('Por categoria', 1, Icons.category_rounded),
          if (_selecaoProdutos == 1) ...[
            SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
            _buildCategoriaDropdown(),
          ],
          SizedBox(height: AppSizes.spacingSm.get(isMobile, isTablet)),
          _buildSelecaoOption('Por lista', 2, Icons.list_alt_rounded),
          SizedBox(height: AppSizes.spacingLg.get(isMobile, isTablet)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _calculando ? null : _calcularPrevia,
              icon: _calculando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ThemeColors.of(context).surface,
                      ),
                    )
                  : const Icon(Icons.calculate_rounded),
              label: Text(_calculando ? 'Calculando...' : 'Calcular Pr�via'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.of(context).blueCyan,
                foregroundColor: ThemeColors.of(context).surface,
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.paddingMd.get(isMobile, isTablet),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelecaoOption(String label, int value, IconData icon) {
    final isSelected = _selecaoProdutos == value;

    return InkWell(
      onTap: () {
        ApplyScope scope;
        switch (value) {
          case 0:
            scope = ApplyScope.todos;
            break;
          case 1:
            scope = ApplyScope.categoria;
            break;
          default:
            scope = ApplyScope.lista;
        }
        ref.read(pricingAdjustmentProvider.notifier).setAplicarEm(scope);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          color: isSelected ? ThemeColors.of(context).primaryLight.withValues(alpha: 0.2) : ThemeColors.of(context).transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? ThemeColors.of(context).primary : ThemeColors.of(context).textSecondaryOverlay30,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? ThemeColors.of(context).primary : ThemeColors.of(context).textSecondary),
            SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? ThemeColors.of(context).primary : ThemeColors.of(context).textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_rounded, color: ThemeColors.of(context).primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriaDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingBase.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColors.of(context).textSecondaryOverlay30),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: _categoriaSelecionada,
        isExpanded: true,
        underline: const SizedBox(),
        items: _categorias.map((cat) {
          return DropdownMenuItem(value: cat, child: Text(cat));
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            ref.read(pricingAdjustmentProvider.notifier).setCategoria(value);
          }
        },
      ),
    );
  }

  Widget _buildPreviaCard() {
    final result = _simulationResult!;

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingXl.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
        border: Border.all(color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Pr�via do Ajuste',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPreviaInfo('Produtos afetados', '${result.produtosAfetados}'),
          const SizedBox(height: 12),
          _buildPreviaInfo(
            'Impacto total',
            'R\$ ${result.impactoTotal.toStringAsFixed(2)}',
            color: result.impactoTotal >= 0 ? ThemeColors.of(context).success : ThemeColors.of(context).error,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(pricingAdjustmentProvider.notifier).resetSimulation();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ThemeColors.of(context).textSecondary,
                    side: BorderSide(color: ThemeColors.of(context).textSecondaryOverlay30),
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _aplicarAjuste,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.of(context).success,
                    foregroundColor: ThemeColors.of(context).surface,
                  ),
                  child: const Text('Aplicar Ajuste'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviaInfo(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: ThemeColors.of(context).textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color ?? ThemeColors.of(context).textPrimary,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  void _calcularPrevia() {
    ref.read(pricingAdjustmentProvider.notifier).simularAjuste();
  }

  void _aplicarAjuste() {
    ref.read(pricingAdjustmentProvider.notifier).aplicarAjuste();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface),
            SizedBox(width: 12),
            Text('Ajuste aplicado com sucesso!'),
          ],
        ),
        backgroundColor: ThemeColors.of(context).success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}










