import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/strategies/presentation/providers/strategies_provider.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
/// Card compacto de estratégias ativas
/// Mostra visÃ£o consolidada das estratégias em funcionamento
class EstrategiasAtivasCard extends ConsumerWidget {
  final VoidCallback? onGerenciar;

  const EstrategiasAtivasCard({
    super.key,
    this.onGerenciar,
  });

  String _formatCurrency(double value) {
    if (value >= 1000) {
      return 'R\$ ${(value / 1000).toStringAsFixed(1)}k';
    }
    return 'R\$ ${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    // Obtém dados de estratégias
    final strategiesState = ref.watch(strategiesProvider);
    final stats = ref.watch(strategiesStatsProvider);
    
    final estrategiasAtivas = strategiesState.strategies
        .where((s) => s.status.isActive)
        .take(5)
        .toList();
    final totalAtivas = strategiesState.strategies
        .where((s) => s.status.isActive)
        .length;
    final impactoMensal = stats.monthlyGain;

    // Cores para cada estratégia
    final cores = [
      ThemeColors.of(context).greenMain,
      ThemeColors.of(context).blueMain,
      ThemeColors.of(context).orangeMain,
      ThemeColors.of(context).greenMaterial,
      ThemeColors.of(context).greenTeal,
    ];

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
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header com resumo
            Container(
              padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    ThemeColors.of(context).orangeMain.withValues(alpha: 0.1),
                    ThemeColors.of(context).orangeDark.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ThemeColors.of(context).orangeMain.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
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
                      Icons.auto_awesome_rounded,
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
                          '$totalAtivas estratégias ativas',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).textPrimary,
                          ),
                        ),
                        Text(
                          'Gerando lucro automaticamente',
                          style: TextStyle(
                            fontSize: 11,
                            color: ThemeColors.of(context).textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Impacto',
                        style: TextStyle(
                          fontSize: 10,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                      Text(
                        '+${_formatCurrency(impactoMensal)}/mês',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).greenMain,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  if (onGerenciar != null)
                    IconButton(
                      onPressed: onGerenciar,
                      icon: Icon(
                        Icons.settings_rounded,
                        color: ThemeColors.of(context).orangeMain,
                        size: 22,
                      ),
                      tooltip: 'Gerenciar',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                ],
              ),
            ),
            
            if (estrategiasAtivas.isNotEmpty) ...[
              SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
              
              // Mini cards de estratégias
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...estrategiasAtivas.asMap().entries.map((entry) {
                      final index = entry.key;
                      final estrategia = entry.value;
                      final cor = cores[index % cores.length];
                      
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < estrategiasAtivas.length - 1 ? 10 : 0,
                        ),
                        child: _buildMiniEstrategiaCard(
                          context: context,
                          nome: estrategia.name,
                          ganho: double.tryParse(estrategia.impactValue.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0,
                          cor: cor,
                          icone: _getIconeEstrategia(estrategia.category.name),
                        ),
                      );
                    }),
                    if (totalAtivas > 5)
                      _buildMaisCard(context, totalAtivas - 5),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconeEstrategia(String type) {
    switch (type.toLowerCase()) {
      case 'temperatura':
      case 'temperature':
        return Icons.thermostat_rounded;
      case 'sazonal':
      case 'seasonal':
        return Icons.event_rounded;
      case 'pico':
      case 'peak':
        return Icons.schedule_rounded;
      case 'liquidacao':
      case 'clearance':
        return Icons.local_offer_rounded;
      case 'concorrencia':
      case 'competition':
        return Icons.trending_up_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  Widget _buildMiniEstrategiaCard({
    required BuildContext context,
    required String nome,
    required double ganho,
    required Color cor,
    required IconData icone,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cor.withValues(alpha: 0.15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: cor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icone, color: cor, size: 18),
          ),
          const SizedBox(height: 6),
          Text(
            nome,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: ThemeColors.of(context).textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '+${_formatCurrency(ganho)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaisCard(BuildContext context, int quantidade) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).backgroundLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ThemeColors.of(context).borderLight),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.more_horiz_rounded,
            color: ThemeColors.of(context).textSecondary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            '+$quantidade mais',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: ThemeColors.of(context).textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
