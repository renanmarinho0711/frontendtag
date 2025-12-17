import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';

/// Estado de onboarding específico para produtos
/// Renomeado de OnboardingState para evitar conflito com tags
enum ProductOnboardingState {
  noProducts,
  noPrice,
  manyWithoutTag,
  none,
}

class ProductsOnboardingCard extends StatelessWidget {
  final ProductOnboardingState state;
  final int produtosSemPreco;
  final int produtosSemTag;
  final int totalProdutos;
  final VoidCallback onImportarPlanilha;
  final VoidCallback onAdicionarManual;
  final VoidCallback onEscanear;
  final VoidCallback onDefinirPrecos;
  final VoidCallback onVincularTags;
  final VoidCallback? onDismiss;

  const ProductsOnboardingCard({
    super.key,
    required this.state,
    this.produtosSemPreco = 0,
    this.produtosSemTag = 0,
    this.totalProdutos = 0,
    required this.onImportarPlanilha,
    required this.onAdicionarManual,
    required this.onEscanear,
    required this.onDefinirPrecos,
    required this.onVincularTags,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (state == ProductOnboardingState.none) {
      return const SizedBox.shrink();
    }

    final isMobile = ResponsiveHelper.isMobile(context);
    final config = _getConfig();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 16, tablet: 20, desktop: 24),
        vertical: 8,
      ),
      padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context, mobile: 16, tablet: 20, desktop: 24)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            config.color.withValues(alpha: 0.15),
            config.color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(color: config.color.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: config.color.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: config.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(config.icon, color: config.color, size: 28),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.title,
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: AppThemeColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      config.subtitle,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: AppThemeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: const Icon(Icons.close, color: AppThemeColors.textTertiary, size: 20),
                  onPressed: onDismiss,
                  tooltip: 'Não mostrar novamente',
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.dashboardSectionGap),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: config.actions.map((action) {
              return _buildActionButton(
                context,
                label: action.label,
                icon: action.icon,
                onTap: action.onTap,
                isPrimary: action.isPrimary,
                color: config.color,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  _OnboardingConfig _getConfig() {
    switch (state) {
      case ProductOnboardingState.noProducts:
        return _OnboardingConfig(
          icon: Icons.celebration_rounded,
          title: 'Comece seu catálogo!',
          subtitle: 'Escolha como adicionar seus primeiros produtos',
          color: AppThemeColors.brandPrimaryGreen,
          actions: [
            _ActionConfig('Importar Planilha', Icons.upload_file_rounded, onImportarPlanilha, true),
            _ActionConfig('Adicionar Manual', Icons.add_rounded, onAdicionarManual, false),
            _ActionConfig('Escanear Código', Icons.qr_code_scanner_rounded, onEscanear, false),
          ],
        );
      case ProductOnboardingState.noPrice:
        return _OnboardingConfig(
          icon: Icons.price_change_outlined,
          title: 'Produtos sem preço definido',
          subtitle: 'Você tem $produtosSemPreco produtos sem preço. Configure preços para exibir nas etiquetas.',
          color: AppThemeColors.orangeMain,
          actions: [
            _ActionConfig('Definir Preços Agora', Icons.attach_money_rounded, onDefinirPrecos, true),
            _ActionConfig('Fazer depois', Icons.schedule_rounded, onDismiss ?? () {}, false),
          ],
        );
      case ProductOnboardingState.manyWithoutTag:
        return _OnboardingConfig(
          icon: Icons.local_offer_rounded,
          title: 'Produtos aguardando tags',
          subtitle: '$produtosSemTag produtos aguardando vinculação. Vincule tags ESL para atualização automática.',
          color: AppThemeColors.blueMaterial,
          actions: [
            _ActionConfig('Vincular Tags', Icons.link_rounded, onVincularTags, true),
            _ActionConfig('Ver Produtos', Icons.visibility_rounded, () => onDefinirPrecos(), false),
          ],
        );
      case ProductOnboardingState.none:
        return _OnboardingConfig(
          icon: Icons.check_circle,
          title: '',
          subtitle: '',
          color: AppThemeColors.brandPrimaryGreen,
          actions: [],
        );
    }
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required bool isPrimary,
    required Color color,
  }) {
    final isMobile = ResponsiveHelper.isMobile(context);

    if (isPrimary) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppThemeColors.surface,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 20,
            vertical: isMobile ? 12 : 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.5)),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 20,
          vertical: isMobile ? 12 : 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _OnboardingConfig {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final List<_ActionConfig> actions;

  _OnboardingConfig({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.actions,
  });
}

class _ActionConfig {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  _ActionConfig(this.label, this.icon, this.onTap, this.isPrimary);
}

