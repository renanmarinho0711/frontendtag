import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/core/theme/app_typography.dart';
import 'package:tagbean/core/theme/app_spacing.dart';
import 'package:tagbean/core/theme/app_shadows.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';

/// # Card de Ações Frequentes
///
/// Widget que exibe as ações mais utilizadas pelo usuário no dashboard.
///
/// ## Layout Responsivo:
/// - **Mobile**: Grid 2x2 compacto
/// - **Tablet/Desktop**: Lista vertical com mais informações
///
/// ## Cores e Indicadores (Dinâmicas via ThemeColors):
/// - Verde (greenMaterial): Vincular tags e atualizar preços
///   - Usado como cor de fundo e gradiente dos ícones das ações relacionadas a tags/produtos.
/// - Azul (info): Adicionar produtos
///   - Usado como cor de fundo e gradiente do ícone de adicionar produto.
/// - Dourado (orangeMain): Ver relatórios
///   - Usado como cor de fundo e gradiente do ícone de relatório.
/// - Vermelho (error): Badges de pendências
///   - Usado para destacar badges de quantidade de pendências (produtos sem tag/preço).
///
/// ## Hierarquia Visual:
/// ```
/// ┌─────────────────────────────────────┐
/// │  🔗 Ações Frequentes                 │ ← Header com ícone gradient (orangeMain)
/// │  ─────────────────────────          │
/// │  ┌──────────┐ ┌──────────┐         │
/// │  │ 🔗 Tag   │ │ 💰 Preço │         │ ← Grid mobile (greenMaterial, success)
/// │  │    [5]   │ │    [3]   │         │   com badges (error)
/// │  └──────────┘ └──────────┘         │
/// │  ┌──────────┐ ┌──────────┐         │
/// │  │ ➕ Prod  │ │ 📊 Report│         │ ← (info, orangeMain)
/// │  └──────────┘ └──────────┘         │
/// └─────────────────────────────────────┘
/// ```
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
    final colors = ThemeColors.of(context);
    
    // Obtém dados para badges dinâmicos
    final dashboardState = ref.watch(dashboardProvider);
    final storeStats = dashboardState.data.storeStats;
    
    // Calcula pendências
    final produtosSemTag = storeStats.productsCount > storeStats.boundTagsCount 
        ? storeStats.productsCount - storeStats.boundTagsCount 
        : 0;
    
    final produtosSemPreco = dashboardState.data.alerts
        .where((a) => a.type.toLowerCase().contains('price') || 
                      a.type.toLowerCase().contains('preco') ||
                      a.type.toLowerCase().contains('preo'))
        .fold(0, (sum, a) => sum + a.count);
    
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Padding(
        padding: isMobile ? AppSpacing.paddingMd : AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com ícone e título
            _buildHeader(context),
            
            isMobile ? AppSpacing.gapVerticalMd : AppSpacing.gapVerticalLg,
            
            // Ações em Grid (mobile) ou Lista (desktop)
            if (isMobile)
              _buildMobileGrid(
                context: context,
                produtosSemTag: produtosSemTag,
                produtosSemPreco: produtosSemPreco,
              )
            else
              _buildDesktopList(
                context: context,
                isMobile: isMobile,
                isTablet: isTablet,
                produtosSemTag: produtosSemTag,
                produtosSemPreco: produtosSemPreco,
              ),
          ],
        ),
      ),
    );
  }

  /// Header do card com ícone gradiente e título
  Widget _buildHeader(BuildContext context) {
    final colors = ThemeColors.of(context);
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.orangeMain, colors.orangeDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: AppSpacing.borderRadiusSm,
            boxShadow: [
              BoxShadow(
                color: colors.orangeMainLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.bolt_rounded,
            color: colors.surface,
            size: 20,
          ),
        ),
        AppSpacing.gapHorizontalMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ações Frequentes',
                style: AppTypography.titleMedium(
                  color: colors.textPrimary,
                ),
              ),
              Text(
                'O que você mais faz',
                style: AppTypography.bodySmall(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Grid 2x2 para dispositivos móveis
  Widget _buildMobileGrid({
    required BuildContext context,
    required int produtosSemTag,
    required int produtosSemPreco,
  }) {
    final colors = ThemeColors.of(context);
    
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
                  corPrimaria: colors.greenMaterial,
                  badge: produtosSemTag > 0 ? produtosSemTag : null,
                  onTap: onVincularTag,
                ),
              ),
              AppSpacing.gapHorizontalSm,
              Expanded(
                child: _buildAcaoCompacta(
                  context: context,
                  icon: Icons.attach_money_rounded,
                  label: 'Preços',
                  corPrimaria: colors.success,
                  badge: produtosSemPreco > 0 ? produtosSemPreco : null,
                  onTap: onAtualizarPrecos,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapVerticalSm,
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildAcaoCompacta(
                  context: context,
                  icon: Icons.add_rounded,
                  label: 'Produto',
                  corPrimaria: colors.info,
                  onTap: onAdicionarProduto,
                ),
              ),
              AppSpacing.gapHorizontalSm,
              Expanded(
                child: _buildAcaoCompacta(
                  context: context,
                  icon: Icons.bar_chart_rounded,
                  label: 'Relatório',
                  corPrimaria: colors.orangeMain,
                  onTap: onVerrelatÃ³rio,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Lista vertical para desktop/tablet
  Widget _buildDesktopList({
    required BuildContext context,
    required bool isMobile,
    required bool isTablet,
    required int produtosSemTag,
    required int produtosSemPreco,
  }) {
    final colors = ThemeColors.of(context);
    
    return Column(
      children: [
        _buildAcaoHorizontal(
          context: context,
          icon: Icons.link_rounded,
          label: 'Vincular Tag a Produto',
          subtitle: 'Ação mais frequente',
          corPrimaria: colors.greenMaterial,
          corSecundaria: colors.greenDark,
          badge: produtosSemTag > 0 ? '$produtosSemTag sem tag' : null,
          onTap: onVincularTag,
        ),
        AppSpacing.gapVerticalSm,
        _buildAcaoHorizontal(
          context: context,
          icon: Icons.attach_money_rounded,
          label: 'Atualizar Preços',
          subtitle: 'Edição em lote',
          corPrimaria: colors.success,
          corSecundaria: colors.successDark,
          badge: produtosSemPreco > 0 ? '$produtosSemPreco pendentes' : null,
          onTap: onAtualizarPrecos,
        ),
        AppSpacing.gapVerticalSm,
        _buildAcaoHorizontal(
          context: context,
          icon: Icons.add_shopping_cart_rounded,
          label: 'Adicionar Produto',
          subtitle: 'Cadastrar novo item',
          corPrimaria: colors.info,
          corSecundaria: colors.infoDark,
          onTap: onAdicionarProduto,
        ),
        AppSpacing.gapVerticalSm,
        _buildAcaoHorizontal(
          context: context,
          icon: Icons.bar_chart_rounded,
          label: 'Ver Relatório do Dia',
          subtitle: 'Resumo de vendas',
          corPrimaria: colors.orangeMain,
          corSecundaria: colors.orangeDark,
          onTap: onVerrelatÃ³rio,
        ),
      ],
    );
  }

  /// Card compacto para ação (mobile)
  Widget _buildAcaoCompacta({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color corPrimaria,
    required VoidCallback onTap,
    int? badge,
  }) {
    final colors = ThemeColors.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusMd,
      child: Container(
        padding: AppSpacing.paddingSm,
        decoration: BoxDecoration(
          // Fundo sutil com cor transparente
          color: corPrimaria.withValues(alpha: 0.12),
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: corPrimariaLight,
            width: 1,
          ),
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
                      colors: [corPrimaria, corPrimariaDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppSpacing.borderRadiusSm,
                    boxShadow: [
                      BoxShadow(
                        color: corPrimariaLight,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: colors.surface,
                    size: 22,
                  ),
                ),
                // Badge de notificação
                if (badge != null)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: colors.error,
                        borderRadius: AppSpacing.borderRadiusFull,
                        border: Border.all(
                          color: colors.surface,
                          width: 2,
                        ),
                        boxShadow: AppShadows.shadowSm,
                      ),
                      child: Text(
                        badge > 99 ? '99+' : '$badge',
                        style: AppTypography.labelSmall(color: colors.surface),
                      ),
                    ),
                  ),
              ],
            ),
            AppSpacing.gapVerticalSm,
            Text(
              label,
              style: AppTypography.labelMedium(
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Card horizontal para ação (desktop/tablet)
  Widget _buildAcaoHorizontal({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String subtitle,
    required Color corPrimaria,
    required Color corSecundaria,
    required VoidCallback onTap,
    String? badge,
  }) {
    final colors = ThemeColors.of(context);
    final gradientColors = [corPrimaria, corSecundaria];
    
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusMd,
      child: Container(
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          // Gradiente sutil de fundo
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              gradientColors[0].withValues(alpha: 0.12),
              gradientColors[1]Light,
            ],
          ),
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: gradientColors[0]Light,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Ícone com gradiente
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppSpacing.borderRadiusSm,
                boxShadow: [
                  BoxShadow(
                    color: gradientColors[0]Light,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: colors.surface,
                size: 20,
              ),
            ),
            AppSpacing.gapHorizontalMd,
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTypography.titleSmall(
                      color: colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall(
                      color: colors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Badge de pendências
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.errorLight,
                  borderRadius: AppSpacing.borderRadiusFull,
                  border: Border.all(
                    color: colors.errorLight,
                    width: 1,
                  ),
                ),
                child: Text(
                  badge,
                  style: AppTypography.labelSmall(color: colors.error),
                ),
              ),
              AppSpacing.gapHorizontalSm,
            ],
            // Seta indicadora
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: colors.textSecondaryLight,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}





