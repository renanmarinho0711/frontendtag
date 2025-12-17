import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:tagbean/features/dashboard/data/models/dashboard_models.dart';

/// Card de Primeiros Passos - Guia Usuários novos pelo sistema
/// Substitui o card de "Atalhos Rpidos" que tinha conflitos com o navegador
class OnboardingStepsCard extends ConsumerWidget {
  final VoidCallback? onImportProducts;
  final VoidCallback? onRegisterTags;
  final VoidCallback? onBindTags;
  final VoidCallback? onActivateStrategy;
  final VoidCallback? onConfigureStore;

  const OnboardingStepsCard({
    super.key,
    this.onImportProducts,
    this.onRegisterTags,
    this.onBindTags,
    this.onActivateStrategy,
    this.onConfigureStore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);
    
    // Se est carregando ou tem erro, no mostrar
    if (dashboardState.isLoading || dashboardState.hasError) {
      return const SizedBox.shrink();
    }
    
    final data = dashboardState.data;
    final steps = _calculateSteps(data);
    
    // Se todos os passos estiverem concludos, no mostrar o card
    final allCompleted = steps.every((p) => p['completed'] == true);
    if (allCompleted) return const SizedBox.shrink();
    
    final completed = steps.where((p) => p['completed'] == true).length;
    final total = steps.length;
    
    return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ThemeColors.of(context).onboardingBackground1,
                ThemeColors.of(context).onboardingBackground2,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ThemeColors.of(context).onboardingBorder.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabealho
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).onboardingIcon.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.rocket_launch_rounded,
                      color: ThemeColors.of(context).onboardingIcon,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRIMEIROS PASSOS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).onboardingIcon,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$completed de $total concludos',
                          style: TextStyle(
                            fontSize: 11,
                            color: ThemeColors.of(context).textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Progresso circular
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: completed / total,
                          backgroundColor: ThemeColors.of(context).grey200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ThemeColors.of(context).onboardingProgress,
                          ),
                          strokeWidth: 4,
                        ),
                        Text(
                          '${((completed / total) * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Barra de progresso
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: completed / total,
                  backgroundColor: ThemeColors.of(context).grey200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ThemeColors.of(context).onboardingProgress,
                  ),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 16),
              
              // Lista de passos
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: steps.map((step) => _buildStep(
                  context,
                  number: step['number'] as int,
                  title: step['title'] as String,
                  completed: step['completed'] as bool,
                  onTap: step['onTap'] as VoidCallback?,
                )).toList(),
              ),
            ],
          ),
        );
  }

  List<Map<String, dynamic>> _calculateSteps(DashboardData data) {
    return [
      {
        'number': 1,
        'title': 'Criar Conta',
        'completed': true, // Sempre verdadeiro se chegou aqui
        'onTap': null,
      },
      {
        'number': 2,
        'title': 'Conectar ERP',
        'completed': data.syncStatus?.isConnected ?? false,
        'onTap': onConfigureStore,
      },
      {
        'number': 3,
        'title': 'Importar Produtos',
        'completed': data.storeStats.productsCount > 0,
        'onTap': onImportProducts,
      },
      {
        'number': 4,
        'title': 'Cadastrar Tags',
        'completed': data.storeStats.tagsCount > 0,
        'onTap': onRegisterTags,
      },
      {
        'number': 5,
        'title': 'Vincular Tags',
        'completed': data.storeStats.boundTagsCount > 0,
        'onTap': onBindTags,
      },
    ];
  }

  Widget _buildStep(
    BuildContext context, {
    required int number,
    required String title,
    required bool completed,
    VoidCallback? onTap,
  }) {
    final bool isNext = !completed && onTap != null;
    
    return Material(
      color: ThemeColors.of(context).transparent,
      child: InkWell(
        onTap: completed ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: completed 
                ? ThemeColors.of(context).greenMain.withValues(alpha: 0.1)
                : isNext
                    ? ThemeColors.of(context).greenMaterial.withValues(alpha: 0.1)
                    : ThemeColors.of(context).grey100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: completed
                  ? ThemeColors.of(context).greenMain.withValues(alpha: 0.3)
                  : isNext
                      ? ThemeColors.of(context).greenMaterial.withValues(alpha: 0.3)
                      : ThemeColors.of(context).grey300,
              width: isNext ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // cone de status
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: completed
                      ? ThemeColors.of(context).greenMain
                      : isNext
                          ? ThemeColors.of(context).greenMaterial
                          : ThemeColors.of(context).grey400,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: completed
                      ? Icon(Icons.check, color: ThemeColors.of(context).surface, size: 14)
                      : Text(
                          '$number',
                          style: TextStyle(
                            color: ThemeColors.of(context).surface,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 8),
              // Ttulo
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                  color: completed
                      ? ThemeColors.of(context).greenMain
                      : isNext
                          ? ThemeColors.of(context).greenMaterial
                          : ThemeColors.of(context).textSecondary,
                  decoration: completed ? TextDecoration.lineThrough : null,
                ),
              ),
              // Boto de ao para prximo passo
              if (isNext) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: ThemeColors.of(context).greenMaterial,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}




