import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/features/auth/presentation/providers/auth_provider.dart';
import 'package:tagbean/features/tags/presentation/providers/tags_provider.dart';
import 'package:tagbean/features/tags/data/models/tag_model.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

class EtiquetasMenuScreen extends ConsumerStatefulWidget {
  const EtiquetasMenuScreen({super.key});

  @override
  ConsumerState<EtiquetasMenuScreen> createState() => _EtiquetasMenuScreenState();
}

class _EtiquetasMenuScreenState extends ConsumerState<EtiquetasMenuScreen> 
    with TickerProviderStateMixin, ResponsiveCache {
  String _formatoSelecionado = 'csv';
  // NOTA: _isImporting removido (morto)
  File? _arquivoSelecionado;
  bool _sobrescreverExistentes = true;
  bool _validarAntes = true;
  bool _notificarConclusao = false;
  
  /// Obtm o storeId do usurio logado
  String get _storeId {
    final authState = ref.read(authProvider);
    return authState.user?.storeId ?? authState.user?.clientId ?? 'default';
  }

  @override
  Widget build(BuildContext context) {
    // Obtm estatsticas reais do backend
    final statsAsync = ref.watch(tagStatsProvider(_storeId));
    
    // Obtm histrico de importaes do backend
    final importHistoryAsync = ref.watch(tagImportHistoryProvider(_storeId));
    
    // Estatsticas (com fallback para 0)
    final stats = statsAsync.when(
      data: (data) => data,
      loading: () => null,
      error: (_, __) => null,
    );
    
    final totalTags = stats?.total ?? 0;
    final associadas = stats?.bound ?? 0;
    final disponiveis = stats?.available ?? 0;
    final offline = stats?.offline ?? 0;
    
    // Histrico de importaes
    final importHistory = importHistoryAsync.when(
      data: (data) => data,
      loading: () => <TagImportHistory>[],
      error: (_, __) => <TagImportHistory>[],
    );

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surfaceSecondary,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildModuleDescription(),
              SizedBox(
                height: AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              _buildFormatoCard(),
              SizedBox(
                height: AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              _buildUploadCard(),
              SizedBox(
                height: AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              _buildConfiguracoesCard(),
              SizedBox(
                height: AppSizes.paddingLgAlt.get(isMobile, isTablet),
              ),
              Text(
                'Importaes Recentes',
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
              SizedBox(
                height: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              // Histrico de importaes do backend
              if (importHistory.isEmpty)
                Padding(
                  padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.history_rounded,
                          size: 48,
                          color: ThemeColors.of(context).textSecondaryOverlay50,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Nenhuma importao realizada',
                          style: TextStyle(
                            color: ThemeColors.of(context).textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: importHistory.length,
                  itemBuilder: (context, index) {
                    final item = importHistory[index];
                    return RepaintBoundary(
                      child: _buildHistoricoItemFromModel(item, index),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: _arquivoSelecionado != null
          ? FloatingActionButton.extended(
              onPressed: _iniciarImportacao,
              backgroundColor: ThemeColors.of(context).blueCyan,
              icon: Icon(
                Icons.upload_rounded,
                size: AppSizes.iconMediumAlt2.get(isMobile, isTablet),
              ),
              label: Text(
                'Importar Agora',
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
            )
          : null,
    );
  }

  Widget _buildHeader() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Obtm estatsticas reais do backend via provider
    final statsAsync = ref.watch(tagStatsProvider(_storeId));
    final stats = statsAsync.valueOrNull;
    
    // Dados reais do provider (com fallback para 0)
    final totalTags = stats?.total ?? 0;
    final associadas = stats?.bound ?? 0;
    final disponiveis = stats?.available ?? 0;
    final offline = stats?.offline ?? 0;

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
              Icons.label_rounded,
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
                  'Etiquetas',
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
                  'Gesto de catlogo e precificao',
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
          // Stats ficam ocultos em mobile para evitar overflow
          if (!isMobile) ...[
            _buildCompactStat('$totalTags', Icons.label_rounded),
            SizedBox(
              width: AppSizes.paddingSmAlt.get(isMobile, isTablet),
            ),
            _buildCompactStat('$associadas', Icons.link_rounded),
            SizedBox(
              width: AppSizes.paddingSmAlt.get(isMobile, isTablet),
            ),
            _buildCompactStat('$offline', Icons.label_off_rounded),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactStat(String value, IconData icon) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
        vertical: AppSizes.paddingXs.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surfaceOverlay20,
        borderRadius: BorderRadius.circular(
          isMobile ? 8 : 10,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: ThemeColors.of(context).surface,
            size: AppSizes.iconSmall.get(isMobile, isTablet),
          ),
          SizedBox(
            width: AppSizes.paddingXsAlt5.get(isMobile, isTablet),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 15,
                mobileFontSize: 13,
                tabletFontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).surface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleDescription() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).warningPastel,
        borderRadius: BorderRadius.circular(
          AppSizes.paddingLg.get(isMobile, isTablet),
        ),
        border: Border.all(color: ThemeColors.of(context).warningLight),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_rounded,
            color: ThemeColors.of(context).warningDark,
            size: AppSizes.iconMedium.get(isMobile, isTablet),
          ),
          SizedBox(
            width: AppSizes.paddingBase.get(isMobile, isTablet),
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
                    color: ThemeColors.of(context).warningDark,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(
                  height: AppSizes.extraSmallPadding.get(isMobile, isTablet),
                ),
                Text(
                  'Crie, personalize e imprima etiquetas eletrnicas com layouts customizados, formatos variados e importao em lote.',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
                    ),
                    color: ThemeColors.of(context).warningDark,
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

  Widget _buildFormatoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingLgAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).primaryPastel,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.description_rounded,
                  color: ThemeColors.of(context).blueCyan,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Formato do Arquivo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 17,
                      mobileFontSize: 16,
                      tabletFontSize: 16,
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _buildFormatoOption(
                  'csv',
                  'CSV',
                  Icons.description,
                  '1.248 KB',
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildFormatoOption(
                  'xlsx',
                  'Excel',
                  Icons.table_chart,
                  '856 KB',
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildFormatoOption(
                  'json',
                  'JSON',
                  Icons.code,
                  '2.1 MB',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormatoOption(
    String value,
    String label,
    IconData icon,
    String size,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isSelected = _formatoSelecionado == value;

    return InkWell(
      onTap: () => setState(() => _formatoSelecionado = value),
      borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? AppGradients.primaryHeader(context)
              : null,
          color: isSelected ?  null : ThemeColors.of(context).grey100,
          border: Border.all(
            color: isSelected ? ThemeColors.of(context).blueCyan : ThemeColors.of(context).borderLight,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ThemeColors.of(context).blueCyanLight,
                    blurRadius: isMobile ? 10 : 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
              size: AppSizes.iconExtraLarge.get(isMobile, isTablet),
            ),
            SizedBox(
              height: AppSizes.paddingSmAlt.get(isMobile, isTablet),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
              ),
            ),
            SizedBox(
              height: AppSizes.paddingXxs.get(isMobile, isTablet),
            ),
            Text(
              size,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 10,
                  mobileFontSize: 9,
                  tabletFontSize: 9,
                ),
              overflow: TextOverflow.ellipsis,
                color: isSelected
                    ? ThemeColors.of(context).surfaceOverlay80
                    : ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingSmAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: AppGradients.syncBlue(context),
        borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).infoLight,
            blurRadius: isMobile ? 10 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay15,
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
              border: Border.all(
                color: ThemeColors.of(context).surfaceOverlay30,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  _arquivoSelecionado != null
                      ? Icons.check_circle_rounded
                      : Icons.cloud_upload_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconExtraLargeAlt.get(isMobile, isTablet),
                ),
                SizedBox(
                  height: AppSizes.paddingXs.get(isMobile, isTablet),
                ),
                Text(
                  _arquivoSelecionado != null
                      ? 'Arquivo Pronto para Importar!'
                      : 'Arraste e Solte o Arquivo Aqui',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                      tabletFontSize: 12,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: AppSizes.paddingXxs.get(isMobile, isTablet),
                ),
                Text(
                  _arquivoSelecionado != null
                      ? 'tags_lote_novo.csv ? 1.248 KB'
                      : 'ou clique no boto abaixo para selecionar',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10,
                      tabletFontSize: 10,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).surfaceOverlay90,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_arquivoSelecionado != null) ...[
                  SizedBox(
                    height: AppSizes.paddingXs.get(isMobile, isTablet),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                      vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).surfaceOverlay20,
                      borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.insert_drive_file_rounded,
                          color: ThemeColors.of(context).surface,
                          size: ResponsiveHelper.getResponsiveIconSize(
                            context,
                            mobile: 14,
                            tablet: 15,
                            desktop: 15,
                          ),
                        ),
                        SizedBox(
                          width: AppSizes.paddingXsAlt5.get(isMobile, isTablet),
                        ),
                        Text(
                          '156 registros detectados',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 10,
                              mobileFontSize: 9,
                              tabletFontSize: 9,
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
              ],
            ),
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_arquivoSelecionado != null) ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() => _arquivoSelecionado = null);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.of(context).surfaceOverlay20,
                      foregroundColor: ThemeColors.of(context).surface,
                      padding: EdgeInsets.symmetric(
                        vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
                      ),
                    ),
                    icon: Icon(
                      Icons.close_rounded,
                      size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                    ),
                    label: Text(
                      'Remover',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 13,
                          tabletFontSize: 13,
                        ),
                      overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
              ],
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _selecionarArquivo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.of(context).surface,
                    foregroundColor: ThemeColors.of(context).blueCyan,
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(
                    _arquivoSelecionado != null
                        ? Icons.swap_horiz_rounded
                        : Icons.folder_open_rounded,
                    size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                  ),
                  label: Text(
                    _arquivoSelecionado != null
                        ? 'Trocar Arquivo'
                        : 'Selecionar Arquivo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 15,
                        mobileFontSize: 14,
                        tabletFontSize: 14,
                      ),
                    overflow: TextOverflow.ellipsis,
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

  Widget _buildConfiguracoesCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingLgAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).primaryPastel,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.settings_suggest_rounded,
                  color: ThemeColors.of(context).primaryDark,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Configuraes de Importao',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 17,
                      mobileFontSize: 16,
                      tabletFontSize: 16,
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
          _buildSwitchOption(
            'Sobrescrever Tags Existentes',
            'Substituir dados se ID j existir',
            Icons.sync_rounded,
            _sobrescreverExistentes,
            (value) => setState(() => _sobrescreverExistentes = value),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildSwitchOption(
            'Validar Dados Antes',
            'Verificar integridade antes de importar',
            Icons.verified_rounded,
            _validarAntes,
            (value) => setState(() => _validarAntes = value),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildSwitchOption(
            'Notificar ao Concluir',
            'Enviar alerta quando processo terminar',
            Icons.notifications_active_rounded,
            _notificarConclusao,
            (value) => setState(() => _notificarConclusao = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchOption(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingSm.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: value ? ThemeColors.of(context).infoPastel : ThemeColors.of(context).grey100,
        borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        border: Border.all(
          color: value ? ThemeColors.of(context).infoLight : ThemeColors.of(context).borderLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: value ?  ThemeColors.of(context).infoDark : ThemeColors.of(context).textSecondary,
            size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
          ),
          SizedBox(
            width: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 13,
                      tabletFontSize: 13,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(
                  height: AppSizes.paddingMicro.get(isMobile, isTablet),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: ThemeColors.of(context).infoDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricoItem(Map<String, dynamic> item, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final taxaSucesso = (item['sucesso'] / item['quantidade'] * 100).round();

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
        margin: EdgeInsets.only(
          bottom: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        padding: EdgeInsets.all(
          AppSizes.paddingLgAlt3.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.04),
              blurRadius: isMobile ? 12 : 15,
              offset: const Offset(0, 2),
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
                    gradient: AppGradients.syncBlue(context),
                    borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                  ),
                  child: Icon(
                    Icons.insert_drive_file_rounded,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                  ),
                ),
                SizedBox(
                  width: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['nome'],
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 15,
                            mobileFontSize: 14,
                            tabletFontSize: 14,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.paddingMicro.get(isMobile, isTablet),
                      ),
                      Text(
                        item['data'],
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
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                    vertical: AppSizes.paddingXsAlt5.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    color: taxaSucesso >= 95
                        ? ThemeColors.of(context).successPastel
                        : ThemeColors.of(context).warningPastel,
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  ),
                  child: Text(
                    '$taxaSucesso%',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 13,
                        mobileFontSize: 12,
                        tabletFontSize: 12,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: taxaSucesso >= 95
                          ? ThemeColors.of(context).successIcon
                          : ThemeColors.of(context).warningDark,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppSizes.paddingSm.get(isMobile, isTablet),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBadge('${item['quantidade']} total', ThemeColors.of(context).info),
                SizedBox(
                  width: AppSizes.paddingXs.get(isMobile, isTablet),
                ),
                _buildBadge('${item['sucesso']} OK', ThemeColors.of(context).successIcon),
                if (item['falha'] > 0) ...[
                  SizedBox(
                    width: AppSizes.paddingXs.get(isMobile, isTablet),
                  ),
                  _buildBadge('${item['falha']} erros', ThemeColors.of(context).error),
                ],
                const Spacer(),
                Icon(
                  Icons.access_time_rounded,
                  size: AppSizes.iconExtraSmallAlt3.get(isMobile, isTablet),
                  color: ThemeColors.of(context).textSecondary,
                ),
                SizedBox(
                  width: AppSizes.paddingXxs.get(isMobile, isTablet),
                ),
                Text(
                  item['duracao'],
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondaryOverlay70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Constri item do histrico a partir do modelo TagImportHistory
  Widget _buildHistoricoItemFromModel(TagImportHistory item, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final taxaSucesso = item.totalCount > 0 
        ? (item.successCount / item.totalCount * 100).round() 
        : 0;

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
        margin: EdgeInsets.only(
          bottom: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        padding: EdgeInsets.all(
          AppSizes.paddingLgAlt3.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.04),
              blurRadius: isMobile ? 12 : 15,
              offset: const Offset(0, 2),
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
                    gradient: AppGradients.syncBlue(context),
                    borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                  ),
                  child: Icon(
                    Icons.insert_drive_file_rounded,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                  ),
                ),
                SizedBox(
                  width: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.fileName,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 15,
                            mobileFontSize: 14,
                            tabletFontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.paddingMicro.get(isMobile, isTablet),
                      ),
                      Text(
                        _formatDateTime(item.importedAt),
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
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                    vertical: AppSizes.paddingXsAlt5.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    color: taxaSucesso >= 95
                        ? ThemeColors.of(context).successPastel
                        : ThemeColors.of(context).warningPastel,
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  ),
                  child: Text(
                    '$taxaSucesso%',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 13,
                        mobileFontSize: 12,
                        tabletFontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: taxaSucesso >= 95
                          ? ThemeColors.of(context).successIcon
                          : ThemeColors.of(context).warningDark,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppSizes.paddingSm.get(isMobile, isTablet),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBadge('${item.totalCount} total', ThemeColors.of(context).info),
                SizedBox(
                  width: AppSizes.paddingXs.get(isMobile, isTablet),
                ),
                _buildBadge('${item.successCount} OK', ThemeColors.of(context).successIcon),
                if (item.failedCount > 0) ...[
                  SizedBox(
                    width: AppSizes.paddingXs.get(isMobile, isTablet),
                  ),
                  _buildBadge('${item.failedCount} erros', ThemeColors.of(context).error),
                ],
                const Spacer(),
                Icon(
                  Icons.access_time_rounded,
                  size: AppSizes.iconExtraSmallAlt3.get(isMobile, isTablet),
                  color: ThemeColors.of(context).textSecondary,
                ),
                SizedBox(
                  width: AppSizes.paddingXxs.get(isMobile, isTablet),
                ),
                Text(
                  item.duration,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondaryOverlay70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Formata DateTime para string legvel
  String _formatDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildBadge(String label, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
        vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: colorLight,
        borderRadius: BorderRadius.circular(isMobile ? 5 : 6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            baseFontSize: 11,
            mobileFontSize: 10,
            tabletFontSize: 10,
          ),
        overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  void _selecionarArquivo() {
    final isMobile = ResponsiveHelper.isMobile(context);

    setState(() {
      _arquivoSelecionado = File('tags_lote_novo.csv');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            Text(
              'Arquivo selecionado com sucesso!',
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
          ],
        ),
        backgroundColor: ThemeColors.of(context).successIcon,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        ),
      ),
    );
  }

  void _iniciarImportacao() {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.upload_rounded,
              color: ThemeColors.of(context).blueCyan,
              size: AppSizes.iconMediumLargeAlt.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            Text(
              'Confirmar Importao',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 18,
                  mobileFontSize: 16,
                  tabletFontSize: 17,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voc est prestes a importar:',
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
            SizedBox(
              height: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            Container(
              padding: EdgeInsets.all(
                AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).infoPastel,
                borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '? 156 registros detectados',
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
                  SizedBox(
                    height: AppSizes.paddingXxs.get(isMobile, isTablet),
                  ),
                  Text(
                    '? Formato: CSV',
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
                  SizedBox(
                    height: AppSizes.paddingXxs.get(isMobile, isTablet),
                  ),
                  Text(
                    '? Tempo estimado: 2 minutos',
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
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
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
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: ResponsiveHelper.getResponsiveWidth(
                          context,
                          mobile: 18,
                          tablet: 19,
                          desktop: 20,
                        ),
                        height: ResponsiveHelper.getResponsiveHeight(
                          context,
                          mobile: 18,
                          tablet: 19,
                          desktop: 20,
                        ),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
                        ),
                      ),
                      SizedBox(
                        width: AppSizes.paddingBase.get(isMobile, isTablet),
                      ),
                      Text(
                        'Importando tags...',
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
                    ],
                  ),
                  backgroundColor: ThemeColors.of(context).blueCyan,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).blueCyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
            ),
            child: Text(
              'Confirmar',
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
          ),
        ],
      ),
    );
  }

  void _mostrarAjuda() {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.help_outline_rounded,
              color: ThemeColors.of(context).blueCyan,
              size: AppSizes.iconMediumLargeAlt.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            Text(
              'Como Importar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 18,
                  mobileFontSize: 16,
                  tabletFontSize: 17,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Formatos Suportados:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                    tabletFontSize: 13,
                  ),
                overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingXs.get(isMobile, isTablet),
              ),
              Text(
                '? CSV - Valores separados por vrgula',
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
              Text(
                '? Excel - Planilhas .xlsx',
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
              Text(
                '? JSON - Estrutura de dados',
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
              SizedBox(
                height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
              ),
              Text(
                'Estrutura Necessria:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                    tabletFontSize: 13,
                  ),
                overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingXs.get(isMobile, isTablet),
              ),
              Text(
                '? ID da Tag (obrigatrio)',
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
              Text(
                '? Cdigo do Produto',
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
              Text(
                '? Nome do Produto',
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
              Text(
                '? Preo',
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
              Text(
                '? Localizao na loja',
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Entendi',
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
          ),
        ],
      ),
    );
  }
}









