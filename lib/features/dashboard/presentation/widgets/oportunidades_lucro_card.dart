import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/pricing/presentation/providers/pricing_provider.dart';

/// Card de Oportunidades de Lucro (Sugestões IA reestruturado)
/// Mostra oportunidades de ajuste de preço identificadas pela IA
class OportunidadesLucroCard extends ConsumerWidget {
  final VoidCallback? onRevisarSugestoes;
  final VoidCallback? onAplicarAutomatico;

  const OportunidadesLucroCard({
    super.key,
    this.onRevisarSugestoes,
    this.onAplicarAutomatico,
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

    // Obtém dados de sugestões da IA
    final suggestionsState = ref.watch(aiSuggestionsProvider);
    
    // Valores calculados - usando os campos corretos do modelo
    final totalSugestoes = suggestionsState.suggestions.length;
    final produtosSubir = suggestionsState.suggestions
        .where((s) => s.tipo == 'aumento')
        .length;
    final produtosBaixar = suggestionsState.suggestions
        .where((s) => s.tipo == 'reducao')
        .length;
    // Calcula ganho potencial somando as variações positivas
    final potencialGanho = suggestionsState.suggestions
        .where((s) => s.tipo == 'aumento')
        .fold(0.0, (sum, s) => sum + (s.precoSugerido - s.precoAtual));

    // Se não há sugestões, mostra versão compacta
    if (totalSugestoes == 0) {
      return _buildEmptyState(context, isMobile, isTablet);
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeColors.of(context).greenMaterialOverlay05,
            ThemeColors.of(context).orangeMainOverlay03,
          ],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(
          color: ThemeColors.of(context).greenMaterialOverlay15,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).greenMaterial.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header com ícone de IA
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ThemeColors.of(context).greenMaterial,
                        ThemeColors.of(context).orangeMain,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: ThemeColors.of(context).greenMaterialOverlay30,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: ThemeColors.of(context).surface,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Oportunidades de Lucro',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 16,
                                mobileFontSize: 14,
                                tabletFontSize: 15,
                              ),
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.of(context).textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [ThemeColors.of(context).greenMaterial, ThemeColors.of(context).orangeMain],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'IA',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: ThemeColors.of(context).surface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'A IA identificou $totalSugestoes oportunidades',
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),

            // 3 números chave
            Row(
              children: [
                Expanded(
                  child: _buildNumeroChave(
                    context: context,
                    icon: Icons.trending_up_rounded,
                    iconColor: ThemeColors.of(context).greenMain,
                    valor: '$produtosSubir',
                    label: 'podem subir',
                    bgColor: ThemeColors.of(context).greenMain.withValues(alpha: 0.08),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildNumeroChave(
                    context: context,
                    icon: Icons.trending_down_rounded,
                    iconColor: ThemeColors.of(context).orangeMain,
                    valor: '$produtosBaixar',
                    label: 'devem baixar',
                    bgColor: ThemeColors.of(context).orangeMain.withValues(alpha: 0.08),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildNumeroChave(
                    context: context,
                    icon: Icons.attach_money_rounded,
                    iconColor: ThemeColors.of(context).greenMaterial,
                    valor: _formatCurrency(potencialGanho),
                    label: 'potencial/mês',
                    bgColor: ThemeColors.of(context).greenMaterial.withValues(alpha: 0.08),
                    destaque: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),

            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRevisarSugestoes,
                    icon: const Icon(Icons.visibility_rounded, size: 18),
                    label: const Text(
                      'Revisar Sugestões',
                      style: TextStyle(fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ThemeColors.of(context).greenMaterial,
                      side: BorderSide(color: ThemeColors.of(context).greenMaterial.withValues(alpha: 0.4)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onAplicarAutomatico,
                    icon: const Icon(Icons.bolt_rounded, size: 18),
                    label: const Text(
                      'Aplicar Todos',
                      style: TextStyle(fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.of(context).greenMaterial,
                      foregroundColor: ThemeColors.of(context).surface,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isMobile, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(
          color: ThemeColors.of(context).greenMaterial.withValues(alpha: 0.1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).greenMaterial.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: ThemeColors.of(context).greenMaterial,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Oportunidades de Lucro',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.of(context).textPrimary,
                    ),
                  ),
                  Text(
                    'Nenhuma sugestão disponível no momento',
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.check_circle_rounded,
              color: ThemeColors.of(context).greenMain,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumeroChave({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String valor,
    required String label,
    required Color bgColor,
    bool destaque = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: destaque 
            ? Border.all(color: iconColor.withValues(alpha: 0.3), width: 1.5) 
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 6),
          Text(
            valor,
            style: TextStyle(
              fontSize: destaque ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: destaque ? iconColor : ThemeColors.of(context).textPrimary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: ThemeColors.of(context).textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}



