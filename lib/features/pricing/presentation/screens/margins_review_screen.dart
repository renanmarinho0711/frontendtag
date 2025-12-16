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

class PrecificacaoRevisaoMargensScreen extends ConsumerStatefulWidget {
  const PrecificacaoRevisaoMargensScreen({super.key});

  @override
  ConsumerState<PrecificacaoRevisaoMargensScreen> createState() => _PrecificacaoRevisaoMargensScreenState();
}

class _PrecificacaoRevisaoMargensScreenState extends ConsumerState<PrecificacaoRevisaoMargensScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;

  // Getters conectados ao Provider
  MarginReviewState get _marginState => ref.watch(marginReviewProvider);
  List<MarginReviewModel> get _items => _marginState.items;
  List<MarginReviewModel> get _filteredItems => _marginState.filteredItems;
  String get _filterStatus => _marginState.filterStatus;
  bool get _isLoading => _marginState.status == LoadingStatus.loading;

  int get _negativas => _items.where((p) => p.status == 'critico').length;
  int get _baixas => _items.where((p) => p.status == 'atencao').length;
  int get _normais => _items.where((p) => p.status == 'saudavel').length;
  int get _altas => _items.where((p) => p.margemAtual >= p.margemIdeal).length;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(marginReviewProvider.notifier).loadMargins();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildModernAppBar(),
                  _buildStatsCard(),
                  _buildFilterCard(),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        return _buildProdutoCard(_filteredItems[index], index);
                      },
                    ),
                  ),
                  _buildDicasCard(),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _exportarrelatÃ³rio,
        icon: Icon(Icons.file_download_rounded, size: AppSizes.iconMediumAlt.get(isMobile, isTablet)),
        label: Text(
          'Exportar',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
          ),
        ),
        backgroundColor: ThemeColors.of(context).primary,
      ),
    );
  }

  void _exportarrelatÃ³rio() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMediumSmall.get(isMobile, isTablet)),
            SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
            const Text('Exportando relat�rio...'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
      ),
    );
  }

  Widget _buildModernAppBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingLgAlt.get(isMobile, isTablet),
        vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 18 : (isTablet ? 19 : 20)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(context, mobile: 16, tablet: 18, desktop: 20),
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
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
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
          SizedBox(width: AppSizes.spacingMdAlt.get(isMobile, isTablet)),
          Container(
            padding: EdgeInsets.all(
              ResponsiveHelper.getResponsivePadding(context, mobile: 9, tablet: 9.5, desktop: 10),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).primary, ThemeColors.of(context).info],
              ),
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
            ),
            child: Icon(
              Icons.trending_up_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
            ),
          ),
          SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revis�o de Margens',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'An�lise de rentabilidade',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
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

  Widget _buildStatsCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      padding: EdgeInsets.all(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).infoModuleBackground, ThemeColors.of(context).infoModuleBackgroundAlt],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 18 : (isTablet ? 19 : 20)),
        border: Border.all(color: ThemeColors.of(context).blueCyanLight, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: _buildStatItem('Negativa', '$_negativas', Icons.trending_down_rounded, ThemeColors.of(context).error)),
          Container(
            width: 1,
            height: ResponsiveHelper.getResponsiveHeight(context, mobile: 36, tablet: 38, desktop: 40),
            color: ThemeColors.of(context).blueCyan,
          ),
          Expanded(child: _buildStatItem('Baixa', '$_baixas', Icons.warning_rounded, ThemeColors.of(context).orangeMaterial)),
          Container(
            width: 1,
            height: ResponsiveHelper.getResponsiveHeight(context, mobile: 36, tablet: 38, desktop: 40),
            color: ThemeColors.of(context).blueCyan,
          ),
          Expanded(child: _buildStatItem('Normal', '$_normais', Icons.check_circle_rounded, ThemeColors.of(context).success)),
          Container(
            width: 1,
            height: ResponsiveHelper.getResponsiveHeight(context, mobile: 36, tablet: 38, desktop: 40),
            color: ThemeColors.of(context).blueCyan,
          ),
          Expanded(child: _buildStatItem('Alta', '$_altas', Icons.trending_up_rounded, ThemeColors.of(context).blueCyan)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSizes.iconMediumLarge.get(isMobile, isTablet)),
        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6)),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 22, mobileFontSize: 19, tabletFontSize: 20.5),
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9, tabletFontSize: 9.5),
            overflow: TextOverflow.ellipsis,
            color: ThemeColors.of(context).textSecondaryOverlay80,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.fromLTRB(
        AppSizes.paddingMdAlt.get(isMobile, isTablet),
        AppSizes.paddingMdAlt.get(isMobile, isTablet),
        AppSizes.paddingMdAlt.get(isMobile, isTablet),
        0,
      ),
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
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(context, mobile: 8, tablet: 9, desktop: 10),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.filter_list_rounded, size: AppSizes.iconMediumSmall.get(isMobile, isTablet), color: ThemeColors.of(context).textSecondary),
          SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
          Text(
            'Filtrar por:',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _filterStatus,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                color: ThemeColors.of(context).textPrimary,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(isMobile ? 8 : 10)),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                  vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 7, tablet: 7.5, desktop: 8),
                ),
                isDense: true,
              ),
              items: ['Todos', 'critico', 'atencao', 'saudavel']
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e == 'critico' ? 'Negativa' : e == 'atencao' ? 'Baixa' : e == 'saudavel' ? 'Normal' : e),
                      ))
                  .toList(),
              onChanged: (value) {
                ref.read(marginReviewProvider.notifier).setFilterStatus(value!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProdutoCard(MarginReviewModel item, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.spacingBase.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(isMobile ? 18 : (isTablet ? 19 : 20)),
          border: Border.all(color: item.statusColorLight, width: 2),
          boxShadow: [
            BoxShadow(
              color: item.statusColorLight,
              blurRadius: ResponsiveHelper.getResponsiveBlurRadius(context, mobile: 16, tablet: 18, desktop: 20),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: ThemeColors.of(context).transparent,
          child: InkWell(
            onTap: () => _mostrarDialogoAjuste(item),
            borderRadius: BorderRadius.circular(isMobile ? 18 : (isTablet ? 19 : 20)),
            child: Padding(
              padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [item.statusColor, item.statusColor.withValues(alpha: 0.7)]),
                          borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                        ),
                        child: Icon(
                          item.status == 'critico' ? Icons.error_rounded : item.status == 'atencao' ? Icons.warning_rounded : Icons.check_circle_rounded,
                          color: ThemeColors.of(context).surface,
                          size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
                        ),
                      ),
                      SizedBox(width: AppSizes.spacingMdAlt.get(isMobile, isTablet)),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.nome,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14.5),
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 5, tablet: 5.5, desktop: 6),
                                    vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 2, tablet: 2.5, desktop: 2),
                                  ),
                                  decoration: BoxDecoration(
                                    color: ThemeColors.of(context).infoLight,
                                    borderRadius: BorderRadius.circular(isMobile ? 3 : 4),
                                  ),
                                  child: Text(
                                    item.categoria,
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 9, mobileFontSize: 8, tabletFontSize: 8.5),
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w600,
                                      color: ThemeColors.of(context).infoDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                          vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 7, tablet: 7.5, desktop: 8),
                        ),
                        decoration: BoxDecoration(
                          color: item.statusColorLight,
                          borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                          border: Border.all(color: item.statusColorLight),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${item.margemAtual.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: item.statusColor,
                              ),
                            ),
                            Text(
                              item.status == 'critico' ? 'Negativa' : item.status == 'atencao' ? 'Baixa' : 'Normal',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 9, mobileFontSize: 8, tabletFontSize: 8.5),
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w600,
                                color: item.statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spacingMdAlt.get(isMobile, isTablet)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: _buildInfoBox('Custo', 'R\$ ${item.custoCompra.toStringAsFixed(2)}', ThemeColors.of(context).error)),
                      SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
                      Expanded(child: _buildInfoBox('Venda', 'R\$ ${item.precoVenda.toStringAsFixed(2)}', ThemeColors.of(context).primary)),
                      SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
                      Expanded(child: _buildInfoBox('Lucro', 'R\$ ${(item.precoVenda - item.custoCompra).toStringAsFixed(2)}', item.statusColor)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String label, String value, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context, mobile: 9, tablet: 9.5, desktop: 10)),
      decoration: BoxDecoration(
        color: colorLight,
        borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
        border: Border.all(color: colorLight),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9, tabletFontSize: 9.5),
              overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDicasCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).cyanMainLight]),
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
        border: Border.all(color: ThemeColors.of(context).infoLight),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tips_and_updates_rounded,
                size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 17, tablet: 17.5, desktop: 18),
                color: ThemeColors.of(context).infoDark,
              ),
              SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
              Text(
                'Dicas de An�lise de Margens',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).infoDark,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
          _buildDicaItem('Margens negativas indicam preju�zo - ajuste urgente'),
          _buildDicaItem('Margens baixas (<10%) podem n�o cobrir despesas'),
          _buildDicaItem('Margens altas podem ser oportunidade para promo��es'),
        ],
      ),
    );
  }

  Widget _buildDicaItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.getResponsivePadding(context, mobile: 3, tablet: 3.5, desktop: 4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_right_rounded,
            size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 13, tablet: 13.5, desktop: 14),
            color: ThemeColors.of(context).infoDark,
          ),
          SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10.5),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoAjuste(MarginReviewModel item) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final novoPrecoController = TextEditingController(text: item.precoVenda.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 18 : 20)),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.status == 'critico' ? Icons.error_rounded : item.status == 'atencao' ? Icons.warning_rounded : Icons.check_circle_rounded,
              color: item.statusColor,
              size: AppSizes.iconLargeAlt.get(isMobile, isTablet),
            ),
            SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
            Expanded(
              child: Text(
                'Ajustar Pre�o',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
                  overflow: TextOverflow.ellipsis,
                  color: item.statusColor,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.nome,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15, tabletFontSize: 15.5),
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSizes.spacingMdAlt.get(isMobile, isTablet)),
              Container(
                padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).textSecondaryOverlay10,
                  borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                  border: Border.all(color: ThemeColors.of(context).textSecondaryOverlay30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Situa��o Atual:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5))),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
                    _buildInfoRow('Custo', 'R\$ ${item.custoCompra.toStringAsFixed(2)}'),
                    _buildInfoRow('Venda', 'R\$ ${item.precoVenda.toStringAsFixed(2)}'),
                    _buildInfoRow('Margem', '${item.margemAtual.toStringAsFixed(1)}% (R\$ ${(item.precoVenda - item.custoCompra).toStringAsFixed(2)})'),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
                    if (item.sugestao != null)
                      Container(
                        padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context, mobile: 7, tablet: 7.5, desktop: 8)),
                        decoration: BoxDecoration(
                          color: item.statusColorLight,
                          borderRadius: BorderRadius.circular(isMobile ? 7 : 8),
                        ),
                        child: Text(
                          item.sugestao!,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
                            color: item.statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.spacingMdAlt.get(isMobile, isTablet)),
              TextFormField(
                controller: novoPrecoController,
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5)),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Novo Pre�o de Venda',
                  labelStyle: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5)),
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                    vertical: AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  isDense: true,
                ),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancelar',
              style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final novoPreco = double.tryParse(novoPrecoController.text) ?? item.precoVenda;
              await ref.read(marginReviewProvider.notifier).ajustarPrecoProduto(item.id, novoPreco);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMediumSmall.get(isMobile, isTablet)),
                        SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
                        Expanded(child: Text('Pre�o de ${item.nome} atualizado!')),
                      ],
                    ),
                    backgroundColor: ThemeColors.of(context).success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: item.statusColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
            ),
            child: Text(
              'Salvar',
              style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.getResponsivePadding(context, mobile: 3, tablet: 3.5, desktop: 4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}








