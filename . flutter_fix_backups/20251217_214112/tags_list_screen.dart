import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tagbean/core/utils/responsive_helper.dart';

import 'package:tagbean/core/utils/responsive_cache.dart';

import 'package:tagbean/features/tags/presentation/screens/tag_add_screen.dart';

import 'package:tagbean/features/tags/presentation/screens/tag_edit_screen.dart';

import 'package:tagbean/features/tags/presentation/screens/tags_batch_screen.dart';

import 'package:tagbean/features/tags/presentation/screens/tags_import_screen.dart';

import 'package:tagbean/features/tags/data/models/tag_model.dart';

import 'package:tagbean/features/tags/presentation/providers/tags_provider.dart';

import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';

import 'package:tagbean/design_system/design_system.dart';




class EtiquetasListaScreen extends ConsumerStatefulWidget {

  final VoidCallback? onBack;

  

  const EtiquetasListaScreen({super.key, this.onBack});



  @override

  ConsumerState<EtiquetasListaScreen> createState() => _EtiquetasListaScreenState();

}



class _EtiquetasListaScreenState extends ConsumerState<EtiquetasListaScreen>

    with SingleTickerProviderStateMixin, ResponsiveCache {

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  late AnimationController _animationController;

  String _filterStatus = 'Todos';

  String _searchQuery = '';

  

  // Cache de etiquetas filtradas

  List<TagModel>? _cachedEtiquetasFiltradas;

  String _lastFilterStatus = 'Todos';

  String _lastSearchQuery = '';



  // Getter para estado das tags via Riverpod

  TagsState get _tagsState => ref.watch(tagsNotifierProvider);

  

  // Getter para notifier das tags via Riverpod

  TagsNotifier get _tagsNotifier => ref.read(tagsNotifierProvider.notifier);



  // Getter para etiquetas do provider

  List<TagModel> get _etiquetas => _tagsState.tags;



  @override

  void initState() {

    super.initState();

    _animationController = AnimationController(

      duration: const Duration(milliseconds: 300),

      vsync: this,

    );

    _animationController.forward();

    

    WidgetsBinding.instance.addPostFrameCallback((_) {

      _loadTags();

    });

  }



  Future<void> _loadTags() async {

    // Obtm storeId do WorkContext do usuário logado

    final currentStore = ref.read(currentStoreProvider);

    final storeId = currentStore?.id ?? 'store-not-configured';

    await _tagsNotifier.loadTagsByStore(storeId);

  }



  @override

  void dispose() {

    _animationController.dispose();

    super.dispose();

  }



  // Getter com cache para etiquetas filtradas

  List<TagModel> get _etiquetasFiltradas {

    if (_cachedEtiquetasFiltradas != null &&

        _lastFilterStatus == _filterStatus &&

        _lastSearchQuery == _searchQuery) {

      return _cachedEtiquetasFiltradas!;

    }

    

    _lastFilterStatus = _filterStatus;

    _lastSearchQuery = _searchQuery;

    

    // Mapear filtro de status para TagStatus

    TagStatus? statusFilter;

    if (_filterStatus == 'Associada') {

      statusFilter = TagStatus.bound;

    } else if (_filterStatus == 'Disponvel') {

      statusFilter = TagStatus.unbound;

    } else if (_filterStatus == 'Offline') {

      statusFilter = TagStatus.offline;

    }

    

    _cachedEtiquetasFiltradas = _tagsNotifier.filterTags(

      search: _searchQuery.isNotEmpty ? _searchQuery : null,

      status: statusFilter,

    );

    

    return _cachedEtiquetasFiltradas!;

  }



  // === Helpers para obter propriedades visuais do TagModel ===

  

  String _getStatusText(TagModel tag) {

    if (tag.hasSyncError) return 'Erro Sync';

    if (tag.isBound) return 'Associada';

    if (tag.status == TagStatus.offline || !tag.isOnline) return 'Offline';

    if (tag.isLowBattery) return 'Bateria Baixa';

    return 'Disponvel';

  }



  Color _getStatusColor(TagModel tag) {

    if (tag.hasSyncError) return ThemeColors.of(context).error;

    if (tag.isBound) return ThemeColors.of(context).success;

    if (tag.status == TagStatus.offline || !tag.isOnline) return ThemeColors.of(context).error;

    if (tag.isLowBattery) return ThemeColors.of(context).orangeMaterial;

    return ThemeColors.of(context).orangeMaterial;

  }



  IconData _getStatusIcon(TagModel tag) {

    if (tag.hasSyncError) return Icons.sync_problem_rounded;

    if (tag.isBound) return Icons.link_rounded;

    if (tag.status == TagStatus.offline || !tag.isOnline) return Icons.signal_wifi_off_rounded;

    if (tag.isLowBattery) return Icons.battery_alert_rounded;

    return Icons.label_off_rounded;

  }



  IconData _getBatteryIcon(TagModel tag) {

    if (tag.batteryLevel >= 70) return Icons.battery_full_rounded;

    if (tag.batteryLevel >= 30) return Icons.battery_charging_full_rounded;

    return Icons.battery_alert_rounded;

  }



  Color _getBatteryColor(int battery) {

    if (battery >= 70) return ThemeColors.of(context).greenMain;

    if (battery >= 30) return ThemeColors.of(context).orangeMain;

    return ThemeColors.of(context).error;

  }



  String _getSignalText(TagModel tag) {

    if (tag.signalStrength >= 80) return 'Excelente';

    if (tag.signalStrength >= 60) return 'Forte';

    if (tag.signalStrength >= 40) return 'Mdio';

    return 'Fraco';

  }



  // ignore: unused_element
  // ignore: unused_element
  String _formatLastSync(TagModel tag) {

    if (tag.lastSync == null) return 'N/A';

    final d = tag.lastSync!;

    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  }



  String _getLastSyncTime(TagModel tag) {

    if (tag.lastSync == null) return 'N/A';

    return '${tag.lastSync!.hour.toString().padLeft(2, '0')}:${tag.lastSync!.minute.toString().padLeft(2, '0')}';

  }

  

  // Novos helpers para status Minew
 // ignore: unused_element

  // ignore: unused_element
  String _getSyncStatusText(TagModel tag) {

    if (tag.minewSyncStatus == 'synced') return 'Sincronizado';

    if (tag.minewSyncStatus == 'pending') return 'Pendente';

    if (tag.minewSyncStatus == 'error') return 'Erro';

    return 'N/A';

  }

   // ignore: unused_element
  

  // ignore: unused_element
  Color _getSyncStatusColor(TagModel tag) {

    if (tag.minewSyncStatus == 'synced') return ThemeColors.of(context).success;

    if (tag.minewSyncStatus == 'pending') return ThemeColors.of(context).orangeMaterial;

    if (tag.minewSyncStatus == 'error') return ThemeColors.of(context).error;

    return ThemeColors.of(context).textSecondary;

  }

  

  IconData _getOnlineIcon(TagModel tag) {

    return tag.isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded;

  }

  

  Color _getOnlineColor(TagModel tag) {

    return tag.isOnline ? ThemeColors.of(context).success : ThemeColors.of(context).textSecondary;

  }



  @override

  Widget build(BuildContext context) {

    // Usar estatsticas do notifier

    final stats = _tagsNotifier.stats;

    final associadas = stats['bound'] ?? 0;

    final disponiveis = stats['available'] ?? 0;

    final offline = stats['offline'] ?? 0;



    // Mostrar loading se estiver carregando

    if (_tagsState.isLoading && _etiquetas.isEmpty) {

      return const Scaffold(

        body: Center(child: CircularProgressIndicator()),

      );

    }



    // Mostrar erro se houver

    if (_tagsState.error != null && _etiquetas.isEmpty) {

      return Scaffold(

        body: Center(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              Icon(Icons.error_outline, size: 64, color: ThemeColors.of(context).error),

              const SizedBox(height: 16),

              Text(_tagsState.error!, style: TextStyle(color: ThemeColors.of(context).error)),

              const SizedBox(height: 16),

              ElevatedButton(

                onPressed: _loadTags,

                child: const Text('Tentar Novamente'),

              ),

            ],

          ),

        ),

      );

    }



    return PopScope(

      canPop: !(_navigatorKey.currentState?.canPop() ?? false),

      onPopInvokedWithResult: (didPop, result) {

        if (didPop) return;

        if (_navigatorKey.currentState?.canPop() ?? false) {

          _navigatorKey.currentState?.pop();

        }

      },

      child: Navigator(

        key: _navigatorKey,

        onGenerateRoute: (settings) {

          return MaterialPageRoute(

            builder: (context) => Scaffold(

              backgroundColor: ThemeColors.of(context).surface,

              body: RefreshIndicator(

                onRefresh: _loadTags,

                child: SingleChildScrollView(

                  physics: const AlwaysScrollableScrollPhysics(),

                  child: Column(

                    children: [

                      _buildHeader(associadas, disponiveis, offline),

                      SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),

                      _buildInfoCard(),

                      SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),

                      _buildFilters(),

                      _etiquetasFiltradas.isEmpty

                          ? _buildEmptyState()

                          : Padding(

                              padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),

                              child: ListView.builder(

                                shrinkWrap: true,

                                physics: const NeverScrollableScrollPhysics(),

                                itemCount: _etiquetasFiltradas.length,

                                itemBuilder: (context, index) {

                                  return RepaintBoundary(

                                    child: _buildTagCard(_etiquetasFiltradas[index], index),

                                  );

                                },

                              ),

                            ),

                    ],

                  ),

                ),

              ),

              floatingActionButton: Column(

                mainAxisSize: MainAxisSize.min,

                mainAxisAlignment: MainAxisAlignment.end,

                children: [

                  FloatingActionButton(

                    heroTag: 'sync',

                    onPressed: _showSyncDialog,

                    backgroundColor: ThemeColors.of(context).blueMain,

                    child: Icon(

                      Icons.sync_rounded,

                      size: AppSizes.iconMediumLargeAlt.get(isMobile, isTablet),

                    ),

                  ),

                  SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),

                  FloatingActionButton(

                    heroTag: 'batch',

                    onPressed: () {

                      _navigatorKey.currentState?.push(

                        MaterialPageRoute(

                          builder: (context) => const EtiquetasOperacoesLoteScreen(),

                        ),

                      );

                    },

                    backgroundColor: ThemeColors.of(context).blueCyan,

                    child: Icon(

                      Icons.layers_rounded,

                      size: AppSizes.iconMediumLargeAlt.get(isMobile, isTablet),

                    ),

                  ),

                  SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),

                  FloatingActionButton.extended(

                    heroTag: 'add',

                    onPressed: () {

                      _navigatorKey.currentState?.push(

                        MaterialPageRoute(

                          builder: (context) => const EtiquetasAdicionarScreen(),

                        ),

                      );

                    },

                    icon: Icon(

                      Icons.add_rounded,

                      size: AppSizes.iconMediumAlt2.get(isMobile, isTablet),

                    ),

                    label: Text(

                      'Nova Tag',

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(

                        fontSize: ResponsiveHelper.getResponsiveFontSize(

                          context,

                          baseFontSize: 14,

                          mobileFontSize: 13,

                          tabletFontSize: 13,

                        ),

                      ),

                    ),

                    backgroundColor: ThemeColors.of(context).blueCyan,

                  ),

                ],

              ),

            ),

          );

        },

      ),

    );

  }



  Widget _buildHeader(int associadas, int disponiveis, int offline) {

    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);



    return Container(

      margin: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),

      padding: EdgeInsets.symmetric(

        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),

        vertical: AppSizes.paddingMd.get(isMobile, isTablet),

      ),

      decoration: BoxDecoration(

        gradient: AppGradients.darkBackground(context),

        borderRadius: BorderRadius.circular(

          ResponsiveHelper.getResponsiveBorderRadius(context, mobile: 16, tablet: 18, desktop: 20),

        ),

        boxShadow: [

          BoxShadow(

            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.4),

            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(context, mobile: 15, tablet: 18, desktop: 20),

            offset: Offset(0, isMobile ? 6 : (isTablet ? 7 : 8)),

          ),

        ],

      ),

      child: Row(

        children: [

          // Boto de voltar

          if (widget.onBack != null) ...[

            Container(

              decoration: BoxDecoration(

                color: ThemeColors.of(context).brandPrimaryGreen,

                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),

              ),

              child: IconButton(

                icon: Icon(

                  Icons.arrow_back_rounded,

                  color: ThemeColors.of(context).surface,

                  size: AppSizes.iconMedium.get(isMobile, isTablet),

                ),

                onPressed: widget.onBack,

              ),

            ),

            SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),

          ],

          Container(

            padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),

            decoration: BoxDecoration(

              color: ThemeColors.of(context).surfaceOverlay20,

              borderRadius: BorderRadius.circular(

                ResponsiveHelper.getResponsiveBorderRadius(context, mobile: 12, tablet: 13, desktop: 14),

              ),

            ),

            child: Icon(

              Icons.label_rounded,

              color: ThemeColors.of(context).surface,

              size: AppSizes.iconLarge.get(isMobile, isTablet),

            ),

          ),

          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),

          Expanded(

            child: Column(

              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(

                  'Etiquetas',

                  style: TextStyle(

                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 20, mobileFontSize: 18, tabletFontSize: 19),

                    overflow: TextOverflow.ellipsis,

                    fontWeight: FontWeight.bold,

                    color: ThemeColors.of(context).surface,

                    letterSpacing: -0.5,

                  ),

                ),

                SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),

                Text(

                  'Gestão de etiquetas ESL',

                  style: TextStyle(

                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 11, tabletFontSize: 12),

                    overflow: TextOverflow.ellipsis,

                    color: ThemeColors.of(context).surfaceOverlay70,

                    letterSpacing: 0.2,

                  ),

                ),

              ],

            ),

          ),

          // Stats ficam ocultos em mobile para evitar overflow

          if (!isMobile) ...[

            _buildCompactStat('$associadas', Icons.link_rounded),

            SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),

            _buildCompactStat('$disponiveis', Icons.label_off_rounded),

            SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),

            _buildCompactStat('$offline', Icons.signal_wifi_off_rounded),

          ],

        ],

      ),

    );

  }



  Widget _buildCompactStat(String value, IconData icon) {

    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);



    return Container(

      padding: EdgeInsets.symmetric(

        horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),

        vertical: AppSizes.paddingXs.get(isMobile, isTablet),

      ),

      decoration: BoxDecoration(

        color: ThemeColors.of(context).surfaceOverlay20,

        borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),

      ),

      child: Row(

        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(icon, color: ThemeColors.of(context).surface, size: AppSizes.iconSmall.get(isMobile, isTablet)),

          SizedBox(width: AppSizes.paddingXsAlt5.get(isMobile, isTablet)),

          Text(

            value,

            style: TextStyle(

              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 13, tabletFontSize: 14),

              overflow: TextOverflow.ellipsis,

              fontWeight: FontWeight.bold,

              color: ThemeColors.of(context).surface,

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

      margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingMd.get(isMobile, isTablet)),

      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),

      decoration: BoxDecoration(

        gradient: LinearGradient(

          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [ThemeColors.of(context).primaryPastel, ThemeColors.of(context).infoPastel],

        ),

        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),

        border: Border.all(color: ThemeColors.of(context).primaryLight, width: 1.5),

      ),

      child: Row(

        children: [

          Container(

            padding: EdgeInsets.all(AppSizes.paddingSmAlt.get(isMobile, isTablet)),

            decoration: BoxDecoration(

              color: ThemeColors.of(context).surface,

              borderRadius: BorderRadius.circular(isMobile ? 8 : 10),

            ),

            child: Icon(

              Icons.info_outline_rounded,

              color: ThemeColors.of(context).primaryDark,

              size: AppSizes.iconMedium.get(isMobile, isTablet),

            ),

          ),

          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisSize: MainAxisSize.min,

              children: [

                Text(

                  'Sobre este Módulo',

                  style: TextStyle(

                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13),

                    fontWeight: FontWeight.bold,

                    color: ThemeColors.of(context).primaryDark,

                    letterSpacing: -0.3,

                  ),

                ),

                SizedBox(height: AppSizes.extraSmallPadding.get(isMobile, isTablet)),

                Text(

                  'Gerencie suas etiquetas eletrnicas (ESLs) com controle completo de status, bateria, sincronização e associao com produtos.',

                  style: TextStyle(

                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11),

                    color: ThemeColors.of(context).primaryDark,

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



  Widget _buildFilters() {

    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);



    return Container(

      margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingBase.get(isMobile, isTablet)),

      padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),

      decoration: BoxDecoration(

        color: ThemeColors.of(context).surface,

        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),

        boxShadow: [

          BoxShadow(

            color: ThemeColors.of(context).textPrimaryOverlay05,

            blurRadius: isMobile ? 6 : 8,

            offset: const Offset(0, 2),

          ),

        ],

      ),

      child: Column(

        mainAxisSize: MainAxisSize.min,

        children: [

          TextField(

            decoration: InputDecoration(

              hintText: 'Buscar por MAC ou produto...',

              hintStyle: TextStyle(

                color: ThemeColors.of(context).textSecondary,

                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13),

              ),

              prefixIcon: Icon(

                Icons.search_rounded,

                color: ThemeColors.of(context).textSecondary,

                size: AppSizes.iconMediumAlt.get(isMobile, isTablet),

              ),

              suffixIcon: _searchQuery.isNotEmpty

                  ? IconButton(

                      icon: Icon(

                        Icons.clear_rounded,

                        color: ThemeColors.of(context).textSecondary,

                        size: AppSizes.iconMediumAlt.get(isMobile, isTablet),

                      ),

                      onPressed: () {

                        setState(() {

                          _searchQuery = '';

                          _cachedEtiquetasFiltradas = null;

                        });

                      },

                    )

                  : null,

              border: OutlineInputBorder(

                borderRadius: BorderRadius.circular(isMobile ? 10 : 12),

                borderSide: BorderSide(color: ThemeColors.of(context).textSecondary),

              ),

              enabledBorder: OutlineInputBorder(

                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),

                borderSide: BorderSide(color: ThemeColors.of(context).textSecondary),

              ),

              focusedBorder: OutlineInputBorder(

                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),

                borderSide: BorderSide(color: ThemeColors.of(context).blueCyan, width: 2),

              ),

              filled: true,

              fillColor: ThemeColors.of(context).textSecondary,

              contentPadding: EdgeInsets.symmetric(

                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),

                vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),

              ),

              isDense: true,

            ),

            onChanged: (value) {

              setState(() {

                _searchQuery = value;

                _cachedEtiquetasFiltradas = null;

              });

            },

          ),

          SizedBox(height: AppSizes.paddingSmAlt.get(isMobile, isTablet)),

          DropdownButtonFormField<String>(

            initialValue: _filterStatus,

            decoration: InputDecoration(

              labelText: 'Status',

              labelStyle: TextStyle(

                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11),

              ),

              prefixIcon: Icon(

                Icons.filter_list_rounded,

                size: AppSizes.iconMediumSmall.get(isMobile, isTablet),

              ),

              border: OutlineInputBorder(

                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),

              ),

              contentPadding: EdgeInsets.symmetric(

                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),

                vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),

              ),

              isDense: true,

            ),

            items: ['Todos', 'Associada', 'Disponvel', 'Offline']

                .map((e) => DropdownMenuItem(

                      value: e,

                      child: Text(

                        e,

                        style: TextStyle(

                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12),

                          overflow: TextOverflow.ellipsis,

                        ),

                      ),

                    ))

                .toList(),

            onChanged: (value) {

              setState(() {

                _filterStatus = value!;

                _cachedEtiquetasFiltradas = null;

              });

            },

          ),

        ],

      ),

    );

  }



  Widget _buildTagCard(TagModel tag, int index) {

    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);

    

    final statusColor = _getStatusColor(tag);

    final statusText = _getStatusText(tag);

    final statusIcon = _getStatusIcon(tag);

    final batteryIcon = _getBatteryIcon(tag);
 // ignore: unused_local_variable

    final batteryColor = _getBatteryColor(tag.batteryLevel);

    final signalText = _getSignalText(tag);

    final lastSyncTime = _getLastSyncTime(tag);



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

        margin: EdgeInsets.only(bottom: AppSizes.paddingSmAlt.get(isMobile, isTablet)),

        decoration: BoxDecoration(

          color: ThemeColors.of(context).surface,

          borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),

          border: Border.all(color: statusColor.withValues(alpha: 0.2), width: 2),

          boxShadow: [

            BoxShadow(

              color: statusColor.withValues(alpha: 0.1),

              blurRadius: isMobile ? 15 : 20,

              offset: const Offset(0, 4),

            ),

          ],

        ),

        child: Material(

          color: ThemeColors.of(context).transparent,

          child: InkWell(

            onTap: () => _navigateToEdit(tag),

            borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),

            child: Padding(

              padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),

              child: Row(

                mainAxisSize: MainAxisSize.min,

                children: [

                  // cone de status

                  Container(

                    width: ResponsiveHelper.getResponsiveWidth(context, mobile: 46, tablet: 48, desktop: 50),

                    height: ResponsiveHelper.getResponsiveHeight(context, mobile: 46, tablet: 48, desktop: 50),

                    decoration: BoxDecoration(

                      gradient: LinearGradient(colors: [statusColor, statusColor.withValues(alpha: 0.7)]),

                      borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),

                    ),

                    child: Icon(

                      statusIcon,

                      color: ThemeColors.of(context).surface,

                      size: AppSizes.iconMediumLarge.get(isMobile, isTablet),

                    ),

                  ),

                  SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),

                  // Informações

                  Expanded(

                    child: Column(

                      mainAxisSize: MainAxisSize.min,

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        // MAC Address e Status

                        Row(

                          mainAxisSize: MainAxisSize.min,

                          children: [

                            Text(

                              tag.macAddress.toUpperCase(),

                              style: TextStyle(

                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15, tabletFontSize: 15),

                                overflow: TextOverflow.ellipsis,

                                fontWeight: FontWeight.bold,

                                letterSpacing: -0.5,

                              ),

                            ),

                            SizedBox(width: AppSizes.paddingXsAlt.get(isMobile, isTablet)),

                            Container(

                              padding: EdgeInsets.symmetric(

                                horizontal: AppSizes.paddingXsAlt.get(isMobile, isTablet),

                                vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 1, tablet: 2, desktop: 2),

                              ),

                              decoration: BoxDecoration(

                                color: statusColor.withValues(alpha: 0.1),

                                borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, isTablet)),

                                border: Border.all(color: statusColor.withValues(alpha: 0.3)),

                              ),

                              child: Text(

                                statusText,

                                style: TextStyle(

                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9, tabletFontSize: 9),

                                  overflow: TextOverflow.ellipsis,

                                  fontWeight: FontWeight.w600,

                                  color: statusColor,

                                ),

                              ),

                            ),

                          ],

                        ),

                        SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),

                        // Nome do produto ou "Sem produto"

                        if (tag.productName != null) ...[

                          Row(

                            mainAxisSize: MainAxisSize.min,

                            children: [

                              Icon(

                                Icons.inventory_2_rounded,

                                size: AppSizes.iconExtraSmallAlt3.get(isMobile, isTablet),

                                color: ThemeColors.of(context).textSecondary,

                              ),

                              SizedBox(width: AppSizes.paddingXsAlt.get(isMobile, isTablet)),

                              Expanded(

                                child: Text(

                                  tag.productName!,

                                  style: TextStyle(

                                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12),

                                    color: ThemeColors.of(context).textSecondary,

                                    fontWeight: FontWeight.w500,

                                  ),

                                  maxLines: 1,

                                  overflow: TextOverflow.ellipsis,

                                ),

                              ),

                            ],

                          ),

                        ] else ...[

                          Text(

                            'Sem produto associado',

                            style: TextStyle(

                              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11),

                              overflow: TextOverflow.ellipsis,

                              color: ThemeColors.of(context).textSecondary,

                              fontStyle: FontStyle.italic,

                            ),

                          ),

                        ],

                        SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),

                        // Bateria, Sinal, Online e Última sincronização

                        Row(

                          mainAxisSize: MainAxisSize.min,

                          children: [

                            Icon(

                              batteryIcon,

                              size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 15, tablet: 16, desktop: 16),

                              color: batteryColor,

                            ),

                            SizedBox(width: AppSizes.paddingXxs.get(isMobile, isTablet)),

                            Text(

                              '${tag.batteryLevel}%',

                              style: TextStyle(

                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10),

                                overflow: TextOverflow.ellipsis,

                                fontWeight: FontWeight.w600,

                                color: batteryColor,

                              ),

                            ),

                            SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),

                            // Indicador Online/Offline

                            Icon(

                              _getOnlineIcon(tag),

                              size: AppSizes.iconExtraSmallAlt3.get(isMobile, isTablet),

                              color: _getOnlineColor(tag),

                            ),

                            SizedBox(width: AppSizes.paddingXxs.get(isMobile, isTablet)),

                            Text(

                              tag.isOnline ? 'Online' : 'Offline',

                              style: TextStyle(

                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10),

                                overflow: TextOverflow.ellipsis,

                                fontWeight: FontWeight.w600,

                                color: _getOnlineColor(tag),

                              ),

                            ),

                            // Temperatura (se disponvel)

                            if (tag.temperature != null) ...[

                              SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),

                              Icon(

                                Icons.thermostat_rounded,

                                size: AppSizes.iconExtraSmallAlt3.get(isMobile, isTablet),

                                color: ThemeColors.of(context).textSecondary,

                              ),

                              SizedBox(width: AppSizes.paddingXxs.get(isMobile, isTablet)),

                              Text(

                                '${tag.temperature}°C',

                                style: TextStyle(

                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10),

                                  overflow: TextOverflow.ellipsis,

                                  color: ThemeColors.of(context).textSecondary,

                                ),

                              ),

                            ],

                            SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),

                            Icon(

                              Icons.access_time_rounded,

                              size: AppSizes.iconExtraSmallAlt3.get(isMobile, isTablet),

                              color: ThemeColors.of(context).textSecondary,

                            ),

                            SizedBox(width: AppSizes.paddingXxs.get(isMobile, isTablet)),

                            Text(

                              lastSyncTime,

                              style: TextStyle(

                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10),

                                overflow: TextOverflow.ellipsis,

                                color: ThemeColors.of(context).textSecondary,

                              ),

                            ),

                          ],

                        ),

                      ],

                    ),

                  ),

                  // Menu de ações

                  _buildTagMenu(tag),

                ],

              ),

            ),

          ),

        ),

      ),

    );

  }



  Widget _buildTagMenu(TagModel tag) {

    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);



    return PopupMenuButton<String>(

      icon: Icon(

        Icons.more_vert_rounded,

        color: ThemeColors.of(context).textSecondary,

        size: AppSizes.iconMediumAlt.get(isMobile, isTablet),

      ),

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),

      ),

      itemBuilder: (context) => <PopupMenuEntry<String>>[

        PopupMenuItem(

          child: Row(

            mainAxisSize: MainAxisSize.min,

            children: [

              Icon(Icons.edit_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet), color: ThemeColors.of(context).textSecondary),

              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),

              Text('Editar', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),

            ],

          ),

          onTap: () => Future.delayed(Duration.zero, () => _navigateToEdit(tag)),

        ),

        PopupMenuItem(

          child: Row(

            mainAxisSize: MainAxisSize.min,

            children: [

              Icon(Icons.flash_on_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet), color: ThemeColors.of(context).warningDark),

              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),

              Text('Piscar LED', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),

            ],

          ),

          onTap: () => Future.delayed(Duration.zero, () => _flashTag(tag)),

        ),

        PopupMenuItem(

          child: Row(

            mainAxisSize: MainAxisSize.min,

            children: [

              Icon(Icons.sync_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet), color: ThemeColors.of(context).infoDark),

              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),

              Text('Atualizar Display', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),

            ],

          ),

          onTap: () => Future.delayed(Duration.zero, () => _refreshTag(tag)),

        ),

        if (tag.isBound)

          PopupMenuItem(

            child: Row(

              mainAxisSize: MainAxisSize.min,

              children: [

                Icon(Icons.link_off_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet), color: ThemeColors.of(context).orangeDark),

                SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),

                Text('Desvincular', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),

              ],

            ),

            onTap: () => Future.delayed(Duration.zero, () => _unbindTag(tag)),

          )

        else

          PopupMenuItem(

            child: Row(

              mainAxisSize: MainAxisSize.min,

              children: [

                Icon(Icons.link_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet), color: ThemeColors.of(context).primary),

                SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),

                Text('Vincular a Produto', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13), color: ThemeColors.of(context).primary, fontWeight: FontWeight.w600)),

              ],

            ),

            onTap: () => Future.delayed(Duration.zero, () => _bindTag(tag)),

          ),

        const PopupMenuDivider(),

        PopupMenuItem(

          child: Row(

            mainAxisSize: MainAxisSize.min,

            children: [

              Icon(Icons.delete_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet), color: ThemeColors.of(context).errorDark),

              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),

              Text('Excluir', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13), color: ThemeColors.of(context).errorDark)),

            ],

          ),

          onTap: () => Future.delayed(Duration.zero, () => _showDeleteDialog(tag)),

        ),

      ],

    );

  }



  Widget _buildEmptyState() {

    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);

    

    // Verifica se  estado vazio inicial ou resultado de busca/filtro

    final isInitialEmpty = _searchQuery.isEmpty && _filterStatus == 'Todos';



    return Center(

      child: Padding(

        padding: EdgeInsets.all(AppSizes.paddingXl.get(isMobile, isTablet)),

        child: Column(

          mainAxisSize: MainAxisSize.min,

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            // cone

            Container(

              padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context, mobile: 28, tablet: 30, desktop: 32)),

              decoration: BoxDecoration(

                gradient: isInitialEmpty

                    ? LinearGradient(

                        colors: [

                          ThemeColors.of(context).blueCyan.withValues(alpha: 0.1),

                          ThemeColors.of(context).blueCyan.withValues(alpha: 0.05),

                        ],

                      )

                    : null,

                color: isInitialEmpty ? null : ThemeColors.of(context).textSecondaryOverlay10,

                shape: BoxShape.circle,

              ),

              child: Icon(

                isInitialEmpty ? Icons.sell_rounded : Icons.search_off_rounded,

                size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 70, tablet: 75, desktop: 80),

                color: isInitialEmpty ? ThemeColors.of(context).blueCyan : ThemeColors.of(context).textSecondary,

              ),

            ),

            SizedBox(height: AppSizes.paddingXl.get(isMobile, isTablet)),

            

            // Ttulo

            Text(

              isInitialEmpty ? 'Configure suas etiquetas ESL!' : 'Nenhuma tag encontrada',

              style: TextStyle(

                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 20, mobileFontSize: 18, tabletFontSize: 19),

                fontWeight: FontWeight.bold,

                color: ThemeColors.of(context).textPrimary,

              ),

              textAlign: TextAlign.center,

            ),

            SizedBox(height: AppSizes.paddingXs.get(isMobile, isTablet)),

            

            // Descrição explicativa

            Padding(

              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingXl.get(isMobile, isTablet)),

              child: Text(

                isInitialEmpty

                    ? 'Tags ESL so etiquetas eletrnicas de prateleira.\nCadastre suas tags para vincular aos produtos e\natualizar preços automaticamente.'

                    : 'Ajuste os filtros ou tente outro termo de busca.',

                style: TextStyle(

                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13),

                  color: ThemeColors.of(context).textSecondary,

                  height: 1.5,

                ),

                textAlign: TextAlign.center,

              ),

            ),

            SizedBox(height: AppSizes.paddingXxl.get(isMobile, isTablet)),

            

            // Botes de ao

            if (isInitialEmpty) ...[

              // Boto principal - Adicionar Tag

              SizedBox(

                width: isMobile ? double.infinity : 260,

                child: ElevatedButton.icon(

                  onPressed: () {

                    _navigatorKey.currentState?.push(

                      MaterialPageRoute(builder: (context) => const EtiquetasAdicionarScreen()),

                    );

                  },

                  style: ElevatedButton.styleFrom(

                    backgroundColor: ThemeColors.of(context).blueCyan,

                    foregroundColor: ThemeColors.of(context).surface,

                    padding: EdgeInsets.symmetric(

                      horizontal: AppSizes.paddingXl.get(isMobile, isTablet),

                      vertical: AppSizes.paddingMd.get(isMobile, isTablet),

                    ),

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(12),

                    ),

                  ),

                  icon: const Icon(Icons.add_rounded),

                  label: const Text(

                    'Adicionar Tag',

                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),

                  ),

                ),

              ),

              SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),

              

              // Boto secundrio - Importar

              SizedBox(

                width: isMobile ? double.infinity : 260,

                child: OutlinedButton.icon(

                  onPressed: () {

                    _navigatorKey.currentState?.push(

                      MaterialPageRoute(builder: (context) => const TagsImportarScreen()),

                    );

                  },

                  style: OutlinedButton.styleFrom(

                    foregroundColor: ThemeColors.of(context).blueCyan,

                    side: BorderSide(color: ThemeColors.of(context).blueCyan),

                    padding: EdgeInsets.symmetric(

                      horizontal: AppSizes.paddingXl.get(isMobile, isTablet),

                      vertical: AppSizes.paddingMd.get(isMobile, isTablet),

                    ),

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(12),

                    ),

                  ),

                  icon: const Icon(Icons.upload_file_rounded),

                  label: const Text(

                    'Importar Tags',

                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),

                  ),

                ),

              ),

              

              // Card informativo sobre ESL

              SizedBox(height: AppSizes.paddingXxl.get(isMobile, isTablet)),

              Container(

                width: isMobile ? double.infinity : 400,

                padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),

                decoration: BoxDecoration(

                  color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.05),

                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.2)),

                ),

                child: Row(

                  children: [

                    Icon(Icons.info_outline_rounded, color: ThemeColors.of(context).blueCyan, size: 24),

                    SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),

                    Expanded(

                      child: Text(

                        'Dica: Cada tag possui um endereo MAC nico que pode ser escaneado ou digitado manualmente.',

                        style: TextStyle(

                          fontSize: 12,

                          color: ThemeColors.of(context).textSecondary,

                          height: 1.4,

                        ),

                      ),

                    ),

                  ],

                ),

              ),

            ] else ...[

              // Botes para resultado de busca vazio

              OutlinedButton.icon(

                onPressed: () {

                  setState(() {

                    _searchQuery = '';

                    _filterStatus = 'Todos';

                  });

                  _loadTags();

                },

                style: OutlinedButton.styleFrom(

                  foregroundColor: ThemeColors.of(context).blueMain,

                  side: BorderSide(color: ThemeColors.of(context).blueMain),

                  padding: EdgeInsets.symmetric(

                    horizontal: AppSizes.paddingMd.get(isMobile, isTablet),

                    vertical: AppSizes.paddingBase.get(isMobile, isTablet),

                  ),

                ),

                icon: const Icon(Icons.clear_all_rounded, size: 18),

                label: const Text('Limpar Filtros'),

              ),

            ],

          ],

        ),

      ),

    );

  }



  // === Ações ===



  void _navigateToEdit(TagModel tag) {

    _navigatorKey.currentState?.push(

      MaterialPageRoute(

        builder: (context) => EtiquetasEditarScreen(tag: tag),

      ),

    );

  }



  Future<void> _flashTag(TagModel tag) async {

    final isMobile = ResponsiveHelper.isMobile(context);



    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Row(

          children: [

            SizedBox(

              width: 18,

              height: 18,

              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface)),

            ),

            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),

            Expanded(

              child: Text(

                'Acionando LED de ${tag.macAddress}...',

                overflow: TextOverflow.ellipsis,

              ),

            ),

          ],

        ),

        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),

      ),

    );



    final success = await _tagsNotifier.flashTag(tag.macAddress);

    

    if (mounted) {

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Row(

            children: [

              Icon(

                success ? Icons.check_circle_rounded : Icons.error_rounded,

                color: ThemeColors.of(context).surface,

              ),

              const SizedBox(width: 8),

              Expanded(

                child: Text(

                  success ? 'LED acionado com sucesso!' : 'Erro ao acionar LED',

                  overflow: TextOverflow.ellipsis,

                ),

              ),

            ],

          ),

          backgroundColor: success ? ThemeColors.of(context).greenMain : ThemeColors.of(context).error,

          behavior: SnackBarBehavior.floating,

        ),

      );

    }

  }



  Future<void> _refreshTag(TagModel tag) async {

    final isMobile = ResponsiveHelper.isMobile(context);



    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Row(

          children: [

            SizedBox(

              width: 18,

              height: 18,

              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface)),

            ),

            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),

            Expanded(

              child: Text(

                'Atualizando display de ${tag.macAddress}...',

                overflow: TextOverflow.ellipsis,

              ),

            ),

          ],

        ),

        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),

      ),

    );



    final success = await _tagsNotifier.refreshTag(tag.macAddress);

    

    if (mounted) {

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Row(

            children: [

              Icon(

                success ? Icons.check_circle_rounded : Icons.error_rounded,

                color: ThemeColors.of(context).surface,

              ),

              const SizedBox(width: 8),

              Expanded(

                child: Text(

                  success ? 'Display atualizado!' : 'Erro ao atualizar display',

                  overflow: TextOverflow.ellipsis,

                ),

              ),

            ],

          ),

          backgroundColor: success ? ThemeColors.of(context).greenMain : ThemeColors.of(context).error,

          behavior: SnackBarBehavior.floating,

        ),

      );

    }

  }



  Future<void> _unbindTag(TagModel tag) async {

    final isMobile = ResponsiveHelper.isMobile(context);



    final confirm = await showDialog<bool>(

      context: context,

      builder: (context) => AlertDialog(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet))),

        icon: Icon(Icons.link_off_rounded, color: ThemeColors.of(context).orangeMain, size: 48),

        title: const Text('Desvincular Tag'),

        content: Text('Deseja desvincular a tag ${tag.macAddress} do produto "${tag.productName}"?'),

        actions: [

          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),

          ElevatedButton(

            onPressed: () => Navigator.pop(context, true),

            style: ElevatedButton.styleFrom(backgroundColor: ThemeColors.of(context).orangeMain),

            child: const Text('Desvincular'),

          ),

        ],

      ),

    );



    if (confirm == true) {

      final success = await _tagsNotifier.unbindTag(tag.macAddress);

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(

            content: Text(success ? 'Tag desvinculada com sucesso!' : 'Erro ao desvincular tag'),

            backgroundColor: success ? ThemeColors.of(context).greenMain : ThemeColors.of(context).error,

            behavior: SnackBarBehavior.floating,

          ),

        );

      }

    }

  }



  void _bindTag(TagModel tag) {

    // Navega para tela de edio da tag onde pode vincular a um produto

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (context) => EtiquetasEditarScreen(tag: tag),

      ),

    ).then((_) {

      // Recarrega a lista aps retornar

      _loadTags();

    });

  }



  void _showSyncDialog() {

    final isMobile = ResponsiveHelper.isMobile(context);



    showDialog(

      context: context,

      builder: (context) => AlertDialog(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet))),

        icon: Icon(Icons.sync_rounded, color: ThemeColors.of(context).blueMain, size: AppSizes.iconHeroSmAlt.get(isMobile, isTablet)),

        title: const Text('Sincronizar Todas'),

        content: const Text('Deseja sincronizar todas as tags com o servidor Minew?\n\nTempo estimado: ~3 minutos', textAlign: TextAlign.center),

        actions: [

          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),

          ElevatedButton(

            onPressed: () async {

              Navigator.pop(context);

              

              ScaffoldMessenger.of(context).showSnackBar(

                SnackBar(

                  content: Row(

                    children: [

                      SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface))),

                      const SizedBox(width: 12),

                      const Expanded(child: Text('Sincronizando todas as tags...', overflow: TextOverflow.ellipsis)),

                    ],

                  ),

                  backgroundColor: ThemeColors.of(context).blueMain,

                  behavior: SnackBarBehavior.floating,

                  duration: const Duration(seconds: 30),

                ),

              );



              final currentStore = ref.read(currentStoreProvider);

              final storeId = currentStore?.id ?? _tagsState.currentStoreId ?? 'store-not-configured';

              final result = await _tagsNotifier.syncTags(storeId);



              if (mounted) {

                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                ScaffoldMessenger.of(context).showSnackBar(

                  SnackBar(

                    content: Text(result != null 

                        ? 'Sincronização concluda: ${result.successCount} sucesso, ${result.failureCount} falhas'

                        : 'Erro na sincronização'),

                    backgroundColor: result != null ? ThemeColors.of(context).greenMain : ThemeColors.of(context).error,

                    behavior: SnackBarBehavior.floating,

                  ),

                );

              }

            },

            style: ElevatedButton.styleFrom(backgroundColor: ThemeColors.of(context).blueMain),

            child: const Text('Sincronizar'),

          ),

        ],

      ),

    );

  }



  void _showDeleteDialog(TagModel tag) {

    final isMobile = ResponsiveHelper.isMobile(context);



    showDialog(

      context: context,

      builder: (context) => AlertDialog(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet))),

        icon: Icon(Icons.warning_rounded, color: ThemeColors.of(context).error, size: AppSizes.iconHeroSmAlt.get(isMobile, isTablet)),

        title: const Text('Confirmar Excluso'),

        content: Text('Deseja realmente excluir a tag "${tag.macAddress}"?\n\nEsta ao no pode ser desfeita.', textAlign: TextAlign.center),

        actions: [

          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),

          ElevatedButton(

            onPressed: () async {

              Navigator.pop(context);

              final success = await _tagsNotifier.deleteTag(tag.macAddress);

              

              if (mounted) {

                ScaffoldMessenger.of(context).showSnackBar(

                  SnackBar(

                    content: Row(

                      children: [

                        Icon(

                          success ? Icons.check_circle_rounded : Icons.error_rounded,

                          color: ThemeColors.of(context).surface,

                        ),

                        const SizedBox(width: 8),

                        Text(success ? '${tag.macAddress} excluda' : 'Erro ao excluir tag'),

                      ],

                    ),

                    backgroundColor: success ? ThemeColors.of(context).greenMain : ThemeColors.of(context).error,

                    behavior: SnackBarBehavior.floating,

                  ),

                );

              }

            },

            style: ElevatedButton.styleFrom(backgroundColor: ThemeColors.of(context).error),

            child: const Text('Excluir'),

          ),

        ],

      ),

    );

  }

}













