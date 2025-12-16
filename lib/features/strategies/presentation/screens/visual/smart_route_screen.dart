import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/features/strategies/data/providers/visual_provider.dart';

class SmartRouteConfigScreen extends ConsumerStatefulWidget {
  const SmartRouteConfigScreen({super.key});

  @override
  ConsumerState<SmartRouteConfigScreen> createState() => _SmartRouteConfigScreenState();
}

class _SmartRouteConfigScreenState extends ConsumerState<SmartRouteConfigScreen>
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
    final state = ref.watch(smartRouteProvider);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildConfigTab(state), _buildRotasTab(state)],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          if (state.fabExpanded)
            FloatingActionButton.extended(heroTag: 'save', onPressed: _salvarConfiguracoes, icon: const Icon(Icons.save_rounded), label: const Text('Salvar'), backgroundColor: ThemeColors.of(context).success, foregroundColor: ThemeColors.of(context).surface),
          Positioned(
            right: 0,
            bottom: state.fabExpanded ? 66 : 0,
            child: FloatingActionButton.small(heroTag: 'toggle', onPressed: () => ref.read(smartRouteProvider.notifier).toggleFabExpanded(), backgroundColor: ThemeColors.of(context).textSecondary, child: Icon(state.fabExpanded ? Icons.close_rounded : Icons.add_rounded, size: 20)),
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
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(gradient: LinearGradient(colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary]), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.route_rounded, color: ThemeColors.of(context).surface, size: 24)),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Smart Route', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.5)), Text('Guia LED para picking', style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textSecondary))])),
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
        indicator: BoxDecoration(gradient: LinearGradient(colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary]), borderRadius: BorderRadius.circular(12)),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ThemeColors.of(context).surface,
        unselectedLabelColor: ThemeColors.of(context).textSecondary,
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        tabs: const [Tab(icon: Icon(Icons.settings_rounded, size: 18), text: 'Configura??o'), Tab(icon: Icon(Icons.route_rounded, size: 18), text: 'Rotas Ativas')],
      ),
    );
  }

  Widget _buildConfigTab(SmartRouteState state) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(children: [_buildModernAppBar(), Padding(padding: const EdgeInsets.all(12), child: Column(children: [_buildHeader(state), const SizedBox(height: 12), _buildParametrosCard(state), const SizedBox(height: 12), _buildModoRotaCard(state), const SizedBox(height: 12), _buildOpcoesCard(state)]))]),
    );
  }

  Widget _buildRotasTab(SmartRouteState state) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildModernAppBar(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: ThemeColors.of(context).blueCyanLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: ThemeColors.of(context).blueCyan, width: 2)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.directions_walk_rounded, size: 20, color: ThemeColors.of(context).blueCyan), const SizedBox(width: 8), Text('${state.rotasAtivas.length} rotas em andamento', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ThemeColors.of(context).blueCyan))])),
                const SizedBox(height: 16),
                ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: state.rotasAtivas.length, itemBuilder: (context, index) => Padding(padding: const EdgeInsets.only(bottom: 16), child: _buildRotaCard(state.rotasAtivas[index], index))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(SmartRouteState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary]), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.4), blurRadius: 25, offset: const Offset(0, 12))]),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: ThemeColors.of(context).surfaceOverlay20, borderRadius: BorderRadius.circular(16)), child: Icon(Icons.route_rounded, color: ThemeColors.of(context).surface, size: 24)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Smart Route', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: ThemeColors.of(context).surface, letterSpacing: -0.8)), const SizedBox(height: 6), Text(state.isStrategyActive ? 'Guia LED ativo para picking' : 'Sistema inativo', style: TextStyle(fontSize: 13, color: ThemeColors.of(context).surfaceOverlay70))])),
          Transform.scale(scale: 1.1, child: Switch(value: state.isStrategyActive, onChanged: (value) => ref.read(smartRouteProvider.notifier).setStrategyActive(value), activeColor: ThemeColors.of(context).surface, activeTrackColor: ThemeColors.of(context).surfaceOverlay50)),
        ],
      ),
    );
  }

  Widget _buildParametrosCard(SmartRouteState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: ThemeColors.of(context).textPrimaryOverlay05, blurRadius: 20, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: ThemeColors.of(context).blueMainLight, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.lightbulb_rounded, color: ThemeColors.of(context).blueMain, size: 22)), const SizedBox(width: 14), const Expanded(child: Text('Par?metros de LED', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.5)))])
          const SizedBox(height: 24),
          Row(children: [const Icon(Icons.light_mode_rounded, size: 24, color: ThemeColors.of(context).blueMain), const SizedBox(width: 12), const Expanded(child: Text('Intensidade LED', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))), Container(padding: EdgeInsets.symmetric(horizontal: AppSizes.mediumPadding.get(isMobile, isTablet), vertical: 6), decoration: BoxDecoration(color: ThemeColors.of(context).blueMainLight, borderRadius: BorderRadius.circular(8)), child: Text('${state.intensidadeLed}%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ThemeColors.of(context).blueMain)))]),
          Slider(value: state.intensidadeLed.toDouble(), min: 0, max: 100, divisions: 10, label: '${state.intensidadeLed}%', onChanged: (value) => ref.read(smartRouteProvider.notifier).setIntensidadeLed(value), activeColor: ThemeColors.of(context).blueMain),
          const SizedBox(height: 24),
          Row(children: [const Icon(Icons.timer_rounded, size: 24, color: ThemeColors.of(context).orangeDark), const SizedBox(width: 12), const Expanded(child: Text('Tempo de Piscar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))), Container(padding: EdgeInsets.symmetric(horizontal: AppSizes.mediumPadding.get(isMobile, isTablet), vertical: 6), decoration: BoxDecoration(color: ThemeColors.of(context).orangeDarkLight, borderRadius: BorderRadius.circular(8)), child: Text('${state.tempoPiscar}s', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ThemeColors.of(context).orangeDark)))]),
          Slider(value: state.tempoPiscar.toDouble(), min: 1, max: 10, divisions: 9, label: '${state.tempoPiscar}s', onChanged: (value) => ref.read(smartRouteProvider.notifier).setTempoPiscar(value.toInt()), activeColor: ThemeColors.of(context).orangeDark),
        ],
      ),
    );
  }

  Widget _buildModoRotaCard(SmartRouteState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: ThemeColors.of(context).textPrimaryOverlay05, blurRadius: 20, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: ThemeColors.of(context).blueCyanLight, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.alt_route_rounded, color: ThemeColors.of(context).blueCyan, size: 22)), const SizedBox(width: 14), const Expanded(child: Text('Modo de Rota', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.5)))])
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Sequencial', 'Otimizado', 'Prioridade'].map((modo) {
              final isSelected = state.modoRota == modo;
              return GestureDetector(
                onTap: () => ref.read(smartRouteProvider.notifier).setModoRota(modo),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(gradient: isSelected ? LinearGradient(colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary]) : null, color: isSelected ? null : ThemeColors.of(context).textSecondary, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? ThemeColors.of(context).blueCyan : ThemeColors.of(context).textSecondary)), child: Text(modo, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary))),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcoesCard(SmartRouteState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: ThemeColors.of(context).textPrimaryOverlay05, blurRadius: 20, offset: const Offset(0, 4))]),
      child: Column(children: [
        _buildSwitchOption('Confirma??o por Scan', 'Exigir scan para confirmar coleta', Icons.qr_code_scanner_rounded, state.confirmacaoScan, (value) => ref.read(smartRouteProvider.notifier).setConfirmacaoScan(value)),
        const SizedBox(height: 12),
        _buildSwitchOption('Som de Confirma??o', 'Emitir beep ao confirmar item', Icons.volume_up_rounded, state.somConfirmacao, (value) => ref.read(smartRouteProvider.notifier).setSomConfirmacao(value)),
        const SizedBox(height: 12),
        _buildSwitchOption('Mostrar Prximo Item', 'Exibir preview do prximo item', Icons.skip_next_rounded, state.mostrarProximoItem, (value) => ref.read(smartRouteProvider.notifier).setMostrarProximoItem(value)),
      ]),
    );
  }

  Widget _buildSwitchOption(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: value ? ThemeColors.of(context).blueCyanLight : ThemeColors.of(context).textSecondary, borderRadius: BorderRadius.circular(12), border: Border.all(color: value ? ThemeColors.of(context).blueCyanLight : ThemeColors.of(context).textSecondary)),
      child: Row(children: [
        Icon(icon, color: value ? ThemeColors.of(context).blueCyan : ThemeColors.of(context).textSecondary, size: 24),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(subtitle, style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textSecondary))])),
        Transform.scale(scale: 0.95, child: Switch(value: value, onChanged: onChanged, activeColor: ThemeColors.of(context).blueCyan)),
      ]),
    );
  }

  Widget _buildRotaCard(SmartRouteModel rota, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) => Transform.scale(scale: 0.8 + (0.2 * value), child: Opacity(opacity: value, child: child)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: rota.corRotaLight, width: 2), boxShadow: [BoxShadow(color: rota.corRotaLight, blurRadius: 20, offset: const Offset(0, 6))]),
        child: Column(children: [
          Row(children: [
            Container(width: 60, height: 60, decoration: BoxDecoration(gradient: LinearGradient(colors: [rota.corRota, rota.corRota.withValues(alpha: 0.7)]), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: rota.corRotaLight, blurRadius: 12, offset: const Offset(0, 4))]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.route_rounded, color: ThemeColors.of(context).surface, size: 24), const SizedBox(height: 2), Text('#${rota.id}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ThemeColors.of(context).surface))])),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(rota.operador, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: -0.3), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 6), Row(children: [Icon(Icons.inventory_2_rounded, size: 14, color: ThemeColors.of(context).textSecondary), const SizedBox(width: 4), Text('${rota.itensColetados}/${rota.totalItens} itens', style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textSecondary))])])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: rota.corRotaLight, borderRadius: BorderRadius.circular(8), border: Border.all(color: rota.corRotaLight, width: 2)), child: Text('${rota.progresso}%', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: rota.corRota))),
          ]),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: rota.progresso / 100, backgroundColor: rota.corRotaLight, valueColor: AlwaysStoppedAnimation<Color>(rota.corRota), minHeight: 8)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: ThemeColors.of(context).textSecondary, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Expanded(child: Column(children: [Icon(Icons.access_time_rounded, size: 20, color: rota.corRota), const SizedBox(height: 4), Text(rota.tempoDecorrido, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: rota.corRota)), const Text('Tempo', style: TextStyle(fontSize: 10, color: ThemeColors.of(context).textSecondary))])),
              Container(width: 1, height: 50, color: ThemeColors.of(context).textSecondary),
              Expanded(child: Column(children: [Icon(Icons.location_on_rounded, size: 20, color: rota.corRota), const SizedBox(height: 4), Text(rota.zonaAtual, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: rota.corRota)), const Text('Zona', style: TextStyle(fontSize: 10, color: ThemeColors.of(context).textSecondary))])),
            ]),
          ),
        ]),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), icon: const Icon(Icons.route_rounded, color: ThemeColors.of(context).blueCyan, size: 56), title: const Text('Smart Route'), content: const SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Guia LED inteligente para picking:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), SizedBox(height: 16), Text(' LED guia o operador at o produto', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Rota otimizada para menor tempo', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Confirma??o por scan ou toque', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Reduz erros de picking em 95%', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Aumenta produtividade em 40%', style: TextStyle(fontSize: 13, height: 1.5))])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendi'))]));
  }

  void _salvarConfiguracoes() async {
    await ref.read(smartRouteProvider.notifier).salvarConfiguracoes();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Row(children: [Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('Configura??es Salvas!', style: TextStyle(fontWeight: FontWeight.bold)), Text('Smart Route configurado', style: TextStyle(fontSize: 12))]))]), backgroundColor: ThemeColors.of(context).success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
  }
}








