import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/products/presentation/screens/products_dashboard_screen.dart';
import 'package:tagbean/features/tags/presentation/screens/tags_dashboard_screen.dart';
import 'package:tagbean/features/sync/presentation/screens/sync_control_screen.dart';
import 'package:tagbean/features/pricing/presentation/screens/pricing_menu_screen.dart';
import 'package:tagbean/features/categories/presentation/screens/categories_menu_screen.dart';
import 'package:tagbean/features/import_export/presentation/screens/import_menu_screen.dart';
import 'package:tagbean/features/reports/presentation/screens/reports_menu_screen.dart';
import 'package:tagbean/features/strategies/presentation/screens/strategies_panel_screen.dart';
import 'package:tagbean/features/strategies/presentation/screens/ai_suggestions_screen.dart';
import 'package:tagbean/features/strategies/presentation/providers/strategies_provider.dart';
import 'package:tagbean/features/settings/presentation/screens/settings_menu_screen.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/auth/presentation/widgets/store_selector.dart';
import 'package:tagbean/features/auth/presentation/widgets/store_switcher.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
import 'package:tagbean/features/auth/presentation/providers/auth_provider.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:tagbean/features/dashboard/presentation/widgets/welcome_section.dart';
// Novos widgets do dashboard reestruturado
import 'package:tagbean/features/dashboard/presentation/widgets/alertas_acionaveis_card.dart';
import 'package:tagbean/features/dashboard/presentation/widgets/acoes_frequentes_card.dart';
import 'package:tagbean/features/dashboard/presentation/widgets/resumo_do_dia_card.dart';
import 'package:tagbean/features/dashboard/presentation/widgets/oportunidades_lucro_card.dart';
import 'package:tagbean/features/dashboard/presentation/widgets/estrategias_ativas_card.dart';
// Novos blocos de melhoria
import 'package:tagbean/features/dashboard/presentation/widgets/status_geral_sistema_card.dart';
import 'package:tagbean/features/dashboard/presentation/widgets/fluxos_inteligentes_card.dart';
// Novos widgets conforme dashboard.txt (substituem atalhos_rapidos_card que conflita com navegador)
import 'package:tagbean/features/dashboard/presentation/widgets/onboarding_steps_card.dart';
import 'package:tagbean/features/dashboard/presentation/widgets/next_action_card.dart';
import 'package:tagbean/features/dashboard/presentation/widgets/recent_activity_dashboard_card.dart';
// Card de administração (PlatformAdmin / ClientAdmin)
import 'package:tagbean/features/dashboard/presentation/widgets/admin_panel_card.dart';
// Widgets de navegação extraídos
import 'package:tagbean/features/dashboard/presentation/widgets/navigation/navigation.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isRailExpanded = true;
  bool _isEstrategiasExpanded = false;
  int _rebuildCounter = 0; // Contador para forçar rebuild ao clicar no mesmo menu
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final ScrollController _bottomNavScrollController = ScrollController();
  
  // ValueKey dinâmica usada em _getSelectedScreen() com _rebuildCounter
  // permite resetar módulo ao clicar no mesmo menu

  // OTIMIZAÇÃO: Lista static const para evitar recriação a cada rebuild
  static const List<Map<String, dynamic>> _menuItems = [
    {
      'icon': Icons.dashboard_rounded,
      'title': 'Dashboard',
      // ignore: implicit_this_reference_in_initializer
      'gradient': [ThemeColors.of(context).moduleDashboard, ThemeColors.of(context).moduleDashboardDark]
    },
    {
      'icon': Icons.inventory_2_rounded,
      'title': 'Produtos',
      // ignore: implicit_this_reference_in_initializer
      'gradient': [ThemeColors.of(context).moduleProdutos, ThemeColors.of(context).moduleProdutosDark]
    },
    {
      'icon': Icons.label_rounded,
      'title': 'Etiquetas',
      // ignore: implicit_this_reference_in_initializer
      'gradient': [ThemeColors.of(context).moduleEtiquetas, ThemeColors.of(context).moduleEtiquetasDark]
    },
    {
      'icon': Icons.auto_awesome_rounded,
      'title': 'Estratégias',
      // ignore: implicit_this_reference_in_initializer
      'gradient': [ThemeColors.of(context).moduleEstrategias, ThemeColors.of(context).moduleEstrategiasDark]
    },
    {
      'icon': Icons.sync_rounded,
      'title': 'Sincronização',
      // ignore: implicit_this_reference_in_initializer
      'gradient': [ThemeColors.of(context).moduleSincronizacao, ThemeColors.of(context).moduleSincronizacaoDark]
    },
    {
      'icon': Icons.monetization_on_rounded,
      'title': 'Precificação',
      // ignore: implicit_this_reference_in_initializer
      'gradient': [ThemeColors.of(context).modulePrecificacao, ThemeColors.of(context).modulePrecificacaoDark]
    },
    {
      'icon': Icons.category_rounded,
      'title': 'Categorias',
      // ignore: implicit_this_reference_in_initializer
      'gradient': [ThemeColors.of(context).moduleCategorias, ThemeColors.of(context).moduleCategoriasDark]
    },
    {
      'icon': Icons.import_export_rounded,
      'title': 'Importação',
      // ignore: implicit_this_reference_in_initializer
      'gradient': [ThemeColors.of(context).moduleImportacao, ThemeColors.of(context).moduleImportacaoDark]
    },
    {
      'icon': Icons.assessment_rounded,
      'title': 'Relatórios',
      // ignore: implicit_this_reference_in_initializer
      'gradient': [ThemeColors.of(context).moduleRelatorios, ThemeColors.of(context).moduleRelatoriosDark]
    },
    {
      'icon': Icons.settings_rounded,
      'title': 'Configurações',
      // ignore: implicit_this_reference_in_initializer
      'gradient': [ThemeColors.of(context).moduleConfiguracoes, ThemeColors.of(context).moduleConfiguracoesDark]
    },
  ];

  /// Getter dinâmico para dados de estratégias baseado no provider
  Map<String, dynamic> get _estrategiasData {
    final strategiesState = ref.watch(strategiesProvider);
    final strategiesStats = ref.watch(strategiesStatsProvider);
    
    final activeStrategies = strategiesState.strategies.where((s) => s.status.isActive).toList();
    final affectedProducts = strategiesStats.affectedProductsCount;
    
    // Calcula ganhos das estratégias
    final ganhoMensal = strategiesStats.monthlyGain;
    final ganhoHoje = strategiesStats.todayGain;
    final crescimento = strategiesStats.growthPercentage;
    
    // Cores para cada estratégia
    final cores = [ThemeColors.of(context).greenMaterial, ThemeColors.of(context).blueMaterial, ThemeColors.of(context).orangeMaterial, ThemeColors.of(context).greenMaterial, ThemeColors.of(context).materialTeal, ThemeColors.of(context).blueIndigo];
    
    return {
      'ativas': activeStrategies.length,
      'produtos_afetados': affectedProducts,
      'ganho_mensal': ganhoMensal,
      'ganho_hoje': ganhoHoje,
      'crescimento': crescimento.startsWith('+') || crescimento.startsWith('-') ? crescimento : '+$crescimento',
      'estrategias': activeStrategies.asMap().entries.map((entry) {
        final index = entry.key;
        final strategy = entry.value;
        return {
          'nome': strategy.name,
          'status': 'Ativa',
          'ganho': strategy.impactValue,
          'produtos': strategy.affectedProducts,
          'cor': cores[index % cores.length],
        };
      }).toList(),
    };
  }

  /// Converte alertas do provider para formato Map usado na UI
  List<Map<String, dynamic>> get _alertas {
    final alerts = ref.watch(dashboardAlertsProvider);
    return alerts.map((alert) {
      IconData icone;
      Color cor;
      
      switch (alert.type.toLowerCase()) {
        case 'produtos sem preço':
        case 'sem_preco':
          icone = Icons.money_off_rounded;
          cor = ThemeColors.of(context).orangeMaterial;
          break;
        case 'tags offline':
        case 'offline':
          icone = Icons.signal_wifi_off_rounded;
          cor = ThemeColors.of(context).redMain;
          break;
        case 'margem negativa':
        case 'margem_negativa':
          icone = Icons.trending_down_rounded;
          cor = ThemeColors.of(context).urgent;
          break;
        case 'estoque baixo':
        case 'estoque_baixo':
          icone = Icons.inventory_2_rounded;
          cor = ThemeColors.of(context).amberMain;
          break;
        default:
          icone = Icons.warning_rounded;
          cor = ThemeColors.of(context).grey500;
      }
      
      return {
        'tipo': alert.type,
        'qtd': alert.count,
        'descricao': alert.description,
        'icone': icone,
        'cor': cor,
        'detalhes': alert.details.isNotEmpty ? alert.details : alert.description,
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
    
    // Carrega os dados do dashboard após o primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }
  
  /// Carrega os dados do dashboard baseado no contexto de trabalho
  void _loadDashboardData() {
    final workContext = ref.read(workContextProvider);
    final storeId = workContext.context.currentStoreId;
    if (workContext.isLoaded && storeId != null && storeId.isNotEmpty) {
      ref.read(dashboardProvider.notifier).loadDashboard(storeId);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _bottomNavScrollController.dispose();
    super.dispose();
  }

  // OTIMIZAÇÃO: Reduzir cálculos e chamadas MediaQuery
  void _scrollToSelectedItem() {
    if (!ResponsiveHelper.isMobile(context)) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_bottomNavScrollController.hasClients) return;
      
      const itemWidth = 90.0; // largura aproximada de cada item
      const totalItems = 10; // _menuItems.length (constante)
      final screenWidth = MediaQuery.sizeOf(context).width; // OTIMIZAÇÃO: sizeOf é mais rápido
      final currentScroll = _bottomNavScrollController.offset;
      final itemPosition = _selectedIndex * itemWidth;
      final itemEnd = itemPosition + itemWidth;
      
      // Detectar se clicou nos extremos (primeiros 3 ou últimos 3)
      final isFirstThree = _selectedIndex < 3;
      final isLastThree = _selectedIndex >= (totalItems - 3);
      
      double targetScroll;
      
      if (isFirstThree) {
        // Clicou nos primeiros 3 → rolar para o início (mostrando até 3 menus)
        targetScroll = 0.0;
      } else if (isLastThree) {
        // Clicou nos últimos 3 → rolar para o final (mostrando até 3 menus)
        targetScroll = _bottomNavScrollController.position.maxScrollExtent;
      } else {
        // Clicou no meio → centralizar o item ou rolar para deixar visível
        final isLeftVisible = itemPosition >= currentScroll;
        final isRightVisible = itemEnd <= (currentScroll + screenWidth);
        final isFullyVisible = isLeftVisible && isRightVisible;
        
        if (!isFullyVisible) {
          if (itemPosition < currentScroll) {
            // Item à esquerda → rolar para trás 3 menus
            targetScroll = (itemPosition - (itemWidth * 2)).clamp(0.0, _bottomNavScrollController.position.maxScrollExtent);
          } else {
            // Item à direita → rolar para frente 3 menus
            targetScroll = (itemPosition - screenWidth + (itemWidth * 3)).clamp(0.0, _bottomNavScrollController.position.maxScrollExtent);
          }
        } else {
          return; // Já está visível, não rolar
        }
      }
      
      _bottomNavScrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  // Keys para forçar rebuild quando clicar no mesmo menu
  Key _getScreenKey(String prefix) {
    return Key('${prefix}_$_rebuildCounter');
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return ProdutosDashboardScreen(key: _getScreenKey('produtos'));
      case 2:
        return TagsDashboardScreen(key: _getScreenKey('etiquetas'));
      case 3:
        return EstrategiasMenuScreen(key: _getScreenKey('estrategias'));
      case 4:
        return SincronizacaoControleScreen(key: _getScreenKey('sincronizacao'));
      case 5:
        return PrecificacaoMenuScreen(key: _getScreenKey('precificacao'));
      case 6:
        return CategoriasMenuScreen(key: _getScreenKey('categorias'));
      case 7:
        return ImportacaoMenuScreen(key: _getScreenKey('importacao'));
      case 8:
        return RelatoriosMenuScreen(key: _getScreenKey('relatorios'));
      case 9:
        return ConfiguracoesMenuScreen(key: _getScreenKey('configuracoes'));
      default:
        return _buildDashboardContent();
    }
  }
  
  // OTIMIZAÇÃO REMOVIDA: Não recriar GlobalKeys (causava rebuilds completos das telas)
  // GlobalKeys agora são final e persistem durante toda vida útil do widget

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      // Drawer para mobile - usando widget extraído
      drawer: isMobile ? DashboardMobileDrawer(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        fadeController: _fadeController,
      ) : null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeColors.of(context).grey50,
              ThemeColors.of(context).grey100,
              ThemeColors.of(context).grey200,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // AppBar usando widget extraído
              DashboardAppBar(
                onNotificationTap: _onNotificationTap,
                onLogout: _onLogout,
                onProfileTap: _onProfileTap,
                onHelpTap: _onHelpTap,
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Navigation rail apenas para tablet e desktop - usando widget extraído
                    if (!isMobile) DashboardNavigationRail(
                      selectedIndex: _selectedIndex,
                      isExpanded: _isRailExpanded,
                      onItemSelected: _onItemSelected,
                      onToggleExpand: _onToggleRailExpand,
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
      // Bottom navigation para mobile - usando widget extraído
      bottomNavigationBar: isMobile ? DashboardMobileBottomNav(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        scrollController: _bottomNavScrollController,
        fadeController: _fadeController,
      ) : null,
    );
  }
  
  // Callbacks para os widgets de navegação
  void _onItemSelected(int index, {bool fromDrawer = false}) {
    if (index == _selectedIndex) {
      // Clicou no mesmo menu - força rebuild para voltar ao dashboard do módulo
      setState(() => _rebuildCounter++);
    } else {
      setState(() => _selectedIndex = index);
    }
    // Reinicia animação de fade
    _fadeController.reset();
    _fadeController.forward();
  }
  
  void _onToggleRailExpand() {
    setState(() => _isRailExpanded = !_isRailExpanded);
  }
  
  void _onNotificationTap() {
    // Navega para tela de notificações (index 9 = Settings > Notificações)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notificações em breve'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
  
  void _onLogout() {
    // Mostra diálogo de confirmação de logout
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair do sistema?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Limpa dados e volta para login
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).redMain,
              foregroundColor: ThemeColors.of(context).surface,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
  
  void _onProfileTap() {
    // Navega para tela de perfil/configurações
    _onItemSelected(9); // Index 9 = Configurações
  }
  
  void _onHelpTap() {
    // Mostra diálogo de ajuda
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline_rounded, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('Ajuda'),
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
            Text('Suporte: suporte@tagbean.com.br'),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // MÉTODOS DE NAVEGAÇÃO REMOVIDOS - Agora usamos widgets extraídos:
  // - DashboardMobileDrawer (widgets/navigation/dashboard_mobile_drawer.dart)
  // - DashboardMobileBottomNav (widgets/navigation/dashboard_mobile_bottom_nav.dart)
  // - DashboardAppBar (widgets/navigation/dashboard_app_bar.dart)
  // - DashboardNavigationRail (widgets/navigation/dashboard_navigation_rail.dart)
  //
  // Métodos removidos: _buildMobileDrawer, _buildMobileBottomNav, _buildModernAppBar,
  // _buildSearchBar, _buildNotificationButton, _buildConnectionStatus, 
  // _buildUserMenu, _buildModernNavigationRail(context, ~880 linhas)
  // ============================================================================

  // ignore: unused_element
  Widget _buildMobileBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          controller: _bottomNavScrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_menuItems.length, (index) {
              final item = _menuItems[index];
              final isSelected = _selectedIndex == index;
              
              return RepaintBoundary(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                onTap: () {
                  if (_selectedIndex != index) {
                    setState(() {
                      _selectedIndex = index;
                      _fadeController.reset();
                      _fadeController.forward();
                    });
                    // Fazer scroll apenas se necessário
                    _scrollToSelectedItem();
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        // ignore: argument_type_not_assignable
                        ? LinearGradient(colors: item['gradient'])
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        // ignore: argument_type_not_assignable
                        item['icon'],
                        color: isSelected
                            ? ThemeColors.of(context).surface
                            : ThemeColors.of(context).grey600,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (item['title']).toString(),
                        style: TextStyle(
                          color: isSelected
                              ?  ThemeColors.of(context).surface
                              : ThemeColors.of(context).grey600,
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildModernAppBar(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      height: isMobile ? 60 : (isTablet ? 65 : 70),
      margin: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 12,
          tablet: 14,
          desktop: 16,
        ),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.08),
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
        ),
        child: Row(
          children: [
            // Menu button para mobile
            if (isMobile)
              IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            if (isMobile) const SizedBox(width: 4),
            // Logo
            Container(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 6,
                  tablet: 7,
                  desktop: 8,
                ),
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [ThemeColors.of(context).moduleDashboard, ThemeColors.of(context).moduleDashboardDark],
                ),
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              child: Icon(
                Icons.storefront_rounded,
                color: ThemeColors.of(context).surface,
                size: ResponsiveHelper.getResponsiveIconSize(
                  context,
                  mobile: 20,
                  tablet: 22,
                  desktop: 24,
                ),
              ),
            ),
            SizedBox(
              width: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              ),
            ),
            if (! isMobile)
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TagBeans',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 18,
                        tabletFontSize: 17,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Sistema de Gestão',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        tabletFontSize: 10,
                      ),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).grey600,
                    ),
                  ),
                ],
              ),
            // Seletor de Loja (WorkContext)
            SizedBox(
              width: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 4,
                tablet: 8,
                desktop: 12,
              ),
            ),
            const Expanded(child: StoreSelector()),
            // Search bar apenas para desktop
            if (!isMobile && ! isTablet) ...[
              const SizedBox(width: 8),
              _buildSearchBar(context),
            ],
            _buildNotificationButton(context),
            SizedBox(
              width: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 8,
                tablet: 12,
                desktop: 16,
              ),
            ),
            if (! isMobile) _buildConnectionStatus(context),
            if (!isMobile)
              SizedBox(
                width: ResponsiveHelper.getResponsivePadding(
                  context,
                  tablet: 12,
                  desktop: 16,
                ),
              ),
            _buildUserMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final searchWidth = screenWidth < 600 ? screenWidth * 0.6 : 300.0;
    
    return Container(
      width: searchWidth,
      height: 42,
      decoration: BoxDecoration(
        color: ThemeColors.of(context).grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar produtos, tags...',
          hintStyle: TextStyle(fontSize: 13, color: ThemeColors.of(context).grey500),
          prefixIcon: Icon(Icons.search_rounded, color: ThemeColors.of(context).grey400, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).errorBackground,
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
      ),
      child: IconButton(
        icon: Badge(
          label: Text(
            '${_alertas.length}',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 10,
                mobileFontSize: 9,
              ),
            overflow: TextOverflow.ellipsis,
            ),
          ),
          backgroundColor: ThemeColors.of(context).redMain,
          child: Icon(
            Icons.notifications_rounded,
            color: ThemeColors.of(context).errorLight,
            size: ResponsiveHelper.getResponsiveIconSize(
              context,
              mobile: 20,
              tablet: 21,
              desktop: 22,
            ),
          ),
        ),
        onPressed: () {
          _showNotificationsPanel(context);
        },
      ),
    );
  }

  Widget _buildConnectionStatus(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(
          context,
          tablet: 10,
          desktop: 12,
        ),
        vertical: ResponsiveHelper.getResponsivePadding(
          context,
          tablet: 6,
          desktop: 8,
        ),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).green50,
        borderRadius: BorderRadius.circular(isTablet ? 10 : 12),
        border: Border.all(color: ThemeColors.of(context).green200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isTablet ? 7 : 8,
            height: isTablet ? 7 : 8,
            decoration: BoxDecoration(
              color: ThemeColors.of(context).greenMaterial,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).greenMaterial.withValues(alpha: 0.5),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.getResponsivePadding(
              context,
              tablet: 6,
              desktop: 8,
            ),
          ),
          Text(
            'ERP Conectado',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                tabletFontSize: 11,
              ),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
              color: ThemeColors.of(context).green700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserMenu(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return PopupMenuButton(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 6,
            tablet: 8,
            desktop: 10,
          ),
          vertical: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 4,
            tablet: 5,
            desktop: 6,
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ThemeColors.of(context).grey200, ThemeColors.of(context).grey300],
          ),
          borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: isMobile ? 12 : 14,
              backgroundColor: ThemeColors.of(context).surface,
              child: Text(
                'A',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 12,
                    mobileFontSize: 11,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).grey700,
                ),
              ),
            ),
            if (!isMobile) ...[
              SizedBox(
                width: ResponsiveHelper.getResponsivePadding(
                  context,
                  tablet: 5,
                  desktop: 6,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Admin',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        tabletFontSize: 10,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Administrador',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 9,
                        tabletFontSize: 8,
                      ),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).grey600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 3),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: ResponsiveHelper.getResponsiveIconSize(
                  context,
                  tablet: 15,
                  desktop: 16,
                ),
                color: ThemeColors.of(context).grey600,
              ),
            ],
          ],
        ),
      ),
      itemBuilder: (context) => [
        _buildPopupMenuItem(Icons.person_rounded, 'Meu Perfil', 'profile'),
        _buildPopupMenuItem(Icons.help_rounded, 'Ajuda & Suporte', 'help'),
        const PopupMenuDivider(),
        _buildPopupMenuItem(Icons.logout_rounded, 'Sair', 'logout', isDestructive: true),
      ],
      onSelected: (value) {
        if (value == 'logout') {
          _showLogoutDialog(context);
        }
      },
    );
  }

  PopupMenuEntry _buildPopupMenuItem(IconData icon, String text, String value,
      {bool isDestructive = false}) {
    return PopupMenuItem(
      value: value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isDestructive ? ThemeColors.of(context).redMain : ThemeColors.of(context).grey700,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isDestructive ? ThemeColors.of(context).redMain : ThemeColors.of(context).grey800,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildModernNavigationRail(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final railWidth = isTablet ? (_isRailExpanded ? 200 : 70) : (_isRailExpanded ? 240 : 80);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: railWidth.toDouble(),
      margin: EdgeInsets.only(
        left: ResponsiveHelper.getResponsivePadding(
          context,
          tablet: 12,
          desktop: 16,
        ),
        right: ResponsiveHelper.getResponsivePadding(
          context,
          tablet: 6,
          desktop: 8,
        ),
        bottom: ResponsiveHelper.getResponsivePadding(
          context,
          tablet: 12,
          desktop: 16,
        ),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.08),
            blurRadius: isTablet ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: ResponsiveHelper.getResponsivePadding(
              context,
              tablet: 12,
              desktop: 16,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _isRailExpanded = !_isRailExpanded;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsivePadding(
                  context,
                  tablet: 12,
                  desktop: 16,
                ),
                vertical: ResponsiveHelper.getResponsivePadding(
                  context,
                  tablet: 6,
                  desktop: 8,
                ),
              ),
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(
                  context,
                  tablet: 10,
                  desktop: 12,
                ),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).grey100,
                borderRadius: BorderRadius.circular(isTablet ? 10 : 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isRailExpanded ?  Icons.menu_open_rounded : Icons.menu_rounded,
                    color: ThemeColors.of(context).grey700,
                    size: ResponsiveHelper.getResponsiveIconSize(
                      context,
                      tablet: 22,
                      desktop: 24,
                    ),
                  ),
                  if (_isRailExpanded) ...[
                    SizedBox(
                      width: ResponsiveHelper.getResponsivePadding(
                        context,
                        tablet: 6,
                        desktop: 8,
                      ),
                    ),
                    Text(
                      'Menu',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.of(context).grey700,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          tabletFontSize: 13,
                        ),
                      overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsivePadding(
              context,
              tablet: 6,
              desktop: 8,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsivePadding(
                  context,
                  tablet: 10,
                  desktop: 12,
                ),
              ),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = _selectedIndex == index;
                
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveHelper.getResponsivePadding(
                      context,
                      tablet: 3,
                      desktop: 4,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (_selectedIndex != index) {
                        setState(() {
                          _selectedIndex = index;
                          _fadeController.reset();
                          _fadeController.forward();
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(isTablet ? 10 : 12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.getResponsivePadding(
                          context,
                          tablet: 12,
                          desktop: 16,
                        ),
                        vertical: ResponsiveHelper.getResponsivePadding(
                          context,
                          tablet: 12,
                          desktop: 14,
                        ),
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            // ignore: argument_type_not_assignable
                            ? LinearGradient(colors: item['gradient'])
                            : null,
                        borderRadius: BorderRadius.circular(isTablet ? 10 : 12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            // ignore: argument_type_not_assignable
                            item['icon'],
                            color: isSelected ?  ThemeColors.of(context).surface : ThemeColors.of(context).grey600,
                            size: ResponsiveHelper.getResponsiveIconSize(
                              context,
                              tablet: 20,
                              desktop: 22,
                            ),
                          ),
                          if (_isRailExpanded) ...[
                            SizedBox(
                              width: ResponsiveHelper.getResponsivePadding(
                                context,
                                tablet: 12,
                                desktop: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                (item['title']).toString(),
                                style: TextStyle(
                                  color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).grey700,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 14,
                                    tabletFontSize: 13,
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final spacing = ResponsiveHelper.getResponsivePadding(
      context,
      mobile: 16,
      tablet: 20,
      desktop: 24,
    );

    // Obtém dados do usuário logado
    final user = ref.watch(currentUserProvider);
    final userName = user?.username ?? 'Usuário';
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1️⃣ HEADER CONTEXTUAL (WelcomeSection já integra sync)
          WelcomeSection(userName: userName),
          SizedBox(height: spacing),
          
          // 🏪 SELETOR DE LOJA (apenas se usuário tem múltiplas lojas)
          StoreSwitcherCard(
            onStoreChanged: () {
              // Recarregar dados do dashboard ao trocar de loja
              _loadDashboardData();
            },
          ),
          SizedBox(height: spacing),
          
          // 🔐 PAINEL ADMINISTRATIVO (PlatformAdmin / ClientAdmin / StoreManager)
          AdminPanelCard(
            onGerenciarClientes: () => _navigateTo(9), // Configurações (com placeholder de clientes)
            onGerenciarLojas: () => _navigateTo(9), // Configurações (com placeholder de lojas)
            onGerenciarUsuarios: () => _navigateTo(9), // Configurações → Usuários
            onVerConfiguracoes: () => _navigateTo(9), // Configurações
          ),
          SizedBox(height: spacing),
          
          // 🆕 PRIMEIROS PASSOS (para usuários novos - substitui atalhos de teclado)
          OnboardingStepsCard(
            onImportProducts: () => _navigateTo(7), // Importação
            onRegisterTags: () => _navigateTo(2), // Etiquetas
            onBindTags: () => _navigateTo(2), // Etiquetas
            onActivateStrategy: () => _navigateTo(3), // Estratégias
            onConfigureStore: () => _navigateTo(9), // Configurações
          ),
          SizedBox(height: spacing),
          
          // 🆕 PRÓXIMA AÇÃO RECOMENDADA (IA sugere o que fazer)
          NextActionCard(
            onImportProducts: () => _navigateTo(7),
            onAddProduct: () => _navigateTo(1),
            onRegisterTag: () => _navigateTo(2),
            onBindTag: () => _navigateTo(2),
            onViewOfflineTags: () => _navigateTo(2),
            onSetPrices: () => _navigateTo(5),
            onActivateStrategy: () => _navigateTo(3),
            onDoLater: () {}, // Dismiss
          ),
          SizedBox(height: spacing),
          
          // BLOCO 1: STATUS GERAL DO SISTEMA
          StatusGeralSistemaCard(
            onForcarSincronizacao: () => _forcarSincronizacao(),
            onVerTagsOffline: () => _navigateTo(2), // Etiquetas
            onCorrigirProdutos: () => _navigateTo(5), // Precificação
            onVerErpStatus: () => _showErpStatusDialog(),
          ),
          SizedBox(height: spacing),
          
          // 2️⃣ ALERTAS ACIONÁVEIS (só aparece se houver alertas)
          AlertasAcionaveisCard(
            onVerTodos: () => _showAlertasDialog(),
            onVerTags: () => _navigateTo(2),
            onVerProdutos: () => _navigateTo(1),
            onVerProdutosSemPreco: () => _navigateTo(5), // Precificação
            onAgendarTroca: () => _navigateTo(2), // Tags
          ),
          SizedBox(height: spacing),
          
          // 🆕 BLOCO 4: FLUXOS INTELIGENTES (se houver pendências)
          FluxosInteligentesCard(
            onVincularTag: () => _navigateTo(2),
            onCriarProduto: () => _navigateTo(1),
            onVerErros: () => _navigateTo(7), // Importação
            onVerPendencias: () => _showFluxosPendentesDialog(),
          ),
          SizedBox(height: spacing),
          
          // Layout responsivo para mobile vs desktop
          if (isMobile)
            _buildMobileLayout(spacing)
          else
            _buildDesktopLayout(spacing, isTablet),
          
          // 🆕 ATIVIDADE RECENTE (histórico do que aconteceu)
          SizedBox(height: spacing),
          RecentActivityDashboardCard(
            onViewAll: () => _navigateTo(8), // Relatórios
          ),
        ],
      ),
    );
  }

  /// Layout para dispositivos móveis - tudo empilhado verticalmente
  Widget _buildMobileLayout(double spacing) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 3️⃣ RESUMO DO DIA
        ResumoDoDoaCard(
          onVerDashboardCompleto: () => _navigateTo(8), // Relatórios
          onVerProdutos: () => _navigateTo(1),
          onVerVinculacao: () => _navigateTo(2),
        ),
        SizedBox(height: spacing),
        
        // 4️⃣ AÇÕES FREQUENTES
        AcoesFrequentesCard(
          onVincularTag: () => _navigateTo(2),
          onAtualizarPrecos: () => _navigateTo(5),
          onAdicionarProduto: () => _navigateTo(1),
          onVerRelatorio: () => _navigateTo(8),
        ),
        SizedBox(height: spacing),
        
        // 5️⃣ OPORTUNIDADES DE LUCRO (IA)
        OportunidadesLucroCard(
          onRevisarSugestoes: () => _navigateTo(3), // Estratégias
          onAplicarAutomatico: () => _showAplicarSugestoesDialog(),
        ),
        SizedBox(height: spacing),
        
        // 6️⃣ ESTRATÉGIAS ATIVAS
        EstrategiasAtivasCard(
          onGerenciar: () => _navigateTo(3),
        ),
      ],
    );
  }

  /// Layout para desktop/tablet - 2 colunas
  Widget _buildDesktopLayout(double spacing, bool isTablet) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primeira linha: Resumo + Ações (altura uniforme)
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 3️⃣ RESUMO DO DIA
              Expanded(
                flex: 1,
                child: ResumoDoDoaCard(
                  onVerDashboardCompleto: () => _navigateTo(8),
                  onVerProdutos: () => _navigateTo(1),
                  onVerVinculacao: () => _navigateTo(2),
                ),
              ),
              SizedBox(width: spacing),
              
              // 4️⃣ AÇÕES FREQUENTES
              Expanded(
                flex: 1,
                child: AcoesFrequentesCard(
                  onVincularTag: () => _navigateTo(2),
                  onAtualizarPrecos: () => _navigateTo(5),
                  onAdicionarProduto: () => _navigateTo(1),
                  onVerRelatorio: () => _navigateTo(8),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing),
        
        // 5️⃣ OPORTUNIDADES DE LUCRO (IA) - largura total
        OportunidadesLucroCard(
          onRevisarSugestoes: () => _navigateTo(3),
          onAplicarAutomatico: () => _showAplicarSugestoesDialog(),
        ),
        SizedBox(height: spacing),
        
        // 6️⃣ ESTRATÉGIAS ATIVAS - largura total
        EstrategiasAtivasCard(
          onGerenciar: () => _navigateTo(3),
        ),
      ],
    );
  }

  /// Dialog para aplicar sugestões automaticamente
  void _showAplicarSugestoesDialog() {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        ),
        icon: Icon(
          Icons.auto_awesome_rounded,
          color: ThemeColors.of(context).greenMaterial,
          size: 48,
        ),
        title: const Text('Aplicar Sugestões da IA'),
        content: const Text(
          'Deseja aplicar automaticamente todas as sugestões de ajuste de preço?\n\n'
          'Esta ação irá atualizar os preços de todos os produtos recomendados.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar aplicação de sugestões
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface),
                      const SizedBox(width: 12),
                      const Expanded(child: Text('Sugestões aplicadas com sucesso!')),
                    ],
                  ),
                  backgroundColor: ThemeColors.of(context).greenMain,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).greenMaterial,
            ),
            child: const Text('Aplicar Todas'),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildWelcomeSection(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final hour = DateTime.now().hour;
    String greeting = 'Bom dia';
    IconData greetingIcon = Icons.wb_sunny_rounded;
    
    if (hour >= 12 && hour < 18) {
      greeting = 'Boa tarde';
      greetingIcon = Icons.wb_twilight_rounded;
    } else if (hour >= 18) {
      greeting = 'Boa noite';
      greetingIcon = Icons.nightlight_round;
    }

    return Container(
      padding: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 16,
          tablet: 18,
          desktop: 20,
        ),
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ThemeColors.of(context).moduleDashboard, ThemeColors.of(context).moduleDashboardDark],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : (isTablet ? 14 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).moduleDashboard.withValues(alpha: 0.3),
            blurRadius: isMobile ? 15 : 20,
            offset: Offset(0, isMobile ? 8 : 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      greetingIcon,
                      color: ThemeColors.of(context).surfaceOverlay90,
                      size: ResponsiveHelper.getResponsiveIconSize(
                        context,
                        mobile: 18,
                        tablet: 19,
                        desktop: 20,
                      ),
                    ),
                    SizedBox(
                      width: ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 6,
                        tablet: 7,
                        desktop: 8,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '$greeting, Admin!',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 22,
                            mobileFontSize: 18,
                            tabletFontSize: 20,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).surface,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 3,
                    tablet: 4,
                    desktop: 4,
                  ),
                ),
                Text(
                  'TagBeans Store • ${_formatDate(DateTime.now())}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 11,
                      tabletFontSize: 12,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).surfaceOverlay90,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 6,
                    tablet: 7,
                    desktop: 8,
                  ),
                ),
                Text(
                  'Tudo funcionando perfeitamente.  Sistema sincronizado há 3 horas.',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 10,
                      tabletFontSize: 11,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).surfaceOverlay80,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildCompactMetricsGrid(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    final estatisticas = [
      {'label': 'Produtos Ativos', 'valor': '1.234', 'icon': Icons.inventory_2_rounded, 'cor': ThemeColors.of(context).blueMaterial, 'mudanca': '+12%', 'tipo': 'aumento'},
      {'label': 'Tags Criadas', 'valor': '987', 'icon': Icons.label_rounded, 'cor': ThemeColors.of(context).blueCyan, 'mudanca': '+8%', 'tipo': 'aumento'},
      {'label': 'Sincronizações', 'valor': '42', 'icon': Icons.sync_rounded, 'cor': ThemeColors.of(context).blueCyan, 'mudanca': '+3', 'tipo': 'aumento'},
      {'label': 'Categorias', 'valor': '156', 'icon': Icons.category_rounded, 'cor': ThemeColors.of(context).blueCyan, 'mudanca': '+5%', 'tipo': 'aumento'},
    ];

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt.get(isMobile, ResponsiveHelper.isTablet(context))),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, ResponsiveHelper.isTablet(context))),
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
        children: [
          isMobile && !ResponsiveHelper.isLandscape(context)
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildDashboardStatCard(context, estatisticas[0])),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                        Expanded(child: _buildDashboardStatCard(context, estatisticas[1])),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                    Row(
                      children: [
                        Expanded(child: _buildDashboardStatCard(context, estatisticas[2])),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                        Expanded(child: _buildDashboardStatCard(context, estatisticas[3])),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: estatisticas.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stat = entry.value;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index < estatisticas.length - 1 ? 12 : 0),
                        child: _buildDashboardStatCard(context, stat),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildDashboardStatCard(BuildContext context, Map<String, dynamic> stat) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, ResponsiveHelper.isTablet(context))),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              (stat['cor'] as Color).withValues(alpha: 0.1),
              (stat['cor'] as Color).withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, ResponsiveHelper.isTablet(context))),
          border: Border.all(
            color: (stat['cor'] as Color).withValues(alpha: 0.3),
            width: AppSizes.borderWidthResponsive.get(isMobile, ResponsiveHelper.isTablet(context)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              // ignore: argument_type_not_assignable
              stat['icon'],
              // ignore: argument_type_not_assignable
              color: stat['cor'],
              size: AppSizes.iconMediumLarge.get(isMobile, ResponsiveHelper.isTablet(context)),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
            Text(
              (stat['valor']).toString(),
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                // ignore: argument_type_not_assignable
                color: stat['cor'],
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
            Text(
              (stat['label']).toString(),
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9, tabletFontSize: 9.5),
                overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 5, tablet: 5.5, desktop: 6),
                vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 2.5, tablet: 2.75, desktop: 3),
              ),
              decoration: BoxDecoration(
                color: (stat['cor'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, ResponsiveHelper.isTablet(context))),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (stat['tipo'] == 'aumento')
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 9, tablet: 9.5, desktop: 10),
                      // ignore: argument_type_not_assignable
                      color: stat['cor'],
                    ),
                  if (stat['tipo'] == 'aumento')
                    SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 2.5, tablet: 2.75, desktop: 3)),
                  Flexible(
                    child: Text(
                      (stat['mudanca']).toString(),
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 9, mobileFontSize: 8, tabletFontSize: 8.5),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        // ignore: argument_type_not_assignable
                        color: stat['cor'],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildCompactMetricCard(BuildContext context, 
    String title,
    String value,
    IconData icon,
    List<Color> gradient,
    String trend) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    // OTIMIZAÇÃO: RepaintBoundary para isolar repaints
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 12 : (isTablet ? 14 : 16),
          ),
          // OTIMIZAÇÃO: Reduzir blur de sombra para melhor performance
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.08),
              blurRadius: isMobile ? 6 : 10,  // Reduzido de 10/15
              offset: const Offset(0, 2),  // Reduzido de (0, 4)
            ),
          ],
        ),
        child: Padding(
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 8,
            tablet: 10,
            desktop: 12,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 3,
                      tablet: 4,
                      desktop: 4,
                    ),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(
                      isMobile ? 10 : (isTablet ? 12 : 14),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: ThemeColors.of(context).surface,
                    size: ResponsiveHelper.getResponsiveIconSize(
                      context,
                      mobile: 14,
                      tablet: 18,
                      desktop: 16,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getResponsiveSpacing(
                  context,
                  mobile: 3,
                  tablet: 4,
                  desktop: 5,
                )),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: TextStyle(
                        height: 1.1,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 13,
                          mobileFontSize: 11,
                          tabletFontSize: 12,
                        ),
                        color: ThemeColors.of(context).grey600,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getResponsiveSpacing(
                  context,
                  mobile: 2,
                  tablet: 3,
                  desktop: 4,
                )),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,
                      style: TextStyle(
                        height: 1.0,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 19,
                          mobileFontSize: 16,
                          tabletFontSize: 18,
                        ),
                        color: ThemeColors.of(context).grey900,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        ),
      ),
    );  // Fechamento do RepaintBoundary
  }

  // ignore: unused_element
  Widget _buildEstrategiasMetricCard(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    // Dados do card
    final produtosComEstrategia = _estrategiasData['produtos_afetados'] as int;

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 12 : (isTablet ? 14 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.of(context).moduleEstrategias.withValues(alpha: 0.08),
              blurRadius: isMobile ? 6 : 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 8,
              tablet: 10,
              desktop: 12,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 3,
                        tablet: 4,
                        desktop: 4,
                      ),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ThemeColors.of(context).moduleEstrategias, ThemeColors.of(context).moduleEstrategiasDark],
                      ),
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : (isTablet ? 12 : 14),
                      ),
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: ThemeColors.of(context).surface,
                      size: ResponsiveHelper.getResponsiveIconSize(
                        context,
                        mobile: 14,
                        tablet: 18,
                        desktop: 16,
                      ),
                    ),
                  ),
              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 3,
                tablet: 4,
                desktop: 5,
              )),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Produtos',
                    style: TextStyle(
                      height: 1.1,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 13,
                        mobileFontSize: 11,
                        tabletFontSize: 12,
                      ),
                      color: ThemeColors.of(context).grey600,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 2,
                tablet: 3,
                desktop: 4,
              )),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '$produtosComEstrategia',
                    style: TextStyle(
                      height: 1.0,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 19,
                        mobileFontSize: 16,
                        tabletFontSize: 18,
                      ),
                      color: ThemeColors.of(context).grey900,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 1,
                tablet: 2,
                desktop: 2,
              )),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Estratégias Ativas',
                    style: TextStyle(
                      height: 1.0,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 8,
                        mobileFontSize: 7,
                        tabletFontSize: 7,
                      ),
                      color: ThemeColors.of(context).grey500,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildEstrategiasLucroCard(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ThemeColors.of(context).successLight, ThemeColors.of(context).materialTeal],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).greenMaterial.withValues(alpha: 0.3),
            blurRadius: isMobile ? 20 : 25,
            offset: Offset(0, isMobile ? 8 : 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 3,
            tablet: 8,
            desktop: 10,
          ),
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
                      mobile: 3,
                      tablet: 6,
                      desktop: 8,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).surfaceOverlay20,
                    borderRadius: BorderRadius.circular(
                      isMobile ? 8 : 10,
                    ),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: ThemeColors.of(context).surface,
                    size: ResponsiveHelper.getResponsiveIconSize(
                      context,
                      mobile: 16,
                      tablet: 20,
                      desktop: 22,
                    ),
                  ),
                ),
                SizedBox(
                  width: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 3,
                    tablet: 8,
                    desktop: 10,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lucro com Estratégias',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 18,
                            mobileFontSize: 14,
                            tabletFontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).surface,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsivePadding(
                          context,
                          mobile: 1,
                          tablet: 2,
                          desktop: 2,
                        ),
                      ),
                      Text(
                        '${_estrategiasData['ativas']} estratégias ativas',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 15,
                            mobileFontSize: 13,
                            tabletFontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).surfaceOverlay90,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 3,
                        tablet: 6,
                        desktop: 8,
                      ),
                      vertical: ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 2,
                        tablet: 4,
                        desktop: 5,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).surfaceOverlay20,
                      borderRadius: BorderRadius.circular(
                        isMobile ? 6 : 10,
                      ),
                      border: Border.all(color: ThemeColors.of(context).surfaceOverlay30),
                    ),
                    child: Text(
                      (_estrategiasData['crescimento']).toString(),
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 11,
                          tabletFontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 12,
                tablet: 14,
                desktop: 16,
              ),
            ),
            Container(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 8,
                  tablet: 9,
                  desktop: 10,
                ),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).surfaceOverlay15,
                borderRadius: BorderRadius.circular(
                  isMobile ? 14 : 16,
                ),
                border: Border.all(color: ThemeColors.of(context).surfaceOverlay30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildGanhoInfo(context, 'Ganho Mensal',
                      Icons.calendar_month_rounded,
                      'R\$ ${_estrategiasData['ganho_mensal'].toStringAsFixed(2)}',
                      'em ${_estrategiasData['produtos_afetados']} produtos',
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 8,
                      tablet: 12,
                      desktop: 16,
                    ),
                  ),
                  Expanded(
                    child: _buildGanhoInfo(context, 'Ganho Hoje',
                      Icons.today_rounded,
                      'R\$ ${_estrategiasData['ganho_hoje'].toStringAsFixed(2)}',
                      '+15% vs. ontem',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGanhoInfo(BuildContext context, String title, IconData icon, String value, String subtitle) {
    // ignore: unused_local_variable
    final isMobile = ResponsiveHelper.isMobile(context);
    // ignore: unused_local_variable
    final isTablet = ResponsiveHelper.isTablet(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 1,
          tablet: 1.5,
          desktop: 2,
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
                icon,
                color: ThemeColors.of(context).surfaceOverlay90,
                size: ResponsiveHelper.getResponsiveIconSize(
                  context,
                  mobile: 15,
                  tablet: 16,
                  desktop: 17,
                ),
              ),
              SizedBox(
                width: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 2,
                  tablet: 2.5,
                  desktop: 3,
                ),
              ),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                      tabletFontSize: 12.5,
                    ),
                    color: ThemeColors.of(context).surfaceOverlay90,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 1,
              tablet: 1.5,
              desktop: 2,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 17,
                mobileFontSize: 15,
                tabletFontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).surface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 1),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title == 'Ganho Hoje')
                Icon(
                  Icons.trending_up_rounded,
                  color: ThemeColors.of(context).surfaceOverlay80,
                  size: 7,
                ),
              if (title == 'Ganho Hoje') const SizedBox(width: 2),
              Flexible(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).surfaceOverlay80,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildSugestoesIACard(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Obtém contagem de produtos afetados pelas estratégias ativas
    final strategiesState = ref.watch(strategiesProvider);
    final strategiesStats = ref.watch(strategiesStatsProvider);
    // ignore: unused_local_variable
    final activeStrategies = strategiesState.strategies.where((s) => s.status.isActive).toList();
    final affectedProducts = strategiesStats.affectedProductsCount;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SugestoesIaScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ThemeColors.of(context).moduleRelatorios, ThemeColors.of(context).moduleRelatoriosDark],
          ),
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.of(context).moduleRelatorios.withValues(alpha: 0.3),
              blurRadius: isMobile ? 20 : 25,
              offset: Offset(0, isMobile ? 8 : 10),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 8,
              tablet: 12,
              desktop: 14,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                Container(
                    padding: EdgeInsets.all(
                      ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 6,
                        tablet: 8,
                        desktop: 10,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).surfaceOverlay20,
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                    child: Icon(
                      Icons.auto_fix_high_rounded,
                      color: ThemeColors.of(context).surface,
                      size: ResponsiveHelper.getResponsiveIconSize(
                        context,
                        mobile: 18,
                        tablet: 20,
                        desktop: 22,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 6,
                      tablet: 10,
                      desktop: 12,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sugestões Inteligentes',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 18,
                              mobileFontSize: 14,
                              tabletFontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).surface,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsivePadding(
                            context,
                            mobile: 2,
                            tablet: 3,
                            desktop: 3,
                          ),
                        ),
                        Text(
                          'IA analisou e sugere ajustes em $affectedProducts produtos',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 12,
                              mobileFontSize: 10,
                              tabletFontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                            color: ThemeColors.of(context).surfaceOverlay90,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 4,
                      tablet: 6,
                      desktop: 8,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 6,
                        tablet: 8,
                        desktop: 9,
                      ),
                      vertical: ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 3,
                        tablet: 4,
                        desktop: 5,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).redMain,
                      borderRadius: BorderRadius.circular(
                        isMobile ? 6 : 8,
                      ),
                    ),
                    child: Text(
                      'NOVO',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 10,
                          mobileFontSize: 8,
                          tabletFontSize: 9,
                        ),
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildSugestaoTag(
                      Icons.trending_up_rounded,
                      '23 aumentos',
                      ThemeColors.of(context).successBackground,
                      ThemeColors.of(context).green700,
                    ),
                  ),
                  SizedBox(width: isMobile ? 8 : 10),
                  Expanded(
                    child: _buildSugestaoTag(
                      Icons.trending_down_rounded,
                      '24 promoções',
                      ThemeColors.of(context).orange100,
                      ThemeColors.of(context).warningDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSugestaoTag(IconData icon, String text, Color bgColor, Color textColor) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 8,
          tablet: 10,
          desktop: 11,
        ),
        vertical: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 6,
          tablet: 7,
          desktop: 8,
        ),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: ResponsiveHelper.getResponsiveIconSize(
              context,
              mobile: 14,
              tablet: 15,
              desktop: 16,
            ),
            color: textColor,
          ),
          SizedBox(width: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 4,
            tablet: 5,
            desktop: 6,
          )),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 11,
                  mobileFontSize: 9,
                  tabletFontSize: 10,
                ),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildEstrategiasDetalhadasCard(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surfaceTinted,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.05),
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        child: Material(
          color: ThemeColors.of(context).transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _isEstrategiasExpanded = !_isEstrategiasExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 14,
                  tablet: 17,
                  desktop: 20,
                ),
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
                            mobile: 8,
                            tablet: 9,
                            desktop: 10,
                          ),
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [ThemeColors.of(context).moduleDashboard, ThemeColors.of(context).moduleDashboardDark],
                          ),
                          borderRadius: BorderRadius.circular(
                            isMobile ? 8 : 10,
                          ),
                        ),
                        child: Icon(
                          Icons.bar_chart_rounded,
                          color: ThemeColors.of(context).surface,
                          size: ResponsiveHelper.getResponsiveIconSize(
                            context,
                            mobile: 18,
                            tablet: 19,
                            desktop: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getResponsivePadding(
                          context,
                          mobile: 10,
                          tablet: 11,
                          desktop: 12,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Performance por Estratégia',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 16,
                              mobileFontSize: 14,
                              tabletFontSize: 15,
                            ),
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      Icon(
                        _isEstrategiasExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: ThemeColors.of(context).grey600,
                        size: 24,
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _isEstrategiasExpanded
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: ResponsiveHelper.getResponsivePadding(
                                  context,
                                  mobile: 12,
                                  tablet: 14,
                                  desktop: 16,
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: (_estrategiasData['estrategias'] as List).length,
                                itemBuilder: (context, index) {
                                  final estrategia = (_estrategiasData['estrategias'] as List)[index];
                                  return RepaintBoundary(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: ResponsiveHelper.getResponsivePadding(
                                          context,
                                          mobile: 10,
                                          tablet: 11,
                                          desktop: 12,
                                        ),
                                      ),
                                      child: _buildEstrategiaItem(context, (estrategia['nome']).toString(),
                                        'R\$ ${estrategia['ganho'].toStringAsFixed(2)}',
                                        '${estrategia['produtos']} produtos',
                                        // ignore: argument_type_not_assignable
                                        estrategia['cor'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEstrategiaItem(BuildContext context, String nome, String ganho, String produtos, Color cor) {
    final isMobile = ResponsiveHelper.isMobile(context);
    // ignore: unused_local_variable
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 12,
          tablet: 13,
          desktop: 14,
        ),
      ),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          isMobile ?  10 : 12,
        ),
        border: Border.all(color: cor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 4,
                tablet: 6,
                desktop: 7,
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cor, cor.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 6 : 7,
              ),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: ThemeColors.of(context).surface,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 12,
                tablet: 14,
                desktop: 15,
              ),
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 5,
              tablet: 8,
              desktop: 9,
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 11,
                      tabletFontSize: 12,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  produtos,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 10,
                      mobileFontSize: 8,
                      tabletFontSize: 9,
                    ),
                    color: ThemeColors.of(context).grey600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    ganho,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 15,
                        mobileFontSize: 12,
                        tabletFontSize: 13,
                      ),
                      fontWeight: FontWeight.bold,
                      color: cor,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 2,
                      tablet: 3,
                      desktop: 3,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 4,
                      tablet: 5,
                      desktop: 5,
                    ),
                    vertical: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 1,
                      tablet: 2,
                      desktop: 2,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: cor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Ativa',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 8,
                        mobileFontSize: 7,
                        tabletFontSize: 7,
                      ),
                      fontWeight: FontWeight.bold,
                      color: cor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildCompactSyncCard(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.05),
            blurRadius: isMobile ? 12 : 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 14,
            tablet: 16,
            desktop: 18,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 8,
                      tablet: 9,
                      desktop: 10,
                    ),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ThemeColors.of(context).moduleSincronizacao, ThemeColors.of(context).moduleSincronizacaoDark],
                    ),
                    borderRadius: BorderRadius.circular(
                      isMobile ? 8 : 10,
                    ),
                  ),
                  child: Icon(
                    Icons.sync_rounded,
                    color: ThemeColors.of(context).surface,
                    size: ResponsiveHelper.getResponsiveIconSize(
                      context,
                      mobile: 18,
                      tablet: 19,
                      desktop: 20,
                    ),
                  ),
                ),
              SizedBox(
                width: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 10,
                  tablet: 11,
                  desktop: 12,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Última Sincronização',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 15,
                          mobileFontSize: 13,
                          tabletFontSize: 14,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 2,
                        tablet: 3,
                        desktop: 3,
                      ),
                    ),
                    Text(
                      'Status: Concluída com sucesso',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 11,
                          mobileFontSize: 9,
                          tabletFontSize: 10,
                        ),
                      overflow: TextOverflow.ellipsis,
                        color: ThemeColors.of(context).greenMaterial,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 6,
                  tablet: 8,
                  desktop: 10,
                ),
              ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.getResponsivePadding(
                          context,
                          mobile: 10,
                          tablet: 11,
                          desktop: 12,
                        ),
                        vertical: ResponsiveHelper.getResponsivePadding(
                          context,
                          mobile: 5,
                          tablet: 6,
                          desktop: 6,
                        ),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [ThemeColors.of(context).moduleSincronizacao, ThemeColors.of(context).moduleSincronizacaoDark],
                        ),
                        borderRadius: BorderRadius.circular(
                          isMobile ? 8 : 10,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                      Icon(
                        Icons.refresh_rounded,
                        color: ThemeColors.of(context).surface,
                        size: ResponsiveHelper.getResponsiveIconSize(
                          context,
                          mobile: 12,
                          tablet: 13,
                          desktop: 14,
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getResponsivePadding(
                          context,
                          mobile: 5,
                          tablet: 6,
                          desktop: 6,
                        ),
                      ),
                      Text(
                        'Sync',
                        style: TextStyle(
                          color: ThemeColors.of(context).surface,
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 12,
                            mobileFontSize: 10,
                            tabletFontSize: 11,
                          ),
                        overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
              height: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 12,
                tablet: 13,
                desktop: 14,
              ),
            ),
            Container(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 10,
                  tablet: 11,
                  desktop: 12,
                ),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).grey50,
                borderRadius: BorderRadius.circular(
                  isMobile ? 8 : 10,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCompactSyncStat(context, '1.234', 'Produtos', Icons.inventory_2_rounded),
                  Container(
                    width: 1,
                    height: isMobile ? 25 : 30,
                    color: ThemeColors.of(context).grey300,
                  ),
                  _buildCompactSyncStat(context, '987', 'Tags', Icons.label_rounded),
                  Container(
                    width: 1,
                    height: isMobile ? 25 : 30,
                    color: ThemeColors.of(context).grey300,
                  ),
                  _buildCompactSyncStat(context, '2.3s', 'Tempo', Icons.speed_rounded),
                ],
              ),
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 8,
                tablet: 9,
                desktop: 10,
              ),
            ),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: ResponsiveHelper.getResponsiveIconSize(
                      context,
                      mobile: 12,
                      tablet: 13,
                      desktop: 14,
                    ),
                    color: ThemeColors.of(context).grey600,
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 5,
                      tablet: 6,
                      desktop: 6,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '23/11/2025 às 14:32',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 11,
                          mobileFontSize: 9,
                          tabletFontSize: 10,
                        ),
                      overflow: TextOverflow.ellipsis,
                        color: ThemeColors.of(context).grey600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactSyncStat(BuildContext context, String value, String label, IconData icon) {
    // ignore: unused_local_variable
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: ResponsiveHelper.getResponsiveIconSize(
            context,
            mobile: 16,
            tablet: 17,
            desktop: 18,
          ),
          color: ThemeColors.of(context).grey600,
        ),
        SizedBox(
          height: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 3,
            tablet: 4,
            desktop: 4,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 12,
              tabletFontSize: 13,
            ),
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 10,
              mobileFontSize: 8,
              tabletFontSize: 9,
            ),
            color: ThemeColors.of(context).grey600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildCompactAlertsCard(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return InkWell(
      onTap: () => _showAlertasDialog(),
      borderRadius: BorderRadius.circular(
        isMobile ? 14 : (isTablet ? 15 : 16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ThemeColors.of(context).errorPastel, ThemeColors.of(context).warningBackground],
          ),
          borderRadius: BorderRadius.circular(
            isMobile ? 14 : (isTablet ?  15 : 16),
          ),
          border: Border.all(color: ThemeColors.of(context).errorLight, width: 2),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.of(context).redMain.withValues(alpha: 0.1),
              blurRadius: isMobile ? 12 : 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 14,
              tablet: 16,
              desktop: 18,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 8,
                        tablet: 9,
                        desktop: 10,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).redMain,
                      borderRadius: BorderRadius.circular(
                        isMobile ? 8 : 10,
                      ),
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      color: ThemeColors.of(context).surface,
                      size: ResponsiveHelper.getResponsiveIconSize(
                        context,
                        mobile: 18,
                        tablet: 19,
                        desktop: 20,
                      ),
                    ),
                  ),
                SizedBox(
                  width: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 10,
                    tablet: 11,
                    desktop: 12,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alertas Pendentes',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 15,
                            mobileFontSize: 13,
                            tabletFontSize: 14,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsivePadding(
                          context,
                          mobile: 2,
                          tablet: 3,
                          desktop: 3,
                        ),
                      ),
                      Text(
                        'Requer atenção imediata',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 11,
                            mobileFontSize: 9,
                            tabletFontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).redMain,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    width: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 6,
                      tablet: 8,
                      desktop: 10,
                    ),
                  ),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        padding: EdgeInsets.all(
                          ResponsiveHelper.getResponsivePadding(
                            context,
                            mobile: 8,
                            tablet: 9,
                            desktop: 10,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).redMain,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${_alertas.length}',
                          style: TextStyle(
                            color: ThemeColors.of(context).surface,
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 14,
                              mobileFontSize: 12,
                              tabletFontSize: 13,
                            ),
                          overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
              ),
              Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 10,
                    tablet: 11,
                    desktop: 12,
                  ),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surface,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 8 : 10,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'Clique para ver todos os alertas',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 12,
                            mobileFontSize: 10,
                            tabletFontSize: 11,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 6,
                        tablet: 7,
                        desktop: 8,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: ResponsiveHelper.getResponsiveIconSize(
                        context,
                        mobile: 14,
                        tablet: 15,
                        desktop: 16,
                      ),
                      color: ThemeColors.of(context).grey700,
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

  // ignore: unused_element
  Widget _buildCompactQuickActionsCard(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.05),
            blurRadius: isMobile ? 12 : 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 14,
            tablet: 16,
            desktop: 18,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ações Rápidas',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 15,
                  mobileFontSize: 13,
                  tabletFontSize: 14,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 12,
                tablet: 13,
                desktop: 14,
              ),
            ),
            _buildCompactQuickActionButton(context, 'Associar Tag',
              Icons.qr_code_scanner_rounded,
              [ThemeColors.of(context).moduleDashboard, ThemeColors.of(context).moduleDashboardDark],
              onTap: () => _navigateTo(2), // Navega para Tags
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 8,
                tablet: 9,
                desktop: 10,
              ),
            ),
            _buildCompactQuickActionButton(context, 'Novo Produto',
              Icons.add_box_rounded,
              [ThemeColors.of(context).moduleProdutos, ThemeColors.of(context).moduleProdutosDark],
              onTap: () => _navegarParaNovoProduto(),
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 8,
                tablet: 9,
                desktop: 10,
              ),
            ),
            _buildCompactQuickActionButton(context, 'Importar Excel',
              Icons.upload_file_rounded,
              [ThemeColors.of(context).modulePrecificacao, ThemeColors.of(context).modulePrecificacaoDark],
              onTap: () => _navegarParaImportacao(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactQuickActionButton(BuildContext context, String text, IconData icon, List<Color> gradient, {required VoidCallback onTap}) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(
          isMobile ? 8 : 10,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: 0.3),
            blurRadius: isMobile ? 6 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: ThemeColors.of(context).transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            isMobile ?  8 : 10,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 12,
                tablet: 13,
                desktop: 14,
              ),
              vertical: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 10,
                tablet: 11,
                desktop: 12,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: ThemeColors.of(context).surface,
                  size: ResponsiveHelper.getResponsiveIconSize(
                    context,
                    mobile: 16,
                    tablet: 17,
                    desktop: 18,
                  ),
                ),
                SizedBox(
                  width: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 8,
                    tablet: 9,
                    desktop: 10,
                  ),
                ),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: ThemeColors.of(context).surface,
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 13,
                        mobileFontSize: 11,
                        tabletFontSize: 12,
                      ),
                    overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: ThemeColors.of(context).surface,
                  size: ResponsiveHelper.getResponsiveIconSize(
                    context,
                    mobile: 14,
                    tablet: 15,
                    desktop: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // NOTA: Método _buildRecentActivityCard() removido
  // O dashboard usa o widget RecentActivityCard que é dinâmico
  // e carrega atividades reais do backend via auditProvider

  void _navigateTo(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        _fadeController.reset();
        _fadeController.forward();
      });
    }
  }

  void _showAlertasDialog() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
        ),
        child: Container(
          width: isMobile ? double.infinity : (isTablet ? 400 : 450),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * (isMobile ? 0.85 : 0.8),
          ),
          padding: EdgeInsets.all(
            ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 12,
              tablet: 22,
              desktop: 26,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                            ResponsiveHelper.getResponsivePadding(
                              context,
                              mobile: 5,
                              tablet: 9,
                              desktop: 10,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: ThemeColors.of(context).redMain,
                            borderRadius: BorderRadius.circular(
                              isMobile ? 5 : 10,
                            ),
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            color: ThemeColors.of(context).surface,
                            size: ResponsiveHelper.getResponsiveIconSize(
                              context,
                              mobile: 14,
                              tablet: 22,
                              desktop: 24,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ResponsiveHelper.getResponsivePadding(
                            context,
                            mobile: 6,
                            tablet: 11,
                            desktop: 12,
                          ),
                        ),
                        Flexible(
                          child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alertas Pendentes',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 16,
                                  mobileFontSize: 12,
                                  tabletFontSize: 15,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Requer atenção imediata',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 11,
                                  mobileFontSize: 8,
                                  tabletFontSize: 10,
                                ),
                                color: ThemeColors.of(context).redMain,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(
                height: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 12,
                  tablet: 18,
                  desktop: 22,
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _alertas.map((alerta) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildAlertItemDetalhado(context, alerta),
                          if (alerta != _alertas.last)
                            Divider(
                              height: ResponsiveHelper.getResponsivePadding(
                                context,
                                mobile: 20,
                                tablet: 22,
                                desktop: 24,
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Força sincronização imediata
  void _forcarSincronizacao() {
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
            const SizedBox(width: 12),
            const Expanded(child: Text('Sincronizando...')),
          ],
        ),
        backgroundColor: ThemeColors.of(context).blueMain,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
    // TODO: Implementar chamada real de sincronização
    ref.read(dashboardProvider.notifier).refresh();
  }

  /// Mostra status do ERP
  void _showErpStatusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(Icons.cloud_done_rounded, color: ThemeColors.of(context).greenMain, size: 48),
        title: const Text('Status do ERP'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusRow(context, 'Conexão', 'Conectado', ThemeColors.of(context).greenMain),
            const SizedBox(height: 8),
            _buildStatusRow(context, 'Última sincronização', 'Há 5 minutos', ThemeColors.of(context).blueMain),
            const SizedBox(height: 8),
            _buildStatusRow(context, 'Pendências', '0 itens', ThemeColors.of(context).textSecondary),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _forcarSincronizacao();
            },
            child: const Text('Sincronizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: ThemeColors.of(context).textSecondary)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
      ],
    );
  }

  /// Mostra dialog de fluxos pendentes
  void _showFluxosPendentesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(Icons.auto_awesome_rounded, color: ThemeColors.of(context).greenMaterial, size: 48),
        title: const Text('Fluxos Pendentes'),
        content: const Text(
          'Aqui você pode ver todos os fluxos inteligentes que precisam de sua atenção.',
          textAlign: TextAlign.center,
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

  /// Abre busca rápida
  // ignore: unused_element
  void _abrirBusca() {
    showSearch(
      context: context,
      delegate: _TagBeanSearchDelegate(),
    );
  }

  /// Atualiza dados do dashboard
  // ignore: unused_element
  void _atualizarDashboard() {
    ref.read(dashboardProvider.notifier).refresh();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.refresh_rounded, color: ThemeColors.of(context).surface),
            const SizedBox(width: 12),
            const Expanded(child: Text('Dashboard atualizado!')),
          ],
        ),
        backgroundColor: ThemeColors.of(context).greenMain,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildAlertItemDetalhado(BuildContext context, Map<String, dynamic> alerta) {
    final isMobile = ResponsiveHelper.isMobile(context);
    // ignore: unused_local_variable
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 10,
          tablet: 14,
          desktop: 16,
        ),
      ),
      decoration: BoxDecoration(
        color: _getAlertCardBackground(alerta['cor'] as Color),
        borderRadius: BorderRadius.circular(
          isMobile ? 8 : 12,
        ),
        border: Border.all(
          color: _getAlertCardBorder(alerta['cor'] as Color), 
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 6,
                    tablet: 9,
                    desktop: 10,
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [alerta['cor'], (alerta['cor'] as Color).withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 6 : 10,
                  ),
                ),
                child: Icon(
                  // ignore: argument_type_not_assignable
                  alerta['icone'],
                  color: ThemeColors.of(context).surface,
                  size: ResponsiveHelper.getResponsiveIconSize(
                    context,
                    mobile: 16,
                    tablet: 20,
                    desktop: 22,
                  ),
                ),
              ),
              SizedBox(
                width: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 10,
                  tablet: 12,
                  desktop: 14,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (alerta['tipo']).toString(),
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 15,
                          mobileFontSize: 13,
                          tabletFontSize: 14,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      (alerta['descricao']).toString(),
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 12,
                          mobileFontSize: 11,
                          tabletFontSize: 11.5,
                        ),
                        color: ThemeColors.of(context).grey600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 10,
                    tablet: 12,
                    desktop: 13,
                  ),
                  vertical: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 6,
                    tablet: 7,
                    desktop: 8,
                  ),
                ),
                decoration: BoxDecoration(
                  // ignore: argument_type_not_assignable
                  color: alerta['cor'],
                  borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
                ),
                child: Text(
                  '${alerta['qtd']}',
                  style: TextStyle(
                    color: ThemeColors.of(context).surface,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 13,
                      tabletFontSize: 13.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 10,
              tablet: 11,
              desktop: 12,
            ),
          ),
          Text(
            (alerta['detalhes']).toString(),
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                mobileFontSize: 11,
                tabletFontSize: 11.5,
              ),
              color: ThemeColors.of(context).grey700,
              height: 1.4,
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 10,
              tablet: 11,
              desktop: 12,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _navegarParaDetalhesAlerta(alerta),
              icon: Icon(
                Icons.arrow_forward_rounded,
                size: ResponsiveHelper.getResponsiveIconSize(
                  context,
                  mobile: 16,
                  tablet: 17,
                  desktop: 18,
                ),
              ),
              label: Text(
                'Ver Detalhes',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                    tabletFontSize: 12.5,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                // ignore: argument_type_not_assignable
                backgroundColor: alerta['cor'],
                foregroundColor: ThemeColors.of(context).surface,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 12,
                    tablet: 13,
                    desktop: 14,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    isMobile ? 8 : 10,
                  ),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Funções auxiliares para determinar cores dos cards de alerta baseado na cor do alerta
  Color _getAlertCardBackground(Color alertColor) {
    // Compara a cor do alerta com as cores conhecidas
    if (alertColor.value == ThemeColors.of(context).alertWarningLight.value ||
        alertColor.value == ThemeColors.of(context).alertOrangeMain.value ||
        alertColor.value == ThemeColors.of(context).alertWarningIcon.value) {
      return ThemeColors.of(context).alertWarningCardBackground;
    } else if (alertColor.value == ThemeColors.of(context).alertWarningLight.value ||
               alertColor.value == ThemeColors.of(context).alertRedMain.value ||
               alertColor.value == ThemeColors.of(context).alertErrorBackground.value) {
      return ThemeColors.of(context).alertErrorCardBackground;
    }
    // Fallback para cor genérica
    return alertColor.withValues(alpha: 0.15);
  }

  Color _getAlertCardBorder(Color alertColor) {
    // Compara a cor do alerta com as cores conhecidas
    if (alertColor.value == ThemeColors.of(context).alertWarningLight.value ||
        alertColor.value == ThemeColors.of(context).alertOrangeMain.value ||
        alertColor.value == ThemeColors.of(context).alertWarningIcon.value) {
      return ThemeColors.of(context).alertWarningCardBorder;
    } else if (alertColor.value == ThemeColors.of(context).alertWarningLight.value ||
               alertColor.value == ThemeColors.of(context).alertRedMain.value ||
               alertColor.value == ThemeColors.of(context).alertErrorBackground.value) {
      return ThemeColors.of(context).alertErrorCardBorder;
    }
    // Fallback para cor genérica
    return alertColor.withValues(alpha: 0.4);
  }

  /// Navega para a tela de detalhes baseada no tipo do alerta
  void _navegarParaDetalhesAlerta(Map<String, dynamic> alerta) {
    Navigator.pop(context); // Fecha o dialog de alertas

    final tipo = (alerta['tipo'] as String).toLowerCase();
    
    if (tipo.contains('sem preço') || tipo.contains('sem_preco')) {
      // Navegar para produtos sem preço
      setState(() => _selectedIndex = 1); // Produtos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.filter_list_rounded, color: ThemeColors.of(context).surface, size: 18),
              ),
              const SizedBox(width: 12),
              const Text('Filtro aplicado: Produtos sem preço'),
            ],
          ),
          backgroundColor: alerta['cor'] as Color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } else if (tipo.contains('offline') || tipo.contains('tags')) {
      // Navegar para tags
      setState(() => _selectedIndex = 2); // Etiquetas
    } else if (tipo.contains('margem')) {
      // Navegar para precificação
      setState(() => _selectedIndex = 5); // Precificação
    } else if (tipo.contains('estoque')) {
      // Navegar para relatórios
      setState(() => _selectedIndex = 8); // Relatórios
    } else {
      // Fallback: mostrar snackbar informativo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(alerta['icone'] as IconData, color: ThemeColors.of(context).surface, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(alerta['detalhes'] as String)),
            ],
          ),
          backgroundColor: alerta['cor'] as Color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _navegarParaNovoProduto() {
    setState(() => _selectedIndex = 1); // Navega para Produtos
    
    // Depois de um breve delay, mostra feedback para usuário
    Future.delayed(const Duration(milliseconds: 300), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_box_rounded, color: ThemeColors.of(context).surface, size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Use o botão "+" para adicionar um novo produto'),
              ),
            ],
          ),
          backgroundColor: ThemeColors.of(context).moduleProdutos,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  void _navegarParaImportacao() {
    setState(() => _selectedIndex = 7); // Navega para Import/Export
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).surfaceOverlay20,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.upload_file_rounded, color: ThemeColors.of(context).surface, size: 18),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Selecione "Importar" para adicionar produtos via Excel'),
            ),
          ],
        ),
        backgroundColor: ThemeColors.of(context).modulePrecificacao,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showNotificationsPanel(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        ),
        child: Container(
          width: isMobile ? double. infinity : 400,
          padding: EdgeInsets.all(
            ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 18,
              tablet: 20,
              desktop: 24,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Notificações',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 20,
                          mobileFontSize: 18,
                          tabletFontSize: 19,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(
                height: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
              ),
              // Usa alertas dinâmicos do provider
              ..._alertas.take(3).map((alerta) => Column(
                children: [
                  _buildNotificationItem(context, alerta['tipo'] as String,
                    alerta['descricao'] as String,
                    alerta['icone'] as IconData,
                    alerta['cor'] as Color,
                    'Recente',
                  ),
                  if (alerta != _alertas.take(3).last) const Divider(),
                ],
              )),
              if (_alertas.isEmpty) ...[
                _buildNotificationItem(context, 'Sem alertas',
                  'Nenhum alerta pendente no momento',
                  Icons.check_circle_rounded,
                  ThemeColors.of(context).greenMaterial,
                  'Agora',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, 
    String title,
    String message,
    IconData icon,
    Color color,
    String time,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 10,
          tablet: 11,
          desktop: 12,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(
              ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 7,
                tablet: 8,
                desktop: 8,
              ),
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                isMobile ?  7 : 8,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 18,
                tablet: 19,
                desktop: 20,
              ),
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 10,
              tablet: 11,
              desktop: 12,
            ),
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
                      baseFontSize: 14,
                      mobileFontSize: 12,
                      tabletFontSize: 13,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 3,
                    tablet: 4,
                    desktop: 4,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 10,
                      tabletFontSize: 11,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).grey600,
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 3,
                    tablet: 4,
                    desktop: 4,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 9,
                      tabletFontSize: 10,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).grey500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.logout_rounded, color: ThemeColors.of(context).redMain),
            SizedBox(
              width: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 10,
                tablet: 11,
                desktop: 12,
              ),
            ),
            Text(
              'Confirmar Saída',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 18,
                  mobileFontSize: 16,
                  tabletFontSize: 17,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Text(
          'Tem certeza que deseja sair do sistema?',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
              tabletFontSize: 13,
            ),
          overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).redMain,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
            ),
            child: Text(
              'Sair',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    return '${date.day} de ${months[date.month - 1]}, ${date.year}';
  }
}

/// SearchDelegate para busca rápida no TagBean
class _TagBeanSearchDelegate extends SearchDelegate<String?> {
  @override
  String get searchFieldLabel => 'Buscar produtos, tags...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: ThemeColors.of(context).surface,
        iconTheme: IconThemeData(color: ThemeColors.of(context).textPrimary),
        titleTextStyle: TextStyle(color: ThemeColors.of(context).textPrimary, fontSize: 16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: ThemeColors.of(context).textSecondary),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _buildEmptyState(context);
    }
    return _buildSearchResults(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 64,
            color: ThemeColors.of(context).textSecondaryOverlay30,
          ),
          const SizedBox(height: 16),
          Text(
            'Busque por produtos ou tags',
            style: TextStyle(
              fontSize: 16,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Digite um nome, código ou MAC',
            style: TextStyle(
              fontSize: 14,
              color: ThemeColors.of(context).textSecondaryOverlay70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    // Resultados de exemplo (substituir por busca real)
    final resultados = <Map<String, dynamic>>[
      {'tipo': 'produto', 'nome': 'Coca-Cola 2L', 'codigo': '7891234567890', 'preco': 'R\$ 12,99'},
      {'tipo': 'produto', 'nome': 'Arroz Tio João 5kg', 'codigo': '7891000123456', 'preco': 'R\$ 29,90'},
      {'tipo': 'tag', 'mac': 'AA:BB:CC:DD:EE:01', 'status': 'Online', 'produto': 'Coca-Cola 2L'},
    ].where((r) {
      final q = query.toLowerCase();
      return r['nome']?.toString().toLowerCase().contains(q) == true ||
             r['codigo']?.toString().toLowerCase().contains(q) == true ||
             r['mac']?.toString().toLowerCase().contains(q) == true;
    }).toList();

    if (resultados.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: ThemeColors.of(context).textSecondaryOverlay30,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum resultado para "$query"',
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: resultados.length,
      itemBuilder: (context, index) {
        final r = resultados[index];
        final isProduto = r['tipo'] == 'produto';
        
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isProduto ? ThemeColors.of(context).blueMain : ThemeColors.of(context).greenMaterial)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isProduto ? Icons.inventory_2_rounded : Icons.sell_rounded,
              color: isProduto ? ThemeColors.of(context).blueMain : ThemeColors.of(context).greenMaterial,
            ),
          ),
          title: Text(
            isProduto ? ((r['nome']).toString()).toString() ?? '' : r['mac'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            isProduto ? ((r['codigo']).toString()).toString() ?? '' : r['produto'] ?? 'Sem vínculo',
            style: TextStyle(
              fontSize: 12,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          trailing: isProduto
              ? Text(
                  (r['preco']).toString() ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).greenMain,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).greenMain.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (r['status']).toString() ?? '',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.of(context).greenMain,
                    ),
                  ),
                ),
          onTap: () {
            close(context, ((r['nome']).toString()).toString() ?? r['mac']);
          },
        );
      },
    );
  }
}

