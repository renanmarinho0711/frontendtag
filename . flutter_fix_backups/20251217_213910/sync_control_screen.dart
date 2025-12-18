import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/sync/presentation/screens/sync_settings_screen.dart';
import 'package:tagbean/features/sync/presentation/screens/sync_log_screen.dart';
import 'package:tagbean/features/sync/presentation/providers/sync_provider.dart';
import 'package:tagbean/features/sync/data/models/sync_models.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';

class SincronizacaoControleScreen extends ConsumerStatefulWidget {
  const SincronizacaoControleScreen({super.key});

  @override
  ConsumerState<SincronizacaoControleScreen> createState() => _SincronizacaoControleScreenState();
}

class _SincronizacaoControleScreenState extends ConsumerState<SincronizacaoControleScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;

  // Obtm histórico do provider
  List<SyncHistoryEntry> get _historico => ref.watch(syncHistoryProvider);
  
  // Obtm status de sincronização do provider  
  bool get _sincronizando => ref.watch(isSyncingProvider);
  
  // Progresso atual (do provider)
  double get _progressoAtual => ref.watch(syncProvider).progress;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.of(context);
    
    return Scaffold(
      backgroundColor: colors.surface,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(
              height: AppSizes.spacingMd.get(isMobile, isTablet),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              child: Column(
                children: [
                  _buildInfoCard(),
                  SizedBox(
                    height: AppSizes.spacingMd.get(isMobile, isTablet),
                  ),
                  _buildStatusCard(),
                  SizedBox(
                    height: AppSizes.spacingMd.get(isMobile, isTablet),
                  ),
                  _buildResultadosCard(),
                  SizedBox(
                    height: AppSizes.spacingMd.get(isMobile, isTablet),
                  ),
                  _buildAcoesRapidas(),
                  SizedBox(
                    height: AppSizes.spacingMd.get(isMobile, isTablet),
                  ),
                  _buildHistoricoCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final colors = ThemeColors.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
        vertical: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: AppGradients.darkBackground(context),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimary.withValues(alpha: 0.4),
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 15,
              tablet: 18,
              desktop: 20,
            ),
            offset: Offset(0, isMobile ? 6 : (isTablet ? 7 : 8)),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: colors.surfaceOverlay20,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getResponsiveBorderRadius(
                  context,
                  mobile: 12,
                  tablet: 13,
                  desktop: 14,
                ),
              ),
            ),
            child: Icon(
              Icons.sync_rounded,
              color: colors.surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.spacingSm.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sincronização',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 18,
                      mobileFontSize: 16,
                      tabletFontSize: 17,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: colors.surface,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(
                  height: AppSizes.paddingXxs.get(isMobile, isTablet),
                ),
                Text(
                  'Controle de integração com ERP',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 10,
                      tabletFontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: colors.surfaceOverlay70,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
              vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: colors.success.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(
                isMobile ? 8 : 10,
              ),
              border: Border.all(color: colors.success.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  size: AppSizes.iconNano.get(isMobile, isTablet),
                  color: colors.success,
                ),
                SizedBox(
                  width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10,
                      tabletFontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: colors.surface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    final colors = ThemeColors.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.successPastel, colors.materialTeal.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 16,
        ),
        border: Border.all(
          color: colors.successLight,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingSmAlt.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(
                isMobile ? 8 : 10,
              ),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: colors.successIcon,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sobre este Módulo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 13,
                      tabletFontSize: 13,
                    ),
                    fontWeight: FontWeight.bold,
                    color: colors.successText,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(
                  height: AppSizes.extraSmallPadding.get(isMobile, isTablet),
                ),
                Text(
                  'Controle total da integração com ERP, sincronizando produtos, preços e tags em tempo real com agendamentos automáticos.',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
                    ),
                    color: colors.successText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final colors = ThemeColors.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.success, colors.greenTeal],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.success.withValues(alpha: 0.3),
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 15,
              tablet: 18,
              desktop: 20,
            ),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceOverlay20,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getResponsiveBorderRadius(
                      context,
                      mobile: 10,
                      tablet: 11,
                      desktop: 12,
                    ),
                  ),
                ),
                child: Icon(
                  Icons.cloud_done_rounded,
                  color: colors.surface,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                    Text(
                      'ERP CONECTADO',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 18,
                          mobileFontSize: 16,
                          tabletFontSize: 17,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: colors.surface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.spacingMicro.get(isMobile, isTablet),
                    ),
                    Text(
                      'Status da Conexo',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 12,
                          mobileFontSize: 11,
                        ),
                      overflow: TextOverflow.ellipsis,
                        color: colors.surfaceOverlay70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.spacingMd.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingMd.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: colors.surfaceOverlay20,
              borderRadius: BorderRadius.circular(
                AppSizes.paddingLg.get(isMobile, isTablet),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: colors.surfaceOverlay90,
                        size: AppSizes.iconSmall.get(isMobile, isTablet),
                      ),
                      SizedBox(
                        height: AppSizes.spacingXsAlt.get(isMobile, isTablet),
                      ),
                      Text(
                        '14:32',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 18,
                            mobileFontSize: 16,
                            tabletFontSize: 17,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: colors.surface,
                        ),
                      ),
                      Text(
                        'Última Sync',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 11,
                            mobileFontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                          color: colors.surfaceOverlay90,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: isMobile ? 50 : (isTablet ? 55 : 60),
                  color: colors.surfaceOverlay30,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        color: colors.surfaceOverlay90,
                        size: AppSizes.iconSmall.get(isMobile, isTablet),
                      ),
                      SizedBox(
                        height: AppSizes.spacingXsAlt.get(isMobile, isTablet),
                      ),
                      Text(
                        '12 min',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 16,
                            mobileFontSize: 14,
                            tabletFontSize: 15,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: colors.surface,
                        ),
                      ),
                      Text(
                        'Prxima Auto',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 10,
                            mobileFontSize: 9,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: colors.surfaceOverlay90,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: isMobile ? 50 : (isTablet ? 55 : 60),
                  color: colors.surfaceOverlay30,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer_rounded,
                        color: colors.surfaceOverlay90,
                        size: AppSizes.iconSmall.get(isMobile, isTablet),
                      ),
                      SizedBox(
                        height: AppSizes.spacingXsAlt.get(isMobile, isTablet),
                      ),
                      Text(
                        '2m 15s',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 16,
                            mobileFontSize: 14,
                            tabletFontSize: 15,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: colors.surface,
                        ),
                      ),
                      Text(
                        'Durao',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 10,
                            mobileFontSize: 9,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: colors.surfaceOverlay90,
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
    );
  }

  Widget _buildResultadosCard() {
    final colors = ThemeColors.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimaryOverlay05,
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 15,
              tablet: 18,
              desktop: 20,
            ),
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
                padding: EdgeInsets.all(
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colors.primary, colors.blueDark],
                  ),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getResponsiveBorderRadius(
                      context,
                      mobile: 10,
                      tablet: 11,
                      desktop: 12,
                    ),
                  ),
                ),
                child: Icon(
                  Icons.assessment_rounded,
                  color: colors.surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Última Sincronização',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 16,
                      mobileFontSize: 15,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SincronizacaoLogScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.list_rounded,
                  size: AppSizes.iconTiny.get(isMobile, isTablet),
                ),
                label: Text(
                  'Ver Log',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                    ),
                  overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.spacingMd.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _buildResultadoItem('1.234', 'Produtos', Icons.inventory_2_rounded, colors.primary),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildResultadoItem('987', 'Tags', Icons.label_rounded, colors.success),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildResultadoItem('0', 'Erros', Icons.error_rounded, colors.error),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultadoItem(String value, String label, IconData icon, Color color) {
    final colors = ThemeColors.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 10,
            tablet: 11,
            desktop: 12,
          ),
        ),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: AppSizes.iconMedium.get(isMobile, isTablet),
          ),
          SizedBox(
            height: AppSizes.spacingXs.get(isMobile, isTablet),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 18,
                mobileFontSize: 16,
                tabletFontSize: 17,
              ),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 11,
                mobileFontSize: 10,
              ),
            overflow: TextOverflow.ellipsis,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcoesRapidas() {
    final colors = ThemeColors.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimary.withValues(alpha: 0.06),
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
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
                baseFontSize: 16,
                mobileFontSize: 15,
              ),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(
            height: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAcaoButtonHorizontal(
              'Sincronizar Tudo',
              'Sincronizar todos os dados com o ERP',
              Icons.sync_rounded,
              [colors.syncComplete, colors.syncCompleteDark],
              _iniciarSincronizacao,
            ),
            SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
            _buildAcaoButtonHorizontal(
              'Apenas Preços',
              'Atualizar somente os preços dos produtos',
              Icons.attach_money_rounded,
              [colors.syncPricesOnly, colors.syncPricesOnlyDark],
              () => _sincronizarParcial('Preços'),
            ),
            SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
            _buildAcaoButtonHorizontal(
              'Produtos Novos',
              'Sincronizar apenas produtos novos',
              Icons.new_releases_rounded,
              [colors.syncNewProducts, colors.syncNewProductsDark],
              () => _sincronizarParcial('Produtos Novos'),
            ),
            SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
            _buildAcaoButtonHorizontal(
              'Configurações',
              'Ajustar configurações de sincronização',
              Icons.settings_rounded,
              [colors.syncSettings, colors.syncSettingsDark],
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SincronizacaoConfiguracoesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        ],
      ),
    );
  }

  Widget _buildAcaoButton(String label, IconData icon, List<Color> gradient, VoidCallback onPressed) {
    final colors = ThemeColors.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(
          AppSizes.paddingLg.get(isMobile, isTablet),
        ),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: 0.3),
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 10,
              tablet: 11,
              desktop: 12,
            ),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(
            AppSizes.paddingLg.get(isMobile, isTablet),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              AppSizes.paddingMd.get(isMobile, isTablet),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: colors.surface,
                  size: AppSizes.iconLarge.get(isMobile, isTablet),
                ),
                SizedBox(
                  height: AppSizes.spacingXs.get(isMobile, isTablet),
                ),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                    ),
                    fontWeight: FontWeight.bold,
                    color: colors.surface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAcaoButtonHorizontal(
    String label,
    String subtitle,
    IconData icon,
    List<Color> gradient,
    VoidCallback onPressed,
  ) {
    final colors = ThemeColors.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.paddingXs.get(isMobile, isTablet)),
              decoration: BoxDecoration(
                color: colors.surfaceOverlay20,
                borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, isTablet)),
              ),
              child: Icon(
                icon,
                color: colors.surface,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
            ),
            SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                        tabletFontSize: 13,
                      ),
                      fontWeight: FontWeight.w600,
                      color: colors.surface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                        tabletFontSize: 10,
                      ),
                      color: colors.surface.withValues(alpha: 0.85),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: colors.surfaceOverlay80,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 16,
                tablet: 17,
                desktop: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricoCard() {
    final colors = ThemeColors.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimaryOverlay05,
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 15,
              tablet: 18,
              desktop: 20,
            ),
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
                padding: EdgeInsets.all(
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colors.textSecondary, colors.textPrimary],
                  ),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getResponsiveBorderRadius(
                      context,
                      mobile: 10,
                      tablet: 11,
                      desktop: 12,
                    ),
                  ),
                ),
                child: Icon(
                  Icons.history_rounded,
                  color: colors.surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Text(
                'Histórico Recente',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.spacingMd.get(isMobile, isTablet),
          ),
          if (_historico.isEmpty)
            _buildHistoricoEmpty()
          else
            ..._historico.map((item) => _buildHistoricoItem(item)),
        ],
      ),
    );
  }

  Widget _buildHistoricoEmpty() {
    final colors = ThemeColors.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.paddingXl.get(isMobile, isTablet),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sync_disabled_rounded,
            size: isMobile ? 36 : 48,
            color: colors.textSecondaryOverlay50,
          ),
          SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
          Text(
            'Nenhuma sincronização realizada',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
              ),
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.spacingXs.get(isMobile, isTablet)),
          Text(
            'Inicie uma sincronização para ver o histórico aqui',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                mobileFontSize: 11,
              ),
              color: colors.textSecondaryOverlay70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricoItem(SyncHistoryEntry item) {
    final colors = ThemeColors.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final isSuccess = item.status == SyncStatus.success;

    return Container(
      margin: EdgeInsets.only(
        bottom: AppSizes.spacingSmAlt.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingSm.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: isSuccess ? colors.successPastel : colors.errorPastel,
        borderRadius: BorderRadius.circular(
          AppSizes.paddingLg.get(isMobile, isTablet),
        ),
        border: Border.all(
          color: isSuccess ?  colors.successLight : colors.errorLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
            color: isSuccess ? colors.success : colors.error,
            size: AppSizes.iconLarge.get(isMobile, isTablet),
          ),
          SizedBox(
            width: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.type.label,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 13,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: AppSizes.spacingXs.get(isMobile, isTablet),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
                        vertical: AppSizes.paddingMicro2.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        color: isSuccess ? colors.success : colors.error,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.status.label,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 9,
                            mobileFontSize: 8,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: colors.surface,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSizes.spacingXxsAlt.get(isMobile, isTablet),
                ),
                Text(
                  '${item.totalItems} itens',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.startedAt.hour.toString().padLeft(2, '0')}:${item.startedAt.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 12,
                    mobileFontSize: 11,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item.durationFormatted,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 10,
                    mobileFontSize: 9,
                  ),
                overflow: TextOverflow.ellipsis,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _iniciarSincronizacao() async {
    final colors = ThemeColors.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final workContext = ref.read(workContextProvider);
    
    if (!workContext.isLoaded || (workContext.context.currentStoreId?.isEmpty ?? true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Selecione uma loja antes de sincronizar'),
          backgroundColor: colors.warning,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getResponsiveBorderRadius(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: ResponsiveHelper.getResponsiveWidth(
                context,
                mobile: 40,
                tablet: 45,
                desktop: 50,
              ),
              height: ResponsiveHelper.getResponsiveHeight(
                context,
                mobile: 40,
                tablet: 45,
                desktop: 50,
              ),
              child: const CircularProgressIndicator(),
            ),
            SizedBox(
              height: AppSizes.spacingLgAlt.get(isMobile, isTablet),
            ),
            Text(
              'Sincronizando...',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 16,
                  mobileFontSize: 15,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: AppSizes.spacingSmAlt.get(isMobile, isTablet),
            ),
            Text(
              'Aguarde enquanto sincronizamos os dados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 12,
                  mobileFontSize: 11,
                ),
              overflow: TextOverflow.ellipsis,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );

    // Executa sincronização real
    final result = await ref.read(syncProvider.notifier).syncTags(
      workContext.context.currentStoreId ?? '',
    );
    
    if (!mounted) return;
    Navigator.pop(context);
    
    if (result != null && result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: colors.surface,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Text(
                'Sincronização completa! ${result.successCount} itens processados.',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          backgroundColor: colors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getResponsiveBorderRadius(
                context,
                mobile: 10,
                tablet: 11,
                desktop: 12,
              ),
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_rounded,
                color: colors.surface,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Text(
                result?.errorMessage ?? 'Erro ao sincronizar',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          backgroundColor: colors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getResponsiveBorderRadius(
                context,
                mobile: 10,
                tablet: 11,
                desktop: 12,
              ),
            ),
          ),
        ),
      );
    }
  }

  void _sincronizarParcial(String tipo) {
    final colors = ThemeColors.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: isMobile ? 16 : 18,
              height: isMobile ? 16 : 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(colors.surface),
              ),
            ),
            SizedBox(
              width: AppSizes.spacingBase.get(isMobile, isTablet),
            ),
            Text(
              'Sincronizando $tipo...',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                ),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getResponsiveBorderRadius(
              context,
              mobile: 10,
              tablet: 11,
              desktop: 12,
            ),
          ),
        ),
      ),
    );
  }
}






