import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/import_export/presentation/providers/import_export_provider.dart';
import 'package:tagbean/features/import_export/data/models/import_export_models.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

class ExportacaoProdutosScreen extends ConsumerStatefulWidget {
  const ExportacaoProdutosScreen({super.key});

  @override
  ConsumerState<ExportacaoProdutosScreen> createState() => _ExportacaoProdutosScreenState();
}

class _ExportacaoProdutosScreenState extends ConsumerState<ExportacaoProdutosScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  // NOTA: _arquivoSelecionadoPath removido (morto)
  
  // Acesso ao provider
  ExportProductsState get _state => ref.watch(exportProductsProvider);
  ExportProductsNotifier get _notifier => ref.read(exportProductsProvider.notifier);
  
  // Getters para compatibilidade
  int get _currentStep => _state.currentStep;
  bool get _uploading => _state.isExporting;
  double get _uploadProgress => _state.exportProgress;
  String get _formatoSelecionado => _state.selectedFormat.id;
  
  // Getters para resultado de exporta??o
  int get _totalExportados => _state.result?.recordCount ?? _state.totalProducts;
  int get _sucessos => _state.result?.success == true ? (_state.result?.recordCount ?? 0) : 0;
  int get _erros => _state.result?.success == false ? 1 : 0;
  int get _ignorados => 0; // Exporta??o n?o tem ignorados
  
  final Map<String, Map<String, dynamic>> _formatos = {
    'excel': {
      'nome': 'Excel',
      'icone': Icons.table_chart_rounded,
      'cor': ThemeColors.of(context).greenDark,
      'extensao': '.xlsx',
    },
    'csv': {
      'nome': 'CSV',
      'icone': Icons.article_rounded,
      'cor': ThemeColors.of(context).primary,
      'extensao': '.csv',
    },
  };

  // Hist?rico de exporta??es via provider
  List<Map<String, dynamic>> get _historicoImportacoes {
    final history = _state.exportHistory;
    if (history.isEmpty) {
      return [];
    }
    return history.map((h) => {
      'nome': h.fileName,
      'data': h.formattedDate,
      'total': h.totalRecords,
      'sucesso': h.successCount,
      'erros': h.errorCount,
      'duracao': h.duration,
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
    
    // Carregar hist?rico
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifier.loadHistory();
    });
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
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                _buildProgressIndicator(),
                Padding(
                  padding: EdgeInsets.all(
                    AppSizes.paddingMd.get(isMobile, isTablet),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormatoSelector(),
                      SizedBox(
                        height: AppSizes.paddingMd.get(isMobile, isTablet),
                      ),
                      _buildStep1Card(),
                      SizedBox(
                        height: AppSizes.paddingMd.get(isMobile, isTablet),
                      ),
                      _buildStep2Card(),
                      SizedBox(
                        height: AppSizes.paddingMd.get(isMobile, isTablet),
                      ),
                      _buildInfoCard(),
                      SizedBox(
                        height: AppSizes.cardPadding.get(isMobile, isTablet),
                      ),
                      Text(
                        'Importa??es Recentes',
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _historicoImportacoes.length,
                        itemBuilder: (context, index) => _buildHistoricoItem(_historicoImportacoes[index], index),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
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
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(
                isMobile ? 8 : 10,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textSecondary,
                size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
              ),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.all(
                AppSizes.paddingXs.get(isMobile, isTablet),
              ),
              constraints: const BoxConstraints(),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 12 : 14,
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).primaryLight,
                  blurRadius: isMobile ? 10 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.upload_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconLarge.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Importar Produtos',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 20,
                      mobileFontSize: 16,
                      tabletFontSize: 18,
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
                  'Cadastro em Lote via Planilha',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 11,
                      tabletFontSize: 12,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
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
              color: ThemeColors.of(context).successPastel,
              borderRadius: BorderRadius.circular(
                isMobile ? 8 : 10,
              ),
              border: Border.all(color: ThemeColors.of(context).success),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: AppSizes.iconTiny.get(isMobile, isTablet),
                  color: ThemeColors.of(context).successIcon,
                ),
                SizedBox(
                  width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                Text(
                  'Guia',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10,
                      tabletFontSize: 10,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).successIcon,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingMdLg.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : (isTablet ? 14 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 12 : 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStepIndicator(0, 'Template', Icons.download_rounded, true),
          Expanded(
            child: Container(
              height: ResponsiveHelper.getResponsiveHeight(
                context,
                mobile: 2.5,
                tablet: 3,
                desktop: 3,
              ),
              decoration: BoxDecoration(
                gradient: _currentStep >= 1
                    ? LinearGradient(colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark])
                    : null,
                color: _currentStep >= 1 ? null : ThemeColors.of(context).textSecondary,
                borderRadius: AppRadius.xxxs,
              ),
            ),
          ),
          _buildStepIndicator(1, 'Upload', Icons.cloud_upload_rounded, _currentStep >= 1),
          Expanded(
            child: Container(
              height: ResponsiveHelper.getResponsiveHeight(
                context,
                mobile: 2.5,
                tablet: 3,
                desktop: 3,
              ),
              decoration: BoxDecoration(
                gradient: _currentStep >= 2
                    ? LinearGradient(colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark])
                    : null,
                color: _currentStep >= 2 ? null : ThemeColors.of(context).textSecondaryOverlay40,
                borderRadius: AppRadius.xxxs,
              ),
            ),
          ),
          _buildStepIndicator(2, 'Conclu?do', Icons.check_circle_rounded, _currentStep >= 2),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, IconData icon, bool isActive) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: ResponsiveHelper.getResponsiveWidth(
            context,
            mobile: 36,
            tablet: 39,
            desktop: 42,
          ),
          height: ResponsiveHelper.getResponsiveHeight(
            context,
            mobile: 36,
            tablet: 39,
            desktop: 42,
          ),
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
                    colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],
                  )
                : null,
            color: isActive ? null : ThemeColors.of(context).textSecondary,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: ThemeColors.of(context).primaryLight,
                      blurRadius: isMobile ? 8 : 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: ThemeColors.of(context).surface,
            size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
          ),
        ),
        SizedBox(
          height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 11,
              mobileFontSize: 9,
              tabletFontSize: 10,
            ),
          overflow: TextOverflow.ellipsis,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ?  ThemeColors.of(context).blueCyan : ThemeColors.of(context).textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFormatoSelector() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
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
                  color: ThemeColors.of(context).infoPastel,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.description_rounded,
                  color: ThemeColors.of(context).infoDark,
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
                      mobileFontSize: 15,
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
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: _formatos.entries.map((entry) {
              final formato = entry.value;
              final isSelected = _formatoSelecionado == entry.key;
              
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  child: InkWell(
                    onTap: () => _notifier.setFormat(entry.key == 'excel' ? ExportFormat.excel : ExportFormat.csv),
                    borderRadius: BorderRadius.circular(
                      isMobile ? 12 : 14,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(
                        AppSizes.paddingMd.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [formato['cor'], (formato['cor'] as Color).withValues(alpha: 0.7)],
                              )
                            : null,
                        color: isSelected ? null : ThemeColors.of(context).textSecondary,
                        border: Border.all(
                          color: isSelected ? ThemeColors.of(context).transparent : ThemeColors.of(context).textSecondary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(
                          isMobile ? 12 : 14,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: (formato['cor'] as Color)Light,
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
                            formato['icone'],
                            color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
                            size: AppSizes.iconExtraLargeAlt.get(isMobile, isTablet),
                          ),
                          SizedBox(
                            height: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                          ),
                          Text(
                            formato['nome'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 14,
                                mobileFontSize: 13,
                                tabletFontSize: 13,
                              ),
                              fontWeight: FontWeight.bold,
                              color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
                            ),
                          ),
                          SizedBox(
                            height: AppSizes.paddingXxs.get(isMobile, isTablet),
                          ),
                          Text(
                            formato['extensao'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 11,
                                mobileFontSize: 10,
                                tabletFontSize: 10,
                              ),
                              color: isSelected ? ThemeColors.of(context).surfaceOverlay80 : ThemeColors.of(context).textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1Card() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final formato = _formatos[_formatoSelecionado]!;
    
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
          children: [
            Container(
              padding: EdgeInsets.all(
                AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ThemeColors.of(context).successPastel, ThemeColors.of(context).materialTealLight],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.file_download_rounded,
                size: AppSizes.iconHeroMd.get(isMobile, isTablet),
                color: ThemeColors.of(context).successIcon,
              ),
            ),
            SizedBox(
              height: AppSizes.cardPadding.get(isMobile, isTablet),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).successPastel,
                borderRadius: BorderRadius.circular(
                  isMobile ? 6 : 8,
                ),
                border: Border.all(color: ThemeColors.of(context).successLight),
              ),
              child: Text(
                'ETAPA 1 - PREPARA??O',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 11,
                    mobileFontSize: 9,
                    tabletFontSize: 10,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).success,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            SizedBox(
              height: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            Text(
              'Baixe o Template',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 22,
                  mobileFontSize: 18,
                  tabletFontSize: 20,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.8,
              ),
            ),
            SizedBox(
              height: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            Text(
              'Template com as colunas necess?rias para importa??o',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 12,
                  tabletFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(
              height: AppSizes.cardPadding.get(isMobile, isTablet),
            ),
            Container(
              padding: EdgeInsets.all(
                AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).infoPastel,
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Colunas do Template:',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 13,
                        mobileFontSize: 11,
                        tabletFontSize: 12,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                  ),
                  _buildColumnItem('C?digo de Barras', 'obrigat?rio'),
                  _buildColumnItem('Nome do Produto', 'obrigat?rio'),
                  _buildColumnItem('Pre?o', 'obrigat?rio'),
                  _buildColumnItem('Categoria', 'opcional'),
                  _buildColumnItem('Estoque', 'opcional'),
                ],
              ),
            ),
            SizedBox(
              height: AppSizes.paddingXl.get(isMobile, isTablet),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _notifier.setStep(1);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            formato['icone'],
                            color: ThemeColors.of(context).surface,
                            size: AppSizes.iconMedium.get(isMobile, isTablet),
                          ),
                          SizedBox(
                            width: AppSizes.paddingBase.get(isMobile, isTablet),
                          ),
                          Text(
                            'Template ${formato['nome']} baixado!',
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
                        ],
                      ),
                      backgroundColor: formato['cor'],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          isMobile ? 10 : 12,
                        ),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.download_rounded,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
                label: Text(
                  'Baixar Template ${formato['nome']}',
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
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                  ),
                  backgroundColor: formato['cor'],
                  foregroundColor: ThemeColors.of(context).surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      isMobile ? 12 : 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnItem(String nome, String status) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isObrigatorio = status == 'obrigat?rio';
    
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSizes.paddingXs.get(isMobile, isTablet),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isObrigatorio ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: AppSizes.iconTiny.get(isMobile, isTablet),
            color: isObrigatorio ? ThemeColors.of(context).success : ThemeColors.of(context).textSecondary,
          ),
          SizedBox(
            width: AppSizes.paddingXs.get(isMobile, isTablet),
          ),
          Expanded(
            child: Text(
              nome,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 11,
                  tabletFontSize: 12,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
              vertical: AppSizes.paddingMicro.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: isObrigatorio ? ThemeColors.of(context).errorLight : ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(
                isMobile ? 5 : 6,
              ),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 10,
                  mobileFontSize: 8,
                  tabletFontSize: 9,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: isObrigatorio ? ThemeColors.of(context).errorDark : ThemeColors.of(context).textSecondaryOverlay70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Card() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXl.get(isMobile, isTablet),
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
        children: [
          Container(
            padding: EdgeInsets.all(
              AppSizes.cardPadding.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).cyanMainLight],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_upload_rounded,
              size: AppSizes.iconHeroMd.get(isMobile, isTablet),
              color: ThemeColors.of(context).infoDark,
            ),
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
              vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).infoPastel,
              borderRadius: BorderRadius.circular(
                isMobile ? 6 : 8,
              ),
              border: Border.all(color: ThemeColors.of(context).infoLight),
            ),
            child: Text(
              'ETAPA 2 - UPLOAD',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 11,
                  mobileFontSize: 9,
                  tabletFontSize: 10,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).primary,
                letterSpacing: 1.5,
              ),
            ),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Text(
            'Envie o Arquivo Preenchido',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 22,
                mobileFontSize: 18,
                tabletFontSize: 20,
              ),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.8,
            ),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Text(
            'Arquivo com os produtos cadastrados conforme template',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 12,
                tabletFontSize: 13,
              ),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(
            height: AppSizes.paddingXl.get(isMobile, isTablet),
          ),
          InkWell(
            onTap: _iniciarUpload,
            borderRadius: BorderRadius.circular(
              isMobile ? 12 : (isTablet ? 14 : 16),
            ),
            child: Container(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 32,
                  tablet: 36,
                  desktop: 40,
                ),
              ),
              decoration: BoxDecoration(
                gradient: _uploading
                    ? null
                    : LinearGradient(
                        colors: [
                          ThemeColors.of(context).blueCyanLight,
                          ThemeColors.of(context).primaryLight,
                        ],
                      ),
                border: Border.all(
                  color: ThemeColors.of(context).blueCyan,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(
                  isMobile ? 12 : (isTablet ? 14 : 16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_uploading) ...[
                    SizedBox(
                      width: ResponsiveHelper.getResponsiveWidth(
                        context,
                        mobile: 56,
                        tablet: 60,
                        desktop: 64,
                      ),
                      height: ResponsiveHelper.getResponsiveHeight(
                        context,
                        mobile: 56,
                        tablet: 60,
                        desktop: 64,
                      ),
                      child: CircularProgressIndicator(
                        strokeWidth: ResponsiveHelper.getResponsiveWidth(
                          context,
                          mobile: 3,
                          tablet: 4,
                          desktop: 4,
                        ),
                        valueColor: const AlwaysStoppedAnimation<Color>(ThemeColors.of(context).blueCyan),
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.cardPadding.get(isMobile, isTablet),
                    ),
                    Text(
                      'Importando...  ${(_uploadProgress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 16,
                          mobileFontSize: 14,
                          tabletFontSize: 15,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        isMobile ? 8 : 10,
                      ),
                      child: LinearProgressIndicator(
                        value: _uploadProgress,
                        minHeight: ResponsiveHelper.getResponsiveHeight(
                          context,
                          mobile: 7,
                          tablet: 8,
                          desktop: 8,
                        ),
                        backgroundColor: ThemeColors.of(context).textSecondary,
                        valueColor: const AlwaysStoppedAnimation<Color>(ThemeColors.of(context).blueCyan),
                      ),
                    ),
                  ] else ...[
                    Icon(
                      Icons.cloud_upload_rounded,
                      size: AppSizes.iconHeroXl.get(isMobile, isTablet),
                      color: ThemeColors.of(context).blueCyan,
                    ),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    Text(
                      'Arraste o arquivo aqui',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 18,
                          mobileFontSize: 15,
                          tabletFontSize: 16,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.paddingXs.get(isMobile, isTablet),
                    ),
                    Text(
                      'ou clique para selecionar',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 12,
                          tabletFontSize: 13,
                        ),
                      overflow: TextOverflow.ellipsis,
                        color: ThemeColors.of(context).textSecondary,
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                        vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).textSecondary,
                        borderRadius: BorderRadius.circular(
                          isMobile ?  6 : 8,
                        ),
                      ),
                      child: Text(
                        'M?ximo: 10 MB',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 11,
                            mobileFontSize: 9,
                            tabletFontSize: 10,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).orangeAmberLight, ThemeColors.of(context).orangeMaterialLight],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : (isTablet ? 14 : 16),
        ),
        border: Border.all(color: ThemeColors.of(context).orangeAmberLight),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lightbulb_rounded,
                size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                color: ThemeColors.of(context).orangeAmberDark,
              ),
              SizedBox(
                width: AppSizes.paddingSmAlt.get(isMobile, isTablet),
              ),
              Text(
                'Dicas Importantes',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 14,
                    tabletFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).orangeAmberDark,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingSm.get(isMobile, isTablet),
          ),
          _buildTipItem('C?digos de barras devem ser ?nicos'),
          _buildTipItem('Pre?os devem usar ponto como separador decimal'),
          _buildTipItem('Produtos duplicados ser?o ignorados'),
          _buildTipItem('M?ximo de 1.000 produtos por arquivo'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSizes.paddingXs.get(isMobile, isTablet),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: AppSizes.iconTiny.get(isMobile, isTablet),
            color: ThemeColors.of(context).orangeAmberDark,
          ),
          SizedBox(
            width: AppSizes.paddingSmAlt.get(isMobile, isTablet),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 11,
                  tabletFontSize: 12,
                ),
              overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricoItem(Map<String, dynamic> item, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final taxaSucesso = (item['sucesso'] / item['total'] * 100).round();
    
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
          AppSizes.paddingMdLg.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 12 : (isTablet ? 14 : 16),
          ),
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
                      colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],
                    ),
                    borderRadius: BorderRadius.circular(
                      isMobile ? 8 : 10,
                    ),
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
                            mobileFontSize: 13,
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
                            mobileFontSize: 10,
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
                    color: taxaSucesso >= 95 ? ThemeColors.of(context).successLight : ThemeColors.of(context).warningPastel,
                    borderRadius: BorderRadius.circular(
                      isMobile ? 6 : 8,
                    ),
                  ),
                  child: Text(
                    '$taxaSucesso%',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 13,
                        mobileFontSize: 11,
                        tabletFontSize: 12,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: taxaSucesso >= 95 ? ThemeColors.of(context).successDark : ThemeColors.of(context).warningDark,
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
                _buildBadge('${item['total']} total', ThemeColors.of(context).primary),
                SizedBox(
                  width: AppSizes.paddingXs.get(isMobile, isTablet),
                ),
                _buildBadge('${item['sucesso']} OK', ThemeColors.of(context).success),
                if (item['erros'] > 0) ...[
                  SizedBox(
                    width: AppSizes.paddingXs.get(isMobile, isTablet),
                  ),
                  _buildBadge('${item['erros']} erros', ThemeColors.of(context).error),
                ],
                const Spacer(),
                Icon(
                  Icons.schedule_rounded,
                  size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
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
                      mobileFontSize: 10,
                      tabletFontSize: 11,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondaryOverlay70,
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
        color: colorLight,
        borderRadius: BorderRadius.circular(
          isMobile ? 5 : 6,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            baseFontSize: 11,
            mobileFontSize: 9,
            tabletFontSize: 10,
          ),
        overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  void _iniciarUpload() async {
    try {
      // Iniciar exporta??o via provider (chama API real)
      await _notifier.exportProducts();
      
      // Se chegou aqui sem erro e completou com sucesso
      if (_state.errorMessage == null && _state.result != null) {
        _showSuccessDialog();
      } else if (_state.errorMessage != null) {
        _showErrorSnackBar(_state.errorMessage!);
      }
    } catch (e) {
      _showErrorSnackBar('Erro na exporta??o: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeColors.of(context).error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessDialog() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 20 : (isTablet ? 22 : 24),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(
            AppSizes.paddingXxl.get(isMobile, isTablet),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.cardPadding.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconHeroXl.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                height: AppSizes.paddingXl.get(isMobile, isTablet),
              ),
              Text(
                'Produtos Importados! ',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 24,
                    mobileFontSize: 20,
                    tabletFontSize: 22,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.8,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingMd.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).successPastel,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$_totalExportados produtos exportados',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 16,
                          mobileFontSize: 14,
                          tabletFontSize: 15,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$_sucessos',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 20,
                                  mobileFontSize: 18,
                                  tabletFontSize: 19,
                                ),
                              overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: ThemeColors.of(context).success,
                              ),
                            ),
                            Text(
                              'Sucesso',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 11,
                                  mobileFontSize: 10,
                                  tabletFontSize: 10,
                                ),
                              overflow: TextOverflow.ellipsis,
                                color: ThemeColors.of(context).textSecondaryOverlay70,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$_erros',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 20,
                                  mobileFontSize: 18,
                                  tabletFontSize: 19,
                                ),
                              overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: ThemeColors.of(context).error,
                              ),
                            ),
                            Text(
                              'Erros',
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
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$_ignorados',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 20,
                                  mobileFontSize: 18,
                                  tabletFontSize: 19,
                                ),
                              overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: ThemeColors.of(context).orangeMaterial,
                              ),
                            ),
                            Text(
                              'Ignorados',
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
                  ],
                ),
              ),
              SizedBox(
                height: AppSizes.paddingXl.get(isMobile, isTablet),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.of(context).success,
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isMobile ? 12 : 14,
                      ),
                    ),
                  ),
                  child: Text(
                    'Concluir',
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
                ),
              ),
            ],
          ),
        )),
    );
  }
}












