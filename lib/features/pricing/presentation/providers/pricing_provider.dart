import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tagbean/features/pricing/data/models/pricing_models.dart';

import 'package:tagbean/features/pricing/data/repositories/pricing_repository.dart';

import 'package:tagbean/core/enums/loading_status.dart';



// =============================================================================

// REPOSITORY PROVIDER

// =============================================================================



/// Provider do PricingRepository

final pricingRepositoryProvider = Provider<PricingRepository>((ref) {

  return PricingRepository();

});



// =============================================================================

// PRICING ADJUSTMENT STATE

// =============================================================================



class PricingAdjustmentState {

  final LoadingStatus status;

  final PricingAdjustmentConfigModel config;

  final PricingSimulationResultModel? simulationResult;

  final bool calculando;

  final String? error;



  const PricingAdjustmentState({

    this.status = LoadingStatus.initial,

    required this.config,

    this.simulationResult,

    this.calculando = false,

    this.error,

  });



  PricingAdjustmentState copyWith({

    LoadingStatus? status,

    PricingAdjustmentConfigModel? config,

    PricingSimulationResultModel? simulationResult,

    bool? calculando,

    String? error,

  }) {

    return PricingAdjustmentState(

      status: status ?? this.status,

      config: config ?? this.config,

      simulationResult: simulationResult ?? this.simulationResult,

      calculando: calculando ?? this.calculando,

      error: error ?? this.error,

    );

  }



  factory PricingAdjustmentState.initial() => const PricingAdjustmentState(

        config: PricingAdjustmentConfigModel(),

      );

}



class PricingAdjustmentNotifier extends StateNotifier<PricingAdjustmentState> {

  final PricingRepository _repository;

  

  PricingAdjustmentNotifier(this._repository) : super(PricingAdjustmentState.initial());



  void updateConfig(PricingAdjustmentConfigModel config) {

    state = state.copyWith(config: config);

  }


 // ignore: argument_type_not_assignable

  // ignore: argument_type_not_assignable
  void setTipoAjuste(AdjustmentType tipo) {
 // ignore: argument_type_not_assignable

    // ignore: argument_type_not_assignable
    state = state.copyWith(

      // ignore: argument_type_not_assignable
      config: state.config.copyWith(tipoAjuste: tipo),

    );

  }



  void setTipoOperacao(OperationType tipo) {

    state = state.copyWith(

      config: state.config.copyWith(tipoOperacao: tipo),

    );

  }



  void setAplicarEm(ApplyScope scope) {

    state = state.copyWith(

      config: state.config.copyWith(aplicarEm: scope),

    );

  }



  void setValor(double valor) {

    state = state.copyWith(

      config: state.config.copyWith(valor: valor),

    );

  }



  void setCategoria(String? categoria) {

    state = state.copyWith(

      config: state.config.copyWith(categoriaSelecionada: categoria),

    );

  }



  void setMarca(String? marca) {

    state = state.copyWith(

      config: state.config.copyWith(marcaSelecionada: marca),

    );

  }



  Future<void> simularAjuste([PricingRepository? repository]) async {

    final repo = repository ?? _repository;

    state = state.copyWith(calculando: true, error: null);



    try {

      final config = state.config;

      

      // Chamar API de simulação

      final response = await repo.simulatePriceAdjustment(

        adjustmentType: config.tipoAjuste == AdjustmentType.percentual ? 'percentual' : 'valor',

        operationType: config.tipoOperacao == OperationType.aumentar ? 'aumentar' : 'diminuir',

        value: config.valor,

        applyScope: _getApplyScopeString(config.aplicarEm),

        categoryId: config.categoriaSelecionada,

        brand: config.marcaSelecionada,

        productIds: config.produtosSelecionados,

        minMargin: config.margemMinima,

      );



      if (response.isSuccess && response.data != null) {

        final data = response.data!;

        final productsList = (data['products'] as List? ?? [])

            .map((p) => PricingProductModel.fromJson(p as Map<String, dynamic>))

            .toList();



        final result = PricingSimulationResultModel(

          // ignore: argument_type_not_assignable
          produtosAfetados: data['affectedProducts'] ?? productsList.length,

          // ignore: argument_type_not_assignable
          impactoTotal: (data['totalImpact'] ?? 0).toDouble(),

          // ignore: argument_type_not_assignable
          margemMediaAtual: (data['currentAverageMargin'] ?? 0).toDouble(),

          // ignore: argument_type_not_assignable
          margemMediaNova: (data['newAverageMargin'] ?? 0).toDouble(),

          produtos: productsList,

          dataSimulacao: DateTime.tryParse((data['simulationDate']).toString() ?? '') ?? DateTime.now(),

        );



        state = state.copyWith(

          calculando: false,

          simulationResult: result,

        );

      } else {

        state = state.copyWith(

          calculando: false,

          error: response.message ?? 'Erro ao simular ajuste de preços',

        );

      }

    } catch (e) {

      state = state.copyWith(

        calculando: false,

        error: 'Erro de conexão: $e',

      );

    }

  }



  String _getApplyScopeString(ApplyScope scope) {

    switch (scope) {

      case ApplyScope.todos:

        return 'todos';

      case ApplyScope.categoria:

        return 'categoria';

      case ApplyScope.marca:

        return 'marca';

      case ApplyScope.selecionados:

        return 'selecionados';

      case ApplyScope.lista:

        return 'lista';

      case ApplyScope.faixaPreco:

        return 'faixaPreco';

    }

  }



  Future<void> aplicarAjuste([PricingRepository? repository]) async {

    final repo = repository ?? _repository;

    state = state.copyWith(status: LoadingStatus.loading);



    try {

      if (state.simulationResult == null || state.simulationResult!.produtos.isEmpty) {

        state = state.copyWith(

          status: LoadingStatus.error,

          error: 'Nenhum produto para aplicar ajuste. Execute a simulação primeiro.',

        );

        return;

      }



      final config = state.config;

      final productIds = state.simulationResult!.produtos.map((p) => p.id).toList();



      final response = await repo.applyPriceAdjustment(

        adjustmentType: config.tipoAjuste == AdjustmentType.percentual ? 'percentual' : 'valor',

        operationType: config.tipoOperacao == OperationType.aumentar ? 'aumentar' : 'diminuir',

        value: config.valor,

        productIds: productIds,

        reason: 'Ajuste em lote via interface',

      );



      if (response.isSuccess) {

        state = state.copyWith(status: LoadingStatus.success);

      } else {

        state = state.copyWith(

          status: LoadingStatus.error,

          error: response.message ?? 'Erro ao aplicar ajuste de preços',

        );

      }

    } catch (e) {

      state = state.copyWith(

        status: LoadingStatus.error,

        error: 'Erro de conexão: $e',

      );

    }

  }



  void limparSimulacao() {

    state = PricingAdjustmentState.initial();

  }

  

  /// Alias para limparSimulacao

  void resetSimulation() {

    limparSimulacao();

  }

}



// =============================================================================

// MARGIN REVIEW STATE

// =============================================================================



class MarginReviewState {

  final LoadingStatus status;

  final List<MarginReviewModel> items;

  final String filterCategoria;

  final String filterStatus;

  final String? error;



  const MarginReviewState({

    this.status = LoadingStatus.initial,

    this.items = const [],

    this.filterCategoria = 'Todas',

    this.filterStatus = 'Todos',

    this.error,

  });



  List<MarginReviewModel> get filteredItems {

    return items.where((item) {

      final matchesCategoria = filterCategoria == 'Todas' ||

          item.categoria == filterCategoria;



      final matchesStatus = filterStatus == 'Todos' ||

          item.status == filterStatus;



      return matchesCategoria && matchesStatus;

    }).toList();

  }



  int get criticos => items.where((i) => i.status == 'critico').length;

  int get atencao => items.where((i) => i.status == 'atencao').length;

  int get saudaveis => items.where((i) => i.status == 'saudavel').length;



  MarginReviewState copyWith({

    LoadingStatus? status,

    List<MarginReviewModel>? items,

    String? filterCategoria,

    String? filterStatus,

    String? error,

  }) {

    return MarginReviewState(

      status: status ?? this.status,

      items: items ?? this.items,

      filterCategoria: filterCategoria ?? this.filterCategoria,

      filterStatus: filterStatus ?? this.filterStatus,

      error: error ?? this.error,

    );

  }



  factory MarginReviewState.initial() => const MarginReviewState();

}



class MarginReviewNotifier extends StateNotifier<MarginReviewState> {

  final PricingRepository _repository;

  

  MarginReviewNotifier(this._repository) : super(MarginReviewState.initial());



  Future<void> loadMargins({double targetMargin = 30}) async {

    state = state.copyWith(status: LoadingStatus.loading);



    try {

      final response = await _repository.getMarginAnalysis(targetMargin: targetMargin);



      if (response.isSuccess && response.data != null) {

        final data = response.data!;

        final criticalProducts = (data['criticalProducts'] as List? ?? [])

            .map((p) => MarginReviewModel.fromJson(p as Map<String, dynamic>))

            .toList();



        // Também carregar produtos com margens críticas

        final criticalResponse = await _repository.getCriticalMargins(minMargin: 20);

        final allCritical = criticalResponse.isSuccess 

            ? (criticalResponse.data ?? []).map((p) => MarginReviewModel.fromJson(p)).toList()

            : <MarginReviewModel>[];



        // Combinar listas sem duplicatas

        final combined = <String, MarginReviewModel>{};

        for (final item in criticalProducts) {

          combined[item.id] = item;

        }

        for (final item in allCritical) {

          if (!combined.containsKey(item.id)) {

            combined[item.id] = item;

          }

        }



        state = state.copyWith(

          status: LoadingStatus.success,

          items: combined.values.toList(),

        );

      } else {

        state = state.copyWith(

          status: LoadingStatus.error,

          error: response.message ?? 'Erro ao carregar análise de margens',

        );

      }

    } catch (e) {

      state = state.copyWith(

        status: LoadingStatus.error,

        error: 'Erro de conexão: $e',

      );

    }

  }



  // Alias para loadMargins

  Future<void> loadItems() => loadMargins();



  void setFilterCategoria(String categoria) {

    state = state.copyWith(filterCategoria: categoria);

  }



  void setFilterStatus(String status) {

    state = state.copyWith(filterStatus: status);

  }



  Future<void> ajustarPrecoProduto(String id, double novoPreco) async {

    try {

      final response = await _repository.updateProductPrice(

        productId: id,

        newPrice: novoPreco,

        reason: 'Ajuste manual de margem',

      );



      if (response.isSuccess) {

        final items = state.items.map((item) {

          if (item.id == id) {

            final margem = ((novoPreco - item.custo) / novoPreco) * 100;

            String novoStatus;

            if (margem < item.margemMinima) {

              novoStatus = 'critico';

            } else if (margem < item.margemIdeal) {

              novoStatus = 'atencao';

            } else {

              novoStatus = 'saudavel';

            }

            return MarginReviewModel(

              id: item.id,

              nome: item.nome,

              categoria: item.categoria,

              precoVenda: novoPreco,

              custoCompra: item.custo,

              margemAtual: margem,

              margemIdeal: item.margemIdeal,

              margemMinima: item.margemMinima,

              status: novoStatus,

              sugestao: 'Ajustado manualmente',

            );

          }

          return item;

        }).toList();

        state = state.copyWith(items: items);

      } else {

        state = state.copyWith(error: response.message ?? 'Erro ao ajustar preço');

      }

    } catch (e) {

      state = state.copyWith(error: 'Erro de conexão: $e');

    }

  }



  Future<void> aplicarAjusteEmMassa(double margemDesejada) async {

    final produtosParaAjustar = state.items

        .where((item) => item.status == 'critico' || item.status == 'atencao')

        .toList();



    if (produtosParaAjustar.isEmpty) return;



    final productIds = produtosParaAjustar.map((p) => p.id).toList();



    // ignore: argument_type_not_assignable
    try {
 // ignore: argument_type_not_assignable

      // ignore: argument_type_not_assignable
      // Calcular o ajuste médio necessário
 // ignore: argument_type_not_assignable

      // ignore: argument_type_not_assignable
      final response = await _repository.applyPriceAdjustment(
 // ignore: argument_type_not_assignable

        adjustmentType: 'percentual',

        operationType: 'aumentar',

        value: margemDesejada,

        productIds: productIds,

        reason: 'Ajuste em massa para margem $margemDesejada%',

      );



      if (response.isSuccess) {

        // Atualizar estado local

        final items = state.items.map((item) {

          if (item.status == 'critico' || item.status == 'atencao') {

            final novoPreco = item.custo / (1 - margemDesejada / 100);

            return MarginReviewModel(

              id: item.id,

              nome: item.nome,

              categoria: item.categoria,

              precoVenda: novoPreco,

              custoCompra: item.custo,

              margemAtual: margemDesejada,

              margemIdeal: item.margemIdeal,

              margemMinima: item.margemMinima,

              status: 'saudavel',

              sugestao: 'Ajustado automaticamente',

            );

          }

          return item;

        }).toList();

        state = state.copyWith(items: items);

      } else {

        state = state.copyWith(error: response.message ?? 'Erro ao aplicar ajuste em massa');

      }

    } catch (e) {

      state = state.copyWith(error: 'Erro de conexão: $e');

    }

  }

}



// =============================================================================

// AI SUGGESTIONS STATE

// =============================================================================



class AiSuggestionsState {

  final LoadingStatus status;

  final List<AiSuggestionModel> suggestions;

  final String filtroTipo; // 'todos', 'aumento', 'reducao', 'manutencao'

  final bool regenerando;

  final String? error;



  const AiSuggestionsState({

    this.status = LoadingStatus.initial,

    this.suggestions = const [],

    this.filtroTipo = 'todos',

    this.regenerando = false,

    this.error,

  });

  

  /// Alias para filtroTipo (compatibilidade)

  String get filterTipo => filtroTipo;



  List<AiSuggestionModel> get filteredSuggestions {

    if (filtroTipo == 'todos') return suggestions;

    return suggestions.where((s) => s.tipo == filtroTipo).toList();

  }



  int get aumentos => suggestions.where((s) => s.tipo == 'aumento').length;

  int get reducoes => suggestions.where((s) => s.tipo == 'reducao').length;

  int get manutencoes => suggestions.where((s) => s.tipo == 'manutencao').length;



  AiSuggestionsState copyWith({

    LoadingStatus? status,

    List<AiSuggestionModel>? suggestions,

    String? filtroTipo,

    bool? regenerando,

    String? error,

  }) {

    return AiSuggestionsState(

      status: status ?? this.status,

      suggestions: suggestions ?? this.suggestions,

      filtroTipo: filtroTipo ?? this.filtroTipo,

      regenerando: regenerando ?? this.regenerando,

      error: error ?? this.error,

    );

  }



  factory AiSuggestionsState.initial() => const AiSuggestionsState();

}



class AiSuggestionsNotifier extends StateNotifier<AiSuggestionsState> {

  final PricingRepository _repository;

  

  AiSuggestionsNotifier(this._repository) : super(AiSuggestionsState.initial());



  Future<void> loadSuggestions({double targetMargin = 30}) async {

    state = state.copyWith(status: LoadingStatus.loading);



    try {

      final response = await _repository.getOptimizationSuggestions(targetMargin: targetMargin);



      if (response.isSuccess && response.data != null) {

        final suggestions = response.data!

            .map((s) => AiSuggestionModel.fromJson(s))

            .toList();



        state = state.copyWith(

          status: LoadingStatus.success,

          suggestions: suggestions,

        );

      } else {

        state = state.copyWith(

          status: LoadingStatus.error,

          error: response.message ?? 'Erro ao carregar sugestões de otimização',

        );

      }

    } catch (e) {

      state = state.copyWith(

        status: LoadingStatus.error,

        error: 'Erro de conexão: $e',

      );

    }

  }



  void setFiltroTipo(String tipo) {

    state = state.copyWith(filtroTipo: tipo);

  }



  Future<void> regenerarSugestoes() async {

    state = state.copyWith(regenerando: true);



    try {

      await loadSuggestions();

      state = state.copyWith(regenerando: false);

    } catch (e) {

      state = state.copyWith(

        regenerando: false,

        error: 'Erro ao regenerar: $e',

      );

    }

  }



  Future<void> aceitarSugestao(String id) async {

    final updated = state.suggestions.map((s) {

      if (s.id == id) {

        return s.copyWith(aceita: true);

      }

      return s;

    }).toList();



    state = state.copyWith(suggestions: updated);

  }



  Future<void> rejeitarSugestao(String id) async {

    final updated = state.suggestions.where((s) => s.id != id).toList();

    state = state.copyWith(suggestions: updated);

  }



  Future<void> aplicarSugestao(String id) async {

    final sugestao = state.suggestions.firstWhere((s) => s.id == id);

    

    try {

      final response = await _repository.updateProductPrice(

        productId: sugestao.produtoId ?? id,

        newPrice: sugestao.precoSugerido,

        reason: 'Sugestão de otimização aplicada: ${sugestao.motivo}',

      );



      if (response.isSuccess) {

        final updated = state.suggestions.where((s) => s.id != id).toList();

        state = state.copyWith(suggestions: updated);

      } else {

        state = state.copyWith(error: response.message ?? 'Erro ao aplicar sugestão');

      }

    } catch (e) {

      state = state.copyWith(error: 'Erro de conexão: $e');

    }

  }



  Future<void> aplicarTodasSugestoes() async {

    for (final sugestao in state.suggestions) {

      try {

        await _repository.updateProductPrice(

          productId: sugestao.produtoId ?? sugestao.id,

          newPrice: sugestao.precoSugerido,

          reason: 'Sugestão de otimização aplicada em lote',

        );

      } catch (e) {

        // Continuar com as outras sugestões

      }

    }

    state = state.copyWith(suggestions: []);

  }

}



// =============================================================================

// PRICING HISTORY STATE

// =============================================================================



class PricingHistoryState {

  final LoadingStatus status;

  final List<PricingHistoryModel> history;

  final String filtroTipo; // 'todos', 'automatico', 'manual', 'ia', 'lote'

  final String filtroPeriodo; // '24h', '7dias', '30dias', 'todos'

  final String searchQuery;

  final String? error;



  const PricingHistoryState({

    this.status = LoadingStatus.initial,

    this.history = const [],

    this.filtroTipo = 'todos',

    this.filtroPeriodo = '7dias',

    this.searchQuery = '',

    this.error,

  });



  List<PricingHistoryModel> get filteredHistory {

    return history.where((item) {

      // Filtro por tipo

      if (filtroTipo != 'todos' && item.tipo != filtroTipo) {

        return false;

      }



      // Filtro por período

      final now = DateTime.now();

      final diffDays = now.difference(item.dataAjuste).inDays;



      if (filtroPeriodo == '24h' && diffDays > 0) return false;

      if (filtroPeriodo == '7dias' && diffDays > 7) return false;

      if (filtroPeriodo == '30dias' && diffDays > 30) return false;



      // Filtro por busca

      if (searchQuery.isNotEmpty) {

        return item.produtoNome.toLowerCase().contains(searchQuery.toLowerCase());

      }



      return true;

    }).toList();

  }



  int get totalAjustes => filteredHistory.length;

  int get aumentos => filteredHistory.where((h) => h.isAumento).length;

  int get reducoes => filteredHistory.where((h) => !h.isAumento).length;



  PricingHistoryState copyWith({

    LoadingStatus? status,

    List<PricingHistoryModel>? history,

    String? filtroTipo,

    String? filtroPeriodo,

    String? searchQuery,

    String? error,

  }) {

    return PricingHistoryState(

      status: status ?? this.status,

      history: history ?? this.history,

      filtroTipo: filtroTipo ?? this.filtroTipo,

      filtroPeriodo: filtroPeriodo ?? this.filtroPeriodo,

      searchQuery: searchQuery ?? this.searchQuery,

      error: error ?? this.error,

    );

  }



  factory PricingHistoryState.initial() => const PricingHistoryState();

}



class PricingHistoryNotifier extends StateNotifier<PricingHistoryState> {

  final PricingRepository _repository;

  

  PricingHistoryNotifier(this._repository) : super(PricingHistoryState.initial());



  Future<void> loadHistory({int limit = 100}) async {

    state = state.copyWith(status: LoadingStatus.loading);



    try {

      final response = await _repository.getPriceHistory(limit: limit);



      if (response.isSuccess && response.data != null) {

        final history = response.data!

            .map((h) => PricingHistoryModel.fromJson(h))

            .toList();



        state = state.copyWith(

          status: LoadingStatus.success,

          history: history,

        );

      } else {

        state = state.copyWith(

          status: LoadingStatus.error,

          error: response.message ?? 'Erro ao carregar histórico de preços',

        );

      }

    } catch (e) {

      state = state.copyWith(

        status: LoadingStatus.error,

        error: 'Erro de conexão: $e',

      );

    }

  }



  void setFiltroTipo(String tipo) {

    state = state.copyWith(filtroTipo: tipo);

  }



  void setFiltroPeriodo(String periodo) {

    state = state.copyWith(filtroPeriodo: periodo);

  }



  void setSearchQuery(String query) {

    state = state.copyWith(searchQuery: query);

  }



  Future<void> reverterAjuste(String id) async {

    // Encontrar o item no histórico

    final item = state.history.firstWhere((h) => h.id == id);

    

    try {

      // Reverter para o preço antigo

      final response = await _repository.updateProductPrice(

        productId: item.produtoId ?? id,

        newPrice: item.precoAntigo,

        reason: 'Reversão de ajuste',

      );



      if (response.isSuccess) {

        final updated = state.history.map((h) {

          if (h.id == id) {

            return h.copyWith(revertido: true);

          }

          return h;

        }).toList();



        state = state.copyWith(history: updated);

      } else {

        state = state.copyWith(error: response.message ?? 'Erro ao reverter ajuste');

      }

    } catch (e) {

      state = state.copyWith(error: 'Erro de conexão: $e');

    }

  }

}



// =============================================================================

// DYNAMIC PRICING STATE

// =============================================================================



class DynamicPricingState {

  final LoadingStatus status;

  final DynamicPricingConfigModel config;

  final String? error;



  const DynamicPricingState({

    this.status = LoadingStatus.initial,

    required this.config,

    this.error,

  });



  DynamicPricingState copyWith({

    LoadingStatus? status,

    DynamicPricingConfigModel? config,

    String? error,

  }) {

    return DynamicPricingState(

      status: status ?? this.status,

      config: config ?? this.config,

      error: error ?? this.error,

    );

  }



  factory DynamicPricingState.initial() => const DynamicPricingState(

        config: DynamicPricingConfigModel(),

      );

}



class DynamicPricingNotifier extends StateNotifier<DynamicPricingState> {

  final PricingRepository _repository;

  

  DynamicPricingNotifier(this._repository) : super(DynamicPricingState.initial());



  Future<void> loadConfig() async {

    state = state.copyWith(status: LoadingStatus.loading);



    try {

      final response = await _repository.getDynamicPricingConfig();

      if (response.isSuccess && response.data != null) {

        final data = response.data!;

        state = state.copyWith(

          status: LoadingStatus.success,

          config: DynamicPricingConfigModel(

            // ignore: argument_type_not_assignable
            ativo: data['ativo'] ?? false,

            // ignore: argument_type_not_assignable
            margemMinima: (data['margemMinima'] ?? 15.0).toDouble(),

            // ignore: argument_type_not_assignable
            margemMaxima: (data['margemMaxima'] ?? 50.0).toDouble(),

            // ignore: argument_type_not_assignable
            ajusteMaximoDiario: (data['ajusteMaximoDiario'] ?? 10.0).toDouble(),

            horarioPico: (data['horarioPico']).toString() ?? '12:00',

            horarioVale: (data['horarioVale']).toString() ?? '03:00',

          ),

        );

      } else {

        // Fallback para configuração padrão se backend não disponível

        state = state.copyWith(

          status: LoadingStatus.success,

          config: const DynamicPricingConfigModel(),

        );

      }

    } catch (e) {

      state = state.copyWith(

        status: LoadingStatus.error,

        error: e.toString(),

      );

    }

  }



  void updateConfig(DynamicPricingConfigModel config) {

    state = state.copyWith(config: config);

  }



  Future<void> saveConfig() async {

    state = state.copyWith(status: LoadingStatus.loading);



    try {

      final response = await _repository.updateDynamicPricingConfig(

        config: {

          'ativo': state.config.ativo,

          'margemMinima': state.config.margemMinima,

          'margemMaxima': state.config.margemMaxima,

          'ajusteMaximoDiario': state.config.ajusteMaximoDiario,

          'horarioPico': state.config.horarioPico,

          'horarioVale': state.config.horarioVale,

        },

      );



      if (response.isSuccess) {

        state = state.copyWith(status: LoadingStatus.success);

      } else {

        state = state.copyWith(

          status: LoadingStatus.error,

          error: response.errorMessage ?? 'Erro ao salvar configuração',

        );

      }

    } catch (e) {

      state = state.copyWith(

        status: LoadingStatus.error,

        error: e.toString(),

      );

    }

  }



  void toggleAtivo() {

    state = state.copyWith(

      config: state.config.copyWith(ativo: !state.config.ativo),

    );

  }

}



// =============================================================================

// PROVIDERS

// =============================================================================



/// Provider de ajuste de preços

final pricingAdjustmentProvider = StateNotifierProvider<PricingAdjustmentNotifier, PricingAdjustmentState>(

  (ref) => PricingAdjustmentNotifier(ref.watch(pricingRepositoryProvider)),

);



/// Provider de revisão de margens

final marginReviewProvider = StateNotifierProvider<MarginReviewNotifier, MarginReviewState>(

  (ref) => MarginReviewNotifier(ref.watch(pricingRepositoryProvider)),

);



/// Provider de sugestões de IA/otimização

final aiSuggestionsProvider = StateNotifierProvider<AiSuggestionsNotifier, AiSuggestionsState>(

  (ref) => AiSuggestionsNotifier(ref.watch(pricingRepositoryProvider)),

);



/// Provider de histórico de precificação

final pricingHistoryProvider = StateNotifierProvider<PricingHistoryNotifier, PricingHistoryState>(

  (ref) => PricingHistoryNotifier(ref.watch(pricingRepositoryProvider)),

);



/// Provider de precificação dinmica

final dynamicPricingProvider = StateNotifierProvider<DynamicPricingNotifier, DynamicPricingState>(

  (ref) => DynamicPricingNotifier(ref.watch(pricingRepositoryProvider)),

);



// =============================================================================

// INDIVIDUAL ADJUSTMENT STATE

// =============================================================================



/// Typedef para produto individual (alias para PricingProductModel)

typedef IndividualProductModel = PricingProductModel;



class IndividualAdjustmentState {

  final LoadingStatus status;

  final List<PricingProductModel> produtos;

  final String searchQuery;

  final String filterCategoria;

  final String sortBy; // 'nome', 'preco', 'margem'

  final String? error;

  final PricingProductModel? selectedProduct;

  final List<PriceHistoryEntry> priceHistory;



  const IndividualAdjustmentState({

    this.status = LoadingStatus.initial,

    this.produtos = const [],

    this.searchQuery = '',

    this.filterCategoria = 'todas',

    this.sortBy = 'nome',

    this.error,

    this.selectedProduct,

    this.priceHistory = const [],

  });



  List<PricingProductModel> get filteredProdutos {

    var result = List<PricingProductModel>.from(produtos);



    // Aplicar busca

    if (searchQuery.isNotEmpty) {

      final query = searchQuery.toLowerCase();

      result = result.where((p) =>

          p.nome.toLowerCase().contains(query) ||

          p.id.toLowerCase().contains(query)).toList();

    }



    // Aplicar filtro de categoria

    if (filterCategoria != 'todas') {

      result = result.where((p) => p.categoria == filterCategoria).toList();

    }



    // Aplicar ordenação

    result.sort((a, b) {

      switch (sortBy) {

        case 'preco':

          return b.precoAtual.compareTo(a.precoAtual);

        case 'margem':

          return b.margemAtual.compareTo(a.margemAtual);

        default:

          return a.nome.compareTo(b.nome);

      }

    });



    return result;

  }



  IndividualAdjustmentState copyWith({

    LoadingStatus? status,

    List<PricingProductModel>? produtos,

    String? searchQuery,

    String? filterCategoria,

    String? sortBy,

    String? error,

    PricingProductModel? selectedProduct,

    List<PriceHistoryEntry>? priceHistory,

  }) {

    return IndividualAdjustmentState(

      status: status ?? this.status,

      produtos: produtos ?? this.produtos,

      searchQuery: searchQuery ?? this.searchQuery,

      filterCategoria: filterCategoria ?? this.filterCategoria,

      sortBy: sortBy ?? this.sortBy,

      error: error ?? this.error,

      selectedProduct: selectedProduct ?? this.selectedProduct,

      priceHistory: priceHistory ?? this.priceHistory,

    );

  }



  factory IndividualAdjustmentState.initial() => const IndividualAdjustmentState();

}



class IndividualAdjustmentNotifier extends StateNotifier<IndividualAdjustmentState> {

  final PricingRepository _repository;

  

  IndividualAdjustmentNotifier(this._repository) : super(IndividualAdjustmentState.initial());



  Future<void> loadProdutos({String? searchTerm, int page = 1, int pageSize = 50}) async {

    state = state.copyWith(status: LoadingStatus.loading);



    try {

      final response = await _repository.getProductPrices(

        searchTerm: searchTerm,

        page: page,

        pageSize: pageSize,

        sortBy: state.sortBy,

      );



      if (response.isSuccess && response.data != null) {

        final data = response.data!;

        final items = (data['items'] as List? ?? [])

            .map((p) => PricingProductModel.fromJson(p as Map<String, dynamic>))

            .toList();



        state = state.copyWith(

          status: LoadingStatus.success,

          produtos: items,

        );

      } else {

        state = state.copyWith(

          status: LoadingStatus.error,

          error: response.message ?? 'Erro ao carregar produtos',

        );

      }

    } catch (e) {

      state = state.copyWith(

        status: LoadingStatus.error,

        error: 'Erro de conexão: $e',

      );

    }

  }



  void setSearchQuery(String query) {

    state = state.copyWith(searchQuery: query);

  }



  void setFilterCategoria(String categoria) {

    state = state.copyWith(filterCategoria: categoria);

  }



  void setSortBy(String sortBy) {

    state = state.copyWith(sortBy: sortBy);

  }



  Future<void> updateProdutoPreco(String produtoId, double novoPreco, {String? motivo}) async {

    try {

      final response = await _repository.updateProductPrice(

        productId: produtoId,

        newPrice: novoPreco,

        reason: motivo ?? 'Ajuste individual',

      );



      if (response.isSuccess) {

        final updatedProdutos = state.produtos.map((p) {

          if (p.id == produtoId) {

            final novaMargem = novoPreco > 0

                ? ((novoPreco - p.custo) / novoPreco) * 100

                : 0.0;

            return p.copyWith(

              precoAtual: novoPreco,

              precoNovo: novoPreco,

              margemAtual: novaMargem,

              margemNova: novaMargem,

            );

          }

          return p;

        }).toList();



        state = state.copyWith(produtos: updatedProdutos);

      } else {

        state = state.copyWith(error: response.message ?? 'Erro ao atualizar preço');

      }

    } catch (e) {

      state = state.copyWith(error: 'Erro de conexão: $e');

    }

  }



  Future<void> aplicarAjusteRapido(String produtoId, double percentual) async {

    final produto = state.produtos.firstWhere((p) => p.id == produtoId);

    final novoPreco = produto.precoAtual * (1 + percentual / 100);

    await updateProdutoPreco(produtoId, novoPreco);

  }

  

  /// Busca um produto específico pelo código/id

  Future<void> buscarProduto(String codigo) async {

    state = state.copyWith(status: LoadingStatus.loading);

    

    try {

      final response = await _repository.getProductPrices(

        searchTerm: codigo,

        page: 1,

        pageSize: 1,

      );

      

      if (response.isSuccess && response.data != null) {

        final items = (response.data!['items'] as List? ?? [])

            .map((p) => PricingProductModel.fromJson(p as Map<String, dynamic>))

            .toList();

        

        if (items.isNotEmpty) {

          state = state.copyWith(

            status: LoadingStatus.success,

            selectedProduct: items.first,

          );

        } else {

          state = state.copyWith(

            status: LoadingStatus.error,

            error: 'Produto não encontrado',

          );

        }

      } else {

        state = state.copyWith(

          status: LoadingStatus.error,

          error: 'Erro ao buscar produto',

        );

      }

    } catch (e) {

      state = state.copyWith(

        status: LoadingStatus.error,

        error: 'Erro de conexão: $e',

      );

    }

  }

  

  /// Aplica novo preço ao produto selecionado

  Future<void> aplicarNovoPreco(String productId, double novoPreco, [String? motivo]) async {

    if (state.selectedProduct == null) return;

    

    await updateProdutoPreco(productId, novoPreco, motivo: motivo);

    

    // Atualiza o produto selecionado com o novo preço

    if (state.selectedProduct != null) {

      final novaMargem = novoPreco > 0

          ? ((novoPreco - state.selectedProduct!.custo) / novoPreco) * 100

          : 0.0;

      state = state.copyWith(

        selectedProduct: state.selectedProduct!.copyWith(

          precoAtual: novoPreco,

          precoNovo: novoPreco,

          margemAtual: novaMargem,

          margemNova: novaMargem,

        ),

      );

    }

  }

}



/// Provider de ajuste individual

final individualAdjustmentProvider = StateNotifierProvider<IndividualAdjustmentNotifier, IndividualAdjustmentState>(

  (ref) => IndividualAdjustmentNotifier(ref.watch(pricingRepositoryProvider)),

);







