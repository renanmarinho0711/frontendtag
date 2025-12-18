import 'package:tagbean/core/enums/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/pricing/data/models/pricing_models.dart';
import 'package:tagbean/features/pricing/presentation/providers/pricing_provider.dart';

class PrecificacaoDinamicaScreen extends ConsumerStatefulWidget {
  const PrecificacaoDinamicaScreen({super.key});

  @override
  ConsumerState<PrecificacaoDinamicaScreen> createState() =>
      _PrecificacaoDinamicaScreenState();
}

class _PrecificacaoDinamicaScreenState
    extends ConsumerState<PrecificacaoDinamicaScreen> with ResponsiveCache {
  // ===========================================================================
  // STATE GETTERS - Conectados ao Provider
  // ===========================================================================

  DynamicPricingState get _state => ref.watch(dynamicPricingProvider);
  DynamicPricingConfigModel get _config => _state.config;
  bool get _carregando => _state.status == LoadingStatus.loading;
  
  /// Histórico de ajustes conectado ao provider
  PricingHistoryState get _historyState => ref.watch(pricingHistoryProvider);
  List<PricingHistoryModel> get _historicoAjustes => _historyState.history.take(5).toList();

  /// Calcula ajustes por tipo usando o histórico do backend
  int _getAjustesHojePorTipo(String tipo) {
    final hoje = DateTime.now();
    return _historyState.history.where((h) {
      final mesmoTipo = h.motivo.toLowerCase().contains(tipo.toLowerCase());
      final mesmaData = h.data.year == hoje.year && 
                        h.data.month == hoje.month && 
                        h.data.day == hoje.day;
      return mesmoTipo && mesmaData;
    }).length;
  }

  /// Gera regras dinamicamente baseado no config do provider
  List<Map<String, dynamic>> get _regras => [
    {
      'id': 'competitividade',
      'nome': 'Competitividade',
      'descricao': 'Ajusta preços baseado na concorrência',
      'ativa': _config.considerarConcorrencia,
      'peso': 40,
      'cor': ThemeColors.of(context).primary,
      'icon': Icons.store_rounded,
      'ajustes_hoje': _getAjustesHojePorTipo('competitividade'),
    },
    {
      'id': 'demanda',
      'nome': 'Demanda',
      'descricao': 'PREÇOs aumentam com alta procura',
      'ativa': _config.considerarDemanda,
      'peso': 30,
      'cor': ThemeColors.of(context).success,
      'icon': Icons.trending_up_rounded,
      'ajustes_hoje': _getAjustesHojePorTipo('demanda'),
    },
    {
      'id': 'estoque',
      'nome': 'Estoque',
      'descricao': 'Reduz preços para produtos parados',
      'ativa': _config.ativo, // Usa status geral do dynamic pricing
      'peso': 20,
      'cor': ThemeColors.of(context).orangeMaterial,
      'icon': Icons.inventory_2_rounded,
      'ajustes_hoje': _getAjustesHojePorTipo('estoque'),
    },
    {
      'id': 'sazonalidade',
      'nome': 'Sazonalidade',
      'descricao': 'Considera épocas e eventos',
      'ativa': _config.considerarSazonalidade,
      'peso': 10,
      'cor': ThemeColors.of(context).blueCyan,
      'icon': Icons.calendar_month_rounded,
      'ajustes_hoje': _getAjustesHojePorTipo('sazonalidade'),
    },
  ];

  double _sensibilidade = 50.0;
  bool _respeitarMargemMinima = true;
  bool _notificacoes = true;

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dynamicPricingProvider.notifier).loadConfig();
      ref.read(pricingHistoryProvider.notifier).loadHistory(limit: 10);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sincronizar valores locais com o config do provider quando carregado
    if (_state.status == LoadingStatus.success) {
      _respeitarMargemMinima = true; // Baseado na config
      // Calcular sensibilidade baseado nas margens
      _sensibilidade = (_config.margemMaxima - _config.margemMinima).clamp(0, 100);
    }
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final regrasAtivas = _regras.where((r) => r['ativa'] == true).length;
    final ajustesHoje =
        _regras.fold(0, (sum, r) => sum + (r['ajustes_hoje'] as int));

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildModernAppBar(),
            Expanded(
              child: _carregando
                  ? _buildLoadingState()
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildStatusCard(regrasAtivas, ajustesHoje),
                        const SizedBox(height: 20),
                        _buildConfigCard(),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'Regras de Precificação',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._regras.asMap().entries.map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildRegraCard(e.value, e.key),
                              ),
                            ),
                        const SizedBox(height: 80),
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarConfiguracoes,
        icon: const Icon(Icons.save_rounded),
        label: const Text('Salvar'),
        backgroundColor: ThemeColors.of(context).greenTeal,
      ),
    );
  }

  // ===========================================================================
  // APP BAR
  // ===========================================================================

  Widget _buildModernAppBar() {
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: 16,
            offset: const Offset(0, 4),
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
              icon: Icon(Icons.arrow_back_rounded,
                  color: ThemeColors.of(context).textSecondary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).greenTeal, ThemeColors.of(context).greenDark],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Precificação Dinâmica',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Ajustes Automáticos',
                  style:
                      TextStyle(fontSize: 11, color: ThemeColors.of(context).textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.history_rounded,
                color: ThemeColors.of(context).textSecondary, size: 20),
            onPressed: _verHistorico,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // STATUS CARD
  // ===========================================================================

  Widget _buildStatusCard(int regrasAtivas, int ajustesHoje) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).greenTeal, ThemeColors.of(context).greenDark],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).greenTeal.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_graph_rounded,
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
                      'Sistema Automãtico',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _config.ativo ? 'Ativo' : 'Desativado',
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeColors.of(context).surfaceOverlay70,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _config.ativo,
                onChanged: (value) {
                  ref.read(dynamicPricingProvider.notifier).toggleAtivo();
                },
                activeThumbColor: ThemeColors.of(context).surface,
                activeTrackColor: ThemeColors.of(context).surfaceOverlay50,
              ),
            ],
          ),
          if (_config.ativo) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatusItem(
                    Icons.rule_rounded,
                    '$regrasAtivas',
                    'Regras Ativas',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatusItem(
                    Icons.flash_on_rounded,
                    '$ajustesHoje',
                    'Ajustes Hoje',
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, String valor, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surfaceOverlay15,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: ThemeColors.of(context).surface, size: 24),
          const SizedBox(height: 6),
          Text(
            valor,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).surface,
            ),
          ),
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

  // ===========================================================================
  // CONFIG CARD
  // ===========================================================================

  Widget _buildConfigCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).greenTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.settings_rounded,
                  color: ThemeColors.of(context).greenTeal,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Configurações Gerais',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Margem Mínima
          _buildConfigRow(
            'Margem Mínima',
            '${_config.margemMinima.toStringAsFixed(0)}%',
          ),
          const SizedBox(height: 8),

          // Margem Mãxima
          _buildConfigRow(
            'Margem Mãxima',
            '${_config.margemMaxima.toStringAsFixed(0)}%',
          ),
          const SizedBox(height: 16),

          // Sensibilidade
          Row(
            children: [
              Icon(Icons.tune_rounded,
                  size: 22, color: ThemeColors.of(context).greenTeal),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Sensibilidade dos Ajustes',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).greenTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getSensibilidadeLabel(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).greenTeal,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: _sensibilidade,
            min: 0,
            max: 100,
            divisions: 4,
            activeColor: ThemeColors.of(context).greenTeal,
            label: _getSensibilidadeLabel(),
            onChanged: (value) => setState(() => _sensibilidade = value),
          ),
          Text(
            _getSensibilidadeDescricao(),
            style: TextStyle(
              fontSize: 12,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),

          // Opções
          _buildSwitchOption(
            'Respeitar Margem Mínima',
            'Nunca reduzir abaixo da margem configurada',
            Icons.shield_rounded,
            _respeitarMargemMinima,
            (value) => setState(() => _respeitarMargemMinima = value),
          ),
          const SizedBox(height: 12),
          _buildSwitchOption(
            'Notificações',
            'Alertar sobre ajustes significativos',
            Icons.notifications_rounded,
            _notificacoes,
            (value) => setState(() => _notificacoes = value),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigRow(String label, String value) {
    return Row(
      children: [
        Icon(Icons.percent_rounded,
            size: 20, color: ThemeColors.of(context).greenTeal),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).greenTeal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).greenTeal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchOption(String title, String subtitle, IconData icon,
      bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Icon(icon, color: ThemeColors.of(context).greenTeal, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: ThemeColors.of(context).greenTeal,
        ),
      ],
    );
  }

  // ===========================================================================
  // REGRA CARD
  // ===========================================================================

  Widget _buildRegraCard(Map<String, dynamic> regra, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 60)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (regra['cor'] as Color).withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (regra['cor'] as Color).withValues(alpha: 0.1),
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
                      colors: [
                        regra['cor'],
                        (regra['cor'] as Color).withValues(alpha: 0.7)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    regra['icon'],
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
                        regra['nome'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        regra['descricao'],
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: regra['ativa'] as bool,
                  onChanged: (value) {
                    setState(() {
                      regra['ativa'] = value;
                    });
                  },
                  activeThumbColor: regra['cor'] as Color,
                ),
              ],
            ),
            if (regra['ativa'] == true) ...[
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.fitness_center_rounded,
                      size: 20, color: ThemeColors.of(context).textSecondary),
                  const SizedBox(width: 8),
                  const Text(
                    'Peso da Regra:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${regra['peso']}%',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: regra['cor'] as Color,
                    ),
                  ),
                ],
              ),
              Slider(
                value: (regra['peso'] as int).toDouble(),
                min: 0,
                max: 100,
                divisions: 20,
                activeColor: regra['cor'] as Color,
                onChanged: (value) {
                  setState(() {
                    regra['peso'] = value.round();
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flash_on_rounded,
                          size: 18, color: ThemeColors.of(context).textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        'Ajustes hoje:',
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${regra['ajustes_hoje']}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: regra['cor'] as Color,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // LOADING STATE
  // ===========================================================================

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(ThemeColors.of(context).greenTeal),
          ),
          const SizedBox(height: 16),
          Text(
            'Carregando configurações...',
            style: TextStyle(
              fontSize: 16,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  String _getSensibilidadeLabel() {
    if (_sensibilidade <= 25) return 'Conservador';
    if (_sensibilidade <= 50) return 'Moderado';
    if (_sensibilidade <= 75) return 'Agressivo';
    return 'Muito Agressivo';
  }

  String _getSensibilidadeDescricao() {
    if (_sensibilidade <= 25) return 'Ajustes pequenos e cautelosos';
    if (_sensibilidade <= 50) return 'Equilíbrio entre cautela e agilidade';
    if (_sensibilidade <= 75) return 'Ajustes rápidos e significativos';
    return 'Mudanãas Rápidas e grandes variações';
  }

  // ===========================================================================
  // ACTIONS
  // ===========================================================================

  void _verHistorico() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeColors.of(context).transparent,
      builder: (context) => Container(
        height: MediaQuery.sizeOf(context).height * 0.7,
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
            const Padding(
              padding: EdgeInsets.all(24),
              child: Row(
                children: [
                  Icon(Icons.history_rounded, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Histórico de Ajustes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _historicoAjustes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 48,
                            color: ThemeColors.of(context).textSecondaryOverlay50,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhum ajuste de preço registrado',
                            style: TextStyle(
                              color: ThemeColors.of(context).textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _historicoAjustes.length,
                      itemBuilder: (context, index) {
                        final item = _historicoAjustes[index];
                        return _buildHistoricoItem(
                          item.produtoNome,
                          'R\$ ${item.precoAntigo.toStringAsFixed(2)} ? R\$ ${item.precoNovo.toStringAsFixed(2)}',
                          '${item.variacao >= 0 ? '+' : ''}${item.variacao.toStringAsFixed(1)}%',
                          'Regra: ${item.tipoLabel}',
                          _formatTimeAgo(item.dataAjuste),
                          item.isAumento ? ThemeColors.of(context).success : ThemeColors.of(context).error,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricoItem(String produto, String mudanca, String percentual,
      String regra, String tempo, Color cor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).textSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  produto,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        AppSizes.extraSmallPadding.get(isMobile, isTablet),
                    vertical: 3),
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  percentual,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: cor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            mudanca,
            style: TextStyle(
              fontSize: 13,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                regra,
                style: TextStyle(
                  fontSize: 11,
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                tempo,
                style: TextStyle(
                  fontSize: 11,
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Formata a data como tempo relativo (ex: "2 horas atrãs")
  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) {
      return 'Agora';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min atrãs';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrãs';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrãs';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _salvarConfiguracoes() {
    // Atualizar a config com os valores locais
    final novaConfig = _config.copyWith(
      considerarConcorrencia: _regras
          .firstWhere((r) => r['id'] == 'competitividade')['ativa'] as bool,
      considerarDemanda:
          _regras.firstWhere((r) => r['id'] == 'demanda')['ativa'] as bool,
      considerarSazonalidade:
          _regras.firstWhere((r) => r['id'] == 'sazonalidade')['ativa'] as bool,
    );

    ref.read(dynamicPricingProvider.notifier).updateConfig(novaConfig);
    ref.read(dynamicPricingProvider.notifier).saveConfig().then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface),
                const SizedBox(width: 12),
                const Text('Configurações salvas com sucesso'),
              ],
            ),
            backgroundColor: ThemeColors.of(context).greenTeal,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    });
  }
}









