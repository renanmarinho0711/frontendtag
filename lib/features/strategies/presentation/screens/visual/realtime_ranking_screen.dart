import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/features/strategies/data/providers/visual_provider.dart';

class RankingTempoRealConfigScreen extends ConsumerStatefulWidget {
  const RankingTempoRealConfigScreen({super.key});

  @override
  ConsumerState<RankingTempoRealConfigScreen> createState() => _RankingTempoRealConfigScreenState();
}

class _RankingTempoRealConfigScreenState extends ConsumerState<RankingTempoRealConfigScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _tabController = TabController(length: 2, vsync: this);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(realtimeRankingProvider);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildConfigTab(state), _buildRankingTab(state)],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          if (state.fabExpanded)
            FloatingActionButton.extended(heroTag: 'save', onPressed: _salvarConfiguracoes, icon: const Icon(Icons.save_rounded), label: const Text('Salvar'), backgroundColor: ThemeColors.of(context).warning, foregroundColor: ThemeColors.of(context).surface),
          Positioned(
            right: 0,
            bottom: state.fabExpanded ? 66 : 0,
            child: FloatingActionButton.small(heroTag: 'toggle', onPressed: () => ref.read(realtimeRankingProvider.notifier).toggleFabExpanded(), backgroundColor: ThemeColors.of(context).textSecondary, child: Icon(state.fabExpanded ? Icons.close_rounded : Icons.add_rounded, size: 20)),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAppBar() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: ThemeColors.of(context).textPrimaryOverlay05, blurRadius: 20, offset: const Offset(0, 4))]),
      child: Row(
        children: [
          Container(decoration: BoxDecoration(color: ThemeColors.of(context).textSecondary, borderRadius: BorderRadius.circular(12)), child: IconButton(icon: Icon(Icons.arrow_back_rounded, color: ThemeColors.of(context).textSecondary), onPressed: () => Navigator.pop(context))),
          const SizedBox(width: 16),
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(gradient: LinearGradient(colors: [ThemeColors.of(context).warning, ThemeColors.of(context).warningDark]), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.leaderboard_rounded, color: ThemeColors.of(context).surface, size: 24)),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Ranking Tempo Real', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.5)), Text('Gamifica??o nas ESLs', style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textSecondary))])),
          IconButton(icon: const Icon(Icons.info_outline_rounded), onPressed: _showInfoDialog, color: ThemeColors.of(context).textSecondary),
        ],
      ),
    );
  }
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: ThemeColors.of(context).textPrimaryOverlay05, blurRadius: 10, offset: const Offset(0, 2))]),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(gradient: LinearGradient(colors: [ThemeColors.of(context).warning, ThemeColors.of(context).warningDark]), borderRadius: BorderRadius.circular(12)),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ThemeColors.of(context).surface,
        unselectedLabelColor: ThemeColors.of(context).textSecondary,
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        tabs: const [Tab(icon: Icon(Icons.settings_rounded, size: 18), text: 'Configura??o'), Tab(icon: Icon(Icons.emoji_events_rounded, size: 18), text: 'Top 5')],
      ),
    );
  }

  Widget _buildConfigTab(RealtimeRankingState state) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(children: [_buildModernAppBar(), Padding(padding: const EdgeInsets.all(12), child: Column(children: [_buildHeader(state), const SizedBox(height: 12), _buildParametrosCard(state), const SizedBox(height: 12), _buildCategoriasCard(state), const SizedBox(height: 12), _buildOpcoesCard(state)]))]),
    );
  }

  Widget _buildRankingTab(RealtimeRankingState state) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildModernAppBar(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: ThemeColors.of(context).successLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: ThemeColors.of(context).success, width: 2)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.circle, size: 10, color: ThemeColors.of(context).successIcon), const SizedBox(width: 8), Text('Atualizado h? 2 min', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ThemeColors.of(context).successIcon))])),
                ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: state.topProdutos.length, itemBuilder: (context, index) => Padding(padding: const EdgeInsets.only(bottom: 16), child: _buildProdutoCard(state.topProdutos[index], index))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(RealtimeRankingState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [ThemeColors.of(context).warning, ThemeColors.of(context).warningDark]), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: ThemeColors.of(context).warning.withValues(alpha: 0.4), blurRadius: 25, offset: const Offset(0, 12))]),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: ThemeColors.of(context).surfaceOverlay20, borderRadius: BorderRadius.circular(16)), child: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 24)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Efeito Manada', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: ThemeColors.of(context).surface, letterSpacing: -0.8)), const SizedBox(height: 6), Text(state.isStrategyActive ? 'Posi??es exibidas nas ESLs' : 'Sistema inativo', style: TextStyle(fontSize: 13, color: ThemeColors.of(context).surfaceOverlay70))])),
          Transform.scale(scale: 1.1, child: Switch(value: state.isStrategyActive, onChanged: (value) => ref.read(realtimeRankingProvider.notifier).setStrategyActive(value), activeColor: ThemeColors.of(context).surface, activeTrackColor: ThemeColors.of(context).surfaceOverlay50)),
        ],
      ),
    );
  }

  Widget _buildParametrosCard(RealtimeRankingState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: ThemeColors.of(context).textPrimaryOverlay05, blurRadius: 20, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: ThemeColors.of(context).infoLight, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.tune_rounded, color: ThemeColors.of(context).info, size: 22)), const SizedBox(width: 14), const Expanded(child: Text('Par?metros de Exibi??o', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.5)))]),
          const SizedBox(height: 24),
          Row(children: [const Icon(Icons.refresh_rounded, size: 24, color: ThemeColors.of(context).info), const SizedBox(width: 12), const Expanded(child: Text('Intervalo de Atualiza??o', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))), Container(padding: EdgeInsets.symmetric(horizontal: AppSizes.mediumPadding.get(isMobile, isTablet), vertical: 6), decoration: BoxDecoration(color: ThemeColors.of(context).infoLight, borderRadius: BorderRadius.circular(8)), child: Text('${state.intervaloAtualizacao} min', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ThemeColors.of(context).info)))]),
          Slider(value: state.intervaloAtualizacao.toDouble(), min: 15, max: 120, divisions: 21, label: '${state.intervaloAtualizacao} min', onChanged: (value) => ref.read(realtimeRankingProvider.notifier).setIntervaloAtualizacao(value.toInt()), activeColor: ThemeColors.of(context).info),
          const SizedBox(height: 24),
          Row(children: [const Icon(Icons.analytics_rounded, size: 24, color: ThemeColors.of(context).blueCyan), const SizedBox(width: 12), const Expanded(child: Text('Tipo de Ranking', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))), Container(padding: EdgeInsets.symmetric(horizontal: AppSizes.mediumPadding.get(isMobile, isTablet), vertical: 6), decoration: BoxDecoration(color: ThemeColors.of(context).blueCyanLight, borderRadius: BorderRadius.circular(8)), child: DropdownButton<String>(value: state.tipoRanking, underline: const SizedBox(), items: ['Vendas', 'Faturamento', 'Quantidade', 'Margem'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (value) => ref.read(realtimeRankingProvider.notifier).setTipoRanking(value!), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ThemeColors.of(context).blueCyan)))]),
        ],
      ),
    );
  }

  Widget _buildCategoriasCard(RealtimeRankingState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: ThemeColors.of(context).textPrimaryOverlay05, blurRadius: 20, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: ThemeColors.of(context).orangeDarkLight, borderRadius: BorderRadius.circular(12)), child: Icon(Icons.category_rounded, color: ThemeColors.of(context).orangeDark, size: 22)), const SizedBox(width: 14), const Expanded(child: Text('Categorias no Ranking', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.5))), Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [ThemeColors.of(context).orangeDark, ThemeColors.of(context).orangeDeep]), borderRadius: BorderRadius.circular(8)), child: IconButton(icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface), onPressed: _editarCategorias, iconSize: 20))]),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.categoriasSelecionadas.map((cat) => Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(gradient: LinearGradient(colors: [ThemeColors.of(context).orangeDark, ThemeColors.of(context).orangeDeep]), borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: ThemeColors.of(context).orangeDarkLight, blurRadius: 8, offset: const Offset(0, 3))]), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 16), const SizedBox(width: 6), Text(cat, style: TextStyle(color: ThemeColors.of(context).surface, fontWeight: FontWeight.w600, fontSize: 13))]))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcoesCard(RealtimeRankingState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: ThemeColors.of(context).textPrimaryOverlay05, blurRadius: 20, offset: const Offset(0, 4))]),
      child: Column(children: [
        _buildSwitchOption('Exibir Posi??o', 'Mostrar medalha de posi??o nas ESLs', Icons.emoji_events_rounded, state.exibirPosicao, (value) => ref.read(realtimeRankingProvider.notifier).setExibirPosicao(value)),
        const SizedBox(height: 12),
        _buildSwitchOption('Anima??o de Subida', 'Efeito visual quando produto sobe no ranking', Icons.trending_up_rounded, state.animacaoSubida, (value) => ref.read(realtimeRankingProvider.notifier).setAnimacaoSubida(value)),
      ]),
    );
  }

  Widget _buildSwitchOption(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: value ? ThemeColors.of(context).amberMainLight : ThemeColors.of(context).textSecondary, borderRadius: BorderRadius.circular(12), border: Border.all(color: value ? ThemeColors.of(context).amberMainLight : ThemeColors.of(context).textSecondary)),
      child: Row(children: [
        Icon(icon, color: value ? ThemeColors.of(context).warning : ThemeColors.of(context).textSecondary, size: 24),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(subtitle, style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textSecondary))])),
        Transform.scale(scale: 0.95, child: Switch(value: value, onChanged: onChanged, activeColor: ThemeColors.of(context).warning)),
      ]),
    );
  }

  Widget _buildProdutoCard(RankingProductModel produto, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) => Transform.scale(scale: 0.8 + (0.2 * value), child: Opacity(opacity: value, child: child)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: produto.corLight, width: 2), boxShadow: [BoxShadow(color: produto.corLight, blurRadius: 20, offset: const Offset(0, 6))]),
        child: Column(children: [
          Row(children: [
            Container(width: 60, height: 60, decoration: BoxDecoration(gradient: LinearGradient(colors: [produto.cor, produto.cor.withValues(alpha: 0.7)]), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: produto.corLight, blurRadius: 12, offset: const Offset(0, 4))]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(produto.icone, color: ThemeColors.of(context).surface, size: 24), const SizedBox(height: 2), Text('${produto.posicao}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ThemeColors.of(context).surface))])),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(produto.nome, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: -0.3), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 6), Row(children: [Icon(Icons.shopping_cart_rounded, size: 14, color: ThemeColors.of(context).textSecondary), const SizedBox(width: 4), Text('${produto.vendas} vendas hoje', style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textSecondary))])])),
            if (produto.isRising || produto.isFalling)
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: (produto.isRising ? ThemeColors.of(context).success : ThemeColors.of(context).error)Light, borderRadius: BorderRadius.circular(8), border: Border.all(color: (produto.isRising ? ThemeColors.of(context).success : ThemeColors.of(context).error)Light, width: 2)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(produto.isRising ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, size: 16, color: produto.isRising ? ThemeColors.of(context).success : ThemeColors.of(context).error), const SizedBox(width: 4), Text('${produto.variacao.abs()}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: produto.isRising ? ThemeColors.of(context).success : ThemeColors.of(context).error))])),
          ]),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: ThemeColors.of(context).textSecondary, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Expanded(child: Column(children: [Icon(Icons.attach_money_rounded, size: 20, color: produto.cor), const SizedBox(height: 4), Text(produto.faturamento, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: produto.cor)), const SizedBox(height: 2), const Text('Faturamento', style: TextStyle(fontSize: 10, color: ThemeColors.of(context).textSecondary))])),
              Container(width: 1, height: 50, color: ThemeColors.of(context).textSecondary),
              Expanded(child: Column(children: [Icon(Icons.percent_rounded, size: 20, color: produto.cor), const SizedBox(height: 4), Text(produto.margemFormatted, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: produto.cor)), const SizedBox(height: 2), const Text('Margem', style: TextStyle(fontSize: 10, color: ThemeColors.of(context).textSecondary))])),
            ]),
          ),
        ]),
      ),
    );
  }

  void _editarCategorias() {
    final state = ref.read(realtimeRankingProvider);
    final categoriasSelecionadas = List<String>.from(state.categoriasSelecionadas);
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Selecionar Categorias'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: state.allCategorias.map((cat) {
                final isSelected = categoriasSelecionadas.contains(cat);
                return CheckboxListTile(title: Text(cat), value: isSelected, activeColor: ThemeColors.of(context).orangeDark, onChanged: (value) {
                  setDialogState(() {
                    if (value == true) { categoriasSelecionadas.add(cat); } else { categoriasSelecionadas.remove(cat); }
                  });
                });
              }).toList(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () { ref.read(realtimeRankingProvider.notifier).setCategoriasSelecionadas(categoriasSelecionadas); Navigator.pop(context); },
              style: ElevatedButton.styleFrom(backgroundColor: ThemeColors.of(context).orangeDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).warning, size: 56), title: const Text('Ranking Tempo Real'), content: const SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Exibe posi??o de vendas nas etiquetas eletr?nicas:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), SizedBox(height: 16), Text(' Ranking atualizado automaticamente', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Gamifica??o aumenta o engajamento', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Clientes veem produtos mais vendidos', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Efeito manada impulsiona vendas', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Aumenta convers?o em 15-25%', style: TextStyle(fontSize: 13, height: 1.5))])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendi'))]));
  }

  void _salvarConfiguracoes() async {
    await ref.read(realtimeRankingProvider.notifier).salvarConfiguracoes();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Row(children: [Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('Configura??es Salvas!', style: TextStyle(fontWeight: FontWeight.bold)), Text('Ranking tempo real configurado', style: TextStyle(fontSize: 12))]))]), backgroundColor: ThemeColors.of(context).warning, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
  }
}










