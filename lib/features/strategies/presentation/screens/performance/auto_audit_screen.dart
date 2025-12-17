import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/strategies/data/providers/performance_provider.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';

class AuditoriaAutomaticaConfigScreen extends ConsumerStatefulWidget {
  const AuditoriaAutomaticaConfigScreen({super.key});

  @override
  ConsumerState<AuditoriaAutomaticaConfigScreen> createState() => _AuditoriaAutomaticaConfigScreenState();
}

class _AuditoriaAutomaticaConfigScreenState extends ConsumerState<AuditoriaAutomaticaConfigScreen>
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
    final state = ref.watch(autoAuditProvider);
    final notifier = ref.read(autoAuditProvider.notifier);

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
                    _buildConfigTab(state, notifier),
                    _buildHistoricoTab(state),
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
              onPressed: () => _salvarConfiguracoes(notifier),
              icon: Icon(
                Icons.save_rounded,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              label: Text(
                'Salvar',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              backgroundColor: ThemeColors.of(context).blueMain,
            ),
          Positioned(
            right: 0,
            bottom: state.fabExpanded ? 66 : 0,
            child: FloatingActionButton.small(
              heroTag: 'toggle',
              onPressed: () => notifier.toggleFabExpanded(),
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

  Widget _buildModernAppBar(AutoAuditState state, AutoAuditNotifier notifier) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
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
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textSecondary,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          Container(
            padding: EdgeInsets.all(AppSizes.paddingSmAlt3.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [ThemeColors.of(context).blueMain, ThemeColors.of(context).blueDark]),
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
            ),
            child: Icon(
              Icons.verified_user_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Auditoria Automatica',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Monitoramento Diario',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.info_outline_rounded,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
            onPressed: _showInfoDialog,
            color: ThemeColors.of(context).textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(AppSizes.paddingXxs.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 12 : (isTablet ? 14 : 16)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(colors: [ThemeColors.of(context).blueMain, ThemeColors.of(context).blueDark]),
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ThemeColors.of(context).surface,
        unselectedLabelColor: ThemeColors.of(context).textSecondary,
        labelStyle: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 11),
          fontWeight: FontWeight.bold,
        ),
        tabs: [
          Tab(
            icon: Icon(Icons.settings_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)),
            text: 'Configuracao',
          ),
          Tab(
            icon: Icon(Icons.history_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)),
            text: 'Historico',
          ),
        ],
      ),
    );
  }

  Widget _buildConfigTab(AutoAuditState state, AutoAuditNotifier notifier) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildModernAppBar(state, notifier),
          Padding(
            padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
            child: Column(
              children: [
                _buildHeader(state, notifier),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildHorarioCard(state, notifier),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildVerificacoesCard(state, notifier),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildEmailsCard(state, notifier),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildExecutarAgoraCard(state, notifier),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricoTab(AutoAuditState state) {
    return ListView.builder(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      itemCount: state.ultimasAuditorias.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: AppSizes.paddingBase.get(isMobile, isTablet)),
        child: _buildAuditoriaCard(state.ultimasAuditorias[index], index),
      ),
    );
  }

  Widget _buildHeader(AutoAuditState state, AutoAuditNotifier notifier) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ThemeColors.of(context).blueMain, ThemeColors.of(context).blueDark]),
        borderRadius: BorderRadius.circular(isMobile ? 20 : (isTablet ? 22 : 24)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).blueMain.withValues(alpha: 0.4),
            blurRadius: isMobile ? 20 : 25,
            offset: Offset(0, isMobile ? 10 : 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay20,
              borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
            ),
            child: Icon(
              Icons.shield_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Auditoria Diaria',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 17, mobileFontSize: 16),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                Text(
                  state.auditoriaAtiva ? 'Verificacoes ativadas' : 'Verificacoes desativadas',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).surfaceOverlay70,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 1.1,
            child: Switch(
              value: state.auditoriaAtiva,
              onChanged: (value) => notifier.setAuditoriaAtiva(value),
              activeThumbColor: ThemeColors.of(context).surface,
              activeTrackColor: ThemeColors.of(context).surfaceOverlay50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorarioCard(AutoAuditState state, AutoAuditNotifier notifier) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
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
      child: InkWell(
        onTap: () => _selecionarHorario(state, notifier),
        borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).blueMain.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
              ),
              child: Icon(
                Icons.schedule_rounded,
                color: ThemeColors.of(context).blueMain,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
            ),
            SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Horario de Execucao',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                  Text(
                    'Auditoria executada diariamente',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMdLg.get(isMobile, isTablet),
                vertical: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [ThemeColors.of(context).blueMain, ThemeColors.of(context).blueDark]),
                borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
                boxShadow: [
                  BoxShadow(
                    color: ThemeColors.of(context).blueMain.withValues(alpha: 0.3),
                    blurRadius: isMobile ? 8 : 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                state.formatHorario(context),
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).surface,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
            Icon(
              Icons.edit_rounded,
              size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
              color: ThemeColors.of(context).textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificacoesCard(AutoAuditState state, AutoAuditNotifier notifier) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.checklist_rounded,
                  color: ThemeColors.of(context).blueCyan,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Verificacoes Automaticas',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                  vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary]),
                  borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                ),
                child: Text(
                  '${state.totalVerificacoesAtivas}/${state.totalVerificacoes}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.cardPadding.get(isMobile, isTablet)),
          ...state.verificacoes.entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSizes.paddingSmAlt3.get(isMobile, isTablet)),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                  vertical: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: entry.value ? ThemeColors.of(context).blueCyan.withValues(alpha: 0.1) : ThemeColors.of(context).textSecondary,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  border: Border.all(color: entry.value ? ThemeColors.of(context).blueCyan.withValues(alpha: 0.3) : ThemeColors.of(context).textSecondary),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: entry.value,
                      onChanged: (value) => notifier.setVerificacao(entry.key, value ?? false),
                      activeColor: ThemeColors.of(context).blueCyan,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    Icon(
                      notifier.getIconForVerificacao(entry.key),
                      size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                      color: entry.value ? ThemeColors.of(context).blueCyan : ThemeColors.of(context).textSecondary,
                    ),
                    SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600,
                          color: entry.value ? ThemeColors.of(context).textPrimary : ThemeColors.of(context).textSecondary,
                          decoration: entry.value ? null : TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmailsCard(AutoAuditState state, AutoAuditNotifier notifier) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).orangeDark.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.email_rounded,
                  color: ThemeColors.of(context).orangeDark,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Alertas por E-mail',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [ThemeColors.of(context).orangeDark, ThemeColors.of(context).orangeDeep]),
                  borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.add_rounded,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                  ),
                  onPressed: () => _adicionarEmail(notifier),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          ...state.emailsAlertas.map((email) => Padding(
            padding: EdgeInsets.only(bottom: AppSizes.paddingSmAlt3.get(isMobile, isTablet)),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                vertical: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).warningPastel,
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                border: Border.all(color: ThemeColors.of(context).warningLight),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.mail_outline_rounded,
                    size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                    color: ThemeColors.of(context).warningDark,
                  ),
                  SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                  Expanded(
                    child: Text(
                      email,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                      color: ThemeColors.of(context).textSecondary,
                    ),
                    onPressed: () => notifier.removeEmail(email),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildExecutarAgoraCard(AutoAuditState state, AutoAuditNotifier notifier) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ThemeColors.of(context).successPastel, ThemeColors.of(context).materialTeal.withValues(alpha: 0.1)]),
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
        border: Border.all(color: ThemeColors.of(context).successLight, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_circle_rounded,
                color: ThemeColors.of(context).successIcon,
                size: AppSizes.iconLarge.get(isMobile, isTablet),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Text(
                'Executar Auditoria',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).successIcon,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          Text(
            'Execute uma auditoria manual agora para identificar problemas imediatamente.',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: state.executando ? null : () => _executarAuditoria(state, notifier),
              icon: state.executando
                  ? SizedBox(
                      width: AppSizes.iconSmall.get(isMobile, isTablet),
                      height: AppSizes.iconSmall.get(isMobile, isTablet),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
                      ),
                    )
                  : Icon(
                      Icons.play_arrow_rounded,
                      size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                    ),
              label: Text(
                state.executando ? 'Executando...' : 'Executar Agora',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                overflow: TextOverflow.ellipsis,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                ),
                backgroundColor: ThemeColors.of(context).greenMain.withValues(alpha: 0.8),
                foregroundColor: ThemeColors.of(context).surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditoriaCard(AuditRecordModel audit, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

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
        padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
          border: Border.all(color: audit.cor.withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: audit.cor.withValues(alpha: 0.15),
              blurRadius: isMobile ? 15 : 20,
              offset: Offset(0, isMobile ? 4 : 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [audit.cor, audit.cor.withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
                  ),
                  child: Icon(
                    audit.hasNoProblems ? Icons.check_circle_rounded : Icons.warning_rounded,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMedium.get(isMobile, isTablet),
                  ),
                ),
                SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        audit.data,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_rounded,
                            size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                            color: ThemeColors.of(context).textSecondary,
                          ),
                          SizedBox(width: AppSizes.paddingXxs.get(isMobile, isTablet)),
                          Text(
                            audit.duracao,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                            overflow: TextOverflow.ellipsis,
                              color: ThemeColors.of(context).textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                        vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        color: audit.cor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                      ),
                      child: Text(
                        '${audit.problemas}',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 17, mobileFontSize: 16),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: audit.cor,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                    Text(
                      'problemas',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9),
                      overflow: TextOverflow.ellipsis,
                        color: ThemeColors.of(context).textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
            Container(
              padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).textSecondary,
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.description_rounded,
                        size: AppSizes.iconTiny.get(isMobile, isTablet),
                        color: ThemeColors.of(context).textSecondary,
                      ),
                      SizedBox(width: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
                      Text(
                        'Detalhes',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
                  Text(
                    audit.detalhes,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                      vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: audit.cor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                          color: audit.cor,
                        ),
                        SizedBox(width: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                        Text(
                          audit.acoes,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                            color: audit.cor,
                          ),
                        ),
                      ],
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

  void _selecionarHorario(AutoAuditState state, AutoAuditNotifier notifier) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: state.horarioExecucao,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: ThemeColors.of(context).blueMain),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != state.horarioExecucao) {
      notifier.setHorarioExecucao(picked);
    }
  }

  void _adicionarEmail(AutoAuditNotifier notifier) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet))),
        title: Text(
          'Adicionar E-mail',
          style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 17)),
          overflow: TextOverflow.ellipsis,
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'E-mail',
            hintText: 'exemplo@tagbeans.com',
            prefixIcon: const Icon(Icons.email_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty && controller.text.contains('@')) {
                notifier.addEmail(controller.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).orangeDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
            ),
            child: Text(
              'Adicionar',
              style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _executarAuditoria(AutoAuditState state, AutoAuditNotifier notifier) async {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 18 : 20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).blueMain)),
            SizedBox(height: AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
            Text(
              'Executando Auditoria',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
            Text(
              'Analisando ${state.totalVerificacoesAtivas} verificações...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );

    // Executar auditoria via provider
    await notifier.executarAuditoria();
    
    if (!mounted) return;
    
    Navigator.pop(context); // Fecha o dialog
    
    final newState = ref.read(autoAuditProvider);
    final hasError = newState.error != null;
    final problemasEncontrados = newState.ultimasAuditorias.isNotEmpty 
        ? newState.ultimasAuditorias.first.problemas 
        : 0;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasError ? Icons.error_rounded : Icons.check_circle_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasError ? 'Erro na Auditoria' : 'Auditoria Concluída!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    hasError 
                        ? newState.error! 
                        : '$problemasEncontrados problemas encontrados',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: hasError ? ThemeColors.of(context).error : ThemeColors.of(context).greenMain,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
        action: hasError ? null : SnackBarAction(
          label: 'Ver Relatãrio',
          textColor: ThemeColors.of(context).surface,
          onPressed: () {
            // Navegar para relatãrio de auditoria
          },
        ),
      ),
    );
  }

  void _showInfoDialog() {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet))),
        icon: Icon(
          Icons.verified_user_rounded,
          color: ThemeColors.of(context).blueMain,
          size: AppSizes.iconHeroMd.get(isMobile, isTablet),
        ),
        title: Text(
          'Auditoria Automatica',
          style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 17)),
          overflow: TextOverflow.ellipsis,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sistema de verificacao diaria automatica:',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
              Text(
                'Identifica margens negativas e produtos parados',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                'Detecta problemas de precificacao automaticamente',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                'Monitora status das tags eletronicas',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                'Envia relatorios detalhados por e-mail',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                'Sugere acoes corretivas automaticamente',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Entendi',
              style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _salvarConfiguracoes(AutoAuditNotifier notifier) {
    final isMobile = ResponsiveHelper.isMobile(context);

    notifier.saveConfigurations();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
            Text(
              'Configurações de auditoria salvas com sucesso',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: ThemeColors.of(context).blueMain,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
      ),
    );
  }
}




