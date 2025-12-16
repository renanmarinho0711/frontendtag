import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/pricing/data/models/pricing_models.dart';
import 'package:tagbean/features/pricing/presentation/providers/pricing_provider.dart';

class AjusteValorFixoScreen extends ConsumerStatefulWidget {
  const AjusteValorFixoScreen({super.key});

  @override
  ConsumerState<AjusteValorFixoScreen> createState() => _AjusteValorFixoScreenState();
}

class _AjusteValorFixoScreenState extends ConsumerState<AjusteValorFixoScreen> with ResponsiveCache {
  final TextEditingController _valorController = TextEditingController();
  List<String> _categoriasSelecionadas = [];
  
  final List<String> _categorias = [
    'Alimentos',
    'Bebidas',
    'Higiene',
    'Limpeza',
    'Congelados',
    'Latic?nios',
    'Padaria',
    'Hortifruti',
  ];

  // Getters conectados ao Provider
  PricingAdjustmentState get _pricingState => ref.watch(pricingAdjustmentProvider);
  PricingAdjustmentConfigModel get _config => _pricingState.config;
  PricingSimulationResultModel? get _simulationResult => _pricingState.simulationResult;
  bool get _calculando => _pricingState.calculando;
  int get _produtosAfetados => _simulationResult?.produtosAfetados ?? 0;
  double get _impactoTotal => _simulationResult?.impactoTotal ?? 0.0;

  @override
  void initState() {
    super.initState();
    // Configura o tipo de ajuste como fixo ao iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pricingAdjustmentProvider.notifier).setTipoAjuste(AdjustmentType.fixo);
    });
    
    _valorController.addListener(_onValorChanged);
  }

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  void _onValorChanged() {
    final valor = double.tryParse(_valorController.text.replaceAll(',', '.')) ?? 0.0;
    if (valor > 0) {
      ref.read(pricingAdjustmentProvider.notifier).setValor(valor);
      ref.read(pricingAdjustmentProvider.notifier).simularAjuste();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(
                  AppSizes.paddingMdAlt.get(isMobile, isTablet),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTipoAjusteCard(),
                    SizedBox(height: AppSizes.spacingMdAlt.get(isMobile, isTablet)),
                    _buildValorCard(),
                    SizedBox(height: AppSizes.spacingMdAlt.get(isMobile, isTablet)),
                    _buildAplicarEmCard(),
                    if (_config.aplicarEm == ApplyScope.categoria) ...[
                      SizedBox(height: AppSizes.spacingMdAlt.get(isMobile, isTablet)),
                      _buildCategoriasCard(),
                    ],
                    SizedBox(height: AppSizes.spacingMdAlt.get(isMobile, isTablet)),
                    _buildPreviewCard(),
                    SizedBox(height: AppSizes.spacingLg.get(isMobile, isTablet)),
                    _buildAplicarButton(),
                  ],
                ),
              ),
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
      margin: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet),
        vertical: AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 12,
              tablet: 13.5,
              desktop: 15,
            ),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondaryOverlay10,
              borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textSecondary,
                size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
              ),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(context, mobile: 7, tablet: 7.5, desktop: 8),
              ),
              constraints: const BoxConstraints(),
            ),
          ),
          SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
          Container(
            padding: EdgeInsets.all(
              ResponsiveHelper.getResponsivePadding(context, mobile: 7, tablet: 7.5, desktop: 8),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd],
              ),
              borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
            ),
            child: Icon(
              Icons.attach_money_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 9, tablet: 9.5, desktop: 10),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ajuste por Valor Fixo',
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
                Text(
                  'Aumentar ou diminuir em R\$',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10,
                      tabletFontSize: 10.5,
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

  Widget _buildTipoAjusteCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.04),
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(context, mobile: 8, tablet: 9, desktop: 10),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tipo de Ajuste',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14.5),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _buildTipoOption(
                  OperationType.aumentar,
                  'Aumento',
                  Icons.add_circle_outline,
                  ThemeColors.of(context).success,
                ),
              ),
              SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
              Expanded(
                child: _buildTipoOption(
                  OperationType.diminuir,
                  'Redu??o',
                  Icons.remove_circle_outline,
                  ThemeColors.of(context).error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipoOption(OperationType value, String label, IconData icon, Color color) {
    final isSelected = _config.tipoOperacao == value;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return InkWell(
      onTap: () {
        ref.read(pricingAdjustmentProvider.notifier).setTipoOperacao(value);
        if (_valorController.text.isNotEmpty) {
          ref.read(pricingAdjustmentProvider.notifier).simularAjuste();
        }
      },
      borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSizes.paddingBase.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          color: isSelected ? colorLight : ThemeColors.of(context).textSecondaryOverlay05,
          border: Border.all(
            color: isSelected ? color : ThemeColors.of(context).textSecondaryOverlay30,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? color : ThemeColors.of(context).textSecondary,
              size: AppSizes.iconLargeAlt.get(isMobile, isTablet),
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                overflow: TextOverflow.ellipsis,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValorCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.04),
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(context, mobile: 8, tablet: 9, desktop: 10),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Valor do Ajuste',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14.5),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
          TextField(
            controller: _valorController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
            ),
            decoration: InputDecoration(
              hintText: 'Digite o valor (ex: 5.00)',
              hintStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
              ),
              prefixText: 'R\$ ',
              prefixStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
              ),
              prefixIcon: Icon(
                Icons.attach_money_rounded,
                size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
              ),
              filled: true,
              fillColor: ThemeColors.of(context).textSecondaryOverlay05,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAplicarEmCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.04),
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(context, mobile: 8, tablet: 9, desktop: 10),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aplicar Em',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14.5),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
          RadioListTile<ApplyScope>(
            title: Text(
              'Todos os produtos',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            value: ApplyScope.todos,
            groupValue: _config.aplicarEm,
            onChanged: (value) {
              ref.read(pricingAdjustmentProvider.notifier).setAplicarEm(value!);
              ref.read(pricingAdjustmentProvider.notifier).simularAjuste();
            },
          ),
          RadioListTile<ApplyScope>(
            title: Text(
              'Categorias espec?ficas',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            value: ApplyScope.categoria,
            groupValue: _config.aplicarEm,
            onChanged: (value) {
              ref.read(pricingAdjustmentProvider.notifier).setAplicarEm(value!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriasCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.04),
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(context, mobile: 8, tablet: 9, desktop: 10),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecione as Categorias',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14.5),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
          Wrap(
            spacing: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8),
            runSpacing: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8),
            children: _categorias.map((categoria) {
              final isSelected = _categoriasSelecionadas.contains(categoria);
              return FilterChip(
                label: Text(
                  categoria,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _categoriasSelecionadas.add(categoria);
                    } else {
                      _categoriasSelecionadas.remove(categoria);
                    }
                  });
                  if (_categoriasSelecionadas.isNotEmpty) {
                    ref.read(pricingAdjustmentProvider.notifier).setCategoria(_categoriasSelecionadas.first);
                    ref.read(pricingAdjustmentProvider.notifier).simularAjuste();
                  }
                },
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
    final valor = _config.valor;
    final isAumento = _config.tipoOperacao == OperationType.aumentar;

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).successPastel,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
        border: Border.all(color: ThemeColors.of(context).successLight),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                color: ThemeColors.of(context).successIcon,
                size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
              ),
              SizedBox(
                width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8),
              ),
              Expanded(
                child: Text(
                  'Pr?via do Ajuste',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14.5),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_calculando)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: ThemeColors.of(context).successIcon),
                ),
            ],
          ),
          SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
          _buildPreviewItem('Produto de R\$ 10,00', 10.00, valor, isAumento),
          _buildPreviewItem('Produto de R\$ 50,00', 50.00, valor, isAumento),
          _buildPreviewItem('Produto de R\$ 100,00', 100.00, valor, isAumento),
          if (_produtosAfetados > 0) ...[
            const Divider(height: 16),
            Text(
              '$_produtosAfetados produtos afetados | Impacto: ${_impactoTotal >= 0 ? '+' : ''}R\$ ${_impactoTotal.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                fontWeight: FontWeight.bold,
                color: isAumento ? ThemeColors.of(context).success : ThemeColors.of(context).error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewItem(String label, double precoAtual, double ajuste, bool isAumento) {
    final novoPreco = isAumento ? precoAtual + ajuste : precoAtual - ajuste;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 3, tablet: 3.5, desktop: 4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            'R\$ ${novoPreco.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: isAumento ? ThemeColors.of(context).success : ThemeColors.of(context).error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAplicarButton() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isAumento = _config.tipoOperacao == OperationType.aumentar;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _produtosAfetados > 0 ? _aplicarAjuste : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isAumento ? ThemeColors.of(context).greenGradient : ThemeColors.of(context).error,
          disabledBackgroundColor: ThemeColors.of(context).textSecondaryOverlay30,
          padding: EdgeInsets.symmetric(vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
          ),
        ),
        child: Text(
          'Aplicar Ajuste ($_produtosAfetados produtos)',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15, tabletFontSize: 15.5),
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            color: ThemeColors.of(context).surface,
          ),
        ),
      ),
    );
  }

  void _aplicarAjuste() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isAumento = _config.tipoOperacao == OperationType.aumentar;

    if (_valorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Digite um valor v?lido',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
      return;
    }

    if (_config.aplicarEm == ApplyScope.categoria && _categoriasSelecionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Selecione ao menos uma categoria',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
        ),
        title: Text(
          'Confirmar Ajuste',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deseja aplicar ${isAumento ? 'aumento' : 'redu??o'} de R\$ ${_config.valor.toStringAsFixed(2)} '
              '${_config.aplicarEm == ApplyScope.todos ? 'em todos os produtos' : 'nas categorias selecionadas'}?',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isAumento ? ThemeColors.of(context).successPastel : ThemeColors.of(context).errorPastel,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('? $_produtosAfetados produtos afetados'),
                  Text('? Impacto: ${_impactoTotal >= 0 ? '+' : ''}R\$ ${_impactoTotal.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              
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
                    backgroundColor: isAumento ? ThemeColors.of(context).success : ThemeColors.of(context).error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isAumento ? ThemeColors.of(context).success : ThemeColors.of(context).error,
            ),
            child: Text(
              'Confirmar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}










