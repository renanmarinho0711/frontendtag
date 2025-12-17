import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/tags/presentation/providers/tags_provider.dart';
import 'package:tagbean/features/tags/data/models/tag_model.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';

class TagsImportarScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  
  const TagsImportarScreen({super.key, this.onBack});

  @override
  ConsumerState<TagsImportarScreen> createState() => _TagsImportarScreenState();
}

class _TagsImportarScreenState extends ConsumerState<TagsImportarScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  String _formatoSelecionado = 'csv';
  bool _isImporting = false;
  PlatformFile? _arquivoSelecionado;
  List<TagImportItem> _parsedItems = [];
  bool _sobrescreverExistentes = true;
  bool _validarAntes = true;
  bool _notificarConclusao = false;
  double _progressoImportacao = 0.0;
  late AnimationController _uploadAnimationController;
  
  // Histórico de importações vem do backend via provider
  List<Map<String, dynamic>> get _importacoesRecentes {
    final workContext = ref.read(workContextProvider);
    final storeId = workContext.context.currentStoreId ?? '';
    if (storeId.isEmpty) return [];
    
    final importHistory = ref.read(tagImportHistoryProvider(storeId));
    return importHistory.when(
      data: (imports) => imports.map((imp) => {
        'nome': imp.fileName,
        'data': _formatDateTime(imp.importedAt),
        'quantidade': imp.totalCount,
        'sucesso': imp.successCount,
        'falha': imp.failedCount,
        'duracao': imp.duration,
        'usuario': imp.importedBy,
        'tamanho': '${(imp.totalCount * 0.1).toStringAsFixed(1)} KB',
      }).toList(),
      loading: () => [],
      error: (_, __) => [],
    );
  }
  
  String _formatDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _uploadAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _uploadAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                Padding(
                  padding: EdgeInsets.all(
                    AppSizes.paddingMdAlt.get(isMobile, isTablet),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormatoCard(),
                      SizedBox(
                        height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                      ),
                      _buildUploadCard(),
                      SizedBox(
                        height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                      ),
                      _buildConfiguracoesCard(),
                      SizedBox(
                        height: AppSizes.paddingXl.get(isMobile, isTablet),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Histórico de Importações',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 18,
                                mobileFontSize: 16,
                                tabletFontSize: 17,
                              ),
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _limparHistorico,
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              size: AppSizes.iconTiny.get(isMobile, isTablet),
                            ),
                            label: Text(
                              'Limpar',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 12,
                                  mobileFontSize: 11,
                                  tabletFontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppSizes.paddingBase.get(isMobile, isTablet),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _importacoesRecentes.length,
                        itemBuilder: (context, index) => _buildHistoricoItem(_importacoesRecentes[index], index),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsivePadding(
                          context,
                          mobile: 70,
                          tablet: 75,
                          desktop: 80,
                        ),
                      ),
                    ],
                  ),
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
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              label: Text(
                'Importar Agora',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                    tabletFontSize: 13,
                  ),
                ),
              ),
            )
          : null,
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
        vertical: AppSizes.paddingMdLg.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 20 : (isTablet ? 22 : 24),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.08),
            blurRadius: isMobile ? 20 : 25,
            offset: Offset(0, isMobile ? 5 : 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Boto de voltar
          if (widget.onBack != null) ...[            Container(
              decoration: BoxDecoration(
                color: ThemeColors.of(context).orangeMaterial,
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
                onPressed: widget.onBack,
              ),
            ),
            SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          ],
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              gradient: AppGradients.syncBlue(context),
              borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.3),
                  blurRadius: isMobile ? 10 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.upload_file_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconLarge.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Importar Tags',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 20,
                      mobileFontSize: 18,
                      tabletFontSize: 19,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(
                  height: AppSizes.paddingXxs.get(isMobile, isTablet),
                ),
                Text(
                  'Upload em Lote de Etiquetas',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                      tabletFontSize: 12,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondaryOverlay70,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
            child: IconButton(
              icon: Icon(
                Icons.help_outline_rounded,
                color: ThemeColors.of(context).textSecondary,
                size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
              ),
              onPressed: _mostrarAjuda,
              padding: EdgeInsets.all(
                AppSizes.paddingSmAlt.get(isMobile, isTablet),
              ),
              constraints: const BoxConstraints(),
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
                  Icons.description_rounded,
                  'Excel, Google Sheets',
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildFormatoOption(
                  'xlsx',
                  'Excel',
                  Icons.table_chart_rounded,
                  'Microsoft Office',
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildFormatoOption(
                  'json',
                  'JSON',
                  Icons.code_rounded,
                  'API, Sistemas',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormatoOption(String value, String label, IconData icon, String description) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isSelected = _formatoSelecionado == value;
    
    return InkWell(
      onTap: () => setState(() => _formatoSelecionado = value),
      borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingBase.get(isMobile, isTablet),
          horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
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
                    color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.3),
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
              size: AppSizes.iconMediumLargeFloat.get(isMobile, isTablet),
            ),
            SizedBox(
              height: AppSizes.paddingSmAlt.get(isMobile, isTablet),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
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
              description,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 10,
                  mobileFontSize: 9,
                  tabletFontSize: 9,
                ),
                color: isSelected ? ThemeColors.of(context).surfaceOverlay80 : ThemeColors.of(context).textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: EdgeInsets.all(
          AppSizes.paddingXl.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ThemeColors.of(context).info, ThemeColors.of(context).cyanMain.withValues(alpha: 0.4)],
          ),
          borderRadius: BorderRadius.circular(
            isMobile ? 20 : (isTablet ? 22 : 24),
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.of(context).blueMain.withValues(alpha: 0.4),
              blurRadius: isMobile ? 20 : 25,
              offset: Offset(0, isMobile ? 8 : 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(
                AppSizes.paddingXxl.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).surfaceOverlay15,
                borderRadius: BorderRadius.circular(isMobile ? 16 : (isTablet ? 18 : 20)),
                border: Border.all(color: ThemeColors.of(context).surfaceOverlay30, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _uploadAnimationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          _isImporting ? -5 + (10 * _uploadAnimationController.value) : 0,
                        ),
                        child: Icon(
                          _arquivoSelecionado != null
                              ? Icons.check_circle_rounded
                              : Icons.cloud_upload_rounded,
                          color: ThemeColors.of(context).surface,
                          size: ResponsiveHelper.getResponsiveIconSize(
                            context,
                            mobile: 60,
                            tablet: 66,
                            desktop: 72,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                  ),
                  Text(
                    _arquivoSelecionado != null
                        ? 'Arquivo Pronto para Importar!'
                        : 'Arraste e Solte o Arquivo Aqui',
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
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: AppSizes.paddingXs.get(isMobile, isTablet),
                  ),
                  Text(
                    _arquivoSelecionado != null
                        ? 'tags_lote_novo.$_formatoSelecionado  156 registros'
                        : 'ou clique no boto abaixo para selecionar',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                        tabletFontSize: 13,
                      ),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).surfaceOverlay90,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_arquivoSelecionado != null) ...[
                    SizedBox(
                      height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingSm.get(isMobile, isTablet),
                            vertical: AppSizes.paddingXs.get(isMobile, isTablet),
                          ),
                          decoration: BoxDecoration(
                            color: ThemeColors.of(context).surfaceOverlay20,
                            borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.insert_drive_file_rounded,
                                color: ThemeColors.of(context).surface,
                                size: AppSizes.iconSmall.get(isMobile, isTablet),
                              ),
                              SizedBox(
                                width: AppSizes.paddingXs.get(isMobile, isTablet),
                              ),
                              Text(
                                _arquivoSelecionado != null && _arquivoSelecionado!.size > 0
                                    ? '${(_arquivoSelecionado!.size / 1024).toStringAsFixed(1)} KB'
                                    : '0 KB',
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
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingSm.get(isMobile, isTablet),
                            vertical: AppSizes.paddingXs.get(isMobile, isTablet),
                          ),
                          decoration: BoxDecoration(
                            color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.tag_rounded,
                                color: ThemeColors.of(context).surface,
                                size: AppSizes.iconSmall.get(isMobile, isTablet),
                              ),
                              SizedBox(
                                width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                              ),
                              Text(
                                '${_parsedItems.length} tags',
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
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingSm.get(isMobile, isTablet),
                            vertical: AppSizes.paddingXs.get(isMobile, isTablet),
                          ),
                          decoration: BoxDecoration(
                            color: ThemeColors.of(context).successIcon.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                color: ThemeColors.of(context).surface,
                                size: AppSizes.iconSmall.get(isMobile, isTablet),
                              ),
                              SizedBox(
                                width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                              ),
                              Text(
                                'Validado',
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                        setState(() {
                          _arquivoSelecionado = null;
                          _parsedItems = [];
                        });
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
                        elevation: 0,
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
                      foregroundColor: ThemeColors.of(context).infoDark,
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
                      _arquivoSelecionado != null ?  'Trocar Arquivo' : 'Selecionar Arquivo',
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
            if (_isImporting) ...[
              SizedBox(
                height: AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingMdAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Importando...',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 14,
                              mobileFontSize: 13,
                              tabletFontSize: 13,
                            ),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).surface,
                          ),
                        ),
                        Text(
                          '${(_progressoImportacao * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 14,
                              mobileFontSize: 13,
                              tabletFontSize: 13,
                            ),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).surface,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                      child: LinearProgressIndicator(
                        value: _progressoImportacao,
                        minHeight: ResponsiveHelper.getResponsiveHeight(
                          context,
                          mobile: 7,
                          tablet: 7,
                          desktop: 8,
                        ),
                        backgroundColor: ThemeColors.of(context).surfaceOverlay30,
                        valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
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
                  'Configurações de Importação',
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
            'Substituir dados se ID j existir no sistema',
            Icons.sync_rounded,
            _sobrescreverExistentes,
            (value) => setState(() => _sobrescreverExistentes = value),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildSwitchOption(
            'Validar Dados Antes',
            'Verificar integridade antes de processar',
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
              activeThumbColor: ThemeColors.of(context).infoDark,
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
      duration: Duration(milliseconds: 400 + (index * 60)),
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
                    gradient: LinearGradient(
                      colors: [ThemeColors.of(context).info, ThemeColors.of(context).cyanMain],
                    ),
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_rounded,
                            size: AppSizes.iconExtraSmallAlt2.get(isMobile, isTablet),
                            color: ThemeColors.of(context).textSecondary,
                          ),
                          SizedBox(
                            width: AppSizes.paddingXxs.get(isMobile, isTablet),
                          ),
                          Text(
                            item['usuario'],
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 11,
                                mobileFontSize: 10,
                                tabletFontSize: 10,
                              ),
                            overflow: TextOverflow.ellipsis,
                              color: ThemeColors.of(context).textSecondary,
                            ),
                          ),
                          SizedBox(
                            width: AppSizes.paddingXs.get(isMobile, isTablet),
                          ),
                          Icon(
                            Icons.access_time_rounded,
                            size: AppSizes.iconExtraSmallAlt2.get(isMobile, isTablet),
                            color: ThemeColors.of(context).textSecondaryOverlay70,
                          ),
                          SizedBox(
                            width: AppSizes.paddingXxs.get(isMobile, isTablet),
                          ),
                          Text(
                            item['data'],
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 11,
                                mobileFontSize: 10,
                                tabletFontSize: 10,
                              ),
                            overflow: TextOverflow.ellipsis,
                              color: ThemeColors.of(context).textSecondary,
                            ),
                          ),
                        ],
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
                    color: taxaSucesso >= 95 ? ThemeColors.of(context).greenMain.withValues(alpha: 0.1) : ThemeColors.of(context).warningPastel,
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
                      color: taxaSucesso >= 95 ? ThemeColors.of(context).greenMain.withValues(alpha: 0.8) : ThemeColors.of(context).warningDark,
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
                _buildBadge('${item['quantidade']} total', ThemeColors.of(context).blueMain),
                SizedBox(
                  width: AppSizes.paddingXs.get(isMobile, isTablet),
                ),
                _buildBadge('${item['sucesso']} OK', ThemeColors.of(context).greenMain),
                if (item['falha'] > 0) ...[
                  SizedBox(
                    width: AppSizes.paddingXs.get(isMobile, isTablet),
                  ),
                  _buildBadge('${item['falha']} erros', ThemeColors.of(context).error),
                ],
                const Spacer(),
                Icon(
                  Icons.schedule_rounded,
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
                    color: ThemeColors.of(context).textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
        vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
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

  void _selecionarArquivo() async {
    final isMobile = ResponsiveHelper.isMobile(context);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _formatoSelecionado == 'csv' ? ['csv'] : ['json', 'xlsx'],
        withData: true, // Necessrio para web
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        if (file.bytes == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Erro ao ler arquivo'),
                backgroundColor: ThemeColors.of(context).errorIcon,
              ),
            );
          }
          return;
        }

        // Parse do arquivo CSV
        final content = utf8.decode(file.bytes!);
        final List<List<dynamic>> csvData = const CsvToListConverter().convert(content);
        
        if (csvData.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Arquivo vazio'),
                backgroundColor: ThemeColors.of(context).warningIcon,
              ),
            );
          }
          return;
        }

        // Primeira linha so headers
        final headers = csvData.first.map((e) => e.toString().toLowerCase()).toList();
        final macIndex = headers.indexWhere((h) => h.contains('mac') || h.contains('endereo') || h.contains('address'));
        final typeIndex = headers.indexWhere((h) => h.contains('type') || h.contains('tipo'));
        final productIndex = headers.indexWhere((h) => h.contains('product') || h.contains('produto') || h.contains('code') || h.contains('cdigo'));

        if (macIndex == -1) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Coluna MAC Address no encontrada'),
                backgroundColor: ThemeColors.of(context).errorIcon,
              ),
            );
          }
          return;
        }

        // Parse das linhas de dados (pular header)
        final items = <TagImportItem>[];
        for (int i = 1; i < csvData.length; i++) {
          final row = csvData[i];
          if (row.isEmpty || macIndex >= row.length) continue;
          
          final macAddress = row[macIndex].toString().trim();
          if (macAddress.isEmpty) continue;
          
          final type = typeIndex >= 0 && typeIndex < row.length 
              ? int.tryParse(row[typeIndex].toString()) ?? 0 
              : 0;
          final productCode = productIndex >= 0 && productIndex < row.length 
              ? row[productIndex].toString().trim() 
              : null;

          items.add(TagImportItem(
            macAddress: macAddress,
            type: type,
            productCode: productCode?.isEmpty == true ? null : productCode,
          ));
        }

        setState(() {
          _arquivoSelecionado = file;
          _parsedItems = items;
        });
        
        if (mounted) {
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
                  SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                  Flexible(
                    child: Text(
                      'Arquivo selecionado: ${items.length} tags encontradas',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 13,
                          tabletFontSize: 13,
                        ),
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
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao selecionar arquivo: $e'),
            backgroundColor: ThemeColors.of(context).errorIcon,
          ),
        );
      }
    }
  }

  void _iniciarImportacao() async {
    if (_parsedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Selecione um arquivo com tags vlidas primeiro'),
          backgroundColor: ThemeColors.of(context).warningIcon,
        ),
      );
      return;
    }

    final workContext = ref.read(workContextProvider);
    final storeId = workContext.context.currentStoreId;
    
    if (storeId == null || storeId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Selecione uma loja primeiro'),
          backgroundColor: ThemeColors.of(context).errorIcon,
        ),
      );
      return;
    }

    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet))),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.upload_rounded,
              color: ThemeColors.of(context).blueCyan,
              size: AppSizes.iconMediumLargeAlt.get(isMobile, isTablet),
            ),
            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
            Text('Confirmar Importação', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Voc est prestes a importar:', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
            SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
            Container(
              padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
              decoration: BoxDecoration(color: ThemeColors.of(context).infoPastel, borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(' ${_parsedItems.length} registros detectados', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12))),
                  SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                  Text(' Formato: ${_formatoSelecionado.toUpperCase()}', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12))),
                  SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                  Text(' Sobrescrever existentes: ${_sobrescreverExistentes ? "Sim" : "No"}', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13)))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isImporting = true);
              _uploadAnimationController.repeat();
              
              try {
                final notifier = ref.read(tagsImportNotifierProvider.notifier);
                final result = await notifier.importTags(
                  storeId: storeId,
                  items: _parsedItems,
                  format: _formatoSelecionado,
                  overwriteExisting: _sobrescreverExistentes,
                  validateBeforeImport: _validarAntes,
                );
                
                setState(() {
                  _isImporting = false;
                  _progressoImportacao = 1.0;
                });
                _uploadAnimationController.stop();
                _uploadAnimationController.reset();
                
                if (mounted) {
                  if (result != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMediumSmall.get(isMobile, isTablet)),
                            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                            Flexible(
                              child: Text(
                                'Importação concluda! ${result.successCount} de ${result.totalProcessed} tags importadas.',
                                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: ThemeColors.of(context).successIcon,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
                      ),
                    );
                    
                    // Limpar estado aps sucesso
                    setState(() {
                      _arquivoSelecionado = null;
                      _parsedItems = [];
                      _progressoImportacao = 0.0;
                    });
                    
                    // Atualizar lista de tags
                    ref.read(tagsNotifierProvider.notifier).refresh();
                    // Invalidar histórico para recarregar
                    ref.invalidate(tagImportHistoryProvider(storeId));
                  } else {
                    final error = ref.read(tagsImportNotifierProvider).error;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error ?? 'Erro ao importar tags'),
                        backgroundColor: ThemeColors.of(context).errorIcon,
                      ),
                    );
                  }
                }
              } catch (e) {
                setState(() => _isImporting = false);
                _uploadAnimationController.stop();
                _uploadAnimationController.reset();
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro: $e'),
                      backgroundColor: ThemeColors.of(context).errorIcon,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: ThemeColors.of(context).blueCyan, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)))),
            child: Text('Confirmar', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
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
                ' CSV - Valores separados por vrgula',
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
                ' Excel - Planilhas .xlsx',
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
                ' JSON - Estrutura de dados',
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
                ' ID da Tag (obrigatrio)',
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
                ' Cdigo do Produto',
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
                ' Nome do Produto',
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
                ' Preço',
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
                ' Localizao na loja',
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
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).blueCyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
            ),
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

  void _limparHistorico() {
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
              Icons.delete_outline_rounded,
              color: ThemeColors.of(context).error,
              size: AppSizes.iconMediumLargeAlt.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            Text(
              'Limpar Histórico',
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
        content: Text(
          'Deseja realmente limpar todo o histórico de importações?',
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
              setState(() => _importacoesRecentes.clear());
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
                        'Histórico limpo!',
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
                    borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).error,
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
}





