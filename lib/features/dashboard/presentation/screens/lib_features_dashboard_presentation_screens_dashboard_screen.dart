import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Screens dos módulos
import 'package:tagbean/features/products/presentation/screens/products_dashboard_screen.dart';
import 'package:tagbean/features/tags/presentation/screens/tags_dashboard_screen.dart';
// ... outros imports de screens

// Widgets modulares
import 'package:tagbean/features/dashboard/presentation/widgets/navigation/navigation.dart';
import 'package:tagbean/features/dashboard/presentation/widgets/cards/cards.dart';
import 'package:tagbean/features/dashboard/presentation/widgets/dialogs/dialogs.dart';
import 'package:tagbean/features/dashboard/presentation/widgets/sections/sections.dart';
import 'package:tagbean/features/dashboard/presentation/widgets/search/tagbean_search_delegate.dart';

// Providers e Utils
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> 
    with TickerProviderStateMixin {
  
  int _selectedIndex = 0;
  bool _isRailExpanded = true;
  int _rebuildCounter = 0;
  
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  final ScrollController _bottomNavScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent:  _fadeController,
      curve:  Curves.easeInOut,
    );
    _fadeController.forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDashboardData());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _bottomNavScrollController.dispose();
    super.dispose();
  }

  void _loadDashboardData() {
    final workContext = ref.read(workContextProvider);
    final storeId = workContext.context.currentStoreId;
    if (workContext.isLoaded && storeId != null && storeId.isNotEmpty) {
      ref.read(dashboardProvider.notifier).loadDashboard(storeId);
    }
  }

  void _onItemSelected(int index, {bool fromDrawer = false}) {
    if (index == _selectedIndex) {
      setState(() => _rebuildCounter++);
    } else {
      setState(() => _selectedIndex = index);
    }
    _fadeController.reset();
    _fadeController.forward();
  }

  void _onToggleRailExpand() {
    setState(() => _isRailExpanded = !_isRailExpanded);
  }

  Key _getScreenKey(String prefix) => Key('${prefix}_$_rebuildCounter');

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      drawer: isMobile ? DashboardMobileDrawer(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        fadeController: _fadeController,
      ) : null,
      body:  Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment. bottomRight,
            colors: [
              ThemeColors.of(context).grey50,
              ThemeColors.of(context).grey100,
              ThemeColors.of(context).grey200,
            ],
          ),
        ),
        child: SafeArea(
          child:  Column(
            children: [
              DashboardAppBar(
                onNotificationTap: () => NotificationsPanel.show(context, ref:  ref),
                onLogout: () => LogoutDialog.show(context),
                onProfileTap: () => _onItemSelected(9),
                onHelpTap: () => _showHelpDialog(),
              ),
              Expanded(
                child: Row(
                  children: [
                    if (! isMobile) DashboardNavigationRail(
                      selectedIndex:  _selectedIndex,
                      isExpanded: _isRailExpanded,
                      onItemSelected: _onItemSelected,
                      onToggleExpand:  _onToggleRailExpand,
                      fadeController: _fadeController,
                    ),
                    Expanded(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _getSelectedScreen(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isMobile ?  DashboardMobileBottomNav(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        scrollController: _bottomNavScrollController,
        fadeController: _fadeController,
      ) : null,
    );
  }

  Widget _getSelectedScreen() {
    return switch (_selectedIndex) {
      0 => DashboardContent(
        key: _getScreenKey('dashboard'),
        onNavigateTo: _onItemSelected,
      ),
      1 => ProdutosDashboardScreen(key: _getScreenKey('produtos')),
      2 => TagsDashboardScreen(key: _getScreenKey('etiquetas')),
      3 => EstrategiasMenuScreen(key: _getScreenKey('estrategias')),
      4 => SincronizacaoControleScreen(key: _getScreenKey('sincronizacao')),
      5 => PrecificacaoMenuScreen(key: _getScreenKey('precificacao')),
      6 => CategoriasMenuScreen(key: _getScreenKey('categorias')),
      7 => ImportacaoMenuScreen(key: _getScreenKey('importacao')),
      8 => RelatoriosMenuScreen(key: _getScreenKey('relatorios')),
      9 => ConfiguracoesMenuScreen(key:  _getScreenKey('configuracoes')),
      _ => DashboardContent(onNavigateTo: _onItemSelected),
    };
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder:  (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help_outline_rounded),
            SizedBox(width: 8),
            Text('Ajuda'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TagBean - Sistema de Gestão de Etiquetas Eletrônicas'),
            SizedBox(height: 12),
            Text('Versão: 1.0.0'),
            SizedBox(height: 8),
            Text('Suporte: suporte@tagbean. com. br'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}