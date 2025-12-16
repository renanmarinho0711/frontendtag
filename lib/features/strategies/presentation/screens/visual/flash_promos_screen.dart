import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/features/strategies/data/providers/visual_provider.dart';

class FlashPromosConfigScreen extends ConsumerStatefulWidget {
  const FlashPromosConfigScreen({super.key});

  @override
  ConsumerState<FlashPromosConfigScreen> createState() => _FlashPromosConfigScreenState();
}

class _FlashPromosConfigScreenState extends ConsumerState<FlashPromosConfigScreen>
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
    final state = ref.watch(flashPromosProvider);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildConfigTab(state), _buildPromosTab(state)],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          if (state.fabExpanded)
            FloatingActionButton.extended(heroTag: 'save', onPressed: _salvarConfiguracoes, icon: const Icon(Icons.save_rounded), label: const Text('Salvar'), backgroundColor: ThemeColors.of(context).error, foregroundColor: ThemeColors.of(context).surface),
          Positioned(
            right: 0,
            bottom: state.fabExpanded ? 66 : 0,
            child: FloatingActionButton.small(heroTag: 'toggle', onPressed: () => ref.read(flashPromosProvider.notifier).toggleFabExpanded(), backgroundColor: ThemeColors.of(context).textSecondary, child: Icon(state.fabExpanded ? Icons.close_rounded : Icons.add_rounded, size: 20)),
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
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(gradient: LinearGradient(colors: [ThemeColors.of(context).error, ThemeColors.of(context).redDark]), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 24)),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Flash Promos', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.5)), Text('Ofertas rel?mpago nas ESLs', style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textSecondary))])),
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
        indicator: BoxDecoration(gradient: LinearGradient(colors: [ThemeColors.of(context).error, ThemeColors.of(context).redDark]), borderRadius: BorderRadius.circular(12)),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ThemeColors.of(context).surface,
        unselectedLabelColor: ThemeColors.of(context).textSecondary,
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          Tab(icon: Icon(Icons.settings_rounded, size: 18), text: 'Configura??o'), Tab(icon: Icon(Icons.flash_on_rounded, size: 18), text: 'Promo??es')
      ),
    );
  }

  Widget _buildConfigTab(FlashPromosState state) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(children: [_buildModernAppBar(), Padding(padding: const EdgeInsets.all(12), child: Column(children: [_buildHeader(state), const SizedBox(height: 12), _buildParametrosCard(state), const SizedBox(height: 12), _buildHorariosCard(state), const SizedBox(height: 12), _buildOpcoesCard(state)]))]),
    );
  }

  Widget _buildPromosTab(FlashPromosState state) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildModernAppBar(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: ThemeColors.of(context).errorLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: ThemeColors.of(context).error, width: 2)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.flash_on_rounded, size: 20, color: ThemeColors.of(context).error), const SizedBox(width: 8), Text('${state.promocoes.where((p) => p.ativa).length} promo??es ativas', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ThemeColors.of(context).error))])),
                const SizedBox(height: 16),
                ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: state.promocoes.length, itemBuilder: (context, index) => Padding(padding: const EdgeInsets.only(bottom: 16), child: _buildPromoCard(state.promocoes[index], index))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(FlashPromosState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [ThemeColors.of(context).error, ThemeColors.of(context).redDark]), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: ThemeColors.of(context).error.withValues(alpha: 0.4), blurRadius: 25, offset: const Offset(0, 12))]),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: ThemeColors.of(context).surfaceOverlay20, borderRadius: BorderRadius.circular(16)), child: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 24)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Flash Promos', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: ThemeColors.of(context).surface, letterSpacing: -0.8)), const SizedBox(height: 6), Text(state.isStrategyActive ? 'Promo??es rel?mpago ativas' : 'Sistema inativo', style: TextStyle(fontSize: 13, color: ThemeColors.of(context).surfaceOverlay70))])),
          Transform.scale(scale: 1.1, child: Switch(value: state.isStrategyActive, onChanged: (value) => ref.read(flashPromosProvider.notifier).setStrategyActive(value), activeColor: ThemeColors.of(context).surface, activeTrackColor: ThemeColors.of(context).surfaceOverlay50)),
        ],
      ),
    );
  }

  Widget _buildParametrosCard(FlashPromosState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: ThemeColors.of(context).textPrimaryOverlay05, blurRadius: 20, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: ThemeColors.of(context).blueMainLight, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.timer_rounded, color: ThemeColors.of(context).blueMain, size: 22)), const SizedBox(width: 14), const Expanded(child: Text('Dura??o das Promo??es', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.5)))])
          const SizedBox(height: 24),
          Row(children: [const Icon(Icons.hourglass_top_rounded, size: 24, color: ThemeColors.of(context).blueMain), const SizedBox(width: 12), const Expanded(child: Text('Dura??o Padr?o', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))), Container(padding: EdgeInsets.symmetric(horizontal: AppSizes.mediumPadding.get(isMobile, isTablet), vertical: 6), decoration: BoxDecoration(color: ThemeColors.of(context).blueMainLight, borderRadius: BorderRadius.circular(8)), child: Text('${state.duracaoMinutos} min', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ThemeColors.of(context).blueMain)))]),
          Slider(value: state.duracaoMinutos.toDouble(), min: 5, max: 60, divisions: 11, label: '${state.duracaoMinutos} min', onChanged: (value) => ref.read(flashPromosProvider.notifier).setDuracaoMinutos(value.toInt()), activeColor: ThemeColors.of(context).blueMain),
          const SizedBox(height: 24),
          Row(children: [const Icon(Icons.speed_rounded, size: 24, color: ThemeColors.of(context).blueCyan), const SizedBox(width: 12), const Expanded(child: Text('Intensidade LED', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))), Container(padding: EdgeInsets.symmetric(horizontal: AppSizes.mediumPadding.get(isMobile, isTablet), vertical: 6), decoration: BoxDecoration(color: ThemeColors.of(context).blueCyanLight, borderRadius: BorderRadius.circular(8)), child: Text('${state.intensidadeLed}%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ThemeColors.of(context).blueCyan)))]),
          Slider(value: state.intensidadeLed.toDouble(), min: 0, max: 100, divisions: 10, label: '${state.intensidadeLed}%', onChanged: (value) => ref.read(flashPromosProvider.notifier).setIntensidadeLed(value.toInt()), activeColor: ThemeColors.of(context).blueCyan),
        ],
      ),
    );
  }

  Widget _buildHorariosCard(FlashPromosState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: ThemeColors.of(context).textPrimaryOverlay05, blurRadius: 20, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: ThemeColors.of(context).orangeDarkLight, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.schedule_rounded, color: ThemeColors.of(context).orangeDark, size: 22)), const SizedBox(width: 14), const Expanded(child: Text('Hor?rios Autom?ticos', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.5)))])
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.horariosAtivos.map((h) => Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(gradient: LinearGradient(colors: [ThemeColors.of(context).orangeDark, ThemeColors.of(context).orangeDeep]), borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: ThemeColors.of(context).orangeDarkLight, blurRadius: 8, offset: const Offset(0, 3))]), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 16), const SizedBox(width: 6), Text(h, style: TextStyle(color: ThemeColors.of(context).surface, fontWeight: FontWeight.w600, fontSize: 13))]))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcoesCard(FlashPromosState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: ThemeColors.of(context).textPrimaryOverlay05, blurRadius: 20, offset: const Offset(0, 4))]),
      child: Column(children: [
        _buildSwitchOption('Notificar Clientes', 'Enviar push notification aos clientes pr?ximos', Icons.notifications_active_rounded, state.notificarClientes, (value) => ref.read(flashPromosProvider.notifier).setNotificarClientes(value)),
        const SizedBox(height: 12),
        _buildSwitchOption('Contagem Regressiva', 'Exibir timer na ESL durante promo??o', Icons.timer_rounded, state.contagemRegressiva, (value) => ref.read(flashPromosProvider.notifier).setContagemRegressiva(value)),
        const SizedBox(height: 12),
        _buildSwitchOption('Anima??o Piscante', 'LED piscante para chamar aten??o', Icons.lightbulb_rounded, state.animacaoPiscante, (value) => ref.read(flashPromosProvider.notifier).setAnimacaoPiscante(value)),
      ]),
    );
  }

  Widget _buildSwitchOption(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: value ? ThemeColors.of(context).errorLight : ThemeColors.of(context).textSecondary, borderRadius: BorderRadius.circular(12), border: Border.all(color: value ? ThemeColors.of(context).errorLight : ThemeColors.of(context).textSecondary)),
      child: Row(children: [
        Icon(icon, color: value ? ThemeColors.of(context).error : ThemeColors.of(context).textSecondary, size: 24),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(subtitle, style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textSecondary))])),
        Transform.scale(scale: 0.95, child: Switch(value: value, onChanged: onChanged, activeColor: ThemeColors.of(context).error)),
      ]),
    );
  }

  Widget _buildPromoCard(FlashPromoModel promo, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) => Transform.scale(scale: 0.8 + (0.2 * value), child: Opacity(opacity: value, child: child)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: promo.ativa ? ThemeColors.of(context).errorLight : ThemeColors.of(context).textSecondary, width: 2), boxShadow: [BoxShadow(color: promo.ativa ? ThemeColors.of(context).errorLight : ThemeColors.of(context).textPrimaryOverlay05, blurRadius: 20, offset: const Offset(0, 6))]),
        child: Column(children: [
          Row(children: [
            Container(width: 60, height: 60, decoration: BoxDecoration(gradient: promo.ativa ? LinearGradient(colors: [ThemeColors.of(context).error, ThemeColors.of(context).redDark]) : LinearGradient(colors: [ThemeColors.of(context).grey400, ThemeColors.of(context).grey500]), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: (promo.ativa ? ThemeColors.of(context).error : ThemeColors.of(context).grey500)Light, blurRadius: 12, offset: const Offset(0, 4))]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.flash_on_rounded, color: ThemeColors.of(context).surface, size: 24), const SizedBox(height: 2), Text('${promo.desconto}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ThemeColors.of(context).surface))])),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(promo.nome, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: -0.3), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 6), Row(children: [Icon(Icons.access_time_rounded, size: 14, color: ThemeColors.of(context).textSecondary), const SizedBox(width: 4), Text('${promo.duracaoMinutos} min restantes', style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textSecondary))])])),
            Switch(value: promo.ativa, onChanged: (value) => ref.read(flashPromosProvider.notifier).togglePromoAtiva(promo.id), activeColor: ThemeColors.of(context).error),
          ]),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: ThemeColors.of(context).textSecondary, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Expanded(child: Column(children: [Icon(Icons.attach_money_rounded, size: 20, color: promo.ativa ? ThemeColors.of(context).error : ThemeColors.of(context).grey500), const SizedBox(height: 4), Text('R\$ ${promo.precoOriginal.toStringAsFixed(2)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: ThemeColors.of(context).textSecondary, decoration: TextDecoration.lineThrough)), Text('R\$ ${promo.precoPromo.toStringAsFixed(2)}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: promo.ativa ? ThemeColors.of(context).error : ThemeColors.of(context).grey500))])),
              Container(width: 1, height: 50, color: ThemeColors.of(context).textSecondary),
              Expanded(child: Column(children: [Icon(Icons.shopping_cart_rounded, size: 20, color: promo.ativa ? ThemeColors.of(context).greenMain : ThemeColors.of(context).grey500), const SizedBox(height: 4), Text('${promo.vendas}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: promo.ativa ? ThemeColors.of(context).greenMain : ThemeColors.of(context).grey500)), const Text('vendas', style: TextStyle(fontSize: 10, color: ThemeColors.of(context).textSecondary))])),
            ]),
          ),
        ]),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).error, size: 56), title: const Text('Flash Promos'), content: const SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Crie promo??es rel?mpago com urg?ncia:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), SizedBox(height: 16), Text(' Ofertas por tempo limitado', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Contagem regressiva nas ESLs', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' LED piscante para urg?ncia', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Notifica??o push para clientes', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Aumenta convers?o em 30-50%', style: TextStyle(fontSize: 13, height: 1.5))])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendi'))]));
  }

  void _salvarConfiguracoes() async {
    await ref.read(flashPromosProvider.notifier).salvarConfiguracoes();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Row(children: [Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('Configura??es Salvas!', style: TextStyle(fontWeight: FontWeight.bold)), Text('Flash promos configuradas', style: TextStyle(fontSize: 12))]))]), backgroundColor: ThemeColors.of(context).error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
  }
}









