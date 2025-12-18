import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/features/strategies/data/repositories/strategies_repository.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

// ============================================================================
// REPOSITORY PROVIDER
// ============================================================================

/// Provider do StrategiesRepository para estratégias de calendário
final calendarStrategiesRepositoryProvider = Provider<StrategiesRepository>((ref) {
  return StrategiesRepository();
});

// ============================================================================
// HOLIDAY EVENTS STATE
// ============================================================================

/// Estado dos eventos de datas comemorativas
class HolidayEventsState {
  final List<HolidayEventModel> events;
  final bool isLoading;
  final String? error;
  final bool isStrategyActive;
  final bool revertAfterEvent;

  const HolidayEventsState({
    this.events = const [],
    this.isLoading = false,
    this.error,
    this.isStrategyActive = true,
    this.revertAfterEvent = true,
  });

  /// Estado inicial com carregamento
  factory HolidayEventsState.loading() => const HolidayEventsState(isLoading: true);

  /// Estado com erro
  factory HolidayEventsState.error(String message) => HolidayEventsState(error: message);

  /// Cria uma cópia com alterações
  HolidayEventsState copyWith({
    List<HolidayEventModel>? events,
    bool? isLoading,
    String? error,
    bool? isStrategyActive,
    bool? revertAfterEvent,
  }) {
    return HolidayEventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isStrategyActive: isStrategyActive ?? this.isStrategyActive,
      revertAfterEvent: revertAfterEvent ?? this.revertAfterEvent,
    );
  }

  /// Retorna a contagem de eventos ativos
  int get activeEventsCount => events.where((e) => e.isActive).length;

  /// Retorna eventos ordenados por próxima data
  List<HolidayEventModel> get eventsSortedByNextDate {
    final sorted = List<HolidayEventModel>.from(events);
    sorted.sort((a, b) => a.nextDate.compareTo(b.nextDate));
    return sorted;
  }
}

// ============================================================================
// HOLIDAY EVENTS NOTIFIER
// ============================================================================

class HolidayEventsNotifier extends StateNotifier<HolidayEventsState> {
  final StrategiesRepository _repository;
  final String _storeId;

  HolidayEventsNotifier(this._repository, this._storeId) : super(const HolidayEventsState());

  /// Carrega dados do backend
  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _repository.getCalendarData(_storeId, type: 'datas-comemorativas');
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final eventsList = data['events'] ?? data['eventos'] ?? [];
        final events = <HolidayEventModel>[];
        
        if (eventsList is List) {
          for (final e in eventsList) {
            events.add(HolidayEventModel(
              id: e['id']?.toString() ?? '',
              name: (((e['name'] ?? e['nome']) as String?) ?? ''),
              emoji: e['emoji']?.toString() ?? '??',
              dateLabel: e['dateLabel']?.toString() ?? e['data']?.toString() ?? '',
              icon: Icons.celebration,
              color: _parseColor(e['color'] ?? e['cor']),
              isActive: (((e['isActive'] ?? e['ativo'] ?? false) as bool?) ?? false),
              adjustment: ((e['adjustment'] ?? e['ajuste'] ?? 0) as num?)?.toDouble() ?? 0.0,
              daysInAdvance: (((e['daysInAdvance'] ?? e['diasAntecedencia'] ?? 7) as int?) ?? 7),
              categories: (e['categories'] is List 
                  ? List<String>.from(e['categories'] as Iterable) 
                  : (e['categorias'] is List ? List<String>.from(e['categorias'] as Iterable) : <String>[])),
              description: e['description']?.toString() ?? e['descricao']?.toString() ?? '',
              nextDate: e['nextDate']?.toString() ?? e['proximaData']?.toString() ?? '',
            ));
          }
        }
        
        state = state.copyWith(
          isLoading: false,
          events: events,
          isStrategyActive: (((data['isActive'] ?? data['ativo']) as bool?) ?? state.isStrategyActive),
          revertAfterEvent: (((data['revertAfterEvent'] ?? data['reverterAposEvento']) as bool?) ?? state.revertAfterEvent),
        );
      } else {
        state = state.copyWith(isLoading: false, events: []);
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

  /// Atualiza o status ativo da estratégia geral
  void setStrategyActive(bool isActive) {
    state = state.copyWith(isStrategyActive: isActive);
  }

  /// Atualiza a configuração de reverter após evento
  void setRevertAfterEvent(bool revert) {
    state = state.copyWith(revertAfterEvent: revert);
  }

  /// Atualiza o status ativo de um evento específico
  void toggleEventActive(String eventId, bool isActive) {
    final updatedEvents = state.events.map((event) {
      if (event.id == eventId) {
        return event.copyWith(isActive: isActive);
      }
      return event;
    }).toList();

    state = state.copyWith(events: updatedEvents);
  }

  /// Atualiza o ajuste de preço de um evento
  void updateEventAdjustment(String eventId, double adjustment) {
    final updatedEvents = state.events.map((event) {
      if (event.id == eventId) {
        return event.copyWith(adjustment: adjustment);
      }
      return event;
    }).toList();

    state = state.copyWith(events: updatedEvents);
  }

  /// Atualiza os dias de antecedência de um evento
  void updateEventDaysInAdvance(String eventId, int days) {
    final updatedEvents = state.events.map((event) {
      if (event.id == eventId) {
        return event.copyWith(daysInAdvance: days);
      }
      return event;
    }).toList();

    state = state.copyWith(events: updatedEvents);
  }

  /// Atualiza as categorias de um evento
  void updateEventCategories(String eventId, List<String> categories) {
    final updatedEvents = state.events.map((event) {
      if (event.id == eventId) {
        return event.copyWith(categories: categories);
      }
      return event;
    }).toList();

    state = state.copyWith(events: updatedEvents);
  }

  /// Salva as configurações no backend
  Future<bool> saveConfigurations() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final holidayStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.calendar && 
                 (s.name.toLowerCase().contains('comemorat') || s.name.toLowerCase().contains('holiday')),
          orElse: () => throw Exception('Estratégia de datas comemorativas não encontrada'),
        );
        
        await _repository.updateStrategyConfiguration(holidayStrategy.id, {
          'events': state.events.map((e) => {
            'id': e.id,
            'name': e.name,
            'isActive': e.isActive,
            'adjustment': e.adjustment,
            'daysInAdvance': e.daysInAdvance,
            'categories': e.categories,
          }).toList(),
          'isActive': state.isStrategyActive,
          'revertAfterEvent': state.revertAfterEvent,
        });
      }
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Busca um evento por ID
  HolidayEventModel? getEventById(String eventId) {
    try {
      return state.events.firstWhere((e) => e.id == eventId);
    } catch (_) {
      return null;
    }
  }
}

// ============================================================================
// SPORTS EVENTS STATE
// ============================================================================

class SportsEventsState {
  final List<SportsEventModel> events;
  final bool isLoading;
  final String? error;
  final bool isStrategyActive;

  const SportsEventsState({
    this.events = const [],
    this.isLoading = false,
    this.error,
    this.isStrategyActive = true,
  });

  factory SportsEventsState.loading() => const SportsEventsState(isLoading: true);

  SportsEventsState copyWith({
    List<SportsEventModel>? events,
    bool? isLoading,
    String? error,
    bool? isStrategyActive,
  }) {
    return SportsEventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isStrategyActive: isStrategyActive ?? this.isStrategyActive,
    );
  }

  int get activeEventsCount => events.where((e) => e.isActive).length;
}

// ============================================================================
// SPORTS TEAMS STATE (Para a tela de Times e Jogos)
// ============================================================================

class SportsTeamsState {
  final List<SportsTeamModel> teams;
  final List<SportsGameModel> games;
  final bool isLoading;
  final String? error;
  final bool isStrategyActive;
  final bool notifyGames;
  final int hoursInAdvance;

  const SportsTeamsState({
    this.teams = const [],
    this.games = const [],
    this.isLoading = false,
    this.error,
    this.isStrategyActive = true,
    this.notifyGames = true,
    this.hoursInAdvance = 3,
  });

  factory SportsTeamsState.loading() => const SportsTeamsState(isLoading: true);

  SportsTeamsState copyWith({
    List<SportsTeamModel>? teams,
    List<SportsGameModel>? games,
    bool? isLoading,
    String? error,
    bool? isStrategyActive,
    bool? notifyGames,
    int? hoursInAdvance,
  }) {
    return SportsTeamsState(
      teams: teams ?? this.teams,
      games: games ?? this.games,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isStrategyActive: isStrategyActive ?? this.isStrategyActive,
      notifyGames: notifyGames ?? this.notifyGames,
      hoursInAdvance: hoursInAdvance ?? this.hoursInAdvance,
    );
  }

  int get activeTeamsCount => teams.where((t) => t.isActive).length;
}

class SportsEventsNotifier extends StateNotifier<SportsEventsState> {
  final StrategiesRepository _repository;
  final String _storeId;

  SportsEventsNotifier(this._repository, this._storeId) : super(const SportsEventsState());

  /// Carrega dados do backend
  Future<void> loadFromBackend() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getCalendarData(_storeId, type: 'eventos-esportivos');
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final eventsList = data['events'] ?? data['eventos'] ?? [];
        final events = <SportsEventModel>[];
        
        if (eventsList is List) {
          for (final e in eventsList) {
            events.add(SportsEventModel(
              id: e['id']?.toString() ?? '',
              name: (((e['name'] ?? e['nome']) as String?) ?? ''),
              emoji: e['emoji']?.toString() ?? '?',
              type: (((e['type'] ?? e['tipo']) as String?) ?? ''),
              isActive: (((e['isActive'] ?? e['ativo'] ?? false) as bool?) ?? false),
              adjustment: ((e['adjustment'] ?? e['ajuste'] ?? 0) as num?)?.toDouble() ?? 0.0,
              date: e['date']?.toString() ?? e['data']?.toString() ?? '',
              categories: (e['categories'] is List 
                  ? List<String>.from(e['categories'] as Iterable) 
                  : (e['categorias'] is List ? List<String>.from(e['categorias'] as Iterable) : <String>[])),
              icon: Icons.sports_soccer,
              color: AppThemeColors.success,
              description: e['description']?.toString() ?? e['descricao']?.toString() ?? '',
              expectedAudience: (((e['expectedAudience'] ?? e['públicoEsperado'] ?? 0) as int?) ?? 0),
            ));
          }
        }
        
        state = state.copyWith(
          isLoading: false,
          events: events,
          isStrategyActive: (((data['isActive'] ?? data['ativo']) as bool?) ?? state.isStrategyActive),
        );
      } else {
        state = state.copyWith(isLoading: false, events: []);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setStrategyActive(bool isActive) {
    state = state.copyWith(isStrategyActive: isActive);
  }

  void toggleEventActive(String eventId, bool isActive) {
    final updatedEvents = state.events.map((event) {
      if (event.id == eventId) {
        return event.copyWith(isActive: isActive);
      }
      return event;
    }).toList();

    state = state.copyWith(events: updatedEvents);
  }
}

// ============================================================================
// SPORTS TEAMS NOTIFIER (Para a tela de Times e Jogos)
// ============================================================================

class SportsTeamsNotifier extends StateNotifier<SportsTeamsState> {
  final StrategiesRepository _repository;
  final String _storeId;

  SportsTeamsNotifier(this._repository, this._storeId) : super(const SportsTeamsState());

  /// Carrega dados do backend
  Future<void> loadFromBackend() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getCalendarData(_storeId, type: 'times');
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final teamsList = data['teams'] ?? data['times'] ?? [];
        final gamesList = data['games'] ?? data['jogos'] ?? [];
        final teams = <SportsTeamModel>[];
        final games = <SportsGameModel>[];
        
        if (teamsList is List) {
          for (final t in teamsList) {
            teams.add(SportsTeamModel(
              id: t['id']?.toString() ?? '',
              name: (((t['name'] ?? t['nome']) as String?) ?? ''),
              isActive: (((t['isActive'] ?? t['ativo'] ?? false) as bool?) ?? false),
              adjustment: ((t['adjustment'] ?? t['ajuste'] ?? 0) as num?)?.toDouble() ?? 0.0,
              products: (t['products'] is List 
                  ? List<String>.from(t['products'] as Iterable) 
                  : (t['produtos'] is List ? List<String>.from(t['produtos'] as Iterable) : <String>[])),
              icon: Icons.sports_soccer,
              color: AppThemeColors.success,
              badge: t['badge']?.toString() ?? t['escudo']?.toString() ?? '?',
              nextGame: t['nextGame']?.toString() ?? t['proxJogo']?.toString() ?? '',
            ));
          }
        }
        
        if (gamesList is List) {
          for (final g in gamesList) {
            games.add(SportsGameModel(
              id: g['id']?.toString() ?? '',
              team: g['team']?.toString() ?? g['time']?.toString() ?? '',
              opponent: g['opponent']?.toString() ?? g['adversario']?.toString() ?? '',
              date: g['date']?.toString() ?? g['data']?.toString() ?? '',
              time: g['time']?.toString() ?? g['horario']?.toString() ?? '',
              championship: g['championship']?.toString() ?? g['campeonato']?.toString() ?? '',
              location: g['location']?.toString() ?? g['local']?.toString() ?? '',
            ));
          }
        }
        
        state = state.copyWith(
          isLoading: false,
          teams: teams,
          games: games,
          // ignore: argument_type_not_assignable
          isStrategyActive: data['isActive'] ?? data['ativo'] ?? state.isStrategyActive,
          // ignore: argument_type_not_assignable
          notifyGames: data['notifyGames'] ?? data['notificarJogos'] ?? state.notifyGames,
          // ignore: argument_type_not_assignable
          hoursInAdvance: data['hoursInAdvance'] ?? data['horasAntecedencia'] ?? state.hoursInAdvance,
        );
      } else {
        state = state.copyWith(isLoading: false, teams: [], games: []);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Atualiza o status ativo da estratégia geral
  void setStrategyActive(bool isActive) {
    state = state.copyWith(isStrategyActive: isActive);
  }

  /// Atualiza a configuração de notificar jogos
  void setNotifyGames(bool notify) {
    state = state.copyWith(notifyGames: notify);
  }

  /// Atualiza as horas de antecedência
  void setHoursInAdvance(int hours) {
    state = state.copyWith(hoursInAdvance: hours);
  }

  /// Atualiza o status ativo de um time específico
  void toggleTeamActive(String teamId, bool isActive) {
    final updatedTeams = state.teams.map((team) {
      if (team.id == teamId) {
        return team.copyWith(isActive: isActive);
      }
      return team;
    }).toList();

    state = state.copyWith(teams: updatedTeams);
  }

  /// Atualiza o ajuste de preço de um time
  void updateTeamAdjustment(String teamId, double adjustment) {
    final updatedTeams = state.teams.map((team) {
      if (team.id == teamId) {
        return team.copyWith(adjustment: adjustment);
      }
      return team;
    }).toList();

    state = state.copyWith(teams: updatedTeams);
  }

  /// Atualiza os produtos de um time
  void updateTeamProducts(String teamId, List<String> products) {
    final updatedTeams = state.teams.map((team) {
      if (team.id == teamId) {
        return team.copyWith(products: products);
      }
      return team;
    }).toList();

    state = state.copyWith(teams: updatedTeams);
  }

  /// Busca um time por ID
  SportsTeamModel? getTeamById(String teamId) {
    try {
      return state.teams.firstWhere((t) => t.id == teamId);
    } catch (_) {
      return null;
    }
  }

  /// Salva as configurações no backend
  Future<bool> saveConfigurations() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final teamsStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.calendar && 
                 (s.name.toLowerCase().contains('time') || s.name.toLowerCase().contains('team')),
          orElse: () => throw Exception('Estratégia de times não encontrada'),
        );
        
        await _repository.updateStrategyConfiguration(teamsStrategy.id, {
          'teams': state.teams.map((t) => {
            'id': t.id,
            'name': t.name,
            'isActive': t.isActive,
            'adjustment': t.adjustment,
            'products': t.products,
          }).toList(),
          'isActive': state.isStrategyActive,
          'notifyGames': state.notifyGames,
          'hoursInAdvance': state.hoursInAdvance,
        });
      }
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

// ============================================================================
// LONG HOLIDAYS STATE
// ============================================================================

class LongHolidaysState {
  final List<LongHolidayModel> holidays;
  final bool isLoading;
  final String? error;
  final bool isStrategyActive;
  final bool deteccaoAutomatica;
  final double ajusteLazer;
  final double ajusteViagem;
  final double ajusteCasa;
  final List<String> categoriasSelecionadas;
  final List<String> todasCategorias;

  const LongHolidaysState({
    this.holidays = const [],
    this.isLoading = false,
    this.error,
    this.isStrategyActive = true,
    this.deteccaoAutomatica = true,
    this.ajusteLazer = 25.0,
    this.ajusteViagem = 30.0,
    this.ajusteCasa = 15.0,
    this.categoriasSelecionadas = const ['Snacks', 'Bebidas', 'Viagem', 'Lazer'],
    this.todasCategorias = const [
      'Snacks',
      'Bebidas',
      'Viagem',
      'Lazer',
      'Churrasco',
      'Praia',
      'Camping',
      'Congelados',
      'Descartáveis',
    ],
  });

  factory LongHolidaysState.loading() => const LongHolidaysState(isLoading: true);

  LongHolidaysState copyWith({
    List<LongHolidayModel>? holidays,
    bool? isLoading,
    String? error,
    bool? isStrategyActive,
    bool? deteccaoAutomatica,
    double? ajusteLazer,
    double? ajusteViagem,
    double? ajusteCasa,
    List<String>? categoriasSelecionadas,
    List<String>? todasCategorias,
  }) {
    return LongHolidaysState(
      holidays: holidays ?? this.holidays,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isStrategyActive: isStrategyActive ?? this.isStrategyActive,
      deteccaoAutomatica: deteccaoAutomatica ?? this.deteccaoAutomatica,
      ajusteLazer: ajusteLazer ?? this.ajusteLazer,
      ajusteViagem: ajusteViagem ?? this.ajusteViagem,
      ajusteCasa: ajusteCasa ?? this.ajusteCasa,
      categoriasSelecionadas: categoriasSelecionadas ?? this.categoriasSelecionadas,
      todasCategorias: todasCategorias ?? this.todasCategorias,
    );
  }

  int get activeHolidaysCount => holidays.where((h) => h.isActive).length;
}

class LongHolidaysNotifier extends StateNotifier<LongHolidaysState> {
  final StrategiesRepository _repository;
  final String _storeId;

  LongHolidaysNotifier(this._repository, this._storeId) : super(const LongHolidaysState());

  /// Carrega dados do backend
  Future<void> loadFromBackend() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getCalendarData(_storeId, type: 'feriados-prolongados');
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final holidaysList = data['holidays'] ?? data['feriados'] ?? [];
        final holidays = <LongHolidayModel>[];
        
        if (holidaysList is List) {
          for (final item in holidaysList) {
            holidays.add(LongHolidayModel(
              id: item['id']?.toString() ?? '',
              name: (item['name']).toString() ?? item['nome'] ?? '',
              startDate: item['startDate']?.toString() ?? item['dataInicio']?.toString() ?? '',
              endDate: item['endDate']?.toString() ?? item['dataFim']?.toString() ?? '',
              // ignore: argument_type_not_assignable
              days: item['days'] ?? item['dias'] ?? 1,
              // ignore: argument_type_not_assignable
              isActive: item['isActive'] ?? item['ativo'] ?? false,
              // ignore: argument_type_not_assignable
              adjustment: (item['adjustment'] ?? item['ajuste'] ?? 0).toDouble(),
              categories: item['categories'] is List 
                  // ignore: argument_type_not_assignable
                  ? List<String>.from(item['categories']) 
                  // ignore: argument_type_not_assignable
                  : (item['categorias'] is List ? List<String>.from(item['categorias']) : []),
              icon: Icons.event_available,
              color: AppThemeColors.primary,
              description: item['description']?.toString() ?? item['descricao']?.toString() ?? '',
            ));
          }
        }
        
        state = state.copyWith(
          isLoading: false,
          holidays: holidays,
          // ignore: argument_type_not_assignable
          isStrategyActive: data['isActive'] ?? data['ativo'] ?? state.isStrategyActive,
          // ignore: argument_type_not_assignable
          deteccaoAutomatica: data['deteccaoAutomatica'] ?? data['autoDetection'] ?? state.deteccaoAutomatica,
          // ignore: argument_type_not_assignable
          ajusteLazer: (data['ajusteLazer'] ?? data['leisureAdjustment'] ?? state.ajusteLazer).toDouble(),
          // ignore: argument_type_not_assignable
          ajusteViagem: (data['ajusteViagem'] ?? data['travelAdjustment'] ?? state.ajusteViagem).toDouble(),
          // ignore: argument_type_not_assignable
          ajusteCasa: (data['ajusteCasa'] ?? data['homeAdjustment'] ?? state.ajusteCasa).toDouble(),
          categoriasSelecionadas: data['categoriasSelecionadas'] is List 
              // ignore: argument_type_not_assignable
              ? List<String>.from(data['categoriasSelecionadas']) 
              // ignore: argument_type_not_assignable
              : (data['selectedCategories'] is List ? List<String>.from(data['selectedCategories']) : state.categoriasSelecionadas),
        );
      } else {
        state = state.copyWith(isLoading: false, holidays: []);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Atualiza o status ativo da estratégia geral
  void setStrategyActive(bool isActive) {
    state = state.copyWith(isStrategyActive: isActive);
  }

  /// Atualiza a configuração de detecção automática
  void setDeteccaoAutomatica(bool value) {
    state = state.copyWith(deteccaoAutomatica: value);
  }

  /// Atualiza o ajuste de lazer
  void setAjusteLazer(double value) {
    state = state.copyWith(ajusteLazer: value);
  }

  /// Atualiza o ajuste de viagem
  void setAjusteViagem(double value) {
    state = state.copyWith(ajusteViagem: value);
  }

  /// Atualiza o ajuste de casa
  void setAjusteCasa(double value) {
    state = state.copyWith(ajusteCasa: value);
  }

  /// Atualiza as categorias selecionadas
  void setCategoriasSelecionadas(List<String> categorias) {
    state = state.copyWith(categoriasSelecionadas: categorias);
  }

  /// Toggle um feriado específico
  void toggleHolidayActive(String holidayId, bool isActive) {
    final updatedHolidays = state.holidays.map((holiday) {
      if (holiday.id == holidayId) {
        return holiday.copyWith(isActive: isActive);
      }
      return holiday;
    }).toList();

    state = state.copyWith(holidays: updatedHolidays);
  }

  /// Atualiza o ajuste de um feriado específico
  void updateHolidayAdjustment(String holidayId, double adjustment) {
    final updatedHolidays = state.holidays.map((holiday) {
      if (holiday.id == holidayId) {
        return holiday.copyWith(adjustment: adjustment);
      }
      return holiday;
    }).toList();

    state = state.copyWith(holidays: updatedHolidays);
  }

  /// Busca um feriado por ID
  LongHolidayModel? getHolidayById(String holidayId) {
    try {
      return state.holidays.firstWhere((h) => h.id == holidayId);
    } catch (_) {
      return null;
    }
  }

  /// Salva as configurações no backend
  Future<bool> saveConfigurations() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final longHolidaysStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.calendar && 
                 (s.name.toLowerCase().contains('feriado') || s.name.toLowerCase().contains('prolongado')),
          orElse: () => throw Exception('Estratégia de feriados prolongados não encontrada'),
        );
        
        await _repository.updateStrategyConfiguration(longHolidaysStrategy.id, {
          'holidays': state.holidays.map((h) => {
            'id': h.id,
            'name': h.name,
            'isActive': h.isActive,
            'adjustment': h.adjustment,
            'tipo': h.tipo,
          }).toList(),
          'isActive': state.isStrategyActive,
          'deteccaoAutomatica': state.deteccaoAutomatica,
          'ajusteLazer': state.ajusteLazer,
          'ajusteViagem': state.ajusteViagem,
          'ajusteCasa': state.ajusteCasa,
          'categoriasSelecionadas': state.categoriasSelecionadas,
        });
      }
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

// ============================================================================
// SALARY CYCLE STATE
// ============================================================================

class SalaryCycleState {
  final List<SalaryCycleModel> cycles;
  final List<SalaryAdjustmentHistoryModel> history;
  final bool isLoading;
  final String? error;
  final bool isStrategyActive;
  final bool monitorarQuinzena;
  final double ajusteInicio;
  final double ajusteFim;
  final int diasPagamento;
  final int diaQuinzena;
  final List<String> categoriasSelecionadas;
  final List<String> todasCategorias;

  const SalaryCycleState({
    this.cycles = const [],
    this.history = const [],
    this.isLoading = false,
    this.error,
    this.isStrategyActive = true,
    this.monitorarQuinzena = true,
    this.ajusteInicio = 20.0,
    this.ajusteFim = -10.0,
    this.diasPagamento = 5,
    this.diaQuinzena = 15,
    this.categoriasSelecionadas = const ['Todos os Produtos'],
    this.todasCategorias = const [
      'Todos os Produtos',
      'Bebidas',
      'Snacks',
      'Mercearia',
      'Higiene',
      'Limpeza',
      'Congelados',
      'Laticínios',
      'Padaria',
    ],
  });

  factory SalaryCycleState.loading() => const SalaryCycleState(isLoading: true);

  SalaryCycleState copyWith({
    List<SalaryCycleModel>? cycles,
    List<SalaryAdjustmentHistoryModel>? history,
    bool? isLoading,
    String? error,
    bool? isStrategyActive,
    bool? monitorarQuinzena,
    double? ajusteInicio,
    double? ajusteFim,
    int? diasPagamento,
    int? diaQuinzena,
    List<String>? categoriasSelecionadas,
    List<String>? todasCategorias,
  }) {
    return SalaryCycleState(
      cycles: cycles ?? this.cycles,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isStrategyActive: isStrategyActive ?? this.isStrategyActive,
      monitorarQuinzena: monitorarQuinzena ?? this.monitorarQuinzena,
      ajusteInicio: ajusteInicio ?? this.ajusteInicio,
      ajusteFim: ajusteFim ?? this.ajusteFim,
      diasPagamento: diasPagamento ?? this.diasPagamento,
      diaQuinzena: diaQuinzena ?? this.diaQuinzena,
      categoriasSelecionadas: categoriasSelecionadas ?? this.categoriasSelecionadas,
      todasCategorias: todasCategorias ?? this.todasCategorias,
    );
  }

  int get activeCyclesCount => cycles.where((c) => c.isActive).length;
}

class SalaryCycleNotifier extends StateNotifier<SalaryCycleState> {
  final StrategiesRepository _repository;
  final String _storeId;

  SalaryCycleNotifier(this._repository, this._storeId) : super(const SalaryCycleState());

  /// Carrega dados do backend
  Future<void> loadFromBackend() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getCalendarData(_storeId, type: 'ciclo-salario');
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final cyclesList = data['cycles'] ?? data['ciclos'] ?? [];
        final historyList = data['history'] ?? data['historico'] ?? [];
        final cycles = <SalaryCycleModel>[];
        final history = <SalaryAdjustmentHistoryModel>[];
        
        if (cyclesList is List) {
          for (final c in cyclesList) {
            cycles.add(SalaryCycleModel(
              id: c['id']?.toString() ?? '',
              name: (c['name']).toString() ?? c['nome'] ?? '',
              // ignore: argument_type_not_assignable
              dayOfMonth: c['dayOfMonth'] ?? c['diaMes'] ?? 5,
              // ignore: argument_type_not_assignable
              isActive: c['isActive'] ?? c['ativo'] ?? false,
              // ignore: argument_type_not_assignable
              adjustment: (c['adjustment'] ?? c['ajuste'] ?? 0).toDouble(),
              // ignore: argument_type_not_assignable
              daysRange: c['daysRange'] ?? c['diasRange'] ?? 3,
              categories: c['categories'] is List 
                  // ignore: argument_type_not_assignable
                  ? List<String>.from(c['categories']) 
                  // ignore: argument_type_not_assignable
                  : (c['categorias'] is List ? List<String>.from(c['categorias']) : []),
              icon: Icons.attach_money,
              color: AppThemeColors.success,
              description: c['description']?.toString() ?? c['descricao']?.toString() ?? '',
            ));
          }
        }
        
        if (historyList is List) {
          for (final item in historyList) {
            history.add(SalaryAdjustmentHistoryModel(
              id: item['id']?.toString() ?? '',
              periodo: item['periodo']?.toString() ?? '',
              dateRange: item['dateRange']?.toString() ?? item['intervalo']?.toString() ?? '',
              // ignore: argument_type_not_assignable
              adjustment: (item['adjustment'] ?? item['ajuste'] ?? 0).toDouble(),
              // ignore: argument_type_not_assignable
              productsCount: item['productsCount'] ?? item['produtosAfetados'] ?? 0,
              revenue: item['revenue']?.toString() ?? item['receita']?.toString() ?? 'R\$ 0',
              color: AppThemeColors.success,
            ));
          }
        }
        
        state = state.copyWith(
          isLoading: false,
          cycles: cycles,
          history: history,
          // ignore: argument_type_not_assignable
          isStrategyActive: data['isActive'] ?? data['ativo'] ?? state.isStrategyActive,
          // ignore: argument_type_not_assignable
          monitorarQuinzena: data['monitorarQuinzena'] ?? data['monitorMidMonth'] ?? state.monitorarQuinzena,
          // ignore: argument_type_not_assignable
          ajusteInicio: (data['ajusteInicio'] ?? data['startAdjustment'] ?? state.ajusteInicio).toDouble(),
          // ignore: argument_type_not_assignable
          ajusteFim: (data['ajusteFim'] ?? data['endAdjustment'] ?? state.ajusteFim).toDouble(),
          // ignore: argument_type_not_assignable
          diasPagamento: data['diasPagamento'] ?? data['paymentDays'] ?? state.diasPagamento,
          // ignore: argument_type_not_assignable
          diaQuinzena: data['diaQuinzena'] ?? data['midMonthDay'] ?? state.diaQuinzena,
          categoriasSelecionadas: data['categoriasSelecionadas'] is List 
              // ignore: argument_type_not_assignable
              ? List<String>.from(data['categoriasSelecionadas']) 
              // ignore: argument_type_not_assignable
              : (data['selectedCategories'] is List ? List<String>.from(data['selectedCategories']) : state.categoriasSelecionadas),
        );
      } else {
        state = state.copyWith(isLoading: false, cycles: [], history: []);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Atualiza o status ativo da estratégia geral
  void setStrategyActive(bool isActive) {
    state = state.copyWith(isStrategyActive: isActive);
  }

  /// Atualiza o monitoramento de quinzena
  void setMonitorarQuinzena(bool value) {
    state = state.copyWith(monitorarQuinzena: value);
  }

  /// Atualiza o ajuste de início do mês
  void setAjusteInicio(double value) {
    state = state.copyWith(ajusteInicio: value);
  }

  /// Atualiza o ajuste de fim do mês
  void setAjusteFim(double value) {
    state = state.copyWith(ajusteFim: value);
  }

  /// Atualiza os dias de pagamento
  void setDiasPagamento(int value) {
    state = state.copyWith(diasPagamento: value);
  }

  /// Atualiza o dia da quinzena
  void setDiaQuinzena(int value) {
    state = state.copyWith(diaQuinzena: value);
  }

  /// Atualiza as categorias selecionadas
  void setCategoriasSelecionadas(List<String> categorias) {
    state = state.copyWith(categoriasSelecionadas: categorias);
  }

  /// Toggle um ciclo específico
  void toggleCycleActive(String cycleId, bool isActive) {
    final updatedCycles = state.cycles.map((cycle) {
      if (cycle.id == cycleId) {
        return cycle.copyWith(isActive: isActive);
      }
      return cycle;
    }).toList();

    state = state.copyWith(cycles: updatedCycles);
  }

  /// Salva as configurações no backend
  Future<bool> saveConfigurations() async {
    state = state.copyWith(isLoading: true);
    try {
      final strategies = await _repository.getStrategies(storeId: _storeId);
      if (strategies.isSuccess && strategies.data != null) {
        final salaryCycleStrategy = strategies.data!.firstWhere(
          (s) => s.category == StrategyCategory.calendar && 
                 (s.name.toLowerCase().contains('salário') || s.name.toLowerCase().contains('salary') || s.name.toLowerCase().contains('ciclo')),
          orElse: () => throw Exception('Estratégia de ciclo de salário não encontrada'),
        );
        
        await _repository.updateStrategyConfiguration(salaryCycleStrategy.id, {
          'isActive': state.isStrategyActive,
          'monitorarQuinzena': state.monitorarQuinzena,
          'ajusteInicio': state.ajusteInicio,
          'ajusteFim': state.ajusteFim,
          'diasPagamento': state.diasPagamento,
          'diaQuinzena': state.diaQuinzena,
          'categoriasSelecionadas': state.categoriasSelecionadas,
        });
      }
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

// ============================================================================
// PROVIDERS
// ============================================================================

/// Provider para eventos de datas comemorativas
final holidayEventsProvider = StateNotifierProvider<HolidayEventsNotifier, HolidayEventsState>((ref) {
  final repository = ref.watch(calendarStrategiesRepositoryProvider);
  final currentStore = ref.watch(currentStoreProvider);
  final storeId = currentStore?.id ?? 'store-not-configured';
  return HolidayEventsNotifier(repository, storeId);
});

/// Provider para eventos esportivos
final sportsEventsProvider = StateNotifierProvider<SportsEventsNotifier, SportsEventsState>((ref) {
  final repository = ref.watch(calendarStrategiesRepositoryProvider);
  final currentStore = ref.watch(currentStoreProvider);
  final storeId = currentStore?.id ?? 'store-not-configured';
  return SportsEventsNotifier(repository, storeId);
});

/// Provider para times esportivos (tela de configuração de times e jogos)
final sportsTeamsProvider = StateNotifierProvider<SportsTeamsNotifier, SportsTeamsState>((ref) {
  final repository = ref.watch(calendarStrategiesRepositoryProvider);
  final currentStore = ref.watch(currentStoreProvider);
  final storeId = currentStore?.id ?? 'store-not-configured';
  return SportsTeamsNotifier(repository, storeId);
});

/// Provider para feriados prolongados
final longHolidaysProvider = StateNotifierProvider<LongHolidaysNotifier, LongHolidaysState>((ref) {
  final repository = ref.watch(calendarStrategiesRepositoryProvider);
  final currentStore = ref.watch(currentStoreProvider);
  final storeId = currentStore?.id ?? 'store-not-configured';
  return LongHolidaysNotifier(repository, storeId);
});

/// Provider para ciclo de salário
final salaryCycleProvider = StateNotifierProvider<SalaryCycleNotifier, SalaryCycleState>((ref) {
  final repository = ref.watch(calendarStrategiesRepositoryProvider);
  final currentStore = ref.watch(currentStoreProvider);
  final storeId = currentStore?.id ?? 'store-not-configured';
  return SalaryCycleNotifier(repository, storeId);
});



