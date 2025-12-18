import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:tagbean/features/import_export/presentation/providers/import_export_provider.dart';
import 'package:tagbean/features/import_export/data/models/import_export_models.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';

class ImportacaoProdutosScreen extends ConsumerStatefulWidget {
  const ImportacaoProdutosScreen({super.key});

  @override
  ConsumerState<ImportacaoProdutosScreen> createState() => _ImportacaoProdutosScreenState();
}

class _ImportacaoProdutosScreenState extends ConsumerState<ImportacaoProdutosScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  // ignore: unused_field
  File? _arquivoSelecionado;
  
  // Acesso ao provider
  ImportProductsState get _state => ref.watch(importProductsProvider);
  ImportProductsNotifier get _notifier => ref.read(importProductsProvider.notifier);
  
  // Getters para compatibilidade com código existente
  int get _currentStep => _state.currentStep;
  bool get _uploading => _state.isUploading;
  double get _uploadProgress => _state.uploadProgress;
  String get _formatoSelecionado => _state.selectedFormat.id;
  
  Map<String, Map<String, dynamic>> _getFormatos(BuildContext context) => {
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

  // Histórico de importações via provider
  List<Map<String, dynamic>> get _historicoImportacoes {
    final history = _state.importHistory;
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
                  padding: ResponsiveHelper.getResponsiveEdgeInsetsSymmetric(
                    context,
                    mobileHorizontal: 12,
                    mobileVertical: 12,
                    tabletHorizontal: 16,
                    tabletVertical: 16,
                    desktopHorizontal: 20,
                    desktopVertical: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormatoSelector(),
                      ResponsiveSpacing.verticalMedium(context),
                      _buildStep1Card(),
                      ResponsiveSpacing.verticalMedium(context),
                      _buildStep2Card(),
                      ResponsiveSpacing.verticalMedium(context),
                      _buildInfoCard(),
                      ResponsiveSpacing.verticalLarge(context),
                      Text(
                        'Importações Recentes',
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
                      ResponsiveSpacing.verticalMedium(context),
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
            blurRadius: isMobile ? 20 : (isTablet ? 22 : 25),
            offset: Offset(0, isMobile ? 5 : 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textSecondary,
                size: ResponsiveHelper.getResponsiveIconSize(
                  context,
                  mobile: 19,
                  tablet: 19.5,
                  desktop: 20,
                ),
              ),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 7,
                  tablet: 7.5,
                  desktop: 8,
                ),
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
                isMobile ? 12 : (isTablet ? 13 : 14),
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).primary.withValues(alpha: 0.3),
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
                      mobileFontSize: 17,
                      tabletFontSize: 18.5,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 3,
                    tablet: 3.5,
                    desktop: 4,
                  ),
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
          if (! isMobile || ResponsiveHelper.isLandscape(context))
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                vertical: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 5,
                  tablet: 5.5,
                  desktop: 6,
                ),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).successPastel,
                borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
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
                    width: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 5,
                      tablet: 5.5,
                      desktop: 6,
                    ),
                  ),
                  Text(
                    'Guia',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                        tabletFontSize: 10.5,
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
          isMobile ? 14 : (isTablet ? 15 : 16),
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
              height: isMobile ? 2.5 : 3,
              decoration: BoxDecoration(
                gradient: _currentStep >= 1
                    ? LinearGradient(colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark])
                    : null,
                color: _currentStep >= 1 ? null : ThemeColors.of(context).textSecondary,
                borderRadius: BorderRadius.circular(isMobile ? 1.5 : 2),
              ),
            ),
          ),
          _buildStepIndicator(1, 'Upload', Icons.cloud_upload_rounded, _currentStep >= 1),
          Expanded(
            child: Container(
              height: isMobile ?  2.5 : 3,
              decoration: BoxDecoration(
                gradient: _currentStep >= 2
                    ? LinearGradient(colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark])
                    : null,
                color: _currentStep >= 2 ? null : ThemeColors.of(context).textSecondaryOverlay40,
                borderRadius: BorderRadius.circular(isMobile ? 1.5 : 2),
              ),
            ),
          ),
          _buildStepIndicator(2, 'Concluãdo', Icons.check_circle_rounded, _currentStep >= 2),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, IconData icon, bool isActive) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: ResponsiveHelper.getResponsiveWidth(
            context,
            mobile: 38,
            tablet: 40,
            desktop: 42,
          ),
          height: ResponsiveHelper.getResponsiveHeight(
            context,
            mobile: 38,
            tablet: 40,
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
                      color: ThemeColors.of(context).primary.withValues(alpha: 0.3),
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
          height: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 5,
            tablet: 5.5,
            desktop: 6,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 11,
              mobileFontSize: 10,
              tabletFontSize: 10.5,
            ),
          overflow: TextOverflow.ellipsis,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ?  ThemeColors.of(context).blueCyan : ThemeColors.of(context).textSecondaryOverlay70,
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
                  ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 9,
                    tablet: 9.5,
                    desktop: 10,
                  ),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).infoPastel,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
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
          ResponsiveSpacing.verticalMedium(context),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: _getFormatos(context).entries.map((entry) {
              final formato = entry.value;
              final isSelected = _formatoSelecionado == entry.key;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: AppSizes.spacingBase.get(isMobile, isTablet),
                  ),
                  child: InkWell(
                    onTap: () => _notifier.setFormat(entry.key == 'excel' ? ExportFormat.excel : ExportFormat.csv),
                    borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(
                        AppSizes.paddingMdAlt.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                // ignore: list_element_type_not_assignable
                                colors: [formato['cor'], (formato['cor'] as Color).withValues(alpha: 0.7)],
                              )
                            : null,
                        color: isSelected ? null : ThemeColors.of(context).textSecondary,
                        border: Border.all(
                          color: isSelected ? ThemeColors.of(context).transparent : ThemeColors.of(context).textSecondary,
                          width: isMobile ? 1.5 : 2,
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: (formato['cor'] as Color).withValues(alpha: 0.3),
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
                            height: AppSizes.spacingSmAlt.get(isMobile, isTablet),
                          ),
                          Text(
                            formato['nome'],
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 14,
                                mobileFontSize: 13,
                                tabletFontSize: 13.5,
                              ),
                            overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              mobile: 3,
                              tablet: 3.5,
                              desktop: 4,
                            ),
                          ),
                          Text(
                            formato['extensao'],
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 11,
                                mobileFontSize: 10,
                                tabletFontSize: 10.5,
                              ),
                            overflow: TextOverflow.ellipsis,
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
    final formato = _getFormatos(context)[_formatoSelecionado]!;
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
                  colors: [ThemeColors.of(context).successPastel, ThemeColors.of(context).materialTeal.withValues(alpha: 0.1)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.file_download_rounded,
                size: AppSizes.iconHeroMd.get(isMobile, isTablet),
                color: ThemeColors.of(context).successIcon,
              ),
            ),
            ResponsiveSpacing.verticalMedium(context),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                vertical: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 5,
                  tablet: 5.5,
                  desktop: 6,
                ),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).successPastel,
                borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                border: Border.all(color: ThemeColors.of(context).successLight),
              ),
              child: Text(
                'ETAPA 1 - PREPARAÇÃO',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 11,
                    mobileFontSize: 10,
                    tabletFontSize: 10.5,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).success,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            SizedBox(
              height: AppSizes.spacingBase.get(isMobile, isTablet),
            ),
            Text(
              'Baixe o Template',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 22,
                  mobileFontSize: 19,
                  tabletFontSize: 20.5,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.8,
              ),
            ),
            SizedBox(
              height: AppSizes.spacingBase.get(isMobile, isTablet),
            ),
            Text(
              'Template com as colunas necessãrias para importação',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13.5,
                ),
              overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).textSecondary,
                height: 1.4,
              ),
            ),
            ResponsiveSpacing.verticalMedium(context),
            Container(
              padding: EdgeInsets.all(
                AppSizes.paddingMdAlt.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).infoPastel,
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
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
                        mobileFontSize: 12,
                        tabletFontSize: 12.5,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.spacingSmAlt.get(isMobile, isTablet),
                  ),
                  _buildColumnItem('Cãdigo de Barras', 'obrigatório'),
                  _buildColumnItem('Nome do Produto', 'obrigatório'),
                  _buildColumnItem('PREÇO', 'obrigatório'),
                  _buildColumnItem('Categoria', 'opcional'),
                  _buildColumnItem('Estoque', 'opcional'),
                ],
              ),
            ),
            ResponsiveSpacing.verticalMedium(context),
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
                          Icon(formato['icone'], color: ThemeColors.of(context).surface),
                          const SizedBox(width: 12),
                          Text('Template ${formato['nome']} baixado!'),
                        ],
                      ),
                      backgroundColor: formato['cor'],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
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
                      tabletFontSize: 13.5,
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
                    borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
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
    final isObrigatorio = status == 'obrigatório';
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveHelper.getResponsiveSpacing(
          context,
          mobile: 7,
          tablet: 7.5,
          desktop: 8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isObrigatorio ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: ResponsiveHelper.getResponsiveIconSize(
              context,
              mobile: 15,
              tablet: 15.5,
              desktop: 16,
            ),
            color: isObrigatorio ? ThemeColors.of(context).success : ThemeColors.of(context).textSecondary,
          ),
          SizedBox(
            width: ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 7,
              tablet: 7.5,
              desktop: 8,
            ),
          ),
          Expanded(
            child: Text(
              nome,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12.5,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 7,
                tablet: 7.5,
                desktop: 8,
              ),
              vertical: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 2.5,
                tablet: 2.75,
                desktop: 3,
              ),
            ),
            decoration: BoxDecoration(
              color: isObrigatorio ? ThemeColors.of(context).error.withValues(alpha: 0.1) : ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, isTablet)),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 10,
                  mobileFontSize: 9,
                  tabletFontSize: 9.5,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: isObrigatorio ? ThemeColors.of(context).error.withValues(alpha: 0.8) : ThemeColors.of(context).textSecondaryOverlay70,
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
                colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).cyanMain.withValues(alpha: 0.1)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_upload_rounded,
              size: AppSizes.iconHeroMd.get(isMobile, isTablet),
              color: ThemeColors.of(context).infoDark,
            ),
          ),
          ResponsiveSpacing.verticalMedium(context),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
              vertical: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 5,
                tablet: 5.5,
                desktop: 6,
              ),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).infoPastel,
              borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
              border: Border.all(color: ThemeColors.of(context).infoLight),
            ),
            child: Text(
              'ETAPA 2 - UPLOAD',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 11,
                  mobileFontSize: 10,
                  tabletFontSize: 10.5,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).primary,
                letterSpacing: 1.5,
              ),
            ),
          ),
          SizedBox(
            height: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          Text(
            'Envie o Arquivo Preenchido',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 22,
                mobileFontSize: 19,
                tabletFontSize: 20.5,
              ),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.8,
            ),
          ),
          SizedBox(
            height: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          Text(
            'Arquivo com os produtos cadastrados conforme template',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
                tabletFontSize: 13.5,
              ),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
              height: 1.4,
            ),
          ),
          ResponsiveSpacing.verticalMedium(context),
          InkWell(
            onTap: _iniciarUpload,
            borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
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
                          ThemeColors.of(context).blueCyan.withValues(alpha: 0.1),
                          ThemeColors.of(context).primary.withValues(alpha: 0.1),
                        ],
                      ),
                border: Border.all(
                  color: ThemeColors.of(context).blueCyan,
                  width: isMobile ? 1.5 : 2,
                ),
                borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
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
                        strokeWidth: 4,
                        valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).blueCyan),
                      ),
                    ),
                    ResponsiveSpacing.verticalMedium(context),
                    Text(
                      'Importando...  ${(_uploadProgress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 16,
                          mobileFontSize: 15,
                          tabletFontSize: 15.5,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.spacingBase.get(isMobile, isTablet),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                      child: LinearProgressIndicator(
                        value: _uploadProgress,
                        minHeight: isMobile ? 7 : 8,
                        backgroundColor: ThemeColors.of(context).textSecondary,
                        valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).blueCyan),
                      ),
                    ),
                  ] else ...[
                    Icon(
                      Icons.cloud_upload_rounded,
                      size: AppSizes.iconHeroXl.get(isMobile, isTablet),
                      color: ThemeColors.of(context).blueCyan,
                    ),
                    ResponsiveSpacing.verticalMedium(context),
                    Text(
                      'Arraste o arquivo aqui',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 18,
                          mobileFontSize: 16,
                          tabletFontSize: 17,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        mobile: 7,
                        tablet: 7.5,
                        desktop: 8,
                      ),
                    ),
                    Text(
                      'ou clique para selecionar',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 13,
                          tabletFontSize: 13.5,
                        ),
                      overflow: TextOverflow.ellipsis,
                        color: ThemeColors.of(context).textSecondary,
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.spacingBase.get(isMobile, isTablet),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                        vertical: ResponsiveHelper.getResponsivePadding(
                          context,
                          mobile: 5,
                          tablet: 5.5,
                          desktop: 6,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).textSecondary,
                        borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                      ),
                      child: Text(
                        'Mãximo: 10 MB',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 11,
                            mobileFontSize: 10,
                            tabletFontSize: 10.5,
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
          colors: [ThemeColors.of(context).orangeAmber.withValues(alpha: 0.1), ThemeColors.of(context).orangeMaterial.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        border: Border.all(color: ThemeColors.of(context).orangeAmber.withValues(alpha: 0.3)),
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
                color: ThemeColors.of(context).orangeAmber.withValues(alpha: 0.8),
              ),
              SizedBox(
                width: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 9,
                  tablet: 9.5,
                  desktop: 10,
                ),
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
                  color: ThemeColors.of(context).orangeAmber.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.spacingSm.get(isMobile, isTablet),
          ),
          _buildTipItem('Cãdigos de barras devem ser únicos'),
          _buildTipItem('PREÇOs devem usar ponto como separador decimal'),
          _buildTipItem('Produtos duplicados serão ignorados'),
          _buildTipItem('Mãximo de 1.000 produtos por arquivo'),
        ],
      ),
    );
  }

  // ignore: unused_local_variable
  Widget _buildTipItem(String text) {
    // ignore: unused_local_variable
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveHelper.getResponsiveSpacing(
          context,
          mobile: 7,
          tablet: 7.5,
          desktop: 8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: ResponsiveHelper.getResponsiveIconSize(
              context,
              mobile: 15,
              tablet: 15.5,
              desktop: 16,
            ),
            color: ThemeColors.of(context).orangeAmber.withValues(alpha: 0.8),
          ),
          SizedBox(
            width: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 9,
              tablet: 9.5,
              desktop: 10,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12.5,
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
    final taxaSucesso = (item['sucesso'] / item['total'] * 100).round();
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

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
          bottom: AppSizes.spacingBase.get(isMobile, isTablet),
        ),
        padding: EdgeInsets.all(
          AppSizes.paddingLgAlt3.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 14 : (isTablet ? 15 : 16),
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
                    ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 9,
                      tablet: 9.5,
                      desktop: 10,
                    ),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],
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
                            tabletFontSize: 14.5,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          mobile: 2.5,
                          tablet: 2.75,
                          desktop: 3,
                        ),
                      ),
                      Text(
                        item['data'],
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 12,
                            mobileFontSize: 11,
                            tabletFontSize: 11.5,
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
                    horizontal: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 9,
                      tablet: 9.5,
                      desktop: 10,
                    ),
                    vertical: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 4,
                      tablet: 4.5,
                      desktop: 5,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: taxaSucesso >= 95 ? ThemeColors.of(context).success.withValues(alpha: 0.1) : ThemeColors.of(context).warningPastel,
                    borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                  ),
                  child: Text(
                    '$taxaSucesso%',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 13,
                        mobileFontSize: 12,
                        tabletFontSize: 12.5,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: taxaSucesso >= 95 ? ThemeColors.of(context).success.withValues(alpha: 0.8) : ThemeColors.of(context).warningDark,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppSizes.spacingSm.get(isMobile, isTablet),
            ),
            Wrap(
              spacing: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 7,
                tablet: 7.5,
                desktop: 8,
              ),
              runSpacing: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 7,
                tablet: 7.5,
                desktop: 8,
              ),
              children: [
                _buildBadge('${item['total']} total', ThemeColors.of(context).primary),
                _buildBadge('${item['sucesso']} OK', ThemeColors.of(context).success),
                if (item['erros'] > 0) _buildBadge('${item['erros']} erros', ThemeColors.of(context).error),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: ResponsiveHelper.getResponsiveIconSize(
                        context,
                        mobile: 13,
                        tablet: 13.5,
                        desktop: 14,
                      ),
                      color: ThemeColors.of(context).textSecondaryOverlay60,
                    ),
                    SizedBox(
                      width: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        mobile: 3,
                        tablet: 3.5,
                        desktop: 4,
                      ),
                    ),
                    Text(
                      item['duracao'],
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 12,
                          mobileFontSize: 11,
                          tabletFontSize: 11.5,
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
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 7,
          tablet: 7.5,
          desktop: 8,
        ),
        vertical: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 3.5,
          tablet: 3.75,
          desktop: 4,
        ),
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
            tabletFontSize: 10.5,
          ),
        overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  void _iniciarUpload() async {
    _notifier.startUpload();

    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        _notifier.setUploadProgress(i / 100);
      }
    }

    _notifier.completeUpload();

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 20 : (isTablet ? 22 : 24)),
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
              ResponsiveSpacing.verticalMedium(context),
              Text(
                'Produtos Importados! ',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 24,
                    mobileFontSize: 21,
                    tabletFontSize: 22.5,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.8,
                ),
              ),
              ResponsiveSpacing.verticalMedium(context),
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingMdAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).successPastel,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '156 produtos cadastrados',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 16,
                          mobileFontSize: 15,
                          tabletFontSize: 15.5,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.spacingBase.get(isMobile, isTablet),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '152',
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
                                  tabletFontSize: 10.5,
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
                              '4',
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
                                  tabletFontSize: 10.5,
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
                              '0',
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
                              'Duplicados',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 11,
                                  mobileFontSize: 10,
                                  tabletFontSize: 10.5,
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
              ResponsiveSpacing.verticalMedium(context),
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
                      borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
                    ),
                  ),
                  child: Text(
                    'Concluir',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 16,
                        mobileFontSize: 15,
                        tabletFontSize: 15.5,
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









