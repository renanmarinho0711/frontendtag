import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/products/presentation/screens/product_edit_screen.dart';
import 'package:tagbean/features/products/presentation/screens/product_qr_screen.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/products/data/models/product_models.dart';
import 'package:tagbean/features/products/presentation/providers/products_state_provider.dart';
import 'package:tagbean/core/enums/loading_status.dart';
import 'package:intl/intl.dart';

/// TELA 3: Detalhes do Produto
/// Implementação conforme PROMOT PRODUTOS.txt
/// Hero section, Quick actions, Tabs (Informações, Estoque, Histórico, Estratégias)
class ProdutosDetalhesScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProdutosDetalhesScreen({super.key, required this.product});

  @override
  ConsumerState<ProdutosDetalhesScreen> createState() => _ProdutosDetalhesScreenState();
}

class _ProdutosDetalhesScreenState extends ConsumerState<ProdutosDetalhesScreen> 
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Carrega detalhes do produto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productDetailsRiverpodProvider.notifier).loadFromProduct(widget.product);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ProductDetailsState get _detailsState => ref.watch(productDetailsRiverpodProvider);
  ProductDetails? get _details => _detailsState.details;
  ProductModel get _product => _details?.product ?? widget.product;
  bool get _isLoading => _detailsState.status == LoadingStatus.loading;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: AppThemeColors.backgroundLight,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // Header com botões Voltar, Editar e Menu
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: AppThemeColors.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppThemeColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // Botão Editar
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProdutosEditarScreen(product: _product),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_rounded, size: 18, color: AppThemeColors.brandPrimaryGreen),
                label: const Text(
                  'Editar',
                  style: TextStyle(
                    color: AppThemeColors.brandPrimaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Menu contextual
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, color: AppThemeColors.textPrimary),
                shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(Icons.copy_rounded, size: 18, color: AppThemeColors.textSecondary),
                        SizedBox(width: AppSpacing.sm),
                        Text('Duplicar Produto'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share_rounded, size: 18, color: AppThemeColors.textSecondary),
                        SizedBox(width: AppSpacing.sm),
                        Text('Compartilhar'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_rounded, size: 18, color: AppThemeColors.errorDark),
                        SizedBox(width: AppSpacing.sm),
                        Text('Excluir', style: TextStyle(color: AppThemeColors.errorDark)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) => _handleMenuAction(value),
              ),
            ],
          ),

          // Hero Section
          SliverToBoxAdapter(
            child: _buildHeroSection(isMobile, isTablet),
          ),

          // Quick Actions
          SliverToBoxAdapter(
            child: _buildQuickActions(isMobile, isTablet),
          ),

          // Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                indicatorColor: AppThemeColors.brandPrimaryGreen,
                labelColor: AppThemeColors.brandPrimaryGreen,
                unselectedLabelColor: AppThemeColors.textSecondary,
                labelStyle: TextStyle(
                  fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet),
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet),
                  fontWeight: FontWeight.normal,
                ),
                tabs: const [
                  Tab(text: 'Informações'),
                  Tab(text: 'Estoque'),
                  Tab(text: 'Histórico'),
                  Tab(text: 'Estratégias'),
                ],
              ),
            ),
          ),
        ],
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppThemeColors.brandPrimaryGreen))
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildTabInformacoes(isMobile, isTablet),
                  _buildTabEstoque(isMobile, isTablet),
                  _buildTabHistorico(isMobile, isTablet),
                  _buildTabEstrategias(isMobile, isTablet),
                ],
              ),
      ),
    );
  }

  // ========== HERO SECTION ==========
  Widget _buildHeroSection(bool isMobile, bool isTablet) {
    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      padding: EdgeInsets.all(AppSizes.paddingLg.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.mediumCard,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem do Produto
          Container(
            width: isMobile ? 100 : 120,
            height: isMobile ? 100 : 120,
            decoration: BoxDecoration(
              gradient: AppGradients.fromBaseColor(_product.cor),
              borderRadius: AppRadius.lg,
            ),
            child: _product.imagem != null && _product.imagem!.isNotEmpty
                ? ClipRRect(
                    borderRadius: AppRadius.lg,
                    child: Image.network(
                      _product.imagem!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        _product.icone,
                        color: AppThemeColors.surface,
                        size: isMobile ? 40 : 50,
                      ),
                    ),
                  )
                : Icon(
                    _product.icone,
                    color: AppThemeColors.surface,
                    size: isMobile ? 40 : 50,
                  ),
          ),
          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),

          // Informações Principais
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome
                Text(
                  _product.nome,
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeXlAlt2.get(isMobile, isTablet),
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSizes.paddingXs.get(isMobile, isTablet)),

                // Categoria
                Row(
                  children: [
                    Icon(Icons.category_rounded, size: 14, color: _product.cor),
                    const SizedBox(width: 4),
                    Text(
                      _product.categoria,
                      style: TextStyle(
                        fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet),
                        color: _product.cor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),

                // Preço e Tag Status
                Row(
                  children: [
                    // Preço
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                        vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        color: _product.cor.withValues(alpha: 0.1),
                        borderRadius: AppRadius.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'R\$ ${_product.preco.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: AppTextStyles.fontSizeXlAlt.get(isMobile, isTablet),
                              fontWeight: FontWeight.bold,
                              color: _product.cor,
                            ),
                          ),
                          if (_product.precoKg != null)
                            Text(
                              'R\$ ${_product.precoKg!.toStringAsFixed(2)}/kg',
                              style: TextStyle(
                                fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet),
                                color: AppThemeColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),

                    // Tag Status
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
                        decoration: BoxDecoration(
                          color: _product.hasTag
                              ? AppThemeColors.successLight
                              : AppThemeColors.warningPastel,
                          borderRadius: AppRadius.md,
                          border: Border.all(
                            color: _product.hasTag
                                ? AppThemeColors.success
                                : AppThemeColors.warningLight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _product.hasTag ? Icons.label_rounded : Icons.label_off_rounded,
                                  size: 16,
                                  color: _product.hasTag
                                      ? AppThemeColors.successIcon
                                      : AppThemeColors.warningDark,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _product.hasTag ? _product.tag ?? 'TAG-XXX' : 'Sem Tag',
                                  style: TextStyle(
                                    fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet),
                                    fontWeight: FontWeight.w600,
                                    color: _product.hasTag
                                        ? AppThemeColors.successIcon
                                        : AppThemeColors.warningDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  _product.hasTag ? Icons.check_circle_rounded : Icons.warning_rounded,
                                  size: 12,
                                  color: _product.hasTag
                                      ? AppThemeColors.successIcon
                                      : AppThemeColors.warningDark,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _product.hasTag ? 'Online' : 'Offline',
                                  style: TextStyle(
                                    fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet),
                                    color: _product.hasTag
                                        ? AppThemeColors.successIcon
                                        : AppThemeColors.warningDark,
                                  ),
                                ),
                              ],
                            ),
                            if (_product.hasTag) ...[
                              SizedBox(height: AppSizes.paddingXs.get(isMobile, isTablet)),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () => _showUnbindTagDialog(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    side: const BorderSide(color: AppThemeColors.orangeMain),
                                    foregroundColor: AppThemeColors.orangeMain,
                                  ),
                                  child: Text(
                                    'Desvincular',
                                    style: TextStyle(
                                      fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet),
                                    ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== QUICK ACTIONS ==========
  Widget _buildQuickActions(bool isMobile, bool isTablet) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.attach_money_rounded,
              label: 'Alterar\nPreço',
              color: AppThemeColors.blueMaterial,
              onTap: () => _showEditPriceDialog(),
              isMobile: isMobile,
              isTablet: isTablet,
            ),
          ),
          SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.inventory_rounded,
              label: 'Ajustar\nEstoque',
              color: AppThemeColors.blueMaterial,
              onTap: () => _tabController.animateTo(1), // Vai para tab Estoque
              isMobile: isMobile,
              isTablet: isTablet,
            ),
          ),
          SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.label_rounded,
              label: 'Gerenciar\nTag',
              color: AppThemeColors.brandPrimaryGreen,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProdutosAssociarQRScreen(),
                  ),
                );
              },
              isMobile: isMobile,
              isTablet: isTablet,
            ),
          ),
          SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.bar_chart_rounded,
              label: 'Ver\nVendas',
              color: AppThemeColors.orangeMain,
              onTap: () => _showVendasDialog(),
              isMobile: isMobile,
              isTablet: isTablet,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool isMobile,
    required bool isTablet,
  }) {
    return Material(
      color: AppThemeColors.surface,
      borderRadius: AppRadius.card,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.card,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: isMobile ? 20 : 24),
              ),
              SizedBox(height: AppSizes.paddingXs.get(isMobile, isTablet)),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet),
                  fontWeight: FontWeight.w600,
                  color: AppThemeColors.textPrimary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== TAB 1: INFORMAÇÕES ==========
  Widget _buildTabInformacoes(bool isMobile, bool isTablet) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: 'Dados Cadastrais',
            items: [
              _buildInfoItem('Código de Barras', _product.codigo, Icons.qr_code_rounded),
              _buildInfoItem('SKU', _product.codigo, Icons.inventory_2_rounded),
              _buildInfoItem('Categoria', _product.categoria, Icons.category_rounded),
              _buildInfoItem('Unidade', 'UN', Icons.straighten_rounded),
              _buildInfoItem('Peso', '2.0 kg', Icons.scale_rounded),
              _buildInfoItem('Dimensões', '15x15x30 cm', Icons.square_foot_rounded),
              _buildInfoItem('Fornecedor', 'Fornecedor Exemplo', Icons.store_rounded),
            ],
            isMobile: isMobile,
            isTablet: isTablet,
          ),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildInfoCard(
            title: 'Datas',
            items: [
              _buildInfoItem('Data Cadastro', '01/01/2025', Icons.event_rounded),
              _buildInfoItem('Última Atualização', DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()), Icons.update_rounded),
            ],
            isMobile: isMobile,
            isTablet: isTablet,
          ),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildInfoCard(
            title: 'Descrição',
            items: [
              Text(
                _product.descricao ?? 'Sem descrição disponível.',
                style: TextStyle(
                  fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
                  color: AppThemeColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
            isMobile: isMobile,
            isTablet: isTablet,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> items,
    required bool isMobile,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeLgAlt.get(isMobile, isTablet),
              fontWeight: FontWeight.bold,
              color: AppThemeColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          ...items,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppThemeColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppThemeColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: AppThemeColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== TAB 2: ESTOQUE ==========
  Widget _buildTabEstoque(bool isMobile, bool isTablet) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      child: Column(
        children: [
          // Quantidade Atual
          Container(
            padding: EdgeInsets.all(AppSizes.paddingLg.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              gradient: AppGradients.fromBaseColor(_product.cor),
              borderRadius: AppRadius.card,
            ),
            child: Column(
              children: [
                Text(
                  'Quantidade em Estoque',
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
                    color: AppThemeColors.surfaceOverlay90,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${_product.estoque ?? 0}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.isMobile(context) ? 32 : 48,
                    fontWeight: FontWeight.bold,
                    color: AppThemeColors.surface,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _showEstoqueDialog(isEntrada: true),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Entrada'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemeColors.surface,
                        foregroundColor: _product.cor,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    OutlinedButton.icon(
                      onPressed: () => _showEstoqueDialog(isEntrada: false),
                      icon: const Icon(Icons.remove_rounded),
                      label: const Text('Saída'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppThemeColors.surface,
                        side: const BorderSide(color: AppThemeColors.surface),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),

          // Estoque Mínimo
          Container(
            padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: AppThemeColors.surface,
              borderRadius: AppRadius.card,
              boxShadow: AppShadows.subtle,
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppThemeColors.warning),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estoque Mínimo',
                        style: TextStyle(
                          fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet),
                          color: AppThemeColors.textSecondary,
                        ),
                      ),
                      Text(
                        '10 unidades',
                        style: TextStyle(
                          fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
                          fontWeight: FontWeight.bold,
                          color: AppThemeColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Alterar'),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),

          // Gráfico de Movimentações (placeholder)
          Container(
            height: 200,
            padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: AppThemeColors.surface,
              borderRadius: AppRadius.card,
              boxShadow: AppShadows.subtle,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Movimentações (últimos 30 dias)',
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Gráfico de movimentações\n(a ser implementado)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppThemeColors.textSecondary),
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

  // ========== TAB 3: HISTÓRICO ==========
  Widget _buildTabHistorico(bool isMobile, bool isTablet) {
    final historicoPrecos = _details?.historicoPrecos ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Histórico de Alterações',
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeLgAlt.get(isMobile, isTablet),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),

          if (historicoPrecos.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.paddingXl.get(isMobile, isTablet)),
                child: Column(
                  children: [
                    const Icon(
                      Icons.history_rounded,
                      size: 64,
                      color: AppThemeColors.textSecondaryOverlay30,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Nenhuma alteração registrada',
                      style: TextStyle(
                        fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
                        color: AppThemeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historicoPrecos.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final item = historicoPrecos[index];
                return Container(
                  padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
                  decoration: BoxDecoration(
                    color: AppThemeColors.surface,
                    borderRadius: AppRadius.md,
                    boxShadow: AppShadows.subtle,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppThemeColors.brandPrimaryGreen.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.attach_money_rounded,
                          color: AppThemeColors.brandPrimaryGreen,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alteração de Preço',
                              style: TextStyle(
                                fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'R\$ ${item.precoAnterior.toStringAsFixed(2)} → R\$ ${item.precoNovo.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet),
                                color: AppThemeColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy').format(item.data),
                            style: TextStyle(
                              fontSize: AppTextStyles.fontSizeXxsAlt.get(isMobile, isTablet),
                              color: AppThemeColors.textSecondary,
                            ),
                          ),
                          Text(
                            DateFormat('HH:mm').format(item.data),
                            style: TextStyle(
                              fontSize: AppTextStyles.fontSizeXxsAlt.get(isMobile, isTablet),
                              color: AppThemeColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ========== TAB 4: ESTRATÉGIAS ==========
  Widget _buildTabEstrategias(bool isMobile, bool isTablet) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estratégias Ativas',
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeLgAlt.get(isMobile, isTablet),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),

          Center(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.paddingXl.get(isMobile, isTablet)),
              child: Column(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 64,
                    color: AppThemeColors.textSecondaryOverlay30,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Nenhuma estratégia ativa',
                    style: TextStyle(
                      fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
                      color: AppThemeColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Criar Estratégia'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemeColors.brandPrimaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== ACTIONS ==========
  void _handleMenuAction(String action) {
    switch (action) {
      case 'duplicate':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Duplicando produto...')),
        );
        break;
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compartilhando produto...')),
        );
        break;
      case 'delete':
        _showDeleteDialog();
        break;
    }
  }

  void _showUnbindTagDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desvincular Tag'),
        content: Text('Deseja remover a vinculação da tag "${_product.tag}" deste produto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tag desvinculada com sucesso')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppThemeColors.orangeMain),
            child: const Text('Desvincular'),
          ),
        ],
      ),
    );
  }

  void _showEditPriceDialog() {
    final controller = TextEditingController(text: _product.preco.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Preço'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Novo Preço',
            prefixText: 'R\$ ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preço atualizado com sucesso')),
              );
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showEstoqueDialog({required bool isEntrada}) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEntrada ? 'Entrada de Estoque' : 'Saída de Estoque'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Quantidade',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Estoque atualizado com sucesso')),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _showVendasDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Relatório de Vendas'),
        content: const Text('Funcionalidade em desenvolvimento.\n\nEm breve você poderá visualizar o histórico de vendas deste produto.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning_rounded, color: AppThemeColors.error, size: 48),
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir "${_product.nome}"?\n\nEsta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Volta para lista
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Produto excluído com sucesso'),
                  backgroundColor: AppThemeColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppThemeColors.error),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

// ========== SLIVER TAB BAR DELEGATE ==========
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppThemeColors.surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}


