import 'package:tagbean/core/enums/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/reports/presentation/providers/reports_provider.dart';
import 'package:tagbean/features/reports/data/models/report_models.dart';

class RelatoriosPerformanceScreen extends ConsumerStatefulWidget {
  const RelatoriosPerformanceScreen({super.key});

  @override
  ConsumerState<RelatoriosPerformanceScreen> createState() => _RelatoriosPerformanceScreenState();
}

class _RelatoriosPerformanceScreenState extends ConsumerState<RelatoriosPerformanceScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  late AnimationController _sparklineController;
  String _ordenacaoSelecionada = 'Impacto';
  String _filtroCategoria = 'Todas';

  // Getter conectado ao Provider - dados reais do backend
  PerformanceReportsState get _performanceState => ref.watch(performanceReportsProvider);
  
  // Converte os modelos do provider para o formato Map esperado pelos widgets
  List<Map<String, dynamic>> get _relatorios {
    if (_performanceState.reports.isEmpty) {
      return [];
    }
    return _performanceState.reports.map((report) {
      return {
        'titulo': report.metrica,
        'subtitulo': report.descricao,
        'icone': _getIconForTrend(report.trend),
        'cor': _getColorForTrend(report.trend),
        'valor': '${report.valorAtual.toStringAsFixed(1)}${report.unidade}',
        'valorNumerico': report.valorAtual,
        'percentual': (report.valorAtual / report.meta * 100).clamp(0, 100),
        'detalhes': 'ã Valor atual: ${report.valorAtual.toStringAsFixed(2)} ${report.unidade}\nã Meta: ${report.meta.toStringAsFixed(2)} ${report.unidade}\nã Variação: ${report.variacao >= 0 ? '+' : ''}${report.variacao.toStringAsFixed(1)}%',
        'acao': report.metaAtingida ? 'Meta atingida' : 'Ajustar estratégia',
        'impacto': 'Variação: ${report.variacao >= 0 ? '+' : ''}${report.variacao.toStringAsFixed(1)}%',
        'impactoNumerico': report.variacao,
        'prioridade': _getPrioridade(report),
        'tag': report.metaAtingida ? 'ATINGIDO' : 'PENDENTE',
        'recomendacao': report.descricao,
        'prazo': report.metaAtingida ? 'Concluãdo' : '7-15 dias',
      };
    }).toList();
  }
  
  IconData _getIconForTrend(ReportTrend trend) {
    switch (trend) {
      case ReportTrend.up:
        return Icons.arrow_upward_rounded;
      case ReportTrend.down:
        return Icons.arrow_downward_rounded;
      case ReportTrend.stable:
        return Icons.remove_rounded;
    }
  }
  
  Color _getColorForTrend(ReportTrend trend) {
    switch (trend) {
      case ReportTrend.up:
        return ThemeColors.of(context).success;
      case ReportTrend.down:
        return ThemeColors.of(context).error;
      case ReportTrend.stable:
        return ThemeColors.of(context).primary;
    }
  }
  
  String _getPrioridade(PerformanceReportModel report) {
    if (report.metaAtingida) return 'baixa';
    if (report.variacao < -10) return 'urgente';
    if (report.variacao < 0) return 'alta';
    return 'media';
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _sparklineController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animationController.forward();
    _sparklineController.forward();
    
    // Carregar dados do backend
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(performanceReportsProvider);
      if (state.status == LoadingStatus.initial) {
        ref.read(performanceReportsProvider.notifier).loadReports();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _sparklineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
      )
    );
  }

  Widget _buildContent() {
    // Tratamento de estados de loading e erro
    if (_performanceState.status == LoadingStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_performanceState.status == LoadingStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: ThemeColors.of(context).error),
            const SizedBox(height: 16),
            Text(
              _performanceState.error ?? 'Erro ao carregar dados',
              textAlign: TextAlign.center,
              style: TextStyle(color: ThemeColors.of(context).textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(performanceReportsProvider.notifier).loadReports(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }
    
    if (_relatorios.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 64, color: ThemeColors.of(context).textSecondary),
            const SizedBox(height: 16),
            Text(
              'Nenhum dado de performance disponível',
              style: TextStyle(color: ThemeColors.of(context).textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Execute EstratÃ©gias para gerar MÃ©tricas',
              style: TextStyle(color: ThemeColors.of(context).textSecondaryOverlay70, fontSize: 14),
            ),
          ],
        ),
      );
    }
    
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildEnhancedInsightsHeader(),
          _buildEnhancedFilterBar(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: _relatorios.length + 1,
            itemBuilder: (context, index) {
              if (index == _relatorios.length) {
                return _buildAISummary();
              }
              return _buildEnhancedPerformanceCard(_relatorios[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.08),
            blurRadius: 25,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textSecondary,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).success.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.insights_rounded,
              color: ThemeColors.of(context).surface,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Anãlise de Performance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.8,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Insights e Recomendações IA',
                  style: TextStyle(
                    fontSize: 13,
                    color: ThemeColors.of(context).textSecondary,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.mediumPadding.get(isMobile, isTablet), vertical: 6),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).successPastel,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ThemeColors.of(context).success),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: ThemeColors.of(context).successIcon,
                ),
                const SizedBox(width: 6),
                Text(
                  'Guia',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).successIcon,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedInsightsHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).success.withValues(alpha: 0.4),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ThemeColors.of(context).surfaceOverlay30, width: 1.5),
                ),
                child: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '80 Insights Identificados',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Powered by IA é Anãlise de 30 dias',
                      style: const TextStyle(
                        fontSize: 13,
                        letterSpacing: 0.2,
                      ).copyWith(color: ThemeColors.of(context).surfaceOverlay70),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.mediumPadding.get(isMobile, isTablet), vertical: 6),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).yellowGold.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ThemeColors.of(context).yellowGold.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 14, color: ThemeColors.of(context).surface),
                    const SizedBox(width: 6),
                    Text(
                      'IA',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay15,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeColors.of(context).surfaceOverlay30, width: 1.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildMiniMetricIA('18', 'Urgente', Icons.error_rounded, ThemeColors.of(context).error),
                ),
                Container(width: 1, height: 40, color: ThemeColors.of(context).surfaceOverlay30),
                Expanded(
                  child: _buildMiniMetricIA('38', 'Alta', Icons.arrow_upward_rounded, ThemeColors.of(context).success),
                ),
                Container(width: 1, height: 40, color: ThemeColors.of(context).surfaceOverlay30),
                Expanded(
                  child: _buildMiniMetricIA('24', 'Mãdia', Icons.remove_rounded, ThemeColors.of(context).yellowGold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetricIA(String value, String label, IconData icon, Color indicatorColor) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: ThemeColors.of(context).surfaceOverlay50, size: 24),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: ThemeColors.of(context).surface,
            letterSpacing: -0.8,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: ThemeColors.of(context).surfaceOverlay90,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedFilterBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).primaryPastel,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.tune_rounded, size: 18, color: ThemeColors.of(context).primaryDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _ordenacaoSelecionada,
                  style: TextStyle(fontSize: 13, color: ThemeColors.of(context).textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Ordenar por',
                    labelStyle: const TextStyle(fontSize: 11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                  items: ['Prioridade', 'Impacto', 'Quantidade', 'Categoria']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _ordenacaoSelecionada = value!);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _filtroCategoria,
                  style: TextStyle(fontSize: 13, color: ThemeColors.of(context).textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    labelStyle: const TextStyle(fontSize: 11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                  items: ['Todas', 'Bebidas', 'Mercearia', 'Limpeza']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _filtroCategoria = value!);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedPerformanceCard(Map<String, dynamic> relatorio, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 60)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: (relatorio['cor'] as Color).withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (relatorio['cor'] as Color).withValues(alpha: 0.15),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: ThemeColors.of(context).transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(20),
            childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            leading: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    relatorio['cor'],
                    (relatorio['cor'] as Color).withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: (relatorio['cor'] as Color).withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(relatorio['icone'], color: ThemeColors.of(context).surface, size: 32),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        relatorio['titulo'],
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.timer_rounded, size: 12, color: ThemeColors.of(context).textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            'Prazo: ${relatorio['prazo']}',
                            style: TextStyle(
                              fontSize: 10,
                              color: ThemeColors.of(context).textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getPrioridadeCor(relatorio['prioridade']).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getPrioridadeCor(relatorio['prioridade']).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    relatorio['tag'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getPrioridadeCor(relatorio['prioridade']),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  relatorio['subtitulo'],
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (relatorio['cor'] as Color).withValues(alpha: 0.15),
                        (relatorio['cor'] as Color).withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (relatorio['cor'] as Color).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              relatorio['valor'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: relatorio['cor'],
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${relatorio['percentual'].toStringAsFixed(1)}% do total',
                              style: TextStyle(
                                fontSize: 11,
                                color: ThemeColors.of(context).textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: relatorio['cor'].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          color: relatorio['cor'],
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ThemeColors.of(context).textSecondary,
                      ThemeColors.of(context).textSecondaryOverlay50,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (relatorio['cor'] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.analytics_rounded,
                            size: 18,
                            color: relatorio['cor'],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Anãlise de Performance',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ThemeColors.of(context).textSecondary),
                      ),
                      child: Text(
                        relatorio['detalhes'],
                        style: TextStyle(
                          fontSize: 13,
                          color: ThemeColors.of(context).textSecondary,
                          height: 1.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (relatorio['cor'] as Color).withValues(alpha: 0.1),
                            (relatorio['cor'] as Color).withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: (relatorio['cor'] as Color).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_rounded,
                                size: 18,
                                color: relatorio['cor'],
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'RecomendAÃ§ão IA',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: relatorio['cor'],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            relatorio['acao'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.of(context).textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            relatorio['recomendacao'],
                            style: TextStyle(
                              fontSize: 12,
                              color: ThemeColors.of(context).textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: ThemeColors.of(context).surfaceOverlay70,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.trending_up_rounded, size: 16, color: ThemeColors.of(context).successIcon),
                                const SizedBox(width: 8),
                                Text(
                                  relatorio['impacto'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: ThemeColors.of(context).successIcon,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _verListaRelatorio(relatorio),
                            icon: Icon(Icons.list_rounded, size: 16, color: relatorio['cor']),
                            label: Text('Ver Lista', style: TextStyle(color: relatorio['cor'], fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: relatorio['cor'], width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _aplicarRelatorio(relatorio),
                            icon: const Icon(Icons.play_arrow_rounded, size: 16),
                            label: const Text('Aplicar', style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: relatorio['cor'],
                              foregroundColor: ThemeColors.of(context).surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAISummary() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).primaryPastel],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ThemeColors.of(context).primaryLight, width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.psychology_rounded, color: ThemeColors.of(context).surface, size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Resumo Inteligente',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryRow(Icons.attach_money_rounded, 'Potencial de ganho: ${_performanceState.potencialGanhoFormatted}', ThemeColors.of(context).success),
                const SizedBox(height: 10),
                _buildSummaryRow(Icons.warning_rounded, '${_performanceState.acoesUrgentes} ações urgentes necessãrias', ThemeColors.of(context).error),
                const SizedBox(height: 10),
                _buildSummaryRow(Icons.trending_up_rounded, '${_performanceState.oportunidadesCrescimento} oportunidades de crescimento', ThemeColors.of(context).primary),
                const SizedBox(height: 10),
                _buildSummaryRow(Icons.timeline_rounded, 'Previsão: ${_performanceState.crescimentoPrevistoFormatted}', ThemeColors.of(context).primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: ThemeColors.of(context).textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Color _getPrioridadeCor(String prioridade) {
    switch (prioridade) {
      case 'urgente':
        return ThemeColors.of(context).error;
      case 'alta':
        return ThemeColors.of(context).success;
      case 'media':
        return ThemeColors.of(context).yellowGold;
      default:
        return ThemeColors.of(context).textSecondary;
    }
  }

  /// Mostra lista detalhada do relatãrio
  void _verListaRelatorio(Map<String, dynamic> relatorio) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeColors.of(context).transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: ThemeColors.of(context).surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (relatorio['cor'] as Color).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.list_rounded, color: relatorio['cor'], size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            relatorio['titulo'] ?? 'Detalhes',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${relatorio['produtos'] ?? 0} itens encontrados',
                            style: TextStyle(fontSize: 13, color: ThemeColors.of(context).grey600),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: 10,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).grey50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ThemeColors.of(context).grey200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 40,
                          decoration: BoxDecoration(
                            color: relatorio['cor'],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Item ${index + 1}', style: const TextStyle(fontWeight: FontWeight.w600)),
                              Text('Detalhes do item', style: TextStyle(fontSize: 12, color: ThemeColors.of(context).grey600)),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: ThemeColors.of(context).grey400),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Aplica AÃ§ão do relatãrio
  void _aplicarRelatorio(Map<String, dynamic> relatorio) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).surfaceOverlay20,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Aplicando ${relatorio['titulo'] ?? 'relatÃÂ£rio'}...'),
            ),
          ],
        ),
        backgroundColor: relatorio['cor'] as Color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}








