import 'package:tagbean/core/enums/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/pricing/data/models/pricing_models.dart';
import 'package:tagbean/features/pricing/presentation/providers/pricing_provider.dart';
import 'package:tagbean/features/products/data/models/product_model.dart';

class RevisaoMargensScreen extends ConsumerStatefulWidget {
  const RevisaoMargensScreen({super.key});

  @override
  ConsumerState<RevisaoMargensScreen> createState() => _RevisaoMargensScreenState();
}

class _RevisaoMargensScreenState extends ConsumerState<RevisaoMargensScreen> with ResponsiveCache {
  double _margemMinima = 20.0;
  double _margemIdeal = 35.0;

  // Getters conectados ao Provider
  MarginReviewState get _state => ref.watch(marginReviewProvider);
  List<MarginReviewModel> get _produtos => _state.items;
  List<MarginReviewModel> get _produtosFiltrados => _state.filteredItems;
  String get _filtroStatus => _state.filterStatus;
  bool get _isLoading => _state.status == LoadingStatus.loading;

  int get _criticos => _produtos.where((p) => p.status == 'critico').length;
  int get _baixos => _produtos.where((p) => p.status == 'atencao').length;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_produtos.isEmpty) {
        ref.read(marginReviewProvider.notifier).loadItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildModernAppBar()),
                  SliverToBoxAdapter(child: _buildAlertCard()),
                  SliverToBoxAdapter(child: _buildFilterBar()),
                  _produtosFiltrados.isEmpty
                      ? SliverFillRemaining(child: _buildEmptyState())
                      : SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildProdutoCard(_produtosFiltrados[index], index),
                                );
                              },
                              childCount: _produtosFiltrados.length,
                            ),
                          ),
                        ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _aplicarAjusteEmMassa,
        icon: const Icon(Icons.auto_fix_high_rounded),
        label: const Text('Ajuste Autom?tico'),
        backgroundColor: ThemeColors.of(context).success,
      ),
    );
  }

  Widget _buildModernAppBar() {
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: 16,
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
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: ThemeColors.of(context).textSecondary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 22),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revis?o de Margens',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'An?lise de lucratividade',
                  style: TextStyle(fontSize: 11, color: ThemeColors.of(context).textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings_rounded, color: ThemeColors.of(context).textSecondary, size: 20),
            onPressed: () {
              // TODO: Implementar configura??o de par?metros
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configura??es em desenvolvimento')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard() {
    if (_criticos == 0 && _baixos == 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeColors.of(context).errorPastel,
            ThemeColors.of(context).warningPastel,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.of(context).error),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_rounded, color: ThemeColors.of(context).errorDark, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aten??o Necess?ria',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_criticos produto(s) com margem cr?tica e $_baixos com margem baixa',
                  style: TextStyle(fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: ThemeColors.of(context).surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Todos', 'todos', Icons.list_rounded, null),
            const SizedBox(width: 8),
            _buildFilterChip('Cr?tico', 'critico', Icons.error_rounded, ThemeColors.of(context).error),
            const SizedBox(width: 8),
            _buildFilterChip('Aten??o', 'atencao', Icons.warning_rounded, ThemeColors.of(context).orangeMaterial),
            const SizedBox(width: 8),
            _buildFilterChip('Saud?vel', 'saudavel', Icons.check_circle_rounded, ThemeColors.of(context).success),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon, Color? cor) {
    final isSelected = _filtroStatus == value;
    final chipColor = cor ?? ThemeColors.of(context).textSecondary;

    return InkWell(
      onTap: () {
        ref.read(marginReviewProvider.notifier).setFilterStatus(value);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColorLight : ThemeColors.of(context).textSecondaryOverlay10,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : ThemeColors.of(context).transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? chipColor : ThemeColors.of(context).textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? chipColor : ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProdutoCard(MarginReviewModel produto, int index) {
    final cor = produto.statusColor;

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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: corLight,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: corLight,
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cor, cor.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    produto.statusIcon,
                    color: ThemeColors.of(context).surface,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        produto.nome,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.extraSmallPadding.get(isMobile, isTablet), vertical: 3),
                        decoration: BoxDecoration(
                          color: corLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          produto.statusLabel,
                          style: TextStyle(
                            fontSize: 11,
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
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Margem Atual',
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${produto.margemAtual.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: cor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: ThemeColors.of(context).textSecondaryOverlay20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Pre?o:', style: TextStyle(fontSize: 12)),
                            Text(
                              'R\$ ${produto.precoAtual.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Custo:', style: TextStyle(fontSize: 12)),
                            Text(
                              'R\$ ${produto.custo.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _calcularNovoPreco(produto),
                    icon: const Icon(Icons.calculate_rounded, size: 18),
                    label: const Text('Calcular'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cor,
                      side: BorderSide(color: corLight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _ajustarMargem(produto),
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: const Text('Ajustar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cor,
                      foregroundColor: ThemeColors.of(context).surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, size: 64, color: ThemeColors.of(context).success),
          const SizedBox(height: 16),
          const Text(
            'Nenhum produto nesta categoria',
            style: TextStyle(
              fontSize: 16,
              color: ThemeColors.of(context).textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _calcularNovoPreco(MarginReviewModel produto) {
    final margemDesejada = _margemIdeal;
    final novoPreco = produto.custo / (1 - margemDesejada / 100);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Pre?o Sugerido'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(produto.nome, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(
              'Para atingir margem de ${margemDesejada.toStringAsFixed(0)}%:',
              style: TextStyle(color: ThemeColors.of(context).textSecondary),
            ),
            const SizedBox(height: 12),
            Text(
              'R\$ ${novoPreco.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).success,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aumento de ${((novoPreco - produto.precoAtual) / produto.precoAtual * 100).toStringAsFixed(1)}%',
              style: TextStyle(color: ThemeColors.of(context).textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(marginReviewProvider.notifier).ajustarPrecoProduto(produto.id, novoPreco);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                      const SizedBox(width: 12),
                      Text('Margem de ${produto.nome} ajustada'),
                    ],
                  ),
                  backgroundColor: ThemeColors.of(context).success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).success,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  void _ajustarMargem(MarginReviewModel produto) {
    final margemController = TextEditingController(text: _margemIdeal.toStringAsFixed(0));
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Ajustar Margem'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(produto.nome, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: margemController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Margem Desejada (%)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final margem = double.tryParse(margemController.text);
              if (margem != null && margem > 0 && margem < 100) {
                final novoPreco = produto.custo / (1 - margem / 100);
                ref.read(marginReviewProvider.notifier).ajustarPrecoProduto(produto.id, novoPreco);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                        const SizedBox(width: 12),
                        Text('Margem de ${produto.nome} ajustada'),
                      ],
                    ),
                    backgroundColor: ThemeColors.of(context).success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).success,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  void _editarMargemIndividual(ProdutoModel produto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Par?metros de Margem'),
        content: StatefulBuilder(
          builder: (context, setStateDialog) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(child: Text('Margem M?nima:')),
                  Text('${_margemMinima.round()}%', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Slider(
                value: _margemMinima,
                min: 10,
                max: 30,
                divisions: 20,
                onChanged: (value) => setStateDialog(() => _margemMinima = value),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: Text('Margem Ideal:')),
                  Text('${_margemIdeal.round()}%', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Slider(
                value: _margemIdeal,
                min: 25,
                max: 50,
                divisions: 25,
                onChanged: (value) => setStateDialog(() => _margemIdeal = value),
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
            onPressed: () {
              // For?a rebuild para aplicar novos valores de margem
              setState(() {});
              Navigator.pop(context);
              // Feedback visual para o usu?rio
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                      const SizedBox(width: 12),
                      Text('Par?metros atualizados: M?nima ${_margemMinima.round()}%, Ideal ${_margemIdeal.round()}%'),
                    ],
                  ),
                  backgroundColor: ThemeColors.of(context).blueCyan,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).blueCyan,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _aplicarAjusteEmMassa() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.auto_fix_high_rounded, color: ThemeColors.of(context).blueCyan, size: 48),
        title: const Text('Ajuste Autom?tico'),
        content: Text(
          'Aplicar margem ideal (${_margemIdeal.round()}%) em $_criticos produto(s) cr?tico(s) e $_baixos com margem baixa?',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(marginReviewProvider.notifier).aplicarAjusteEmMassa(_margemIdeal);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                      const SizedBox(width: 12),
                      Text('${_criticos + _baixos} produtos ajustados'),
                    ],
                  ),
                  backgroundColor: ThemeColors.of(context).success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).success,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }
}











