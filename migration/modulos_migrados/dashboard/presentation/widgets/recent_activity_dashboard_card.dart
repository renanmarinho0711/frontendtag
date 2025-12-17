import 'package:tagbean/core/enums/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/reports/presentation/providers/reports_provider.dart';
import 'package:tagbean/features/auth/presentation/providers/auth_provider.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
/// Card de Atividade Recente - Mostra histórico de ações no sistema
/// Integrado com API de auditoria do backend
class RecentActivityDashboardCard extends ConsumerStatefulWidget {
  final VoidCallback? onViewAll;

  const RecentActivityDashboardCard({
    super.key,
    this.onViewAll,
  });

  @override
  ConsumerState<RecentActivityDashboardCard> createState() => _RecentActivityDashboardCardState();
}

class _RecentActivityDashboardCardState extends ConsumerState<RecentActivityDashboardCard> {
  @override
  void initState() {
    super.initState();
    // Carrega dados de auditoria ao iniciar (somente se autenticado)
    Future.microtask(() {
      final isLoggedIn = ref.read(isLoggedInProvider);
      if (isLoggedIn) {
        ref.read(auditReportsProvider.notifier).loadReports();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auditState = ref.watch(auditReportsProvider);
    
    // Converte relatórios de auditoria em atividades
    final activities = _convertAuditToActivities(auditState);
    
    // Se está carregando, mostra skeleton
    if (auditState.status == LoadingStatus.loading && activities.isEmpty) {
      return _buildLoadingState(context);
    }
    
    // Se não houver atividades, mostra estado vazio
    if (activities.isEmpty) {
      return _buildEmptyState(context);
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeColors.of(context).grey200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).infoBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.history_rounded,
                  color: ThemeColors.of(context).blueDark,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Atividade Recente',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                ),
              ),
              // Botão de refresh
              IconButton(
                onPressed: () {
                  ref.read(auditReportsProvider.notifier).loadReports();
                },
                icon: Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: ThemeColors.of(context).textSecondary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              if (widget.onViewAll != null)
                TextButton(
                  onPressed: widget.onViewAll,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ver todas',
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeColors.of(context).greenMaterial,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 10,
                        color: ThemeColors.of(context).greenMaterial,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Lista de atividades (máximo 4)
          ...activities.take(4).map((activity) => _buildActivityItem(context, activity)),
        ],
      ),
    );
  }

  /// Converte dados de auditoria em formato de atividades para exibição
  List<Map<String, dynamic>> _convertAuditToActivities(AuditReportsState state) {
    final activities = <Map<String, dynamic>>[];
    
    for (final report in state.reports) {
      activities.add({
        'time': _formatRelativeTime(report.dataAuditoria),
        'icon': _getIconForType(report.titulo),
        'color': _getColorForType(report.titulo, report.hasProblems),
        'description': report.descricao.isNotEmpty ? report.descricao : report.titulo,
      });
    }
    
    return activities;
  }

  /// Formata data em tempo relativo (há X minutos, há X horas)
  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'agora';
    } else if (difference.inMinutes < 60) {
      return 'há ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'há ${difference.inHours}há';
    } else if (difference.inDays < 7) {
      return 'há ${difference.inDays}d';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  /// Retorna ícone baseado no tipo de atividade
  IconData _getIconForType(String tipo) {
    final tipoLower = tipo.toLowerCase();
    
    if (tipoLower.contains('produto') || tipoLower.contains('product')) {
      return Icons.inventory_2_rounded;
    } else if (tipoLower.contains('tag') || tipoLower.contains('etiqueta')) {
      return Icons.sell_rounded;
    } else if (tipoLower.contains('vincula') || tipoLower.contains('bind') || tipoLower.contains('link')) {
      return Icons.link_rounded;
    } else if (tipoLower.contains('sync') || tipoLower.contains('sincron')) {
      return Icons.sync_rounded;
    } else if (tipoLower.contains('preço') || tipoLower.contains('price') || tipoLower.contains('precifica')) {
      return Icons.attach_money_rounded;
    } else if (tipoLower.contains('estratégia') || tipoLower.contains('strategy')) {
      return Icons.auto_graph_rounded;
    } else if (tipoLower.contains('offline') || tipoLower.contains('erro') || tipoLower.contains('error')) {
      return Icons.signal_wifi_off_rounded;
    } else if (tipoLower.contains('login') || tipoLower.contains('auth') || tipoLower.contains('usuário')) {
      return Icons.person_rounded;
    } else if (tipoLower.contains('import') || tipoLower.contains('export')) {
      return Icons.upload_file_rounded;
    } else {
      return Icons.info_outline_rounded;
    }
  }

  /// Retorna cor baseada no tipo e se tem problemas
  Color _getColorForType(String tipo, bool hasProblems) {
    if (hasProblems) {
      return ThemeColors.of(context).orangeMaterial;
    }
    
    final tipoLower = tipo.toLowerCase();
    
    if (tipoLower.contains('erro') || tipoLower.contains('error') || tipoLower.contains('offline')) {
      return ThemeColors.of(context).redMain;
    } else if (tipoLower.contains('warning') || tipoLower.contains('aviso')) {
      return ThemeColors.of(context).orangeMaterial;
    } else if (tipoLower.contains('sucesso') || tipoLower.contains('success') || tipoLower.contains('vincula')) {
      return ThemeColors.of(context).greenMaterial;
    } else if (tipoLower.contains('tag') || tipoLower.contains('etiqueta')) {
      return ThemeColors.of(context).greenMaterial;
    } else if (tipoLower.contains('produto') || tipoLower.contains('product')) {
      return ThemeColors.of(context).blueMaterial;
    } else if (tipoLower.contains('preço') || tipoLower.contains('price')) {
      return ThemeColors.of(context).greenMaterial;
    } else {
      return ThemeColors.of(context).blueMaterial;
    }
  }

  Widget _buildActivityItem(BuildContext context, Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicador de tempo
          SizedBox(
            width: 60,
            child: Text(
              activity['time'] as String,
              style: TextStyle(
                fontSize: 11,
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
          ),
          // Ícone
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: (activity['color'] as Color).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activity['icon'] as IconData,
              size: 12,
              color: activity['color'] as Color,
            ),
          ),
          const SizedBox(width: 8),
          // Descrição
          Expanded(
            child: Text(
              activity['description'] as String,
              style: TextStyle(
                fontSize: 12,
                color: ThemeColors.of(context).textPrimary,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.of(context).grey200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).infoBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.history_rounded,
                  color: ThemeColors.of(context).blueDark,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Atividade Recente',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Carregando atividades...',
            style: TextStyle(
              fontSize: 12,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.of(context).grey200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).infoBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.history_rounded,
                  color: ThemeColors.of(context).blueDark,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Atividade Recente',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).textPrimary,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  ref.read(auditReportsProvider.notifier).loadReports();
                },
                icon: Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: ThemeColors.of(context).textSecondary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Icon(
            Icons.inbox_rounded,
            size: 40,
            color: ThemeColors.of(context).textSecondaryOverlay50,
          ),
          const SizedBox(height: 8),
          Text(
            'Nenhuma atividade recente',
            style: TextStyle(
              fontSize: 13,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'As ações do sistema aparecerão aqui',
            style: TextStyle(
              fontSize: 11,
              color: ThemeColors.of(context).textSecondaryOverlay70,
            ),
          ),
        ],
      ),
    );
  }
}


