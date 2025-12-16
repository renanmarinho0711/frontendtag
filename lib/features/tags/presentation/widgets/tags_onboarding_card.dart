import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Estados poss?veis do onboarding - compat?vel com tags_dashboard_screen.dart
enum TagOnboardingState {
  none,             // Tudo OK - n?o mostrar
  noTags,           // Sem tags cadastradas
  manyUnbound,      // >30% sem v?nculo
  manyOffline,      // >10% offline
  lowBattery,       // Muitas com bateria baixa (extens?o do dashboard)
}

/// Card de onboarding contextual para o m?dulo Tags
/// Exibe mensagens e a??es baseadas no estado atual das tags
class TagsOnboardingCard extends ConsumerWidget {
  final TagOnboardingState state;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final VoidCallback? onDismiss;

  const TagsOnboardingCard({
    super.key,
    required this.state,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state == TagOnboardingState.none) {
      return const SizedBox.shrink();
    }

    final isMobile = ResponsiveHelper.isMobile(context);
    final config = _getConfig(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: config.gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: config.gradientColors.firstLight,
            blurRadius: 12,
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  config.icon,
                  color: ThemeColors.of(context).surface,
                  size: isMobile ? 24 : 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.title,
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      config.subtitle,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: ThemeColors.of(context).surfaceOverlay90,
                      ),
                    ),
                  ],
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  onPressed: onDismiss,
                  icon: Icon(
                    Icons.close_rounded,
                    color: ThemeColors.of(context).surfaceOverlay70,
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onPrimaryAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.of(context).surface,
                    foregroundColor: config.gradientColors.first,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 20,
                      vertical: isMobile ? 12 : 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    config.primaryActionLabel,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (config.secondaryActionLabel != null) ...[
                const SizedBox(width: 12),
                TextButton(
                  onPressed: onSecondaryAction,
                  style: TextButton.styleFrom(
                    foregroundColor: ThemeColors.of(context).surface,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 16,
                      vertical: isMobile ? 12 : 14,
                    ),
                  ),
                  child: Text(
                    config.secondaryActionLabel!,
                    style: TextStyle(
                      color: ThemeColors.of(context).surfaceOverlay90,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  _OnboardingConfig _getConfig(BuildContext context) {
    switch (state) {
      case TagOnboardingState.noTags:
        return _OnboardingConfig(
          icon: Icons.label_off_rounded,
          title: 'Nenhuma etiqueta cadastrada',
          subtitle: 'Importe suas primeiras etiquetas ESL para come?ar',
          primaryActionLabel: 'Importar Tags',
          secondaryActionLabel: 'Adicionar Manual',
          gradientColors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
        );
      case TagOnboardingState.manyOffline:
        return _OnboardingConfig(
          icon: Icons.signal_wifi_off_rounded,
          title: 'Tags sem comunica??o',
          subtitle: 'Algumas etiquetas est?o offline h? mais de 2 horas',
          primaryActionLabel: 'Ver Offline',
          secondaryActionLabel: 'Diagn?stico',
          gradientColors: [ThemeColors.of(context).error, ThemeColors.of(context).yellowGold],
        );
      case TagOnboardingState.lowBattery:
        return _OnboardingConfig(
          icon: Icons.battery_alert_rounded,
          title: 'Tags com bateria baixa',
          subtitle: 'Algumas etiquetas precisam de aten??o',
          primaryActionLabel: 'Ver Cr?ticas',
          secondaryActionLabel: 'Ignorar',
          gradientColors: [ThemeColors.of(context).yellowGold, ThemeColors.of(context).warning],
        );
      case TagOnboardingState.manyUnbound:
        return _OnboardingConfig(
          icon: Icons.link_off_rounded,
          title: 'Tags sem produto vinculado',
          subtitle: 'Vincule suas tags aos produtos para exibir pre?os',
          primaryActionLabel: 'Vincular Tags',
          secondaryActionLabel: 'Ver Lista',
          gradientColors: [ThemeColors.of(context).primary, ThemeColors.of(context).tealMain],
        );
      case TagOnboardingState.none:
        return _OnboardingConfig(
          icon: Icons.check_circle_rounded,
          title: '',
          subtitle: '',
          primaryActionLabel: '',
          gradientColors: [ThemeColors.of(context).success, ThemeColors.of(context).materialTeal],
        );
    }
  }
}

class _OnboardingConfig {
  final IconData icon;
  final String title;
  final String subtitle;
  final String primaryActionLabel;
  final String? secondaryActionLabel;
  final List<Color> gradientColors;

  const _OnboardingConfig({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryActionLabel,
    this.secondaryActionLabel,
    required this.gradientColors,
  });
}







