import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/features/sync/presentation/providers/sync_provider.dart';
import 'package:tagbean/features/sync/data/models/sync_models.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:tagbean/core/utils/web_utils.dart';

class SincronizacaoLogScreen extends ConsumerStatefulWidget {
  const SincronizacaoLogScreen({super.key});

  @override
  ConsumerState<SincronizacaoLogScreen> createState() => _SincronizacaoLogScreenState();
}

class _SincronizacaoLogScreenState extends ConsumerState<SincronizacaoLogScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  String _filtroStatus = 'Todos';
  String _filtroTipo = 'Todos';
  final _dataController = TextEditingController();
  
  // Cache de logs filtrados
  List<SyncHistoryEntry>? _cachedLogsFiltrados;
  String _lastFiltroStatus = 'Todos';
  String _lastFiltroTipo = 'Todos';

  // Obt�m logs do provider
  List<SyncHistoryEntry> get _logs => ref.watch(syncHistoryProvider);

  // Getter com cache para logs filtrados
  List<SyncHistoryEntry> get _logsFiltrados {
    if (_cachedLogsFiltrados != null &&
        _lastFiltroStatus == _filtroStatus &&
        _lastFiltroTipo == _filtroTipo) {
      return _cachedLogsFiltrados!;
    }
    
    _lastFiltroStatus = _filtroStatus;
    _lastFiltroTipo = _filtroTipo;
    
    _cachedLogsFiltrados = _logs.where((log) {
      final statusMatch = _filtroStatus == 'Todos' || log.status.label == _filtroStatus;
      final tipoMatch = _filtroTipo == 'Todos' || log.type.label == _filtroTipo;
      return statusMatch && tipoMatch;
    }).toList();
    
    return _cachedLogsFiltrados!;
  }

  @override
  void initState() {
    super.initState();
    initResponsiveCache();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModernAppBar(),
            _buildStatsHeader(),
            _buildFilterBar(),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(
                  AppSizes.cardPadding.get(isMobile, isTablet),
                ),
                itemCount: _logsFiltrados.length,
                itemBuilder: (context, index) {
                  return _buildLogCard(_logsFiltrados[index], index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _exportarLog,
        icon: Icon(
          Icons.download_rounded,
          size: AppSizes.iconMedium.get(isMobile, isTablet),
        ),
        label: Text(
          'Exportar',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
            ),
          overflow: TextOverflow.ellipsis,
          ),
        ),
        backgroundColor: ThemeColors.of(context).primary,
      ),
    );
  }

  Widget _buildModernAppBar() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
        vertical: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 15,
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
              color: ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getResponsiveBorderRadius(
                  context,
                  mobile: 10,
                  tablet: 11,
                  desktop: 12,
                ),
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textSecondary,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(
            width: AppSizes.spacingMd.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingSmAlt.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).textSecondary, ThemeColors.of(context).textPrimary],
              ),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getResponsiveBorderRadius(
                  context,
                  mobile: 10,
                  tablet: 11,
                  desktop: 12,
                ),
              ),
            ),
            child: Icon(
              Icons.history_rounded,
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
                  'Log de Sincroniza��o',
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
                  'Hist�rico detalhado',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
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

  Widget _buildStatsHeader() {
    final sucesso = _logs.where((l) => l.status == SyncStatus.success).length;
    final parcial = _logs.where((l) => l.status == SyncStatus.partial).length;
    final falha = _logs.where((l) => l.status == SyncStatus.failed).length;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      margin: EdgeInsets.fromLTRB(
        AppSizes.paddingMd.get(isMobile, isTablet),
        0,
        AppSizes.paddingMd.get(isMobile, isTablet),
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 15,
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
          Expanded(
            child: _buildStatItem('$sucesso', 'Sucesso', Icons.check_circle_rounded, ThemeColors.of(context).success),
          ),
          Container(
            width: 1,
            height: isMobile ? 45 : 50,
            color: ThemeColors.of(context).textSecondary,
          ),
          Expanded(
            child: _buildStatItem('$parcial', 'Parcial', Icons.warning_rounded, ThemeColors.of(context).orangeMaterial),
          ),
          Container(
            width: 1,
            height: isMobile ? 45 : 50,
            color: ThemeColors.of(context).textSecondary,
          ),
          Expanded(
            child: _buildStatItem('$falha', 'Falha', Icons.error_rounded, ThemeColors.of(context).error),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
        ),
        SizedBox(
          height: AppSizes.spacingXsAlt2.get(isMobile, isTablet),
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
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 10,
              mobileFontSize: 9,
            ),
          overflow: TextOverflow.ellipsis,
            color: ThemeColors.of(context).textSecondaryOverlay70,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      margin: EdgeInsets.fromLTRB(
        AppSizes.paddingMd.get(isMobile, isTablet),
        0,
        AppSizes.paddingMd.get(isMobile, isTablet),
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingMdAlt2.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 14,
            tablet: 16,
            desktop: 16,
          ),
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
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.filter_list_rounded,
                size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                color: ThemeColors.of(context).textSecondary,
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Text(
                'Filtros',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _dataController,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                    ),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Data',
                    labelStyle: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.calendar_today_rounded,
                      size: AppSizes.iconSmall.get(isMobile, isTablet),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getResponsiveBorderRadius(
                          context,
                          mobile: 8,
                          tablet: 9,
                          desktop: 10,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                      vertical: AppSizes.paddingXs.get(isMobile, isTablet),
                    ),
                    isDense: true,
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      _dataController.text = '${date.day}/${date.month}/${date.year}';
                    }
                  },
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filtroStatus,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                    ),
                    color: ThemeColors.of(context).textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.info_rounded,
                      size: AppSizes.iconSmall.get(isMobile, isTablet),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getResponsiveBorderRadius(
                          context,
                          mobile: 8,
                          tablet: 9,
                          desktop: 10,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                      vertical: AppSizes.paddingXs.get(isMobile, isTablet),
                    ),
                    isDense: true,
                  ),
                  items: ['Todos', 'Sucesso', 'Parcial', 'Falha']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _filtroStatus = value!;
                      _cachedLogsFiltrados = null;
                    });
                  },
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filtroTipo,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                    ),
                    color: ThemeColors.of(context).textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Tipo',
                    labelStyle: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.category_rounded,
                      size: AppSizes.iconSmall.get(isMobile, isTablet),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getResponsiveBorderRadius(
                          context,
                          mobile: 8,
                          tablet: 9,
                          desktop: 10,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                      vertical: AppSizes.paddingXs.get(isMobile, isTablet),
                    ),
                    isDense: true,
                  ),
                  items: ['Todos', 'Completa', 'Pre�os', 'Produtos Novos', 'Tags']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _filtroTipo = value!;
                      _cachedLogsFiltrados = null;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(SyncHistoryEntry log, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final logColor = log.color;
    final logIcon = log.iconData;

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
        margin: EdgeInsets.only(
          bottom: AppSizes.spacingBase.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getResponsiveBorderRadius(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),
          border: Border.all(
            color: logColor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: logColor.withValues(alpha: 0.1),
              blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
                context,
                mobile: 15,
                tablet: 18,
                desktop: 20,
              ),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: ThemeColors.of(context).transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.all(
              AppSizes.paddingMdAlt.get(isMobile, isTablet),
            ),
            childrenPadding: EdgeInsets.fromLTRB(
              AppSizes.paddingMdAlt.get(isMobile, isTablet),
              0,
              AppSizes.paddingMdAlt.get(isMobile, isTablet),
              AppSizes.paddingMdAlt.get(isMobile, isTablet),
            ),
            leading: Container(
              width: isMobile ? 50 : 56,
              height: isMobile ? 50 : 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [logColor, logColor.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getResponsiveBorderRadius(
                    context,
                    mobile: 12,
                    tablet: 13,
                    desktop: 14,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: logColor.withValues(alpha: 0.3),
                    blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
                      context,
                      mobile: 10,
                      tablet: 11,
                      desktop: 12,
                    ),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                logIcon,
                color: ThemeColors.of(context).surface,
                size: AppSizes.iconLarge.get(isMobile, isTablet),
              ),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    '${log.type.label} - ${log.status.label}',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 15,
                        mobileFontSize: 14,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
                    vertical: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 3,
                      tablet: 3,
                      desktop: 4,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: logColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getResponsiveBorderRadius(
                        context,
                        mobile: 5,
                        tablet: 5,
                        desktop: 6,
                      ),
                    ),
                  ),
                  child: Text(
                    '#${log.id}',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 10,
                        mobileFontSize: 9,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: logColor,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: AppSizes.spacingXsAlt2.get(isMobile, isTablet),
                ),
                Text(
                  log.formattedDate,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondaryOverlay70,
                  ),
                ),
                SizedBox(
                  height: AppSizes.spacingXs.get(isMobile, isTablet),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMiniChip(Icons.inventory_rounded, '${log.productsCount} prod'),
                    SizedBox(
                      width: AppSizes.spacingXs.get(isMobile, isTablet),
                    ),
                    _buildMiniChip(Icons.label_rounded, '${log.tagsCount} tags'),
                    SizedBox(
                      width: AppSizes.spacingXs.get(isMobile, isTablet),
                    ),
                    _buildMiniChip(Icons.timer_rounded, log.durationFormatted),
                  ],
                ),
              ],
            ),
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingMdAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).textSecondary,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getResponsiveBorderRadius(
                      context,
                      mobile: 10,
                      tablet: 11,
                      desktop: 12,
                    ),
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
                          Icons.person_rounded,
                          size: AppSizes.iconTiny.get(isMobile, isTablet),
                          color: ThemeColors.of(context).textSecondary,
                        ),
                        SizedBox(
                          width: AppSizes.spacingXs.get(isMobile, isTablet),
                        ),
                        Text(
                          'Executado por: ${log.executedBy ?? 'Sistema'}',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 12,
                              mobileFontSize: 11,
                            ),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                            color: ThemeColors.of(context).textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSizes.spacingBase.get(isMobile, isTablet),
                    ),
                    Text(
                      'Detalhes:',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 12,
                          mobileFontSize: 11,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).textPrimary,
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.spacingXsAlt2.get(isMobile, isTablet),
                    ),
                    Text(
                      log.details ?? 'Nenhum detalhe dispon�vel.',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 12,
                          mobileFontSize: 11,
                        ),
                        color: ThemeColors.of(context).textSecondary,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.spacingBase.get(isMobile, isTablet),
                    ),
                    Container(
                      padding: EdgeInsets.all(
                        AppSizes.paddingBase.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).surface,
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.getResponsiveBorderRadius(
                            context,
                            mobile: 8,
                            tablet: 9,
                            desktop: 10,
                          ),
                        ),
                        border: Border.all(color: ThemeColors.of(context).textSecondary),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: _buildDetailItem(
                                  'Produtos',
                                  '${log.productsCount}',
                                  Icons.inventory_rounded,
                                ),
                              ),
                              Container(
                                width: 1,
                                height: ResponsiveHelper.getResponsiveHeight(
                                  context,
                                  mobile: 28,
                                  tablet: 29,
                                  desktop: 30,
                                ),
                                color: ThemeColors.of(context).textSecondary,
                              ),
                              Expanded(
                                child: _buildDetailItem(
                                  'Tags',
                                  '${log.tagsCount}',
                                  Icons.label_rounded,
                                ),
                              ),
                              Container(
                                width: 1,
                                height: ResponsiveHelper.getResponsiveHeight(
                                  context,
                                  mobile: 28,
                                  tablet: 29,
                                  desktop: 30,
                                ),
                                color: ThemeColors.of(context).textSecondary,
                              ),
                              Expanded(
                                child: _buildDetailItem(
                                  'Erros',
                                  '${log.errorCount}',
                                  Icons.error_rounded,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.spacingBase.get(isMobile, isTablet),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _exportarLogIndividual(log),
                            icon: Icon(
                              Icons.download_rounded,
                              size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                              color: logColor,
                            ),
                            label: Text(
                              'Exportar',
                              style: TextStyle(
                                color: logColor,
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 11,
                                  mobileFontSize: 10,
                                ),
                              overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                              ),
                              side: BorderSide(color: logColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.getResponsiveBorderRadius(
                                    context,
                                    mobile: 8,
                                    tablet: 9,
                                    desktop: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: AppSizes.spacingXs.get(isMobile, isTablet),
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _verDetalhesCompletos(log),
                            icon: Icon(
                              Icons.info_rounded,
                              size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                            ),
                            label: Text(
                              'Detalhes',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 11,
                                  mobileFontSize: 10,
                                ),
                              overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                              ),
                              backgroundColor: logColor,
                              foregroundColor: ThemeColors.of(context).surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.getResponsiveBorderRadius(
                                    context,
                                    mobile: 8,
                                    tablet: 9,
                                    desktop: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: AppSizes.iconMicro.get(isMobile, isTablet),
          color: ThemeColors.of(context).textSecondary,
        ),
        SizedBox(
          width: AppSizes.spacingXxsAlt.get(isMobile, isTablet),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 11,
              mobileFontSize: 10,
            ),
          overflow: TextOverflow.ellipsis,
            color: ThemeColors.of(context).textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: AppSizes.iconSmall.get(isMobile, isTablet),
          color: ThemeColors.of(context).primary,
        ),
        SizedBox(
          height: AppSizes.spacingXxsAlt.get(isMobile, isTablet),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
            ),
          overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 10,
              mobileFontSize: 9,
            ),
          overflow: TextOverflow.ellipsis,
            color: ThemeColors.of(context).textSecondary,
          ),
        ),
      ],
    );
  }

  void _verDetalhesCompletos(SyncHistoryEntry log) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final logColor = log.color;
    final logIcon = log.iconData;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getResponsiveBorderRadius(
              dialogContext,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              logIcon,
              color: logColor,
              size: AppSizes.iconLarge.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.spacingBase.get(isMobile, isTablet),
            ),
            Expanded(
              child: Text(
                'Log #${log.id}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    dialogContext,
                    baseFontSize: 18,
                    mobileFontSize: 16,
                    tabletFontSize: 17,
                  ),
                overflow: TextOverflow.ellipsis,
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
              _buildInfoRow('Data/Hora:', log.formattedDate),
              _buildInfoRow('Tipo:', log.type.label),
              _buildInfoRow('Status:', log.status.label),
              _buildInfoRow('Usu�rio:', log.executedBy ?? 'Sistema'),
              _buildInfoRow('Produtos:', '${log.productsCount}'),
              _buildInfoRow('Tags:', '${log.tagsCount}'),
              _buildInfoRow('Erros:', '${log.errorCount}'),
              _buildInfoRow('Dura��o:', log.durationFormatted),
              SizedBox(
                height: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              const Divider(),
              SizedBox(
                height: AppSizes.spacingXs.get(isMobile, isTablet),
              ),
              Text(
                'Detalhes:',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    dialogContext,
                    baseFontSize: 12,
                    mobileFontSize: 11,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).textPrimary,
                ),
              ),
              SizedBox(
                height: AppSizes.spacingXsAlt2.get(isMobile, isTablet),
              ),
              Text(
                log.details ?? 'Nenhum detalhe dispon�vel.',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    dialogContext,
                    baseFontSize: 12,
                    mobileFontSize: 11,
                  ),
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
              if (log.errors.isNotEmpty) ...[
                SizedBox(
                  height: AppSizes.spacingBase.get(isMobile, isTablet),
                ),
                const Divider(),
                SizedBox(
                  height: AppSizes.spacingXs.get(isMobile, isTablet),
                ),
                Text(
                  'Erros encontrados:',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      dialogContext,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                    ),
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).error,
                  ),
                ),
                SizedBox(
                  height: AppSizes.spacingXsAlt2.get(isMobile, isTablet),
                ),
                ...log.errors.map((error) => Padding(
                  padding: EdgeInsets.only(
                    bottom: AppSizes.spacingXxsAlt.get(isMobile, isTablet),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: AppSizes.iconTiny.get(isMobile, isTablet),
                        color: ThemeColors.of(context).error,
                      ),
                      SizedBox(
                        width: AppSizes.spacingXs.get(isMobile, isTablet),
                      ),
                      Expanded(
                        child: Text(
                          error,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              dialogContext,
                              baseFontSize: 11,
                              mobileFontSize: 10,
                            ),
                            color: ThemeColors.of(context).textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Fechar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  dialogContext,
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSizes.spacingXsAlt2.get(isMobile, isTablet),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                mobileFontSize: 11,
              ),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                mobileFontSize: 11,
              ),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _exportarLogIndividual(SyncHistoryEntry log) {
    final isMobile = ResponsiveHelper.isMobile(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.download_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconSmallMediumAlt.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.spacingBase.get(isMobile, isTablet),
            ),
            Expanded(
              child: Text(
                'Exportando log #${log.id}...',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: log.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getResponsiveBorderRadius(
              context,
              mobile: 10,
              tablet: 11,
              desktop: 12,
            ),
          ),
        ),
      ),
    );
  }

  void _exportarLog() async {
    final isMobile = ResponsiveHelper.isMobile(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.download_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconSmallMediumAlt.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.spacingBase.get(isMobile, isTablet),
            ),
            Text(
              'Exportando log completo...',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                ),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        backgroundColor: ThemeColors.of(context).primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getResponsiveBorderRadius(
              context,
              mobile: 10,
              tablet: 11,
              desktop: 12,
            ),
          ),
        ),
      ),
    );

    // Gerar dados do log para exporta��o
    final syncState = ref.read(syncProvider);
    final history = syncState.history;
    
    if (history.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nenhum log dispon�vel para exportar'),
          backgroundColor: ThemeColors.of(context).warningIcon,
        ),
      );
      return;
    }
    
    // Converter hist�rico para texto
    final buffer = StringBuffer();
    buffer.writeln('=== LOG DE SINCRONIZA��O TAGBEAN ===');
    buffer.writeln('Gerado em: ${DateTime.now().toString()}');
    buffer.writeln('Total de registros: ${history.length}');
    buffer.writeln('');
    
    for (final entry in history) {
      buffer.writeln('--- Sincroniza��o ${entry.id} ---');
      buffer.writeln('Tipo: ${entry.type.name}');
      buffer.writeln('Status: ${entry.status.name}');
      buffer.writeln('Iniciado: ${entry.startedAt}');
      buffer.writeln('Conclu�do: ${entry.completedAt}');
      buffer.writeln('Tags: ${entry.tagsCount}');
      buffer.writeln('Sucesso: ${entry.successCount}');
      buffer.writeln('Erros: ${entry.errorCount}');
      buffer.writeln('Dura��o: ${entry.duration?.inSeconds ?? 0}s');
      buffer.writeln('');
    }
    
    // Download do arquivo
    if (kIsWeb) {
      final bytes = utf8.encode(buffer.toString());
      final fileName = 'sync_log_${DateTime.now().millisecondsSinceEpoch}.txt';
      triggerDownload(bytes, fileName, 'text/plain');
    }
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconSmallMediumAlt.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.spacingBase.get(isMobile, isTablet),
            ),
            Text(
              'Log gerado: ${history.length} registros',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                ),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        backgroundColor: ThemeColors.of(context).success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getResponsiveBorderRadius(
              context,
              mobile: 10,
              tablet: 11,
              desktop: 12,
            ),
          ),
        ),
      ),
    );
  }
}





