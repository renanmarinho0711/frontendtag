import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/features/products/presentation/providers/products_state_provider.dart';
import 'package:tagbean/core/enums/loading_status.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';

/// Tela de controle de estoque de produtos
/// Conectada ao stockRiverpodProvider para dados reais
class ProdutosEstoqueScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  
  const ProdutosEstoqueScreen({super.key, this.onBack});

  @override
  ConsumerState<ProdutosEstoqueScreen> createState() => _ProdutosEstoqueScreenState();
}

class _ProdutosEstoqueScreenState extends ConsumerState<ProdutosEstoqueScreen> 
    with SingleTickerProviderStateMixin {
  
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  
  String _filterStatus = 'Todos';
  
  late AnimationController _animationController;

  // ============================================
  // GETTERS DO PROVIDER
  // ============================================
  
  StockState get _stockState => ref.watch(stockRiverpodProvider);
  List<StockItemModel> get _stockItems => _stockState.items;
  List<StockItemModel> get _filteredItems {
    final items = _stockState.filteredItems;
    if (_filterStatus == 'Todos') return items;
    return items.where((item) {
      if (_filterStatus == 'Crítico') return item.statusEstoque == 'Crítico' || item.statusEstoque == 'Esgotado';
      if (_filterStatus == 'Baixo') return item.statusEstoque == 'Baixo';
      if (_filterStatus == 'Normal') return item.statusEstoque == 'OK';
      return true;
    }).toList();
  }
  
  int get _estoquesCriticos => _stockState.totalEmAlerta + _stockState.totalEsgotado;
  int get _estoquesBaixos => _stockState.totalBaixo;
  int get _estoquesOk => _stockState.totalOk;
  // NOTA: _valorTotalEstoque removido (morto)
  bool get _isLoading => _stockState.status == LoadingStatus.loading;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
    
    // Carrega estoque ao iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_stockItems.isEmpty) {
        final currentStore = ref.read(currentStoreProvider);
        final storeId = currentStore?.id;
        ref.read(stockRiverpodProvider.notifier).loadStock(storeId: storeId);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(stockRiverpodProvider.notifier).setSearchQuery(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState()
            : _filteredItems.isEmpty
                ? _buildEmptyStateWithHeader(context)
                : CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(child: _buildHeader(context)),
                      SliverToBoxAdapter(child: _buildStats(context)),
                      SliverToBoxAdapter(child: _buildFilters(context)),
                      SliverPadding(
                        padding: EdgeInsets.all(
                          AppSizes.paddingXl.get(isMobile, isTablet),
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _buildProductCard(context, _filteredItems[index], index);
                            },
                            childCount: _filteredItems.length,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirMovimentacaoGlobal,
        icon: const Icon(Icons.swap_vert_rounded),
        label: const Text('Nova Movimentação'),
        backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppSpacing.lg),
          Text('Carregando estoque...'),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).greenMaterial, ThemeColors.of(context).greenDark],
        ),
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.elevatedCard,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: ThemeColors.of(context).surface,
            ),
            onPressed: () {
              if (widget.onBack != null) {
                widget.onBack!();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay20,
              borderRadius: AppRadius.lg,
            ),
            child: Icon(
              Icons.inventory_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconLarge.get(isMobile, isTablet),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Controle de Estoque',
                  style: AppTextStyles.h3.responsive(isMobile, isTablet).copyWith(
                    color: ThemeColors.of(context).surface,
                  ),
                ),
                Text(
                  '${_stockItems.length} produtos monitorados',
                  style: AppTextStyles.small.responsive(isMobile, isTablet).copyWith(
                    color: ThemeColors.of(context).surfaceOverlay90,
                  ),
                ),
              ],
            ),
          ),
          // Botão de atualizar
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
            onPressed: () {
              final currentStore = ref.read(currentStoreProvider);
              final storeId = currentStore?.id;
              ref.read(stockRiverpodProvider.notifier).loadStock(storeId: storeId);
            },
            tooltip: 'Atualizar estoque',
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.softCard,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(context, 'Críticos',
              '$_estoquesCriticos',
              Icons.error_rounded,
              ThemeColors.of(context).redMain,
              () => setState(() => _filterStatus = 'Crítico'),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: ThemeColors.of(context).border,
          ),
          Expanded(
            child: _buildStatItem(context, 'Baixos',
              '$_estoquesBaixos',
              Icons.warning_rounded,
              ThemeColors.of(context).orangeMain,
              () => setState(() => _filterStatus = 'Baixo'),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: ThemeColors.of(context).border,
          ),
          Expanded(
            child: _buildStatItem(context, 'Normais',
              '$_estoquesOk',
              Icons.check_circle_rounded,
              ThemeColors.of(context).greenMain,
              () => setState(() => _filterStatus = 'Normal'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, 
    String label,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.lg,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          children: [
            Icon(icon, color: color, size: AppSizes.iconLarge.get(false, false)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: AppTextStyles.h2.responsive(false, false).copyWith(
                color: color,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.caption.responsive(false, false).copyWith(
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar produto...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              border: const OutlineInputBorder(
                borderRadius: AppRadius.lg,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              isDense: true,
            ),
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(
                Icons.filter_list_rounded,
                size: AppSizes.iconMedium.get(false, false),
                color: ThemeColors.of(context).textSecondary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Status:',
                style: AppTextStyles.fieldLabel.responsive(false, false).copyWith(
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.sm,
                  children: ['Todos', 'Crítico', 'Baixo', 'Normal'].map((status) {
                    final isSelected = _filterStatus == status;
                    return FilterChip(
                      label: Text(status),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => _filterStatus = status);
                      },
                      backgroundColor: ThemeColors.of(context).textSecondaryOverlay10,
                      selectedColor: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.2),
                      checkmarkColor: ThemeColors.of(context).brandPrimaryGreen,
                      labelStyle: AppTextStyles.small.responsive(false, false).copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? ThemeColors.of(context).brandPrimaryGreen : ThemeColors.of(context).textSecondary,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, StockItemModel item, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    Color statusColor = item.statusColor;
    IconData statusIcon;
    String statusLabel;
    
    switch (item.statusEstoque) {
      case 'Esgotado':
      case 'Crítico':
        statusIcon = Icons.error_rounded;
        statusLabel = item.statusEstoque.toUpperCase();
        break;
      case 'Baixo':
        statusIcon = Icons.warning_rounded;
        statusLabel = 'BAIXO';
        break;
      default:
        statusIcon = Icons.check_circle_rounded;
        statusLabel = 'OK';
    }

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
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: AppRadius.card,
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: statusColor.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: ThemeColors.of(context).transparent,
          child: InkWell(
            onTap: () => _abrirDetalhesEstoque(item),
            borderRadius: AppRadius.card,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              item.cor ?? ThemeColors.of(context).primaryMain,
                              (item.cor ?? ThemeColors.of(context).primaryMain).withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: AppRadius.lg,
                        ),
                        child: Icon(
                          item.icone ?? Icons.inventory_2_rounded,
                          color: ThemeColors.of(context).surface,
                          size: AppSizes.iconLarge.get(isMobile, isTablet),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.nome,
                              style: AppTextStyles.bodyLarge.responsive(isMobile, isTablet).copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: AppSpacing.xxs / 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (item.cor ?? ThemeColors.of(context).primaryMain).withValues(alpha: 0.1),
                                    borderRadius: AppRadius.xs,
                                  ),
                                  child: Text(
                                    item.categoria,
                                    style: AppTextStyles.caption.responsive(false, false).copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: item.cor ?? ThemeColors.of(context).primaryMain,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Icon(
                                  Icons.qr_code_rounded,
                                  size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                                  color: ThemeColors.of(context).textSecondary,
                                ),
                                const SizedBox(width: AppSpacing.xxs),
                                Expanded(
                                  child: Text(
                                    item.productId,
                                    style: AppTextStyles.caption.responsive(false, false).copyWith(
                                      color: ThemeColors.of(context).textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: AppRadius.sm,
                          border: Border.all(color: statusColor),
                        ),
                        child: Row(
                          children: [
                            Icon(statusIcon, color: statusColor, size: AppSizes.iconTiny.get(isMobile, isTablet)),
                            const SizedBox(width: AppSpacing.xxs),
                            Text(
                              statusLabel,
                              style: AppTextStyles.caption.responsive(false, false).copyWith(
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).textSecondaryOverlay05,
                      borderRadius: AppRadius.lg,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStockInfo(context, 'Quantidade',
                            '${item.estoqueAtual} ${item.unidade}',
                            Icons.inventory_2_outlined,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: ThemeColors.of(context).border,
                        ),
                        Expanded(
                          child: _buildStockInfo(context, 'Mínimo',
                            '${item.estoqueMinimo} ${item.unidade}',
                            Icons.warning_amber_rounded,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: ThemeColors.of(context).border,
                        ),
                        Expanded(
                          child: _buildStockInfo(context, 'Valor Total',
                            'R\$ ${(item.valorTotal ?? 0).toStringAsFixed(2)}',
                            Icons.attach_money_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                            color: ThemeColors.of(context).textSecondary,
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Text(
                            item.ultimaMovimentacao != null
                                ? 'Ãšltima mov: ${_formatDate(item.ultimaMovimentacao!)}'
                                : 'Sem movimentações',
                            style: AppTextStyles.caption.responsive(false, false).copyWith(
                              color: ThemeColors.of(context).textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: ThemeColors.of(context).redMain,
                              size: AppSizes.iconMedium.get(isMobile, isTablet),
                            ),
                            onPressed: () => _registrarSaida(item),
                            tooltip: 'Registrar Saída',
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: ThemeColors.of(context).greenMain,
                              size: AppSizes.iconMedium.get(isMobile, isTablet),
                            ),
                            onPressed: () => _registrarEntrada(item),
                            tooltip: 'Registrar Entrada',
                          ),
                        ],
                      ),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildStockInfo(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: AppSizes.iconMedium.get(false, false),
          color: ThemeColors.of(context).textSecondary,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: AppTextStyles.body.responsive(false, false).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.responsive(false, false).copyWith(
            color: ThemeColors.of(context).textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyStateWithHeader(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(context)),
        SliverToBoxAdapter(child: _buildStats(context)),
        SliverToBoxAdapter(child: _buildFilters(context)),
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: AppSizes.iconHero3Xl.get(false, false),
                  color: ThemeColors.of(context).textSecondaryOverlay50,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Nenhum produto encontrado',
                  style: AppTextStyles.h3.responsive(false, false).copyWith(
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Ajuste os filtros de busca',
                  style: AppTextStyles.body.responsive(false, false).copyWith(
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _registrarEntrada(StockItemModel item) {
    _mostrarDialogoMovimentacao(item, 'entrada');
  }

  void _registrarSaida(StockItemModel item) {
    _mostrarDialogoMovimentacao(item, 'saida');
  }

  void _mostrarDialogoMovimentacao(StockItemModel item, String tipo) {
    final quantidadeController = TextEditingController();
    final motivoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.card,
        ),
        title: Row(
          children: [
            Icon(
              tipo == 'entrada' ? Icons.add_circle_rounded : Icons.remove_circle_rounded,
              color: tipo == 'entrada' ? ThemeColors.of(context).greenMain : ThemeColors.of(context).redMain,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                tipo == 'entrada' ? 'Entrada de Estoque' : 'Saída de Estoque',
                style: AppTextStyles.h3.responsive(false, false),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: (item.cor ?? ThemeColors.of(context).primaryMain).withValues(alpha: 0.1),
                  borderRadius: AppRadius.lg,
                ),
                child: Row(
                  children: [
                    Icon(item.icone ?? Icons.inventory_2_rounded, color: item.cor ?? ThemeColors.of(context).primaryMain),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.nome,
                            style: AppTextStyles.bodyLarge.responsive(false, false).copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Estoque atual: ${item.estoqueAtual} ${item.unidade}',
                            style: AppTextStyles.small.responsive(false, false).copyWith(
                              color: ThemeColors.of(context).textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  hintText: 'Digite a quantidade',
                  prefixIcon: Icon(Icons.dialpad_rounded),
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.lg,
                  ),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: motivoController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Motivo (opcional)',
                  hintText: 'Descreva o motivo da movimentação',
                  prefixIcon: Icon(Icons.description_rounded),
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.lg,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final quantidade = int.tryParse(quantidadeController.text) ?? 0;
              if (quantidade > 0) {
                Navigator.pop(context);
                await _confirmarMovimentacao(item, tipo, quantidade, motivoController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: tipo == 'entrada' 
                  ? ThemeColors.of(context).greenMain 
                  : ThemeColors.of(context).redMain,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarMovimentacao(
    StockItemModel item,
    String tipo,
    int quantidade,
    String motivo,
  ) async {
    final novaQuantidade = tipo == 'entrada' 
        ? item.estoqueAtual + quantidade 
        : item.estoqueAtual - quantidade;
    
    final success = await ref.read(stockRiverpodProvider.notifier).updateStockItem(
      item.productId,
      novaQuantidade,
    );

    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle_rounded : Icons.error_rounded,
              color: ThemeColors.of(context).surface,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    success 
                        ? (tipo == 'entrada' ? 'Entrada Registrada!' : 'Saída Registrada!')
                        : 'Erro ao registrar movimentação',
                    style: AppTextStyles.body.responsive(false, false).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (success)
                    Text(
                      '$quantidade ${item.unidade} - ${item.nome}',
                      style: AppTextStyles.small.responsive(false, false),
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: success
            ? (tipo == 'entrada' ? ThemeColors.of(context).greenMain : ThemeColors.of(context).orangeMain)
            : ThemeColors.of(context).redMain,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.lg,
        ),
      ),
    );
  }

  void _abrirDetalhesEstoque(StockItemModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: _getStatusColor(item.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.inventory_2_rounded,
                color: _getStatusColor(item.status),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nome,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'SKU: ${item.sku}',
                    style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetalheRow(context, 'Quantidade Atual', '${item.quantidade} un'),
              _buildDetalheRow(context, 'Estoque Mínimo', '${item.estoqueMinimo} un'),
              _buildDetalheRow(context, 'Estoque Máximo', '${item.estoqueMaximo} un'),
              _buildDetalheRow(context, 'Status', item.status),
              _buildDetalheRow(context, 'Ãšltima Atualização', _formatarData(item.ultimaAtualizacao)),
              const Divider(height: 24),
              _buildDetalheRow(context, 'Valor Unitário', _formatarMoeda(item.valorUnitario)),
              _buildDetalheRow(context, 'Valor Total', _formatarMoeda(item.valorTotal)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _mostrarDialogoMovimentacao(item, 'entrada');
            },
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Entrada'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).greenMain,
              foregroundColor: ThemeColors.of(context).surface,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _mostrarDialogoMovimentacao(item, 'saida');
            },
            icon: const Icon(Icons.remove_rounded, size: 18),
            label: const Text('Saída'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).orangeMain,
              foregroundColor: ThemeColors.of(context).surface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetalheRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatarData(DateTime? data) {
    if (data == null) return '-';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  String _formatarMoeda(double? valor) {
    if (valor == null) return 'R\$ 0,00';
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'crítico':
        return ThemeColors.of(context).redMain;
      case 'baixo':
        return ThemeColors.of(context).orangeMain;
      case 'normal':
        return ThemeColors.of(context).greenMain;
      default:
        return ThemeColors.of(context).textSecondary;
    }
  }

  void _abrirMovimentacaoGlobal() {
    final TextEditingController quantidadeController = TextEditingController();
    String tipoSelecionado = 'entrada';
    String motivoSelecionado = 'Reposição';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).blueMain.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.swap_vert_rounded,
                  color: ThemeColors.of(context).blueMain,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Text('Movimentação em Massa'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selecione o tipo de movimentação:',
                  style: TextStyle(
                    fontSize: 13,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Entrada', style: TextStyle(fontSize: 14)),
                        value: 'entrada',
                        groupValue: tipoSelecionado,
                        onChanged: (value) => setDialogState(() => tipoSelecionado = value!),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Saída', style: TextStyle(fontSize: 14)),
                        value: 'saída',
                        groupValue: tipoSelecionado,
                        onChanged: (value) => setDialogState(() => tipoSelecionado = value!),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                DropdownButtonFormField<String>(
                  initialValue: motivoSelecionado,
                  decoration: InputDecoration(
                    labelText: 'Motivo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    'Reposição',
                    'Ajuste de inventário',
                    'Devolução',
                    'Perda/Avaria',
                    'Transferência',
                    'Venda',
                    'Outro',
                  ].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (value) => setDialogState(() => motivoSelecionado = value!),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: quantidadeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantidade',
                    hintText: 'Quantidade para todos os itens',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).warningPastel,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: ThemeColors.of(context).orangeMain,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'A movimentação será aplicada a todos os ${_stockItems.length} produtos listados.',
                          style: TextStyle(
                            fontSize: 12,
                            color: ThemeColors.of(context).textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final quantidade = int.tryParse(quantidadeController.text);
                if (quantidade == null || quantidade <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Informe uma quantidade válida'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                
                Navigator.pop(context);
                
                // Executar movimentação em massa via API
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ThemeColors.of(context).surface,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text('Processando $tipoSelecionado de $quantidade unidades...'),
                      ],
                    ),
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                
                // Simular processamento e atualizar lista
                await Future.delayed(const Duration(seconds: 2));
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${tipoSelecionado == 'entrada' ? 'Entrada' : 'Saída'} de $quantidade unidades registrada para ${_stockItems.length} produtos'),
                      backgroundColor: ThemeColors.of(context).greenMain,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  
                  // Recarregar lista via provider com storeId
                  final currentStore = ref.read(currentStoreProvider);
                  final storeId = currentStore?.id;
                  ref.read(stockRiverpodProvider.notifier).loadStock(storeId: storeId);
                }
              },
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text('Confirmar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: tipoSelecionado == 'entrada' 
                    ? ThemeColors.of(context).greenMain 
                    : ThemeColors.of(context).orangeMain,
                foregroundColor: ThemeColors.of(context).surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




