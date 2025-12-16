import 'package:tagbean/core/enums/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/reports/presentation/providers/reports_provider.dart';
import 'package:tagbean/features/auth/presentation/providers/auth_provider.dart';

class RecentActivityCard extends ConsumerStatefulWidget {
  const RecentActivityCard({super.key});

  @override
  ConsumerState<RecentActivityCard> createState() => _RecentActivityCardState();
}

class _RecentActivityCardState extends ConsumerState<RecentActivityCard> {
  @override
  void initState() {
    super.initState();
    // Carregar dados de auditoria ao inicializar (somente se autenticado)
    Future.microtask(() {
      final isLoggedIn = ref.read(isLoggedInProvider);
      if (!isLoggedIn) return;
      
      final state = ref.read(auditReportsProvider);
      if (state.status == LoadingStatus.initial) {
        ref.read(auditReportsProvider.notifier).loadReports();
      }
    });
  }

  /// Converte dados de auditoria em atividades formatadas
  List<Map<String, dynamic>> _buildActivities(AuditReportsState auditState) {
    if (auditState.status == LoadingStatus.loading) {
      return [];
    }

    if (auditState.reports.isEmpty) {
      return [];
    }

    // Pega as 4 atividades mais recentes
    final recentReports = auditState.reports.take(4).toList();

    return recentReports.map((report) {
      return {
        'icon': _getIconForAction(report.titulo),
        'title': report.titulo,
        'description': report.descricao.isEmpty
            ? '${report.itensVerificados} itens verificados'
            : report.descricao,
        'time': _formatTimeAgo(report.dataauditoria),
        'color': _getColorForAction(report.titulo),
      };
    }).toList();
  }

  IconData _getIconForAction(String action) {
    final lower = action.toLowerCase();
    if (lower.contains('produto') || lower.contains('product')) {
      return Icons.add_shopping_cart_rounded;
    }
    if (lower.contains('sync') || lower.contains('sincroniza')) {
      return Icons.sync_rounded;
    }
    if (lower.contains('tag') || lower.contains('label')) {
      return Icons.label_rounded;
    }
    if (lower.contains('categoria') || lower.contains('category')) {
      return Icons.category_rounded;
    }
    if (lower.contains('preo') || lower.contains('price')) {
      return Icons.attach_money_rounded;
    }
    if (lower.contains('usurio') || lower.contains('user') || lower.contains('login')) {
      return Icons.person_rounded;
    }
    if (lower.contains('config') || lower.contains('setting')) {
      return Icons.settings_rounded;
    }
    return Icons.history_rounded;
  }

  Color _getColorForAction(String action) {
    final lower = action.toLowerCase();
    if (lower.contains('produto') || lower.contains('product')) {
      return ThemeColors.of(context).success;
    }
    if (lower.contains('sync') || lower.contains('sincroniza')) {
      return ThemeColors.of(context).info;
    }
    if (lower.contains('tag') || lower.contains('label')) {
      return ThemeColors.of(context).blueCyan;
    }
    if (lower.contains('categoria') || lower.contains('category')) {
      return ThemeColors.of(context).yellowGold;
    }
    if (lower.contains('preo') || lower.contains('price')) {
      return ThemeColors.of(context).greenDark;
    }
    return ThemeColors.of(context).textSecondary;
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Agora';
    if (diff.inMinutes < 60) return 'H ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'H ${diff.inHours}h';
    if (diff.inDays == 1) return 'Ontem';
    if (diff.inDays < 7) return 'H ${diff.inDays} dias';
    return '${date.day}/${date.month}';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final auditState = ref.watch(auditReportsProvider);
    final activities = _buildActivities(auditState);

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 12 : 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          AppSizes.paddingMdLg.get(isMobile, isTablet),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  color: ThemeColors.of(context).textSecondary,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
                SizedBox(
                  width: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                Expanded(
                  child: Text(
                    'Atividade Recente',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 16,
                        mobileFontSize: 14,
                        tabletFontSize: 15,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppSizes.paddingMdLg.get(isMobile, isTablet),
            ),
            // Estados de loading, erro e vazio
            if (auditState.status == LoadingStatus.loading)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.paddingLg.get(isMobile, isTablet)),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ThemeColors.of(context).info,
                    ),
                  ),
                ),
              )
            else if (auditState.status == LoadingStatus.error)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_off_rounded,
                        color: ThemeColors.of(context).textSecondaryOverlay50,
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No foi possvel carregar atividades',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 12,
                            mobileFontSize: 10,
                            tabletFontSize: 11,
                          ),
                          color: ThemeColors.of(context).textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: () => ref.read(auditReportsProvider.notifier).loadReports(),
                        child: Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              )
            else if (activities.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_rounded,
                        color: ThemeColors.of(context).textSecondaryOverlay50,
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Nenhuma atividade recente',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 12,
                            mobileFontSize: 10,
                            tabletFontSize: 11,
                          ),
                          color: ThemeColors.of(context).textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => Divider(
                height: AppSizes.paddingXl.get(isMobile, isTablet),
                color: ThemeColors.of(context).textSecondary,
              ),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _buildActivityItem(
                  context,
                  icon: activity['icon'] as IconData,
                  title: activity['title'] as String,
                  description: activity['description'] as String,
                  time: activity['time'] as String,
                  color: activity['color'] as Color,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String time,
    required Color color,
  }) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(
            AppSizes.paddingSmAlt.get(isMobile, isTablet),
          ),
          decoration: BoxDecoration(
            color: colorLight,
            borderRadius: BorderRadius.circular(
              isMobile ? 8 : 10,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: AppSizes.iconSmallMedium.get(isMobile, isTablet),
          ),
        ),
        SizedBox(
          width: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 11,
                    tabletFontSize: 12,
                  ),
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: AppSizes.paddingMicro.get(isMobile, isTablet),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 11,
                    mobileFontSize: 9,
                    tabletFontSize: 10,
                  ),
                  color: ThemeColors.of(context).textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(
          width: AppSizes.paddingXs.get(isMobile, isTablet),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 10,
              mobileFontSize: 8,
              tabletFontSize: 9,
            ),
            color: ThemeColors.of(context).textSecondary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}







