import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/features/products/presentation/providers/products_state_provider.dart';
import 'package:tagbean/features/products/data/models/product_models.dart';

/// Tela de edição de produto
/// Aceita ProductModel para dados reais
class ProdutosEditarScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProdutosEditarScreen({super.key, required this.product});

  @override
  ConsumerState<ProdutosEditarScreen> createState() => _ProdutosEditarScreenState();
}

class _ProdutosEditarScreenState extends ConsumerState<ProdutosEditarScreen> 
    with SingleTickerProviderStateMixin, ResponsiveCache {
  
  // Controllers
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codigoController;
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _precoController;
  late TextEditingController _precoKgController;
  
  // Focus nodes
  final _codigoFocusNode = FocusNode();
  final _nomeFocusNode = FocusNode();
  final _descricaoFocusNode = FocusNode();
  final _precoFocusNode = FocusNode();
  final _precoKgFocusNode = FocusNode();
  
  // Estado
  late String _categoria;
  late String _status;
  bool _alteracoesFeitas = false;
  bool _salvando = false;
  bool _expandirHistorico = false;
  late AnimationController _animationController;
  
  // Validação
  bool _codigoValido = false;
  bool _nomeValido = false;
  bool _precoValido = false;

  // ============================================
  // GETTERS DO PROVIDER
  // ============================================
  
  ProductDetailsState get _detailsState => ref.watch(productDetailsRiverpodProvider);
  ProductDetails? get _details => _detailsState.details;
  List<PriceHistoryModel> get _historicoPrecos => _details?.historicoPrecos ?? [];

  @override
  void initState() {
    super.initState();
    
    // Inicializa controllers com valores do produto
    _codigoController = TextEditingController(text: widget.product.codigo ?? widget.product.id);
    _nomeController = TextEditingController(text: widget.product.nome);
    _descricaoController = TextEditingController(text: widget.product.descricao ?? '');
    _precoController = TextEditingController(text: widget.product.preco.toString());
    _precoKgController = TextEditingController(
      text: widget.product.precoKg?.toString() ?? '',
    );
    _categoria = widget.product.categoria;
    _status = widget.product.statusLabel;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
    
    // Listeners
    _codigoController.addListener(_onFormChanged);
    _nomeController.addListener(_onFormChanged);
    _precoController.addListener(_onFormChanged);
    _descricaoController.addListener(_onFormChanged);
    _precoKgController.addListener(_onFormChanged);
    
    // Validação inicial
    _validateFields();
  }

  // Helper para aplicar estilos responsivos
  TextStyle _responsiveTextStyle(TextStyle base) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    return base.responsive(isMobile, isTablet);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _codigoController.dispose();
    _nomeController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();
    _precoKgController.dispose();
    _codigoFocusNode.dispose();
    _nomeFocusNode.dispose();
    _descricaoFocusNode.dispose();
    _precoFocusNode.dispose();
    _precoKgFocusNode.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    _validateFields();
    setState(() => _alteracoesFeitas = true);
  }

  void _validateFields() {
    setState(() {
      _codigoValido = _codigoController.text.length >= 8;
      _nomeValido = _nomeController.text.length >= 3;
      _precoValido = _precoController.text.isNotEmpty && 
                     double.tryParse(_precoController.text.replaceAll(',', '.')) != null;
    });
  }

  bool get _formularioValido => _codigoValido && _nomeValido && _precoValido;

  Future<bool> _onWillPop() async {
    if (!_alteracoesFeitas) return true;
    
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => _buildDiscardDialog(context),
    );
    
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    
    return PopScope(
      canPop: !_alteracoesFeitas,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: ThemeColors.of(context).surface,
        body: SafeArea(
          child: Column(
            children: [
              _buildModernAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTagCard(context),
                        SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
                        _buildInfoCard(context),
                        SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
                        _buildPricingCard(context),
                        SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
                        _buildCategoryCard(context),
                        SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
                        _buildHistoryCard(context),
                        SizedBox(height: AppSizes.productEditCardPadding.get(isMobile, isTablet)),
                      ],
                    ),
                  ),
                ),
              ),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final productColor = widget.product.cor ?? ThemeColors.of(context).brandPrimaryGreen;

    return Container(
      margin: AppSizes.productEditSectionSpacing.toEdgeInsetsAll(isMobile, isTablet),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.productEditCardPadding.get(isMobile, isTablet),
        vertical: AppSizes.productEditSectionSpacing.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: isMobile ? AppRadius.card : (isTablet ? AppRadius.lg : AppRadius.xl),
        boxShadow: isMobile ? AppShadows.cardElevatedMobile : AppShadows.cardElevatedDesktop,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondaryOverlay10,
              borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textSecondary,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              onPressed: () {
                if (_alteracoesFeitas) {
                  _onWillPop().then((shouldPop) {
                    if (shouldPop) Navigator.pop(context);
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              tooltip: 'Voltar',
            ),
          ),
          SizedBox(width: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
          Container(
            padding: AppSizes.productEditButtonPaddingHorizontal.toEdgeInsetsAll(isMobile, isTablet),
            decoration: BoxDecoration(
              gradient: CategoryThemes.getTheme(_categoria).gradient,
              borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
            ),
            child: Icon(
              CategoryThemes.getTheme(_categoria).icon,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(width: AppSizes.productEditIconToTitle.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Editar Produto',
                  style: _responsiveTextStyle(AppTextStyles.h3),
                ),
                Text(
                  widget.product.nome,
                  style: _responsiveTextStyle(AppTextStyles.caption.copyWith(color: ThemeColors.of(context).textSecondary)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (_alteracoesFeitas)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.productEditButtonPaddingHorizontal.get(isMobile, isTablet),
                vertical: AppSizes.productEditButtonPaddingVertical.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).warningLight,
                borderRadius: isMobile ? AppRadius.xs : AppRadius.sm,
                border: Border.all(color: ThemeColors.of(context).warning),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_rounded,
                    size: AppSizes.iconExtraSmallAlt2.get(isMobile, isTablet),
                    color: ThemeColors.of(context).warningDark,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    'Editando',
                    style: _responsiveTextStyle(AppTextStyles.tiny.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.of(context).warningDark,
                    )),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTagCard(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final hasTag = widget.product.tagId != null;
    
    return Container(
      padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
      decoration: BoxDecoration(
        gradient: hasTag ? AppGradients.success : AppGradients.alert,
        borderRadius: isMobile ? AppRadius.card : (isTablet ? AppRadius.appBarTablet : AppRadius.appBar),
        border: Border.all(
          color: hasTag ? ThemeColors.of(context).success : ThemeColors.of(context).warning,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: AppSizes.productEditIconToTitle.toEdgeInsetsAll(isMobile, isTablet),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surface,
                  borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
                  boxShadow: hasTag ? AppShadows.successGlow : AppShadows.warningGlow,
                ),
                child: Icon(
                  hasTag ? Icons.label_rounded : Icons.label_off_rounded,
                  color: hasTag ? ThemeColors.of(context).success : ThemeColors.of(context).warning,
                  size: AppSizes.iconLarge.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasTag ? 'Tag Associada' : 'Sem Tag',
                      style: _responsiveTextStyle(AppTextStyles.sectionTitle.copyWith(
                        color: hasTag ? ThemeColors.of(context).successDark : ThemeColors.of(context).warningDark,
                      )),
                    ),
                    SizedBox(
                      height: AppSizes.productEditSmallSpacing.get(isMobile, isTablet),
                    ),
                    Text(
                      hasTag 
                          ? 'Este produto possui tag sincronizada'
                          : 'Este produto não possui tag associada',
                      style: _responsiveTextStyle(AppTextStyles.caption.copyWith(
                        color: ThemeColors.of(context).textSecondary,
                      )),
                    ),
                  ],
                ),
              ),
              if (hasTag)
                OutlinedButton(
                  onPressed: _desassociarTag,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.formFieldSpacing.get(isMobile, isTablet),
                      vertical: AppSizes.formButtonPaddingVertical.get(isMobile, isTablet),
                    ),
                    foregroundColor: ThemeColors.of(context).warningDark,
                    side: BorderSide(color: ThemeColors.of(context).warning),
                    shape: RoundedRectangleBorder(
                      borderRadius: isMobile ? AppRadius.sm : AppRadius.iconButtonLarge,
                    ),
                  ),
                  child: Text(
                    'Desassociar',
                    style: _responsiveTextStyle(AppTextStyles.dialogButton),
                  ),
                ),
            ],
          ),
          if (hasTag) ...[
            SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
            Container(
              padding: AppSizes.formFieldSpacing.toEdgeInsetsAll(isMobile, isTablet),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).surface,
                borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
              ),
              child: Column(
                children: [
                  _buildTagInfo(context, 'ID', widget.product.tagId ?? ''),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTagInfo(context, 'Status', 'ðŸŸ¢ Online'),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTagInfo(context, 'Ãšltima Sincronização', 
                    widget.product.ultimaAtualizacao != null 
                      ? _formatDateFromString(widget.product.ultimaAtualizacao!) 
                      : 'Não disponível'),
                ],
              ),
            ),
            SizedBox(height: AppSizes.formFieldSpacing.get(isMobile, isTablet)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.open_in_new_rounded, color: ThemeColors.of(context).surface),
                          const SizedBox(width: AppSpacing.md),
                          const Text('Abrindo detalhes da tag...'),
                        ],
                      ),
                      backgroundColor: ThemeColors.of(context).success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: const Text('Ver Detalhes da Tag'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.of(context).success,
                  foregroundColor: ThemeColors.of(context).surface,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.formButtonPaddingVerticalDense.get(isMobile, isTablet),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
                  ),
                ),
              ),
            ),
          ] else ...[
            SizedBox(height: AppSizes.formFieldSpacing.get(isMobile, isTablet)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.qr_code_scanner_rounded, color: ThemeColors.of(context).surface),
                          const SizedBox(width: AppSpacing.md),
                          const Text('Abrindo associação de tag...'),
                        ],
                      ),
                      backgroundColor: ThemeColors.of(context).warning,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.qr_code_scanner_rounded, size: 16),
                label: const Text('Associar Tag Agora'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.of(context).warning,
                  foregroundColor: ThemeColors.of(context).surface,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.formButtonPaddingVerticalDense.get(isMobile, isTablet),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateFromString(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return _formatDate(date);
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildTagInfo(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: _responsiveTextStyle(AppTextStyles.valueLabel.copyWith(
            color: ThemeColors.of(context).textSecondary,
            fontWeight: FontWeight.w500,
          )),
        ),
        Text(
          value,
          style: _responsiveTextStyle(AppTextStyles.valueText.copyWith(
            fontWeight: FontWeight.bold,
          )),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: isMobile ? AppRadius.card : (isTablet ? AppRadius.lg : AppRadius.xl),
        boxShadow: isMobile ? AppShadows.cardMobile : AppShadows.cardDesktop,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppSizes.productEditIconPadding.toEdgeInsetsAll(isMobile, isTablet),
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryHeader,
                  borderRadius: isMobile ? AppRadius.sm : AppRadius.sm,
                ),
                child: Icon(
                  Icons.info_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.productEditIconToTitle.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Informações Básicas',
                  style: _responsiveTextStyle(AppTextStyles.sectionTitle),
                ),
              ),
              if (_codigoValido && _nomeValido)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).successBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: ThemeColors.of(context).successIcon,
                    size: 16,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
          _buildTextField(context, controller: _codigoController,
            focusNode: _codigoFocusNode,
            label: 'Código de Barras',
            prefixIcon: Icons.qr_code_rounded,
            isValid: _codigoValido,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onSubmitted: () => _nomeFocusNode.requestFocus(),
          ),
          SizedBox(height: AppSizes.formButtonPaddingHorizontal.get(isMobile, isTablet)),
          _buildTextField(context, controller: _nomeController,
            focusNode: _nomeFocusNode,
            label: 'Nome do Produto',
            prefixIcon: Icons.inventory_2_rounded,
            isValid: _nomeValido,
            onSubmitted: () => _descricaoFocusNode.requestFocus(),
          ),
          SizedBox(height: AppSizes.formButtonPaddingHorizontal.get(isMobile, isTablet)),
          _buildTextField(context, controller: _descricaoController,
            focusNode: _descricaoFocusNode,
            label: 'Descrição (opcional)',
            prefixIcon: Icons.description_rounded,
            maxLines: 3,
            maxLength: 200,
            onSubmitted: () => _precoFocusNode.requestFocus(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, {
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData prefixIcon,
    bool isValid = true,
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    VoidCallback? onSubmitted,
  }) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final showValidation = controller.text.isNotEmpty && maxLength == null;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: _responsiveTextStyle(AppTextStyles.dropdownItem),
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => onSubmitted?.call(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: _responsiveTextStyle(AppTextStyles.fieldLabel),
        prefixIcon: Icon(
          prefixIcon,
          size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
          color: showValidation && isValid ? ThemeColors.of(context).success : null,
        ),
        suffixIcon: showValidation
            ? Icon(
                isValid ? Icons.check_circle_rounded : Icons.error_rounded,
                color: isValid ? ThemeColors.of(context).success : ThemeColors.of(context).error,
                size: 20,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
          borderSide: BorderSide(
            color: showValidation && isValid 
                ? ThemeColors.of(context).successLight 
                : ThemeColors.of(context).textSecondaryOverlay30,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
          borderSide: BorderSide(
            color: showValidation && isValid 
                ? ThemeColors.of(context).success 
                : ThemeColors.of(context).brandPrimaryGreen,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.productEditIconToTitle.get(isMobile, isTablet),
          vertical: AppSizes.productEditIconToTitle.get(isMobile, isTablet),
        ),
        isDense: true,
      ),
    );
  }

  Widget _buildPricingCard(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: isMobile ? AppRadius.card : (isTablet ? AppRadius.lg : AppRadius.xl),
        boxShadow: isMobile ? AppShadows.cardMobile : AppShadows.cardDesktop,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppSizes.productEditIconPadding.toEdgeInsetsAll(isMobile, isTablet),
                decoration: BoxDecoration(
                  gradient: ModuleGradients.precificacao,
                  borderRadius: isMobile ? AppRadius.sm : AppRadius.sm,
                ),
                child: Icon(
                  Icons.attach_money_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.productEditIconToTitle.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Precificação',
                  style: _responsiveTextStyle(AppTextStyles.sectionTitle),
                ),
              ),
              if (_precoValido)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).successBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: ThemeColors.of(context).successIcon,
                    size: 16,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
          Row(
            children: [
              Expanded(
                child: _buildTextField(context, controller: _precoController,
                  focusNode: _precoFocusNode,
                  label: 'Preço (R\$)',
                  prefixIcon: Icons.attach_money_rounded,
                  isValid: _precoValido,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: () => _precoKgFocusNode.requestFocus(),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildTextField(context, controller: _precoKgController,
                  focusNode: _precoKgFocusNode,
                  label: 'Preço/Kg (opcional)',
                  prefixIcon: Icons.monitor_weight_rounded,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: isMobile ? AppRadius.card : (isTablet ? AppRadius.lg : AppRadius.xl),
        boxShadow: isMobile ? AppShadows.cardMobile : AppShadows.cardDesktop,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppSizes.productEditIconPadding.toEdgeInsetsAll(isMobile, isTablet),
                decoration: BoxDecoration(
                  gradient: CategoryThemes.getTheme(_categoria).gradient,
                  borderRadius: isMobile ? AppRadius.sm : AppRadius.sm,
                ),
                child: Icon(
                  Icons.category_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.productEditIconToTitle.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Categoria e Status',
                  style: _responsiveTextStyle(AppTextStyles.sectionTitle),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
          
          // Dropdown de categoria
          DropdownButtonFormField<String>(
            initialValue: _categoria,
            style: _responsiveTextStyle(AppTextStyles.dropdownItem),
            decoration: InputDecoration(
              labelText: 'Categoria',
              labelStyle: _responsiveTextStyle(AppTextStyles.fieldLabel),
              prefixIcon: Icon(
                CategoryThemes.getTheme(_categoria).icon,
                color: CategoryThemes.getTheme(_categoria).color,
              ),
              border: OutlineInputBorder(
                borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.productEditInputPadding.get(isMobile, isTablet),
                vertical: AppSizes.productEditInputPadding.get(isMobile, isTablet),
              ),
            ),
            items: ['Bebidas', 'Mercearia', 'Perecíveis', 'Limpeza', 'Higiene']
                .map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Row(
                        children: [
                          Icon(
                            CategoryThemes.getTheme(cat).icon,
                            color: CategoryThemes.getTheme(cat).color,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(cat),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _categoria = value;
                  _alteracoesFeitas = true;
                });
              }
            },
          ),
          SizedBox(height: AppSizes.formButtonPaddingHorizontal.get(isMobile, isTablet)),
          
          // Dropdown de status
          DropdownButtonFormField<String>(
            initialValue: _status,
            style: _responsiveTextStyle(AppTextStyles.dropdownItem),
            decoration: InputDecoration(
              labelText: 'Status',
              labelStyle: _responsiveTextStyle(AppTextStyles.fieldLabel),
              prefixIcon: Icon(
                _status == 'Ativo' 
                    ? Icons.check_circle_rounded 
                    : Icons.cancel_rounded,
                color: _status == 'Ativo' 
                    ? ThemeColors.of(context).success 
                    : ThemeColors.of(context).error,
              ),
              border: OutlineInputBorder(
                borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.productEditInputPadding.get(isMobile, isTablet),
                vertical: AppSizes.productEditInputPadding.get(isMobile, isTablet),
              ),
            ),
            items: ['Ativo', 'Inativo']
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Row(
                        children: [
                          Icon(
                            status == 'Ativo' 
                                ? Icons.check_circle_rounded 
                                : Icons.cancel_rounded,
                            color: status == 'Ativo' 
                                ? ThemeColors.of(context).success 
                                : ThemeColors.of(context).error,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(status),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _status = value;
                  _alteracoesFeitas = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final historicoExibir = _expandirHistorico 
        ? _historicoPrecos 
        : _historicoPrecos.take(3).toList();

    return Container(
      padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: isMobile ? AppRadius.card : (isTablet ? AppRadius.lg : AppRadius.xl),
        boxShadow: isMobile ? AppShadows.cardMobile : AppShadows.cardDesktop,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppSizes.productEditIconPadding.toEdgeInsetsAll(isMobile, isTablet),
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryHeader,
                  borderRadius: isMobile ? AppRadius.sm : AppRadius.sm,
                ),
                child: Icon(
                  Icons.history_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.productEditIconToTitle.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Histórico de Preços',
                  style: _responsiveTextStyle(AppTextStyles.sectionTitle),
                ),
              ),
              if (_historicoPrecos.isNotEmpty)
                Text(
                  '${_historicoPrecos.length} alterações',
                  style: _responsiveTextStyle(AppTextStyles.caption.copyWith(
                    color: ThemeColors.of(context).textSecondary,
                  )),
                ),
            ],
          ),
          SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
          
          if (_historicoPrecos.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: AppSizes.iconHero.get(isMobile, isTablet),
                      color: ThemeColors.of(context).textSecondaryOverlay50,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Nenhum histórico disponível',
                      style: _responsiveTextStyle(AppTextStyles.body.copyWith(
                        color: ThemeColors.of(context).textSecondary,
                      )),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            ...historicoExibir.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == historicoExibir.length - 1;
              
              return Column(
                children: [
                  _buildHistoryItem(context, item),
                  if (!isLast) const Divider(height: 16),
                ],
              );
            }),
            if (_historicoPrecos.length > 3) ...[
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _expandirHistorico = !_expandirHistorico);
                  },
                  icon: Icon(
                    _expandirHistorico 
                        ? Icons.expand_less_rounded 
                        : Icons.expand_more_rounded,
                    size: 18,
                  ),
                  label: Text(
                    _expandirHistorico 
                        ? 'Ver Menos' 
                        : 'Ver Histórico Completo (${_historicoPrecos.length})',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.formButtonPaddingVertical.get(isMobile, isTablet),
                    ),
                    side: BorderSide(color: ThemeColors.of(context).borderLight),
                    shape: RoundedRectangleBorder(
                      borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, PriceHistoryItem item) {
    final isAumento = item.precoNovo > item.precoAnterior;
    
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDate(item.data),
                style: _responsiveTextStyle(AppTextStyles.tiny.copyWith(
                  fontWeight: FontWeight.w600,
                )),
              ),
              Text(
                item.usuario ?? 'Sistema',
                style: _responsiveTextStyle(AppTextStyles.tiny.copyWith(
                  color: ThemeColors.of(context).textSecondary,
                )),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'R\$ ${item.precoAnterior.toStringAsFixed(2)}',
                style: _responsiveTextStyle(AppTextStyles.tiny),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.arrow_forward_rounded, size: 12),
              ),
              Text(
                'R\$ ${item.precoNovo.toStringAsFixed(2)}',
                style: _responsiveTextStyle(AppTextStyles.tiny.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isAumento ? ThemeColors.of(context).warning : ThemeColors.of(context).brandPrimaryGreen,
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  if (_alteracoesFeitas) {
                    _onWillPop().then((shouldPop) {
                      if (shouldPop) Navigator.pop(context);
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.formButtonPaddingVertical.get(isMobile, isTablet),
                  ),
                  side: BorderSide(color: ThemeColors.of(context).borderLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: _responsiveTextStyle(AppTextStyles.buttonText.copyWith(
                    color: ThemeColors.of(context).textSecondary,
                  )),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _formularioValido && !_salvando ? _salvarProduto : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
                  foregroundColor: ThemeColors.of(context).surface,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.formButtonPaddingVertical.get(isMobile, isTablet),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
                  ),
                  disabledBackgroundColor: ThemeColors.of(context).textSecondaryOverlay30,
                ),
                child: _salvando
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
                        ),
                      )
                    : Text(
                        'Salvar Alterações',
                        style: _responsiveTextStyle(AppTextStyles.buttonText),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscardDialog(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.dialog,
      ),
      icon: const Icon(
        Icons.warning_rounded,
        color: ThemeColors.of(context).warning,
        size: 48,
      ),
      title: const Text('Descartar alterações?'),
      content: const Text(
        'Você tem alterações não salvas. Deseja descartar todas as alterações?',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Continuar Editando'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColors.of(context).error,
            foregroundColor: ThemeColors.of(context).surface,
          ),
          child: const Text('Descartar'),
        ),
      ],
    );
  }

  Future<void> _salvarProduto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      // TODO: Implementar salvamento via provider
      // final updatedProduct = widget.product.copyWith(
      //   codigo: _codigoController.text,
      //   nome: _nomeController.text,
      //   descricao: _descricaoController.text,
      //   preco: double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0,
      //   precoKg: _precoKgController.text.isNotEmpty 
      //       ? double.tryParse(_precoKgController.text.replaceAll(',', '.'))
      //       : null,
      //   categoria: _categoria,
      //   status: _status == 'Ativo' ? ProductStatus.ativo : ProductStatus.inativo,
      // );
      // await ref.read(productsListRiverpodProvider.notifier).updateProduct(updatedProduct);

      await Future.delayed(const Duration(seconds: 1)); // Simulação

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Produto atualizado!',
                      style: _responsiveTextStyle(AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    Text(
                      _nomeController.text,
                      style: _responsiveTextStyle(AppTextStyles.small),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: ThemeColors.of(context).success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar produto: $e'),
          backgroundColor: ThemeColors.of(context).error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  void _desassociarTag() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.dialog,
        ),
        icon: Icon(
          Icons.link_off_rounded,
          color: ThemeColors.of(context).warning,
          size: 48,
        ),
        title: const Text('Desassociar Tag?'),
        content: const Text(
          'O produto ficará sem uma tag associada e não será atualizado automaticamente.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar desassociação via provider
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Tag desassociada com sucesso!'),
                  backgroundColor: ThemeColors.of(context).warning,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).warning,
              foregroundColor: ThemeColors.of(context).surface,
            ),
            child: const Text('Desassociar'),
          ),
        ],
      ),
    );
  }
}


