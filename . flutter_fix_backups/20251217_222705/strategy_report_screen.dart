import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/features/strategies/presentation/providers/strategies_provider.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

class EstrategiaRelatorioScreen extends ConsumerStatefulWidget {
  const EstrategiaRelatorioScreen({super.key});

  @override
  ConsumerState<EstrategiaRelatorioScreen> createState() => _EstrategiaRelatorioScreenState();
}

class _EstrategiaRelatorioScreenState extends ConsumerState<EstrategiaRelatorioScreen> with ResponsiveCache {
  String _periodoSelecionado = '30dias'; // 7dias, 30dias, 90dias, customizado

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(strategiesProvider);
      if (state.strategies.isEmpty) {
        ref.read(strategiesProvider.notifier).initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final strategiesState = ref.watch(strategiesProvider);
    final estrategias = strategiesState.strategies;
    
    final estrategiasAtivas = estrategias.where((e) => e.status == StrategyStatus.active).length;
    final totalVendas = estrategias
        .where((e) => e.status == StrategyStatus.active)
        .fold(0.0, (sum, e) => sum + (e.savings.isNotEmpty ? double.tryParse(e.savings.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0 : 0.0));
    final produtosAfetadosTotal = estrategias.fold(0, (sum, e) => sum + e.products);
    final roiMedio = estrategias.isNotEmpty 
        ? (estrategias.fold(0.0, (sum, e) => sum + (double.tryParse(e.roi.replaceAll('%', '')) ?? 0.0)) / estrategias.length).round()
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatãrio de Estratégias'),
        backgroundColor: ThemeColors.of(context).primary,
        foregroundColor: ThemeColors.of(context).surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded),
            onPressed: _exportarPdf,
          ),
          IconButton(
            icon: const Icon(Icons.file_download_rounded),
            onPressed: _exportarExcel,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: ThemeColors.of(context).backgroundLight,
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildResumoCard(estrategiasAtivas, totalVendas, produtosAfetadosTotal, roiMedio),
            const SizedBox(height: 16),
            _buildPeriodoSelector(),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Desempenho por Estratãgia',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...estrategias.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildEstrategiaCard(e.value, e.key),
            )),
            const SizedBox(height: 20),
            _buildInsightsCard(),
            const SizedBox(height: 80),
          ],
        ),
      )
    );
  }

  Widget _buildResumoCard(int estrategiasAtivas, double totalVendas, int produtosAfetadosTotal, int roiMedio) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: ThemeColors.of(context).surface,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visão Geral',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'últimos 30 dias',
                      style: const TextStyle(
                        fontSize: 14,
                      ).copyWith(color: ThemeColors.of(context).surfaceOverlay70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMetricBox(
                  'Estratégias Ativas',
                  '$estratégiasAtivas',
                  Icons.lightbulb_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricBox(
                  'Produtos Afetados',
                  '$produtosAfetadosTotal',
                  Icons.inventory_2_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricBox(
                  'Faturamento',
                  'R\$ ${totalVendas.toStringAsFixed(1)}k',
                  Icons.attach_money_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricBox(
                  'ROI Mãdio',
                  '$roiMedio%',
                  Icons.trending_up_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surfaceOverlay15,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.of(context).surfaceOverlay20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ThemeColors.of(context).surfaceOverlay70, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).surface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: ThemeColors.of(context).surfaceOverlay70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodoSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildPeriodoButton('7 dias', '7dias'),
          _buildPeriodoButton('30 dias', '30dias'),
          _buildPeriodoButton('90 dias', '90dias'),
          _buildPeriodoButton('Customizado', 'customizado'),
        ],
      ),
    );
  }

  Widget _buildPeriodoButton(String label, String periodo) {
    final isSelected = _periodoSelecionado == periodo;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _periodoSelecionado = periodo),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? ThemeColors.of(context).primary : ThemeColors.of(context).borderLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEstrategiaCard(StrategyModel estrategia, int index) {
    // Calcula crescimento baseado no ROI
    final crescimento = double.tryParse(estrategia.roi.replaceAll('%', '')) ?? 0.0;
    // ignore: unused_local_variable
    final roiValue = double.tryParse(estrategia.roi.replaceAll('%', '')) ?? 0.0;
    
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 60)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: InkWell(
        onTap: () => _verDetalhes(estrategia),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: estrategia.primaryColor.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: estrategia.primaryColor.withValues(alpha: 0.1),
                blurRadius: 15,
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: estrategia.gradient,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      estrategia.icon,
                      color: ThemeColors.of(context).surface,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          estrategia.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: AppSizes.extraSmallPadding.get(isMobile, isTablet), vertical: 3),
                              decoration: BoxDecoration(
                                color: estrategia.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                estrategia.category.label,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: estrategia.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildImpactoTag(estrategia.impact),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: ThemeColors.of(context).textSecondary),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildMetrica(
                      'Vendas',
                      estrategia.savings,
                      Icons.attach_money_rounded,
                      estrategia.primaryColor,
                    ),
                  ),
                  Container(width: 1, height: 40, color: ThemeColors.of(context).textSecondary),
                  Expanded(
                    child: _buildMetrica(
                      'Crescimento',
                      '+${crescimento.toStringAsFixed(0)}%',
                      Icons.trending_up_rounded,
                      ThemeColors.of(context).greenMain,
                    ),
                  ),
                  Container(width: 1, height: 40, color: ThemeColors.of(context).textSecondary),
                  Expanded(
                    child: _buildMetrica(
                      'ROI',
                      estrategia.roi,
                      Icons.analytics_rounded,
                      estrategia.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImpactoTag(String impacto) {
    Color cor;
    switch (impacto) {
      case 'Alto':
        cor = ThemeColors.of(context).greenMain;
        break;
      case 'Mãdio':
        cor = ThemeColors.of(context).orangeMain;
        break;
      default:
        cor = ThemeColors.of(context).textSecondary;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.extraSmallPadding.get(isMobile, isTablet), vertical: 3),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: cor),
          const SizedBox(width: 4),
          Text(
            impacto,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetrica(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: ThemeColors.of(context).textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsCard() {
    final strategiesState = ref.watch(strategiesProvider);
    final estrategias = strategiesState.strategies;
    final insights = _generateDynamicInsights(estrategias);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeColors.of(context).primaryPastel,
            ThemeColors.of(context).infoPastel,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.of(context).primaryLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.lightbulb_rounded, color: ThemeColors.of(context).primaryDark, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Insights da IA',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (insights.isEmpty)
            _buildInsightItem(
              '? Nenhuma estratãgia ativa para anãlise',
              ThemeColors.of(context).textSecondary,
            )
          else
            ...insights.map((insight) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildInsightItem(insight['texto'], insight['cor']),
            )),
        ],
      ),
    );
  }
  
  /// Gera insights dinâmicos baseados nas Estratégias do provider
  List<Map<String, dynamic>> _generateDynamicInsights(List<StrategyModel> estrategias) {
    final insights = <Map<String, dynamic>>[];
    
    if (estrategias.isEmpty) return insights;
    
    // Encontrar estratãgia com melhor ROI
    final estrategiasComRoi = estrategias.where((e) {
      final roi = double.tryParse(e.roi.replaceAll('%', '').replaceAll(',', '.')) ?? 0.0;
      return roi > 0;
    }).toList();
    
    if (estrategiasComRoi.isNotEmpty) {
      estrategiasComRoi.sort((a, b) {
        final roiA = double.tryParse(a.roi.replaceAll('%', '').replaceAll(',', '.')) ?? 0.0;
        final roiB = double.tryParse(b.roi.replaceAll('%', '').replaceAll(',', '.')) ?? 0.0;
        return roiB.compareTo(roiA);
      });
      final melhorRoi = estrategiasComRoi.first;
      insights.add({
        'texto': '? ${melhorRoi.name} apresenta o melhor ROI (${melhorRoi.roi})',
        'cor': ThemeColors.of(context).greenMain,
      });
    }
    
    // Encontrar estratãgia que afeta mais produtos
    final estrategiasComProdutos = estrategias.where((e) => e.products > 0).toList();
    if (estrategiasComProdutos.isNotEmpty) {
      estrategiasComProdutos.sort((a, b) => b.products.compareTo(a.products));
      final maisProdutos = estrategiasComProdutos.first;
      insights.add({
        'texto': '? ${maisProdutos.name} afeta mais produtos (${maisProdutos.products} itens)',
        'cor': ThemeColors.of(context).blueMain,
      });
    }
    
    // SuGestão para Estratégias inativas
    final inativas = estrategias.where((e) => e.status != StrategyStatus.active).toList();
    if (inativas.isNotEmpty) {
      final sugestao = inativas.first;
      insights.add({
        'texto': '? SuGestão: Ativar estratãgia de ${sugestao.name} para aumentar vendas',
        'cor': ThemeColors.of(context).orangeMain,
      });
    }
    
    // Mostrar economia total das ativas
    final ativas = estrategias.where((e) => e.status == StrategyStatus.active).toList();
    if (ativas.isNotEmpty) {
      final economiaTotal = ativas.fold(0.0, (sum, e) {
        final valor = double.tryParse(e.savings.replaceAll(RegExp(r'[^\d.,]'), '').replaceAll(',', '.')) ?? 0.0;
        return sum + valor;
      });
      if (economiaTotal > 0) {
        insights.add({
          'texto': '? Estratégias ativas geraram R\$ ${economiaTotal.toStringAsFixed(2)} de economia',
          'cor': ThemeColors.of(context).blueCyan,
        });
      }
    }
    
    return insights;
  }

  Widget _buildInsightItem(String texto, Color cor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: cor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _verDetalhes(StrategyModel estrategia) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeColors.of(context).transparent,
      builder: (context) => Container(
        height: MediaQuery.sizeOf(context).height * 0.75,
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ThemeColors.of(context).textSecondary,
                borderRadius: AppRadius.xxxs,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: estrategia.gradient,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          estrategia.icon,
                          color: ThemeColors.of(context).surface,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              estrategia.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Categoria: ${estrategia.category.label}',
                              style: TextStyle(
                                fontSize: 14,
                                color: ThemeColors.of(context).textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Desempenho Detalhado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetalheMetrica('Produtos Afetados', '${estrategia.products}', Icons.inventory_2_rounded),
                  _buildDetalheMetrica('Economia', estrategia.savings, Icons.attach_money_rounded),
                  _buildDetalheMetrica('Impacto', estrategia.impact, Icons.trending_up_rounded),
                  _buildDetalheMetrica('ROI', estrategia.roi, Icons.analytics_rounded),
                  const SizedBox(height: 24),
                  const Text(
                    'Evolução de Vendas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildChartArea(estrategia),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      label: const Text('Fechar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: estrategia.primaryColor,
                        foregroundColor: ThemeColors.of(context).surface,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalheMetrica(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).textSecondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: ThemeColors.of(context).primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportarPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.picture_as_pdf_rounded, color: ThemeColors.of(context).surface),
            SizedBox(width: 12),
            Text('Exportando relatãrio em PDF...'),
          ],
        ),
        backgroundColor: ThemeColors.of(context).primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _exportarExcel() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.file_download_rounded, color: ThemeColors.of(context).surface),
            SizedBox(width: 12),
            Text('Exportando relatãrio em Excel...'),
          ],
        ),
        backgroundColor: ThemeColors.of(context).greenMain,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Constrói ãrea do gráfico com dados do backend
  Widget _buildChartArea(StrategyModel estrategia) {
    final providerKey = '${estrategia.id}:7';
    final asyncValue = ref.watch(strategyDailySalesProvider(providerKey));
    
    return asyncValue.when(
      loading: () => Container(
        height: 150,
        decoration: BoxDecoration(
          color: ThemeColors.of(context).textSecondaryOverlay10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => Container(
        height: 150,
        decoration: BoxDecoration(
          color: ThemeColors.of(context).textSecondaryOverlay10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: ThemeColors.of(context).textSecondary, size: 40),
              const SizedBox(height: 8),
              Text(
                'Erro ao carregar dados',
                style: TextStyle(color: ThemeColors.of(context).textSecondary),
              ),
            ],
          ),
        ),
      ),
      data: (salesData) {
        if (salesData.isEmpty) {
          return Container(
            height: 150,
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondaryOverlay10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Sem dados de vendas disponíveis',
                style: TextStyle(color: ThemeColors.of(context).textSecondary),
              ),
            ),
          );
        }
        
        final maxSales = salesData.map((d) => d.sales).reduce((a, b) => a > b ? a : b);
        
        return Container(
          height: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).textSecondaryOverlay10,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: salesData.map((data) {
              final height = maxSales > 0 ? (data.sales / maxSales) * 100 : 0.0;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${data.sales}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 28,
                    height: height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: estrategia.gradient,
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.dayAbbreviation,
                    style: TextStyle(
                      fontSize: 10,
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}







