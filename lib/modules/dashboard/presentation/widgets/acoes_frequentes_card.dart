import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
/// Card de a��es frequentes baseado no uso real
/// Substitui QuickActionsCard com a��es mais relevantes
class AcoesFrequentesCard extends ConsumerWidget {
  final VoidCallback onVincularTag;
  final VoidCallback onAtualizarPrecos;
  final VoidCallback onAdicionarProduto;
  final VoidCallback onVerrelatÃ³rio;
  
  const AcoesFrequentesCard({
    super.key,
    required this.onVincularTag,
    required this.onAtualizarPrecos,
    required this.onAdicionarProduto,
    required this.onVerrelatÃ³rio,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Obt�m dados para badges din�micos
    final dashboardState = ref.watch(dashboardProvider);
    final storeStats = dashboardState.data.storeStats;
    // Produtos sem tag = total - vinculados (boundTagsCount representa quantas tags est�o vinculadas)
    final produtosSemTag = storeStats.productsCount > storeStats.boundTagsCount 
        ? storeStats.productsCount - storeStats.boundTagsCount 
        : 0;
    // Produtos sem pre�o - busca nos alertas pelo type string
    final produtosSemPreco = dashboardState.data.alerts
        .where((a) => a.type.toLowerCase().contains('price') || 
                      a.type.toLowerCase().contains('preco') ||
                      a.type.toLowerCase().contains('pre�o'))
        .fold(0, (sum, a) => sum + a.count);

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
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
                    gradient: LinearGradient(
                      colors: [ThemeColors.of(context).orangeMain, ThemeColors.of(context).orangeDark],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.bolt_rounded,
                    color: ThemeColors.of(context).surface,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'A��es Frequentes',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 16,
                            mobileFontSize: 14,
                            tabletFontSize: 15,
                          ),
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).textPrimary,
                        ),
                      ),
                      Text(
                        'O que voc� mais faz',
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
            
            // A��es em Grid (2x2) para mobile ou lista vertical para desktop
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
                  cor: ThemeColors.of(context).greenMaterial,
                  badge: produtosSemTag > 0 ? produtosSemTag : null,
                  onTap: onVincularTag,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAcaoCompacta(
                  context: context,
                  icon: Icons.attach_money_rounded,
                  label: 'Pre�os',
                  cor: ThemeColors.of(context).greenMain,
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
                  cor: ThemeColors.of(context).blueMain,
                  onTap: onAdicionarProduto,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAcaoCompacta(
                  context: context,
                  icon: Icons.bar_chart_rounded,
                  label: 'Relat�rio',
                  cor: ThemeColors.of(context).orangeMain,
                  onTap: onVerrelatÃ³rio,
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
          subtitle: 'A��o mais frequente',
          gradiente: [ThemeColors.of(context).greenMaterial, ThemeColors.of(context).greenDark],
          badge: produtosSemTag > 0 ? '$produtosSemTag sem tag' : null,
          onTap: onVincularTag,
          isMobile: isMobile,
          isTablet: isTablet,
        ),
        const SizedBox(height: 10),
        _buildAcaoHorizontal(
          context: context,
          icon: Icons.attach_money_rounded,
          label: 'Atualizar Pre�os',
          subtitle: 'Edi��o em lote',
          gradiente: [ThemeColors.of(context).greenMain, ThemeColors.of(context).greenDark],
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
          gradiente: [ThemeColors.of(context).blueMain, ThemeColors.of(context).blueDark],
          onTap: onAdicionarProduto,
          isMobile: isMobile,
          isTablet: isTablet,
        ),
        const SizedBox(height: 10),
        _buildAcaoHorizontal(
          context: context,
          icon: Icons.bar_chart_rounded,
          label: 'Ver Relat�rio do Dia',
          subtitle: 'Resumo de vendas',
          gradiente: [ThemeColors.of(context).orangeMain, ThemeColors.of(context).orangeDark],
          onTap: onVerrelatÃ³rio,
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
                  child: Icon(icon, color: ThemeColors.of(context).surface, size: 22),
                ),
                if (badge != null)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).redMain,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ThemeColors.of(context).surface, width: 2),
                      ),
                      child: Text(
                        badge > 99 ? '99+' : '$badge',
                        style: TextStyle(
                          color: ThemeColors.of(context).surface,
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
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ThemeColors.of(context).textPrimary,
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
              child: Icon(icon, color: ThemeColors.of(context).surface, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.of(context).textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: ThemeColors.of(context).textSecondary,
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
                  color: ThemeColors.of(context).redMain.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ThemeColors.of(context).redMain.withValues(alpha: 0.3)),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.of(context).redMain,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: ThemeColors.of(context).textSecondaryOverlay50,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}




