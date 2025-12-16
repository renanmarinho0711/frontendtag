import 'package:tagbean/core/enums/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/pricing/data/models/pricing_models.dart';
import 'package:tagbean/features/pricing/presentation/providers/pricing_provider.dart';

class AjustePorcentagemScreen extends ConsumerStatefulWidget {
  const AjustePorcentagemScreen({super.key});

  @override
  ConsumerState<AjustePorcentagemScreen> createState() => _AjustePorcentagemScreenState();
}

class _AjustePorcentagemScreenState extends ConsumerState<AjustePorcentagemScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  late AnimationController _calculateController;
  
  final TextEditingController _percentualController = TextEditingController();
  final TextEditingController _valorFixoController = TextEditingController();
  final FocusNode _percentualFocus = FocusNode();
  final FocusNode _valorFixoFocus = FocusNode();
  
  bool _configuracoesAvancadasExpandido = false;

  // Getters conectados ao Provider
  PricingAdjustmentState get _pricingState => ref.watch(pricingAdjustmentProvider);
  PricingAdjustmentConfigModel get _config => _pricingState.config;
  PricingSimulationResultModel? get _simulationResult => _pricingState.simulationResult;
  bool get _calculando => _pricingState.calculando;
  
  int get _produtosAfetados => _simulationResult?.produtosAfetados ?? 0;
  double get _impactoTotal => _simulationResult?.impactoTotal ?? 0.0;
  List<PricingProductModel> get _produtos => _simulationResult?.produtos ?? [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _calculateController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
    
    _percentualController.addListener(_onValorChanged);
    _valorFixoController.addListener(_onValorChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calculateController.dispose();
    _percentualController.dispose();
    _valorFixoController.dispose();
    _percentualFocus.dispose();
    _valorFixoFocus.dispose();
    super.dispose();
  }

  void _onValorChanged() {
    double valor = 0.0;
    if (_config.tipoAjuste == AdjustmentType.percentual && _percentualController.text.isNotEmpty) {
      valor = double.tryParse(_percentualController.text.replaceAll(',', '.')) ?? 0.0;
    } else if (_config.tipoAjuste == AdjustmentType.fixo && _valorFixoController.text.isNotEmpty) {
      valor = double.tryParse(_valorFixoController.text.replaceAll(',', '.')) ?? 0.0;
    }
    
    if (valor > 0) {
      ref.read(pricingAdjustmentProvider.notifier).setValor(valor);
      _calcularSimulacao();
    }
  }

  void _calcularSimulacao() {
    _calculateController.forward(from: 0);
    ref.read(pricingAdjustmentProvider.notifier).simularAjuste();
  }

  void _aplicarQuick(int valor, bool aumentar) {
    ref.read(pricingAdjustmentProvider.notifier).setTipoAjuste(AdjustmentType.percentual);
    ref.read(pricingAdjustmentProvider.notifier).setTipoOperacao(
      aumentar ? OperationType.aumentar : OperationType.diminuir
    );
    _percentualController.text = valor.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildEnhancedHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickActions(),
                    SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
                    _buildTipoAjusteCard(),
                    SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
                    _buildInputCard(),
                    SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
                    _buildFiltrosCard(),
                    SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
                    _buildConfiguracoesAvancadas(),
                    SizedBox(height: AppSizes.paddingXl.get(isMobile, isTablet)),
                    _buildResumoImpacto(),
                    SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
                    Text(
                      'Pr�-visualiza��o',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 20, mobileFontSize: 18, tabletFontSize: 19),
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.8,
                      ),
                    ),
                    SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                    if (_pricingState.status == LoadingStatus.loading)
                      const Center(child: CircularProgressIndicator())
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context, mobile: 1, tablet: 2, desktop: 3),
                          crossAxisSpacing: AppSizes.paddingBase.get(isMobile, isTablet),
                          mainAxisSpacing: AppSizes.paddingBase.get(isMobile, isTablet),
                          childAspectRatio: isMobile ? 4.2 : (isTablet ? 4.4 : 4.5),
                        ),
                        itemCount: _produtos.length,
                        itemBuilder: (context, index) => _buildProdutoPreview(_produtos[index]),
                      ),
                    SizedBox(height: AppSizes.padding2Xl.get(isMobile, isTablet)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildActionButtons(),
    );
  }

  Widget _buildEnhancedHeader() {
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondaryOverlay10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).textSecondary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 22),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ajuste por Porcentagem',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Altera��o massiva de pre�os',
                  style: TextStyle(fontSize: 11, color: ThemeColors.of(context).textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).primaryPastel]),
        borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
        border: Border.all(color: ThemeColors.of(context).infoLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flash_on_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet), color: ThemeColors.of(context).infoDark),
              const SizedBox(width: 8),
              Text(
                'A��es R�pidas',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).infoDark,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          Row(
            children: [
              Expanded(child: _buildQuickButton('+5%', () => _aplicarQuick(5, true))),
              const SizedBox(width: 8),
              Expanded(child: _buildQuickButton('+10%', () => _aplicarQuick(10, true))),
              const SizedBox(width: 8),
              Expanded(child: _buildQuickButton('-5%', () => _aplicarQuick(5, false))),
              const SizedBox(width: 8),
              Expanded(child: _buildQuickButton('-10%', () => _aplicarQuick(10, false))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(String label, VoidCallback onPressed) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(isMobile ? 7 : 8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 9 : 10),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(isMobile ? 7 : 8),
          border: Border.all(color: ThemeColors.of(context).textSecondaryOverlay30),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTipoAjusteCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
            blurRadius: 20,
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
                padding: EdgeInsets.all(isMobile ? 9 : 10),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).primaryPastel,
                  borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                ),
                child: Icon(
                  Icons.settings_suggest_rounded,
                  color: ThemeColors.of(context).primaryDark,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Text(
                'Tipo de Ajuste',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 17, mobileFontSize: 15, tabletFontSize: 16),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildTipoChip('Percentual (%)', AdjustmentType.percentual, Icons.percent_rounded),
              _buildTipoChip('Valor Fixo (R\$)', AdjustmentType.fixo, Icons.attach_money_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipoChip(String label, AdjustmentType value, IconData icon) {
    final isSelected = _config.tipoAjuste == value;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return InkWell(
      onTap: () => ref.read(pricingAdjustmentProvider.notifier).setTipoAjuste(value),
      borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          vertical: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? LinearGradient(colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark])
              : null,
          color: isSelected ? null : ThemeColors.of(context).textSecondaryOverlay10,
          borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
          border: Border.all(color: isSelected ? ThemeColors.of(context).transparent : ThemeColors.of(context).textSecondaryOverlay30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSizes.iconSmall.get(isMobile, isTablet), color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondaryOverlay80,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
            blurRadius: 20,
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
                padding: EdgeInsets.all(isMobile ? 9 : 10),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).infoPastel,
                  borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                ),
                child: Icon(
                  Icons.calculate_rounded,
                  color: ThemeColors.of(context).infoDark,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Text(
                'Defina o Valor',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 17, mobileFontSize: 15, tabletFontSize: 16),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingLg.get(isMobile, isTablet)),
          Row(
            children: [
              Expanded(child: _buildOperacaoButton('Aumentar', OperationType.aumentar, Icons.add_rounded, ThemeColors.of(context).success)),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Expanded(child: _buildOperacaoButton('Reduzir', OperationType.diminuir, Icons.remove_rounded, ThemeColors.of(context).error)),
            ],
          ),
          SizedBox(height: AppSizes.paddingLg.get(isMobile, isTablet)),
          if (_config.tipoAjuste == AdjustmentType.percentual)
            _buildInputField(
              controller: _percentualController,
              focus: _percentualFocus,
              label: 'Percentual',
              hint: 'Ex: 10.5',
              prefixText: _config.tipoOperacao == OperationType.aumentar ? '+' : '-',
              suffixText: '%',
            ),
          if (_config.tipoAjuste == AdjustmentType.fixo)
            _buildInputField(
              controller: _valorFixoController,
              focus: _valorFixoFocus,
              label: 'Valor Fixo',
              hint: 'Ex: 2.50',
              prefixText: 'R\$ ',
              suffixText: '',
            ),
        ],
      ),
    );
  }

  Widget _buildOperacaoButton(String label, OperationType value, IconData icon, Color color) {
    final isSelected = _config.tipoOperacao == value;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return InkWell(
      onTap: () {
        ref.read(pricingAdjustmentProvider.notifier).setTipoOperacao(value);
        _calcularSimulacao();
      },
      borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(colors: [color, color.withValues(alpha: 0.7)]) : null,
          color: isSelected ? null : ThemeColors.of(context).textSecondaryOverlay10,
          borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
          border: Border.all(color: isSelected ? ThemeColors.of(context).transparent : ThemeColors.of(context).textSecondaryOverlay30, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary, size: AppSizes.iconMediumSmall.get(isMobile, isTablet)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14.5),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focus,
    required String label,
    required String hint,
    required String prefixText,
    required String suffixText,
  }) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return TextField(
      controller: controller,
      focusNode: focus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      style: TextStyle(
        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 32, mobileFontSize: 26, tabletFontSize: 29),
        fontWeight: FontWeight.bold,
        letterSpacing: -1,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefixText,
        suffixText: suffixText,
        prefixStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: _config.tipoOperacao == OperationType.aumentar ? ThemeColors.of(context).success : ThemeColors.of(context).error,
        ),
        suffixStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ThemeColors.of(context).textSecondary),
        filled: true,
        fillColor: ThemeColors.of(context).textSecondaryOverlay05,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(isMobile ? 14 : 16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
          borderSide: BorderSide(color: ThemeColors.of(context).textSecondaryOverlay30, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
          borderSide: BorderSide(color: ThemeColors.of(context).blueCyan, width: 2),
        ),
      ),
    );
  }

  Widget _buildFiltrosCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
            blurRadius: 20,
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
                padding: EdgeInsets.all(isMobile ? 9 : 10),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).warningPastel,
                  borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                ),
                child: Icon(
                  Icons.filter_alt_rounded,
                  color: ThemeColors.of(context).warningDark,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Text(
                'Aplicar Em',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 17, mobileFontSize: 15, tabletFontSize: 16),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildFiltroChip('Todos', ApplyScope.todos),
              _buildFiltroChip('Categoria', ApplyScope.categoria),
              _buildFiltroChip('Marca', ApplyScope.marca),
            ],
          ),
          if (_config.aplicarEm == ApplyScope.categoria) ...[
            SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
            DropdownButtonFormField<String>(
              value: _config.categoriaSelecionada ?? 'Todas',
              decoration: InputDecoration(
                labelText: 'Selecione a Categoria',
                prefixIcon: Icon(Icons.category_rounded, color: ThemeColors.of(context).warningDark, size: AppSizes.iconMediumAlt.get(isMobile, isTablet)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
                filled: true,
                fillColor: ThemeColors.of(context).textSecondaryOverlay05,
              ),
              items: ['Todas', 'Bebidas', 'Alimentos', 'Limpeza', 'Higiene']
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) {
                ref.read(pricingAdjustmentProvider.notifier).setCategoria(value);
                _calcularSimulacao();
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFiltroChip(String label, ApplyScope value) {
    final isSelected = _config.aplicarEm == value;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return InkWell(
      onTap: () {
        ref.read(pricingAdjustmentProvider.notifier).setAplicarEm(value);
        _calcularSimulacao();
      },
      borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSm.get(isMobile, isTablet),
          vertical: isMobile ? 9 : 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? ThemeColors.of(context).orangeMaterial.withValues(alpha: 0.1) : ThemeColors.of(context).textSecondaryOverlay05,
          borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
          border: Border.all(color: isSelected ? ThemeColors.of(context).orangeMaterial : ThemeColors.of(context).textSecondaryOverlay30),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? ThemeColors.of(context).orangeMaterial : ThemeColors.of(context).textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildConfiguracoesAvancadas() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _configuracoesAvancadasExpandido = !_configuracoesAvancadasExpandido),
            borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isMobile ? 9 : 10),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).successPastel,
                    borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: ThemeColors.of(context).successIcon,
                    size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                  ),
                ),
                SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                Expanded(
                  child: Text(
                    'Configura��es Avan�adas',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 17, mobileFontSize: 15, tabletFontSize: 16),
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                Icon(
                  _configuracoesAvancadasExpandido ? Icons.expand_less : Icons.expand_more,
                  color: ThemeColors.of(context).textSecondary,
                  size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
                ),
              ],
            ),
          ),
          if (_configuracoesAvancadasExpandido) ...[
            SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
            _buildSwitchTile(
              'Respeitar Margem M�nima',
              'N�o reduzir abaixo de ${_config.margemMinimaSeguranca}%',
              Icons.shield_rounded,
              _config.respeitarMargemMinima,
              (value) {
                ref.read(pricingAdjustmentProvider.notifier).updateConfig(
                  _config.copyWith(respeitarMargemMinima: value),
                );
              },
            ),
            SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
            _buildSwitchTile(
              'Apenas Produtos Ativos',
              'Ignorar produtos inativos',
              Icons.check_circle_rounded,
              _config.aplicarApenasProdutosAtivos,
              (value) {
                ref.read(pricingAdjustmentProvider.notifier).updateConfig(
                  _config.copyWith(aplicarApenasProdutosAtivos: value),
                );
                _calcularSimulacao();
              },
            ),
            SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
            _buildSwitchTile(
              'Notificar Tags ESL',
              'Sincronizar automaticamente ap�s aplicar',
              Icons.notifications_active_rounded,
              _config.notificarTags,
              (value) {
                ref.read(pricingAdjustmentProvider.notifier).updateConfig(
                  _config.copyWith(notificarTags: value),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: value ? ThemeColors.of(context).successPastel : ThemeColors.of(context).textSecondaryOverlay05,
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
        border: Border.all(color: value ? ThemeColors.of(context).success.withValues(alpha: 0.3) : ThemeColors.of(context).textSecondaryOverlay20),
      ),
      child: Row(
        children: [
          Icon(icon, color: value ? ThemeColors.of(context).success : ThemeColors.of(context).textSecondaryOverlay70, size: AppSizes.iconMediumAlt.get(isMobile, isTablet)),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10.5),
                    color: ThemeColors.of(context).textSecondaryOverlay70,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: isMobile ? 0.8 : 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: ThemeColors.of(context).success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoImpacto() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isAumento = _config.tipoOperacao == OperationType.aumentar;

    return AnimatedBuilder(
      animation: _calculateController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isAumento
                  ? [ThemeColors.of(context).success, ThemeColors.of(context).successIcon]
                  : [ThemeColors.of(context).error, ThemeColors.of(context).error.withValues(alpha: 0.7)],
            ),
            borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
            boxShadow: [
              BoxShadow(
                color: (isAumento ? ThemeColors.of(context).success : ThemeColors.of(context).error).withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 9 : 10),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                ),
                child: Icon(Icons.analytics_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMediumSmall.get(isMobile, isTablet)),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Resumo do Impacto',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 13, tabletFontSize: 14),
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingBase.get(isMobile, isTablet), vertical: 6),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(isMobile ? 7 : 8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inventory_2_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconSmall.get(isMobile, isTablet)),
                    const SizedBox(width: 6),
                    Text(
                      '$_produtosAfetados',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 14, tabletFontSize: 15),
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingBase.get(isMobile, isTablet), vertical: 6),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(isMobile ? 7 : 8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isAumento ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconSmall.get(isMobile, isTablet)),
                    const SizedBox(width: 6),
                    Text(
                      '${_impactoTotal >= 0 ? '+' : ''}${_impactoTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 14, tabletFontSize: 15),
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                      ),
                    ),
                  ],
                ),
              ),
              if (_calculando)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SizedBox(
                    width: isMobile ? 14 : 16,
                    height: isMobile ? 14 : 16,
                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProdutoPreview(PricingProductModel produto) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final variacao = produto.variacao;
    
    if (variacao == 0) return const SizedBox.shrink();
    
    return Container(
      padding: EdgeInsets.all(isMobile ? 9 : 10),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
        border: Border.all(color: produto.cor.withValues(alpha: 0.3), width: isMobile ? 1.2 : 1.5),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 7 : 8),
                decoration: BoxDecoration(
                  color: produto.cor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(isMobile ? 7 : 8),
                ),
                child: Icon(Icons.shopping_bag_rounded, color: produto.cor, size: AppSizes.iconTiny.get(isMobile, isTablet)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  produto.nome,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 12, tabletFontSize: 13),
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (produto.hasTag)
            Row(
              children: [
                Icon(Icons.sell_rounded, size: AppSizes.iconTiny.get(isMobile, isTablet), color: ThemeColors.of(context).textSecondary),
                const SizedBox(width: 4),
                Text(
                  produto.tag!,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: variacao > 0
                    ? [ThemeColors.of(context).success, ThemeColors.of(context).success.withValues(alpha: 0.7)]
                    : [ThemeColors.of(context).error, ThemeColors.of(context).error.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(isMobile ? 5 : 6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  variacao > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  size: AppSizes.iconTiny.get(isMobile, isTablet),
                  color: ThemeColors.of(context).surface,
                ),
                const SizedBox(width: 4),
                Text(
                  'R\$ ${variacao.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
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

  Widget _buildActionButtons() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isAumento = _config.tipoOperacao == OperationType.aumentar;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          onPressed: () => Navigator.pop(context),
          backgroundColor: ThemeColors.of(context).textSecondaryOverlay20,
          foregroundColor: ThemeColors.of(context).textSecondary,
          icon: Icon(Icons.close_rounded, size: AppSizes.iconMediumAlt.get(isMobile, isTablet)),
          label: Text(
            'Cancelar',
            style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5)),
          ),
          heroTag: 'cancel',
        ),
        SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
        FloatingActionButton.extended(
          onPressed: _produtosAfetados > 0 ? _confirmarAplicacao : null,
          backgroundColor: _produtosAfetados > 0 
              ? (isAumento ? ThemeColors.of(context).success : ThemeColors.of(context).error)
              : ThemeColors.of(context).textSecondaryOverlay30,
          icon: Icon(Icons.check_rounded, size: AppSizes.iconMediumAlt.get(isMobile, isTablet)),
          label: Text(
            'Aplicar ($_produtosAfetados)',
            style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5)),
          ),
          heroTag: 'apply',
        ),
      ],
    );
  }

  void _confirmarAplicacao() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isAumento = _config.tipoOperacao == OperationType.aumentar;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 20 : 24)),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: isAumento ? ThemeColors.of(context).success : ThemeColors.of(context).error,
              size: AppSizes.iconExtraLarge.get(isMobile, isTablet),
            ),
            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
            const Expanded(
              child: Text('Confirmar Ajuste', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Voc� est� prestes a aplicar:'),
            SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
            Container(
              padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isAumento
                      ? [ThemeColors.of(context).success.withValues(alpha: 0.1), ThemeColors.of(context).successLight]
                      : [ThemeColors.of(context).errorPastel, ThemeColors.of(context).error.withValues(alpha: 0.2)],
                ),
                borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${isAumento ? 'Aumento' : 'Redu��o'} de ${_config.valor}%',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('� $_produtosAfetados produtos afetados'),
                  Text('� Impacto: ${_impactoTotal >= 0 ? '+' : ''}R\$ ${_impactoTotal.toStringAsFixed(2)}'),
                  if (_config.notificarTags) const Text('� Tags ESL ser�o notificadas'),
                ],
              ),
            ),
            SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
            const Text(
              'Esta opera��o n�o pode ser desfeita.',
              style: TextStyle(fontSize: 12, color: ThemeColors.of(context).error, fontWeight: FontWeight.bold),
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
              
              // Aplica o ajuste via provider
              await ref.read(pricingAdjustmentProvider.notifier).aplicarAjuste();
              
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                        const SizedBox(width: 12),
                        Expanded(child: Text('Ajuste aplicado em $_produtosAfetados produtos!')),
                      ],
                    ),
                    backgroundColor: ThemeColors.of(context).success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isAumento ? ThemeColors.of(context).success : ThemeColors.of(context).error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
            ),
            child: const Text('Confirmar Ajuste'),
          ),
        ],
      ),
    );
  }
}









