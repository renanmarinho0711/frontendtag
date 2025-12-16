mport 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/features/products/presentation/providers/products_state_provider.dart';
import 'package:tagbean/core/enums/loading_status.dart';
import 'package:tagbean/features/products/data/models/product_models.dart';
import 'package:tagbean/features/products/presentation/widgets/qr/qr_widgets.dart';
import 'package:tagbean/features/products/presentation/widgets/barcode_scanner_widget.dart';
import 'package:tagbean/features/products/data/repositories/global_products_repository.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
import 'package:tagbean/features/products/presentation/screens/product_add_screen.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
/// Tela de Vincular Tags ESL com 3 abas conforme PROMOT PRODUTOS.txt:
/// - Tab 1: Escanear (c�mera para leitura de QR/NFC)
/// - Tab 2: Lista Pendentes (produtos sem tag vinculada)
/// - Tab 3: Vinculados (produtos com tag j� associada)
class ProdutosAssociarQRScreen extends ConsumerStatefulWidget {
  const ProdutosAssociarQRScreen({super.key});

  @override
  ConsumerState<ProdutosAssociarQRScreen> createState() => _ProdutosAssociarQRScreenState();
}

class _ProdutosAssociarQRScreenState extends ConsumerState<ProdutosAssociarQRScreen> 
    with TickerProviderStateMixin, ResponsiveCache {
  
  late TabController _tabController;
  late AnimationController _pulseController;
  late AnimationController _scanController;
  late AnimationController _successController;
  late Animation<double> _scaleAnimation;
  
  // Estado do binding
  TagBindingState get _bindingState => ref.watch(tagBindingProvider);
  TagBindingNotifier get _bindingNotifier => ref.read(tagBindingProvider.notifier);
  
  int get _step => _bindingState.currentStep;
  String? get _tagId => _bindingState.tagId;
  ProductModel? get _produto => _bindingState.product;
  bool get _scanning => _bindingState.isScanning;
  bool get _processando => _bindingState.status == LoadingStatus.loading;

  // Dados de produtos
  List<ProductModel> get _produtosPendentes {
    final state = ref.watch(productsListRiverpodProvider);
    return state.products.where((p) => !p.hasTag).toList();
  }
  
  List<ProductModel> get _produtosVinculados {
    final state = ref.watch(productsListRiverpodProvider);
    return state.products.where((p) => p.hasTag).toList();
  }

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 3, vsync: this);
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _scanController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _successController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pulseController.dispose();
    _scanController.dispose();
    _successController.dispose();
    super.dispose();
  }

  // ============================================================================
  // ACTIONS
  // ============================================================================

  /// Abre a c�mera para escanear c�digo de tag ESL
  Future<void> _abrirCameraTag() async {
    final codigo = await BarcodeScannerDialog.show(
      context,
      title: 'Escanear Tag ESL',
      subtitle: 'Aponte a c�mera para o QR Code da etiqueta',
      primaryColor: ThemeColors.of(context).blueMaterial,
    );
    
    if (codigo != null && codigo.isNotEmpty) {
      _processarCodigo(codigo, true);
    }
  }

  /// Abre a c�mera para escanear c�digo de barras do produto
  Future<void> _abrirCameraProduto() async {
    final codigo = await BarcodeScannerDialog.show(
      context,
      title: 'Escanear Produto',
      subtitle: 'Aponte a c�mera para o c�digo de barras do produto',
      primaryColor: ThemeColors.of(context).blueCyan,
    );
    
    if (codigo != null && codigo.isNotEmpty) {
      _processarCodigo(codigo, false);
    }
  }

  void _iniciarLeituraTag() {
    _inserirManualmente(true);
  }

  void _iniciarLeituraProduto() {
    _inserirManualmente(false);
  }

  void _inserirManualmente(bool isTag) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: (isTag ? ThemeColors.of(context).blueMaterial : ThemeColors.of(context).blueCyan).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isTag ? Icons.label_rounded : Icons.qr_code_2_rounded,
                color: isTag ? ThemeColors.of(context).blueMaterial : ThemeColors.of(context).blueCyan,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Text(isTag ? 'Inserir Tag' : 'Inserir C�digo'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: isTag ? 'MAC da tag (ex: AA:BB:CC:DD:EE:FF)' : 'C�digo de barras (EAN)',
                prefixIcon: Icon(isTag ? Icons.label_outline : Icons.qr_code_2_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Navigator.pop(context);
                  _processarCodigo(value, isTag);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context);
                _processarCodigo(controller.text, isTag);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isTag ? ThemeColors.of(context).blueMaterial : ThemeColors.of(context).blueCyan,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _processarCodigo(String codigo, bool isTag) {
    HapticFeedback.mediumImpact();
    
    if (isTag) {
      _bindingNotifier.setTagId(codigo, macAddress: codigo);
    } else {
      // Busca produto pelo c�digo na loja local primeiro
      final products = ref.read(productsListRiverpodProvider).products;
      final produto = products.firstWhere(
        (p) => p.codigo == codigo,
        orElse: () => ProductModel(
          id: '',
          codigo: codigo,
          nome: 'Produto n�o encontrado',
          preco: 0,
          categoria: '',
          status: ProductStatus.inativo,
        ),
      );
      
      if (produto.id.isNotEmpty) {
        _bindingNotifier.setProduct(produto);
      } else {
        // Produto n�o encontrado localmente - busca no cat�logo global
        _buscarNoCatalogoGlobal(codigo);
      }
    }
  }

  /// Busca produto no cat�logo global de produtos pelo c�digo de barras
  Future<void> _buscarNoCatalogoGlobal(String codigo) async {
    // Mostra loading
    _showLoading('Buscando produto no cat�logo global...');
    
    try {
      final repository = GlobalProductsRepository();
      final response = await repository.buscarPorBarcode(codigo);
      
      // Esconde loading
      if (mounted) Navigator.of(context).pop();
      
      response.when(
        success: (globalProduct) {
          if (globalProduct != null && globalProduct.found) {
            // Produto encontrado no cat�logo global - oferece importar
            _mostrarDialogoImportacao(globalProduct);
          } else {
            // N�o encontrado nem no cat�logo global
            _mostrarDialogoProdutoNaoEncontrado(codigo);
          }
        },
        error: (message, statusCode) {
          // Erro na busca ou produto n�o encontrado
          _mostrarDialogoProdutoNaoEncontrado(codigo);
        },
      );
      
      repository.dispose();
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      _mostrarDialogoProdutoNaoEncontrado(codigo);
    }
  }

  void _showLoading(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: AppSpacing.lg),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoImportacao(GlobalProduct globalProduct) {
    final precoController = TextEditingController(
      text: globalProduct.referencePrice?.toStringAsFixed(2) ?? '0.00',
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.check_rounded, color: ThemeColors.of(context).success),
            ),
            SizedBox(width: AppSpacing.md),
            const Expanded(child: Text('Produto Encontrado!')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem do produto (se dispon�vel)
              if (globalProduct.imageUrl != null && globalProduct.imageUrl!.isNotEmpty)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      globalProduct.imageUrl!,
                      height: 120,
                      width: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).grey200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.image_not_supported_rounded, size: 48, color: ThemeColors.of(context).grey500),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: AppSpacing.lg),
              
              // Nome
              Text(
                globalProduct.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: AppSpacing.sm),
              
              // C�digo
              Row(
                children: [
                  Icon(Icons.qr_code_rounded, size: 16, color: ThemeColors.of(context).grey500),
                  SizedBox(width: AppSpacing.xs),
                  Text(globalProduct.gtin, style: TextStyle(color: ThemeColors.of(context).grey600)),
                ],
              ),
              
              // Marca
              if (globalProduct.brand != null) ...[
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.business_rounded, size: 16, color: ThemeColors.of(context).grey500),
                    SizedBox(width: AppSpacing.xs),
                    Text(globalProduct.brand!, style: TextStyle(color: ThemeColors.of(context).grey600)),
                  ],
                ),
              ],
              
              // Categoria
              if (globalProduct.category != null) ...[
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.category_rounded, size: 16, color: ThemeColors.of(context).grey500),
                    SizedBox(width: AppSpacing.xs),
                    Text(globalProduct.category!, style: TextStyle(color: ThemeColors.of(context).grey600)),
                  ],
                ),
              ],
              
              const Divider(height: 24),
              
              // Campo de pre�o
              const Text('Defina o pre�o para sua loja:', style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: AppSpacing.sm),
              TextField(
                controller: precoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintText: '0,00',
                ),
              ),
              
              SizedBox(height: AppSpacing.md),
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ThemeColors.of(context).info.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 20, color: ThemeColors.of(context).info),
                    SizedBox(width: AppSpacing.sm),
                    const Expanded(
                      child: Text(
                        'Este produto ser� adicionado ao seu cat�logo local.',
                        style: TextStyle(fontSize: 12, color: ThemeColors.of(context).info),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              await _importarProdutoGlobal(globalProduct, double.tryParse(precoController.text.replaceAll(',', '.')) ?? 0);
            },
            icon: const Icon(Icons.add_shopping_cart_rounded),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
            ),
            label: const Text('Importar'),
          ),
        ],
      ),
    );
  }

  Future<void> _importarProdutoGlobal(GlobalProduct globalProduct, double preco) async {
    _showLoading('Importando produto...');
    
    try {
      // Obt�m storeId do contexto atual via provider
      final workContext = ref.read(currentWorkContextProvider);
      final storeId = workContext.currentStoreId ?? '';
      
      if (storeId.isEmpty) {
        if (mounted) Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro: Nenhuma loja selecionada'),
            backgroundColor: ThemeColors.of(context).redMain,
          ),
        );
        return;
      }
      
      final repository = GlobalProductsRepository();
      final response = await repository.importarParaLoja(
        globalProductId: globalProduct.id,
        storeId: storeId,
        preco: preco,
      );
      
      if (mounted) Navigator.of(context).pop();
      
      response.when(
        success: (result) {
          // Recarrega lista de produtos
          ref.read(productsListRiverpodProvider.notifier).loadProducts();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                  SizedBox(width: AppSpacing.md),
                  Expanded(child: Text('${globalProduct.name} importado com sucesso!')),
                ],
              ),
              backgroundColor: ThemeColors.of(context).success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        error: (message, statusCode) {
          _showError('Erro ao importar: $message');
        },
      );
      
      repository.dispose();
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      _showError('Erro ao importar produto: $e');
    }
  }

  void _mostrarDialogoProdutoNaoEncontrado(String codigo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).warning, size: 48),
        title: const Text('Produto n�o encontrado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'O c�digo "$codigo" n�o foi encontrado na sua loja nem no cat�logo global.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.lg),
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Deseja cadastrar um novo produto com este c�digo?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // Navega para tela de cadastro com c�digo pr�-preenchido
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProdutosAdicionarScreen(
                    initialProduct: ProductModel(
                      id: '',
                      codigo: codigo,
                      nome: '',
                      preco: 0,
                      categoria: '',
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add_rounded),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
            ),
            label: const Text('Cadastrar'),
          ),
        ],
      ),
    );
  }

  void _selecionarProduto(ProductModel produto) {
    HapticFeedback.selectionClick();
    _bindingNotifier.setProduct(produto);
    _tabController.animateTo(0); // Volta para aba de escanear
  }

  Future<void> _confirmarVinculacao() async {
    HapticFeedback.heavyImpact();
    
    final success = await _bindingNotifier.confirmBinding();
    
    if (success) {
      _successController.forward();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                SizedBox(width: AppSpacing.md),
                const Text('Vincula��o realizada com sucesso!'),
              ],
            ),
            backgroundColor: ThemeColors.of(context).success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      
      // Aguarda anima��o e reseta
      await Future.delayed(const Duration(milliseconds: 2000));
      _reset();
    } else {
      _showError(_bindingState.error ?? 'Erro ao vincular');
    }
  }

  void _reset() {
    _successController.reset();
    _bindingNotifier.reset();
  }

  Future<void> _desvincularTag(ProductModel produto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).warning, size: 48),
        title: const Text('Desvincular Tag?'),
        content: Text(
          'Deseja desvincular a tag do produto "${produto.nome}"?\n\nA tag ficar� dispon�vel para vincular a outro produto.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).warning,
              foregroundColor: ThemeColors.of(context).surface,
            ),
            child: const Text('Desvincular'),
          ),
        ],
      ),
    );
    
    if (confirmar == true && produto.tag != null) {
      final success = await _bindingNotifier.unbindTag(produto.tag!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success 
              ? 'Tag desvinculada com sucesso'
              : 'Erro ao desvincular tag'),
            backgroundColor: success ? ThemeColors.of(context).success : ThemeColors.of(context).error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        if (success) {
          // Recarrega lista de produtos
          ref.read(productsListRiverpodProvider.notifier).loadProducts(refresh: true);
        }
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
              SizedBox(width: AppSpacing.md),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: ThemeColors.of(context).error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ============================================================================
  // BUILD
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            _buildTabBar(context),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabEscanear(),
                  _buildTabPendentes(),
                  _buildTabVinculados(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: ModuleGradients.produto(context)s(context),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: ThemeColors.of(context).surface,
            style: IconButton.styleFrom(
              backgroundColor: ThemeColors.of(context).surfaceOverlay20,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Container(
            padding: EdgeInsets.all(AppSpacing.welcomeInnerSpacing),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay20,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.qr_code_scanner_rounded, color: ThemeColors.of(context).surface, size: 24),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vincular Tags',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                  ),
                ),
                Text(
                  'Associar etiquetas eletr�nicas',
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeColors.of(context).surfaceOverlay80,
                  ),
                ),
              ],
            ),
          ),
          // Stats
          _buildStatBadge(context, value: '${_produtosPendentes.length}',
            label: 'Pendentes',
            color: ThemeColors.of(context).warning,
          ),
          SizedBox(width: AppSpacing.sm),
          _buildStatBadge(context, value: '${_produtosVinculados.length}',
            label: 'Vinculados',
            color: ThemeColors.of(context).success,
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(BuildContext context, {required String value, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surfaceOverlay20,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).surface,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: ThemeColors.of(context).surfaceOverlay80,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).backgroundLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: ThemeColors.of(context).brandPrimaryGreen,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ThemeColors.of(context).surface,
        unselectedLabelColor: ThemeColors.of(context).textSecondary,
        labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
        dividerColor: ThemeColors.of(context).transparent,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.qr_code_scanner_rounded, size: 18),
                SizedBox(width: AppSpacing.xs),
                Text('Escanear'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pending_actions_rounded, size: 18),
                SizedBox(width: AppSpacing.xs),
                Text('Pendentes (${_produtosPendentes.length})'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.link_rounded, size: 18),
                SizedBox(width: AppSpacing.xs),
                Text('Vinculados (${_produtosVinculados.length})'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // TAB ESCANEAR
  // ============================================================================

  Widget _buildTabEscanear() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Indicador de progresso
          _buildProgressIndicator(context),
          SizedBox(height: AppSpacing.lg),
          // Conte�do baseado no passo atual
          if (_step == 1) _buildStepScanTag(context),
          if (_step == 2) _buildStepScanProduto(context),
          if (_step == 3 || _step == 4) _buildStepConfirmar(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).backgroundLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildProgressStep(context, 1, 'Tag', Icons.label_rounded, _step >= 1),
          Expanded(child: _buildProgressLine(context, _step >= 2)),
          _buildProgressStep(context, 2, 'Produto', Icons.inventory_2_rounded, _step >= 2),
          Expanded(child: _buildProgressLine(context, _step >= 3)),
          _buildProgressStep(context, 3, 'Confirmar', Icons.check_circle_rounded, _step >= 3),
        ],
      ),
    );
  }

  Widget _buildProgressStep(BuildContext context, int stepNum, String label, IconData icon, bool isActive) {
    final color = isActive ? ThemeColors.of(context).brandPrimaryGreen : ThemeColors.of(context).textTertiary;
    
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? color.withValues(alpha: 0.1) : ThemeColors.of(context).transparent,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: isActive ? 2 : 1),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(BuildContext context, bool isActive) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive ? ThemeColors.of(context).brandPrimaryGreen : ThemeColors.of(context).border,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildStepScanTag(BuildContext context) {
    return Column(
      children: [
        _buildStepHeader(context, title: 'Passo 1: Escanear Tag',
          subtitle: 'Escaneie o QR Code ou aproxime a tag NFC',
          icon: Icons.label_rounded,
          color: ThemeColors.of(context).blueMaterial,
        ),
        SizedBox(height: AppSpacing.lg),
        QrScanArea(
          isScanning: _scanning,
          hasCapture: _tagId != null,
          capturedValue: _tagId,
          label: 'Posicione a tag na �rea de leitura',
          primaryColor: ThemeColors.of(context).blueMaterial,
          pulseController: _pulseController,
          scanController: _scanController,
          onTapToScan: _iniciarLeituraTag,
          onManualInput: () => _inserirManualmente(true),
          onOpenCamera: _abrirCameraTag,
        ),
      ],
    );
  }

  Widget _buildStepScanProduto(BuildContext context) {
    return Column(
      children: [
        _buildStepHeader(context, title: 'Passo 2: Escanear Produto',
          subtitle: 'Escaneie o c�digo de barras do produto',
          icon: Icons.inventory_2_rounded,
          color: ThemeColors.of(context).blueCyan,
        ),
        SizedBox(height: AppSpacing.sm),
        // Badge da tag capturada
        _buildCapturedBadge(context, 'Tag', _tagId ?? '', ThemeColors.of(context).blueMaterial),
        SizedBox(height: AppSpacing.lg),
        QrScanArea(
          isScanning: _scanning,
          hasCapture: _produto != null,
          capturedValue: _produto?.nome,
          label: 'Posicione o c�digo de barras',
          primaryColor: ThemeColors.of(context).blueCyan,
          pulseController: _pulseController,
          scanController: _scanController,
          onTapToScan: _iniciarLeituraProduto,
          onManualInput: () => _inserirManualmente(false),
          onOpenCamera: _abrirCameraProduto,
        ),
        SizedBox(height: AppSpacing.lg),
        // Ou selecionar da lista
        OutlinedButton.icon(
          onPressed: () => _tabController.animateTo(1),
          icon: const Icon(Icons.list_rounded),
          label: const Text('Selecionar da lista de pendentes'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildStepConfirmar() {
    return BindingConfirmationCard(
      tagId: _tagId,
      produto: _produto,
      isProcessing: _processando,
      scaleAnimation: _scaleAnimation,
      onConfirm: _confirmarVinculacao,
      onCancel: _reset,
    );
  }

  Widget _buildStepHeader(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.welcomeInnerSpacing),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
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

  Widget _buildCapturedBadge(BuildContext context, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: color, size: 18),
          SizedBox(width: AppSpacing.sm),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // TAB PENDENTES
  // ============================================================================

  Widget _buildTabPendentes() {
    if (_produtosPendentes.isEmpty) {
      return ProductsEmptyState.pendentes();
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
      itemCount: _produtosPendentes.length,
      itemBuilder: (context, index) {
        final produto = _produtosPendentes[index];
        return ProductBindingCard(
          produto: produto,
          isPendente: true,
          onTap: () => _selecionarProduto(produto),
          onBindTag: () => _selecionarProduto(produto),
        );
      },
    );
  }

  // ============================================================================
  // TAB VINCULADOS
  // ============================================================================

  Widget _buildTabVinculados() {
    if (_produtosVinculados.isEmpty) {
      return ProductsEmptyState.vinculados(
        onScan: () => _tabController.animateTo(0),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
      itemCount: _produtosVinculados.length,
      itemBuilder: (context, index) {
        final produto = _produtosVinculados[index];
        return ProductBindingCard(
          produto: produto,
          isPendente: false,
          onUnbindTag: () => _desvincularTag(produto),
        );
      },
    );
  }
}








