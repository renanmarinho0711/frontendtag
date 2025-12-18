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
// REMOVED: import 'package:tagbean/features/strategies/presentation/screens/ai_suggestions_screen.dart';
import 'package:tagbean/features/strategies/presentation/providers/strategies_provider.dart';
import 'package:tagbean/features/settings/presentation/screens/settings_menu_screen.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
// REMOVED: import 'package:tagbean/features/auth/presentation/widgets/store_selector.dart';
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
// Card de administrao (PlatformAdmin / ClientAdmin)
import 'package:tagbean/features/dashboard/presentation/widgets/admin_panel_card.dart';
// Widgets de navegao extrados
import 'package:tagbean/features/dashboard/presentation/widgets/navigation/navigation.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isRailExpanded = true;
  // ignore: unused_field
  bool _isEstrategiasExpanded = false;
  int _rebuildCounter = 0; // Contador para forar rebuild ao clicar no mesmo menu
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final ScrollController _bottomNavScrollController = ScrollController();
  
  // ValueKey dinmica usada em _getSelectedScreen() com _rebuildCounter
  // permite resetar módulo ao clicar no mesmo menu

  /// Retorna os itens do menu com cores DINMICAS baseadas no tema atual
  // ignore: unused_element
  List<Map<String, dynamic>> _getMenuItems() {
    return [
      {
        'icon': Icons.dashboard_rounded,
        'title': 'Dashboard',
        'gradient': [ThemeColors.of(context).moduleDashboard, ThemeColors.of(context).moduleDashboardDark]
      },
      {
        'icon': Icons.inventory_2_rounded,
        'title': 'Produtos',
        'gradient': [ThemeColors.of(context).moduleProdutos, ThemeColors.of(context).moduleProdutosDark]
      },
      {
        'icon': Icons.label_rounded,
        'title': 'Etiquetas',
        'gradient': [ThemeColors.of(context).moduleEtiquetas, ThemeColors.of(context).moduleEtiquetasDark]
      },
      {
        'icon': Icons.auto_awesome_rounded,
        'title': 'Estratgias',
        'gradient': [ThemeColors.of(context).moduleEstrategias, ThemeColors.of(context).moduleEstrategiasDark]
      },
      {
        'icon': Icons.sync_rounded,
        'title': 'Sincronização',
        'gradient': [ThemeColors.of(context).moduleSincronizacao, ThemeColors.of(context).moduleSincronizacaoDark]
      },
      {
        'icon': Icons.monetization_on_rounded,
        'title': 'precificação',
        'gradient': [ThemeColors.of(context).modulePrecificacao, ThemeColors.of(context).modulePrecificacaoDark]
      },
      {
        'icon': Icons.category_rounded,
        'title': 'Categorias',
        'gradient': [ThemeColors.of(context).moduleCategorias, ThemeColors.of(context).moduleCategoriasDark]
      },
      {
        'icon': Icons.import_export_rounded,
        'title': 'Importação',
        'gradient': [ThemeColors.of(context).moduleImportacao, ThemeColors.of(context).moduleImportacaoDark]
      },
      {
        'icon': Icons.assessment_rounded,
        'title': 'Relatrios',
        'gradient': [ThemeColors.of(context).moduleRelatorios, ThemeColors.of(context).moduleRelatoriosDark]
      },
      {
        'icon': Icons.settings_rounded,
        'title': 'Configurações',
        'gradient': [ThemeColors.of(context).moduleConfiguracoes, ThemeColors.of(context).moduleConfiguracoesDark]
      },
    ];
  }

  /// Getter dinmico para dados de estratgias baseado no provider
  // ignore: unused_element
  Map<String, dynamic> get _estrategiasData {
    final strategiesState = ref.watch(strategiesProvider);
    final strategiesStats = ref.watch(strategiesStatsProvider);
    
    final activeStrategies = strategiesState.strategies.where((s) => s.status.isActive).toList();
    final affectedProducts = strategiesStats.affectedProductsCount;
    
    // Calcula ganhos das estratgias
    final ganhoMensal = strategiesStats.monthlyGain;
    final ganhoHoje = strategiesStats.todayGain;
    final crescimento = strategiesStats.growthPercentage;
    
    // Cores para cada estratgia
    final cores = [ThemeColors.of(context).greenMaterial, ThemeColors.of(context).blueMaterial, ThemeColors.of(context).orangeMaterial, ThemeColors.of(context).greenMaterial, ThemeColors.of(context).materialTeal, ThemeColors.of(context).blueIndigo];
    
    return {
      'ativas': activeStrategies.length,
      'produtos_afetados': affectedProducts,
      'ganho_mensal': ganhoMensal,
      'ganho_hoje': ganhoHoje,
      'crescimento': crescimento.startsWith('+') || crescimento.startsWith('-') ? crescimento : '+$crescimento',
      'estratégias': activeStrategies.asMap().entries.map((entry) {
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
  // ignore: unused_element
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
    
    // Carrega os dados do dashboard aps o primeiro frame
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

  // OTIMIZAO: Reduzir clculos e chamadas MediaQuery
  // ignore: unused_element
  void _scrollToSelectedItem() {
    if (!ResponsiveHelper.isMobile(context)) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_bottomNavScrollController.hasClients) return;
      
      const itemWidth = 90.0; // largura aproximada de cada item
      const totalItems = 10; // _menuItems.length (constante)
      final screenWidth = MediaQuery.sizeOf(context).width; // OTIMIZAO: sizeOf  mais rápido
      final currentScroll = _bottomNavScrollController.offset;
      final itemPosition = _selectedIndex * itemWidth;
      final itemEnd = itemPosition + itemWidth;
      
      // Detectar se clicou nos extremos (primeiros 3 ou ltimos 3)
      final isFirstThree = _selectedIndex < 3;
      final isLastThree = _selectedIndex >= (totalItems - 3);
      
      double targetScroll;
      
      if (isFirstThree) {
        // Clicou nos primeiros 3 ? rolar para o incio (mostrando at 3 menus)
        targetScroll = 0.0;
      } else if (isLastThree) {
        // Clicou nos ltimos 3 ? rolar para o final (mostrando at 3 menus)
        targetScroll = _bottomNavScrollController.position.maxScrollExtent;
      } else {
        // Clicou no meio ? centralizar o item ou rolar para deixar visvel
        final isLeftVisible = itemPosition >= currentScroll;
        final isRightVisible = itemEnd <= (currentScroll + screenWidth);
        final isFullyVisible = isLeftVisible && isRightVisible;
        
        if (!isFullyVisible) {
          if (itemPosition < currentScroll) {
            // Item  esquerda ? rolar para trs 3 menus
            targetScroll = (itemPosition - (itemWidth * 2)).clamp(0.0, _bottomNavScrollController.position.maxScrollExtent);
          } else {
            // Item  direita ? rolar para frente 3 menus
            targetScroll = (itemPosition - screenWidth + (itemWidth * 3)).clamp(0.0, _bottomNavScrollController.position.maxScrollExtent);
          }
        } else {
          return; // J est visvel, no rolar
        }
      }
      
      _bottomNavScrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  // Keys para forar rebuild quando clicar no mesmo menu
  Key _getScreenKey(String prefix) {
    return Key('${prefix}_$_rebuildCounter');
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        try {
          return _buildDashboardContent();
        } catch (e, stack) {
          debugPrint('? ERRO NO DASHBOARD: $e');
          debugPrint('?? STACK: $stack');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: ThemeColors.of(context).error),
                const SizedBox(height: 16),
                Text('Erro ao carregar dashboard:\n$e', textAlign: TextAlign.center),
              ],
            ),
          );
        }
      case 1:
        return ProdutosDashboardScreen(key: _getScreenKey('produtos'));
      case 2:
        return TagsDashboardScreen(key: _getScreenKey('etiquetas'));
      case 3:
        return EstrategiasMenuScreen(key: _getScreenKey('estratégias'));
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
  
  // OTIMIZAO REMOVIDA: No recriar GlobalKeys (causava rebuilds completos das telas)
  // GlobalKeys agora so final e persistem durante toda vida til do widget

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      // Drawer para mobile - usando widget extrado
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
              // AppBar usando widget extrado
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
                    // Navigation rail apenas para tablet e desktop - usando widget extrado
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
      // Bottom navigation para mobile - usando widget extrado
      bottomNavigationBar: isMobile ? DashboardMobileBottomNav(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        scrollController: _bottomNavScrollController,
        fadeController: _fadeController,
      ) : null,
    );
  }
  
  // Callbacks para os widgets de navegao
  void _onItemSelected(int index, {bool fromDrawer = false}) {
    if (index == _selectedIndex) {
      // Clicou no mesmo menu - fora rebuild para voltar ao dashboard do módulo
      setState(() => _rebuildCounter++);
    } else {
      setState(() => _selectedIndex = index);
    }
    // Reinicia animao de fade
    _fadeController.reset();
    _fadeController.forward();
  }
  
  void _onToggleRailExpand() {
    setState(() => _isRailExpanded = !_isRailExpanded);
  }
  
  void _onNotificationTap() {
    // Navega para tela de notificaes (index 9 = Settings > Notificações)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notificações em breve'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
  
  void _onLogout() {
    // Mostra dilogo de confirmao de logout
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
    // Mostra dilogo de ajuda
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
            Text('TagBean - Sistema de Gesto de Etiquetas Eletrnicas'),
            SizedBox(height: 12),
            Text('Verso: 1.0.0'),
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
  // NAVEGAÇÃO: Widgets já extraídos em widgets/navigation/
  // - DashboardMobileDrawer, DashboardMobileBottomNav
  // - DashboardAppBar, DashboardNavigationRail
  // ============================================================================

  // ============================================================================
  // DASHBOARD CONTENT
  // ============================================================================

  Widget _buildDashboardContent() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final spacing = ResponsiveHelper.getResponsivePadding(
      context,
      mobile: 16,
      tablet: 20,
      desktop: 24,
    );

    // Obtém dados do Usuário logado
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
          
          // 👑 PAINEL ADMINISTRATIVO (PlatformAdmin / ClientAdmin / StoreManager)
          AdminPanelCard(
            onGerenciarClientes: () => _navigateTo(9), // Configurações (com placeholder de clientes)
            onGerenciarLojas: () => _navigateTo(9), // Configurações (com placeholder de lojas)
            onGerenciarUsuarios: () => _navigateTo(9), // Configurações → Usuários
            onVerConfiguracoes: () => _navigateTo(9), // Configurações
          ),
          SizedBox(height: spacing),
          
          // 🎯 PRIMEIROS PASSOS (para usuários novos - substitui atalhos de teclado)
          OnboardingStepsCard(
            onImportProducts: () => _navigateTo(7), // Importação
            onRegisterTags: () => _navigateTo(2), // Etiquetas
            onBindTags: () => _navigateTo(2), // Etiquetas
            onActivateStrategy: () => _navigateTo(3), // Estratégias
            onConfigureStore: () => _navigateTo(9), // Configurações
          ),
          SizedBox(height: spacing),
          
          // 🧠 PRÓXIMA AÇÃO RECOMENDADA (IA sugere o que fazer)
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
          
          // 📊 BLOCO 1: STATUS GERAL DO SISTEMA
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
          
          // 🔄 BLOCO 4: FLUXOS INTELIGENTES (se houver pendências)
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
          
          // 📜 ATIVIDADE RECENTE (histórico do que aconteceu)
          SizedBox(height: spacing),
          RecentActivityDashboardCard(
            onViewAll: () => _navigateTo(8), // Relatórios
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // LAYOUT HELPERS (Mobile/Desktop)
  // ============================================================================

  /// Layout para dispositivos móveis - tudo empilhado verticalmente
  Widget _buildMobileLayout(double spacing) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Resumo do Dia
        ResumoDoDoaCard(
          onVerDashboardCompleto: () => _navigateTo(8),
          onVerProdutos: () => _navigateTo(1),
          onVerVinculacao: () => _navigateTo(2),
        ),
        SizedBox(height: spacing),
        
        // Ações Frequentes
        AcoesFrequentesCard(
          onVincularTag: () => _navigateTo(2),
          onAtualizarPrecos: () => _navigateTo(5),
          onAdicionarProduto: () => _navigateTo(1),
          onVerRelatorio: () => _navigateTo(8),
        ),
        SizedBox(height: spacing),
        
        // Oportunidades de Lucro (IA)
        OportunidadesLucroCard(
          onRevisarSugestoes: () => _navigateTo(3),
          onAplicarAutomatico: () => _showAplicarSugestoesDialog(),
        ),
        SizedBox(height: spacing),
        
        // Estratégias Ativas
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
              // Resumo do Dia
              Expanded(
                flex: 1,
                child: ResumoDoDoaCard(
                  onVerDashboardCompleto: () => _navigateTo(8),
                  onVerProdutos: () => _navigateTo(1),
                  onVerVinculacao: () => _navigateTo(2),
                ),
              ),
              SizedBox(width: spacing),
              
              // Ações Frequentes
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
        
        // Oportunidades de Lucro (IA) - largura total
        OportunidadesLucroCard(
          onRevisarSugestoes: () => _navigateTo(3),
          onAplicarAutomatico: () => _showAplicarSugestoesDialog(),
        ),
        SizedBox(height: spacing),
        
        // Estratégias Ativas - largura total
        EstrategiasAtivasCard(
          onGerenciar: () => _navigateTo(3),
        ),
      ],
    );
  }

  // ============================================================================
  // DIALOGS
  // ============================================================================

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
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ThemeColors.of(context).redMain,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            color: ThemeColors.of(context).surface,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Alertas Pendentes',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
              const SizedBox(height: 16),
              const Text('Nenhum alerta no momento.'),
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
            _buildStatusRow('Conexão', 'Conectado', ThemeColors.of(context).greenMain),
            const SizedBox(height: 8),
            _buildStatusRow('Última sincronização', 'Há 5 minutos', ThemeColors.of(context).blueMain),
            const SizedBox(height: 8),
            _buildStatusRow('Pendências', '0 itens', ThemeColors.of(context).textSecondary),
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

  Widget _buildStatusRow(String label, String value, Color color) {
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

  // ignore: unused_element
  void _showNotificationsPanel(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        ),
        child: Container(
          width: isMobile ? double.infinity : 400,
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
                  const Text(
                    'Notificações',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Nenhuma notificação no momento.'),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
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
            const SizedBox(width: 12),
            const Text('Confirmar Saída', style: TextStyle(fontSize: 17)),
          ],
        ),
        content: const Text('Tem certeza que deseja sair do sistema?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).redMain,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
              ),
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // NAVIGATION HELPERS
  // ============================================================================

  void _navigateTo(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        _fadeController.reset();
        _fadeController.forward();
      });
    }
  }

  // ignore: unused_element
  void _navegarParaNovoProduto() {
    setState(() => _selectedIndex = 1);
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
                child: Icon(Icons.add_box_rounded, color: ThemeColors.of(context).surface, size: 18),
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

  // ignore: unused_element
  void _navegarParaImportacao() {
    setState(() => _selectedIndex = 7);
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

  // ignore: unused_element
  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    return '${date.day} de ${months[date.month - 1]}, ${date.year}';
  }
}

/// SearchDelegate para busca rápida no TagBean
// ignore: unused_element
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
            isProduto ? r['nome'] ?? '' : r['mac'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            isProduto ? r['codigo'] ?? '' : r['produto'] ?? 'Sem vínculo',
            style: TextStyle(
              fontSize: 12,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          trailing: isProduto
              ? Text(
                  r['preco'] ?? '',
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
                    r['status'] ?? '',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.of(context).greenMain,
                    ),
                  ),
                ),
          onTap: () {
            close(context, r['nome'] ?? r['mac']);
          },
        );
      },
    );
  }
}
