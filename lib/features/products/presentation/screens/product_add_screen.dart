import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/enums/loading_status.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/design_system/theme/module_gradients.dart';
import 'package:tagbean/design_system/theme/category_themes.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/features/products/presentation/providers/products_state_provider.dart';
import 'package:tagbean/features/products/data/models/product_models.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
import 'package:tagbean/features/tags/presentation/screens/tags_batch_screen.dart';
import 'package:tagbean/features/categories/presentation/providers/categories_provider.dart';
import 'package:tagbean/features/categories/data/models/category_models.dart';

/// Tela de adio de novo produto com Wizard de 3 passos
/// Conforme PROMOT PRODUTOS.txt:
/// - Passo 1: Informaes Bsicas (Cdigo, Nome, Categoria, Descrio)
/// - Passo 2: Preo (Preo de venda, Preo por kg, Custo)
/// - Passo 3: Confirmar (Resumo + opo de vincular tag)
class ProdutosAdicionarScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  final ProductModel? initialProduct; // Para duplicao de produtos
  
  const ProdutosAdicionarScreen({super.key, this.onBack, this.initialProduct});

  @override
  ConsumerState<ProdutosAdicionarScreen> createState() => _ProdutosAdicionarScreenState();
}

class _ProdutosAdicionarScreenState extends ConsumerState<ProdutosAdicionarScreen> 
    with SingleTickerProviderStateMixin, ResponsiveCache {
  
  // Controllers
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  final _precoKgController = TextEditingController();
  final _custoController = TextEditingController();
  
  // Focus nodes para navegao
  final _codigoFocusNode = FocusNode();
  final _nomeFocusNode = FocusNode();
  final _descricaoFocusNode = FocusNode();
  final _precoFocusNode = FocusNode();
  final _precoKgFocusNode = FocusNode();
  final _custoFocusNode = FocusNode();
  
  // Estado do Wizard
  int _currentStep = 0;
  static const int _totalSteps = 3;
  
  // Estado
  String _categoria = 'Bebidas';
  bool _alteracoesFeitas = false;
  bool _salvando = false;
  bool _vincularTag = false;
  late AnimationController _animationController;
  late PageController _pageController;
  
  // Validao em tempo real
  bool _codigoValido = false;
  bool _nomeValido = false;
  bool _precoValido = false;
  final bool _categoriaValida = true;

  // Categorias carregadas do backend
  List<SuggestedCategoryModel> _categoriasCarregadas = [];
  bool _categoriasLoading = false;

  // Fallback de categorias caso o backend falhe
  List<String> get _categoriasFallback => ['Bebidas', 'Mercearia', 'Perecveis', 'Limpeza', 'Higiene'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
    
    _pageController = PageController();
    
    // Inicializa com dados do produto inicial (duplicao)
    if (widget.initialProduct != null) {
      final product = widget.initialProduct!;
      _codigoController.text = product.codigo;
      _nomeController.text = product.nome;
      _descricaoController.text = product.descricao ?? '';
      _precoController.text = product.preco.toStringAsFixed(2);
      _precoKgController.text = product.precoKg?.toStringAsFixed(2) ?? '';
      _categoria = product.categoria;
      _codigoValido = product.codigo.length >= 8;
      _nomeValido = product.nome.length >= 3;
      _precoValido = product.preco > 0;
    }
    
    // Listeners para detectar alteraes
    _codigoController.addListener(_onFormChanged);
    _nomeController.addListener(_onFormChanged);
    _precoController.addListener(_onFormChanged);
    _descricaoController.addListener(_onFormChanged);
    _precoKgController.addListener(_onFormChanged);
    _custoController.addListener(_onFormChanged);
    
    // Focus automtico no primeiro campo e carrega categorias aps build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _codigoFocusNode.requestFocus();
      // Carrega categorias do backend (adiado para evitar modificar provider durante build)
      _carregarCategorias();
    });
  }

  /// Carrega categorias do backend
  Future<void> _carregarCategorias() async {
    setState(() => _categoriasLoading = true);
    
    try {
      // Usa o provider para carregar categorias sugeridas
      await ref.read(suggestedCategoriesProvider.notifier).loadSuggestions();
      
      final suggestedState = ref.read(suggestedCategoriesProvider);
      
      if (suggestedState.status == LoadingStatus.success && 
          suggestedState.suggestions.isNotEmpty) {
        setState(() {
          _categoriasCarregadas = suggestedState.suggestions;
          // Se a categoria atual no existir nas carregadas, define a primeira
          final nomes = _categoriasCarregadas.map((c) => c.nome).toList();
          if (!nomes.contains(_categoria) && nomes.isNotEmpty) {
            _categoria = nomes.first;
          }
        });
      }
    } catch (e) {
      // Fallback silencioso - usa categorias padro do CategoryThemes
      debugPrint('Erro ao carregar categorias: $e');
    } finally {
      if (mounted) {
        setState(() => _categoriasLoading = false);
      }
    }
  }

  /// Constri os chips de categoria usando dados do backend ou fallback
  List<Widget> _buildCategoriaChips() {
    // Se tem categorias do backend, usa elas
    if (_categoriasCarregadas.isNotEmpty) {
      return _categoriasCarregadas.map((categoria) {
        final isSelected = _categoria == categoria.nome;
        final cor = categoria.cor;
        
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                categoria.iconData,
                size: 16,
                color: isSelected ? ThemeColors.of(context).surface : cor,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(categoria.nome),
            ],
          ),
          selected: isSelected,
          onSelected: (_) {
            setState(() {
              _categoria = categoria.nome;
              _alteracoesFeitas = true;
            });
          },
          selectedColor: cor,
          backgroundColor: corLight,
          labelStyle: TextStyle(
            color: isSelected ? ThemeColors.of(context).surface : cor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList();
    }
    
    // Fallback: usa categorias do CategoryThemes
    return _categoriasFallback.map((cat) {
      final theme = CategoryThemes.getTheme(cat);
      final isSelected = _categoria == cat;
      
      return ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              theme.icon,
              size: 16,
              color: isSelected ? ThemeColors.of(context).surface : theme.color,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(cat),
          ],
        ),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _categoria = cat;
            _alteracoesFeitas = true;
          });
        },
        selectedColor: theme.color,
        backgroundColor: theme.colorLight,
        labelStyle: TextStyle(
          color: isSelected ? ThemeColors.of(context).surface : theme.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    _codigoController.dispose();
    _nomeController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();
    _precoKgController.dispose();
    _custoController.dispose();
    _codigoFocusNode.dispose();
    _nomeFocusNode.dispose();
    _descricaoFocusNode.dispose();
    _precoFocusNode.dispose();
    _precoKgFocusNode.dispose();
    _custoFocusNode.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {
      _alteracoesFeitas = true;
      _codigoValido = _codigoController.text.length >= 8;
      _nomeValido = _nomeController.text.length >= 3;
      _precoValido = _precoController.text.isNotEmpty && 
                     double.tryParse(_precoController.text.replaceAll(',', '.')) != null &&
                     (double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0) > 0;
    });
  }

  bool get _step1Valid => _codigoValido && _nomeValido && _categoriaValida;
  bool get _step2Valid => _precoValido;
  bool get _formularioValido => _step1Valid && _step2Valid;

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      if (_currentStep == 0 && !_step1Valid) {
        _showValidationError('Complete todos os campos obrigatrios do Passo 1');
        return;
      }
      if (_currentStep == 1 && !_step2Valid) {
        _showValidationError('Informe um preo vlido maior que zero');
        return;
      }
      
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      
      if (_currentStep == 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _precoFocusNode.requestFocus();
        });
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ThemeColors.of(context).warning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_alteracoesFeitas) {
      if (widget.onBack != null) {
        widget.onBack!();
        return false;
      }
      return true;
    }
    
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => _buildDiscardDialog(),
    );
    
    if (shouldPop == true) {
      if (widget.onBack != null) {
        widget.onBack!();
        return false;
      }
      return true;
    }
    
    return false;
  }

  TextStyle _responsiveTextStyle(TextStyle base) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    return base.responsive(isMobile, isTablet);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return PopScope(
      canPop: !_alteracoesFeitas,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        if (!_alteracoesFeitas) {
          if (widget.onBack != null) {
            widget.onBack!();
          } else {
            Navigator.of(context).pop();
          }
          return;
        }
        
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => _buildDiscardDialog(),
        );
        
        if (shouldPop == true) {
          if (mounted) {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.of(context).pop();
            }
          }
        }
      },
      child: Scaffold(
        backgroundColor: ThemeColors.of(context).surface,
        body: SafeArea(
          child: Column(
            children: [
              _buildModernAppBar(),
              SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
              _buildProgressIndicator(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) {
                    setState(() {
                      _currentStep = page;
                    });
                  },
                  children: [
                    _buildStep1InformacoesBasicas(),
                    _buildStep2Preco(),
                    _buildStep3Confirmar(),
                  ],
                ),
              ),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
        vertical: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 16 : (isTablet ? 18 : 20)),
        boxShadow: isMobile ? AppShadows.softCard : AppShadows.cardDesktop,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).grey200,
              borderRadius: isMobile ? AppRadius.iconButtonLarge : AppRadius.md,
            ),
            child: IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: ThemeColors.of(context).textPrimary,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              onPressed: () async {
                if (_alteracoesFeitas) {
                  final shouldPop = await _onWillPop();
                  if (shouldPop && mounted) {
                    Navigator.of(context).pop();
                  }
                } else {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else {
                    Navigator.of(context).pop();
                  }
                }
              },
              tooltip: 'Cancelar',
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 12,
              tablet: 14,
              desktop: 16,
            ),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingSmAlt.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).success, ThemeColors.of(context).successEnd],
              ),
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
            ),
            child: Icon(
              Icons.add_box_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Novo Produto',
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeXl.get(isMobile, isTablet),
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                ),
                Text(
                  'Passo ${_currentStep + 1} de $_totalSteps',
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeXs.get(isMobile, isTablet),
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (_formularioValido && _currentStep == _totalSteps - 1)
            FilledButton.icon(
              onPressed: _salvando ? null : _salvarProduto,
              icon: _salvando
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
                      ),
                    )
                  : const Icon(Icons.check_rounded, size: 18),
              label: Text(_salvando ? 'Salvando...' : 'Salvar'),
              style: FilledButton.styleFrom(
                backgroundColor: ThemeColors.of(context).success,
                foregroundColor: ThemeColors.of(context).surface,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    final steps = ['Informaes', 'Preo', 'Confirmar'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingMd.get(isMobile, isTablet)),
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(_totalSteps * 2 - 1, (index) {
              if (index.isOdd) {
                final stepBefore = index ~/ 2;
                final isCompleted = stepBefore < _currentStep;
                return Expanded(
                  child: Container(
                    height: 3,
                    color: isCompleted 
                        ? ThemeColors.of(context).success 
                        : ThemeColors.of(context).grey200,
                  ),
                );
              } else {
                final stepIndex = index ~/ 2;
                final isActive = stepIndex == _currentStep;
                final isCompleted = stepIndex < _currentStep;
                
                return Container(
                  width: isActive ? 36 : 28,
                  height: isActive ? 36 : 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted 
                        ? ThemeColors.of(context).success 
                        : isActive 
                            ? ThemeColors.of(context).successLight
                            : ThemeColors.of(context).grey200,
                    border: isActive 
                        ? Border.all(color: ThemeColors.of(context).success, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 16)
                        : Text(
                            '${stepIndex + 1}',
                            style: TextStyle(
                              fontSize: isActive ? 14 : 12,
                              fontWeight: FontWeight.bold,
                              color: isActive 
                                  ? ThemeColors.of(context).success 
                                  : ThemeColors.of(context).textSecondary,
                            ),
                          ),
                  ),
                );
              }
            }),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: steps.asMap().entries.map((entry) {
              final isActive = entry.key == _currentStep;
              final isCompleted = entry.key < _currentStep;
              
              return Expanded(
                child: Text(
                  entry.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive || isCompleted ? FontWeight.w600 : FontWeight.normal,
                    color: isActive 
                        ? ThemeColors.of(context).success 
                        : isCompleted 
                            ? ThemeColors.of(context).success
                            : ThemeColors.of(context).textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1InformacoesBasicas() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ThemeColors.of(context).infoPastelLight,
                    ThemeColors.of(context).infoPastelLight,
                  ],
                ),
                borderRadius: AppRadius.card,
                border: Border.all(color: ThemeColors.of(context).blueMainLight),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).blueMain,
                          borderRadius: AppRadius.sm,
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: ThemeColors.of(context).surface,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Escanear Cdigo de Barras',
                              style: _responsiveTextStyle(AppTextStyles.sectionTitle),
                            ),
                            Text(
                              'Toque para abrir a cmera ou digite manualmente',
                              style: _responsiveTextStyle(AppTextStyles.caption.copyWith(
                                color: ThemeColors.of(context).textSecondary,
                              )),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _abrirScanner,
                        icon: const Icon(Icons.camera_alt_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: ThemeColors.of(context).blueMain,
                          foregroundColor: ThemeColors.of(context).surface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildTextField(
                    controller: _codigoController,
                    focusNode: _codigoFocusNode,
                    label: 'Cdigo de Barras *',
                    hint: 'Mnimo 8 dgitos',
                    prefixIcon: Icons.qr_code_rounded,
                    isValid: _codigoValido,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onSubmitted: () => _nomeFocusNode.requestFocus(),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: AppSizes.paddingLg.get(isMobile, isTablet)),
            
            Container(
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
                          gradient: AppGradients.primaryHeader(context),
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
                          'Informaes do Produto',
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
                  
                  _buildTextField(
                    controller: _nomeController,
                    focusNode: _nomeFocusNode,
                    label: 'Nome do Produto *',
                    hint: 'Mnimo 3 caracteres',
                    prefixIcon: Icons.inventory_2_rounded,
                    isValid: _nomeValido,
                    onSubmitted: () => _descricaoFocusNode.requestFocus(),
                  ),
                  
                  SizedBox(height: AppSizes.formButtonPaddingHorizontal.get(isMobile, isTablet)),
                  
                  Text(
                    'Categoria *',
                    style: _responsiveTextStyle(AppTextStyles.fieldLabel),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _categoriasLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: _buildCategoriaChips(),
                      ),
                  
                  SizedBox(height: AppSizes.formButtonPaddingHorizontal.get(isMobile, isTablet)),
                  
                  _buildTextField(
                    controller: _descricaoController,
                    focusNode: _descricaoFocusNode,
                    label: 'Descrio (opcional)',
                    hint: 'Descrio detalhada do produto',
                    prefixIcon: Icons.description_rounded,
                    maxLines: 3,
                    maxLength: 200,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2Preco() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      child: Column(
        children: [
          Container(
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
                        gradient: ModuleGradients.precificacao(context),
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
                        'Preo de Venda',
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
                
                _buildTextField(
                  controller: _precoController,
                  focusNode: _precoFocusNode,
                  label: 'Preo de Venda (R\$) *',
                  hint: 'Ex: 9,90',
                  prefixIcon: Icons.attach_money_rounded,
                  isValid: _precoValido,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: () => _precoKgFocusNode.requestFocus(),
                ),
                
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Este  o preo que ser exibido na etiqueta ESL',
                  style: _responsiveTextStyle(AppTextStyles.caption.copyWith(
                    color: ThemeColors.of(context).textSecondary,
                  )),
                ),
              ],
            ),
          ),
          
          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
          
          Container(
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
                        color: ThemeColors.of(context).grey200,
                        borderRadius: isMobile ? AppRadius.sm : AppRadius.sm,
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: ThemeColors.of(context).textSecondary,
                        size: AppSizes.iconSmall.get(isMobile, isTablet),
                      ),
                    ),
                    SizedBox(width: AppSizes.productEditIconToTitle.get(isMobile, isTablet)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preos Adicionais',
                            style: _responsiveTextStyle(AppTextStyles.sectionTitle),
                          ),
                          Text(
                            'Opcional',
                            style: _responsiveTextStyle(AppTextStyles.caption.copyWith(
                              color: ThemeColors.of(context).textSecondary,
                            )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.productEditSectionSpacing.get(isMobile, isTablet)),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _precoKgController,
                        focusNode: _precoKgFocusNode,
                        label: 'Preo por Kg (R\$)',
                        hint: 'Opcional',
                        prefixIcon: Icons.monitor_weight_rounded,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onSubmitted: () => _custoFocusNode.requestFocus(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildTextField(
                        controller: _custoController,
                        focusNode: _custoFocusNode,
                        label: 'Custo (R\$)',
                        hint: 'Opcional',
                        prefixIcon: Icons.receipt_long_rounded,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                if (_custoController.text.isNotEmpty && _precoController.text.isNotEmpty)
                  _buildMargemInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMargemInfo() {
    final preco = double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0;
    final custo = double.tryParse(_custoController.text.replaceAll(',', '.')) ?? 0;
    
    if (custo <= 0 || preco <= 0) return const SizedBox.shrink();
    
    final margem = ((preco - custo) / custo) * 100;
    final lucro = preco - custo;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: margem > 0 
            ? ThemeColors.of(context).successBackground 
            : ThemeColors.of(context).errorBackground,
        borderRadius: AppRadius.sm,
      ),
      child: Row(
        children: [
          Icon(
            margem > 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            color: margem > 0 ? ThemeColors.of(context).success : ThemeColors.of(context).error,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Margem de Lucro',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: margem > 0 ? ThemeColors.of(context).success : ThemeColors.of(context).error,
                  ),
                ),
                Text(
                  '${margem.toStringAsFixed(1)}% (R\$ ${lucro.toStringAsFixed(2)})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: margem > 0 ? ThemeColors.of(context).success : ThemeColors.of(context).error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3Confirmar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final categoryTheme = CategoryThemes.getTheme(_categoria);

    final preco = double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0;
    final precoKg = _precoKgController.text.isNotEmpty 
        ? double.tryParse(_precoKgController.text.replaceAll(',', '.'))
        : null;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      child: Column(
        children: [
          Container(
            padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  categoryTheme.colorLight,
                  categoryTheme.colorLight,
                ],
              ),
              borderRadius: isMobile ? AppRadius.card : (isTablet ? AppRadius.lg : AppRadius.xl),
              border: Border.all(color: categoryTheme.colorLight),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        gradient: categoryTheme.gradient,
                        borderRadius: AppRadius.md,
                        boxShadow: [
                          BoxShadow(
                            color: categoryTheme.colorLight,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        categoryTheme.icon,
                        color: ThemeColors.of(context).surface,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nomeController.text,
                            style: _responsiveTextStyle(AppTextStyles.sectionTitle.copyWith(
                              fontSize: 18,
                            )),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Icon(
                                categoryTheme.icon,
                                size: 14,
                                color: categoryTheme.color,
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                _categoria,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: categoryTheme.color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).success,
                        borderRadius: AppRadius.sm,
                      ),
                      child: Text(
                        'R\$ ${preco.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).surface,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.xl),
                const Divider(),
                const SizedBox(height: AppSpacing.lg),
                
                _buildResumoItem('Cdigo de Barras', _codigoController.text, Icons.qr_code_rounded),
                _buildResumoItem('Nome', _nomeController.text, Icons.inventory_2_rounded),
                _buildResumoItem('Categoria', _categoria, categoryTheme.icon),
                _buildResumoItem('Preo', 'R\$ ${preco.toStringAsFixed(2)}', Icons.attach_money_rounded),
                if (precoKg != null)
                  _buildResumoItem('Preo/Kg', 'R\$ ${precoKg.toStringAsFixed(2)}', Icons.monitor_weight_rounded),
                if (_descricaoController.text.isNotEmpty)
                  _buildResumoItem('Descrio', _descricaoController.text, Icons.description_rounded),
              ],
            ),
          ),
          
          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
          
          Container(
            padding: AppSizes.productEditCardPadding.toEdgeInsetsAll(isMobile, isTablet),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surface,
              borderRadius: AppRadius.card,
              boxShadow: AppShadows.subtle,
              border: Border.all(
                color: _vincularTag 
                    ? ThemeColors.of(context).successLight 
                    : ThemeColors.of(context).borderLight,
                width: _vincularTag ? 2 : 1,
              ),
            ),
            child: CheckboxListTile(
              value: _vincularTag,
              onChanged: (value) {
                setState(() {
                  _vincularTag = value ?? false;
                });
              },
              title: Text(
                'Vincular etiqueta ESL aps criar',
                style: _responsiveTextStyle(AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                )),
              ),
              subtitle: Text(
                'Abrir tela de vinculao de tags automaticamente',
                style: _responsiveTextStyle(AppTextStyles.caption.copyWith(
                  color: ThemeColors.of(context).textSecondary,
                )),
              ),
              secondary: Container(
                padding: EdgeInsets.all(AppSpacing.welcomeInnerSpacing),
                decoration: BoxDecoration(
                  color: _vincularTag 
                      ? ThemeColors.of(context).successLight
                      : ThemeColors.of(context).grey200,
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(
                  Icons.label_rounded,
                  color: _vincularTag 
                      ? ThemeColors.of(context).success 
                      : ThemeColors.of(context).textSecondary,
                ),
              ),
              activeColor: ThemeColors.of(context).success,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          
          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
          
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).infoPastel,
              borderRadius: AppRadius.sm,
              border: Border.all(color: ThemeColors.of(context).blueMainLight),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: ThemeColors.of(context).blueMain),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Revise os dados antes de salvar. Voc poder editar o produto posteriormente.',
                    style: TextStyle(
                      fontSize: 13,
                      color: ThemeColors.of(context).blueMainDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: ThemeColors.of(context).textSecondary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: ThemeColors.of(context).textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _previousStep,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Voltar'),
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
            )
          else
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final shouldPop = await _onWillPop();
                  if (shouldPop && mounted) {
                    Navigator.of(context).pop();
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
                child: const Text('Cancelar'),
              ),
            ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 2,
            child: _currentStep < _totalSteps - 1
                ? FilledButton.icon(
                    onPressed: _currentStep == 0 
                        ? (_step1Valid ? _nextStep : null)
                        : (_step2Valid ? _nextStep : null),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: const Text('Prximo'),
                    style: FilledButton.styleFrom(
                      backgroundColor: ThemeColors.of(context).success,
                      foregroundColor: ThemeColors.of(context).surface,
                      padding: EdgeInsets.symmetric(
                        vertical: AppSizes.formButtonPaddingVertical.get(isMobile, isTablet),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
                      ),
                      disabledBackgroundColor: ThemeColors.of(context).textSecondaryOverlay30,
                    ),
                  )
                : FilledButton.icon(
                    onPressed: _formularioValido && !_salvando ? _salvarProduto : null,
                    icon: _salvando
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
                            ),
                          )
                        : const Icon(Icons.check_rounded, size: 18),
                    label: Text(_salvando ? 'Salvando...' : 'Criar Produto'),
                    style: FilledButton.styleFrom(
                      backgroundColor: ThemeColors.of(context).success,
                      foregroundColor: ThemeColors.of(context).surface,
                      padding: EdgeInsets.symmetric(
                        vertical: AppSizes.formButtonPaddingVertical.get(isMobile, isTablet),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
                      ),
                      disabledBackgroundColor: ThemeColors.of(context).textSecondaryOverlay30,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    FocusNode? focusNode,
    required String label,
    String? hint,
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
        hintText: hint,
        labelStyle: _responsiveTextStyle(AppTextStyles.fieldLabel),
        hintStyle: _responsiveTextStyle(AppTextStyles.caption.copyWith(
          color: ThemeColors.of(context).textSecondaryOverlay50,
        )),
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
                : ThemeColors.of(context).success,
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

  Widget _buildDiscardDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.dialog,
      ),
      icon: const Icon(
        Icons.warning_rounded,
        color: ThemeColors.of(context).warning,
        size: 48,
      ),
      title: const Text('Descartar produto?'),
      content: const Text(
        'Voc tem dados no salvos. Deseja descartar todas as alteraes?',
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

  void _abrirScanner() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
              child: Text('Scanner de cdigo de barras em desenvolvimento. Digite o cdigo manualmente.'),
            ),
          ],
        ),
        backgroundColor: ThemeColors.of(context).blueMain,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _salvarProduto() async {
    if (!_formularioValido) return;

    final workContext = ref.read(currentWorkContextProvider);
    final storeId = workContext.currentStoreId;
    
    if (storeId == null || storeId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Nenhuma loja selecionada. Por favor, selecione uma loja primeiro.',
                  style: _responsiveTextStyle(AppTextStyles.body),
                ),
              ),
            ],
          ),
          backgroundColor: ThemeColors.of(context).error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _salvando = true);

    try {
      final preco = double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0;
      final precoKg = _precoKgController.text.isNotEmpty 
          ? double.tryParse(_precoKgController.text.replaceAll(',', '.'))
          : null;

      final newProduct = ProductModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nome: _nomeController.text,
        codigo: _codigoController.text,
        categoria: _categoria,
        preco: preco,
        precoKg: precoKg,
        descricao: _descricaoController.text.isNotEmpty ? _descricaoController.text : null,
        status: ProductStatus.ativo,
        cor: CategoryThemes.getTheme(_categoria).color,
        icone: CategoryThemes.getTheme(_categoria).icon,
      );

      final result = await ref.read(productsListRiverpodProvider.notifier).addProduct(
        newProduct,
        storeId: storeId,
      );
      
      if (!mounted) return;

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Produto criado!',
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
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        if (_vincularTag) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const EtiquetasOperacoesLoteScreen(),
            ),
          );
        } else {
          if (widget.onBack != null) {
            widget.onBack!();
          } else {
            Navigator.pop(context);
          }
        }
      } else {
        final errorState = ref.read(productsListRiverpodProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    errorState.error ?? 'Erro ao criar produto',
                    style: _responsiveTextStyle(AppTextStyles.body),
                  ),
                ),
              ],
            ),
            backgroundColor: ThemeColors.of(context).error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao criar produto: $e'),
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
}













