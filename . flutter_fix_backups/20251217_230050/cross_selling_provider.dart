import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/features/strategies/data/repositories/strategies_repository.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

// ============================================================================
// REPOSITORY PROVIDER
// ============================================================================

/// Provider do StrategiesRepository para estrat�gias de cross-selling
final crossSellingStrategiesRepositoryProvider = Provider<StrategiesRepository>((ref) {
  return StrategiesRepository();
});

// ============================================================================
// NEARBY PRODUCTS (PRODUTO VIZINHO) STATE
// ============================================================================

/// Estado da estratgia de Produto Vizinho
class NearbyProductsState {
  final List<NearbyProductSuggestionModel> sugestoes;
  final bool isLoading;
  final String? error;
  final bool isStrategyActive;
  final bool fabExpanded;
  final double distanciaMaxima;
  final double confiancaMinima;
  final bool setaAnimada;
  final String estiloSeta;
  final bool rotacaoAutomatica;
  final int tempoRotacao;
  final bool notificarSugestoes;

  const NearbyProductsState({
    this.sugestoes = const [],
    this.isLoading = false,
    this.error,
    this.isStrategyActive = true,
    this.fabExpanded = true,
    this.distanciaMaxima = 5.0,
    this.confiancaMinima = 70.0,
    this.setaAnimada = true,
    this.estiloSeta = 'classica',
    this.rotacaoAutomatica = true,
    this.tempoRotacao = 10,
    this.notificarSugestoes = true,
  });

  /// Estado inicial com carregamento
  factory NearbyProductsState.loading() => const NearbyProductsState(isLoading: true);

  /// Estado com erro
  factory NearbyProductsState.error(String message) => NearbyProductsState(error: message);

  /// Cria uma c�pia com altera��es
  NearbyProductsState copyWith({
    List<NearbyProductSuggestionModel>? sugestoes,
    bool? isLoading,
    String? error,
    bool? isStrategyActive,
    bool? fabExpanded,
    double? distanciaMaxima,
    double? confiancaMinima,
    bool? setaAnimada,
    String? estiloSeta,
    bool? rotacaoAutomatica,
    int? tempoRotacao,
    bool? notificarSugestoes,
  }) {
    return NearbyProductsState(
      sugestoes: sugestoes ?? this.sugestoes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isStrategyActive: isStrategyActive ?? this.isStrategyActive,
      fabExpanded: fabExpanded ?? this.fabExpanded,
      distanciaMaxima: distanciaMaxima ?? this.distanciaMaxima,
      confiancaMinima: confiancaMinima ?? this.confiancaMinima,
      setaAnimada: setaAnimada ?? this.setaAnimada,
      estiloSeta: estiloSeta ?? this.estiloSeta,
      rotacaoAutomatica: rotacaoAutomatica ?? this.rotacaoAutomatica,
      tempoRotacao: tempoRotacao ?? this.tempoRotacao,
      notificarSugestoes: notificarSugestoes ?? this.notificarSugestoes,
    );
  }

  /// Total de sugest�es
  int get totalSugestoes => sugestoes.length;

  /// Dist�ncia m�xima formatada
  String get distanciaMaximaFormatted => '${distanciaMaxima.toStringAsFixed(1)}m';

  /// Confian�a m�nima formatada
  String get confiancaMinimaFormatted => '${confiancaMinima.toStringAsFixed(0)}%';

  /// Tempo de rota��o formatado
  String get tempoRotacaoFormatted => '${tempoRotacao}s';
}

// ============================================================================
// NEARBY PRODUCTS NOTIFIER
// ============================================================================

class NearbyProductsNotifier extends StateNotifier<NearbyProductsState> {
  final StrategiesRepository _repository;
  final String _storeId;

  NearbyProductsNotifier(this._repository, this._storeId) : super(const NearbyProductsState());

  /// Carrega dados do backend
  Future<void> loadFromBackend() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getCrossSellingData(_storeId, type: 'vizinhos');
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final sugestoesList = data['sugestoes'] ?? data['suggestions'] ?? [];
        final sugestoes = <NearbyProductSuggestionModel>[];
        
        if (sugestoesList is List) {
          for (final s in sugestoesList) {
            sugestoes.add(NearbyProductSuggestionModel(
              id: s['id']?.toString() ?? '',
              produto: s['produto']?.toString() ?? s['produtoOrigem']?.toString() ?? s['sourceProduct']?.toString() ?? '',
              sugere: s['sugere']?.toString() ?? s['produtoDestino']?.toString() ?? s['targetProduct']?.toString() ?? '',
              correlacao: (((s['correlacao'] ?? s['confianca'] ?? s['confidence'] ?? 0) as int?) ?? 0),
              distancia: s['distancia']?.toString() ?? '',
              conversao: (((s['conversão'] ?? 0) as int?) ?? 0),
              cor: const Color(0xFF2196F3),
              vendas: (((s['vendas'] ?? 0) as int?) ?? 0),
              icone: Icons.local_offer,
            ));
          }
        }
        
        state = state.copyWith(
          isLoading: false,
          sugestoes: sugestoes,
          isStrategyActive: (((data['isActive'] ?? data['ativo']) as bool?) ?? state.isStrategyActive),
          distanciaMaxima: ((data['distanciaMaxima'] ?? data['maxDistance'] ?? state.distanciaMaxima) as num?)?.toDouble() ?? state.distanciaMaxima,
          confiancaMinima: ((data['confiancaMinima'] ?? data['minConfidence'] ?? state.confiancaMinima) as num?)?.toDouble() ?? state.confiancaMinima,
          setaAnimada: (((data['setaAnimada'] ?? data['animatedArrow']) as bool?) ?? state.setaAnimada),
          estiloSeta: (((data['estiloSeta'] ?? data['arrowStyle']) as String?) ?? state.estiloSeta),
          rotacaoAutomatica: (((data['rotacaoAutomatica'] ?? data['autoRotation']) as bool?) ?? state.rotacaoAutomatica),
          tempoRotacao: (((data['tempoRotacao'] ?? data['rotationTime']) as int?) ?? state.tempoRotacao),
          notificarSugestoes: (((data['notificarSugestoes'] ?? data['notifySuggestions']) as bool?) ?? state.notificarSugestoes),
        );
      } else {
        state = state.copyWith(isLoading: false, sugestoes: []);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Atualiza o status ativo da estratgia
  void setStrategyActive(bool isActive) {
    state = state.copyWith(isStrategyActive: isActive);
  }

  /// Atualiza o estado expandido do FAB
  void toggleFabExpanded() {
    state = state.copyWith(fabExpanded: !state.fabExpanded);
  }

  /// Define o estado do FAB
  void setFabExpanded(bool expanded) {
    state = state.copyWith(fabExpanded: expanded);
  }

  /// Atualiza a dist�ncia mxima
  void setDistanciaMaxima(double distancia) {
    state = state.copyWith(distanciaMaxima: distancia);
  }

  /// Atualiza a confiana mnima
  void setConfiancaMinima(double confianca) {
    state = state.copyWith(confiancaMinima: confianca);
  }

  /// Atualiza o estilo da seta
  void setEstiloSeta(String estilo) {
    state = state.copyWith(estiloSeta: estilo);
  }

  /// Atualiza a anima��o da seta
  void setSetaAnimada(bool animada) {
    state = state.copyWith(setaAnimada: animada);
  }

  /// Atualiza a rota��o autom�tica
  void setRotacaoAutomatica(bool rotacao) {
    state = state.copyWith(rotacaoAutomatica: rotacao);
  }

  /// Atualiza o tempo de rota��o
  void setTempoRotacao(int tempo) {
    state = state.copyWith(tempoRotacao: tempo);
  }

  /// Atualiza a notifica��o de sugest�es
  void setNotificarSugestoes(bool notificar) {
    state = state.copyWith(notificarSugestoes: notificar);
  }

  /// Gera novas sugest�es via IA
  Future<void> gerarSugestoes() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final nearbyStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.crossSelling && 
                 (s.name.toLowerCase().contains('vizinho') || s.name.toLowerCase().contains('nearby')),
          orElse: () => throw Exception('Estrat�gia de produto vizinho n�o encontrada'),
        );
        
        await _repository.executeStrategy(nearbyStrategy.id);
        await loadFromBackend();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Salva as configura��es
  Future<void> saveConfigurations() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final nearbyStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.crossSelling && 
                 (s.name.toLowerCase().contains('vizinho') || s.name.toLowerCase().contains('nearby')),
          orElse: () => throw Exception('Estratgia de produto vizinho n�o encontrada'),
        );
        
        await _repository.updateStrategyConfiguration(nearbyStrategy.id, {
          'isActive': state.isStrategyActive,
          'distanciaMaxima': state.distanciaMaxima,
          'confiancaMinima': state.confiancaMinima,
          'setaAnimada': state.setaAnimada,
          'estiloSeta': state.estiloSeta,
          'rotacaoAutomatica': state.rotacaoAutomatica,
          'tempoRotacao': state.tempoRotacao,
          'notificarSugestoes': state.notificarSugestoes,
        });
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// Provider para a estratgia de Produto Vizinho
final nearbyProductsProvider = StateNotifierProvider<NearbyProductsNotifier, NearbyProductsState>(
  (ref) {
    final repository = ref.watch(crossSellingStrategiesRepositoryProvider);
    final currentStore = ref.watch(currentStoreProvider);
    final storeId = currentStore?.id ?? 'store-not-configured';
    return NearbyProductsNotifier(repository, storeId);
  },
);

// ============================================================================
// OFFERS TRAIL (TRILHA DE OFERTAS) STATE
// ============================================================================

/// Estado da estratgia de Trilha de Ofertas
class OffersTrailState {
  final List<OffersTrailModel> trilhas;
  final bool isLoading;
  final String? error;
  final bool isStrategyActive;
  final bool fabExpanded;
  final double intervaloAtualizacao;
  final int produtosPorTrilha;
  final bool destacarInicio;
  final bool destacarFim;
  final String estilo;
  final bool notificarCliente;

  const OffersTrailState({
    this.trilhas = const [],
    this.isLoading = false,
    this.error,
    this.isStrategyActive = true,
    this.fabExpanded = true,
    this.intervaloAtualizacao = 30.0,
    this.produtosPorTrilha = 4,
    this.destacarInicio = true,
    this.destacarFim = true,
    this.estilo = 'setas',
    this.notificarCliente = false,
  });

  /// Estado inicial com carregamento
  factory OffersTrailState.loading() => const OffersTrailState(isLoading: true);

  /// Estado com erro
  factory OffersTrailState.error(String message) => OffersTrailState(error: message);

  /// Cria uma c�pia com altera��es
  OffersTrailState copyWith({
    List<OffersTrailModel>? trilhas,
    bool? isLoading,
    String? error,
    bool? isStrategyActive,
    bool? fabExpanded,
    double? intervaloAtualizacao,
    int? produtosPorTrilha,
    bool? destacarInicio,
    bool? destacarFim,
    String? estilo,
    bool? notificarCliente,
  }) {
    return OffersTrailState(
      trilhas: trilhas ?? this.trilhas,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isStrategyActive: isStrategyActive ?? this.isStrategyActive,
      fabExpanded: fabExpanded ?? this.fabExpanded,
      intervaloAtualizacao: intervaloAtualizacao ?? this.intervaloAtualizacao,
      produtosPorTrilha: produtosPorTrilha ?? this.produtosPorTrilha,
      destacarInicio: destacarInicio ?? this.destacarInicio,
      destacarFim: destacarFim ?? this.destacarFim,
      estilo: estilo ?? this.estilo,
      notificarCliente: notificarCliente ?? this.notificarCliente,
    );
  }

  /// Total de trilhas
  int get totalTrilhas => trilhas.length;

  /// Trilhas ativas
  int get trilhasAtivas => trilhas.where((t) => t.ativa).length;

  /// Intervalo formatado
  String get intervaloFormatted => '${intervaloAtualizacao.toStringAsFixed(0)}min';
}

// ============================================================================
// OFFERS TRAIL NOTIFIER
// ============================================================================

class OffersTrailNotifier extends StateNotifier<OffersTrailState> {
  final StrategiesRepository _repository;
  final String _storeId;

  OffersTrailNotifier(this._repository, this._storeId) : super(const OffersTrailState());

  /// Carrega dados do backend
  Future<void> loadFromBackend() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getCrossSellingData(_storeId, type: 'trilhas');
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final trilhasList = data['trilhas'] ?? data['trails'] ?? [];
        final trilhas = <OffersTrailModel>[];
        
        if (trilhasList is List) {
          for (final t in trilhasList) {
            trilhas.add(OffersTrailModel(
              id: t['id']?.toString() ?? '',
              nome: ((t['nome']).toString()).toString() ?? t['name'] ?? '',
              produtos: t['produtos'] is List 
                  // ignore: argument_type_not_assignable
                  ? List<String>.from(t['produtos']) 
                  // ignore: argument_type_not_assignable
                  : (t['products'] is List ? List<String>.from(t['products']) : []),
              corredores: t['corredores'] is List 
                  // ignore: argument_type_not_assignable
                  ? List<String>.from(t['corredores']) 
                  // ignore: argument_type_not_assignable
                  : (t['aisles'] is List ? List<String>.from(t['aisles']) : []),
              // ignore: argument_type_not_assignable
              ativa: t['ativa'] ?? t['active'] ?? false,
              // ignore: argument_type_not_assignable
              conversao: t['conversão'] ?? t['conversion'] ?? 0,
              cor: AppThemeColors.orangeMaterial,
              icone: Icons.route,
              // ignore: argument_type_not_assignable
              vendas: t['vendas'] ?? t['sales'] ?? 0,
              ticketMedio: t['ticketMedio']?.toString() ?? t['avgTicket']?.toString() ?? 'R\$ 0',
            ));
          }
        }
        
        state = state.copyWith(
          isLoading: false,
          trilhas: trilhas,
          // ignore: argument_type_not_assignable
          isStrategyActive: data['isActive'] ?? data['ativo'] ?? state.isStrategyActive,
          // ignore: argument_type_not_assignable
          intervaloAtualizacao: (data['intervaloAtualizacao'] ?? data['updateInterval'] ?? state.intervaloAtualizacao).toDouble(),
          // ignore: argument_type_not_assignable
          produtosPorTrilha: data['produtosPorTrilha'] ?? data['productsPerTrail'] ?? state.produtosPorTrilha,
          // ignore: argument_type_not_assignable
          destacarInicio: data['destacarInicio'] ?? data['highlightStart'] ?? state.destacarInicio,
          // ignore: argument_type_not_assignable
          destacarFim: data['destacarFim'] ?? data['highlightEnd'] ?? state.destacarFim,
          estilo: ((data['estilo']).toString()).toString() ?? data['style'] ?? state.estilo,
          // ignore: argument_type_not_assignable
          notificarCliente: data['notificarCliente'] ?? data['notifyClient'] ?? state.notificarCliente,
        );
      } else {
        state = state.copyWith(isLoading: false, trilhas: []);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Atualiza o status ativo da estratgia
  void setStrategyActive(bool isActive) {
    state = state.copyWith(isStrategyActive: isActive);
  }

  /// Atualiza o estado expandido do FAB
  void toggleFabExpanded() {
    state = state.copyWith(fabExpanded: !state.fabExpanded);
  }

  /// Define o estado do FAB
  void setFabExpanded(bool expanded) {
    state = state.copyWith(fabExpanded: expanded);
  }

  /// Atualiza o intervalo de atualiza��o
  void setIntervaloAtualizacao(double intervalo) {
    state = state.copyWith(intervaloAtualizacao: intervalo);
  }

  /// Atualiza produtos por trilha
  void setProdutosPorTrilha(int quantidade) {
    state = state.copyWith(produtosPorTrilha: quantidade);
  }

  /// Atualiza destaque do incio
  void setDestacarInicio(bool destacar) {
    state = state.copyWith(destacarInicio: destacar);
  }

  /// Atualiza destaque do fim
  void setDestacarFim(bool destacar) {
    state = state.copyWith(destacarFim: destacar);
  }

  /// Atualiza o estilo
  void setEstilo(String estilo) {
    state = state.copyWith(estilo: estilo);
  }

  /// Atualiza notifica��o ao cliente
  void setNotificarCliente(bool notificar) {
    state = state.copyWith(notificarCliente: notificar);
  }

  /// Toggle status de uma trilha
  void toggleTrilhaStatus(String trilhaId) {
    final updatedTrilhas = state.trilhas.map((trilha) {
      if (trilha.id == trilhaId) {
        return trilha.copyWith(ativa: !trilha.ativa);
      }
      return trilha;
    }).toList();
    state = state.copyWith(trilhas: updatedTrilhas);
  }

  /// Atualiza status ativa de uma trilha especfica
  void toggleTrilhaAtiva(String trilhaId, bool ativa) {
    final updatedTrilhas = state.trilhas.map((trilha) {
      if (trilha.id == trilhaId) {
        return trilha.copyWith(ativa: ativa);
      }
      return trilha;
    }).toList();
    state = state.copyWith(trilhas: updatedTrilhas);
  }

  /// Cria uma nova trilha
  Future<void> criarTrilha() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final trailStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.crossSelling && 
                 (s.name.toLowerCase().contains('trilha') || s.name.toLowerCase().contains('trail')),
          orElse: () => throw Exception('Estrat�gia de trilha n�o encontrada'),
        );
        
        await _repository.executeStrategy(trailStrategy.id);
        await loadFromBackend();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Salva as configura��es
  Future<void> saveConfigurations() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final trailStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.crossSelling && 
                 (s.name.toLowerCase().contains('trilha') || s.name.toLowerCase().contains('trail')),
          orElse: () => throw Exception('Estrat�gia de trilha n�o encontrada'),
        );
        
        await _repository.updateStrategyConfiguration(trailStrategy.id, {
          'trilhas': state.trilhas.map((t) => {
            'id': t.id,
            'nome': t.nome,
            'ativa': t.ativa,
            'produtos': t.produtos,
          }).toList(),
          'isActive': state.isStrategyActive,
          'intervaloAtualizacao': state.intervaloAtualizacao,
          'produtosPorTrilha': state.produtosPorTrilha,
          'destacarInicio': state.destacarInicio,
          'destacarFim': state.destacarFim,
          'estilo': state.estilo,
          'notificarCliente': state.notificarCliente,
        });
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// Provider para a estratgia de Trilha de Ofertas
final offersTrailProvider = StateNotifierProvider<OffersTrailNotifier, OffersTrailState>(
  (ref) {
    final repository = ref.watch(crossSellingStrategiesRepositoryProvider);
    final currentStore = ref.watch(currentStoreProvider);
    final storeId = currentStore?.id ?? 'store-not-configured';
    return OffersTrailNotifier(repository, storeId);
  },
);

// ============================================================================
// SMART COMBO (COMBO INTELIGENTE) STATE
// ============================================================================

/// Estado da estratgia de Combo Inteligente
class SmartComboState {
  final List<SmartComboModel> combos;
  final bool isLoading;
  final String? error;
  final bool isStrategyActive;
  final bool fabExpanded;
  final double descontoMinimo;
  final double descontoMaximo;
  final int produtosPorCombo;
  final bool sugestaoAutomatica;
  final bool integracaoPdv;
  final String tipoDesconto;
  final bool exibirEconomia;

  const SmartComboState({
    this.combos = const [],
    this.isLoading = false,
    this.error,
    this.isStrategyActive = true,
    this.fabExpanded = true,
    this.descontoMinimo = 10.0,
    this.descontoMaximo = 30.0,
    this.produtosPorCombo = 3,
    this.sugestaoAutomatica = true,
    this.integracaoPdv = true,
    this.tipoDesconto = 'percentual',
    this.exibirEconomia = true,
  });

  /// Estado inicial com carregamento
  factory SmartComboState.loading() => const SmartComboState(isLoading: true);

  /// Estado com erro
  factory SmartComboState.error(String message) => SmartComboState(error: message);

  /// Cria uma c�pia com altera��es
  SmartComboState copyWith({
    List<SmartComboModel>? combos,
    bool? isLoading,
    String? error,
    bool? isStrategyActive,
    bool? fabExpanded,
    double? descontoMinimo,
    double? descontoMaximo,
    int? produtosPorCombo,
    bool? sugestaoAutomatica,
    bool? integracaoPdv,
    String? tipoDesconto,
    bool? exibirEconomia,
  }) {
    return SmartComboState(
      combos: combos ?? this.combos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isStrategyActive: isStrategyActive ?? this.isStrategyActive,
      fabExpanded: fabExpanded ?? this.fabExpanded,
      descontoMinimo: descontoMinimo ?? this.descontoMinimo,
      descontoMaximo: descontoMaximo ?? this.descontoMaximo,
      produtosPorCombo: produtosPorCombo ?? this.produtosPorCombo,
      sugestaoAutomatica: sugestaoAutomatica ?? this.sugestaoAutomatica,
      integracaoPdv: integracaoPdv ?? this.integracaoPdv,
      tipoDesconto: tipoDesconto ?? this.tipoDesconto,
      exibirEconomia: exibirEconomia ?? this.exibirEconomia,
    );
  }

  /// Total de combos
  int get totalCombos => combos.length;

  /// Combos ativos
  int get combosAtivos => combos.where((c) => c.ativo).length;

  /// Total de vendas
  int get totalVendas => combos.fold(0, (sum, c) => sum + c.vendas);
  
  /// Alias para totalVendas (compatibilidade)
  int get vendasTotais => totalVendas;

  /// Faturamento total
  double get faturamentoTotal => combos.fold(0.0, (sum, c) => sum + (c.precoCombo * c.vendas));

  /// Faturamento formatado
  String get faturamentoFormatted => 'R\$ ${faturamentoTotal.toStringAsFixed(2)}';

  /// Convers�o mdia
  int get conversaoMedia {
    if (combos.isEmpty) return 0;
    return (combos.fold(0, (sum, c) => sum + c.conversao) / combos.length).round();
  }

  /// Desconto mnimo formatado
  String get descontoMinimoFormatted => '${descontoMinimo.toStringAsFixed(0)}%';

  /// Desconto mximo formatado
  String get descontoMaximoFormatted => '${descontoMaximo.toStringAsFixed(0)}%';
}

// ============================================================================
// SMART COMBO NOTIFIER
// ============================================================================

class SmartComboNotifier extends StateNotifier<SmartComboState> {
  final StrategiesRepository _repository;
  final String _storeId;

  SmartComboNotifier(this._repository, this._storeId) : super(const SmartComboState());

  /// Carrega dados do backend
  Future<void> loadFromBackend() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getCrossSellingData(_storeId, type: 'combos');
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final combosList = data['combos'] ?? [];
        final combos = <SmartComboModel>[];
        
        if (combosList is List) {
          for (final c in combosList) {
            combos.add(SmartComboModel(
              id: c['id']?.toString() ?? '',
              nome: ((c['nome']).toString()).toString() ?? c['name'] ?? '',
              emoji: c['emoji']?.toString() ?? '??',
              produtos: c['produtos'] is List 
                  // ignore: argument_type_not_assignable
                  ? List<String>.from(c['produtos']) 
                  // ignore: argument_type_not_assignable
                  : (c['products'] is List ? List<String>.from(c['products']) : []),
              // ignore: argument_type_not_assignable
              precoNormal: (c['precoNormal'] ?? c['precoOriginal'] ?? c['originalPrice'] ?? 0).toDouble(),
              // ignore: argument_type_not_assignable
              precoCombo: (c['precoCombo'] ?? c['comboPrice'] ?? 0).toDouble(),
              // ignore: argument_type_not_assignable
              economia: (c['economia'] ?? c['desconto'] ?? c['discount'] ?? 0).toDouble(),
              // ignore: argument_type_not_assignable
              vendas: c['vendas'] ?? c['sales'] ?? 0,
              // ignore: argument_type_not_assignable
              conversao: c['conversão'] ?? c['conversion'] ?? 0,
              cor: AppThemeColors.blueCyan,
              // ignore: argument_type_not_assignable
              ativo: c['ativo'] ?? c['active'] ?? false,
              icone: Icons.card_giftcard,
              // ignore: argument_type_not_assignable
              margem: (c['margem'] ?? c['margin'] ?? 0).toDouble(),
            ));
          }
        }
        
        state = state.copyWith(
          isLoading: false,
          combos: combos,
          // ignore: argument_type_not_assignable
          isStrategyActive: data['isActive'] ?? data['ativo'] ?? state.isStrategyActive,
          // ignore: argument_type_not_assignable
          descontoMinimo: (data['descontoMinimo'] ?? data['minDiscount'] ?? state.descontoMinimo).toDouble(),
          // ignore: argument_type_not_assignable
          descontoMaximo: (data['descontoMaximo'] ?? data['maxDiscount'] ?? state.descontoMaximo).toDouble(),
          // ignore: argument_type_not_assignable
          produtosPorCombo: data['produtosPorCombo'] ?? data['productsPerCombo'] ?? state.produtosPorCombo,
          // ignore: argument_type_not_assignable
          sugestaoAutomatica: data['sugestaoAutomatica'] ?? data['autoSuggestion'] ?? state.sugestaoAutomatica,
          // ignore: argument_type_not_assignable
          integracaoPdv: data['integracaoPdv'] ?? data['pdvIntegration'] ?? state.integracaoPdv,
          tipoDesconto: ((data['tipoDesconto']).toString()).toString() ?? data['discountType'] ?? state.tipoDesconto,
          // ignore: argument_type_not_assignable
          exibirEconomia: data['exibirEconomia'] ?? data['showSavings'] ?? state.exibirEconomia,
        );
      } else {
        state = state.copyWith(isLoading: false, combos: []);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Atualiza o status ativo da estratgia
  void setStrategyActive(bool isActive) {
    state = state.copyWith(isStrategyActive: isActive);
  }

  /// Atualiza o estado expandido do FAB
  void toggleFabExpanded() {
    state = state.copyWith(fabExpanded: !state.fabExpanded);
  }

  /// Define o estado do FAB
  void setFabExpanded(bool expanded) {
    state = state.copyWith(fabExpanded: expanded);
  }

  /// Atualiza o desconto mnimo
  void setDescontoMinimo(double desconto) {
    state = state.copyWith(descontoMinimo: desconto);
  }

  /// Atualiza o desconto mximo
  void setDescontoMaximo(double desconto) {
    state = state.copyWith(descontoMaximo: desconto);
  }

  /// Atualiza produtos por combo
  void setProdutosPorCombo(int quantidade) {
    state = state.copyWith(produtosPorCombo: quantidade);
  }

  /// Atualiza sugest�o automtica
  void setSugestaoAutomatica(bool sugestao) {
    state = state.copyWith(sugestaoAutomatica: sugestao);
  }

  /// Atualiza integra��o com PDV
  void setIntegracaoPdv(bool integracao) {
    state = state.copyWith(integracaoPdv: integracao);
  }

  /// Atualiza tipo de desconto
  void setTipoDesconto(String tipo) {
    state = state.copyWith(tipoDesconto: tipo);
  }

  /// Atualiza exibir economia
  void setExibirEconomia(bool exibir) {
    state = state.copyWith(exibirEconomia: exibir);
  }

  /// Toggle status de um combo
  void toggleComboStatus(String comboId) {
    final updatedCombos = state.combos.map((combo) {
      if (combo.id == comboId) {
        return combo.copyWith(ativo: !combo.ativo);
      }
      return combo;
    }).toList();
    state = state.copyWith(combos: updatedCombos);
  }

  /// Atualiza status ativo de um combo especfico
  void toggleComboAtivo(String comboId, bool ativo) {
    final updatedCombos = state.combos.map((combo) {
      if (combo.id == comboId) {
        return combo.copyWith(ativo: ativo);
      }
      return combo;
    }).toList();
    state = state.copyWith(combos: updatedCombos);
  }

  /// Gera novos combos via IA
  Future<void> gerarCombos() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final comboStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.crossSelling && 
                 s.name.toLowerCase().contains('combo'),
          orElse: () => throw Exception('Estrat�gia de combo n�o encontrada'),
        );
        
        await _repository.executeStrategy(comboStrategy.id);
        await loadFromBackend();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Salva as configura��es
  Future<void> saveConfigurations() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final comboStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.crossSelling && 
                 s.name.toLowerCase().contains('combo'),
          orElse: () => throw Exception('Estratgia de combo n�o encontrada'),
        );
        
        await _repository.updateStrategyConfiguration(comboStrategy.id, {
          'combos': state.combos.map((c) => {
            'id': c.id,
            'nome': c.nome,
            'ativo': c.ativo,
            'produtos': c.produtos,
            'precoNormal': c.precoNormal,
            'precoCombo': c.precoCombo,
            'economia': c.economia,
          }).toList(),
          'isActive': state.isStrategyActive,
          'descontoMinimo': state.descontoMinimo,
          'descontoMaximo': state.descontoMaximo,
          'produtosPorCombo': state.produtosPorCombo,
          'sugestaoAutomatica': state.sugestaoAutomatica,
          'integracaoPdv': state.integracaoPdv,
          'tipoDesconto': state.tipoDesconto,
          'exibirEconomia': state.exibirEconomia,
        });
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// Provider para a estratgia de Combo Inteligente
final smartComboProvider = StateNotifierProvider<SmartComboNotifier, SmartComboState>(
  (ref) {
    final repository = ref.watch(crossSellingStrategiesRepositoryProvider);
    final currentStore = ref.watch(currentStoreProvider);
    final storeId = currentStore?.id ?? 'store-not-configured';
    return SmartComboNotifier(repository, storeId);
  },
);



