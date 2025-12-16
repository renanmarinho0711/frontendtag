import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/design_system/theme/category_themes.dart';
import 'package:tagbean/design_system/theme/gradients.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/features/products/presentation/providers/products_state_provider.dart';
import 'package:tagbean/features/products/data/models/product_models.dart';

/// Tela de edio de produto
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
  
  // Validao
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
    
    // Validao inicial
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
      builder: (context) => _buildDiscardDialog(),
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
        backgroundColor: ThemeColors.of(context).background,
        body: SafeArea(
          child: Column(
            children: [
              _buildModernAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTagCard(),
                        SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
                        _buildInfoCard(),
                        SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
                        _buildPricingCard(),
                        SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
                        _buildCategoryCard(),
                        SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
                        _buildHistoryCard(),
                        SizedBox(height: AppSizes.productEditCardPadding.get(isMobile, isTablet)),
                      ],
                    ),
                  ),
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final productColor = widget.product.cor ?? ThemeColors.of(context).greenMaterial;

    return Container(
      margin: AppSizes.productEditSectionSpacing.toEdgeInsetsAll(isMobile, isTablet),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.productEditCardPadding.get(isMobile, isTablet),
        vertical: AppSizes.productEditSectionSpacing.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).textSecondary,
        borderRadius: isMobile ? AppRadius.card : (isTablet ? AppRadius.lg : AppRadius.xl),
        boxShadow: isMobile ? AppShadows.cardElevatedMobile : AppShadows.cardElevatedDesktop,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).grey700,
              borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textTertiary,
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
              color: ThemeColors.of(context).textSecondary,
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
                  style: _responsiveTextStyle(AppTextStyles.caption.copyWith(color: ThemeColors.of(context).textTertiary)),
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
                color: ThemeColors.of(context).yellow50,
                borderRadius: isMobile ? AppRadius.xs : AppRadius.sm,
                border: Border.all(color: ThemeColors.of(context).warningMain),
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

  Widget _buildTagCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final hasTag = widget.product.tagId != null;
    
    return Container(
      padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
      decoration: BoxDecoration(
        gradient: hasTag ? AppGradients.success(context) : AppGradients.alert(context),
        borderRadius: isMobile ? AppRadius.card : (isTablet ? AppRadius.appBarTablet : AppRadius.appBar),
        border: Border.all(
          color: hasTag ? ThemeColors.of(context).greenMaterial : ThemeColors.of(context).warningMain,
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
                  color: ThemeColors.of(context).textSecondary,
                  borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
                  boxShadow: hasTag ? AppShadows.successGlow : AppShadows.warningGlow,
                ),
                child: Icon(
                  hasTag ? Icons.label_rounded : Icons.label_off_rounded,
                  color: hasTag ? ThemeColors.of(context).greenMaterial : ThemeColors.of(context).warningMain,
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
                        color: hasTag ? ThemeColors.of(context).greenDark : ThemeColors.of(context).warningDark,
                      )),
                    ),
                    SizedBox(
                      height: AppSizes.productEditSmallSpacing.get(isMobile, isTablet),
                    ),
                    Text(
                      hasTag 
                          ? 'Este produto possui tag sincronizada'
                          : 'Este produto no possui tag associada',
                      style: _responsiveTextStyle(AppTextStyles.caption.copyWith(
                        color: ThemeColors.of(context).textTertiary,
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
                    side: BorderSide(color: ThemeColors.of(context).warningMain),
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
                color: ThemeColors.of(context).textSecondary,
                borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
              ),
              child: Column(
                children: [
                  _buildTagInfo('ID', widget.product.tagId ?? ''),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTagInfo('Status', '?? Online'),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTagInfo('�ltima Sincronizao', 
                    widget.product.ultimaAtualizacao != null 
                      ? _formatDateFromString(widget.product.ultimaAtualizacao!) 
                      : 'No disponvel'),
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
                          Icon(Icons.open_in_new_rounded, color: ThemeColors.of(context).textSecondary),
                          SizedBox(width: AppSpacing.md),
                          Text('Abrindo detalhes da tag...'),
                        ],
                      ),
                      backgroundColor: ThemeColors.of(context).greenMaterial,
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
                  backgroundColor: ThemeColors.of(context).greenMaterial,
                  foregroundColor: ThemeColors.of(context).textSecondary,
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
                          Icon(Icons.qr_code_scanner_rounded, color: ThemeColors.of(context).textSecondary),
                          const SizedBox(width: AppSpacing.md),
                          const Text('Abrindo associao de tag...'),
                        ],
                      ),
                      backgroundColor: ThemeColors.of(context).warningMain,
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
                  backgroundColor: ThemeColors.of(context).warningMain,
                  foregroundColor: ThemeColors.of(context).textSecondary,
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

  Widget _buildTagInfo(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: _responsiveTextStyle(AppTextStyles.valueLabel.copyWith(
            color: ThemeColors.of(context).textTertiary,
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

  Widget _buildInfoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).textSecondary,
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
                  gradient: AppGradients.primaryHeader(context),
                  borderRadius: isMobile ? AppRadius.sm : AppRadius.sm,
                ),
                child: Icon(
                  Icons.info_rounded,
                  color: ThemeColors.of(context).textSecondary,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.productEditIconToTitle.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Informaes Bsicas',
                  style: _responsiveTextStyle(AppTextStyles.sectionTitle),
                ),
              ),
              if (_codigoValido && _nomeValido)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).greenSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: ThemeColors.of(context).greenSuccess,
                    size: 16,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
          _buildTextField(
            controller: _codigoController,
            focusNode: _codigoFocusNode,
            label: 'Cdigo de Barras',
            prefixIcon: Icons.qr_code_rounded,
            isValid: _codigoValido,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onSubmitted: () => _nomeFocusNode.requestFocus(),
          ),
          SizedBox(height: AppSizes.formButtonPaddingHorizontal.get(isMobile, isTablet)),
          _buildTextField(
            controller: _nomeController,
            focusNode: _nomeFocusNode,
            label: 'Nome do Produto',
            prefixIcon: Icons.inventory_2_rounded,
            isValid: _nomeValido,
            onSubmitted: () => _descricaoFocusNode.requestFocus(),
          ),
          SizedBox(height: AppSizes.formButtonPaddingHorizontal.get(isMobile, isTablet)),
          _buildTextField(
            controller: _descricaoController,
            focusNode: _descricaoFocusNode,
            label: 'Descrio (opcional)',
            prefixIcon: Icons.description_rounded,
            maxLines: 3,
            maxLength: 200,
            onSubmitted: () => _precoFocusNode.requestFocus(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
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
          color: showValidation && isValid ? ThemeColors.of(context).greenMaterial : null,
        ),
        suffixIcon: showValidation
            ? Icon(
                isValid ? Icons.check_circle_rounded : Icons.error_rounded,
                color: isValid ? ThemeColors.of(context).greenMaterial : ThemeColors.of(context).errorMain,
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
                ? ThemeColors.of(context).greenLight
                : ThemeColors.of(context).textTertiary.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
          borderSide: BorderSide(
            color: showValidation && isValid 
                ? ThemeColors.of(context).greenMaterial
                : ThemeColors.of(context).greenMaterial,
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

  Widget _buildPricingCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).textSecondary,
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
                  gradient: ModuleGradients.precificacao(context),
                  borderRadius: isMobile ? AppRadius.sm : AppRadius.sm,
                ),
                child: Icon(
                  Icons.attach_money_rounded,
                  color: ThemeColors.of(context).textSecondary,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.productEditIconToTitle.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Precificao',
                  style: _responsiveTextStyle(AppTextStyles.sectionTitle),
                ),
              ),
              if (_precoValido)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).greenSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: ThemeColors.of(context).greenSuccess,
                    size: 16,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _precoController,
                  focusNode: _precoFocusNode,
                  label: 'Preo (R\$)',
                  prefixIcon: Icons.attach_money_rounded,
                  isValid: _precoValido,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: () => _precoKgFocusNode.requestFocus(),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildTextField(
                  controller: _precoKgController,
                  focusNode: _precoKgFocusNode,
                  label: 'Preo/Kg (opcional)',
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

  Widget _buildCategoryCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).textSecondary,
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
                  color: ThemeColors.of(context).textSecondary,
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
            value: _categoria,
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
            items: ['Bebidas', 'Mercearia', 'Perecveis', 'Limpeza', 'Higiene']
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
            value: _status,
            style: _responsiveTextStyle(AppTextStyles.dropdownItem),
            decoration: InputDecoration(
              labelText: 'Status',
              labelStyle: _responsiveTextStyle(AppTextStyles.fieldLabel),
              prefixIcon: Icon(
                _status == 'Ativo' 
                    ? Icons.check_circle_rounded 
                    : Icons.cancel_rounded,
                color: _status == 'Ativo' 
                    ? ThemeColors.of(context).greenMaterial
                    : ThemeColors.of(context).errorMain,
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
                                ? ThemeColors.of(context).greenMaterial
                                : ThemeColors.of(context).errorMain,
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

  Widget _buildHistoryCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final historicoExibir = _expandirHistorico 
        ? _historicoPrecos 
        : _historicoPrecos.take(3).toList();

    return Container(
      padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).textSecondary,
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
                  gradient: AppGradients.primaryHeader(context),
                  borderRadius: isMobile ? AppRadius.sm : AppRadius.sm,
                ),
                child: Icon(
                  Icons.history_rounded,
                  color: ThemeColors.of(context).textSecondary,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.productEditIconToTitle.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Histrico de Preos',
                  style: _responsiveTextStyle(AppTextStyles.sectionTitle),
                ),
              ),
              if (_historicoPrecos.isNotEmpty)
                Text(
                  '${_historicoPrecos.length} alteraes',
                  style: _responsiveTextStyle(AppTextStyles.caption.copyWith(
                    color: ThemeColors.of(context).textTertiary,
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
                      color: ThemeColors.of(context).textTertiary.withOpacity(0.8),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Nenhum histrico disponvel',
                      style: _responsiveTextStyle(AppTextStyles.body.copyWith(
                        color: ThemeColors.of(context).textTertiary,
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
                  _buildHistoryItem(item),
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
                        : 'Ver Histrico Completo (${_historicoPrecos.length})',
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

  Widget _buildHistoryItem(PriceHistoryItem item) {
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
                  color: ThemeColors.of(context).textTertiary,
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
                  color: isAumento ? ThemeColors.of(context).warningMain : ThemeColors.of(context).greenMaterial,
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).textSecondary,
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).shadowDark,
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
                    color: ThemeColors.of(context).textTertiary,
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
                  backgroundColor: ThemeColors.of(context).greenMaterial,
                  foregroundColor: ThemeColors.of(context).textSecondary,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.formButtonPaddingVertical.get(isMobile, isTablet),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
                  ),
                  disabledBackgroundColor: ThemeColors.of(context).textTertiary.withOpacity(0.3),
                ),
                child: _salvando
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).textSecondary),
                        ),
                      )
                    : Text(
                        'Salvar Alteraes',
                        style: _responsiveTextStyle(AppTextStyles.buttonText),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscardDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.dialog,
      ),
      icon: Icon(
        Icons.warning_rounded,
        color: ThemeColors.of(context).warningMain,
        size: 48,
      ),
      title: const Text('Descartar alteraes?'),
      content: const Text(
        'Voc tem alteraes no salvas. Deseja descartar todas as alteraes?',
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
            backgroundColor: ThemeColors.of(context).errorMain,
            foregroundColor: ThemeColors.of(context).textSecondary,
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

      await Future.delayed(const Duration(seconds: 1)); // Simulao

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_rounded, color: ThemeColors.of(context).textSecondary),
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
          backgroundColor: ThemeColors.of(context).greenMaterial,
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
          backgroundColor: ThemeColors.of(context).errorMain,
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
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.dialog,
        ),
        icon: Icon(
          Icons.link_off_rounded,
          color: ThemeColors.of(context).warningMain,
          size: 48,
        ),
        title: const Text('Desassociar Tag?'),
        content: const Text(
          'O produto ficar sem uma tag associada e no ser atualizado automaticamente.',
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
              // TODO: Implementar desassociao via provider
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Tag desassociada com sucesso!'),
                  backgroundColor: ThemeColors.of(context).warningMain,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).warningMain,
              foregroundColor: ThemeColors.of(context).textSecondary,
            ),
            child: const Text('Desassociar'),
          ),
        ],
      ),
    );
  }
}









