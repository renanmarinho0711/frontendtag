import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/products/presentation/providers/products_state_provider.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';

/// Tela de importação em massa de produtos
/// Conectada ao productImportProvider para gerenciamento de estado
class ProdutosImportarScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  
  const ProdutosImportarScreen({super.key, this.onBack});

  @override
  ConsumerState<ProdutosImportarScreen> createState() => _ProdutosImportarScreenState();
}

class _ProdutosImportarScreenState extends ConsumerState<ProdutosImportarScreen> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;

  // ============================================================================
  // PROVIDER ACCESS
  // ============================================================================
  
  ProductImportState get _importState => ref.watch(productImportProvider);
  ProductImportNotifier get _importNotifier => ref.read(productImportProvider.notifier);
  
  int get _step => _importState.currentStep;
  String? get _arquivoNome => _importState.arquivoNome;
  List<ImportPreviewItem> get _previewDados => _importState.previewItems;
  int get _totalLinhas => _importState.totalLinhas;
  int get _linhasProcessadas => _importState.linhasProcessadas;
  int get _sucessos => _importState.sucessos;
  int get _erros => _importState.erros;
  // NOTA: _importando removido (morto)
  double get _progresso => _importState.progressoImportacao;
  int get _validosNoPreview => _importState.validosNoPreview;
  int get _invalidosNoPreview => _importState.invalidosNoPreview;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
    
    // Reset state ao entrar na tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _importNotifier.reset();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ============================================================================
  // BUILD
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          _buildProgressIndicator(),
          Padding(
            padding: AppSizes.paddingLg.toEdgeInsetsAll(isMobile, isTablet),
            child: _buildCurrentStep(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return Container(
      margin: AppSizes.paddingMd.toEdgeInsetsAll(isMobile, isTablet),
      padding: AppSizes.paddingLg.toEdgeInsetsAll(isMobile, isTablet),
      decoration: BoxDecoration(
        gradient: AppGradients.blueCyan,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.primaryHeaderGlowMobile,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppThemeColors.surface,
            ),
            onPressed: () {
              if (widget.onBack != null) {
                widget.onBack!();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppThemeColors.surfaceOverlay20,
              borderRadius: AppRadius.md,
            ),
            child: Icon(
              Icons.cloud_upload_rounded,
              color: AppThemeColors.surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Importação em Massa',
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeLg.get(isMobile, isTablet),
                    fontWeight: FontWeight.bold,
                    color: AppThemeColors.surface,
                  ),
                ),
                Text(
                  _getStepDescription(),
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeXs.get(isMobile, isTablet),
                    color: AppThemeColors.white90,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStepDescription() {
    switch (_step) {
      case 1:
        return 'Selecione o arquivo CSV/Excel';
      case 2:
        return 'Revise os dados antes de importar';
      case 3:
        return 'Importando produtos...';
      case 4:
        return 'Importação concluída';
      default:
        return '';
    }
  }

  Widget _buildProgressIndicator() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return Container(
      margin: AppSizes.paddingMd.toEdgeInsetsHorizontal(isMobile, isTablet),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: AppRadius.card,
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimaryOverlay05,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildStepIndicator(1, 'Upload', _step >= 1),
              Expanded(child: _buildStepConnector(_step > 1)),
              _buildStepIndicator(2, 'Preview', _step >= 2),
              Expanded(child: _buildStepConnector(_step > 2)),
              _buildStepIndicator(3, 'Importar', _step >= 3),
              Expanded(child: _buildStepConnector(_step > 3)),
              _buildStepIndicator(4, 'Concluído', _step >= 4),
            ],
          ),
          if (_step == 3) ...[
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: AppRadius.xs,
              child: LinearProgressIndicator(
                value: _progresso,
                backgroundColor: AppThemeColors.textSecondaryOverlay20,
                valueColor: const AlwaysStoppedAnimation<Color>(AppThemeColors.brandPrimaryGreen),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '$_linhasProcessadas de $_totalLinhas processados',
              style: TextStyle(
                fontSize: AppTextStyles.fontSizeXs.get(isMobile, isTablet),
                color: AppThemeColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool completed) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;
    final size = AppSizes.paddingXl.get(isMobile, isTablet) + 8;

    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: completed ? AppGradients.blueCyan : null,
            color: completed ? null : AppThemeColors.textSecondaryOverlay30,
            shape: BoxShape.circle,
          ),
          child: completed
              ? Icon(
                  Icons.check_rounded, 
                  color: AppThemeColors.surface, 
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                )
              : Center(
                  child: Text(
                    '$step',
                    style: TextStyle(
                      fontSize: AppTextStyles.fontSizeXs.get(isMobile, isTablet),
                      fontWeight: FontWeight.bold,
                      color: AppThemeColors.textSecondary,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          label,
          style: TextStyle(
            fontSize: AppTextStyles.fontSizeXxs.get(isMobile, isTablet),
            fontWeight: completed ? FontWeight.w600 : FontWeight.normal,
            color: completed ? AppThemeColors.blueCyan : AppThemeColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(bool completed) {
    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: completed ? AppGradients.blueCyan : null,
        color: completed ? null : AppThemeColors.textSecondaryOverlay30,
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case 1:
        return _buildUploadStep();
      case 2:
        return _buildPreviewStep();
      case 3:
        return _buildImportingStep();
      case 4:
        return _buildCompletedStep();
      default:
        return Container();
    }
  }

  Widget _buildUploadStep() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return Column(
      children: [
        _buildInfoCard(),
        const SizedBox(height: AppSpacing.xl),
        Container(
          padding: AppSizes.paddingXl.toEdgeInsetsAll(isMobile, isTablet),
          decoration: BoxDecoration(
            color: AppThemeColors.surface,
            borderRadius: AppRadius.card,
            border: Border.all(
              color: AppThemeColors.blueCyan.withValues(alpha: 0.3),
              width: AppSizes.borderWidthMedium,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppThemeColors.textPrimaryOverlay05,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                Icons.cloud_upload_rounded,
                size: AppSizes.iconHeroLg.get(isMobile, isTablet),
                color: AppThemeColors.blueCyan,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Arraste o arquivo aqui',
                style: TextStyle(
                  fontSize: AppTextStyles.fontSizeXl.get(isMobile, isTablet),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'ou clique para selecionar',
                style: TextStyle(
                  fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
                  color: AppThemeColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: _selecionarArquivo,
                icon: const Icon(Icons.attach_file_rounded),
                label: const Text('Selecionar Arquivo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeColors.blueCyan,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingXxl.get(isMobile, isTablet),
                    vertical: AppSizes.paddingLg.get(isMobile, isTablet),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.button,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Formatos aceitos: CSV, XLS, XLSX',
                style: TextStyle(
                  fontSize: AppTextStyles.fontSizeXs.get(isMobile, isTablet),
                  color: AppThemeColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        OutlinedButton.icon(
          onPressed: _baixarTemplate,
          icon: const Icon(Icons.download_rounded),
          label: const Text('Baixar Modelo CSV'),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingXl.get(isMobile, isTablet),
              vertical: AppSizes.paddingMd.get(isMobile, isTablet),
            ),
            side: const BorderSide(color: AppThemeColors.blueCyan),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.button,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppThemeColors.infoBackground,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppThemeColors.infoBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppThemeColors.infoDark,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Formato do Arquivo',
                style: TextStyle(
                  fontSize: AppTextStyles.fontSizeLg.get(isMobile, isTablet),
                  fontWeight: FontWeight.bold,
                  color: AppThemeColors.infoDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Seu arquivo CSV deve conter as seguintes colunas:',
            style: TextStyle(fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet)),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildInfoItem('codigo', 'Código de barras (mínimo 8 dígitos)'),
          _buildInfoItem('nome', 'Nome do produto (obrigatório)'),
          _buildInfoItem('preco', 'Preço unitário (formato: 9.99)'),
          _buildInfoItem('categoria', 'Categoria existente no sistema'),
          _buildInfoItem('estoque', 'Quantidade em estoque (opcional)'),
          _buildInfoItem('descricao', 'Descrição do produto (opcional)'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String campo, String descricao) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.lg, top: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'â€¢ ',
            style: TextStyle(
              color: AppThemeColors.infoDark, 
              fontSize: AppTextStyles.fontSizeLg.get(isMobile, isTablet),
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: AppTextStyles.fontSizeXs.get(isMobile, isTablet), 
                  color: AppThemeColors.textPrimary,
                ),
                children: [
                  TextSpan(
                    text: '$campo: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      color: AppThemeColors.infoDark,
                    ),
                  ),
                  TextSpan(text: descricao),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewStep() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: const BoxDecoration(
            color: AppThemeColors.surface,
            borderRadius: AppRadius.card,
            boxShadow: [
              BoxShadow(
                color: AppThemeColors.textPrimaryOverlay05,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.description_rounded, color: AppThemeColors.blueCyan),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _arquivoNome ?? 'produtos.csv',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppTextStyles.fontSizeLg.get(isMobile, isTablet),
                      ),
                    ),
                    Text(
                      '${_previewDados.length} linhas encontradas',
                      style: TextStyle(
                        fontSize: AppTextStyles.fontSizeXs.get(isMobile, isTablet),
                        color: AppThemeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Válidos',
                '$_validosNoPreview',
                Icons.check_circle_rounded,
                AppThemeColors.greenMain,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                'Erros',
                '$_invalidosNoPreview',
                Icons.error_rounded,
                AppThemeColors.redMain,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Preview dos Dados',
          style: TextStyle(
            fontSize: AppTextStyles.fontSizeLg.get(isMobile, isTablet),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ..._previewDados.map((item) => _buildPreviewItem(item)),
        const SizedBox(height: AppSpacing.xxl),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _importNotifier.reset();
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingLg.get(isMobile, isTablet),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.button,
                  ),
                ),
                child: const Text('Voltar'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _validosNoPreview > 0 ? _iniciarImportacao : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeColors.greenMain,
                  disabledBackgroundColor: AppThemeColors.textSecondary,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingLg.get(isMobile, isTablet),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.button,
                  ),
                ),
                child: Text('Importar $_validosNoPreview Produtos'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;
                     
    return Container(
      padding: AppSizes.paddingLg.toEdgeInsetsAll(isMobile, isTablet),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.lg,
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSizes.iconLarge.get(isMobile, isTablet)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeXxl.get(isMobile, isTablet),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeXs.get(isMobile, isTablet),
              color: AppThemeColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewItem(ImportPreviewItem item) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: item.valido 
              ? AppThemeColors.greenMain.withValues(alpha: 0.3) 
              : AppThemeColors.redMain.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: item.valido ? AppThemeColors.greenMain : AppThemeColors.redMain,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.valido ? Icons.check_rounded : Icons.close_rounded,
                  color: AppThemeColors.surface,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  item.nome,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: const BoxDecoration(
                  color: AppThemeColors.textSecondaryOverlay10,
                  borderRadius: AppRadius.sm,
                ),
                child: Text(
                  'Linha ${item.linha}',
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeXxs.get(isMobile, isTablet),
                    fontWeight: FontWeight.w600,
                    color: AppThemeColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              _buildFieldChip('Código', item.codigo),
              _buildFieldChip('Preço', 'R\$ ${item.preco}'),
              _buildFieldChip('Categoria', item.categoria),
              _buildFieldChip('Estoque', '${item.estoque} un'),
            ],
          ),
          if (!item.valido && item.erro != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: const BoxDecoration(
                color: AppThemeColors.errorBackground,
                borderRadius: AppRadius.sm,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: AppSizes.iconSmall.get(isMobile, isTablet),
                    color: AppThemeColors.errorDark,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      item.erro!,
                      style: TextStyle(
                        fontSize: AppTextStyles.fontSizeXxs.get(isMobile, isTablet),
                        color: AppThemeColors.errorDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFieldChip(String label, String value) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;
                     
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppThemeColors.textSecondaryOverlay05,
        borderRadius: AppRadius.sm,
        border: Border.all(color: AppThemeColors.border),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: AppTextStyles.fontSizeXxs.get(isMobile, isTablet), 
            color: AppThemeColors.textPrimary,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppThemeColors.textSecondary,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildImportingStep() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;
                     
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: AppThemeColors.brandPrimaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation<Color>(AppThemeColors.brandPrimaryGreen),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'Importando produtos...',
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeXl.get(isMobile, isTablet),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Aguarde enquanto processamos os dados',
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
              color: AppThemeColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            '$_linhasProcessadas de $_totalLinhas',
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeLg.get(isMobile, isTablet),
              fontWeight: FontWeight.w600,
              color: AppThemeColors.brandPrimaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedStep() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          decoration: BoxDecoration(
            color: AppThemeColors.greenMain.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_rounded,
            size: AppSizes.iconHeroLg.get(isMobile, isTablet),
            color: AppThemeColors.greenMain,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Importação Concluída!',
          style: TextStyle(
            fontSize: AppTextStyles.fontSizeXxl.get(isMobile, isTablet),
            fontWeight: FontWeight.bold,
            color: AppThemeColors.greenMain,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Processo finalizado com sucesso',
          style: TextStyle(
            fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
            color: AppThemeColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: const BoxDecoration(
            color: AppThemeColors.surface,
            borderRadius: AppRadius.card,
            boxShadow: [
              BoxShadow(
                color: AppThemeColors.textPrimaryOverlay05,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildResultItem(
                'Total Processado',
                '$_totalLinhas',
                Icons.list_alt_rounded,
                AppThemeColors.blueCyan,
              ),
              const Divider(height: AppSpacing.xl),
              _buildResultItem(
                'Importados com Sucesso',
                '$_sucessos',
                Icons.check_circle_rounded,
                AppThemeColors.greenMain,
              ),
              const Divider(height: AppSpacing.xl),
              _buildResultItem(
                'Erros',
                '$_erros',
                Icons.error_rounded,
                AppThemeColors.redMain,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _baixarRelatorio,
                icon: const Icon(Icons.download_rounded),
                label: const Text('Baixar Relatório'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingLg.get(isMobile, isTablet),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.button,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppThemeColors.surface),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Produtos Importados!',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '$_sucessos produtos prontos para vincular a tags',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      action: SnackBarAction(
                        label: 'Vincular Tags',
                        textColor: AppThemeColors.surface,
                        onPressed: () {
                          // Navega para a tela de vinculação em lote
                          Navigator.pushNamed(context, '/tags/batch');
                        },
                      ),
                      backgroundColor: AppThemeColors.greenMain,
                      behavior: SnackBarBehavior.floating,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.lg,
                      ),
                      duration: const Duration(seconds: 5),
                    ),
                  );
                  
                  if (widget.onBack != null) {
                    widget.onBack!();
                  }
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text('Concluir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeColors.brandPrimaryGreen,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingLg.get(isMobile, isTablet),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.button,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultItem(String label, String value, IconData icon, Color color) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;
                     
    return Row(
      children: [
        Icon(icon, color: color, size: AppSizes.iconMedium.get(isMobile, isTablet)),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
              color: AppThemeColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: AppTextStyles.fontSizeXl.get(isMobile, isTablet),
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // ACTIONS
  // ============================================================================

  void _selecionarArquivo() async {
    HapticFeedback.mediumImpact();
    
    try {
      // Selecionar arquivo usando file_picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls'],
        withData: true, // Importante para web
      );
      
      if (result == null || result.files.isEmpty) {
        return;
      }
      
      final file = result.files.first;
      if (file.bytes == null) {
        _showErrorSnackBar('Não foi possível ler o arquivo');
        return;
      }
      
      // Parsear o arquivo
      List<Map<String, dynamic>> records;
      
      if (file.extension?.toLowerCase() == 'csv') {
        records = await _parseCSV(file.bytes!);
      } else {
        // Para Excel, por enquanto só suportamos CSV
        _showErrorSnackBar('Por enquanto, apenas arquivos CSV são suportados');
        return;
      }
      
      if (records.isEmpty) {
        _showErrorSnackBar('O arquivo não contém dados válidos');
        return;
      }
      
      // Processa dados através do provider
      await _importNotifier.processFile(file.name, records);
    } catch (e) {
      _showErrorSnackBar('Erro ao processar arquivo: $e');
    }
  }

  /// Parseia arquivo CSV para lista de mapas
  Future<List<Map<String, dynamic>>> _parseCSV(List<int> bytes) async {
    try {
      final csvString = utf8.decode(bytes);
      final csvTable = const CsvToListConverter(
        eol: '\n',
        shouldParseNumbers: true,
      ).convert(csvString);
      
      if (csvTable.isEmpty) {
        return [];
      }
      
      // Primeira linha são os headers
      final headers = csvTable.first.map((e) => e.toString().trim().toLowerCase()).toList();
      
      // Converter cada linha em um Map
      final records = <Map<String, dynamic>>[];
      for (var i = 1; i < csvTable.length; i++) {
        final row = csvTable[i];
        final record = <String, dynamic>{};
        
        for (var j = 0; j < headers.length && j < row.length; j++) {
          record[headers[j]] = row[j];
        }
        
        // Ignorar linhas vazias
        if (record.values.any((v) => v != null && v.toString().isNotEmpty)) {
          records.add(record);
        }
      }
      
      return records;
    } catch (e) {
      debugPrint('Erro ao parsear CSV: $e');
      return [];
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppThemeColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _baixarTemplate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.download_rounded, color: AppThemeColors.surface),
            SizedBox(width: AppSpacing.md),
            Text('Baixando modelo CSV...'),
          ],
        ),
        backgroundColor: AppThemeColors.blueCyan,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lg,
        ),
      ),
    );
  }

  void _iniciarImportacao() async {
    HapticFeedback.mediumImpact();
    
    // Obtém storeId do contexto
    final currentStore = ref.read(currentStoreProvider);
    final storeId = currentStore?.id ?? '';
    
    // Executa importação via provider
    await _importNotifier.executeImport(storeId: storeId);
    
    HapticFeedback.heavyImpact();
  }

  void _baixarRelatorio() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.description_rounded, color: AppThemeColors.surface),
            SizedBox(width: AppSpacing.md),
            Text('Baixando relatório de importação...'),
          ],
        ),
        backgroundColor: AppThemeColors.greenMain,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lg,
        ),
      ),
    );
  }
}


