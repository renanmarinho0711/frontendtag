import 'package:tagbean/core/enums/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/pricing/data/models/pricing_models.dart';
import 'package:tagbean/features/pricing/presentation/providers/pricing_provider.dart';

class PrecificacaoSugestoesScreen extends ConsumerStatefulWidget {
  const PrecificacaoSugestoesScreen({super.key});

  @override
  ConsumerState<PrecificacaoSugestoesScreen> createState() => _PrecificacaoSugestoesScreenState();
}

class _PrecificacaoSugestoesScreenState extends ConsumerState<PrecificacaoSugestoesScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  bool _estrategiaAtiva = true;
  // NOTA: _sugestoesSelecionadas removido (morto)

  // Getters conectados ao Provider
  AiSuggestionsState get _state => ref.watch(aiSuggestionsProvider);
  List<AiSuggestionModel> get _sugestoes => _state.suggestions;
  List<AiSuggestionModel> get _sugestoesFiltradas => _state.filteredSuggestions;
  bool get _isLoading => _state.status == LoadingStatus.loading;
  // NOTA: _filterTipo removido (morto)

  int get _aumentos => _sugestoes.where((s) => s.tipo == 'Aumento').length;
  int get _promocoes => _sugestoes.where((s) => s.tipo == 'Promo��o').length;
  int get _prioridade => _sugestoes.where((s) => s.confianca >= 90).length;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_sugestoes.isEmpty) {
        ref.read(aiSuggestionsProvider.notifier).loadSuggestions();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildStatsCard(),
        if (_isLoading)
          const Expanded(
            child: Center(child: CircularProgressIndicator()),
          )
        else
          Expanded(
            child: _sugestoesFiltradas.isEmpty
                ? _buildEmptyState()
                : GridView.builder(
                    padding: const EdgeInsets.all(15),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3.75,
                    ),
                    itemCount: _sugestoesFiltradas.length,
                    itemBuilder: (context, index) {
                      return _buildSugestaoCard(_sugestoesFiltradas[index], index);
                    },
                  ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 64,
            color: ThemeColors.of(context).textSecondaryOverlay50,
          ),
          const SizedBox(height: 16),
          const Text(
            'Nenhuma sugest�o dispon�vel',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'As sugest�es de IA aparecer�o aqui',
            style: TextStyle(
              fontSize: 14,
              color: ThemeColors.of(context).textSecondaryOverlay70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
              color: ThemeColors.of(context).textSecondaryOverlay10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: ThemeColors.of(context).textSecondary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).orangeMain, ThemeColors.of(context).warning],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 22),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sugest�es Inteligentes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'An�lise autom�tica de pre�os',
                  style: TextStyle(fontSize: 11, color: ThemeColors.of(context).textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: ThemeColors.of(context).textSecondary, size: 20),
            onPressed: () {
              ref.read(aiSuggestionsProvider.notifier).regenerarSugestoes();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(16),
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
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: ThemeColors.of(context).orangeAmber.withValues(alpha: 0.8), size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Estrat�gia de Sugest�es Autom�ticas',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: _estrategiaAtiva,
                  onChanged: (value) {
                    setState(() => _estrategiaAtiva = value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              value ? Icons.check_circle_rounded : Icons.cancel_rounded,
                              color: ThemeColors.of(context).surface,
                            ),
                            const SizedBox(width: 12),
                            Text(value ? 'Estrat�gia ativada' : 'Estrat�gia desativada'),
                          ],
                        ),
                        backgroundColor: value ? ThemeColors.of(context).success : ThemeColors.of(context).error,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  activeColor: ThemeColors.of(context).success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Aumentos',
                  '$_aumentos',
                  Icons.trending_up_rounded,
                  ThemeColors.of(context).success,
                ),
              ),
              Container(width: 1, height: 35, color: ThemeColors.of(context).textSecondaryOverlay20),
              Expanded(
                child: _buildStatItem(
                  'Promo��es',
                  '$_promocoes',
                  Icons.local_offer_rounded,
                  ThemeColors.of(context).orangeMaterial,
                ),
              ),
              Container(width: 1, height: 35, color: ThemeColors.of(context).textSecondaryOverlay20),
              Expanded(
                child: _buildStatItem(
                  'Prioridade',
                  '$_prioridade',
                  Icons.priority_high_rounded,
                  ThemeColors.of(context).error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            color: ThemeColors.of(context).textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSugestaoCard(AiSuggestionModel sugestao, int index) {
    final confiancaCor = _getCorConfianca(sugestao.confianca);
    final gradiente = sugestao.tipo == 'Aumento'
        ? [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd]
        : [ThemeColors.of(context).primaryPastel, ThemeColors.of(context).yellowGold];
    final icone = sugestao.tipo == 'Aumento' ? Icons.trending_up_rounded : Icons.local_offer_rounded;

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 200 + (index * 30)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 5),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ThemeColors.of(context).textSecondaryOverlay20),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradiente),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icone, color: ThemeColors.of(context).surface, size: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sugestao.produto,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        sugestao.id,
                        style: TextStyle(
                          fontSize: 13,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: confiancaCor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: confiancaCor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '${sugestao.confianca}%',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: confiancaCor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).textSecondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Atual',
                          style: TextStyle(
                            fontSize: 13,
                            color: ThemeColors.of(context).textSecondary,
                          ),
                        ),
                        Text(
                          'R\$ ${sugestao.precoAtual.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_rounded, size: 14, color: ThemeColors.of(context).textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sugerido',
                          style: TextStyle(
                            fontSize: 13,
                            color: ThemeColors.of(context).textSecondary,
                          ),
                        ),
                        Text(
                          'R\$ ${sugestao.precoSugerido.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: gradiente[0],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).infoPastel,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.psychology_rounded, size: 13, color: ThemeColors.of(context).infoDark),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      sugestao.motivo,
                      style: TextStyle(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).successPastel,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.analytics_rounded, size: 13, color: ThemeColors.of(context).successIcon),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Varia��o: ${sugestao.variacao > 0 ? '+' : ''}${sugestao.variacao.toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => _mostrarAnaliseDetalhada(sugestao),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      child: const Text('An�lise', style: TextStyle(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _rejeitarSugestao(sugestao),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ThemeColors.of(context).error,
                        side: BorderSide(color: ThemeColors.of(context).error, width: 1.5),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      child: const Text('Rejeitar', style: TextStyle(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _aceitarSugestao(sugestao),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gradiente[0],
                        foregroundColor: ThemeColors.of(context).surface,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      child: const Text('Aceitar', style: TextStyle(fontSize: 13)),
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

  Color _getCorConfianca(int confianca) {
    if (confianca >= 90) return ThemeColors.of(context).success;
    if (confianca >= 75) return ThemeColors.of(context).primary;
    return ThemeColors.of(context).orangeMaterial;
  }

  void _mostrarAnaliseDetalhada(AiSuggestionModel sugestao) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.analytics_rounded, color: ThemeColors.of(context).infoDark, size: 48),
        title: const Text('An�lise Detalhada'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                sugestao.produto,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 24),
              const Text(
                'Dados Considerados:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildAnaliseItem('Hist�rico de vendas: 30 dias'),
              _buildAnaliseItem('Rotatividade: Alta'),
              _buildAnaliseItem('Elasticidade de pre�o: Calculada'),
              _buildAnaliseItem('Compara��o com concorr�ncia'),
              _buildAnaliseItem('Sazonalidade: Considerada'),
              _buildAnaliseItem('Margem atual vs ideal'),
              const SizedBox(height: 16),
              const Text(
                'Impacto Estimado:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Vendas: ${sugestao.impactoVendas}'),
              Text('Margem: ${sugestao.impactoMargem}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnaliseItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, size: 14, color: ThemeColors.of(context).successIcon),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  void _aceitarSugestao(AiSuggestionModel sugestao) {
    final gradiente = sugestao.tipo == 'Aumento'
        ? [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd]
        : [ThemeColors.of(context).primaryPastel, ThemeColors.of(context).yellowGold];
    final icone = sugestao.tipo == 'Aumento' ? Icons.trending_up_rounded : Icons.local_offer_rounded;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(icone, color: gradiente[0], size: 48),
        title: const Text('Confirmar Sugest�o'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Aplicar sugest�o para ${sugestao.produto}?',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).infoPastel,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Pre�o atual:'),
                      Text('R\$ ${sugestao.precoAtual.toStringAsFixed(2)}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Novo pre�o:'),
                      Text(
                        'R\$ ${sugestao.precoSugerido.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: gradiente[0],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(aiSuggestionsProvider.notifier).aceitarSugestao(sugestao.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                      const SizedBox(width: 12),
                      Text('Sugest�o aplicada: ${sugestao.produto}'),
                    ],
                  ),
                  backgroundColor: ThemeColors.of(context).success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gradiente[0],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  void _rejeitarSugestao(AiSuggestionModel sugestao) {
    ref.read(aiSuggestionsProvider.notifier).rejeitarSugestao(sugestao.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
            const SizedBox(width: 12),
            Text('Sugest�o rejeitada: ${sugestao.produto}'),
          ],
        ),
        backgroundColor: ThemeColors.of(context).error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}









