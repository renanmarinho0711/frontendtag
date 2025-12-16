import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/features/strategies/data/providers/visual_provider.dart';

class MapaCalorConfigScreen extends ConsumerStatefulWidget {
  const MapaCalorConfigScreen({super.key});

  @override
  ConsumerState<MapaCalorConfigScreen> createState() => _MapaCalorConfigScreenState();
}

class _MapaCalorConfigScreenState extends ConsumerState<MapaCalorConfigScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
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
    final state = ref.watch(heatmapProvider);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildConfigTab(state),
                  _buildZonasTab(state),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          if (state.fabExpanded)
            FloatingActionButton.extended(
              heroTag: 'save',
              onPressed: _salvarConfiguracoes,
              icon: Icon(
                Icons.save_rounded,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              label: Text(
                'Salvar',
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
              backgroundColor: ThemeColors.of(context).error,
            ),
          Positioned(
            right: 0,
            bottom: state.fabExpanded ? 66 : 0,
            child: FloatingActionButton.small(
              heroTag: 'toggle',
              onPressed: () => ref.read(heatmapProvider.notifier).toggleFabExpanded(),
              backgroundColor: ThemeColors.of(context).textSecondary,
              child: Icon(
                state.fabExpanded ? Icons.close_rounded : Icons.add_rounded,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAppBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMdAlt2.get(isMobile, isTablet),
        vertical: AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: ThemeColors.of(context).textSecondary, size: AppSizes.iconMedium.get(isMobile, isTablet)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          Container(
            padding: EdgeInsets.all(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [ThemeColors.of(context).error, ThemeColors.of(context).errorDark]),
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
            child: Icon(Icons.heat_pump_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMedium.get(isMobile, isTablet)),
          ),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mapa de Calor', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                Text('Aten��o Visual Inteligente', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11), overflow: TextOverflow.ellipsis, color: ThemeColors.of(context).textSecondary)),
              ],
            ),
          ),
          IconButton(icon: Icon(Icons.info_outline_rounded, size: AppSizes.iconMedium.get(isMobile, isTablet)), onPressed: _showInfoDialog, color: ThemeColors.of(context).textSecondary),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingMd.get(isMobile, isTablet)),
      padding: EdgeInsets.all(AppSizes.paddingXxs.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
        boxShadow: [BoxShadow(color: ThemeColors.of(context).textPrimaryOverlay05, blurRadius: isMobile ? 8 : 10, offset: const Offset(0, 2))],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(gradient: LinearGradient(colors: [ThemeColors.of(context).error, ThemeColors.of(context).errorDark]), borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ThemeColors.of(context).surface,
        unselectedLabelColor: ThemeColors.of(context).textSecondary,
        labelStyle: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12), fontWeight: FontWeight.bold),
        tabs: [
          Tab(icon: Icon(Icons.settings_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)), text: 'Configura��o'),
          Tab(icon: Icon(Icons.map_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)), text: 'Zonas'),
        ],
      ),
    );
  }

  Widget _buildConfigTab(HeatmapState state) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildModernAppBar(),
          Padding(
            padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
            child: Column(
              children: [
                _buildHeader(state),
                SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                _buildIntegracaoCard(state),
                SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                _buildParametrosCard(state),
                SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                _buildOpcoesCard(state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZonasTab(HeatmapState state) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildModernAppBar(),
          Padding(
            padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.zonas.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: AppSizes.paddingBase.get(isMobile, isTablet)),
                child: _buildZonaCard(state.zonas[index], index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(HeatmapState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingXl.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ThemeColors.of(context).error, ThemeColors.of(context).errorDark]),
        borderRadius: BorderRadius.circular(isMobile ? 20 : (isTablet ? 22 : 24)),
        boxShadow: [BoxShadow(color: ThemeColors.of(context).error.withValues(alpha: 0.4), blurRadius: isMobile ? 20 : 25, offset: Offset(0, isMobile ? 10 : 12))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
            decoration: BoxDecoration(color: ThemeColors.of(context).surfaceOverlay20, borderRadius: BorderRadius.circular(isMobile ? 12 : (isTablet ? 14 : 16))),
            child: Icon(Icons.visibility_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMedium.get(isMobile, isTablet)),
          ),
          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Aten��o Direcionada', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 17, mobileFontSize: 15, tabletFontSize: 16), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold, color: ThemeColors.of(context).surface, letterSpacing: -0.8)),
                SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                Text(state.isStrategyActive ? 'ESLs piscando em zonas frias' : 'Sistema inativo', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12), overflow: TextOverflow.ellipsis, color: ThemeColors.of(context).surfaceOverlay70)),
              ],
            ),
          ),
          Transform.scale(scale: 1.1, child: Switch(value: state.isStrategyActive, onChanged: (value) => ref.read(heatmapProvider.notifier).setStrategyActive(value), activeColor: ThemeColors.of(context).surface, activeTrackColor: ThemeColors.of(context).surfaceOverlay50)),
        ],
      ),
    );
  }

  Widget _buildIntegracaoCard(HeatmapState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).primaryPastel]), borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)), border: Border.all(color: ThemeColors.of(context).info, width: 2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.videocam_rounded, color: ThemeColors.of(context).infoDark, size: AppSizes.iconExtraLarge.get(isMobile, isTablet)),
          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Integra��o com C�meras', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold)),
                SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                Text('Sistema detecta tr�fego em tempo real via an�lise de v�deo com IA', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11), overflow: TextOverflow.ellipsis, height: 1.5)),
              ],
            ),
          ),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingBase.get(isMobile, isTablet), vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
            decoration: BoxDecoration(color: ThemeColors.of(context).greenMain.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(isMobile ? 6 : 8), border: Border.all(color: ThemeColors.of(context).greenMain, width: 2)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.check_circle_rounded, size: AppSizes.iconTiny.get(isMobile, isTablet), color: ThemeColors.of(context).greenMain.withValues(alpha: 0.8)),
              SizedBox(width: AppSizes.paddingXxs.get(isMobile, isTablet)),
              Text('Conectado', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold, color: ThemeColors.of(context).successIcon)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildParametrosCard(HeatmapState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingXl.get(isMobile, isTablet)),
      decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)), boxShadow: [BoxShadow(color: ThemeColors.of(context).textPrimaryOverlay05, blurRadius: isMobile ? 15 : 20, offset: const Offset(0, 4))]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Container(padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)), decoration: BoxDecoration(color: ThemeColors.of(context).blueMain.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))), child: Icon(Icons.tune_rounded, color: ThemeColors.of(context).blueMain, size: AppSizes.iconMediumAlt.get(isMobile, isTablet))),
            SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
            Expanded(child: Text('Par�metros de Ativa��o', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold, letterSpacing: -0.5))),
          ]),
          SizedBox(height: AppSizes.paddingXl.get(isMobile, isTablet)),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.speed_rounded, size: AppSizes.iconMediumLarge.get(isMobile, isTablet), color: ThemeColors.of(context).blueMain),
            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
            Expanded(child: Text('Limite de Zona Fria', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600))),
            Container(padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingBase.get(isMobile, isTablet), vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet)), decoration: BoxDecoration(color: ThemeColors.of(context).blueMain.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))), child: Text('< ${state.limiteZonaFria.toStringAsFixed(0)}%', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15, tabletFontSize: 15), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold, color: ThemeColors.of(context).blueMain))),
          ]),
          SizedBox(height: AppSizes.paddingXs.get(isMobile, isTablet)),
          Container(padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)), decoration: BoxDecoration(color: ThemeColors.of(context).infoPastel, borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet))), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.info_rounded, size: AppSizes.iconTiny.get(isMobile, isTablet), color: ThemeColors.of(context).infoDark), SizedBox(width: AppSizes.paddingXs.get(isMobile, isTablet)), Expanded(child: Text('ESLs piscam quando tr�fego est� abaixo deste percentual', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10), overflow: TextOverflow.ellipsis, color: ThemeColors.of(context).infoDark)))])),
          Slider(value: state.limiteZonaFria, min: 10, max: 60, divisions: 50, label: '${state.limiteZonaFria.toStringAsFixed(0)}%', onChanged: (value) => ref.read(heatmapProvider.notifier).setLimiteZonaFria(value), activeColor: ThemeColors.of(context).blueMain),
          SizedBox(height: AppSizes.paddingXl.get(isMobile, isTablet)),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.wb_incandescent_rounded, size: AppSizes.iconMediumLarge.get(isMobile, isTablet), color: ThemeColors.of(context).orangeMain),
            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
            Expanded(child: Text('Intensidade do Piscar', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600))),
            Container(padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingBase.get(isMobile, isTablet), vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet)), decoration: BoxDecoration(color: ThemeColors.of(context).orangeMain.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))), child: DropdownButton<String>(value: state.intensidadePiscar, underline: const SizedBox(), items: ['Baixa', 'M�dia', 'Alta', 'Muito Alta'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13), overflow: TextOverflow.ellipsis)))).toList(), onChanged: (value) => ref.read(heatmapProvider.notifier).setIntensidadePiscar(value!), style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13), fontWeight: FontWeight.bold, color: ThemeColors.of(context).orangeMain))),
          ]),
          SizedBox(height: AppSizes.paddingXl.get(isMobile, isTablet)),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.refresh_rounded, size: AppSizes.iconMediumLarge.get(isMobile, isTablet), color: ThemeColors.of(context).purpleMedium),
            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
            Expanded(child: Text('Atualiza��o do Mapa', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600))),
            Container(padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingBase.get(isMobile, isTablet), vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet)), decoration: BoxDecoration(color: ThemeColors.of(context).purpleMedium.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))), child: Text('${state.intervaloAtualizacao} min', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15, tabletFontSize: 15), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold, color: ThemeColors.of(context).purpleMedium))),
          ]),
          Slider(value: state.intervaloAtualizacao.toDouble(), min: 5, max: 60, divisions: 11, label: '${state.intervaloAtualizacao} min', onChanged: (value) => ref.read(heatmapProvider.notifier).setIntervaloAtualizacao(value.toInt()), activeColor: ThemeColors.of(context).purpleMedium),
        ],
      ),
    );
  }

  Widget _buildOpcoesCard(HeatmapState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingXl.get(isMobile, isTablet)),
      decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)), boxShadow: [BoxShadow(color: ThemeColors.of(context).textPrimaryOverlay05, blurRadius: isMobile ? 15 : 20, offset: const Offset(0, 4))]),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _buildSwitchOption('Notificar Gestor', 'Alertar quando zona ficar muito fria', Icons.notifications_active_rounded, state.notificarGestor, (value) => ref.read(heatmapProvider.notifier).setNotificarGestor(value)),
        SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
        _buildSwitchOption('Integra��o com C�meras', 'Usar an�lise de v�deo para detec��o', Icons.videocam_rounded, state.integracaoCameras, (value) => ref.read(heatmapProvider.notifier).setIntegracaoCameras(value)),
      ]),
    );
  }

  Widget _buildSwitchOption(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    final isMobile = ResponsiveHelper.isMobile(context);
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(color: value ? ThemeColors.of(context).error.withValues(alpha: 0.1) : ThemeColors.of(context).textSecondary, borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)), border: Border.all(color: value ? ThemeColors.of(context).errorLight : ThemeColors.of(context).textSecondary)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: value ? ThemeColors.of(context).error : ThemeColors.of(context).textSecondaryOverlay70, size: AppSizes.iconMediumLarge.get(isMobile, isTablet)),
        SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
        Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold)), SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)), Text(subtitle, style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11), overflow: TextOverflow.ellipsis, color: ThemeColors.of(context).textSecondary))])),
        Transform.scale(scale: 0.95, child: Switch(value: value, onChanged: onChanged, activeColor: ThemeColors.of(context).error)),
      ]),
    );
  }

  Widget _buildZonaCard(HeatmapZoneModel zona, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) => Transform.translate(offset: Offset(0, 20 * (1 - value)), child: Opacity(opacity: value, child: child)),
      child: Container(
        padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
        decoration: BoxDecoration(color: ThemeColors.of(context).surface, borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)), border: Border.all(color: zona.cor.withValues(alpha: 0.3), width: 2), boxShadow: [BoxShadow(color: zona.cor.withValues(alpha: 0.15), blurRadius: isMobile ? 15 : 20, offset: Offset(0, isMobile ? 4 : 6))]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Container(padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)), decoration: BoxDecoration(gradient: LinearGradient(colors: [zona.cor, zona.cor.withValues(alpha: 0.7)]), borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))), child: Icon(zona.icone, color: ThemeColors.of(context).surface, size: AppSizes.iconMedium.get(isMobile, isTablet))),
            SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
            Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(zona.nome, style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold)), SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)), Container(padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingXs.get(isMobile, isTablet), vertical: AppSizes.paddingXxs.get(isMobile, isTablet)), decoration: BoxDecoration(color: zona.cor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Text(zona.status, style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10), fontWeight: FontWeight.bold, color: zona.cor)))])),
            Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [Text('${zona.trafego}%', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 20, mobileFontSize: 18, tabletFontSize: 19), fontWeight: FontWeight.bold, color: zona.cor)), Row(mainAxisSize: MainAxisSize.min, children: [Icon(zona.variacao >= 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, size: 12, color: zona.variacao >= 0 ? ThemeColors.of(context).greenMain : ThemeColors.of(context).error), Text(zona.variacaoFormatted, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: zona.variacao >= 0 ? ThemeColors.of(context).greenMain : ThemeColors.of(context).error))])]),
          ]),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildZonaStat(Icons.local_offer_rounded, '${zona.tags}', 'Tags'), _buildZonaStat(Icons.people_rounded, '${zona.pessoas}', 'Pessoas')]),
        ]),
      ),
    );
  }

  Widget _buildZonaStat(IconData icon, String value, String label) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    return Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: AppSizes.iconSmall.get(isMobile, isTablet), color: ThemeColors.of(context).textSecondary), const SizedBox(height: 4), Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), Text(label, style: TextStyle(fontSize: 10, color: ThemeColors.of(context).textSecondary))]);
  }

  void _showInfoDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).error, size: 56), title: const Text('Mapa de Calor'), content: const SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Direciona aten��o para zonas frias da loja:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), SizedBox(height: 16), Text(' ESLs piscam em �reas pouco visitadas', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Integra��o com c�meras para detec��o', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Ajuste autom�tico de pre�os', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Aumento de tr�fego em zonas frias', style: TextStyle(fontSize: 13, height: 1.5))])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendi'))]));
  }

  void _salvarConfiguracoes() async {
    await ref.read(heatmapProvider.notifier).salvarConfiguracoes();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Row(children: [Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('Configura��es Salvas!', style: TextStyle(fontWeight: FontWeight.bold)), Text('Mapa de calor configurado', style: TextStyle(fontSize: 12))]))]), backgroundColor: ThemeColors.of(context).error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
  }
}







