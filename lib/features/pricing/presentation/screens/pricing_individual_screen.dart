import 'package:tagbean/core/enums/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/pricing/data/models/pricing_models.dart';
import 'package:tagbean/features/pricing/presentation/providers/pricing_provider.dart';

class PrecificacaoAjusteIndividualScreen extends ConsumerStatefulWidget {
  const PrecificacaoAjusteIndividualScreen({super.key});

  @override
  ConsumerState<PrecificacaoAjusteIndividualScreen> createState() =>
      _PrecificacaoAjusteIndividualScreenState();
}

class _PrecificacaoAjusteIndividualScreenState
    extends ConsumerState<PrecificacaoAjusteIndividualScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  final _buscaController = TextEditingController();
  final _novoPrecoController = TextEditingController();
  final _motivoController = TextEditingController();

  // Getters conectados ao Provider
  IndividualAdjustmentState get _state => ref.watch(individualAdjustmentProvider);
  IndividualProductModel? get _produtoSelecionado => _state.selectedProduct;
  List<PriceHistoryEntry> get _historico => _state.priceHistory;
  bool get _isLoading => _state.status == LoadingStatus.loading;
  bool get _mostrarDetalhes => _produtoSelecionado != null;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _buscaController.dispose();
    _novoPrecoController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: true,
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildModernAppBar(),
              ),
              SliverPadding(
                padding: EdgeInsets.all(
                  AppSizes.paddingLgAlt.get(isMobile, isTablet),
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildBuscaCard(),
                    if (_mostrarDetalhes) ...[
                      SizedBox(
                        height: AppSizes.spacingMdAlt.get(isMobile, isTablet),
                      ),
                      _buildProdutoCard(),
                      SizedBox(
                        height: AppSizes.spacingMdAlt.get(isMobile, isTablet),
                      ),
                      _buildNovoPrecoCard(),
                      SizedBox(
                        height: AppSizes.spacingMdAlt.get(isMobile, isTablet),
                      ),
                      _buildHistoricoCard(),
                    ],
                  ]),
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
                colors: [ThemeColors.of(context).primaryPastel, ThemeColors.of(context).yellowGold],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.edit_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ajuste Individual',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 18,
                        mobileFontSize: 16,
                        tabletFontSize: 17,
                      ),
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Alterar produto espec?fico',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 12,
                        mobileFontSize: 11,
                        tabletFontSize: 11.5,
                      ),
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuscaCard() {
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
                  Icons.search_rounded,
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
              Flexible(
                child: Text(
                  'Buscar Produto',
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
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.spacingMdAlt.get(isMobile, isTablet),
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _buscaController,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 13,
                      tabletFontSize: 13.5,
                    ),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Nome ou C?digo de Barras',
                    labelStyle: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 12,
                        mobileFontSize: 11,
                        tabletFontSize: 11.5,
                      ),
                    ),
                    hintText: 'Digite para buscar...',
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                      vertical: AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    isDense: true,
                  ),
                  onSubmitted: (_) => _buscarProduto(),
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.qr_code_scanner_rounded,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.qr_code_scanner_rounded,
                              color: ThemeColors.of(context).surface,
                              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                            ),
                            SizedBox(
                              width: AppSizes.spacingBase.get(isMobile, isTablet),
                            ),
                            const Text('Escaneando c?digo de barras...'),
                          ],
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isMobile ? 10 : 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: ResponsiveHelper.getResponsiveSpacing(
                  context,
                  mobile: 7,
                  tablet: 7.5,
                  desktop: 8,
                ),
              ),
              Flexible(
                child: ElevatedButton.icon(
                  onPressed: _buscarProduto,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ThemeColors.of(context).surface,
                          ),
                        )
                      : Icon(
                          Icons.search_rounded,
                          size: ResponsiveHelper.getResponsiveIconSize(
                            context,
                            mobile: 17,
                            tablet: 17.5,
                            desktop: 18,
                          ),
                        ),
                  label: Text(
                    'Buscar',
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
                      horizontal: AppSizes.paddingLgAlt.get(isMobile, isTablet),
                      vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                    ),
                    backgroundColor: ThemeColors.of(context).primary,
                    foregroundColor: ThemeColors.of(context).surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProdutoCard() {
    final produto = _produtoSelecionado!;

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXl.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).cyanMainLight],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 18 : (isTablet ? 19 : 20),
        ),
        border: Border.all(color: ThemeColors.of(context).infoLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.check_rounded, color: ThemeColors.of(context).info, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produto.nome,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      produto.codigo ?? produto.id,
                      style: TextStyle(
                        fontSize: 13,
                        color: ThemeColors.of(context).textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoChip('Categoria', produto.categoria, ThemeColors.of(context).blueCyan),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoChip(
                  'Pre?o Atual',
                  'R\$ ${produto.precoAtual.toStringAsFixed(2)}',
                  ThemeColors.of(context).success,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoChip(
                  'Custo',
                  'R\$ ${produto.custo.toStringAsFixed(2)}',
                  ThemeColors.of(context).orangeMaterial,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorLight),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildNovoPrecoCard() {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingXl.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: 10,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).primaryPastel, ThemeColors.of(context).yellowGold],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Novo Pre?o',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _novoPrecoController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: 'Novo Pre?o',
              prefixText: 'R\$ ',
              prefixIcon: const Icon(Icons.monetization_on_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _motivoController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Motivo do ajuste (opcional)',
              prefixIcon: const Icon(Icons.notes_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _aplicarNovoPreco,
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text('Aplicar Novo Pre?o'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.of(context).success,
                foregroundColor: ThemeColors.of(context).surface,
                padding: const EdgeInsets.symmetric(vertical: 14),
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

  Widget _buildHistoricoCard() {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingXl.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: 10,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Hist?rico de Pre?os',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_historico.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Nenhum hist?rico dispon?vel',
                  style: TextStyle(color: ThemeColors.of(context).textSecondary),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _historico.length,
              separatorBuilder: (_, __) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final item = _historico[index];
                return _buildHistoricoItem(item);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHistoricoItem(PriceHistoryEntry item) {
    final isAumento = item.previousPrice != null && item.price > item.previousPrice!;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isAumento ? ThemeColors.of(context).success : ThemeColors.of(context).error)Light,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isAumento ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            color: isAumento ? ThemeColors.of(context).success : ThemeColors.of(context).error,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'R\$ ${item.previousPrice?.toStringAsFixed(2) ?? "0.00"} ? R\$ ${item.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.reason ?? 'Altera??o de pre?o',
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _buscarProduto() {
    final termo = _buscaController.text.trim();
    if (termo.isNotEmpty) {
      ref.read(individualAdjustmentProvider.notifier).buscarProduto(termo);
    }
  }

  void _aplicarNovoPreco() {
    final novoPreco = double.tryParse(_novoPrecoController.text);
    if (novoPreco != null && _produtoSelecionado != null) {
      ref.read(individualAdjustmentProvider.notifier).aplicarNovoPreco(
        _produtoSelecionado!.id,
        novoPreco,
        _motivoController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
              const SizedBox(width: 12),
              Text('Pre?o de ${_produtoSelecionado!.nome} atualizado!'),
            ],
          ),
          backgroundColor: ThemeColors.of(context).success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      _novoPrecoController.clear();
      _motivoController.clear();
    }
  }
}










