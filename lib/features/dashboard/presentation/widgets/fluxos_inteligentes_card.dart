import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';

/// BLOCO 4: Fluxos Inteligentes
/// Detecta situaes e sugere prximos passos automaticamente
class FluxosInteligentesCard extends ConsumerWidget {
  final VoidCallback? onVincularTag;
  final VoidCallback? onCriarProduto;
  final VoidCallback? onVerErros;
  final VoidCallback? onVerPendencias;

  const FluxosInteligentesCard({
    super.key,
    this.onVincularTag,
    this.onCriarProduto,
    this.onVerErros,
    this.onVerPendencias,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final dashboardState = ref.watch(dashboardProvider);
    
    // Buscar fluxos pendentes
    final fluxos = _getFluxosPendentes(context, dashboardState);
    
    // Se no h fluxos, no mostrar o card
    if (fluxos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeColors.of(context).blueCyan.withValues(alpha: 0.05),
            ThemeColors.of(context).blueLight.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeColors.of(context).greenMaterial.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ttulo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).greenMaterial.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: ThemeColors.of(context).greenMaterial,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'FLUXOS INTELIGENTES',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).greenMaterial,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (fluxos.length > 3)
                TextButton(
                  onPressed: onVerPendencias,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 32),
                  ),
                  child: Text(
                    'Ver todos (${fluxos.length})',
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeColors.of(context).greenMaterial,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Lista de fluxos (mximo 3)
          ...fluxos.take(3).map((fluxo) => _buildFluxoItem(context, fluxo, isMobile)),
        ],
      ),
    );
  }

  List<_FluxoInteligente> _getFluxosPendentes(BuildContext context, DashboardState state) {
    final fluxos = <_FluxoInteligente>[];
    
    // Verificar produtos sem tag
    final produtosSemTag = state.data.storeStats.productsWithoutTag;
    if (produtosSemTag > 0) {
      fluxos.add(_FluxoInteligente(
        icone: Icons.inventory_2_rounded,
        cor: ThemeColors.of(context).blueMaterial,
        titulo: '$produtosSemTag ${produtosSemTag == 1 ? "produto" : "produtos"} sem tag vinculada',
        descricao: 'Vincule tags para exibir preços nos displays',
        acoes: [
          _FluxoAcao('Vincular Tag', onVincularTag, principal: true),
          _FluxoAcao('Depois', null),
        ],
      ));
    }
    
    // Verificar tags no vinculadas
    final tagsNaoVinculadas = state.data.storeStats.tagsWithoutProduct;
    if (tagsNaoVinculadas > 0) {
      fluxos.add(_FluxoInteligente(
        icone: Icons.sell_rounded,
        cor: ThemeColors.of(context).orangeMaterial,
        titulo: '$tagsNaoVinculadas ${tagsNaoVinculadas == 1 ? "tag no vinculada" : "tags no vinculadas"}',
        descricao: 'Vincule a produtos existentes ou crie novos',
        acoes: [
          _FluxoAcao('Vincular a Produto', onVincularTag, principal: true),
          _FluxoAcao('Criar Produto', onCriarProduto),
        ],
      ));
    }
    
    // Verificar importações com erro
    final importacoesComErro = state.data.storeStats.importsWithErrors;
    if (importacoesComErro > 0) {
      fluxos.add(_FluxoInteligente(
        icone: Icons.error_outline_rounded,
        cor: ThemeColors.of(context).redMain,
        titulo: 'Importação com $importacoesComErro ${importacoesComErro == 1 ? "erro" : "erros"}',
        descricao: 'Alguns produtos no foram importados corretamente',
        acoes: [
          _FluxoAcao('Ver Erros', onVerErros, principal: true),
          _FluxoAcao('Reimportar', null),
        ],
      ));
    }
    
    // Verificar produtos sem preço
    final produtosSemPreco = state.data.storeStats.productsWithoutPrice;
    if (produtosSemPreco > 0) {
      fluxos.add(_FluxoInteligente(
        icone: Icons.attach_money_rounded,
        cor: ThemeColors.of(context).amberDark,
        titulo: '$produtosSemPreco ${produtosSemPreco == 1 ? "produto" : "produtos"} sem preço definido',
        descricao: 'Defina preços para exibir nos displays',
        acoes: [
          _FluxoAcao('Definir Preços', null, principal: true),
          _FluxoAcao('Aplicar Regra', null),
        ],
      ));
    }
    
    return fluxos;
  }

  Widget _buildFluxoItem(BuildContext context, _FluxoInteligente fluxo, bool isMobile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(isMobile ? 10 : 12),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: fluxo.cor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(fluxo.icone, color: fluxo.cor, size: isMobile ? 18 : 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fluxo.titulo,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.of(context).textPrimary,
                      ),
                    ),
                    if (fluxo.descricao != null)
                      Text(
                        fluxo.descricao!,
                        style: TextStyle(
                          fontSize: isMobile ? 10 : 11,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          
          // Ações
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: fluxo.acoes.map((acao) {
              if (acao.principal) {
                return ElevatedButton(
                  onPressed: acao.onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: fluxo.cor,
                    foregroundColor: ThemeColors.of(context).surface,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 14,
                      vertical: isMobile ? 6 : 8,
                    ),
                    minimumSize: const Size(0, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    acao.label,
                    style: TextStyle(fontSize: isMobile ? 11 : 12),
                  ),
                );
              } else {
                return TextButton(
                  onPressed: acao.onTap,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 8 : 12,
                      vertical: isMobile ? 4 : 6,
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                  child: Text(
                    acao.label,
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 12,
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
                );
              }
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _FluxoInteligente {
  final IconData icone;
  final Color cor;
  final String titulo;
  final String? descricao;
  final List<_FluxoAcao> acoes;

  _FluxoInteligente({
    required this.icone,
    required this.cor,
    required this.titulo,
    this.descricao,
    required this.acoes,
  });
}

class _FluxoAcao {
  final String label;
  final VoidCallback? onTap;
  final bool principal;

  _FluxoAcao(this.label, this.onTap, {this.principal = false});
}



