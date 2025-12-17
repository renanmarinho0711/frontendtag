import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';

import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/features/tags/data/models/tag_model.dart';
import 'package:tagbean/features/tags/presentation/providers/tags_provider.dart';
import 'package:tagbean/features/products/presentation/providers/products_state_provider.dart';
import 'package:tagbean/features/products/data/models/product_models.dart';
import 'package:tagbean/features/products/presentation/widgets/barcode_scanner_widget.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';

class EtiquetasEditarScreen extends ConsumerStatefulWidget {
  final TagModel tag;

  const EtiquetasEditarScreen({super.key, required this.tag});

  @override
  ConsumerState<EtiquetasEditarScreen> createState() =>
      _EtiquetasEditarScreenState();
}

class _EtiquetasEditarScreenState extends ConsumerState<EtiquetasEditarScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  late TextEditingController _localizacaoController;
  late TextEditingController _observacoesController;
  late String _status;
  bool _alteracoesFeitas = false;
  bool _testingSync = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _localizacaoController = TextEditingController(
        text: widget.tag.location ?? 'Localizao no definida');
    _observacoesController =
        TextEditingController(text: widget.tag.notes ?? '');
    _status = widget.tag.status == TagStatus.online ? 'Ativo' : 'Inativo';

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();

    _localizacaoController
        .addListener(() => setState(() => _alteracoesFeitas = true));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _localizacaoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  // Helper methods para derivar cores e cones do TagModel
  Color _getStatusColor() {
    switch (widget.tag.status) {
      case TagStatus.online:
        return ThemeColors.of(context).greenMain;
      case TagStatus.offline:
        return ThemeColors.of(context).textSecondary;
      case TagStatus.lowBattery:
        return ThemeColors.of(context).orangeMain;
      case TagStatus.bound:
        return ThemeColors.of(context).blueMain;
      case TagStatus.unbound:
        return ThemeColors.of(context).blueCyan;
      case TagStatus.unknown:
        return ThemeColors.of(context).textSecondary;
    }
  }

  IconData _getStatusIcon() {
    switch (widget.tag.status) {
      case TagStatus.online:
        return Icons.check_circle_rounded;
      case TagStatus.offline:
        return Icons.cancel_rounded;
      case TagStatus.lowBattery:
        return Icons.battery_alert_rounded;
      case TagStatus.bound:
        return Icons.link_rounded;
      case TagStatus.unbound:
        return Icons.link_off_rounded;
      case TagStatus.unknown:
        return Icons.help_outline_rounded;
    }
  }

  String _getStatusText() {
    switch (widget.tag.status) {
      case TagStatus.online:
        return 'Online';
      case TagStatus.offline:
        return 'Offline';
      case TagStatus.lowBattery:
        return 'Bateria Baixa';
      case TagStatus.bound:
        return 'Vinculada';
      case TagStatus.unbound:
        return 'Disponvel';
      case TagStatus.unknown:
        return 'Desconhecido';
    }
  }

  IconData _getBatteryIcon() {
    final level = widget.tag.batteryLevel;
    if (level >= 80) return Icons.battery_full_rounded;
    if (level >= 60) return Icons.battery_5_bar_rounded;
    if (level >= 40) return Icons.battery_3_bar_rounded;
    if (level >= 20) return Icons.battery_2_bar_rounded;
    return Icons.battery_alert_rounded;
  }

  String _getSignalText() {
    final rssi = widget.tag.rssi ?? -100;
    if (rssi >= -50) return 'Excelente';
    if (rssi >= -60) return 'Bom';
    if (rssi >= -70) return 'Regular';
    return 'Fraco';
  }

  String _formatLastSync() {
    final lastSync = widget.tag.lastSync;
    if (lastSync == null) return '--:--';
    final diff = DateTime.now().difference(lastSync);
    if (diff.inMinutes < 1) return 'Agora';
    if (diff.inHours < 1) return '${diff.inMinutes}min';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).backgroundLight,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    AppSizes.cardPadding.get(isMobile, isTablet),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildModernAppBar(),
                      SizedBox(
                        height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                      ),
                      _buildTagInfoCard(),
                      SizedBox(
                        height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                      ),
                      if (widget.tag.productId != null) ...[
                        _buildProductCard(),
                        SizedBox(
                          height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                        ),
                      ],
                      _buildMetricsCard(),
                      SizedBox(
                        height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                      ),
                      _buildEditCard(),
                      SizedBox(
                        height: AppSizes.cardPadding.get(isMobile, isTablet),
                      ),
                      _buildActionButtons(),
                      SizedBox(
                        height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModernAppBar() {
    final statusColor = _getStatusColor();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
        vertical: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).backgroundLight,
              borderRadius: BorderRadius.circular(
                  AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textPrimary,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingSmAlt.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  statusColor,
                  statusColor.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(
                  AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
            child: Icon(
              _getStatusIcon(),
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Editar Tag',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 18,
                      mobileFontSize: 16,
                      tabletFontSize: 17,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  widget.tag.macAddress,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (_alteracoesFeitas)
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                  vertical: AppSizes.paddingXsAlt5.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).orangeMain.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                      AppSizes.paddingBase.get(isMobile, isTablet)),
                  border: Border.all(color: ThemeColors.of(context).warningLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_rounded,
                      size: AppSizes.iconExtraSmallAlt2.get(isMobile, isTablet),
                      color: ThemeColors.of(context).warningDark,
                    ),
                    SizedBox(
                      width: AppSizes.paddingXxs.get(isMobile, isTablet),
                    ),
                    Flexible(
                      child: Text(
                        'Editando',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 10,
                            mobileFontSize: 9,
                            tabletFontSize: 9,
                          ),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.of(context).warningDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTagInfoCard() {
    final statusColor = _getStatusColor();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        AppSizes.paddingXl.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor,
            statusColor.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 20 : (isTablet ? 22 : 24),
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.3),
            blurRadius: isMobile ? 15 : 20,
            offset: Offset(0, isMobile ? 8 : 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingMdAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 14 : (isTablet ? 15 : 16),
                  ),
                ),
                child: Icon(
                  Icons.label_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconExtraLarge.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingMdAlt.get(isMobile, isTablet),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tag.macAddress,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 24,
                          mobileFontSize: 18,
                          tabletFontSize: 20,
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
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            AppSizes.paddingSmAlt.get(isMobile, isTablet),
                        vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).surfaceOverlay20,
                        borderRadius: BorderRadius.circular(
                            AppSizes.paddingBase.get(isMobile, isTablet)),
                      ),
                      child: Text(
                        _getStatusText(),
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 12,
                            mobileFontSize: 11,
                            tabletFontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.of(context).surface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Bateria',
                    '${widget.tag.batteryLevel}%',
                    _getBatteryIcon(),
                  ),
                ),
                Container(
                  width: 1,
                  color: ThemeColors.of(context).surfaceOverlay30,
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Sinal',
                    _getSignalText(),
                    Icons.signal_cellular_alt_rounded,
                  ),
                ),
                Container(
                  width: 1,
                  color: ThemeColors.of(context).surfaceOverlay30,
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Sync',
                    _formatLastSync(),
                    Icons.sync_rounded,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: ThemeColors.of(context).surface,
            size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
          ),
          SizedBox(
            height: AppSizes.paddingXxs.get(isMobile, isTablet),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 12,
                tabletFontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).surface,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 10,
                mobileFontSize: 9,
                tabletFontSize: 9,
              ),
              overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).surfaceOverlay90,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).successPastel,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        border: Border.all(color: ThemeColors.of(context).successLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingXs.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).greenMain,
                  borderRadius: BorderRadius.circular(
                      AppSizes.paddingSm.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Produto Associado',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 16,
                      mobileFontSize: 14,
                      tabletFontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).successIcon,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          ),
          Text(
            widget.tag.productName ?? 'Produto #${widget.tag.productId}',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 16,
                mobileFontSize: 14,
                tabletFontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              Icons.open_in_new_rounded,
                              color: ThemeColors.of(context).surface,
                              size: AppSizes.iconMediumSmall
                                  .get(isMobile, isTablet),
                            ),
                            SizedBox(
                              width:
                                  AppSizes.paddingBase.get(isMobile, isTablet),
                            ),
                            Expanded(
                              child: Text(
                                'Abrindo produto...',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 14,
                                    mobileFontSize: 13,
                                    tabletFontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppSizes.paddingBase.get(isMobile, isTablet)),
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.open_in_new_rounded,
                    size: AppSizes.iconTiny.get(isMobile, isTablet),
                  ),
                  label: Text(
                    'Ver',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 12,
                        mobileFontSize: 11,
                        tabletFontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.paddingBase.get(isMobile, isTablet),
                      horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
                    ),
                    foregroundColor: ThemeColors.of(context).greenMain,
                    side: BorderSide(color: ThemeColors.of(context).greenMain),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppSizes.paddingSm.get(isMobile, isTablet)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _desassociarProduto,
                  icon: Icon(
                    Icons.link_off_rounded,
                    size: AppSizes.iconTiny.get(isMobile, isTablet),
                  ),
                  label: Text(
                    'Desassociar',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 12,
                        mobileFontSize: 11,
                        tabletFontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.paddingBase.get(isMobile, isTablet),
                      horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
                    ),
                    backgroundColor: ThemeColors.of(context).orangeMain,
                    foregroundColor: ThemeColors.of(context).surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppSizes.paddingSm.get(isMobile, isTablet)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingXs.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: AppGradients.syncBlue(context),
                  borderRadius: BorderRadius.circular(
                      AppSizes.paddingSm.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.analytics_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Mtricas',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 16,
                      mobileFontSize: 14,
                      tabletFontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 
                  (AppSizes.paddingBase.get(isMobile, isTablet) * 2)) / 3;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _buildMetricItem(
                      'Tipo',
                      widget.tag.type.name.toUpperCase(),
                      Icons.category_rounded,
                      ThemeColors.of(context).blueCyan,
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _buildMetricItem(
                      'Tela',
                      widget.tag.screenSize ?? 'N/A',
                      Icons.aspect_ratio_rounded,
                      ThemeColors.of(context).blueMain,
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _buildMetricItem(
                      'Bateria',
                      '${widget.tag.batteryLevel}%',
                      _getBatteryIcon(),
                      widget.tag.batteryLevel > 20
                          ? ThemeColors.of(context).greenMain
                          : ThemeColors.of(context).orangeMain,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            color: color,
          ),
          SizedBox(
            height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 12,
                tabletFontSize: 13,
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
                baseFontSize: 10,
                mobileFontSize: 9,
                tabletFontSize: 9,
              ),
              overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingXs.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ThemeColors.of(context).success,
                      ThemeColors.of(context).greenDark
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                      AppSizes.paddingSm.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.edit_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Editar Informações',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 16,
                      mobileFontSize: 14,
                      tabletFontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          ),
          TextFormField(
            controller: _localizacaoController,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
                tabletFontSize: 13,
              ),
            ),
            decoration: InputDecoration(
              labelText: 'Localizao Fsica',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 12,
                  mobileFontSize: 11,
                  tabletFontSize: 11,
                ),
              ),
              prefixIcon: Icon(
                Icons.location_on_rounded,
                size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                vertical: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              isDense: true,
            ),
          ),
          SizedBox(
            height: AppSizes.paddingSm.get(isMobile, isTablet),
          ),
          TextFormField(
            controller: _observacoesController,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
                tabletFontSize: 13,
              ),
            ),
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Observaes',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 12,
                  mobileFontSize: 11,
                  tabletFontSize: 11,
                ),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  bottom: AppSizes.paddingMd.get(isMobile, isTablet),
                ),
                child: Icon(
                  Icons.note_rounded,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                vertical: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              isDense: true,
            ),
          ),
          SizedBox(
            height: AppSizes.paddingSm.get(isMobile, isTablet),
          ),
          DropdownButtonFormField<String>(
            initialValue: _status,
            isExpanded: true,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
                tabletFontSize: 13,
              ),
              color: ThemeColors.of(context).textPrimary,
            ),
            decoration: InputDecoration(
              labelText: 'Status',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 12,
                  mobileFontSize: 11,
                  tabletFontSize: 11,
                ),
              ),
              prefixIcon: Icon(
                _status == 'Ativo'
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                color: _status == 'Ativo'
                    ? ThemeColors.of(context).greenMain
                    : ThemeColors.of(context).textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                vertical: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              isDense: true,
            ),
            items: ['Ativo', 'Inativo']
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 13,
                            mobileFontSize: 12,
                            tabletFontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _status = value!;
                _alteracoesFeitas = true;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final statusColor = _getStatusColor();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _testingSync ? null : _testarSincronizacao,
                icon: _testingSync
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ThemeColors.of(context).surface),
                        ),
                      )
                    : Icon(Icons.sync_rounded,
                        size: AppSizes.iconSmall.get(isMobile, isTablet)),
                label: Flexible(
                  child: Text(
                    _testingSync ? 'Testando...' : 'Testar Sync',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 12,
                        tabletFontSize: 13,
                      ),
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingSm.get(isMobile, isTablet),
                    horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
                  ),
                  backgroundColor: ThemeColors.of(context).blueMain,
                  foregroundColor: ThemeColors.of(context).surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        AppSizes.paddingBase.get(isMobile, isTablet)),
                  ),
                ),
              ),
            ),
            if (widget.tag.productId == null) ...[
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showProductSelectorModal(),
                  icon: Icon(Icons.link_rounded,
                      size: AppSizes.iconSmall.get(isMobile, isTablet)),
                  label: Flexible(
                    child: Text(
                      'Associar',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 12,
                          tabletFontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.paddingSm.get(isMobile, isTablet),
                      horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
                    ),
                    backgroundColor: ThemeColors.of(context).orangeMain,
                    foregroundColor: ThemeColors.of(context).surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppSizes.paddingBase.get(isMobile, isTablet)),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded,
                    size: AppSizes.iconSmall.get(isMobile, isTablet)),
                label: Text(
                  'Cancelar',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 12,
                      tabletFontSize: 13,
                    ),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingSm.get(isMobile, isTablet),
                  ),
                  side: BorderSide(color: ThemeColors.of(context).textSecondary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        AppSizes.paddingBase.get(isMobile, isTablet)),
                  ),
                ),
              ),
            ),
            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _salvarAlteracoes,
                icon: _isSaving
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ThemeColors.of(context).surface),
                        ),
                      )
                    : Icon(Icons.check_rounded,
                        size: AppSizes.iconSmall.get(isMobile, isTablet)),
                label: Flexible(
                  child: Text(
                    _isSaving ? 'Salvando...' : 'Salvar',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 12,
                        tabletFontSize: 13,
                      ),
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingSm.get(isMobile, isTablet),
                  ),
                  backgroundColor: statusColor,
                  foregroundColor: ThemeColors.of(context).surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        AppSizes.paddingBase.get(isMobile, isTablet)),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _excluirTag,
            icon: Icon(Icons.delete_rounded,
                size: AppSizes.iconSmall.get(isMobile, isTablet)),
            label: Text(
              'Excluir Tag',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 12,
                  tabletFontSize: 13,
                ),
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              foregroundColor: ThemeColors.of(context).error,
              side: BorderSide(color: ThemeColors.of(context).error),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _testarSincronizacao() async {
    setState(() => _testingSync = true);

    try {
      await ref.read(tagsRepositoryProvider).flashTag(widget.tag.macAddress);

      if (mounted) {
        setState(() => _testingSync = false);
        _showSyncSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _testingSync = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao testar sincronização: $e'),
            backgroundColor: ThemeColors.of(context).error,
          ),
        );
      }
    }
  }

  void _showSyncSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              AppSizes.paddingLg.get(isMobile, isTablet)),
        ),
        icon: Icon(
          Icons.check_circle_rounded,
          color: ThemeColors.of(context).greenMain,
          size: AppSizes.iconHeroSmAlt.get(isMobile, isTablet),
        ),
        title: Text(
          'Sincronização OK!',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 18,
              mobileFontSize: 16,
              tabletFontSize: 17,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tag respondendo normalmente',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
            ),
            SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
            Text(
              '? Conexo: OK\n? Bateria: ${widget.tag.batteryLevel}%\n? Display: OK',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 12,
                  mobileFontSize: 11,
                  tabletFontSize: 11,
                ),
                color: ThemeColors.of(context).greenMain,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).greenMain,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
            ),
            child: Text(
              'Fechar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra modal para selecionar produto e vincular  tag
  void _showProductSelectorModal() {
    final workContext = ref.read(workContextProvider);
    final storeId = workContext.context.currentStoreId ?? '';
    
    if (storeId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Selecione uma loja primeiro'),
          backgroundColor: ThemeColors.of(context).warning,
        ),
      );
      return;
    }
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeColors.of(context).transparent,
      builder: (context) => _ProductSelectorModal(
        tagMac: widget.tag.macAddress,
        storeId: storeId,
        onProductSelected: (product) async {
          Navigator.pop(context);
          await _bindTagToProduct(product);
        },
      ),
    );
  }

  Future<void> _bindTagToProduct(ProductModel product) async {
    setState(() => _isSaving = true);
    
    try {
      final success = await ref
          .read(tagsNotifierProvider.notifier)
          .bindTag(widget.tag.macAddress, product.id);
      
      if (!mounted) return;
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Tag vinculada!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Produto: ${product.nome}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: ThemeColors.of(context).success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Retorna para recarregar a tela com dados atualizados
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao vincular tag'),
            backgroundColor: ThemeColors.of(context).error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _desassociarProduto() async {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              AppSizes.paddingLg.get(isMobile, isTablet)),
        ),
        icon: Icon(
          Icons.link_off_rounded,
          color: ThemeColors.of(context).orangeMain,
          size: AppSizes.iconHeroSmAlt.get(isMobile, isTablet),
        ),
        title: Text(
          'Desassociar Produto',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 18,
              mobileFontSize: 16,
              tabletFontSize: 17,
            ),
          ),
        ),
        content: Text(
          'A tag ficar disponvel para ser associada a outro produto.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
              tabletFontSize: 13,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref
                    .read(tagsRepositoryProvider)
                    .unbindTag(widget.tag.macAddress);

                ref.invalidate(tagsNotifierProvider);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: ThemeColors.of(context).surface,
                            size: AppSizes.iconMediumSmall
                                .get(isMobile, isTablet),
                          ),
                          SizedBox(
                            width:
                                AppSizes.paddingBase.get(isMobile, isTablet),
                          ),
                          const Expanded(
                            child: Text('Produto desassociado'),
                          ),
                        ],
                      ),
                      backgroundColor: ThemeColors.of(context).orangeMain,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            AppSizes.paddingBase.get(isMobile, isTablet)),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao desassociar: $e'),
                      backgroundColor: ThemeColors.of(context).error,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).orangeMain,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
            ),
            child: Text(
              'Desassociar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _salvarAlteracoes() async {
    setState(() => _isSaving = true);

    try {
      final updateDto = UpdateTagDto(
        location: _localizacaoController.text.trim(),
        notes: _observacoesController.text.trim(),
        isActive: _status == 'Ativo',
      );

      await ref
          .read(tagsRepositoryProvider)
          .updateTag(widget.tag.id.toString(), updateDto);

      ref.invalidate(tagsNotifierProvider);

      if (mounted) {
        setState(() => _isSaving = false);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
                SizedBox(
                    width: AppSizes.paddingBase.get(isMobile, isTablet)),
                const Expanded(child: Text('Tag atualizada!')),
              ],
            ),
            backgroundColor: ThemeColors.of(context).greenMain,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: ThemeColors.of(context).error,
          ),
        );
      }
    }
  }

  Future<void> _excluirTag() async {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              AppSizes.paddingLg.get(isMobile, isTablet)),
        ),
        icon: Icon(
          Icons.warning_rounded,
          color: ThemeColors.of(context).error,
          size: AppSizes.iconHeroSmAlt.get(isMobile, isTablet),
        ),
        title: Text(
          'Confirmar Excluso',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 18,
              mobileFontSize: 16,
              tabletFontSize: 17,
            ),
          ),
        ),
        content: Text(
          'Deseja realmente excluir "${widget.tag.macAddress}"?\n\nEsta ao no pode ser desfeita.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
              tabletFontSize: 13,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref
                    .read(tagsRepositoryProvider)
                    .deleteTag(widget.tag.id.toString());

                ref.invalidate(tagsNotifierProvider);

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: ThemeColors.of(context).surface,
                            size: AppSizes.iconMediumSmall
                                .get(isMobile, isTablet),
                          ),
                          SizedBox(
                            width:
                                AppSizes.paddingBase.get(isMobile, isTablet),
                          ),
                          const Expanded(child: Text('Tag excluda')),
                        ],
                      ),
                      backgroundColor: ThemeColors.of(context).error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            AppSizes.paddingBase.get(isMobile, isTablet)),
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao excluir: $e'),
                      backgroundColor: ThemeColors.of(context).error,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
            ),
            child: Text(
              'Excluir',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Modal para seleo de produto para vinculao
/// Carrega produtos DA LOJA DO LOGIN usando endpoint especfico
class _ProductSelectorModal extends ConsumerStatefulWidget {
  final String tagMac;
  final String storeId;
  final Function(ProductModel) onProductSelected;

  const _ProductSelectorModal({
    required this.tagMac,
    required this.storeId,
    required this.onProductSelected,
  });

  @override
  ConsumerState<_ProductSelectorModal> createState() => _ProductSelectorModalState();
}

class _ProductSelectorModalState extends ConsumerState<_ProductSelectorModal> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Estado para carregamento de produtos da loja
  List<ProductModel> _storeProducts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStoreProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Carrega produtos da loja especfica usando GET /api/products/store/{storeId}
  Future<void> _loadStoreProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(produtoRepositoryProvider);
      final response = await repository.listarProdutosPorLoja(widget.storeId);

      if (!mounted) return;

      if (response.isSuccess && response.data != null) {
        setState(() {
          _storeProducts = response.data!.map((p) => ProductModel.fromProduto(p)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.errorMessage ?? 'Erro ao carregar produtos';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Erro ao carregar produtos: $e';
          _isLoading = false;
        });
      }
    }
  }

  /// Abre o scanner de cdigo de barras
  void _openBarcodeScanner() async {
    final barcode = await BarcodeScannerDialog.show(
      context,
      title: 'Escanear Cdigo de Barras',
      subtitle: 'Posicione o cdigo de barras do produto na rea',
    );
    
    if (barcode == null || barcode.isEmpty) return;
    if (!mounted) return;
    
    // Busca o produto pelo cdigo de barras na lista local
    ProductModel? foundProduct;
    for (final p in _storeProducts) {
      if (p.codigo == barcode) {
        foundProduct = p;
        break;
      }
    }

    if (foundProduct != null && foundProduct.id.isNotEmpty) {
      widget.onProductSelected(foundProduct);
    } else {
      // Produto no encontrado na loja
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Produto "$barcode" no encontrado nesta loja'),
              ),
            ],
          ),
          backgroundColor: ThemeColors.of(context).warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtra produtos sem tag vinculada
    final availableProducts = _storeProducts
        .where((p) => !p.hasTag && (p.tag == null || p.tag!.isEmpty))
        .where((p) => _searchQuery.isEmpty || 
            p.nome.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.codigo.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ThemeColors.of(context).grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header com boto de scanner
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).primaryOverlay10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.link_rounded,
                    color: ThemeColors.of(context).primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vincular a Produto',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Tag: ${widget.tagMac}',
                        style: TextStyle(
                          fontSize: 13,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Boto de Scanner de Cdigo de Barras
                Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).blueMain.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: _openBarcodeScanner,
                    icon: Icon(
                      Icons.qr_code_scanner_rounded,
                      color: ThemeColors.of(context).blueMain,
                    ),
                    tooltip: 'Escanear cdigo de barras',
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          
          // Indicador de loja
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).greenMain.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ThemeColors.of(context).greenMain.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.store_rounded, size: 16, color: ThemeColors.of(context).greenMain),
                  const SizedBox(width: 6),
                  Text(
                    'Produtos da sua loja',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.of(context).greenMain,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).greenMain.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${availableProducts.length} disponveis',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).greenMain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Search com boto de scanner inline
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Buscar produto por nome ou cdigo...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: ThemeColors.of(context).grey300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: ThemeColors.of(context).grey300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: ThemeColors.of(context).primary),
                      ),
                      filled: true,
                      fillColor: ThemeColors.of(context).grey50,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Boto de scanner alternativo
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ThemeColors.of(context).blueMain, ThemeColors.of(context).primary],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: _openBarcodeScanner,
                    icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                    tooltip: 'Escanear cdigo',
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Lista de produtos
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline_rounded, size: 64, color: ThemeColors.of(context).error),
                            const SizedBox(height: 16),
                            Text(_error!, style: TextStyle(color: ThemeColors.of(context).error)),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _loadStoreProducts,
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      )
                    : availableProducts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64,
                                  color: ThemeColors.of(context).grey400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'Nenhum produto encontrado'
                                      : 'Nenhum produto disponvel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: ThemeColors.of(context).textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'Tente outro termo ou escaneie o cdigo'
                                      : 'Todos os produtos j possuem tags',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: ThemeColors.of(context).textSecondary,
                                  ),
                                ),
                                if (_searchQuery.isEmpty) ...[
                                  const SizedBox(height: 16),
                                  OutlinedButton.icon(
                                    onPressed: _openBarcodeScanner,
                                    icon: const Icon(Icons.qr_code_scanner_rounded),
                                    label: const Text('Escanear cdigo de barras'),
                                  ),
                                ],
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: availableProducts.length,
                            itemBuilder: (context, index) {
                              final product = availableProducts[index];
                              return _buildProductTile(product);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTile(ProductModel product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.of(context).grey200),
      ),
      child: ListTile(
        onTap: () => widget.onProductSelected(product),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppGradients.fromBaseColor(context, product.cor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            product.icone,
            color: ThemeColors.of(context).surface,
            size: 24,
          ),
        ),
        title: Text(
          product.nome,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.qr_code_rounded,
              size: 14,
              color: ThemeColors.of(context).textSecondary,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                product.codigo,
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeColors.of(context).textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: product.cor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                product.categoria,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: product.cor,
                ),
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).primaryOverlay10,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add_link_rounded,
            color: ThemeColors.of(context).primary,
            size: 20,
          ),
        ),
      ),
    );
  }
}









