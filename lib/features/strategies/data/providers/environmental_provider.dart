import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/features/strategies/data/repositories/strategies_repository.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

// ============================================================================
// REPOSITORY PROVIDER
// ============================================================================

/// Provider do StrategiesRepository para estratégias ambientais
final environmentalStrategiesRepositoryProvider = Provider<StrategiesRepository>((ref) {
  return StrategiesRepository();
});

// ============================================================================
// TEMPERATURE STATE
// ============================================================================

/// Estado da estratgia de temperatura
class TemperatureState {
  final List<TemperatureRangeModel> temperatureRanges;
  final List<TemperatureHistoryModel> history;
  final bool isLoading;
  final String? error;
  final bool isStrategyActive;
  final bool isConnected;
  final bool fabExpanded;
  final String apiKey;
  final String city;
  final double currentTemperature;
  final String currentCondition;
  final String selectedFrequency;

  const TemperatureState({
    this.temperatureRanges = const [],
    this.history = const [],
    this.isLoading = false,
    this.error,
    this.isStrategyActive = true,
    this.isConnected = false,
    this.fabExpanded = true,
    this.apiKey = '',
    this.city = 'So Paulo',
    this.currentTemperature = 28.5,
    this.currentCondition = 'Ensolarado',
    this.selectedFrequency = '30 min',
  });

  /// Estado inicial com carregamento
  factory TemperatureState.loading() => const TemperatureState(isLoading: true);

  /// Estado com erro
  factory TemperatureState.error(String message) => TemperatureState(error: message);

  /// Cria uma cpia com alterações
  TemperatureState copyWith({
    List<TemperatureRangeModel>? temperatureRanges,
    List<TemperatureHistoryModel>? history,
    bool? isLoading,
    String? error,
    bool? isStrategyActive,
    bool? isConnected,
    bool? fabExpanded,
    String? apiKey,
    String? city,
    double? currentTemperature,
    String? currentCondition,
    String? selectedFrequency,
  }) {
    return TemperatureState(
      temperatureRanges: temperatureRanges ?? this.temperatureRanges,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isStrategyActive: isStrategyActive ?? this.isStrategyActive,
      isConnected: isConnected ?? this.isConnected,
      fabExpanded: fabExpanded ?? this.fabExpanded,
      apiKey: apiKey ?? this.apiKey,
      city: city ?? this.city,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      currentCondition: currentCondition ?? this.currentCondition,
      selectedFrequency: selectedFrequency ?? this.selectedFrequency,
    );
  }

  /// Retorna a contagem de faixas com ajuste
  int get activeRangesCount => temperatureRanges.where((r) => r.adjustment != 0).length;

  /// Retorna a temperatura formatada
  String get temperatureFormatted => '${currentTemperature.toStringAsFixed(1)}C';
}

// ============================================================================
// TEMPERATURE NOTIFIER
// ============================================================================

class TemperatureNotifier extends StateNotifier<TemperatureState> {
  final StrategiesRepository _repository;
  final String _storeId;

  TemperatureNotifier(this._repository, this._storeId) : super(const TemperatureState());

  /// Carrega dados do backend
  Future<void> loadFromBackend() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getEnvironmentalData(_storeId, type: 'temperatura');
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final rangesList = data['ranges'] ?? data['faixas'] ?? [];
        final historyList = data['history'] ?? data['historico'] ?? [];
        final ranges = <TemperatureRangeModel>[];
        final history = <TemperatureHistoryModel>[];
        
        if (rangesList is List) {
          for (final r in rangesList) {
            ranges.add(TemperatureRangeModel(
              id: r['id']?.toString() ?? '',
              range: r['range']?.toString() ?? r['faixa']?.toString() ?? '',
              title: r['title']?.toString() ?? r['titulo']?.toString() ?? r['name']?.toString() ?? r['nome']?.toString() ?? '',
              adjustment: (r['adjustment'] ?? r['ajuste'] ?? 0).toDouble(),
              products: r['products'] is List 
                  ? List<String>.from(r['products']) 
                  : (r['produtos'] is List ? List<String>.from(r['produtos']) : []),
              icon: Icons.thermostat,
              color: _parseColor(r['color'] ?? r['cor']),
              description: r['description']?.toString() ?? r['descricao']?.toString() ?? '',
            ));
          }
        }
        
        if (historyList is List) {
          for (final item in historyList) {
            history.add(TemperatureHistoryModel(
              id: item['id']?.toString() ?? '',
              dateTime: item['dateTime']?.toString() ?? item['date']?.toString() ?? item['data']?.toString() ?? '',
              temperature: item['temperature']?.toString() ?? item['temperatura']?.toString() ?? '',
              adjustmentsCount: item['adjustmentsCount'] ?? item['produtosAfetados'] ?? 0,
              status: item['status']?.toString() ?? 'ok',
            ));
          }
        }
        
        state = state.copyWith(
          isLoading: false,
          temperatureRanges: ranges,
          history: history,
          isStrategyActive: data['isActive'] ?? data['ativo'] ?? state.isStrategyActive,
          isConnected: data['isConnected'] ?? data['conectado'] ?? state.isConnected,
          apiKey: data['apiKey'] ?? data['chaveApi'] ?? state.apiKey,
          city: data['city'] ?? data['cidade'] ?? state.city,
          currentTemperature: (data['currentTemperature'] ?? data['temperaturaAtual'] ?? state.currentTemperature).toDouble(),
          currentCondition: data['currentCondition'] ?? data['condicaoAtual'] ?? state.currentCondition,
          selectedFrequency: data['selectedFrequency'] ?? data['frequenciaSelecionada'] ?? state.selectedFrequency,
        );
      } else {
        state = state.copyWith(isLoading: false, temperatureRanges: [], history: []);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Color _parseColor(dynamic colorValue) {
    if (colorValue == null) return AppThemeColors.primary;
    if (colorValue is String) {
      try {
        return Color(int.parse(colorValue.replaceFirst('#', '0xFF')));
      } catch (_) {
        return AppThemeColors.primary;
      }
    }
    return AppThemeColors.primary;
  }

  /// Atualiza o status ativo da estratgia
  void setStrategyActive(bool isActive) {
    state = state.copyWith(isStrategyActive: isActive);
  }

  /// Atualiza o status de conexo
  void setConnected(bool isConnected) {
    state = state.copyWith(isConnected: isConnected);
  }

  /// Atualiza o estado expandido do FAB
  void toggleFabExpanded() {
    state = state.copyWith(fabExpanded: !state.fabExpanded);
  }

  /// Define o estado do FAB
  void setFabExpanded(bool expanded) {
    state = state.copyWith(fabExpanded: expanded);
  }

  /// Atualiza a chave da API
  void setApiKey(String apiKey) {
    state = state.copyWith(apiKey: apiKey);
  }

  /// Atualiza a cidade
  void setCity(String city) {
    state = state.copyWith(city: city);
  }

  /// Atualiza a temperatura atual
  void setCurrentTemperature(double temperature) {
    state = state.copyWith(currentTemperature: temperature);
  }

  /// Atualiza a condição atual
  void setCurrentCondition(String condition) {
    state = state.copyWith(currentCondition: condition);
  }

  /// Atualiza a frequncia selecionada
  void setSelectedFrequency(String frequency) {
    state = state.copyWith(selectedFrequency: frequency);
  }

  /// Atualiza o ajuste de uma faixa de temperatura
  void updateRangeAdjustment(String rangeId, double adjustment) {
    final updatedRanges = state.temperatureRanges.map((range) {
      if (range.id == rangeId) {
        return range.copyWith(adjustment: adjustment);
      }
      return range;
    }).toList();
    state = state.copyWith(temperatureRanges: updatedRanges);
  }

  /// Testa a conexo com a API de temperatura
  /// Retorna true se a conexo for bem-sucedida
  Future<bool> testConnection() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final tempStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.environmental && 
                 s.name.toLowerCase().contains('temperatura'),
          orElse: () => throw Exception('Estratgia de temperatura não encontrada'),
        );
        
        // Executa a estratgia para testar conexo
        final result = await _repository.executeStrategy(tempStrategy.id);
        state = state.copyWith(isLoading: false, isConnected: result.isSuccess);
        return result.isSuccess;
      }
      state = state.copyWith(isLoading: false, isConnected: false);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, isConnected: false, error: e.toString());
      return false;
    }
  }

  /// Salva as configurações
  Future<bool> saveConfigurations() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final tempStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.environmental && 
                 s.name.toLowerCase().contains('temperatura'),
          orElse: () => throw Exception('Estratgia de temperatura não encontrada'),
        );
        
        await _repository.updateStrategyConfiguration(tempStrategy.id, {
          'ranges': state.temperatureRanges.map((r) => {
            'id': r.id,
            'title': r.title,
            'range': r.range,
            'adjustment': r.adjustment,
            'products': r.products,
          }).toList(),
          'isActive': state.isStrategyActive,
          'apiKey': state.apiKey,
          'city': state.city,
          'selectedFrequency': state.selectedFrequency,
        });
      }
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Recarrega os dados
  Future<void> refresh() async {
    await loadFromBackend();
  }
}

// ============================================================================
// PROVIDERS
// ============================================================================

/// Provider para o estado de temperatura
final temperatureProvider =
    StateNotifierProvider<TemperatureNotifier, TemperatureState>(
  (ref) {
    final repository = ref.watch(environmentalStrategiesRepositoryProvider);
    final currentStore = ref.watch(currentStoreProvider);
    final storeId = currentStore?.id ?? 'store-not-configured';
    return TemperatureNotifier(repository, storeId);
  },
);

// ============================================================================
// PEAK HOURS STATE
// ============================================================================

/// Estado da estratgia de horrio de pico
class PeakHoursState {
  final List<PeakHourModel> peakHours;
  final List<WeekDayModel> weekDays;
  final List<PeakHourHistoryModel> history;
  final bool isLoading;
  final String? error;
  final bool isStrategyActive;
  final bool fabExpanded;
  final bool aplicarFinaisSemana;
  final bool notificarAjustes;

  const PeakHoursState({
    this.peakHours = const [],
    this.weekDays = const [],
    this.history = const [],
    this.isLoading = false,
    this.error,
    this.isStrategyActive = true,
    this.fabExpanded = true,
    this.aplicarFinaisSemana = true,
    this.notificarAjustes = false,
  });

  /// Estado inicial com carregamento
  factory PeakHoursState.loading() => const PeakHoursState(isLoading: true);

  /// Estado com erro
  factory PeakHoursState.error(String message) => PeakHoursState(error: message);

  /// Cria uma cpia com alterações
  PeakHoursState copyWith({
    List<PeakHourModel>? peakHours,
    List<WeekDayModel>? weekDays,
    List<PeakHourHistoryModel>? history,
    bool? isLoading,
    String? error,
    bool? isStrategyActive,
    bool? fabExpanded,
    bool? aplicarFinaisSemana,
    bool? notificarAjustes,
  }) {
    return PeakHoursState(
      peakHours: peakHours ?? this.peakHours,
      weekDays: weekDays ?? this.weekDays,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isStrategyActive: isStrategyActive ?? this.isStrategyActive,
      fabExpanded: fabExpanded ?? this.fabExpanded,
      aplicarFinaisSemana: aplicarFinaisSemana ?? this.aplicarFinaisSemana,
      notificarAjustes: notificarAjustes ?? this.notificarAjustes,
    );
  }

  /// Retorna a contagem de perodos com ajuste
  int get activePeriodsCount => peakHours.where((p) => p.ajuste != 0).length;

  /// Retorna a contagem de dias ativos
  int get activeDaysCount => weekDays.where((d) => d.ativo).length;
}

// ============================================================================
// PEAK HOURS NOTIFIER
// ============================================================================

class PeakHoursNotifier extends StateNotifier<PeakHoursState> {
  final StrategiesRepository _repository;
  final String _storeId;

  PeakHoursNotifier(this._repository, this._storeId) : super(const PeakHoursState());

  /// Carrega dados do backend
  Future<void> loadFromBackend() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getEnvironmentalData(_storeId, type: 'horario-pico');
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final peakHoursList = data['peakHours'] ?? data['horarios'] ?? [];
        final weekDaysList = data['weekDays'] ?? data['diasSemana'] ?? [];
        final historyList = data['history'] ?? data['historico'] ?? [];
        final peakHours = <PeakHourModel>[];
        final weekDays = <WeekDayModel>[];
        final history = <PeakHourHistoryModel>[];
        
        if (peakHoursList is List) {
          for (final p in peakHoursList) {
            peakHours.add(PeakHourModel(
              id: p['id']?.toString() ?? '',
              periodo: p['periodo']?.toString() ?? p['name']?.toString() ?? p['nome']?.toString() ?? '',
              horario: p['horario']?.toString() ?? '${p['startTime'] ?? p['horaInicio'] ?? '00:00'} - ${p['endTime'] ?? p['horaFim'] ?? '00:00'}',
              tipo: p['tipo']?.toString() ?? 'pico',
              ajuste: (p['ajuste'] ?? p['adjustment'] ?? 0).toDouble(),
              icone: Icons.access_time,
              cor: _parseColor(p['color'] ?? p['cor']),
              descricao: p['descricao']?.toString() ?? p['description']?.toString() ?? '',
              produtos: p['produtos'] is List 
                  ? List<String>.from(p['produtos']) 
                  : (p['products'] is List ? List<String>.from(p['products']) : []),
            ));
          }
        }
        
        if (weekDaysList is List) {
          for (final d in weekDaysList) {
            weekDays.add(WeekDayModel(
              id: d['id']?.toString() ?? '',
              dia: d['dia']?.toString() ?? d['name']?.toString() ?? d['nome']?.toString() ?? '',
              movimento: (d['movimento'] ?? 0).toDouble(),
              ativo: d['ativo'] ?? d['active'] ?? false,
            ));
          }
        }
        
        if (historyList is List) {
          for (final item in historyList) {
            history.add(PeakHourHistoryModel(
              id: item['id']?.toString() ?? '',
              data: item['data']?.toString() ?? item['date']?.toString() ?? '',
              periodo: item['periodo']?.toString() ?? item['period']?.toString() ?? '',
              ajustes: item['ajustes'] ?? item['adjustmentsCount'] ?? item['produtosAfetados'] ?? 0,
              tipo: item['tipo']?.toString() ?? 'pico',
            ));
          }
        }
        
        state = state.copyWith(
          isLoading: false,
          peakHours: peakHours,
          weekDays: weekDays,
          history: history,
          isStrategyActive: data['isActive'] ?? data['ativo'] ?? state.isStrategyActive,
          aplicarFinaisSemana: data['aplicarFinaisSemana'] ?? data['applyWeekends'] ?? state.aplicarFinaisSemana,
          notificarAjustes: data['notificarAjustes'] ?? data['notifyAdjustments'] ?? state.notificarAjustes,
        );
      } else {
        state = state.copyWith(isLoading: false, peakHours: [], weekDays: [], history: []);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Color _parseColor(dynamic colorValue) {
    if (colorValue == null) return AppThemeColors.orangeMaterial;
    if (colorValue is String) {
      try {
        return Color(int.parse(colorValue.replaceFirst('#', '0xFF')));
      } catch (_) {
        return AppThemeColors.orangeMaterial;
      }
    }
    return AppThemeColors.orangeMaterial;
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

  /// Atualiza a opção de aplicar em finais de semana
  void setAplicarFinaisSemana(bool value) {
    state = state.copyWith(aplicarFinaisSemana: value);
  }

  /// Atualiza a opção de notificar ajustes
  void setNotificarAjustes(bool value) {
    state = state.copyWith(notificarAjustes: value);
  }

  /// Atualiza o status ativo de um dia da semana
  void setWeekDayActive(String dayId, bool isActive) {
    final updatedDays = state.weekDays.map((day) {
      if (day.id == dayId) {
        return day.copyWith(ativo: isActive);
      }
      return day;
    }).toList();
    state = state.copyWith(weekDays: updatedDays);
  }

  /// Atualiza o ajuste de um perodo de pico
  void updatePeakHourAdjustment(String peakHourId, double adjustment) {
    final updatedPeakHours = state.peakHours.map((peakHour) {
      if (peakHour.id == peakHourId) {
        return peakHour.copyWith(ajuste: adjustment);
      }
      return peakHour;
    }).toList();
    state = state.copyWith(peakHours: updatedPeakHours);
  }

  /// Salva as configurações
  Future<bool> saveConfigurations() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final peakStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.environmental && 
                 (s.name.toLowerCase().contains('pico') || s.name.toLowerCase().contains('peak')),
          orElse: () => throw Exception('Estratgia de horrio de pico não encontrada'),
        );
        
        await _repository.updateStrategyConfiguration(peakStrategy.id, {
          'peakHours': state.peakHours.map((p) => {
            'id': p.id,
            'periodo': p.periodo,
            'horario': p.horario,
            'tipo': p.tipo,
            'ajuste': p.ajuste,
          }).toList(),
          'weekDays': state.weekDays.map((d) => {
            'id': d.id,
            'dia': d.dia,
            'ativo': d.ativo,
          }).toList(),
          'isActive': state.isStrategyActive,
          'aplicarFinaisSemana': state.aplicarFinaisSemana,
          'notificarAjustes': state.notificarAjustes,
        });
      }
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Recarrega os dados
  Future<void> refresh() async {
    await loadFromBackend();
  }
}

// ============================================================================
// PEAK HOURS PROVIDER
// ============================================================================

/// Provider para o estado de horrio de pico
final peakHoursProvider =
    StateNotifierProvider<PeakHoursNotifier, PeakHoursState>(
  (ref) {
    final repository = ref.watch(environmentalStrategiesRepositoryProvider);
    final currentStore = ref.watch(currentStoreProvider);
    final storeId = currentStore?.id ?? 'store-not-configured';
    return PeakHoursNotifier(repository, storeId);
  },
);



