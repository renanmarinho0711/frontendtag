import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:tagbean/features/dashboard/data/models/dashboard_models.dart';

/// Card de Primeiros Passos - Guia usuários novos pelo sistema
/// Substitui o card de "Atalhos Rápidos" que tinha conflitos com o navegador
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
    
    // Se está carregando ou tem erro, não mostrar
    if (dashboardState.isLoading || dashboardState.hasError) {
      return const SizedBox.shrink();
    }
    
    final data = dashboardState.data;
    final steps = _calculateSteps(data);
    
    // Se todos os passos estiverem concluídos, não mostrar o card
    final allCompleted = steps.every((p) => p['completed'] == true);
    if (allCompleted) return const SizedBox.shrink();
    
    final completed = steps.where((p) => p['completed'] == true).length;
    final total = steps.length;
    
    return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppThemeColors.onboardingBackground1,
                AppThemeColors.onboardingBackground2,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppThemeColors.onboardingBorder.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppThemeColors.onboardingIcon.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.rocket_launch_rounded,
                      color: AppThemeColors.onboardingIcon,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PRIMEIROS PASSOS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppThemeColors.onboardingIcon,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$completed de $total concluídos',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppThemeColors.textSecondary,
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
                          backgroundColor: AppThemeColors.grey200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppThemeColors.onboardingProgress,
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
                  backgroundColor: AppThemeColors.grey200,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppThemeColors.onboardingProgress,
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
      color: AppThemeColors.transparent,
      child: InkWell(
        onTap: completed ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: completed 
                ? AppThemeColors.greenMain.withValues(alpha: 0.1)
                : isNext
                    ? AppThemeColors.greenMaterial.withValues(alpha: 0.1)
                    : AppThemeColors.grey100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: completed
                  ? AppThemeColors.greenMain.withValues(alpha: 0.3)
                  : isNext
                      ? AppThemeColors.greenMaterial.withValues(alpha: 0.3)
                      : AppThemeColors.grey300,
              width: isNext ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone de status
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: completed
                      ? AppThemeColors.greenMain
                      : isNext
                          ? AppThemeColors.greenMaterial
                          : AppThemeColors.grey400,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: completed
                      ? const Icon(Icons.check, color: AppThemeColors.surface, size: 14)
                      : Text(
                          '$number',
                          style: const TextStyle(
                            color: AppThemeColors.surface,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 8),
              // Título
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                  color: completed
                      ? AppThemeColors.greenMain
                      : isNext
                          ? AppThemeColors.greenMaterial
                          : AppThemeColors.textSecondary,
                  decoration: completed ? TextDecoration.lineThrough : null,
                ),
              ),
              // Botão de ação para próximo passo
              if (isNext) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: AppThemeColors.greenMaterial,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
