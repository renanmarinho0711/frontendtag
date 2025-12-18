import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:tagbean/features/import_export/presentation/providers/import_export_provider.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';

class ImportacaoTagsScreen extends ConsumerStatefulWidget {
  const ImportacaoTagsScreen({super.key});

  @override
  ConsumerState<ImportacaoTagsScreen> createState() => _ImportacaoTagsScreenState();
}

class _ImportacaoTagsScreenState extends ConsumerState<ImportacaoTagsScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  // ignore: unused_field
  File? _arquivoSelecionado;

  // Acesso ao provider
  ImportTagsState get _state => ref.watch(importTagsProvider);
  ImportTagsNotifier get _notifier => ref.read(importTagsProvider.notifier);
  
  // Getters para compatibilidade
  bool get _uploading => _state.isUploading;
  int get _currentStep => _state.currentStep;
  double get _uploadProgress => _state.uploadProgress;

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
      'duplicados': h.duplicateCount ?? 0,
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
    
    // Carregar histórico
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
                colors: [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 12 : 14,
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).greenGradient.withValues(alpha: 0.3),
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
            width: AppSizes.paddingMd.get(isMobile, isTablet),
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
                  'Cadastro em Lote de ESLs',
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
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(
                isMobile ?  10 : 12,
              ),
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
                    ? LinearGradient(colors: [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd])
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
                    ? LinearGradient(colors: [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd])
                    : null,
                color: _currentStep >= 2 ? null : ThemeColors.of(context).textSecondary,
                borderRadius: AppRadius.xxxs,
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
                    colors: [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd],
                  )
                : null,
            color: isActive ? null : ThemeColors.of(context).textSecondary,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Color.alphaBlend(ThemeColors.of(context).surface.withValues(alpha: 0.7), ThemeColors.of(context).greenGradient),
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
            color: isActive ? ThemeColors.of(context).greenGradient : ThemeColors.of(context).textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStep1Card() {
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
                Icons.table_chart_rounded,
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
                'ETAPA 1 - TEMPLATE',
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
              'Baixe o Template de Tags',
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
              'Template padronizado com as colunas necessãrias',
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
                  _buildColumnItem('ID da Tag', 'obrigatório', 'Ex: TAG-001, TAG-002'),
                  _buildColumnItem('LocalizAção', 'opcional', 'Corredor e prateleira'),
                  _buildColumnItem('Observações', 'opcional', 'Notas adicionais'),
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
                            Icons.download_rounded,
                            color: ThemeColors.of(context).surface,
                            size: AppSizes.iconMedium.get(isMobile, isTablet),
                          ),
                          SizedBox(
                            width: AppSizes.paddingBase.get(isMobile, isTablet),
                          ),
                          Text(
                            'Template de tags baixado!',
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
                  'Baixar Template de Tags',
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
                  backgroundColor: ThemeColors.of(context).success,
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

  Widget _buildColumnItem(String nome, String status, String exemplo) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isObrigatorio = status == 'obrigatório';
    
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isObrigatorio ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: AppSizes.iconTiny.get(isMobile, isTablet),
            color: isObrigatorio ? ThemeColors.of(context).success : ThemeColors.of(context).textSecondaryOverlay60,
          ),
          SizedBox(
            width: AppSizes.paddingSmAlt.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
                        vertical: AppSizes.paddingMicro.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        color: isObrigatorio ? ThemeColors.of(context).error.withValues(alpha: 0.1) : ThemeColors.of(context).textSecondary,
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
                          color: isObrigatorio ? ThemeColors.of(context).error.withValues(alpha: 0.8) : ThemeColors.of(context).textSecondaryOverlay70,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSizes.paddingMicro.get(isMobile, isTablet),
                ),
                Text(
                  exemplo,
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
              ],
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
                colors: [ThemeColors.of(context).materialTeal.withValues(alpha: 0.1), ThemeColors.of(context).cyanMain.withValues(alpha: 0.1)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_upload_rounded,
              size: AppSizes.iconHeroMd.get(isMobile, isTablet),
              color: ThemeColors.of(context).materialTeal.withValues(alpha: 0.8),
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
              color: ThemeColors.of(context).materialTeal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                isMobile ? 6 : 8,
              ),
              border: Border.all(color: ThemeColors.of(context).materialTeal.withValues(alpha: 0.3)),
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
                color: ThemeColors.of(context).materialTeal,
                letterSpacing: 1.5,
              ),
            ),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Text(
            'Envie o Arquivo',
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
            'Arquivo Excel com as tags preenchidas',
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
                          ThemeColors.of(context).greenGradient.withValues(alpha: 0.1),
                          ThemeColors.of(context).greenGradientEnd.withValues(alpha: 0.1),
                        ],
                      ),
                border: Border.all(
                  color: ThemeColors.of(context).greenGradient,
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
                    Stack(
                      alignment: Alignment.center,
                      children: [
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
                            value: _uploadProgress,
                            strokeWidth: ResponsiveHelper.getResponsiveWidth(
                              context,
                              mobile: 3,
                              tablet: 4,
                              desktop: 4,
                            ),
                            backgroundColor: ThemeColors.of(context).textSecondary,
                            valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).greenGradient),
                          ),
                        ),
                        Text(
                          '${(_uploadProgress * 100).toInt()}%',
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
                      ],
                    ),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    Text(
                      'Importando tags...',
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
                  ] else ...[
                    Icon(
                      Icons.cloud_upload_rounded,
                      size: AppSizes.iconHeroXl.get(isMobile, isTablet),
                      color: ThemeColors.of(context).greenGradient,
                    ),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    Text(
                      'Arraste o arquivo Excel aqui',
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
                        'Mãximo: 500 tags por arquivo',
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
          colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).cyanMain.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : (isTablet ?  14 : 16),
        ),
        border: Border.all(color: ThemeColors.of(context).infoLight),
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
                color: ThemeColors.of(context).infoDark,
              ),
              SizedBox(
                width: AppSizes.paddingSmAlt.get(isMobile, isTablet),
              ),
              Text(
                'Dicas de Importação',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 14,
                    tabletFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).primary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingSm.get(isMobile, isTablet),
          ),
          _buildTipItem('?', 'IDs devem ser únicos (ex: TAG-001)'),
          _buildTipItem('?', 'LocalizAção é opcional mas recomendada'),
          _buildTipItem('?', 'Tags duplicadas serão ignoradas'),
          _buildTipItem('?', 'Mãximo de 500 tags por arquivo'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String icon, String text) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSizes.paddingXs.get(isMobile, isTablet),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            icon,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 16,
                mobileFontSize: 14,
                tabletFontSize: 15,
              ),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).infoDark,
              fontWeight: FontWeight.bold,
            ),
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
                color: ThemeColors.of(context).textSecondaryOverlay80,
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
                      colors: [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd],
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
                        (item['nome']).toString(),
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
                        (item['data']).toString(),
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
                    color: taxaSucesso == 100 ? ThemeColors.of(context).success.withValues(alpha: 0.1) : ThemeColors.of(context).warningPastel,
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
                      color: taxaSucesso == 100 ? ThemeColors.of(context).success.withValues(alpha: 0.8) : ThemeColors.of(context).warningDark,
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
                if (item['duplicados'] > 0) ...[
                  SizedBox(
                    width: AppSizes.paddingXs.get(isMobile, isTablet),
                  ),
                  _buildBadge('${item['duplicados']} dupl. ', ThemeColors.of(context).orangeMaterial),
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
                  (item['duracao']).toString(),
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          isMobile ?  5 : 6,
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
    _notifier.startUpload();

    // Upload com progresso via provider
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 200));
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
                'Tags Importadas!',
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
                      '47 tags cadastradas com sucesso',
                      textAlign: TextAlign.center,
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
                              '47',
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
                            SizedBox(
                              height: AppSizes.paddingXxs.get(isMobile, isTablet),
                            ),
                            Text(
                              'Novas tags',
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
                            SizedBox(
                              height: AppSizes.paddingXxs.get(isMobile, isTablet),
                            ),
                            Text(
                              'Duplicadas',
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
                                color: ThemeColors.of(context).error,
                              ),
                            ),
                            SizedBox(
                              height: AppSizes.paddingXxs.get(isMobile, isTablet),
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
        ),
      ),
    );
  }

  void _mostrarAjuda() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.help_outline_rounded,
              color: ThemeColors.of(context).greenGradient,
              size: AppSizes.iconLarge.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            Text(
              'Ajuda - Importação',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 20,
                  mobileFontSize: 18,
                  tabletFontSize: 19,
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
                'Como importar tags:',
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
                height: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                '1.    Baixe o template Excel',
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
                '2.   Preencha os dados das tags',
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
                '3.   Faça o upload do arquivo',
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
                '4.   Aguarde o processamento',
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
                height: AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              Text(
                'Formato dos IDs:',
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
                'ã TAG-001, TAG-002, etc.',
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
                'ã Devem ser únicos',
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
                'ã Mãximo 20 caracteres',
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
              backgroundColor: ThemeColors.of(context).greenGradient,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXlAlt2.get(isMobile, isTablet),
                vertical: AppSizes.paddingBaseAlt.get(isMobile, isTablet),
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
}







