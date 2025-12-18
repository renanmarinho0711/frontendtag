import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/import_export/presentation/providers/import_export_provider.dart';
import 'package:tagbean/features/import_export/data/models/import_export_models.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';

class ExportacaoTagsScreen extends ConsumerStatefulWidget {
  const ExportacaoTagsScreen({super.key});

  @override
  ConsumerState<ExportacaoTagsScreen> createState() => _ExportacaoTagsScreenState();
}

class _ExportacaoTagsScreenState extends ConsumerState<ExportacaoTagsScreen> with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  
  // Acesso ao provider
  ExportTagsState get _state => ref.watch(exportTagsProvider);
  ExportTagsNotifier get _notifier => ref.read(exportTagsProvider.notifier);
  
  // Getters para compatibilidade
  String get _formatoSelecionado => _state.config.format.id;
  String get _filtroStatus => _state.config.filterStatus.id;
  bool get _incluirLocalizacao => _state.config.includeLocation;
  bool get _incluirProdutos => _state.config.includeProducts;
  bool get _incluirMetricas => _state.config.includeMetrics;
  bool get _incluirHistorico => _state.config.includeHistory;

  Map<String, Map<String, dynamic>> _getFormatos(BuildContext context) => {
    'excel': {
      'nome': 'Microsoft Excel',
      'subtitulo': 'Planilha completa (.xlsx)',
      'icone': Icons.table_chart_rounded,
      'cor': ThemeColors.of(context).greenDark,
      'extensao': '.xlsx',
    },
    'csv': {
      'nome': 'CSV',
      'subtitulo': 'Dados separados (.csv)',
      'icone': Icons.article_rounded,
      'cor': ThemeColors.of(context).primary,
      'extensao': '.csv',
    },
    'json': {
      'nome': 'JSON',
      'subtitulo': 'Formato API (.json)',
      'icone': Icons.code_rounded,
      'cor': ThemeColors.of(context).orangeDeep,
      'extensao': '.json',
    },
  };

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
    super.dispose();
  }

  // Total de tags via provider
  int get _totalTags => _state.tagCount;

  int get _totalColunas {
    int colunas = 4;
    if (_incluirLocalizacao) colunas += 2;
    if (_incluirProdutos) colunas += 3;
    if (_incluirMetricas) colunas += 4;
    if (_incluirHistorico) colunas += 2;
    return colunas;
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
                      _buildStatusOverview(),
                      ResponsiveSpacing.verticalMedium(context),
                      _buildFormatSelector(),
                      ResponsiveSpacing.verticalMedium(context),
                      _buildFilterCard(),
                      ResponsiveSpacing.verticalMedium(context),
                      _buildOptionsCard(),
                      ResponsiveSpacing.verticalMedium(context),
                      _buildPreviewCard(),
                      ResponsiveSpacing.verticalMedium(context),
                      _buildSummaryCard(),
                      SizedBox(
                        height: AppSizes.spacing3Xl.get(isMobile, isTablet),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
      floatingActionButton: _buildExportFAB(),
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
              borderRadius: BorderRadius.circular(isMobile ? 9 : 10),
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
                colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueMain],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 12 : (isTablet ? 13 : 14),
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).primary.withValues(alpha: 0.3),
                  blurRadius: isMobile ?  10 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.download_for_offline_rounded,
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
                  'Exportar Tags',
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
                  'Relatãrio Completo de ESLs',
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
          if (! isMobile || ResponsiveHelper.isLandscape(context))
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
                color: ThemeColors.of(context).successPastel,
                borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                border: Border.all(color: ThemeColors.of(context).success),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sell_rounded,
                    size: AppSizes.iconTiny.get(isMobile, isTablet),
                    color: ThemeColors.of(context).successIcon,
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
                    '1.248',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 12,
                        mobileFontSize: 11,
                        tabletFontSize: 11.5,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.of(context).success.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusOverview() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return isMobile
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusMiniCard('Online', '1.220', Icons.wifi_rounded, ThemeColors.of(context).success),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: _buildStatusMiniCard('Associadas', '1.127', Icons.link_rounded, ThemeColors.of(context).primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatusMiniCard('Offline', '28', Icons.wifi_off_rounded, ThemeColors.of(context).error),
                  ),
                ],
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _buildStatusMiniCard('Online', '1.220', Icons.wifi_rounded, ThemeColors.of(context).success),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusMiniCard('Associadas', '1.127', Icons.link_rounded, ThemeColors.of(context).primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusMiniCard('Offline', '28', Icons.wifi_off_rounded, ThemeColors.of(context).error),
              ),
            ],
          );
  }

  Widget _buildStatusMiniCard(String label, String value, IconData icon, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingMdAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: isMobile ? 12 : 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: AppSizes.iconLargeFloat.get(isMobile, isTablet),
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
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 20,
                mobileFontSize: 18,
                tabletFontSize: 19,
              ),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: -0.8,
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 3,
              tablet: 3.5,
              desktop: 4,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 11,
                mobileFontSize: 10,
                tabletFontSize: 10.5,
              ),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondaryOverlay70,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFormatSelector() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
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
                  ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 9,
                    tablet: 9.5,
                    desktop: 10,
                  ),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).primaryPastel,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.description_rounded,
                  color: ThemeColors.of(context).primaryDark,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Formato de ExportAção',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 17,
                      mobileFontSize: 15,
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
          ResponsiveSpacing.verticalMedium(context),
          isMobile && !ResponsiveHelper.isLandscape(context)
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _getFormatos(context).entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildFormatOption(entry.key, entry.value),
                    );
                  }).toList(),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _getFormatos(context).entries.map((entry) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _buildFormatOption(entry.key, entry.value),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildFormatOption(String key, Map<String, dynamic> formato) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isSelected = _formatoSelecionado == key;

    return InkWell(
      onTap: () => _notifier.setFormat(_parseFormat(key)),
      borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(
          AppSizes.paddingMdAlt.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (formato['cor'] as Color).withValues(alpha: 0.1)
              : ThemeColors.of(context).textSecondary,
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
          border: Border.all(
            // ignore: argument_type_not_assignable
            color: isSelected ? formato['cor'] : ThemeColors.of(context).textSecondaryOverlay40,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              // ignore: argument_type_not_assignable
              formato['icone'],
              // ignore: argument_type_not_assignable
              color: isSelected ? formato['cor'] : ThemeColors.of(context).textSecondary,
              size: AppSizes.iconExtraLarge.get(isMobile, isTablet),
            ),
            SizedBox(
              height: AppSizes.spacingSmAlt.get(isMobile, isTablet),
            ),
            Text(
              (formato['nome']).toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 12,
                  mobileFontSize: 11,
                  tabletFontSize: 11.5,
                ),
                fontWeight: FontWeight.bold,
                // ignore: argument_type_not_assignable
                color: isSelected ?  formato['cor'] : ThemeColors.of(context).textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 3,
                tablet: 3.5,
                desktop: 4,
              ),
            ),
            Text(
              (formato['subtitulo']).toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 10,
                  mobileFontSize: 9,
                  tabletFontSize: 9.5,
                ),
                color: ThemeColors.of(context).textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
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
                  ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 9,
                    tablet: 9.5,
                    desktop: 10,
                  ),
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
                  'Filtrar por Status',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 17,
                      mobileFontSize: 15,
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
          ResponsiveSpacing.verticalMedium(context),
          Wrap(
            spacing: AppSizes.spacingSmAlt.get(isMobile, isTablet),
            runSpacing: AppSizes.spacingSmAlt.get(isMobile, isTablet),
            children: [
              _buildFilterChip('todas', 'Todas (1.248)', Icons.grid_view_rounded),
              _buildFilterChip('associadas', 'Associadas (1.127)', Icons.link_rounded),
              _buildFilterChip('disponiveis', 'Disponíveis (121)', Icons.check_circle_rounded),
              _buildFilterChip('offline', 'Offline (28)', Icons.wifi_off_rounded),
            ],
          ),
        ],
      ),
    );
  }

  ExportFormat _parseFormat(String key) {
    switch (key) {
      case 'csv': return ExportFormat.csv;
      case 'json': return ExportFormat.json;
      default: return ExportFormat.excel;
    }
  }

  FilterStatus _parseFilter(String value) {
    switch (value) {
      case 'associadas': return FilterStatus.associated;
      case 'disponiveis': return FilterStatus.available;
      case 'offline': return FilterStatus.offline;
      default: return FilterStatus.all;
    }
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isSelected = _filtroStatus == value;

    return InkWell(
      onTap: () => _notifier.setFilter(_parseFilter(value)),
      borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSm.get(isMobile, isTablet),
          vertical: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 9,
            tablet: 9.5,
            desktop: 10,
          ),
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueMain])
              : null,
          color: isSelected ? null : ThemeColors.of(context).textSecondary,
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
          border: Border.all(
            color: isSelected ? ThemeColors.of(context).transparent : ThemeColors.of(context).textSecondary,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 15,
                tablet: 15.5,
                desktop: 16,
              ),
              color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
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
                  baseFontSize: 12,
                  mobileFontSize: 11,
                  tabletFontSize: 11.5,
                ),
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

  Widget _buildOptionsCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
            blurRadius: isMobile ?  15 : 20,
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
                  ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 9,
                    tablet: 9.5,
                    desktop: 10,
                  ),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).warningPastel,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: ThemeColors.of(context).warningDark,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Dados a Incluir',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 17,
                      mobileFontSize: 15,
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
          ResponsiveSpacing.verticalMedium(context),
          _buildOptionSwitch(
            'LocalizAção Fãsica',
            'Corredor, prateleira e posição',
            _incluirLocalizacao,
            Icons.location_on_rounded,
            (value) => _notifier.toggleIncludeLocation(),
          ),
          SizedBox(
            height: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          _buildOptionSwitch(
            'Produtos Associados',
            'Nome, código e preço do produto',
            _incluirProdutos,
            Icons.inventory_2_rounded,
            (value) => _notifier.toggleIncludeProducts(),
          ),
          SizedBox(
            height: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          _buildOptionSwitch(
            'Mãtricas de Performance',
            'Bateria, sinal, uptime e atualizações',
            _incluirMetricas,
            Icons.analytics_rounded,
            (value) => _notifier.toggleIncludeMetrics(),
          ),
          SizedBox(
            height: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          _buildOptionSwitch(
            'Histórico de Atividades',
            'Última atualizAção e eventos',
            _incluirHistorico,
            Icons.history_rounded,
            (value) => _notifier.toggleIncludeHistory(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionSwitch(
    String title,
    String subtitle,
    bool value,
    IconData icon,
    Function(bool) onChanged,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingSm.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: value ? ThemeColors.of(context).primaryPastel : ThemeColors.of(context).textSecondary,
        borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        border: Border.all(
          color: value ? ThemeColors.of(context).primaryLight : ThemeColors.of(context).textSecondary,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: ResponsiveHelper.getResponsiveIconSize(
              context,
              mobile: 19,
              tablet: 19.5,
              desktop: 20,
            ),
            color: value ? ThemeColors.of(context).primaryDark : ThemeColors.of(context).textSecondary,
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
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                      tabletFontSize: 12.5,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: value ? ThemeColors.of(context).primaryDark : ThemeColors.of(context).textSecondary,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveSpacing(
                    context,
                    mobile: 1.5,
                    tablet: 1.75,
                    desktop: 2,
                  ),
                ),
                Text(
                  subtitle,
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
          Transform.scale(
            scale: isMobile ? 0.8 : 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: ThemeColors.of(context).primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).cyanMain.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
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
                Icons.preview_rounded,
                size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                color: ThemeColors.of(context).infoDark,
              ),
              SizedBox(
                width: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 9,
                  tablet: 9.5,
                  desktop: 10,
                ),
              ),
              Text(
                'Preview das Colunas',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 14,
                    tabletFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).primary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.spacingSm.get(isMobile, isTablet),
          ),
          Wrap(
            spacing: ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 7,
              tablet: 7.5,
              desktop: 8,
            ),
            runSpacing: ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 7,
              tablet: 7.5,
              desktop: 8,
            ),
            children: [
              _buildColumnChip('ID Tag'),
              _buildColumnChip('Status'),
              _buildColumnChip('Bateria'),
              _buildColumnChip('Sinal WiFi'),
              if (_incluirLocalizacao) ...[
                _buildColumnChip('Corredor'),
                _buildColumnChip('Prateleira'),
              ],
              if (_incluirProdutos) ...[
                _buildColumnChip('Produto'),
                _buildColumnChip('Cãdigo'),
                _buildColumnChip('PREÇO'),
              ],
              if (_incluirMetricas) ...[
                _buildColumnChip('Uptime'),
                _buildColumnChip('Updates'),
                _buildColumnChip('Erros'),
                _buildColumnChip('Latãncia'),
              ],
              if (_incluirHistorico) ...[
                _buildColumnChip('Última AtualizAção'),
                _buildColumnChip('Eventos'),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumnChip(String label) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
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
        color: ThemeColors.of(context).infoLight,
        borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
        border: Border.all(color: ThemeColors.of(context).info),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            baseFontSize: 11,
            mobileFontSize: 10,
            tabletFontSize: 10.5,
          ),
        overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold,
          color: ThemeColors.of(context).infoDark,
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final formato = _getFormatos(context)[_formatoSelecionado]!;
    final tamanhoEstimado = (_totalTags * 0.015 * _totalColunas / 4).toStringAsFixed(1);
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).infoModuleBackground, ThemeColors.of(context).infoModuleBackgroundAlt],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        border: Border.all(color: ThemeColors.of(context).primaryLight),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.summarize_rounded,
                size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                color: ThemeColors.of(context).primaryDark,
              ),
              SizedBox(
                width: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 9,
                  tablet: 9.5,
                  desktop: 10,
                ),
              ),
              Text(
                'Resumo da ExportAção',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 14,
                    tabletFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.spacingSm.get(isMobile, isTablet),
          ),
          _buildSummaryRow('Formato', (formato['nome']).toString()),
          _buildSummaryRow('Total de Tags', '$_totalTags'),
          _buildSummaryRow('Colunas', '$_totalColunas campos'),
          _buildSummaryRow('Tamanho estimado', '~$tamanhoEstimado MB'),
          _buildSummaryRow('Nome do arquivo', 'tags_export_$timestamp${formato['extensao']}'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveHelper.getResponsiveSpacing(
          context,
          mobile: 7,
          tablet: 7.5,
          desktop: 8,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12.5,
                ),
              overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12.5,
                ),
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportFAB() {
    final formato = _getFormatos(context)[_formatoSelecionado]!;
    final isMobile = ResponsiveHelper.isMobile(context);

    return FloatingActionButton.extended(
      onPressed: _executarExportacao,
      // ignore: argument_type_not_assignable
      backgroundColor: formato['cor'],
      icon: Icon(
        Icons.file_download_rounded,
        size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
      ),
      label: Text(
        'Exportar $_totalTags Tags',
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
    );
  }

  void _executarExportacao() async {
    final formato = _getFormatos(context)[_formatoSelecionado]!;
    final isMobile = ResponsiveHelper.isMobile(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text('Gerando arquivo ${formato['nome']}...')),
          ],
        ),
        // ignore: argument_type_not_assignable
        backgroundColor: formato['cor'],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    // Executar exportAção real via provider
    final workContext = ref.read(workContextProvider);
    final storeId = workContext.context.currentStoreId ?? '';
    await _notifier.exportTags(storeId);
    
    final success = _state.result != null && _state.errorMessage == null;

    if (mounted) {
      Navigator.pop(context);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    _state.result != null 
                        ? 'ExportAção Concluída: ${_state.result!.recordCount} tags'
                        : 'Tags exportadas com sucesso!',
                  ),
                ),
              ],
            ),
            backgroundColor: ThemeColors.of(context).successIcon,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_state.errorMessage ?? 'Erro ao exportar tags'),
            backgroundColor: ThemeColors.of(context).errorIcon,
          ),
        );
      }
    }
  }
}









