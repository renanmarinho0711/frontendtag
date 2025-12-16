import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/sync/presentation/screens/sync_settings_screen.dart';
import 'package:tagbean/features/sync/presentation/screens/sync_log_screen.dart';
import 'package:tagbean/features/sync/presentation/providers/sync_provider.dart';
import 'package:tagbean/features/sync/presentation/providers/minew_provider.dart';
import 'package:tagbean/features/sync/presentation/widgets/minew_stats_card.dart';
import 'package:tagbean/features/sync/data/models/sync_models.dart';
import 'package:tagbean/features/sync/data/exceptions/sync_exceptions.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

class SincronizacaoControleScreen extends ConsumerStatefulWidget {
  const SincronizacaoControleScreen({super.key});

  @override
  ConsumerState<SincronizacaoControleScreen> createState() => _SincronizacaoControleScreenState();
}

class _SincronizacaoControleScreenState extends ConsumerState<SincronizacaoControleScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;

  // Obtm histrico do provider
  List<SyncHistoryEntry> get _historico => ref.watch(syncHistoryProvider);
  
  // Obtm status de sincronizao do provider  
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
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
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
                  // Widget reutilizável de Minew Stats
                  _buildMinewSection(),
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
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.4),
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
              color: ThemeColors.of(context).surfaceOverlay20,
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
              color: ThemeColors.of(context).surface,
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
                  'Sincronizao',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 18,
                      mobileFontSize: 16,
                      tabletFontSize: 17,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(
                  height: AppSizes.paddingXxs.get(isMobile, isTablet),
                ),
                Text(
                  'Controle de integrao com ERP',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 10,
                      tabletFontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).surfaceOverlay70,
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
              color: ThemeColors.of(context).successLight,
              borderRadius: BorderRadius.circular(
                isMobile ? 8 : 10,
              ),
              border: Border.all(color: ThemeColors.of(context).success.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  size: AppSizes.iconNano.get(isMobile, isTablet),
                  color: ThemeColors.of(context).success,
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
                    color: ThemeColors.of(context).surface,
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
          colors: [ThemeColors.of(context).successPastel, ThemeColors.of(context).materialTealLight],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 16,
        ),
        border: Border.all(
          color: ThemeColors.of(context).successLight,
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
              color: ThemeColors.of(context).surface,
              borderRadius: BorderRadius.circular(
                isMobile ? 8 : 10,
              ),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: ThemeColors.of(context).successIcon,
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
                  'Sobre este Mdulo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 13,
                      tabletFontSize: 13,
                    ),
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).successText,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(
                  height: AppSizes.extraSmallPadding.get(isMobile, isTablet),
                ),
                Text(
                  'Controle total da integrao com ERP, sincronizando produtos, preos e tags em tempo real com agendamentos automticos.',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
                    ),
                    color: ThemeColors.of(context).successText,
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
          colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenTeal],
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
            color: ThemeColors.of(context).successLight,
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
                  color: ThemeColors.of(context).surfaceOverlay20,
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
                  color: ThemeColors.of(context).surface,
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
                        color: ThemeColors.of(context).surface,
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
                        color: ThemeColors.of(context).surfaceOverlay70,
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
              color: ThemeColors.of(context).surfaceOverlay20,
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
                        color: ThemeColors.of(context).surfaceOverlay90,
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
                          color: ThemeColors.of(context).surface,
                        ),
                      ),
                      Text(
                        'ltima Sync',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 11,
                            mobileFontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).surfaceOverlay90,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: isMobile ? 50 : (isTablet ? 55 : 60),
                  color: ThemeColors.of(context).surfaceOverlay30,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        color: ThemeColors.of(context).surfaceOverlay90,
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
                          color: ThemeColors.of(context).surface,
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
                          color: ThemeColors.of(context).surfaceOverlay90,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: isMobile ? 50 : (isTablet ? 55 : 60),
                  color: ThemeColors.of(context).surfaceOverlay30,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer_rounded,
                        color: ThemeColors.of(context).surfaceOverlay90,
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
                          color: ThemeColors.of(context).surface,
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
                          color: ThemeColors.of(context).surfaceOverlay90,
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
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
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
            color: ThemeColors.of(context).textPrimaryOverlay05,
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
                    colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],
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
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'ltima Sincronizao',
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
                child: _buildResultadoItem('1.234', 'Produtos', Icons.inventory_2_rounded, ThemeColors.of(context).primary),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildResultadoItem('987', 'Tags', Icons.label_rounded, ThemeColors.of(context).success),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildResultadoItem('0', 'Erros', Icons.error_rounded, ThemeColors.of(context).error),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultadoItem(String value, String label, IconData icon, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: colorLight,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 10,
            tablet: 11,
            desktop: 12,
          ),
        ),
        border: Border.all(color: colorLight),
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
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcoesRapidas() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
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
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
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
            'Aes Rpidas',
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
              [ThemeColors.of(context).syncComplete, ThemeColors.of(context).syncCompleteDark],
              _iniciarSincronizacao,
            ),
            SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
            _buildAcaoButtonHorizontal(
              'Apenas Preos',
              'Atualizar somente os preos dos produtos',
              Icons.attach_money_rounded,
              [ThemeColors.of(context).syncPricesOnly, ThemeColors.of(context).syncPricesOnlyDark],
              () => _sincronizarParcial('Preos'),
            ),
            SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
            _buildAcaoButtonHorizontal(
              'Produtos Novos',
              'Sincronizar apenas produtos novos',
              Icons.new_releases_rounded,
              [ThemeColors.of(context).syncNewProducts, ThemeColors.of(context).syncNewProductsDark],
              () => _sincronizarParcial('Produtos Novos'),
            ),
            SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
            _buildAcaoButtonHorizontal(
              'Configuraes',
              'Ajustar configuraes de sincronizao',
              Icons.settings_rounded,
              [ThemeColors.of(context).syncSettings, ThemeColors.of(context).syncSettingsDark],
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
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(
          AppSizes.paddingLg.get(isMobile, isTablet),
        ),
        boxShadow: [
          BoxShadow(
            color: gradient[0]Light,
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
        color: ThemeColors.of(context).transparent,
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
                  color: ThemeColors.of(context).surface,
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
                    color: ThemeColors.of(context).surface,
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
              color: gradient[0]Light,
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
                color: ThemeColors.of(context).surfaceOverlay20,
                borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, isTablet)),
              ),
              child: Icon(
                icon,
                color: ThemeColors.of(context).surface,
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
                      color: ThemeColors.of(context).surface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                        tabletFontSize: 10,
                      ),
                      color: ThemeColors.of(context).surface.withValues(alpha: 0.85),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: ThemeColors.of(context).surfaceOverlay80,
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

  /// Seção Minew Cloud - Usa widget reutilizável MinewStatsCard
  Widget _buildMinewSection() {
    // Obtém o storeId do contexto atual
    final workContext = ref.watch(workContextProvider);
    final storeId = workContext.context.currentStoreId;
    
    if (storeId == null) {
      return const SizedBox.shrink();
    }
    
    return MinewStatsCard(
      storeId: storeId,
      onSyncComplete: () => _syncMinewComplete(storeId),
      onImportTags: () => _importMinewTags(storeId),
    );
  }

  /// Executa sincronização completa com Minew Cloud
  Future<void> _syncMinewComplete(String storeId) async {
    final syncNotifier = ref.read(syncProvider.notifier);
    
    final result = await syncNotifier.syncMinewComplete(storeId);
    
    if (result != null) {
      // Força refresh das stats
      ref.read(minewStatsRefreshTriggerProvider.notifier).state++;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sync completo! Tags: ${result.tagsSync?.updated ?? 0}, '
              'Gateways: ${result.gatewaysSync?.updated ?? 0}',
            ),
            backgroundColor: ThemeColors.of(context).success,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro na sincronização'),
            backgroundColor: ThemeColors.of(context).error,
          ),
        );
      }
    }
  }

  /// Importa novas tags da Minew Cloud
  Future<void> _importMinewTags(String storeId) async {
    final syncNotifier = ref.read(syncProvider.notifier);
    
    final result = await syncNotifier.importMinewTags(storeId);
    
    if (result != null) {
      // Força refresh das stats
      ref.read(minewStatsRefreshTriggerProvider.notifier).state++;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Importação concluída! ${result.updated} novas tags',
            ),
            backgroundColor: ThemeColors.of(context).success,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao importar tags'),
            backgroundColor: ThemeColors.of(context).error,
          ),
        );
      }
    }
  }

  Widget _buildHistoricoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
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
            color: ThemeColors.of(context).textPrimaryOverlay05,
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
                    colors: [ThemeColors.of(context).textSecondary, ThemeColors.of(context).textPrimary],
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
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Text(
                'Histrico Recente',
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
            ..._historico.map((item) => _buildHistoricoItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildHistoricoEmpty() {
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
            color: ThemeColors.of(context).textSecondaryOverlay50,
          ),
          SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
          Text(
            'Nenhuma sincronizao realizada',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
              ),
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.spacingXs.get(isMobile, isTablet)),
          Text(
            'Inicie uma sincronizao para ver o histrico aqui',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                mobileFontSize: 11,
              ),
              color: ThemeColors.of(context).textSecondaryOverlay70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricoItem(SyncHistoryEntry item) {
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
        color: isSuccess ? ThemeColors.of(context).successPastel : ThemeColors.of(context).errorPastel,
        borderRadius: BorderRadius.circular(
          AppSizes.paddingLg.get(isMobile, isTablet),
        ),
        border: Border.all(
          color: isSuccess ?  ThemeColors.of(context).successLight : ThemeColors.of(context).errorLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
            color: isSuccess ? ThemeColors.of(context).success : ThemeColors.of(context).error,
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
                        color: isSuccess ? ThemeColors.of(context).success : ThemeColors.of(context).error,
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
                          color: ThemeColors.of(context).surface,
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
                    color: ThemeColors.of(context).textSecondary,
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
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _iniciarSincronizacao() async {
    final isMobile = ResponsiveHelper.isMobile(context);
    final workContext = ref.read(workContextProvider);
    
    if (!workContext.isLoaded || (workContext.context.currentStoreId?.isEmpty ?? true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Selecione uma loja antes de sincronizar'),
          backgroundColor: ThemeColors.of(context).warning,
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
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );

    // Executa sincronizao real
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
                color: ThemeColors.of(context).surface,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Text(
                'Sincronizao completa! ${result.successCount} itens processados.',
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
          backgroundColor: ThemeColors.of(context).success,
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
                color: ThemeColors.of(context).surface,
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
          backgroundColor: ThemeColors.of(context).error,
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
                valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
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








