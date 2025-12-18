import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/design_system/theme/dynamic_gradients.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/enums/loading_status.dart';
import 'package:tagbean/features/products/presentation/screens/products_list_screen.dart';
import 'package:tagbean/features/products/presentation/screens/product_add_screen.dart';
import 'package:tagbean/features/products/presentation/screens/product_qr_screen.dart';
import 'package:tagbean/features/products/presentation/screens/products_stock_screen.dart';
import 'package:tagbean/features/products/presentation/screens/products_import_screen.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/features/products/presentation/providers/products_state_provider.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';

class ProdutosDashboardScreen extends ConsumerStatefulWidget {
  const ProdutosDashboardScreen({super.key});

  @override
  ConsumerState<ProdutosDashboardScreen> createState() => _ProdutosDashboardScreenState();
}

class _ProdutosDashboardScreenState extends ConsumerState<ProdutosDashboardScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _headerAnimationController;
  late AnimationController _cardsAnimationController;
  late AnimationController _pulseController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  bool _isSyncing = false;
  bool _showOnboarding = true;
  bool _hideFabAddProduct = false;
  DateTime? _lastSyncTime;
  
  String _currentScreen = 'dashboard';

  // Acesso rápido aos providers
  ProductsListState get _productsState => ref.watch(productsListRiverpodProvider);
  ProductsListNotifier get _productsNotifier => ref.read(productsListRiverpodProvider.notifier);
  ProductStatisticsState get _statsState => ref.watch(productStatisticsRiverpodProvider);
  // ignore: unused_element
  ProductStatisticsNotifier get _statsNotifier => ref.read(productStatisticsRiverpodProvider.notifier);

  @override
  void initState() {
    super.initState();
    _loadOnboardingPreference();

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _cardsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _headerAnimationController.forward();
    _cardsAnimationController.forward();

    // Carrega dados do provider usando o storeId do contexto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  /// Carrega preferncia do onboarding
  Future<void> _loadOnboardingPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showOnboarding = prefs.getBool('products_show_onboarding') ?? true;
    });
  }

  /// Salva preferncia do onboarding
  Future<void> _dismissOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('products_show_onboarding', false);
    setState(() => _showOnboarding = false);
  }

  /// Carrega dados dos providers com storeId do contexto
  Future<void> _loadData() async {
    if (!mounted) return;
    
    final currentStore = ref.read(currentStoreProvider);
    final storeId = currentStore?.id;
    
    // Guardar referências antes das operações assíncronas
    final productsNotifier = ref.read(productsListRiverpodProvider.notifier);
    final statsNotifier = ref.read(productStatisticsRiverpodProvider.notifier);
    
    await productsNotifier.loadProducts(refresh: true);
    
    if (!mounted) return;
    
    await statsNotifier.loadStatistics(storeId: storeId);
    
    if (!mounted) return;
    
    setState(() {
      _lastSyncTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _cardsAnimationController.dispose();
    _pulseController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _isSyncing = true;
    });
    HapticFeedback.mediumImpact();

    // Usar storeId do contexto - guardar referências antes do await
    final currentStore = ref.read(currentStoreProvider);
    final storeId = currentStore?.id;
    final productsNotifier = ref.read(productsListRiverpodProvider.notifier);
    final statsNotifier = ref.read(productStatisticsRiverpodProvider.notifier);

    await productsNotifier.loadProducts(refresh: true);
    
    if (!mounted) return;
    
    await statsNotifier.loadStatistics(storeId: storeId);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _isSyncing = false;
      _lastSyncTime = DateTime.now();
    });
    HapticFeedback.lightImpact();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: ThemeColors.of(context).surface,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Text(
                'Sincronizado com sucesso!',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: ThemeColors.of(context).greenMain,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.snackbar),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Estatsticas do provider ou valores default
  int get _totalProdutos => _productsState.totalItems > 0 
      ? _productsState.totalItems 
      : _productsState.products.length;
  int get _comTag => _productsState.produtosComTag;
  int get _semTag => _productsState.produtosSemTag;
  // ignore: unused_element
  int get _ativos => _productsState.produtosAtivos;
  int get _categorias => _statsState.categoriesStats.length;
  double get _valorEstoque => _statsState.statistics?.valorEstoque ?? 0;
  
  // Verifica condies para onboarding contextual
  bool get _shouldShowOnboarding {
    if (!_showOnboarding) return false;
    if (_totalProdutos == 0) return true; // catálogo vazio
    if (_semTag > 0 && _semTag / _totalProdutos > 0.3) return true; // >30% sem tag
    return false;
  }
  
  String get _onboardingMessage {
    if (_totalProdutos == 0) return 'Comece seu catálogo adicionando produtos!';
    if (_semTag > 0) return 'Voc tem $_semTag produtos sem tag vinculada';
    return '';
  }
  
  String get _syncTimeAgo {
    if (_lastSyncTime == null) return 'Nunca';
    final diff = DateTime.now().difference(_lastSyncTime!);
    if (diff.inMinutes < 1) return 'Agora';
    if (diff.inMinutes < 60) return 'h ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'h ${diff.inHours}h';
    return 'h ${diff.inDays}d';
  }

  /// HEADER - Com sync status, voltar, sincronizar e configurações
  Widget _buildModuleHeader() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
        vertical: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: DynamicGradients.darkBackground(ref),
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
          // cone e Ttulo
          Container(
            padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay20,
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
            ),
            child: Icon(
              AppIcons.produtos,
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
                  'Produtos',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Gestão de catálogo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 10, tabletFontSize: 11),
                    color: ThemeColors.of(context).surfaceOverlay70,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Status de Sincronização
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
              vertical: AppSizes.paddingXs.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay15,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isSyncing ? Icons.sync_rounded : Icons.cloud_done_rounded,
                  color: ThemeColors.of(context).surfaceOverlay90,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  _isSyncing ? 'Sincronizando...' : _syncTimeAgo,
                  style: TextStyle(
                    fontSize: 11,
                    color: ThemeColors.of(context).surfaceOverlay90,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          
          // Boto Sincronizar
          IconButton(
            onPressed: _isSyncing ? null : _refreshData,
            icon: AnimatedRotation(
              turns: _isSyncing ? 1 : 0,
              duration: const Duration(seconds: 1),
              child: Icon(
                Icons.sync_rounded,
                color: _isSyncing ? ThemeColors.of(context).surfaceOverlay50 : ThemeColors.of(context).surface,
                size: AppSizes.iconSmall.get(isMobile, isTablet),
              ),
            ),
            tooltip: 'Sincronizar',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          
          // Boto Configurações
          IconButton(
            onPressed: () => _showConfiguracoesModal(),
            icon: Icon(
              Icons.settings_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            tooltip: 'Configurações',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
  
  void _showConfiguracoesModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings_rounded, color: ThemeColors.of(context).brandPrimaryGreen),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Configurações de Produtos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.of(context).textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.visibility_rounded, color: ThemeColors.of(context).primary),
              title: const Text('Mostrar onboarding'),
              subtitle: const Text('Exibir dicas e Sugestões'),
              trailing: Switch(
                value: _showOnboarding,
                activeThumbColor: ThemeColors.of(context).brandPrimaryGreen,
                onChanged: (value) async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('products_show_onboarding', value);
                  setState(() => _showOnboarding = value);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.sync_rounded, color: ThemeColors.of(context).orangeMain),
              title: const Text('Sincronização automtica'),
              subtitle: const Text('Atualizar ao abrir'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
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

  /// FAB Contextual - muda comportamento baseado no estado
  Widget _buildContextualFAB() {
    // Se catálogo vazio, mostrar FAB para adicionar primeiro produto
    if (_totalProdutos == 0) {
      // Se oculto, mostrar apenas boto pequeno para reexibir
      if (_hideFabAddProduct) {
        return FloatingActionButton.small(
          onPressed: () => setState(() => _hideFabAddProduct = false),
          backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
          foregroundColor: ThemeColors.of(context).surface,
          child: const Icon(Icons.add_rounded),
        );
      }
      // FAB extendido com boto de fechar
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'fab_toggle',
            onPressed: () => setState(() => _hideFabAddProduct = true),
            backgroundColor: ThemeColors.of(context).textSecondaryOverlay80,
            foregroundColor: ThemeColors.of(context).surface,
            child: const Icon(Icons.close_rounded, size: 18),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.extended(
            heroTag: 'fab_add_product',
            onPressed: () => setState(() => _currentScreen = 'adicionar'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Adicionar Primeiro Produto'),
            backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
            foregroundColor: ThemeColors.of(context).surface,
          ),
        ],
      );
    }
    
    // Se todos sem tag (ou maioria), mostrar FAB para vincular tags
    if (_semTag > 0 && _comTag == 0) {
      return FloatingActionButton.extended(
        onPressed: () => setState(() => _currentScreen = 'qr'),
        icon: const Icon(Icons.qr_code_scanner_rounded),
        label: const Text('Vincular Tags'),
        backgroundColor: ThemeColors.of(context).blueCyan,
        foregroundColor: ThemeColors.of(context).surface,
      );
    }
    
    // Normal: FAB com menu de ações rápidas
    return FloatingActionButton(
      onPressed: _showQuickActionsMenu,
      backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
      foregroundColor: ThemeColors.of(context).surface,
      child: const Icon(Icons.add_rounded),
    );
  }

  void _showQuickActionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).textSecondaryOverlay30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Ações Rápidas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _buildQuickMenuItem(
              icon: Icons.add_circle_outline_rounded,
              label: 'Adicionar Produto',
              cor: ThemeColors.of(context).brandPrimaryGreen,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentScreen = 'adicionar');
              },
            ),
            _buildQuickMenuItem(
              icon: Icons.qr_code_scanner_rounded,
              label: 'Escanear / Vincular Tag',
              cor: ThemeColors.of(context).blueCyan,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentScreen = 'qr');
              },
            ),
            _buildQuickMenuItem(
              icon: Icons.upload_file_rounded,
              label: 'Importar Planilha',
              cor: ThemeColors.of(context).success,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentScreen = 'importar');
              },
            ),
            _buildQuickMenuItem(
              icon: Icons.inventory_rounded,
              label: 'Gerenciar Estoque',
              cor: ThemeColors.of(context).orangeMain,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentScreen = 'estoque');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMenuItem({
    required IconData icon,
    required String label,
    required Color cor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: cor, size: 22),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: ThemeColors.of(context).textPrimary,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: ThemeColors.of(context).textSecondary),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case 'lista':
        return ProdutosListaScreen(
          onBack: () => setState(() => _currentScreen = 'dashboard'),
        );
      case 'adicionar':
        return ProdutosAdicionarScreen(
          onBack: () => setState(() => _currentScreen = 'dashboard'),
        );
      case 'importar':
        return ProdutosImportarScreen(
          onBack: () => setState(() => _currentScreen = 'dashboard'),
        );
      case 'qr':
        return const ProdutosAssociarQRScreen();
      case 'estoque':
        return ProdutosEstoqueScreen(
          onBack: () => setState(() => _currentScreen = 'dashboard'),
        );
      case 'dashboard':
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isLoading = _productsState.status == LoadingStatus.loading;

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshData,
      color: ThemeColors.of(context).brandPrimaryGreen,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SEããO 1: Header
            _buildModuleHeader(),
            
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 16, tablet: 20, desktop: 24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SEããO 2: Busca Global
                  _buildBuscaGlobal(),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // SEããO 3: Onboarding Contextual (condicional)
                  if (_shouldShowOnboarding) ...[
                    _buildOnboardingContextual(),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  
                  // SEããO 4: Resumo do catálogo (5 cards clicveis)
                  if (isLoading)
                    _buildLoadingStats()
                  else
                    _buildResumoCatalogo(),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // SEããO 5: Ações Rápidas + Produtos em Destaque (2 colunas)
                  _buildAcoesEDestaques(),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // SEããO 6: Categorias
                  _buildCategoriasSection(),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // SEããO 7: Mapa do Módulo (todos os menus disponveis)
                  _buildMapaModulo(),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SEããO 2: Busca Global com Scanner
  Widget _buildBuscaGlobal() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: ThemeColors.of(context).surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  color: ThemeColors.of(context).textPrimary,
                  fontSize: isMobile ? 14 : 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Buscar produto, cdigo, categoria...',
                  hintStyle: TextStyle(
                    color: ThemeColors.of(context).textTertiary,
                    fontSize: isMobile ? 13 : 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: ThemeColors.of(context).brandPrimaryGreen,
                    size: 22,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _productsNotifier.setSearchQuery(value);
                    setState(() => _currentScreen = 'lista');
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Boto Scanner
          Material(
            color: ThemeColors.of(context).brandPrimaryGreen,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: () => setState(() => _currentScreen = 'qr'),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: ThemeColors.of(context).surface,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SEããO 3: Onboarding Contextual
  Widget _buildOnboardingContextual() {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.1),
            ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lightbulb_rounded,
                  color: ThemeColors.of(context).brandPrimaryGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Prximo Passo',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: _dismissOnboarding,
                icon: const Icon(Icons.close_rounded, size: 20),
                color: ThemeColors.of(context).textSecondary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _onboardingMessage,
            style: TextStyle(
              fontSize: isMobile ? 13 : 14,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_totalProdutos == 0) {
                      setState(() => _currentScreen = 'adicionar');
                    } else {
                      setState(() => _currentScreen = 'qr');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
                    foregroundColor: ThemeColors.of(context).surface,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    _totalProdutos == 0 ? 'Adicionar Primeiro Produto' : 'Vincular Tags',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: _dismissOnboarding,
                child: Text(
                  'Fazer Depois',
                  style: TextStyle(color: ThemeColors.of(context).textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// SEããO 4: Resumo do catálogo - 5 Cards Clicveis
  Widget _buildResumoCatalogo() {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo do catálogo',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Grid de 5 cards - usando Row para desktop, Wrap para mobile
          if (isMobile)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildStatClickable(
                  label: 'Total',
                  valor: '$_totalProdutos',
                  icon: Icons.inventory_2_rounded,
                  cor: ThemeColors.of(context).primary,
                  onTap: () {
                    _productsNotifier.clearFilters();
                    setState(() => _currentScreen = 'lista');
                  },
                ),
                _buildStatClickable(
                  label: 'Com Tag',
                  valor: '$_comTag',
                  icon: Icons.label_rounded,
                  cor: ThemeColors.of(context).brandPrimaryGreen,
                  onTap: () {
                    _productsNotifier.clearFilters();
                    setState(() => _currentScreen = 'lista');
                  },
                ),
                _buildStatClickable(
                  label: 'Sem Tag',
                  valor: '$_semTag',
                  icon: Icons.label_off_rounded,
                  cor: ThemeColors.of(context).orangeMain,
                  showAlert: _semTag > 0,
                  onTap: () {
                    _productsNotifier.clearFilters();
                    setState(() => _currentScreen = 'lista');
                  },
                ),
                _buildStatClickable(
                  label: 'Estoque',
                  valor: 'R\$ ${_formatarValor(_valorEstoque)}',
                  icon: Icons.account_balance_wallet_rounded,
                  cor: ThemeColors.of(context).primary,
                  onTap: () => setState(() => _currentScreen = 'estoque'),
                ),
                _buildStatClickable(
                  label: 'Categorias',
                  valor: '$_categorias',
                  icon: Icons.category_rounded,
                  cor: ThemeColors.of(context).cyanMain,
                  onTap: () {},
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildStatClickableExpanded(
                    label: 'Total',
                    valor: '$_totalProdutos',
                    icon: Icons.inventory_2_rounded,
                    cor: ThemeColors.of(context).primary,
                    onTap: () {
                      _productsNotifier.clearFilters();
                      setState(() => _currentScreen = 'lista');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatClickableExpanded(
                    label: 'Com Tag',
                    valor: '$_comTag',
                    icon: Icons.label_rounded,
                    cor: ThemeColors.of(context).brandPrimaryGreen,
                    onTap: () {
                      _productsNotifier.clearFilters();
                      setState(() => _currentScreen = 'lista');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatClickableExpanded(
                    label: 'Sem Tag',
                    valor: '$_semTag',
                    icon: Icons.label_off_rounded,
                    cor: ThemeColors.of(context).orangeMain,
                    showAlert: _semTag > 0,
                    onTap: () {
                      _productsNotifier.clearFilters();
                      setState(() => _currentScreen = 'lista');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatClickableExpanded(
                    label: 'Estoque',
                    valor: 'R\$ ${_formatarValor(_valorEstoque)}',
                    icon: Icons.account_balance_wallet_rounded,
                    cor: ThemeColors.of(context).primary,
                    onTap: () => setState(() => _currentScreen = 'estoque'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatClickableExpanded(
                    label: 'Categorias',
                    valor: '$_categorias',
                    icon: Icons.category_rounded,
                    cor: ThemeColors.of(context).cyanMain,
                    onTap: () {},
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatClickable({
    required String label,
    required String valor,
    required IconData icon,
    required Color cor,
    required VoidCallback onTap,
    bool showAlert = false,
  }) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final width = (MediaQuery.of(context).size.width - 80) / (isMobile ? 2 : 5);
    
    return SizedBox(
      width: isMobile ? width : null,
      child: Material(
        color: ThemeColors.of(context).transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cor.withValues(alpha: 0.12), cor.withValues(alpha: 0.06)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cor.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: cor, size: isMobile ? 18 : 22),
                    if (showAlert) ...[
                      const SizedBox(width: 4),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    valor,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                      fontWeight: FontWeight.bold,
                      color: cor,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 13,
                    color: ThemeColors.of(context).textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: cor.withValues(alpha: 0.6),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Verso expandida para Row (desktop)
  Widget _buildStatClickableExpanded({
    required String label,
    required String valor,
    required IconData icon,
    required Color cor,
    required VoidCallback onTap,
    bool showAlert = false,
  }) {
    return Material(
      color: ThemeColors.of(context).transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cor.withValues(alpha: 0.12), cor.withValues(alpha: 0.06)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cor.withValues(alpha: 0.3), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: cor, size: 20),
                  if (showAlert) ...[
                    const SizedBox(width: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  valor,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cor,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: ThemeColors.of(context).textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Icon(
                Icons.arrow_forward_rounded,
                color: cor.withValues(alpha: 0.6),
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingStats() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: ThemeColors.of(context).brandPrimaryGreen),
            const SizedBox(height: 16),
            Text(
              'Carregando estatsticas...',
              style: TextStyle(color: ThemeColors.of(context).textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  /// SEããO 5: Ações Rápidas + Produtos em Destaque (2 colunas)
  Widget _buildAcoesEDestaques() {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    if (isMobile) {
      // Em mobile, empilhar verticalmente
      return Column(
        children: [
          _buildAcoesRapidasCard(),
          const SizedBox(height: 16),
          _buildProdutosDestaqueCard(),
        ],
      );
    }
    
    // Em tablet/desktop, 2 colunas
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildAcoesRapidasCard()),
        const SizedBox(width: 16),
        Expanded(child: _buildProdutosDestaqueCard()),
      ],
    );
  }

  Widget _buildAcoesRapidasCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    final acoes = [
      {
        'label': 'Ver Lista Completa',
        'subtitle': '$_totalProdutos produtos',
        'icon': Icons.list_alt_rounded,
        'cor': ThemeColors.of(context).brandPrimaryGreen,
        'screen': 'lista',
      },
      {
        'label': 'Adicionar Produto',
        'subtitle': 'Cadastrar novo',
        'icon': Icons.add_circle_outline_rounded,
        'cor': ThemeColors.of(context).primary,
        'screen': 'adicionar',
      },
      {
        'label': 'Importar Planilha',
        'subtitle': 'CSV, Excel',
        'icon': Icons.upload_file_rounded,
        'cor': ThemeColors.of(context).success,
        'screen': 'importar',
      },
      {
        'label': 'Vincular Tags',
        'subtitle': _semTag > 0 ? '$_semTag pendentes' : 'Vincular produtos',
        'icon': Icons.qr_code_scanner_rounded,
        'cor': ThemeColors.of(context).blueCyan,
        'screen': 'qr',
        'badge': _semTag > 0 ? _semTag : null,
      },
      {
        'label': 'Gerenciar Estoque',
        'subtitle': 'Entradas e sadas',
        'icon': Icons.inventory_rounded,
        'cor': ThemeColors.of(context).orangeMain,
        'screen': 'estoque',
      },
    ];

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flash_on_rounded, color: ThemeColors.of(context).brandPrimaryGreen, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Ações Rápidas',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...acoes.map((acao) => _buildAcaoItem(acao)),
        ],
      ),
    );
  }

  Widget _buildAcaoItem(Map<String, dynamic> acao) {
    final cor = acao['cor'] as Color;
    final badge = acao['badge'] as int?;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: ThemeColors.of(context).transparent,
        child: InkWell(
          onTap: () => setState(() => _currentScreen = acao['screen'] as String),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: cor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cor.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(acao['icon'] as IconData, color: cor, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        acao['label'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.of(context).textPrimary,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        acao['subtitle'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$badge',
                      style: TextStyle(
                        color: ThemeColors.of(context).surface,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: cor.withValues(alpha: 0.6), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProdutosDestaqueCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final recentProducts = _productsState.products.take(5).toList();
    
    return Container(
      padding: EdgeInsets.all(isMobile ? 10 : 12),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ttulo
          Row(
            children: [
              Icon(Icons.star_rounded, color: ThemeColors.of(context).orangeMain, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Produtos em Destaque',
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          
          // Seo: Atualizados Recentemente
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ThemeColors.of(context).primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, color: ThemeColors.of(context).primary, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Atualizados Recentemente',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.of(context).primary,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (recentProducts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        'Nenhum produto cadastrado',
                        style: TextStyle(
                          color: ThemeColors.of(context).textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                else
                  ...recentProducts.map((produto) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: ThemeColors.of(context).backgroundLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.inventory_2_rounded,
                            color: ThemeColors.of(context).textSecondary,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            produto.nome,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: ThemeColors.of(context).textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          'R\$ ${produto.preco.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).brandPrimaryGreen,
                          ),
                        ),
                      ],
                    ),
                  )),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // Boto Ver Histórico
          Center(
            child: TextButton.icon(
              onPressed: () => setState(() => _currentScreen = 'lista'),
              icon: const Icon(Icons.history_rounded, size: 14),
              label: const Text('Ver Histórico Completo', style: TextStyle(fontSize: 11)),
              style: TextButton.styleFrom(
                foregroundColor: ThemeColors.of(context).primary,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SEããO 6: Categorias com Chips e boto + Nova
  Widget _buildCategoriasSection() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final categorias = _statsState.categoriesStats;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.category_rounded, color: ThemeColors.of(context).cyanMain, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Categorias',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Abrir modal de nova categoria
                },
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Nova'),
                style: TextButton.styleFrom(
                  foregroundColor: ThemeColors.of(context).brandPrimaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (categorias.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 48,
                      color: ThemeColors.of(context).textSecondaryOverlay50,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nenhuma categoria encontrada',
                      style: TextStyle(color: ThemeColors.of(context).textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'As categorias aparecero aqui quando voc adicionar produtos',
                      style: TextStyle(
                        color: ThemeColors.of(context).textTertiary,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categorias.map((cat) {
                return Material(
                  color: ThemeColors.of(context).transparent,
                  child: InkWell(
                    onTap: () {
                      _productsNotifier.setFilterCategoria(cat.nome);
                      setState(() => _currentScreen = 'lista');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: cat.cor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cat.cor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(cat.icone, color: cat.cor, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            cat.nome,
                            style: TextStyle(
                              color: cat.cor,
                              fontWeight: FontWeight.w600,
                              fontSize: isMobile ? 12 : 13,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: cat.cor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${cat.quantidade}',
                              style: TextStyle(
                                color: cat.cor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  String _formatarValor(double valor) {
    if (valor >= 1000000) {
      return '${(valor / 1000000).toStringAsFixed(1)}M';
    } else if (valor >= 1000) {
      return '${(valor / 1000).toStringAsFixed(1)}K';
    }
    return valor.toStringAsFixed(2);
  }

  /// SEããO 7: Mapa do Módulo - Todos os menus disponveis em cards pequenos
  Widget _buildMapaModulo() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    // Lista de todos os menus/telas disponveis no módulo
    final menus = [
      _ModuloMenuItem(
        titulo: 'Dashboard',
        subtitulo: 'Viso geral',
        icone: Icons.dashboard_rounded,
        cor: ThemeColors.of(context).brandPrimaryGreen,
        onTap: () => setState(() => _currentScreen = 'dashboard'),
      ),
      _ModuloMenuItem(
        titulo: 'Lista de Produtos',
        subtitulo: 'catálogo completo',
        icone: Icons.inventory_2_rounded,
        cor: ThemeColors.of(context).primary,
        onTap: () => setState(() => _currentScreen = 'lista'),
      ),
      _ModuloMenuItem(
        titulo: 'Adicionar',
        subtitulo: 'Novo produto',
        icone: Icons.add_circle_rounded,
        cor: ThemeColors.of(context).success,
        onTap: () => setState(() => _currentScreen = 'adicionar'),
      ),
      _ModuloMenuItem(
        titulo: 'Importar',
        subtitulo: 'CSV/Excel',
        icone: Icons.upload_file_rounded,
        cor: ThemeColors.of(context).orangeMain,
        onTap: () => setState(() => _currentScreen = 'importar'),
      ),
      _ModuloMenuItem(
        titulo: 'Vincular Tags',
        subtitulo: 'ESL/QR Code',
        icone: Icons.qr_code_scanner_rounded,
        cor: ThemeColors.of(context).cyanMain,
        onTap: () => setState(() => _currentScreen = 'qr'),
      ),
      _ModuloMenuItem(
        titulo: 'Estoque',
        subtitulo: 'Gestão de inventrio',
        icone: Icons.warehouse_rounded,
        cor: ThemeColors.of(context).materialTeal,
        onTap: () => setState(() => _currentScreen = 'estoque'),
      ),
      _ModuloMenuItem(
        titulo: 'Categorias',
        subtitulo: 'Organizao',
        icone: Icons.category_rounded,
        cor: ThemeColors.of(context).amberMain,
        onTap: () {
          // Scroll para seo de categorias ou modal
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Role para ver as categorias acima')),
          );
        },
      ),
      _ModuloMenuItem(
        titulo: 'Relatrios',
        subtitulo: 'Anlises',
        icone: Icons.bar_chart_rounded,
        cor: ThemeColors.of(context).blueIndigo,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Relatrios em desenvolvimento'),
              backgroundColor: ThemeColors.of(context).info,
            ),
          );
        },
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ttulo da seo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.map_rounded,
                  color: ThemeColors.of(context).brandPrimaryGreen,
                  size: isMobile ? 18 : 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mapa do Módulo',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).textPrimary,
                      ),
                    ),
                    Text(
                      'Acesso rápido a todas as funcionalidades',
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 12,
                        color: ThemeColors.of(context).textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Grid de cards compactos - calculando tamanho baseado na largura
          LayoutBuilder(
            builder: (context, constraints) {
              // Calcular tamanho do card baseado na largura disponvel
              final availableWidth = constraints.maxWidth;
              final cardsPerRow = isMobile ? 4 : 8; // 4 em mobile, 8 em desktop
              const spacing = 8.0;
              final totalSpacing = spacing * (cardsPerRow - 1);
              final cardWidth = (availableWidth - totalSpacing) / cardsPerRow;
              final cardHeight = cardWidth * 0.85; // Proporo mais quadrada
              
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: menus.map((menu) => SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildMapaCardCompact(menu),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapaCardCompact(_ModuloMenuItem menu) {
    return Material(
      color: ThemeColors.of(context).transparent,
      child: InkWell(
        onTap: menu.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: menu.cor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: menu.cor.withValues(alpha: 0.2), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: menu.cor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(menu.icone, color: menu.cor, size: 16),
                  ),
                ),
              ),
              const SizedBox(height: 1),
              Flexible(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    menu.titulo,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.of(context).textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    menu.subtitulo,
                    style: TextStyle(
                      fontSize: 8,
                      color: ThemeColors.of(context).textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mtodo antigo mantido para compatibilidade
  // ignore: unused_element
  Widget _buildMapaCard(_ModuloMenuItem menu, bool isMobile) {
    return Material(
      color: ThemeColors.of(context).transparent,
      child: InkWell(
        onTap: menu.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          decoration: BoxDecoration(
            color: menu.cor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: menu.cor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: menu.cor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  menu.icone,
                  color: menu.cor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                menu.titulo,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ThemeColors.of(context).textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                menu.subtitulo,
                style: TextStyle(
                  fontSize: 11,
                  color: ThemeColors.of(context).textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Classe auxiliar para itens do mapa do módulo
class _ModuloMenuItem {
  final String titulo;
  final String subtitulo;
  final IconData icone;
  final Color cor;
  final VoidCallback onTap;

  const _ModuloMenuItem({
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.cor,
    required this.onTap,
  });
}






