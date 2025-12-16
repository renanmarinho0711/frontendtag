import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:tagbean/features/dashboard/data/models/dashboard_models.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

/// Card de Próxima Ação Sugerida - IA sugere o próximo passo baseado no estado do sistema
/// Lógica de prioridade:
/// 1. Sem produtos → "Importe ou cadastre produtos"
/// 2. Sem tags cadastradas → "Cadastre suas tags ESL"
/// 3. Produtos sem tags → "Vincule tags aos produtos"
/// 4. Tags offline → "Verifique as tags offline"
/// 5. Produtos sem preço → "Defina preços"
/// 6. Nenhuma estratégia → "Ative estratégias de precificação"
class NextActionCard extends ConsumerWidget {
  final VoidCallback? onImportProducts;
  final VoidCallback? onAddProduct;
  final VoidCallback? onRegisterTag;
  final VoidCallback? onBindTag;
  final VoidCallback? onViewOfflineTags;
  final VoidCallback? onSetPrices;
  final VoidCallback? onActivateStrategy;
  final VoidCallback? onDoLater;

  const NextActionCard({
    super.key,
    this.onImportProducts,
    this.onAddProduct,
    this.onRegisterTag,
    this.onBindTag,
    this.onViewOfflineTags,
    this.onSetPrices,
    this.onActivateStrategy,
    this.onDoLater,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);
    final isDismissed = ref.watch(nextActionDismissedProvider);
    final dismissNotifier = ref.read(nextActionDismissedProvider.notifier);
    
    // Se está carregando, tem erro ou foi "dismiss", não mostrar
    if (dashboardState.isLoading || dashboardState.hasError) {
      return const SizedBox.shrink();
    }
    
    // Verifica se foi dismissed (reseta após 1 hora)
    if (isDismissed && !dismissNotifier.shouldShow) {
      return const SizedBox.shrink();
    }
    
    final data = dashboardState.data;
    final suggestion = _determineNextAction(data);
    
    // Se não houver sugestão, não mostrar o card
    if (suggestion == null) return const SizedBox.shrink();
    
    return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                (suggestion['color'] as Color).withValues(alpha: 0.05),
                (suggestion['color'] as Color).withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (suggestion['color'] as Color).withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (suggestion['color'] as Color).withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (suggestion['color'] as Color).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      suggestion['icon'] as IconData,
                      color: suggestion['color'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_rounded,
                              size: 14,
                              color: AppThemeColors.amberDark,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'PRÓXIMO PASSO RECOMENDADO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppThemeColors.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          suggestion['title'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: suggestion['color'] as Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Descrição
              Text(
                suggestion['description'] as String,
                style: TextStyle(
                  fontSize: 13,
                  color: AppThemeColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              
              // Botões de ação
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: suggestion['onMainAction'] as VoidCallback?,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: suggestion['color'] as Color,
                        foregroundColor: AppThemeColors.surface,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: Icon(suggestion['buttonIcon'] as IconData, size: 18),
                      label: Text(
                        suggestion['buttonText'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      // Dismiss o card (esconde por 1 hora)
                      dismissNotifier.dismiss();
                      // Chama callback se fornecido
                      onDoLater?.call();
                      // Feedback visual
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.schedule_rounded, color: AppThemeColors.surface, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Lembraremos você mais tarde',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: AppThemeColors.textSecondary,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Fazer depois',
                      style: TextStyle(
                        color: AppThemeColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
  }

  Map<String, dynamic>? _determineNextAction(DashboardData data) {
    // 1. Sem produtos
    if (data.storeStats.productsCount == 0) {
      return {
        'title': 'Importe seus produtos',
        'description': 'Você ainda não tem produtos cadastrados. '
            'Importe do ERP ou cadastre manualmente para começar a usar o sistema.',
        'icon': Icons.inventory_2_rounded,
        'color': AppThemeColors.nextStepIcon,
        'buttonText': 'Importar Produtos',
        'buttonIcon': Icons.cloud_download_rounded,
        'onMainAction': onImportProducts,
      };
    }
    
    // 2. Sem tags cadastradas
    if (data.storeStats.tagsCount == 0) {
      return {
        'title': 'Cadastre suas tags ESL',
        'description': 'Nenhuma etiqueta eletrônica foi cadastrada ainda. '
            'Adicione as tags ESL para exibir preços automaticamente nas prateleiras.',
        'icon': Icons.label_rounded,
        'color': AppThemeColors.blueCyan,
        'buttonText': 'Cadastrar Tags',
        'buttonIcon': Icons.add_circle_outline_rounded,
        'onMainAction': onRegisterTag,
      };
    }
    
    // 3. Produtos sem tags (mais de 0 produtos e taxa < 100%)
    final bindingRate = data.storeStats.productsCount > 0
        ? (data.storeStats.boundTagsCount / data.storeStats.productsCount * 100)
        : 0.0;
    final productsWithoutTag = data.storeStats.productsWithoutTag;
    
    if (productsWithoutTag > 0 && bindingRate < 100) {
      return {
        'title': 'Vincule tags aos produtos',
        'description': 'Você tem $productsWithoutTag produtos sem tag vinculada. '
            'Vincule tags ESL para exibir preços automaticamente.',
        'icon': Icons.link_rounded,
        'color': AppThemeColors.nextStepIcon,
        'buttonText': 'Vincular Tags Agora',
        'buttonIcon': Icons.link_rounded,
        'onMainAction': onBindTag,
      };
    }
    
    // 4. Tags offline (tags não vinculadas podem indicar offline)
    final offlineCount = data.storeStats.availableTagsCount;
    if (offlineCount > 0) {
      return {
        'title': 'Verifique as tags offline',
        'description': '$offlineCount tags estão sem comunicação. '
            'Isso pode indicar problema de bateria ou distância do gateway.',
        'icon': Icons.signal_wifi_off_rounded,
        'color': AppThemeColors.error,
        'buttonText': 'Ver Tags Offline',
        'buttonIcon': Icons.visibility_rounded,
        'onMainAction': onViewOfflineTags,
      };
    }
    
    // 5. Produtos sem preço
    final productsWithoutPrice = data.storeStats.productsWithoutPrice;
    if (productsWithoutPrice > 0) {
      return {
        'title': 'Defina preços dos produtos',
        'description': 'Você tem $productsWithoutPrice produtos sem preço definido. '
            'Produtos sem preço não serão exibidos nas etiquetas.',
        'icon': Icons.money_off_rounded,
        'color': AppThemeColors.warningDark,
        'buttonText': 'Definir Preços',
        'buttonIcon': Icons.attach_money_rounded,
        'onMainAction': onSetPrices,
      };
    }
    
    // 6. Nenhuma estratégia ativa
    if (data.strategiesStats.activeCount == 0) {
      return {
        'title': 'Ative estratégias de lucro',
        'description': 'Nenhuma estratégia de precificação está ativa. '
            'Ative estratégias para otimizar seus preços automaticamente.',
        'icon': Icons.auto_awesome_rounded,
        'color': AppThemeColors.greenMaterial,
        'buttonText': 'Ativar Estratégia',
        'buttonIcon': Icons.play_arrow_rounded,
        'onMainAction': onActivateStrategy,
      };
    }
    
    // Tudo OK - não mostrar o card
    return null;
  }
}
