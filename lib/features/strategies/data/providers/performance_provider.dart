import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/features/strategies/data/repositories/strategies_repository.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';

// ============================================================================
// REPOSITORY PROVIDER
// ============================================================================

/// Provider do StrategiesRepository para estratégias de performance
final performanceStrategiesRepositoryProvider = Provider<StrategiesRepository>((ref) {
  return StrategiesRepository();
});

// ============================================================================
// AUTO CLEARANCE STATE
// ============================================================================

/// Estado da estratégia de Liquidação Automática
class AutoClearanceState {
  final List<ClearancePhaseModel> phases;
  final List<ClearanceProductModel> products;
  final List<String> selectedCategories;
  final List<String> allCategories;
  final bool isLoading;
  final String? error;
  final bool isStrategyActive;
  final bool fabExpanded;
  final double margemMinima;
  final bool notificarLiquidacao;

  const AutoClearanceState({
    this.phases = const [],
    this.products = const [],
    this.selectedCategories = const [],
    this.allCategories = const [],
    this.isLoading = false,
    this.error,
    this.isStrategyActive = true,
    this.fabExpanded = true,
    this.margemMinima = 5.0,
    this.notificarLiquidacao = true,
  });

  /// Estado inicial com carregamento
  factory AutoClearanceState.loading() => const AutoClearanceState(isLoading: true);

  /// Estado com erro
  factory AutoClearanceState.error(String message) => AutoClearanceState(error: message);

  /// Cria uma cópia com alterações
  AutoClearanceState copyWith({
    List<ClearancePhaseModel>? phases,
    List<ClearanceProductModel>? products,
    List<String>? selectedCategories,
    List<String>? allCategories,
    bool? isLoading,
    String? error,
    bool? isStrategyActive,
    bool? fabExpanded,
    double? margemMinima,
    bool? notificarLiquidacao,
  }) {
    return AutoClearanceState(
      phases: phases ?? this.phases,
      products: products ?? this.products,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      allCategories: allCategories ?? this.allCategories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isStrategyActive: isStrategyActive ?? this.isStrategyActive,
      fabExpanded: fabExpanded ?? this.fabExpanded,
      margemMinima: margemMinima ?? this.margemMinima,
      notificarLiquidacao: notificarLiquidacao ?? this.notificarLiquidacao,
    );
  }

  /// Retorna o total de produtos em liquidação
  int get totalProductsInClearance => products.length;

  /// Retorna a margem formatada
  String get margemMinimaFormatted => '${margemMinima.toStringAsFixed(1)}%';

  /// Calcula o capital empatado baseado nos produtos em liquidação
  /// Capital empatado = soma de (preço atual × estoque) de todos os produtos
  String get capitalEmpatado {
    if (products.isEmpty) return 'R\$ 0,00';
    
    double total = 0.0;
    for (final produto in products) {
      // Extrai o valor numérico do preço (remove "R$ " e converte vírgula para ponto)
      final precoStr = produto.precoAtual
          .replaceAll('R\$', '')
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .trim();
      final preco = double.tryParse(precoStr) ?? 0.0;
      total += preco * produto.estoque;
    }
    
    // Formata para moeda brasileira
    final formatter = total.toStringAsFixed(2).replaceAll('.', ',');
    final parts = formatter.split(',');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'R\$ $intPart,${parts[1]}';
  }
}

// ============================================================================
// AUTO CLEARANCE NOTIFIER
// ============================================================================

class AutoClearanceNotifier extends StateNotifier<AutoClearanceState> {
  final StrategiesRepository _repository;
  final String _storeId;

  AutoClearanceNotifier(this._repository, this._storeId) : super(const AutoClearanceState());

  /// Carrega dados do backend
  Future<void> loadFromBackend() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getPerformanceData(_storeId, type: 'liquidacao');
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final phasesList = data['phases'] ?? data['fases'] ?? [];
        final productsList = data['products'] ?? data['produtos'] ?? [];
        final categoriesList = data['categories'] ?? data['categorias'] ?? [];
        final phases = <ClearancePhaseModel>[];
        final products = <ClearanceProductModel>[];
        
        if (phasesList is List) {
          for (int i = 0; i < phasesList.length; i++) {
            final p = phasesList[i];
            phases.add(ClearancePhaseModel(
              id: p['id']?.toString() ?? (i + 1).toString(),
              fase: p['fase']?.toString() ?? 'Fase ${i + 1}',
              titulo: p['titulo']?.toString() ?? p['nome']?.toString() ?? p['name']?.toString() ?? 'Fase ${i + 1}',
              dias: p['dias'] ?? p['days'] ?? 7,
              desconto: (p['desconto'] ?? p['discount'] ?? 0).toDouble(),
              cor: _parseColor(p['cor'] ?? p['color']),
              icone: Icons.timer,
              descricao: p['descricao']?.toString() ?? p['description']?.toString() ?? '',
            ));
          }
        }
        
        if (productsList is List) {
          for (final pr in productsList) {
            products.add(ClearanceProductModel(
              id: pr['id']?.toString() ?? '',
              nome: pr['nome'] ?? pr['name'] ?? '',
              precoOriginal: pr['precoOriginal']?.toString() ?? pr['originalPrice']?.toString() ?? '',
              precoAtual: pr['precoAtual']?.toString() ?? pr['currentPrice']?.toString() ?? '',
              fase: pr['fase'] ?? pr['phase'] ?? 1,
              diasParado: pr['diasParado'] ?? pr['diasLiquidacao'] ?? pr['daysInClearance'] ?? 0,
              desconto: pr['desconto'] ?? pr['discount'] ?? 0,
              estoque: pr['estoque'] ?? pr['stock'] ?? 0,
            ));
          }
        }
        
        state = state.copyWith(
          isLoading: false,
          phases: phases,
          products: products,
          allCategories: categoriesList is List ? List<String>.from(categoriesList) : [],
          isStrategyActive: data['isActive'] ?? data['ativo'] ?? state.isStrategyActive,
          margemMinima: (data['margemMinima'] ?? data['minMargin'] ?? state.margemMinima).toDouble(),
          notificarLiquidacao: data['notificarLiquidacao'] ?? data['notifyClearance'] ?? state.notificarLiquidacao,
        );
      } else {
        state = state.copyWith(isLoading: false, phases: [], products: []);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Color _parseColor(dynamic colorValue) {
    if (colorValue == null) return const Color(0xFF2196F3);
    if (colorValue is String) {
      try {
        return Color(int.parse(colorValue.replaceFirst('#', '0xFF')));
      } catch (_) {
        return const Color(0xFF2196F3);
      }
    }
    return const Color(0xFF2196F3);
  }

  /// Atualiza o status ativo da estratégia
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

  /// Atualiza a margem mínima
  void setMargemMinima(double margem) {
    state = state.copyWith(margemMinima: margem);
  }

  /// Atualiza a notificação de liquidação
  void setNotificarLiquidacao(bool notificar) {
    state = state.copyWith(notificarLiquidacao: notificar);
  }

  /// Adiciona uma categoria
  void addCategory(String category) {
    if (!state.selectedCategories.contains(category)) {
      final updated = [...state.selectedCategories, category];
      state = state.copyWith(selectedCategories: updated);
    }
  }

  /// Remove uma categoria
  void removeCategory(String category) {
    final updated = state.selectedCategories.where((c) => c != category).toList();
    state = state.copyWith(selectedCategories: updated);
  }

  /// Toggle categoria (adiciona ou remove)
  void toggleCategory(String category) {
    if (state.selectedCategories.contains(category)) {
      removeCategory(category);
    } else {
      addCategory(category);
    }
  }

  /// Atualiza os dias de uma fase
  void updatePhaseDays(String phaseId, int dias) {
    final updatedPhases = state.phases.map((phase) {
      if (phase.id == phaseId) {
        return phase.copyWith(dias: dias);
      }
      return phase;
    }).toList();
    state = state.copyWith(phases: updatedPhases);
  }

  /// Atualiza o desconto de uma fase
  void updatePhaseDiscount(String phaseId, double desconto) {
    final updatedPhases = state.phases.map((phase) {
      if (phase.id == phaseId) {
        return phase.copyWith(desconto: desconto);
      }
      return phase;
    }).toList();
    state = state.copyWith(phases: updatedPhases);
  }

  /// Salva as configurações
  Future<void> saveConfigurations() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final clearanceStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.performance && 
                 (s.name.toLowerCase().contains('liquidação') || s.name.toLowerCase().contains('clearance')),
          orElse: () => throw Exception('Estratégia de liquidação não encontrada'),
        );
        
        await _repository.updateStrategyConfiguration(clearanceStrategy.id, {
          'phases': state.phases.map((p) => {
            'id': p.id,
            'fase': p.fase,
            'titulo': p.titulo,
            'dias': p.dias,
            'desconto': p.desconto,
          }).toList(),
          'isActive': state.isStrategyActive,
          'margemMinima': state.margemMinima,
          'notificarLiquidacao': state.notificarLiquidacao,
          'selectedCategories': state.selectedCategories,
        });
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Retorna a fase pelo índice
  ClearancePhaseModel? getPhaseByIndex(int index) {
    if (index >= 0 && index < state.phases.length) {
      return state.phases[index];
    }
    return null;
  }

  /// Retorna a fase de um produto
  ClearancePhaseModel? getPhaseForProduct(ClearanceProductModel product) {
    final phaseIndex = product.fase - 1;
    return getPhaseByIndex(phaseIndex);
  }
}

// ============================================================================
// PROVIDER
// ============================================================================

/// Provider para a estratégia de Liquidação Automática
final autoClearanceProvider = StateNotifierProvider<AutoClearanceNotifier, AutoClearanceState>(
  (ref) {
    final repository = ref.watch(performanceStrategiesRepositoryProvider);
    final currentStore = ref.watch(currentStoreProvider);
    final storeId = currentStore?.id ?? 'store-not-configured';
    return AutoClearanceNotifier(repository, storeId);
  },
);

// ============================================================================
// DYNAMIC MARKDOWN STATE
// ============================================================================

/// Estado da estratégia de Dynamic Markdown (Redução por Validade)
class DynamicMarkdownState {
  final List<MarkdownRuleModel> rules;
  final List<MarkdownProductModel> products;
  final List<String> selectedCategories;
  final List<String> allCategories;
  final bool isLoading;
  final String? error;
  final bool isStrategyActive;
  final bool fabExpanded;
  final bool apenasPereci;
  final bool notificarAjustes;

  const DynamicMarkdownState({
    this.rules = const [],
    this.products = const [],
    this.selectedCategories = const [],
    this.allCategories = const [],
    this.isLoading = false,
    this.error,
    this.isStrategyActive = true,
    this.fabExpanded = true,
    this.apenasPereci = true,
    this.notificarAjustes = true,
  });

  /// Estado inicial com carregamento
  factory DynamicMarkdownState.loading() => const DynamicMarkdownState(isLoading: true);

  /// Estado com erro
  factory DynamicMarkdownState.error(String message) => DynamicMarkdownState(error: message);

  /// Cria uma cópia com alterações
  DynamicMarkdownState copyWith({
    List<MarkdownRuleModel>? rules,
    List<MarkdownProductModel>? products,
    List<String>? selectedCategories,
    List<String>? allCategories,
    bool? isLoading,
    String? error,
    bool? isStrategyActive,
    bool? fabExpanded,
    bool? apenasPereci,
    bool? notificarAjustes,
  }) {
    return DynamicMarkdownState(
      rules: rules ?? this.rules,
      products: products ?? this.products,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      allCategories: allCategories ?? this.allCategories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isStrategyActive: isStrategyActive ?? this.isStrategyActive,
      fabExpanded: fabExpanded ?? this.fabExpanded,
      apenasPereci: apenasPereci ?? this.apenasPereci,
      notificarAjustes: notificarAjustes ?? this.notificarAjustes,
    );
  }

  /// Retorna o total de produtos com desconto
  int get totalProductsWithDiscount => products.length;
}

// ============================================================================
// DYNAMIC MARKDOWN NOTIFIER
// ============================================================================

class DynamicMarkdownNotifier extends StateNotifier<DynamicMarkdownState> {
  final StrategiesRepository _repository;
  final String _storeId;

  DynamicMarkdownNotifier(this._repository, this._storeId) : super(const DynamicMarkdownState());

  /// Carrega dados do backend
  Future<void> loadFromBackend() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getPerformanceData(_storeId, type: 'markdown');
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final rulesList = data['rules'] ?? data['regras'] ?? data['faixas'] ?? [];
        final productsList = data['products'] ?? data['produtos'] ?? [];
        final categoriesList = data['categories'] ?? data['categorias'] ?? [];
        final rules = <MarkdownRuleModel>[];
        final products = <MarkdownProductModel>[];
        
        if (rulesList is List) {
          for (final r in rulesList) {
            rules.add(MarkdownRuleModel(
              id: r['id']?.toString() ?? '',
              faixa: r['faixa']?.toString() ?? r['nome']?.toString() ?? r['name']?.toString() ?? '',
              desconto: (r['desconto'] ?? r['discount'] ?? 0).toDouble(),
              cor: _parseColor(r['cor'] ?? r['color']),
              icone: Icons.schedule,
              descricao: r['descricao']?.toString() ?? r['description']?.toString() ?? '',
            ));
          }
        }
        
        if (productsList is List) {
          for (final p in productsList) {
            products.add(MarkdownProductModel(
              id: p['id']?.toString() ?? '',
              nome: p['nome'] ?? p['name'] ?? '',
              validade: p['validade']?.toString() ?? p['expiry']?.toString() ?? '',
              diasRestantes: p['diasRestantes'] ?? p['daysRemaining'] ?? 0,
              desconto: p['descontoAtual'] ?? p['currentDiscount'] ?? 0,
              precoOriginal: p['precoOriginal']?.toString() ?? p['originalPrice']?.toString() ?? '',
              precoAtual: p['precoAtual']?.toString() ?? p['currentPrice']?.toString() ?? '',
            ));
          }
        }
        
        state = state.copyWith(
          isLoading: false,
          rules: rules,
          products: products,
          allCategories: categoriesList is List ? List<String>.from(categoriesList) : [],
          isStrategyActive: data['isActive'] ?? data['ativo'] ?? state.isStrategyActive,
          apenasPereci: data['apenasPereci'] ?? data['onlyPerishables'] ?? state.apenasPereci,
          notificarAjustes: data['notificarAjustes'] ?? data['notifyAdjustments'] ?? state.notificarAjustes,
        );
      } else {
        state = state.copyWith(isLoading: false, rules: [], products: []);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Color _parseColor(dynamic colorValue) {
    if (colorValue == null) return const Color(0xFF4CAF50);
    if (colorValue is String) {
      try {
        return Color(int.parse(colorValue.replaceFirst('#', '0xFF')));
      } catch (_) {
        return const Color(0xFF4CAF50);
      }
    }
    return const Color(0xFF4CAF50);
  }

  /// Atualiza o status ativo da estratégia
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

  /// Atualiza a opção "apenas perecíveis"
  void setApenasPereci(bool value) {
    state = state.copyWith(apenasPereci: value);
  }

  /// Atualiza a opção de notificar ajustes
  void setNotificarAjustes(bool value) {
    state = state.copyWith(notificarAjustes: value);
  }

  /// Atualiza o desconto de uma faixa
  void updateRuleDiscount(String ruleId, double desconto) {
    final updatedRules = state.rules.map((rule) {
      if (rule.id == ruleId) {
        return rule.copyWith(desconto: desconto);
      }
      return rule;
    }).toList();
    state = state.copyWith(rules: updatedRules);
  }

  /// Adiciona uma categoria
  void addCategory(String category) {
    if (!state.selectedCategories.contains(category)) {
      final updated = [...state.selectedCategories, category];
      state = state.copyWith(selectedCategories: updated);
    }
  }

  /// Remove uma categoria
  void removeCategory(String category) {
    final updated = state.selectedCategories.where((c) => c != category).toList();
    state = state.copyWith(selectedCategories: updated);
  }

  /// Toggle categoria (adiciona ou remove)
  void toggleCategory(String category) {
    if (state.selectedCategories.contains(category)) {
      removeCategory(category);
    } else {
      addCategory(category);
    }
  }

  /// Salva as configurações
  Future<void> saveConfigurations() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final markdownStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.performance && 
                 (s.name.toLowerCase().contains('markdown') || s.name.toLowerCase().contains('validade')),
          orElse: () => throw Exception('Estratégia de markdown não encontrada'),
        );
        
        await _repository.updateStrategyConfiguration(markdownStrategy.id, {
          'rules': state.rules.map((r) => {
            'id': r.id,
            'faixa': r.faixa,
            'desconto': r.desconto,
            'descricao': r.descricao,
          }).toList(),
          'isActive': state.isStrategyActive,
          'apenasPereci': state.apenasPereci,
          'notificarAjustes': state.notificarAjustes,
          'selectedCategories': state.selectedCategories,
        });
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Retorna a regra pelo ID
  MarkdownRuleModel? getRuleById(String id) {
    try {
      return state.rules.firstWhere((rule) => rule.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Retorna a regra pelo índice
  MarkdownRuleModel? getRuleByIndex(int index) {
    if (index >= 0 && index < state.rules.length) {
      return state.rules[index];
    }
    return null;
  }
}

// ============================================================================
// PROVIDER
// ============================================================================

/// Provider para a estratégia de Dynamic Markdown (Redução por Validade)
final dynamicMarkdownProvider = StateNotifierProvider<DynamicMarkdownNotifier, DynamicMarkdownState>(
  (ref) {
    final repository = ref.watch(performanceStrategiesRepositoryProvider);
    final currentStore = ref.watch(currentStoreProvider);
    final storeId = currentStore?.id ?? 'store-not-configured';
    return DynamicMarkdownNotifier(repository, storeId);
  },
);

// ============================================================================
// AI FORECAST STATE
// ============================================================================

/// Estado da estratégia de Previsão com IA
class AIForecastState {
  final List<ForecastPredictionModel> predictions;
  final List<ForecastFactorModel> factors;
  final ForecastModelStatus? modelStatus;
  final bool isLoading;
  final String? error;
  final bool motorAtivo;
  final bool fabExpanded;
  final int periodoHistorico;
  final double nivelConfianca;
  final bool isTraining;

  const AIForecastState({
    this.predictions = const [],
    this.factors = const [],
    this.modelStatus,
    this.isLoading = false,
    this.error,
    this.motorAtivo = true,
    this.fabExpanded = true,
    this.periodoHistorico = 90,
    this.nivelConfianca = 75.0,
    this.isTraining = false,
  });

  /// Estado inicial com carregamento
  factory AIForecastState.loading() => const AIForecastState(isLoading: true);

  /// Estado com erro
  factory AIForecastState.error(String message) => AIForecastState(error: message);

  /// Cria uma cópia com alterações
  AIForecastState copyWith({
    List<ForecastPredictionModel>? predictions,
    List<ForecastFactorModel>? factors,
    ForecastModelStatus? modelStatus,
    bool? isLoading,
    String? error,
    bool? motorAtivo,
    bool? fabExpanded,
    int? periodoHistorico,
    double? nivelConfianca,
    bool? isTraining,
  }) {
    return AIForecastState(
      predictions: predictions ?? this.predictions,
      factors: factors ?? this.factors,
      modelStatus: modelStatus ?? this.modelStatus,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      motorAtivo: motorAtivo ?? this.motorAtivo,
      fabExpanded: fabExpanded ?? this.fabExpanded,
      periodoHistorico: periodoHistorico ?? this.periodoHistorico,
      nivelConfianca: nivelConfianca ?? this.nivelConfianca,
      isTraining: isTraining ?? this.isTraining,
    );
  }

  /// Retorna o total de previsões
  int get totalPredictions => predictions.length;
  
  /// Aliases para compatibilidade com telas em inglês
  bool get isEngineActive => motorAtivo;
  int get historicalPeriod => periodoHistorico;
  double get confidenceLevel => nivelConfianca;

  /// Retorna a soma dos pesos dos fatores
  double get totalFactorWeight => factors.fold(0.0, (sum, f) => sum + f.peso);

  /// Retorna a soma formatada dos pesos
  String get totalFactorWeightFormatted => '${totalFactorWeight.toStringAsFixed(0)}%';

  /// Retorna o período formatado
  String get periodoFormatted => '$periodoHistorico dias';

  /// Retorna o nível de confiança formatado
  String get nivelConfiancaFormatted => '${nivelConfianca.toStringAsFixed(0)}%';
}

// ============================================================================
// AI FORECAST NOTIFIER
// ============================================================================

class AIForecastNotifier extends StateNotifier<AIForecastState> {
  final StrategiesRepository _repository;
  final String _storeId;

  AIForecastNotifier(this._repository, this._storeId) : super(const AIForecastState());

  /// Carrega dados do backend
  Future<void> loadFromBackend() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getPerformanceData(_storeId, type: 'previsao');
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final predictionsList = data['predictions'] ?? data['previsoes'] ?? [];
        final factorsList = data['factors'] ?? data['fatores'] ?? [];
        final predictions = <ForecastPredictionModel>[];
        final factors = <ForecastFactorModel>[];
        
        if (predictionsList is List) {
          for (final p in predictionsList) {
            predictions.add(ForecastPredictionModel(
              id: p['id']?.toString() ?? '',
              nome: p['nome']?.toString() ?? p['produtoNome']?.toString() ?? p['productName']?.toString() ?? '',
              vendasAtuais: p['vendasAtuais'] ?? p['currentSales'] ?? 0,
              previsao: p['previsao'] ?? p['demandaPrevista'] ?? p['predictedDemand'] ?? 0,
              confianca: ((p['confianca'] ?? p['confidence'] ?? 0) * 1).toInt(),
              tendencia: ForecastTrend.fromString(p['tendencia']?.toString() ?? p['trend']?.toString() ?? 'estavel'),
              cor: const Color(0xFF2196F3),
              impacto: p['impacto']?.toString() ?? 'R\$ 0',
              elasticidade: p['elasticidade']?.toString() ?? 'Média',
            ));
          }
        }
        
        if (factorsList is List) {
          for (final f in factorsList) {
            factors.add(ForecastFactorModel(
              id: f['id']?.toString() ?? '',
              nome: f['nome'] ?? f['name'] ?? '',
              peso: (f['peso'] ?? f['weight'] ?? 0).toDouble(),
              cor: const Color(0xFF2196F3),
              icone: Icons.analytics,
              descricao: f['descricao']?.toString() ?? f['description']?.toString() ?? '',
            ));
          }
        }
        
        ForecastModelStatus? modelStatus;
        if (data['modelStatus'] != null) {
          final ms = data['modelStatus'];
          modelStatus = ForecastModelStatus(
            isActive: ms['isActive'] ?? ms['ativo'] ?? false,
            isTrained: ms['isTrained'] ?? ms['treinado'] ?? false,
            lastTraining: ms['lastTraining']?.toString() ?? ms['ultimoTreinamento']?.toString() ?? 'Nunca',
            precision: (ms['precision'] ?? ms['precisao'] ?? 0).toDouble(),
            totalProducts: ms['totalProducts'] ?? ms['totalProdutos'] ?? 0,
            totalPredictions: ms['totalPredictions'] ?? ms['totalPrevisoes'] ?? 0,
          );
        }
        
        state = state.copyWith(
          isLoading: false,
          predictions: predictions,
          factors: factors,
          modelStatus: modelStatus,
          motorAtivo: data['motorAtivo'] ?? data['engineActive'] ?? state.motorAtivo,
          periodoHistorico: data['periodoHistorico'] ?? data['historicalPeriod'] ?? state.periodoHistorico,
          nivelConfianca: (data['nivelConfianca'] ?? data['confidenceLevel'] ?? state.nivelConfianca).toDouble(),
        );
      } else {
        state = state.copyWith(isLoading: false, predictions: [], factors: []);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Atualiza o status do motor de IA
  void setMotorAtivo(bool isActive) {
    state = state.copyWith(motorAtivo: isActive);
  }
  
  /// Alias para setMotorAtivo (compatibilidade inglês)
  void setEngineActive(bool isActive) => setMotorAtivo(isActive);

  /// Atualiza o estado expandido do FAB
  void toggleFabExpanded() {
    state = state.copyWith(fabExpanded: !state.fabExpanded);
  }

  /// Define o estado do FAB
  void setFabExpanded(bool expanded) {
    state = state.copyWith(fabExpanded: expanded);
  }

  /// Atualiza o período histórico
  void setPeriodoHistorico(int periodo) {
    state = state.copyWith(periodoHistorico: periodo);
  }
  
  /// Alias para setPeriodoHistorico (compatibilidade inglês)
  void setHistoricalPeriod(int period) => setPeriodoHistorico(period);

  /// Atualiza o nível de confiança
  void setNivelConfianca(double nivel) {
    state = state.copyWith(nivelConfianca: nivel);
  }
  
  /// Alias para setNivelConfianca (compatibilidade inglês)
  void setConfidenceLevel(double level) => setNivelConfianca(level);

  /// Atualiza o peso de um fator
  void updateFactorWeight(String factorId, double peso) {
    final updatedFactors = state.factors.map((factor) {
      if (factor.id == factorId) {
        return factor.copyWith(peso: peso);
      }
      return factor;
    }).toList();
    state = state.copyWith(factors: updatedFactors);
  }

  /// Atualiza o peso de um fator pelo nome
  void updateFactorWeightByName(String factorName, double peso) {
    final updatedFactors = state.factors.map((factor) {
      if (factor.nome == factorName) {
        return factor.copyWith(peso: peso);
      }
      return factor;
    }).toList();
    state = state.copyWith(factors: updatedFactors);
  }

  /// Inicia o treinamento do modelo
  Future<void> startTraining() async {
    state = state.copyWith(isTraining: true);
    
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final forecastStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.performance && 
                 (s.name.toLowerCase().contains('previsão') || s.name.toLowerCase().contains('forecast') || s.name.toLowerCase().contains('ia')),
          orElse: () => throw Exception('Estratégia de previsão não encontrada'),
        );
        
        // Executa estratégia para treinar o modelo
        await _repository.executeStrategy(forecastStrategy.id);
        
        // Recarrega dados para obter o novo status do modelo
        await loadFromBackend();
      }
    } catch (e) {
      state = state.copyWith(isTraining: false, error: e.toString());
    }
  }
  
  /// Finaliza o treinamento (alias)
  Future<void> finishTraining() async {
    state = state.copyWith(isTraining: false);
  }

  /// Salva as configurações
  Future<void> saveConfigurations() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final forecastStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.performance && 
                 (s.name.toLowerCase().contains('previsão') || s.name.toLowerCase().contains('forecast') || s.name.toLowerCase().contains('ia')),
          orElse: () => throw Exception('Estratégia de previsão não encontrada'),
        );
        
        await _repository.updateStrategyConfiguration(forecastStrategy.id, {
          'motorAtivo': state.motorAtivo,
          'periodoHistorico': state.periodoHistorico,
          'nivelConfianca': state.nivelConfianca,
          'factors': state.factors.map((f) => {
            'id': f.id,
            'nome': f.nome,
            'peso': f.peso,
          }).toList(),
        });
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Retorna o fator pelo ID
  ForecastFactorModel? getFactorById(String id) {
    try {
      return state.factors.firstWhere((factor) => factor.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Retorna a previsão pelo ID
  ForecastPredictionModel? getPredictionById(String id) {
    try {
      return state.predictions.firstWhere((pred) => pred.id == id);
    } catch (_) {
      return null;
    }
  }
}

// ============================================================================
// PROVIDER
// ============================================================================

/// Provider para a estratégia de Previsão com IA
final aiForecastProvider = StateNotifierProvider<AIForecastNotifier, AIForecastState>(
  (ref) {
    final repository = ref.watch(performanceStrategiesRepositoryProvider);
    final currentStore = ref.watch(currentStoreProvider);
    final storeId = currentStore?.id ?? 'store-not-configured';
    return AIForecastNotifier(repository, storeId);
  },
);

// ============================================================================
// AUTO AUDIT STATE
// ============================================================================

/// Estado da estratégia de Auditoria Automática
class AutoAuditState {
  final Map<String, bool> verificacoes;
  final List<String> emailsAlertas;
  final List<AuditRecordModel> ultimasAuditorias;
  final bool isLoading;
  final String? error;
  final bool auditoriaAtiva;
  final bool fabExpanded;
  final TimeOfDay horarioExecucao;
  final bool executando;

  const AutoAuditState({
    this.verificacoes = const {},
    this.emailsAlertas = const [],
    this.ultimasAuditorias = const [],
    this.isLoading = false,
    this.error,
    this.auditoriaAtiva = true,
    this.fabExpanded = true,
    this.horarioExecucao = const TimeOfDay(hour: 6, minute: 0),
    this.executando = false,
  });

  /// Estado inicial com carregamento
  factory AutoAuditState.loading() => const AutoAuditState(isLoading: true);

  /// Estado com erro
  factory AutoAuditState.error(String message) => AutoAuditState(error: message);

  /// Cria uma cópia com alterações
  AutoAuditState copyWith({
    Map<String, bool>? verificacoes,
    List<String>? emailsAlertas,
    List<AuditRecordModel>? ultimasAuditorias,
    bool? isLoading,
    String? error,
    bool? auditoriaAtiva,
    bool? fabExpanded,
    TimeOfDay? horarioExecucao,
    bool? executando,
  }) {
    return AutoAuditState(
      verificacoes: verificacoes ?? this.verificacoes,
      emailsAlertas: emailsAlertas ?? this.emailsAlertas,
      ultimasAuditorias: ultimasAuditorias ?? this.ultimasAuditorias,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      auditoriaAtiva: auditoriaAtiva ?? this.auditoriaAtiva,
      fabExpanded: fabExpanded ?? this.fabExpanded,
      horarioExecucao: horarioExecucao ?? this.horarioExecucao,
      executando: executando ?? this.executando,
    );
  }

  /// Retorna o total de verificações ativas
  int get totalVerificacoesAtivas => verificacoes.values.where((v) => v).length;

  /// Retorna o total de verificações
  int get totalVerificacoes => verificacoes.length;

  /// Retorna o horário formatado
  String formatHorario(BuildContext context) => horarioExecucao.format(context);
}

// ============================================================================
// AUTO AUDIT NOTIFIER
// ============================================================================

class AutoAuditNotifier extends StateNotifier<AutoAuditState> {
  final StrategiesRepository _repository;
  final String _storeId;

  AutoAuditNotifier(this._repository, this._storeId) : super(const AutoAuditState());

  /// Carrega dados do backend
  Future<void> loadFromBackend() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getPerformanceData(_storeId, type: 'auditoria');
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final verificacoesMap = data['verificacoes'] ?? data['checks'] ?? {};
        final emailsList = data['emailsAlertas'] ?? data['alertEmails'] ?? [];
        final auditoriasList = data['ultimasAuditorias'] ?? data['recentAudits'] ?? [];
        
        Map<String, bool> verificacoes = {};
        if (verificacoesMap is Map) {
          verificacoesMap.forEach((key, value) {
            verificacoes[key.toString()] = value == true;
          });
        }
        
        final ultimasAuditorias = <AuditRecordModel>[];
        if (auditoriasList is List) {
          for (final a in auditoriasList) {
            ultimasAuditorias.add(AuditRecordModel(
              id: a['id']?.toString() ?? '',
              data: a['data']?.toString() ?? a['date']?.toString() ?? '',
              problemas: a['problemas'] ?? a['issues'] ?? 0,
              status: a['status']?.toString() ?? 'concluido',
              cor: const Color(0xFF4CAF50),
              detalhes: a['detalhes']?.toString() ?? a['details']?.toString() ?? '',
              duracao: a['duracao']?.toString() ?? a['duration']?.toString() ?? '',
              acoes: a['acoes']?.toString() ?? a['actions']?.toString() ?? '',
            ));
          }
        }
        
        TimeOfDay horario = state.horarioExecucao;
        if (data['horarioExecucao'] != null || data['executionTime'] != null) {
          final horarioStr = data['horarioExecucao'] ?? data['executionTime'];
          if (horarioStr is String && horarioStr.contains(':')) {
            final parts = horarioStr.split(':');
            horario = TimeOfDay(
              hour: int.tryParse(parts[0]) ?? 6,
              minute: int.tryParse(parts[1]) ?? 0,
            );
          }
        }
        
        state = state.copyWith(
          isLoading: false,
          verificacoes: verificacoes,
          emailsAlertas: emailsList is List ? List<String>.from(emailsList) : [],
          ultimasAuditorias: ultimasAuditorias,
          auditoriaAtiva: data['auditoriaAtiva'] ?? data['auditActive'] ?? state.auditoriaAtiva,
          horarioExecucao: horario,
        );
      } else {
        state = state.copyWith(isLoading: false, ultimasAuditorias: []);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Atualiza o status ativo da auditoria
  void setAuditoriaAtiva(bool isActive) {
    state = state.copyWith(auditoriaAtiva: isActive);
  }

  /// Atualiza o estado expandido do FAB
  void toggleFabExpanded() {
    state = state.copyWith(fabExpanded: !state.fabExpanded);
  }

  /// Define o estado do FAB
  void setFabExpanded(bool expanded) {
    state = state.copyWith(fabExpanded: expanded);
  }

  /// Atualiza o horário de execução
  void setHorarioExecucao(TimeOfDay horario) {
    state = state.copyWith(horarioExecucao: horario);
  }

  /// Atualiza uma verificação
  void setVerificacao(String verificacao, bool valor) {
    final updated = Map<String, bool>.from(state.verificacoes);
    updated[verificacao] = valor;
    state = state.copyWith(verificacoes: updated);
  }

  /// Adiciona um email de alerta
  void addEmail(String email) {
    if (email.isNotEmpty && email.contains('@') && !state.emailsAlertas.contains(email)) {
      final updated = [...state.emailsAlertas, email];
      state = state.copyWith(emailsAlertas: updated);
    }
  }

  /// Remove um email de alerta
  void removeEmail(String email) {
    final updated = state.emailsAlertas.where((e) => e != email).toList();
    state = state.copyWith(emailsAlertas: updated);
  }

  /// Define o estado de execução
  void setExecutando(bool executando) {
    state = state.copyWith(executando: executando);
  }

  /// Executa auditoria manualmente
  Future<void> executarAuditoria() async {
    state = state.copyWith(executando: true);
    
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final auditStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.performance && 
                 (s.name.toLowerCase().contains('auditoria') || s.name.toLowerCase().contains('audit')),
          orElse: () => throw Exception('Estratégia de auditoria não encontrada'),
        );
        
        await _repository.executeStrategy(auditStrategy.id);
        await loadFromBackend();
      }
    } catch (e) {
      state = state.copyWith(executando: false, error: e.toString());
    }
    
    state = state.copyWith(executando: false);
  }

  /// Salva as configurações
  Future<void> saveConfigurations() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final auditStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.performance && 
                 (s.name.toLowerCase().contains('auditoria') || s.name.toLowerCase().contains('audit')),
          orElse: () => throw Exception('Estratégia de auditoria não encontrada'),
        );
        
        await _repository.updateStrategyConfiguration(auditStrategy.id, {
          'auditoriaAtiva': state.auditoriaAtiva,
          'horarioExecucao': '${state.horarioExecucao.hour.toString().padLeft(2, '0')}:${state.horarioExecucao.minute.toString().padLeft(2, '0')}',
          'verificacoes': state.verificacoes,
          'emailsAlertas': state.emailsAlertas,
        });
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Retorna o ícone para uma verificação
  IconData getIconForVerificacao(String verificacao) {
    switch (verificacao) {
      case 'Margens Negativas':
        return Icons.money_off_rounded;
      case 'Produtos Sem Movimento':
        return Icons.inventory_rounded;
      case 'Preços Abaixo do Custo':
        return Icons.trending_down_rounded;
      case 'Tags Offline':
        return Icons.wifi_off_rounded;
      case 'Divergências de Estoque':
        return Icons.difference_rounded;
      case 'Produtos Sem Tag':
        return Icons.label_off_rounded;
      case 'Validades Vencidas':
        return Icons.event_busy_rounded;
      case 'Estoque Zerado':
        return Icons.inventory_2_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }
}

// ============================================================================
// PROVIDER
// ============================================================================

/// Provider para a estratégia de Auditoria Automática
final autoAuditProvider = StateNotifierProvider<AutoAuditNotifier, AutoAuditState>(
  (ref) {
    final repository = ref.watch(performanceStrategiesRepositoryProvider);
    final currentStore = ref.watch(currentStoreProvider);
    final storeId = currentStore?.id ?? 'store-not-configured';
    return AutoAuditNotifier(repository, storeId);
  },
);



