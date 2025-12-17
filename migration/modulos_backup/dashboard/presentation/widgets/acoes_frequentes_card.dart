import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';

/// Card de ações frequentes baseado no uso real
/// Substitui QuickActionsCard com ações mais relevantes
class AcoesFrequentesCard extends ConsumerWidget {
  final VoidCallback onVincularTag;
  final VoidCallback onAtualizarPrecos;
  final VoidCallback onAdicionarProduto;
  final VoidCallback onVerRelatorio;
  
  const AcoesFrequentesCard({
    super.key,
    required this.onVincularTag,
    required this.onAtualizarPrecos,
    required this.onAdicionarProduto,
    required this.onVerRelatorio,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Obtém dados para badges dinâmicos
    final dashboardState = ref.watch(dashboardProvider);
    final storeStats = dashboardState.data.storeStats;
    // Produtos sem tag = total - vinculados (boundTagsCount representa quantas tags estão vinculadas)
    final produtosSemTag = storeStats.productsCount > storeStats.boundTagsCount 
        ? storeStats.productsCount - storeStats.boundTagsCount 
        : 0;
    // Produtos sem preço - busca nos alertas pelo type string
    final produtosSemPreco = dashboardState.data.alerts
        .where((a) => a.type.toLowerCase().contains('price') || 
                      a.type.toLowerCase().contains('preco') ||
                      a.type.toLowerCase().contains('preço'))
        .fold(0, (sum, a) => sum + a.count);

    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppThemeColors.orangeMain, AppThemeColors.orangeDark],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: AppThemeColors.surface,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ações Frequentes',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 16,
                            mobileFontSize: 14,
                            tabletFontSize: 15,
                          ),
                          fontWeight: FontWeight.bold,
                          color: AppThemeColors.textPrimary,
                        ),
                      ),
                      const Text(
                        'O que você mais faz',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppThemeColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
            
            // Ações em Grid (2x2) para mobile ou lista vertical para desktop
            if (isMobile)
              _buildMobileGrid(context, produtosSemTag, produtosSemPreco)
            else
              _buildDesktopList(context, isMobile, isTablet, produtosSemTag, produtosSemPreco),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileGrid(BuildContext context, int produtosSemTag, int produtosSemPreco) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildAcaoCompacta(
                  context: context,
                  icon: Icons.link_rounded,
                  label: 'Vincular Tag',
                  cor: AppThemeColors.greenMaterial,
                  badge: produtosSemTag > 0 ? produtosSemTag : null,
                  onTap: onVincularTag,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAcaoCompacta(
                  context: context,
                  icon: Icons.attach_money_rounded,
                  label: 'Preços',
                  cor: AppThemeColors.greenMain,
                  badge: produtosSemPreco > 0 ? produtosSemPreco : null,
                  onTap: onAtualizarPrecos,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildAcaoCompacta(
                  context: context,
                  icon: Icons.add_rounded,
                  label: 'Produto',
                  cor: AppThemeColors.blueMain,
                  onTap: onAdicionarProduto,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAcaoCompacta(
                  context: context,
                  icon: Icons.bar_chart_rounded,
                  label: 'Relatório',
                  cor: AppThemeColors.orangeMain,
                  onTap: onVerRelatorio,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopList(BuildContext context, bool isMobile, bool isTablet, int produtosSemTag, int produtosSemPreco) {
    return Column(
      children: [
        _buildAcaoHorizontal(
          context: context,
          icon: Icons.link_rounded,
          label: 'Vincular Tag a Produto',
          subtitle: 'Ação mais frequente',
          gradiente: [AppThemeColors.greenMaterial, AppThemeColors.greenDark],
          badge: produtosSemTag > 0 ? '$produtosSemTag sem tag' : null,
          onTap: onVincularTag,
          isMobile: isMobile,
          isTablet: isTablet,
        ),
        const SizedBox(height: 10),
        _buildAcaoHorizontal(
          context: context,
          icon: Icons.attach_money_rounded,
          label: 'Atualizar Preços',
          subtitle: 'Edição em lote',
          gradiente: [AppThemeColors.greenMain, AppThemeColors.greenDark],
          badge: produtosSemPreco > 0 ? '$produtosSemPreco pendentes' : null,
          onTap: onAtualizarPrecos,
          isMobile: isMobile,
          isTablet: isTablet,
        ),
        const SizedBox(height: 10),
        _buildAcaoHorizontal(
          context: context,
          icon: Icons.add_shopping_cart_rounded,
          label: 'Adicionar Produto',
          subtitle: 'Cadastrar novo item',
          gradiente: [AppThemeColors.blueMain, AppThemeColors.blueDark],
          onTap: onAdicionarProduto,
          isMobile: isMobile,
          isTablet: isTablet,
        ),
        const SizedBox(height: 10),
        _buildAcaoHorizontal(
          context: context,
          icon: Icons.bar_chart_rounded,
          label: 'Ver Relatório do Dia',
          subtitle: 'Resumo de vendas',
          gradiente: [AppThemeColors.orangeMain, AppThemeColors.orangeDark],
          onTap: onVerRelatorio,
          isMobile: isMobile,
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildAcaoCompacta({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color cor,
    required VoidCallback onTap,
    int? badge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cor.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cor, cor.withValues(alpha: 0.8)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppThemeColors.surface, size: 22),
                ),
                if (badge != null)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppThemeColors.redMain,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppThemeColors.surface, width: 2),
                      ),
                      child: Text(
                        badge > 99 ? '99+' : '$badge',
                        style: const TextStyle(
                          color: AppThemeColors.surface,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppThemeColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcaoHorizontal({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String subtitle,
    required List<Color> gradiente,
    required VoidCallback onTap,
    required bool isMobile,
    required bool isTablet,
    String? badge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              gradiente[0].withValues(alpha: 0.08),
              gradiente[1].withValues(alpha: 0.03),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: gradiente[0].withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradiente),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: gradiente[0].withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: AppThemeColors.surface, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppThemeColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppThemeColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppThemeColors.redMain.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppThemeColors.redMain.withValues(alpha: 0.3)),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppThemeColors.redMain,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppThemeColors.textSecondaryOverlay50,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

