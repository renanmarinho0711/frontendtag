import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';

/// Estado de onboarding espec�fico para produtos
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
            config.colorLight,
            config.colorLight,
          ],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(color: config.colorLight, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: config.colorLight,
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
                  color: config.colorLight,
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
                        color: ThemeColors.of(context).textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      config.subtitle,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: ThemeColors.of(context).textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).textTertiary, size: 20),
                  onPressed: onDismiss,
                  tooltip: 'N�o mostrar novamente',
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
          title: 'Comece seu cat�logo!',
          subtitle: 'Escolha como adicionar seus primeiros produtos',
          color: ThemeColors.of(context).brandPrimaryGreen,
          actions: [
            _ActionConfig('Importar Planilha', Icons.upload_file_rounded, onImportarPlanilha, true),
            _ActionConfig('Adicionar Manual', Icons.add_rounded, onAdicionarManual, false),
            _ActionConfig('Escanear C�digo', Icons.qr_code_scanner_rounded, onEscanear, false),
          ],
        );
      case ProductOnboardingState.noPrice:
        return _OnboardingConfig(
          icon: Icons.price_change_outlined,
          title: 'Produtos sem pre�o definido',
          subtitle: 'Voc� tem $produtosSemPreco produtos sem pre�o. Configure pre�os para exibir nas etiquetas.',
          color: ThemeColors.of(context).orangeMain,
          actions: [
            _ActionConfig('Definir Pre�os Agora', Icons.attach_money_rounded, onDefinirPrecos, true),
            _ActionConfig('Fazer depois', Icons.schedule_rounded, onDismiss ?? () {}, false),
          ],
        );
      case ProductOnboardingState.manyWithoutTag:
        return _OnboardingConfig(
          icon: Icons.local_offer_rounded,
          title: 'Produtos aguardando tags',
          subtitle: '$produtosSemTag produtos aguardando vincula��o. Vincule tags ESL para atualiza��o autom�tica.',
          color: ThemeColors.of(context).primary,
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
          color: ThemeColors.of(context).brandPrimaryGreen,
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
          foregroundColor: ThemeColors.of(context).surface,
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
        side: BorderSide(color: colorLight),
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







