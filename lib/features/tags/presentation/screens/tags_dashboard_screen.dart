import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/features/tags/presentation/screens/tags_list_screen.dart';
import 'package:tagbean/features/tags/presentation/screens/tags_diagnostic_screen.dart';
import 'package:tagbean/features/tags/presentation/screens/tags_store_map_screen.dart';
import 'package:tagbean/features/tags/presentation/screens/tag_add_screen.dart';
import 'package:tagbean/features/tags/presentation/screens/tags_batch_screen.dart';
import 'package:tagbean/features/tags/presentation/screens/tags_import_screen.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/features/tags/presentation/providers/tags_provider.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
// Widgets do módulo Tags
import 'package:tagbean/features/tags/presentation/widgets/widgets.dart';

class TagsDashboardScreen extends ConsumerStatefulWidget {
  const TagsDashboardScreen({super.key});

  @override
  ConsumerState<TagsDashboardScreen> createState() => _TagsDashboardScreenState();
}

class _TagsDashboardScreenState extends ConsumerState<TagsDashboardScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _headerAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  
  // Campos faltantes
  DateTime? _lastSync;
  bool _isLoading = false;
  String _filterStatus = 'all';
  final TextEditingController _searchController = TextEditingController();

  // NOTA: _isLoading removido (morto)
  bool _dismissedOnboarding = false;
  // NOTA: _lastSync removido (morto)
  
  String _currentScreen = 'dashboard';
  // NOTA: _filterStatus removido (morto)

  @override
  void initState() {
    super.initState();

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _headerAnimationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final currentStore = ref.read(currentStoreProvider);
    final storeId = currentStore?.id;
    
    final tagsNotifier = ref.read(tagsNotifierProvider.notifier);
    await tagsNotifier.loadTagsByStore(storeId ?? 'default');
    
    if (mounted) {
      setState(() => _lastSync = DateTime.now());
    }
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    await _loadData();

    if (!mounted) return;

    setState(() => _isLoading = false);
    HapticFeedback.lightImpact();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(
                  Icons.refresh_rounded,
                  color: ThemeColors.of(context).surface,
                  size: 20,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              const Text(
                'Dados atualizados com sucesso!',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.snackbar),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Obtm dados do provider corretamente
  TagsState get _tagsState => ref.watch(tagsNotifierProvider);

  // Estatsticas calculadas usando helpers do TagModel
  int get _totalTags => _tagsState.tags.length;
  int get _tagsOnline => _tagsState.tags.where((t) => t.isOnline).length;
  int get _tagsOffline => _tagsState.tags.where((t) => !t.isOnline).length;
  int get _tagsBound => _tagsState.tags.where((t) => t.isBound).length;
  int get _tagsUnbound => _tagsState.tags.where((t) => !t.isBound).length;
  int get _tagsLowBattery => _tagsState.tags.where((t) => t.isLowBattery).length;
  double get _percentualBound => _totalTags > 0 ? (_tagsBound / _totalTags * 100) : 0;

  // Determina o estado de onboarding
  TagOnboardingState get _onboardingState {
    if (_dismissedOnboarding) return TagOnboardingState.none;
    if (_totalTags == 0) return TagOnboardingState.noTags;
    if (_tagsUnbound > _totalTags * 0.3) return TagOnboardingState.manyUnbound;
    if (_tagsOffline > _totalTags * 0.2) return TagOnboardingState.manyOffline;
    return TagOnboardingState.none;
  }

  // Determina alertas ativos
  List<TagAlert> get _alerts {
    final alerts = <TagAlert>[];
    
    if (_tagsOffline > 0) {
      alerts.add(TagAlert(
        id: 'offline',
        priority: TagAlertPriority.critical,
        message: 'tags offline ou sem comunicao',
        icon: Icons.signal_cellular_off_rounded,
        actionLabel: 'Diagnosticar',
        onAction: () => _navigateToScreen('diagnostico'),
        count: _tagsOffline,
      ));
    }
    
    if (_tagsUnbound > 0) {
      alerts.add(TagAlert(
        id: 'unbound',
        priority: TagAlertPriority.attention,
        message: 'tags sem produto vinculado',
        icon: Icons.link_off_rounded,
        actionLabel: 'Vincular',
        onAction: () => _navigateToListWithFilter('disponiveis'),
        count: _tagsUnbound,
      ));
    }

    if (_tagsLowBattery > 0) {
      alerts.add(TagAlert(
        id: 'lowBattery',
        priority: TagAlertPriority.attention,
        message: 'tags com bateria baixa',
        icon: Icons.battery_alert_rounded,
        actionLabel: 'Ver Tags',
        onAction: () => _navigateToListWithFilter('bateria_baixa'),
        count: _tagsLowBattery,
      ));
    }
    
    return alerts;
  }

  void _navigateToScreen(String screen) {
    // Casos especiais que redirecionam para lista com filtro
    if (screen == 'lista_disponiveis') {
      _navigateToListWithFilter('disponiveis');
      return;
    }
    setState(() => _currentScreen = screen);
  }

  void _navigateToListWithFilter(String? filter) {
    setState(() {
      _filterStatus = filter ?? 'all';
      _currentScreen = 'lista';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).backgroundLight,
      body: _buildCurrentScreen(),
      floatingActionButton: _currentScreen == 'dashboard' 
          ? _buildContextualFAB()
          : null,
    );
  }

  Widget _buildCurrentScreen() {
    // Callback para voltar ao dashboard
    void goBackToDashboard() {
      setState(() => _currentScreen = 'dashboard');
    }
    
    switch (_currentScreen) {
      case 'lista':
        return EtiquetasListaScreen(onBack: goBackToDashboard);
      case 'diagnostico':
        return TagsDiagnosticoScreen(onBack: goBackToDashboard);
      case 'mapa':
        return TagsMapaLojaScreen(onBack: goBackToDashboard);
      case 'lote':
        return EtiquetasOperacoesLoteScreen(onBack: goBackToDashboard);
      case 'importar':
        return TagsImportarScreen(onBack: goBackToDashboard);
      case 'adicionar':
        return EtiquetasAdicionarScreen(onBack: goBackToDashboard);
      case 'dashboard':
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    final isLoading = _tagsState.isLoading;

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshData,
      backgroundColor: ThemeColors.of(context).surface,
      color: ThemeColors.of(context).textPrimary,
      child: CustomScrollView(
        slivers: [
          // 1. Header
          SliverToBoxAdapter(child: _buildHeader()),
          
          // 2. Barra de busca
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 16, tablet: 20, desktop: 24),
                vertical: 8,
              ),
              child: _buildSearchBar(),
            ),
          ),
          
          // 3. Grid de Estatsticas
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 16, tablet: 20, desktop: 24),
                vertical: 8,
              ),
              child: isLoading ? _buildLoadingContent() : _buildStatsGrid(),
            ),
          ),
          
          // 4. Alertas (condicional)
          if (_alerts.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 16, tablet: 20, desktop: 24),
                  vertical: 8,
                ),
                child: _buildAlertsSection(),
              ),
            ),
          
          // 5. Menu Principal
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 16, tablet: 20, desktop: 24),
                vertical: 8,
              ),
              child: _buildMainMenuSection(),
            ),
          ),
          
          // 6. Aes Rpidas
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 16, tablet: 20, desktop: 24),
                vertical: 8,
              ),
              child: _buildQuickActionsSection(),
            ),
          ),
          
          // 7. Menu Completo de Tags
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 16, tablet: 20, desktop: 24),
                vertical: 8,
              ),
              child: _buildMenuCompletoTags(),
            ),
          ),
          
          // Espao para o FAB
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildContextualFAB() {
    if (_totalTags == 0) {
      return FloatingActionButton.extended(
        onPressed: () => _navigateToScreen('adicionar'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Adicionar Primeira Tag'),
        backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
      );
    }

    if (_tagsUnbound > 0 && _tagsUnbound == _totalTags) {
      return FloatingActionButton.extended(
        onPressed: () => _navigateToListWithFilter('disponiveis'),
        icon: const Icon(Icons.link_rounded),
        label: const Text('Vincular Tags'),
        backgroundColor: ThemeColors.of(context).primary,
      );
    }

    return FloatingActionButton(
      onPressed: () => _showQuickActionSheet(),
      backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
      child: const Icon(Icons.add_rounded),
    );
  }

  void _showQuickActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeColors.of(context).transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(AppSpacing.dashboardSectionGap),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ThemeColors.of(context).border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.dashboardSectionGap),
            Text(
              'Aes Rpidas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.dashboardSectionGap),
            _buildQuickActionTile(
              icon: Icons.add_rounded,
              label: 'Nova Tag',
              color: ThemeColors.of(context).brandPrimaryGreen,
              onTap: () {
                Navigator.pop(context);
                _navigateToScreen('adicionar');
              },
            ),
            _buildQuickActionTile(
              icon: Icons.upload_file_rounded,
              label: 'Importar Tags',
              color: ThemeColors.of(context).primary,
              onTap: () {
                Navigator.pop(context);
                _navigateToScreen('importar');
              },
            ),
            _buildQuickActionTile(
              icon: Icons.layers_rounded,
              label: 'Operaes em Lote',
              color: ThemeColors.of(context).orangeMaterial,
              onTap: () {
                Navigator.pop(context);
                _navigateToScreen('lote');
              },
            ),
            _buildQuickActionTile(
              icon: Icons.troubleshoot_rounded,
              label: 'Diagnstico',
              color: ThemeColors.of(context).blueCyan,
              onTap: () {
                Navigator.pop(context);
                _navigateToScreen('diagnostico');
              },
            ),
            _buildQuickActionTile(
              icon: Icons.sync_rounded,
              label: 'Sincronizar Todas',
              color: ThemeColors.of(context).tealMain,
              onTap: () {
                Navigator.pop(context);
                _syncAllTags();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Material(
        color: ThemeColors.of(context).transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: ThemeColors.of(context).textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SlideTransition(
      position: _headerSlideAnimation,
      child: FadeTransition(
        opacity: _headerFadeAnimation,
        child: Container(
          margin: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
            vertical: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          decoration: BoxDecoration(
            gradient: AppGradients.darkBackground(context),
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
                color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.4),
                blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
                  context,
                  mobile: 15,
                  tablet: 18,
                  desktop: 20,
                ),
                offset: Offset(0, isMobile ? 6 : (isTablet ? 7 : 8)),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                ),
                child: Icon(
                  Icons.label_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.spacingSm.get(isMobile, isTablet)),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Etiquetas',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                        letterSpacing: -0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Gesto de tags ESL',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 10, tabletFontSize: 11),
                        color: ThemeColors.of(context).surfaceOverlay70,
                      ),
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildHeaderStat(String value, IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 12,
        vertical: isMobile ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surfaceOverlay20,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: ThemeColors.of(context).surface, size: 16),
          SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).surface,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: ThemeColors.of(context).surfaceOverlay80,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 20,
        vertical: isMobile ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 14 : 18),
        border: Border.all(color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: ThemeColors.of(context).brandPrimaryGreen,
            size: isMobile ? 22 : 24,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                color: ThemeColors.of(context).textPrimary,
                fontSize: isMobile ? 14 : 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Buscar por MAC, produto ou localizao...',
                hintStyle: TextStyle(
                  color: ThemeColors.of(context).textTertiary.withValues(alpha: 0.6),
                  fontSize: isMobile ? 14 : 15,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 14),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _navigateToListWithFilter('search:$value');
                }
              },
            ),
          ),
          Container(
            height: 30,
            width: 1,
            color: ThemeColors.of(context).border,
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          IconButton(
            icon: Icon(Icons.qr_code_scanner_rounded, color: ThemeColors.of(context).brandPrimaryGreen),
            onPressed: () => _navigateToScreen('adicionar'),
            tooltip: 'Escanear Tag',
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: CircularProgressIndicator(color: ThemeColors.of(context).brandPrimaryGreen),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total',
                value: '$_totalTags',
                icon: Icons.label_rounded,
                color: ThemeColors.of(context).brandPrimaryGreen,
                subtitle: 'etiquetas',
                onTap: () => _navigateToListWithFilter(null),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                title: 'Online',
                value: '$_tagsOnline',
                icon: Icons.signal_cellular_4_bar_rounded,
                color: ThemeColors.of(context).success,
                subtitle: 'ativas',
                onTap: () => _navigateToListWithFilter('online'),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                title: 'Offline',
                value: '$_tagsOffline',
                icon: Icons.signal_cellular_off_rounded,
                color: ThemeColors.of(context).error,
                subtitle: 'inativas',
                isWarning: _tagsOffline > 0,
                onTap: () => _navigateToListWithFilter('offline'),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Vinculadas',
                value: '$_tagsBound',
                icon: Icons.link_rounded,
                color: ThemeColors.of(context).primary,
                subtitle: 'com produto',
                onTap: () => _navigateToListWithFilter('vinculadas'),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                title: 'Disponveis',
                value: '$_tagsUnbound',
                icon: Icons.link_off_rounded,
                color: ThemeColors.of(context).orangeMaterial,
                subtitle: 'sem produto',
                isWarning: _tagsUnbound > 0,
                onTap: () => _navigateToListWithFilter('disponiveis'),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                title: 'Bateria',
                value: '$_tagsLowBattery',
                icon: Icons.battery_alert_rounded,
                color: ThemeColors.of(context).blueCyan,
                subtitle: 'baixa (<20%)',
                isWarning: _tagsLowBattery > 0,
                onTap: () => _navigateToListWithFilter('bateria_baixa'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
    bool isWarning = false,
    VoidCallback? onTap,
  }) {
    return Material(
      color: ThemeColors.of(context).transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.md,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).surface,
            borderRadius: AppRadius.md,
            boxShadow: [
              BoxShadow(
                color: ThemeColors.of(context).textPrimaryOverlay05,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: isWarning ? color.withValues(alpha: 0.5) : ThemeColors.of(context).border,
              width: isWarning ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.of(context).textSecondary,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 16),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isWarning ? color : ThemeColors.of(context).textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: ThemeColors.of(context).orangeMaterial, size: 20),
            SizedBox(width: AppSpacing.sm),
            Text(
              'Alertas Importantes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).textPrimary,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                if (_alerts.isNotEmpty) {
                  _alerts.first.onAction();
                }
              },
              child: Text(
                'Resolver Todos',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ThemeColors.of(context).orangeMaterial,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        ..._alerts.map((alert) => _buildAlertCard(alert)),
      ],
    );
  }

  Widget _buildAlertCard(TagAlert alert) {
    final backgroundColor = alert.priority == TagAlertPriority.critical
        ? ThemeColors.of(context).error.withValues(alpha: 0.1)
        : ThemeColors.of(context).orangeMaterial.withValues(alpha: 0.1);
    
    final borderColor = alert.priority == TagAlertPriority.critical
        ? ThemeColors.of(context).error
        : ThemeColors.of(context).orangeMaterial;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.md,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: borderColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(alert.icon, color: borderColor, size: 20),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${alert.count} ${alert.message}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Clique para resolver',
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          ElevatedButton(
            onPressed: alert.onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: borderColor,
              foregroundColor: ThemeColors.of(context).surface,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              alert.actionLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMenuSection() {
    final menuItems = [
      MenuItemData(
        icon: Icons.list_alt_rounded,
        title: 'Lista de Tags',
        subtitle: 'Visualizar e gerenciar todas',
        color: ThemeColors.of(context).brandPrimaryGreen,
        screen: 'lista',
      ),
      MenuItemData(
        icon: Icons.troubleshoot_rounded,
        title: 'Diagnstico',
        subtitle: 'Status e conectividade',
        color: ThemeColors.of(context).primary,
        screen: 'diagnostico',
      ),
      MenuItemData(
        icon: Icons.link_rounded,
        title: 'Vincular Produtos',
        subtitle: 'Associar tags a produtos',
        color: ThemeColors.of(context).blueCyan,
        screen: 'lista_disponiveis',
      ),
      MenuItemData(
        icon: Icons.layers_rounded,
        title: 'Operaes em Lote',
        subtitle: 'Atualizar mltiplas tags',
        color: ThemeColors.of(context).orangeMaterial,
        screen: 'lote',
      ),
      MenuItemData(
        icon: Icons.map_rounded,
        title: 'Mapa da Loja',
        subtitle: 'Localizao das tags',
        color: ThemeColors.of(context).tealMain,
        screen: 'mapa',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.dashboard_rounded, color: ThemeColors.of(context).brandPrimaryGreen, size: 20),
            SizedBox(width: AppSpacing.sm),
            Text(
              'Menu Principal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        ...menuItems.map((item) => _buildMenuItemCard(item)),
      ],
    );
  }

  Widget _buildMenuItemCard(MenuItemData item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: AppRadius.md,
        border: Border.all(color: ThemeColors.of(context).border, width: 1),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: ThemeColors.of(context).transparent,
        child: InkWell(
          onTap: () => _navigateToScreen(item.screen),
          borderRadius: AppRadius.md,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.color, size: 24),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.of(context).textPrimary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ThemeColors.of(context).textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.flash_on_rounded, color: ThemeColors.of(context).orangeMaterial, size: 20),
            SizedBox(width: AppSpacing.sm),
            Text(
              'Aes Rpidas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                icon: Icons.add_rounded,
                label: 'Nova Tag',
                color: ThemeColors.of(context).brandPrimaryGreen,
                onTap: () => _navigateToScreen('adicionar'),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildQuickActionButton(
                icon: Icons.upload_file_rounded,
                label: 'Importar',
                color: ThemeColors.of(context).primary,
                onTap: () => _navigateToScreen('importar'),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                icon: Icons.sync_rounded,
                label: 'Sincronizar',
                color: ThemeColors.of(context).blueCyan,
                onTap: _syncAllTags,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildQuickActionButton(
                icon: Icons.refresh_rounded,
                label: 'Atualizar',
                color: ThemeColors.of(context).tealMain,
                onTap: _refreshData,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: AppRadius.md,
        border: Border.all(color: ThemeColors.of(context).border, width: 1),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: ThemeColors.of(context).transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.md,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCompletoTags() {
    final menuItems = [
      _MenuTagItem(
        icon: Icons.list_alt_rounded,
        label: 'Ver Tags',
        subtitle: 'Lista completa',
        color: ThemeColors.of(context).brandPrimaryGreen,
        onTap: () => _navigateToScreen('lista'),
      ),
      _MenuTagItem(
        icon: Icons.add_circle_rounded,
        label: 'Nova Tag',
        subtitle: 'Cadastrar',
        color: ThemeColors.of(context).primary,
        onTap: () => _navigateToScreen('adicionar'),
      ),
      _MenuTagItem(
        icon: Icons.link_rounded,
        label: 'Vincular',
        subtitle: 'Produtos',
        color: ThemeColors.of(context).blueCyan,
        onTap: () => _navigateToListWithFilter('disponiveis'),
      ),
      _MenuTagItem(
        icon: Icons.upload_file_rounded,
        label: 'Importar',
        subtitle: 'CSV/Excel',
        color: ThemeColors.of(context).orangeMaterial,
        onTap: () => _navigateToScreen('importar'),
      ),
      _MenuTagItem(
        icon: Icons.troubleshoot_rounded,
        label: 'Diagnstico',
        subtitle: 'Status',
        color: ThemeColors.of(context).tealMain,
        onTap: () => _navigateToScreen('diagnostico'),
      ),
      _MenuTagItem(
        icon: Icons.signal_cellular_off_rounded,
        label: 'Offline',
        subtitle: '$_tagsOffline tags',
        color: ThemeColors.of(context).error,
        badge: _tagsOffline > 0 ? _tagsOffline : null,
        onTap: () => _navigateToListWithFilter('offline'),
      ),
      _MenuTagItem(
        icon: Icons.link_off_rounded,
        label: 'Sem Produto',
        subtitle: '$_tagsUnbound tags',
        color: ThemeColors.of(context).orangeMaterial,
        badge: _tagsUnbound > 0 ? _tagsUnbound : null,
        onTap: () => _navigateToListWithFilter('disponiveis'),
      ),
      _MenuTagItem(
        icon: Icons.check_circle_rounded,
        label: 'Vinculadas',
        subtitle: '$_tagsBound tags',
        color: ThemeColors.of(context).brandPrimaryGreen,
        onTap: () => _navigateToListWithFilter('vinculadas'),
      ),
      _MenuTagItem(
        icon: Icons.map_rounded,
        label: 'Mapa Loja',
        subtitle: 'Localizao',
        color: ThemeColors.of(context).primary,
        onTap: () => _navigateToScreen('mapa'),
      ),
      _MenuTagItem(
        icon: Icons.layers_rounded,
        label: 'Lote',
        subtitle: 'Operaes',
        color: ThemeColors.of(context).blueCyan,
        onTap: () => _navigateToScreen('lote'),
      ),
      _MenuTagItem(
        icon: Icons.sync_rounded,
        label: 'Sincronizar',
        subtitle: 'Todas',
        color: ThemeColors.of(context).tealMain,
        onTap: _syncAllTags,
      ),
      _MenuTagItem(
        icon: Icons.settings_rounded,
        label: 'Configuraes',
        subtitle: 'Preferncias',
        color: ThemeColors.of(context).textSecondary,
        onTap: () => _showSettingsSheet(),
      ),
    ];

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context, mobile: 16, tablet: 20, desktop: 24)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
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
              Icon(Icons.apps_rounded, color: ThemeColors.of(context).brandPrimaryGreen, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu de Tags',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.of(context).textPrimary,
                    ),
                  ),
                  Text(
                    'Acesse rapidamente qualquer funo',
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 12,
                      color: ThemeColors.of(context).textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 4 : 6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isMobile ? 0.85 : 1.0,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) => _buildMenuGridItem(menuItems[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGridItem(_MenuTagItem item) {
    return Material(
      color: ThemeColors.of(context).transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 8 : 12),
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: item.color.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(isMobile ? 8 : 10),
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item.icon,
                      color: item.color,
                      size: isMobile ? 20 : 24,
                    ),
                  ),
                  if (item.badge != null && item.badge! > 0)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${item.badge}',
                          style: TextStyle(
                            color: ThemeColors.of(context).surface,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: isMobile ? 6 : 8),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: isMobile ? 10 : 12,
                  fontWeight: FontWeight.w600,
                  color: ThemeColors.of(context).textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isMobile) ...[
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 9,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _syncAllTags() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(child: Text('Sincronizando todas as tags...')),
          ],
        ),
        backgroundColor: ThemeColors.of(context).primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );

    final notifier = ref.read(tagsNotifierProvider.notifier);
    await notifier.refresh();

    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
              const SizedBox(width: 12),
              const Expanded(child: Text('Sincronizao concluda!')),
            ],
          ),
          backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeColors.of(context).transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(AppSpacing.dashboardSectionGap),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ThemeColors.of(context).border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.dashboardSectionGap),
            Text(
              'Configuraes de Tags',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.dashboardSectionGap),
            ListTile(
              leading: Icon(Icons.notifications_rounded, color: ThemeColors.of(context).brandPrimaryGreen),
              title: const Text('Alertas de Status'),
              subtitle: const Text('Notificaes de tags offline'),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: ThemeColors.of(context).textTertiary),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.battery_alert_rounded, color: ThemeColors.of(context).orangeMaterial),
              title: const Text('Alertas de Bateria'),
              subtitle: const Text('Limite de bateria baixa'),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: ThemeColors.of(context).textTertiary),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.sync_rounded, color: ThemeColors.of(context).primary),
              title: const Text('Sincronizao Automtica'),
              subtitle: const Text('Intervalo de atualizao'),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: ThemeColors.of(context).textTertiary),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.download_rounded, color: ThemeColors.of(context).blueCyan),
              title: const Text('Exportar Dados'),
              subtitle: const Text('Baixar relatório de tags'),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: ThemeColors.of(context).textTertiary),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppSpacing.welcomeMetricGap),
          ],
        ),
      ),
    );
  }
}

// Classes auxiliares locais (no duplicadas dos widgets)
class MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String screen;

  MenuItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.screen,
  });
}

class _MenuTagItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final int? badge;

  const _MenuTagItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.badge,
  });
}









