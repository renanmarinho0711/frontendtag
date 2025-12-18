import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tagbean/design_system/design_system.dart';


import 'package:tagbean/features/strategies/data/models/strategy_models.dart';

import 'package:tagbean/features/strategies/data/repositories/strategies_repository.dart';

import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';



// ============================================================================

// REPOSITORY PROVIDER

// ============================================================================



final visualStrategiesRepositoryProvider = Provider<StrategiesRepository>((ref) {

  return StrategiesRepository();

});



// ============================================================================

// HEATMAP STATE

// ============================================================================



/// Estado da estratgia de Mapa de Calor

class HeatmapState {

  final List<HeatmapZoneModel> zonas;

  final bool isLoading;

  final String? error;

  final bool isStrategyActive;

  final bool fabExpanded;

  final double limiteZonaFria;

  final String intensidadePiscar;

  final int intervaloAtualizacao;

  final bool notificarGestor;

  final bool integracaoCameras;



  const HeatmapState({

    this.zonas = const [],

    this.isLoading = false,

    this.error,

    this.isStrategyActive = true,

    this.fabExpanded = true,

    this.limiteZonaFria = 30.0,

    this.intensidadePiscar = 'Mdia',

    this.intervaloAtualizacao = 15,

    this.notificarGestor = true,

    this.integracaoCameras = true,

  });



  factory HeatmapState.loading() => const HeatmapState(isLoading: true);



  factory HeatmapState.error(String message) => HeatmapState(error: message);



  HeatmapState copyWith({

    List<HeatmapZoneModel>? zonas,

    bool? isLoading,

    String? error,

    bool? isStrategyActive,

    bool? fabExpanded,

    double? limiteZonaFria,

    String? intensidadePiscar,

    int? intervaloAtualizacao,

    bool? notificarGestor,

    bool? integracaoCameras,

  }) {

    return HeatmapState(

      zonas: zonas ?? this.zonas,

      isLoading: isLoading ?? this.isLoading,

      error: error,

      isStrategyActive: isStrategyActive ?? this.isStrategyActive,

      fabExpanded: fabExpanded ?? this.fabExpanded,

      limiteZonaFria: limiteZonaFria ?? this.limiteZonaFria,

      intensidadePiscar: intensidadePiscar ?? this.intensidadePiscar,

      intervaloAtualizacao: intervaloAtualizacao ?? this.intervaloAtualizacao,

      notificarGestor: notificarGestor ?? this.notificarGestor,

      integracaoCameras: integracaoCameras ?? this.integracaoCameras,

    );

  }



  /// Total de zonas frias

  int get zonasQuentes => zonas.where((z) => z.isHot).length;



  /// Total de zonas frias

  int get zonasFrias => zonas.where((z) => z.isCold).length;



  /// Limite formatado

  String get limiteZonaFriaFormatted => '${limiteZonaFria.toStringAsFixed(0)}%';

}



// ============================================================================

// HEATMAP NOTIFIER

// ============================================================================



class HeatmapNotifier extends StateNotifier<HeatmapState> {

  final StrategiesRepository _repository;

  final String _storeId;



  HeatmapNotifier(this._repository, this._storeId) : super(const HeatmapState());



  /// Carrega dados do backend

  Future<void> loadFromBackend() async {

    state = state.copyWith(isLoading: true, error: null);

    try {

      final response = await _repository.getVisualData(_storeId, type: 'heatmap');

      

      if (response.isSuccess && response.data != null) {

        final data = response.data!;

        final zonasList = data['zonas'] ?? data['zones'] ?? [];

        final zonas = <HeatmapZoneModel>[];

        

        if (zonasList is List) {

          for (final z in zonasList) {

            zonas.add(HeatmapZoneModel(
              id: z['id']?.toString() ?? '',
              nome: (((z['nome'] ?? z['name']) as String?) ?? ''),
              trafego: (((z['trafego'] ?? z['fluxo'] ?? z['flow'] ?? 0) as int?) ?? 0),
              status: z['status']?.toString() ?? '',
              cor: _parseColor(z['cor'] ?? z['color']),
              icone: Icons.map,
              tags: (((z['tags']) as int?) ?? 0),
              variacao: (((z['variacao'] ?? z['variation'] ?? 0) as int?) ?? 0),
              pessoas: (((z['pessoas'] ?? z['people'] ?? 0) as int?) ?? 0),
            ));

          }

        }

        

        state = state.copyWith(
          isLoading: false,
          zonas: zonas,
          isStrategyActive: (((data['isActive'] ?? data['is_active']) as bool?) ?? state.isStrategyActive),
          limiteZonaFria: ((data['limiteZonaFria'] ?? data['cold_zone_limit'] ?? state.limiteZonaFria) as num?)?.toDouble() ?? state.limiteZonaFria,
          intensidadePiscar: (((data['intensidadePiscar'] ?? data['blink_intensity']) as String?) ?? state.intensidadePiscar),
          intervaloAtualizacao: (((data['intervaloAtualizacao'] ?? data['update_interval']) as int?) ?? state.intervaloAtualizacao),
          notificarGestor: (((data['notificarGestor'] ?? data['notify_manager']) as bool?) ?? state.notificarGestor),
          integracaoCameras: (((data['integracaoCameras'] ?? data['camera_integration']) as bool?) ?? state.integracaoCameras),
        );

      } else {

        // Sem dados no backend - mantêm estado vazio

        state = state.copyWith(isLoading: false, zonas: []);

      }

    } catch (e) {

      state = state.copyWith(isLoading: false, error: e.toString());

    }

  }



  Color _parseColor(dynamic colorValue) {

    if (colorValue == null) return const Color(0xFF757575);

    if (colorValue is String) {

      try {

        return Color(int.parse(colorValue.replaceFirst('#', '0xFF')));

      } catch (_) {

        return const Color(0xFF757575);

      }

    }

    return const Color(0xFF757575);

  }



  void setStrategyActive(bool isActive) {

    state = state.copyWith(isStrategyActive: isActive);

  }



  void toggleFabExpanded() {

    state = state.copyWith(fabExpanded: !state.fabExpanded);

  }



  void setLimiteZonaFria(double value) {

    state = state.copyWith(limiteZonaFria: value);

  }



  void setIntensidadePiscar(String value) {

    state = state.copyWith(intensidadePiscar: value);

  }



  void setIntervaloAtualizacao(int value) {

    state = state.copyWith(intervaloAtualizacao: value);

  }



  void setNotificarGestor(bool value) {

    state = state.copyWith(notificarGestor: value);

  }



  void setIntegracaoCameras(bool value) {

    state = state.copyWith(integracaoCameras: value);

  }



  Future<void> salvarConfiguracoes() async {

    state = state.copyWith(isLoading: true);

    try {

      // Encontra a estratgia de mapa de calor e atualiza sua configuração

      final strategies = await _repository.getStrategies(storeId: _storeId);

      if (strategies.isSuccess && strategies.data != null) {

        final heatmapStrategy = strategies.data!.firstWhere(

          (s) => s.category == StrategyCategory.visual && s.name.toLowerCase().contains('calor'),

          orElse: () => throw Exception('Estratgia de mapa de calor não encontrada'),

        );

        

        await _repository.updateStrategyConfiguration(heatmapStrategy.id, {

          'limiteZonaFria': state.limiteZonaFria,

          'intensidadePiscar': state.intensidadePiscar,

          'intervaloAtualizacao': state.intervaloAtualizacao,

          'notificarGestor': state.notificarGestor,

          'integracaoCameras': state.integracaoCameras,

          'isActive': state.isStrategyActive,

        });

      }

      state = state.copyWith(isLoading: false);

    } catch (e) {

      state = state.copyWith(isLoading: false, error: e.toString());

    }

  }

}



// ============================================================================

// REALTIME RANKING STATE

// ============================================================================



/// Estado da estratgia de Ranking em Tempo Real

class RealtimeRankingState {

  final List<RankingProductModel> topProdutos;

  final List<String> categoriasSelecionadas;

  final List<String> allCategorias;

  final bool isLoading;

  final String? error;

  final bool isStrategyActive;

  final bool fabExpanded;

  final int intervaloAtualizacao;

  final String tipoRanking;

  final bool exibirPosicao;

  final bool animacaoSubida;



  const RealtimeRankingState({

    this.topProdutos = const [],

    this.categoriasSelecionadas = const [],

    this.allCategorias = const [],

    this.isLoading = false,

    this.error,

    this.isStrategyActive = true,

    this.fabExpanded = true,

    this.intervaloAtualizacao = 30,

    this.tipoRanking = 'Vendas',

    this.exibirPosicao = true,

    this.animacaoSubida = true,

  });



  factory RealtimeRankingState.loading() => const RealtimeRankingState(isLoading: true);



  factory RealtimeRankingState.error(String message) => RealtimeRankingState(error: message);



  RealtimeRankingState copyWith({

    List<RankingProductModel>? topProdutos,

    List<String>? categoriasSelecionadas,

    List<String>? allCategorias,

    bool? isLoading,

    String? error,

    bool? isStrategyActive,

    bool? fabExpanded,

    int? intervaloAtualizacao,

    String? tipoRanking,

    bool? exibirPosicao,

    bool? animacaoSubida,

  }) {

    return RealtimeRankingState(

      topProdutos: topProdutos ?? this.topProdutos,

      categoriasSelecionadas: categoriasSelecionadas ?? this.categoriasSelecionadas,

      allCategorias: allCategorias ?? this.allCategorias,

      isLoading: isLoading ?? this.isLoading,

      error: error,

      isStrategyActive: isStrategyActive ?? this.isStrategyActive,

      fabExpanded: fabExpanded ?? this.fabExpanded,

      intervaloAtualizacao: intervaloAtualizacao ?? this.intervaloAtualizacao,

      tipoRanking: tipoRanking ?? this.tipoRanking,

      exibirPosicao: exibirPosicao ?? this.exibirPosicao,

      animacaoSubida: animacaoSubida ?? this.animacaoSubida,

    );

  }



  /// Total de produtos no pdio

  int get totalPodium => topProdutos.where((p) => p.isPodium).length;

}



// ============================================================================

// REALTIME RANKING NOTIFIER

// ============================================================================



class RealtimeRankingNotifier extends StateNotifier<RealtimeRankingState> {

  final StrategiesRepository _repository;

  final String _storeId;



  RealtimeRankingNotifier(this._repository, this._storeId) : super(const RealtimeRankingState());



  /// Carrega dados do backend

  Future<void> loadFromBackend() async {

    state = state.copyWith(isLoading: true, error: null);

    try {

      final response = await _repository.getVisualData(_storeId, type: 'ranking');

      

      if (response.isSuccess && response.data != null) {

        final data = response.data!;

        final produtosList = data['topProdutos'] ?? data['top_products'] ?? data['produtos'] ?? [];

        final categoriasList = data['categorias'] ?? data['categories'] ?? [];

        final produtos = <RankingProductModel>[];

        

        if (produtosList is List) {

          for (int i = 0; i < produtosList.length; i++) {

            final p = produtosList[i];

            produtos.add(RankingProductModel(

              id: p['id']?.toString() ?? '',

              posicao: p['posicao'] ?? p['position'] ?? (i + 1),

              nome: p['nome'] ?? p['name'] ?? '',

              vendas: p['vendas'] ?? p['sales'] ?? 0,

              variacao: p['variacao'] ?? p['variation'] ?? 0,

              cor: AppThemeColors.orangeMaterial,

              icone: Icons.star,

              faturamento: p['faturamento']?.toString() ?? p['revenue']?.toString() ?? 'R\$ 0',

              margem: ((p['margem'] ?? p['margin'] ?? 0) as num?)?.toDouble() ?? 0.0,

            ));

          }

        }

        

        state = state.copyWith(

          isLoading: false,

          topProdutos: produtos,

          allCategorias: categoriasList is List ? categoriasList.cast<String>() : [],

          isStrategyActive: data['isActive'] ?? data['is_active'] ?? state.isStrategyActive,

          intervaloAtualizacao: data['intervaloAtualizacao'] ?? data['update_interval'] ?? state.intervaloAtualizacao,

          tipoRanking: data['tipoRanking'] ?? data['ranking_type'] ?? state.tipoRanking,

          exibirPosicao: data['exibirPosicao'] ?? data['show_position'] ?? state.exibirPosicao,

          animacaoSubida: data['animacaoSubida'] ?? data['rise_animation'] ?? state.animacaoSubida,

        );

      } else {

        state = state.copyWith(isLoading: false, topProdutos: []);

      }

    } catch (e) {

      state = state.copyWith(isLoading: false, error: e.toString());

    }

  }



  void setStrategyActive(bool isActive) {

    state = state.copyWith(isStrategyActive: isActive);

  }



  void toggleFabExpanded() {

    state = state.copyWith(fabExpanded: !state.fabExpanded);

  }



  void setIntervaloAtualizacao(int value) {

    state = state.copyWith(intervaloAtualizacao: value);

  }



  void setTipoRanking(String value) {

    state = state.copyWith(tipoRanking: value);

  }



  void setExibirPosicao(bool value) {

    state = state.copyWith(exibirPosicao: value);

  }



  void setAnimacaoSubida(bool value) {

    state = state.copyWith(animacaoSubida: value);

  }



  void setCategoriasSelecionadas(List<String> categorias) {

    state = state.copyWith(categoriasSelecionadas: categorias);

  }



  void toggleCategoria(String categoria) {

    final current = List<String>.from(state.categoriasSelecionadas);

    if (current.contains(categoria)) {

      current.remove(categoria);

    } else {

      current.add(categoria);

    }

    state = state.copyWith(categoriasSelecionadas: current);

  }



  Future<void> salvarConfiguracoes() async {

    state = state.copyWith(isLoading: true);

    try {

      final strategies = await _repository.getStrategies(storeId: _storeId);

      if (strategies.isSuccess && strategies.data != null) {

        final rankingStrategy = strategies.data!.firstWhere(

          (s) => s.category == StrategyCategory.visual && s.name.toLowerCase().contains('ranking'),

          orElse: () => throw Exception('Estratgia de ranking não encontrada'),

        );

        

        await _repository.updateStrategyConfiguration(rankingStrategy.id, {

          'intervaloAtualizacao': state.intervaloAtualizacao,

          'tipoRanking': state.tipoRanking,

          'exibirPosicao': state.exibirPosicao,

          'animacaoSubida': state.animacaoSubida,

          'categoriasSelecionadas': state.categoriasSelecionadas,

          'isActive': state.isStrategyActive,

        });

      }

      state = state.copyWith(isLoading: false);

    } catch (e) {

      state = state.copyWith(isLoading: false, error: e.toString());

    }

  }

}



// ============================================================================

// FLASH PROMOS STATE

// ============================================================================



/// Estado da estratgia de Promoções Relmpago

class FlashPromosState {

  final List<FlashPromoModel> promocoes;

  final bool isLoading;

  final String? error;

  final bool isStrategyActive;

  final bool fabExpanded;

  final bool notificarClientes;

  final bool exibirContador;

  final int duracaoMinutos;

  final int intensidadeLed;

  final List<String> horariosAtivos;

  final bool contagemRegressiva;

  final bool animacaoPiscante;



  const FlashPromosState({

    this.promocoes = const [],

    this.isLoading = false,

    this.error,

    this.isStrategyActive = true,

    this.fabExpanded = true,

    this.notificarClientes = true,

    this.exibirContador = true,

    this.duracaoMinutos = 30,

    this.intensidadeLed = 80,

    this.horariosAtivos = const ['10:00', '12:00', '15:00', '18:00'],

    this.contagemRegressiva = true,

    this.animacaoPiscante = true,

  });



  factory FlashPromosState.loading() => const FlashPromosState(isLoading: true);



  factory FlashPromosState.error(String message) => FlashPromosState(error: message);



  FlashPromosState copyWith({

    List<FlashPromoModel>? promocoes,

    bool? isLoading,

    String? error,

    bool? isStrategyActive,

    bool? fabExpanded,

    bool? notificarClientes,

    bool? exibirContador,

    int? duracaoMinutos,

    int? intensidadeLed,

    List<String>? horariosAtivos,

    bool? contagemRegressiva,

    bool? animacaoPiscante,

  }) {

    return FlashPromosState(

      promocoes: promocoes ?? this.promocoes,

      isLoading: isLoading ?? this.isLoading,

      error: error,

      isStrategyActive: isStrategyActive ?? this.isStrategyActive,

      fabExpanded: fabExpanded ?? this.fabExpanded,

      notificarClientes: notificarClientes ?? this.notificarClientes,

      exibirContador: exibirContador ?? this.exibirContador,

      duracaoMinutos: duracaoMinutos ?? this.duracaoMinutos,

      intensidadeLed: intensidadeLed ?? this.intensidadeLed,

      horariosAtivos: horariosAtivos ?? this.horariosAtivos,

      contagemRegressiva: contagemRegressiva ?? this.contagemRegressiva,

      animacaoPiscante: animacaoPiscante ?? this.animacaoPiscante,

    );

  }



  /// Total de promoções ativas

  int get promocoesAtivas => promocoes.where((p) => p.ativa).length;



  /// Prxima promoção ativa

  FlashPromoModel? get proximaPromocao {

    try {

      return promocoes.firstWhere((p) => p.ativa && p.isNext);

    } catch (_) {

      return promocoes.isNotEmpty ? promocoes.first : null;

    }

  }

}



// ============================================================================

// FLASH PROMOS NOTIFIER

// ============================================================================



class FlashPromosNotifier extends StateNotifier<FlashPromosState> {

  final StrategiesRepository _repository;

  final String _storeId;



  FlashPromosNotifier(this._repository, this._storeId) : super(const FlashPromosState());



  /// Carrega dados do backend

  Future<void> loadFromBackend() async {

    state = state.copyWith(isLoading: true, error: null);

    try {

      final response = await _repository.getVisualData(_storeId, type: 'promocoes');

      

      if (response.isSuccess && response.data != null) {

        final data = response.data!;

        final promosList = data['promocoes'] ?? data['promotions'] ?? [];

        final promocoes = <FlashPromoModel>[];

        

        if (promosList is List) {

          for (final p in promosList) {

            promocoes.add(FlashPromoModel(

              id: p['id']?.toString() ?? '',

              horario: p['horario']?.toString() ?? '',

              ativa: p['ativa'] ?? p['active'] ?? false,

              desconto: p['desconto'] ?? p['discount'] ?? 0,

              produtos: p['produtos'] ?? p['products'] ?? 0,

              cor: const Color(0xFFFF5252),

              status: p['status']?.toString() ?? '',

              tempoRestante: p['tempoRestante']?.toString() ?? p['tempo_restante']?.toString() ?? '',

              produtosLista: p['produtosLista'] is List 

                  ? List<String>.from(p['produtosLista']) 

                  : (p['produtos_lista'] is List ? List<String>.from(p['produtos_lista']) : []),

              vendasPrevistas: p['vendasPrevistas'] ?? p['expectedSales'] ?? 0,

              nome: p['nome']?.toString() ?? p['name']?.toString() ?? '',

            ));

          }

        }

        

        state = state.copyWith(

          isLoading: false,

          promocoes: promocoes,

          isStrategyActive: data['isActive'] ?? data['is_active'] ?? state.isStrategyActive,

          notificarClientes: data['notificarClientes'] ?? data['notify_customers'] ?? state.notificarClientes,

          exibirContador: data['exibirContador'] ?? data['show_counter'] ?? state.exibirContador,

          duracaoMinutos: data['duracaoMinutos'] ?? data['duration_minutes'] ?? state.duracaoMinutos,

          intensidadeLed: data['intensidadeLed'] ?? data['led_intensity'] ?? state.intensidadeLed,

          horariosAtivos: (data['horariosAtivos'] ?? data['active_schedules'] ?? state.horariosAtivos) is List 

              ? List<String>.from(data['horariosAtivos'] ?? data['active_schedules'] ?? state.horariosAtivos)

              : state.horariosAtivos,

          contagemRegressiva: data['contagemRegressiva'] ?? data['countdown'] ?? state.contagemRegressiva,

          animacaoPiscante: data['animacaoPiscante'] ?? data['blink_animation'] ?? state.animacaoPiscante,

        );

      } else {

        state = state.copyWith(isLoading: false, promocoes: []);

      }

    } catch (e) {

      state = state.copyWith(isLoading: false, error: e.toString());

    }

  }



  void setStrategyActive(bool isActive) {

    state = state.copyWith(isStrategyActive: isActive);

  }



  void toggleFabExpanded() {

    state = state.copyWith(fabExpanded: !state.fabExpanded);

  }



  void setNotificarClientes(bool value) {

    state = state.copyWith(notificarClientes: value);

  }



  void setExibirContador(bool value) {

    state = state.copyWith(exibirContador: value);

  }

  

  void setDuracaoMinutos(int value) {

    state = state.copyWith(duracaoMinutos: value);

  }

  

  void setIntensidadeLed(int value) {

    state = state.copyWith(intensidadeLed: value);

  }

  

  void setContagemRegressiva(bool value) {

    state = state.copyWith(contagemRegressiva: value);

  }

  

  void setAnimacaoPiscante(bool value) {

    state = state.copyWith(animacaoPiscante: value);

  }

  

  void togglePromoAtiva(String id) {

    togglePromocaoAtiva(id);

  }



  void togglePromocaoAtiva(String id) {

    final updatedPromocoes = state.promocoes.map((promo) {

      if (promo.id == id) {

        return promo.copyWith(ativa: !promo.ativa);

      }

      return promo;

    }).toList();

    state = state.copyWith(promocoes: updatedPromocoes);

  }



  void adicionarPromocao(FlashPromoModel promo) {

    state = state.copyWith(promocoes: [...state.promocoes, promo]);

  }



  void removerPromocao(String id) {

    state = state.copyWith(

      promocoes: state.promocoes.where((p) => p.id != id).toList(),

    );

  }



  Future<void> salvarConfiguracoes() async {

    state = state.copyWith(isLoading: true);

    try {

      final strategies = await _repository.getStrategies(storeId: _storeId);

      if (strategies.isSuccess && strategies.data != null) {

        final promoStrategy = strategies.data!.firstWhere(

          (s) => s.category == StrategyCategory.visual && 

                 (s.name.toLowerCase().contains('promo') || s.name.toLowerCase().contains('relmpago')),

          orElse: () => throw Exception('Estratgia de promoções não encontrada'),

        );

        

        await _repository.updateStrategyConfiguration(promoStrategy.id, {

          'notificarClientes': state.notificarClientes,

          'exibirContador': state.exibirContador,

          'duracaoMinutos': state.duracaoMinutos,

          'intensidadeLed': state.intensidadeLed,

          'horariosAtivos': state.horariosAtivos,

          'contagemRegressiva': state.contagemRegressiva,

          'animacaoPiscante': state.animacaoPiscante,

          'isActive': state.isStrategyActive,

        });

      }

      state = state.copyWith(isLoading: false);

    } catch (e) {

      state = state.copyWith(isLoading: false, error: e.toString());

    }

  }

}



// ============================================================================

// SMART ROUTE STATE

// ============================================================================



/// Estado da estratgia de Rota Inteligente

class SmartRouteState {

  final List<SmartRouteModel> rotasAtivas;

  final bool isLoading;

  final String? error;

  final bool isStrategyActive;

  final bool fabExpanded;

  final double intensidadeLed;

  final double duracaoDestaque;

  final bool corProgressiva;

  final String modoRota;

  final bool feedbackSonoro;

  final bool confirmarColeta;

  final bool integracaoWms;

  final int tempoPiscar;

  final bool confirmacaoScan;

  final bool somConfirmacao;

  final bool mostrarProximoItem;



  const SmartRouteState({

    this.rotasAtivas = const [],

    this.isLoading = false,

    this.error,

    this.isStrategyActive = true,

    this.fabExpanded = true,

    this.intensidadeLed = 80.0,

    this.duracaoDestaque = 5.0,

    this.corProgressiva = true,

    this.modoRota = 'otimizada',

    this.feedbackSonoro = false,

    this.confirmarColeta = true,

    this.integracaoWms = true,

    this.tempoPiscar = 5,

    this.confirmacaoScan = true,

    this.somConfirmacao = true,

    this.mostrarProximoItem = true,

  });



  factory SmartRouteState.loading() => const SmartRouteState(isLoading: true);



  factory SmartRouteState.error(String message) => SmartRouteState(error: message);



  SmartRouteState copyWith({

    List<SmartRouteModel>? rotasAtivas,

    bool? isLoading,

    String? error,

    bool? isStrategyActive,

    bool? fabExpanded,

    double? intensidadeLed,

    double? duracaoDestaque,

    bool? corProgressiva,

    String? modoRota,

    bool? feedbackSonoro,

    bool? confirmarColeta,

    bool? integracaoWms,

    int? tempoPiscar,

    bool? confirmacaoScan,

    bool? somConfirmacao,

    bool? mostrarProximoItem,

  }) {

    return SmartRouteState(

      rotasAtivas: rotasAtivas ?? this.rotasAtivas,

      isLoading: isLoading ?? this.isLoading,

      error: error,

      isStrategyActive: isStrategyActive ?? this.isStrategyActive,

      fabExpanded: fabExpanded ?? this.fabExpanded,

      intensidadeLed: intensidadeLed ?? this.intensidadeLed,

      duracaoDestaque: duracaoDestaque ?? this.duracaoDestaque,

      corProgressiva: corProgressiva ?? this.corProgressiva,

      modoRota: modoRota ?? this.modoRota,

      feedbackSonoro: feedbackSonoro ?? this.feedbackSonoro,

      confirmarColeta: confirmarColeta ?? this.confirmarColeta,

      integracaoWms: integracaoWms ?? this.integracaoWms,

      tempoPiscar: tempoPiscar ?? this.tempoPiscar,

      confirmacaoScan: confirmacaoScan ?? this.confirmacaoScan,

      somConfirmacao: somConfirmacao ?? this.somConfirmacao,

      mostrarProximoItem: mostrarProximoItem ?? this.mostrarProximoItem,

    );

  }



  /// Total de rotas em andamento

  int get rotasEmAndamento => rotasAtivas.where((r) => r.isInProgress).length;



  /// Total de rotas na fila

  int get rotasNaFila => rotasAtivas.where((r) => r.isQueued).length;



  /// Intensidade formatada

  String get intensidadeLedFormatted => '${intensidadeLed.toStringAsFixed(0)}%';



  /// Duração formatada

  String get duracaoDestaqueFormatted => '${duracaoDestaque.toStringAsFixed(0)}s';

}



// ============================================================================

// SMART ROUTE NOTIFIER

// ============================================================================



class SmartRouteNotifier extends StateNotifier<SmartRouteState> {

  final StrategiesRepository _repository;

  final String _storeId;



  SmartRouteNotifier(this._repository, this._storeId) : super(const SmartRouteState());



  /// Carrega dados do backend

  Future<void> loadFromBackend() async {

    state = state.copyWith(isLoading: true, error: null);

    try {

      final response = await _repository.getVisualData(_storeId, type: 'rotas');

      

      if (response.isSuccess && response.data != null) {

        final data = response.data!;

        final rotasList = data['rotasAtivas'] ?? data['active_routes'] ?? data['rotas'] ?? [];

        final rotas = <SmartRouteModel>[];

        

        if (rotasList is List) {

          for (final r in rotasList) {

            rotas.add(SmartRouteModel(

              id: r['id']?.toString() ?? '',

              numero: r['número']?.toString() ?? r['number']?.toString() ?? r['nome']?.toString() ?? r['name']?.toString() ?? '',

              itens: r['itens'] ?? r['items'] ?? r['itensTotal'] ?? r['total_items'] ?? 0,

              progresso: r['progresso'] ?? r['progress'] ?? r['itensColetados'] ?? r['collected_items'] ?? 0,

              setor: r['setor']?.toString() ?? r['sector']?.toString() ?? '',

              status: r['status']?.toString() ?? 'Na fila',

              cor: const Color(0xFF4CAF50),

              tempo: r['tempo']?.toString() ?? r['time']?.toString() ?? '',

              operador: r['operador']?.toString() ?? r['operator']?.toString() ?? '',

              prioridade: r['prioridade']?.toString() ?? r['priority']?.toString() ?? 'Mdia',

            ));

          }

        }

        

        state = state.copyWith(

          isLoading: false,

          rotasAtivas: rotas,

          isStrategyActive: (((data['isActive'] ?? data['is_active']) as bool?) ?? state.isStrategyActive),

          intensidadeLed: ((data['intensidadeLed'] ?? data['led_intensity'] ?? state.intensidadeLed) as num?)?.toDouble() ?? state.intensidadeLed,

          duracaoDestaque: ((data['duracaoDestaque'] ?? data['highlight_duration'] ?? state.duracaoDestaque) as num?)?.toDouble() ?? state.duracaoDestaque,

          corProgressiva: (((data['corProgressiva'] ?? data['progressive_color']) as String?) ?? state.corProgressiva),

          modoRota: (((data['modoRota'] ?? data['route_mode']) as String?) ?? state.modoRota),

          feedbackSonoro: data['feedbackSonoro'] ?? data['sound_feedback'] ?? state.feedbackSonoro,

          confirmarColeta: data['confirmarColeta'] ?? data['confirm_collection'] ?? state.confirmarColeta,

          integracaoWms: data['integracaoWms'] ?? data['wms_integration'] ?? state.integracaoWms,

          tempoPiscar: data['tempoPiscar'] ?? data['blink_time'] ?? state.tempoPiscar,

          confirmacaoScan: data['confirmacaoScan'] ?? data['scan_confirmation'] ?? state.confirmacaoScan,

          somConfirmacao: data['somConfirmacao'] ?? data['confirmation_sound'] ?? state.somConfirmacao,

          mostrarProximoItem: data['mostrarProximoItem'] ?? data['show_next_item'] ?? state.mostrarProximoItem,

        );

      } else {

        state = state.copyWith(isLoading: false, rotasAtivas: []);

      }

    } catch (e) {

      state = state.copyWith(isLoading: false, error: e.toString());

    }

  }



  void setStrategyActive(bool isActive) {

    state = state.copyWith(isStrategyActive: isActive);

  }



  void toggleFabExpanded() {

    state = state.copyWith(fabExpanded: !state.fabExpanded);

  }



  void setIntensidadeLed(double value) {

    state = state.copyWith(intensidadeLed: value);

  }



  void setDuracaoDestaque(double value) {

    state = state.copyWith(duracaoDestaque: value);

  }



  void setCorProgressiva(bool value) {

    state = state.copyWith(corProgressiva: value);

  }



  void setModoRota(String value) {

    state = state.copyWith(modoRota: value);

  }



  void setFeedbackSonoro(bool value) {

    state = state.copyWith(feedbackSonoro: value);

  }



  void setConfirmarColeta(bool value) {

    state = state.copyWith(confirmarColeta: value);

  }



  void setIntegracaoWms(bool value) {

    state = state.copyWith(integracaoWms: value);

  }

  

  void setTempoPiscar(int value) {

    state = state.copyWith(tempoPiscar: value);

  }

  

  void setConfirmacaoScan(bool value) {

    state = state.copyWith(confirmacaoScan: value);

  }

  

  void setSomConfirmacao(bool value) {

    state = state.copyWith(somConfirmacao: value);

  }

  

  void setMostrarProximoItem(bool value) {

    state = state.copyWith(mostrarProximoItem: value);

  }



  Future<void> simularRota() async {

    state = state.copyWith(isLoading: true);

    try {

      // Executa simulação via estratgia

      final strategies = await _repository.getStrategies(storeId: _storeId);

      if (strategies.isSuccess && strategies.data != null) {

        final routeStrategy = strategies.data!.firstWhere(

          (s) => s.category == StrategyCategory.visual && 

                 (s.name.toLowerCase().contains('rota') || s.name.toLowerCase().contains('route')),

          orElse: () => throw Exception('Estratgia de rotas não encontrada'),

        );

        

        await _repository.executeStrategy(routeStrategy.id);

      }

      state = state.copyWith(isLoading: false);

    } catch (e) {

      state = state.copyWith(isLoading: false, error: e.toString());

    }

  }



  Future<void> salvarConfiguracoes() async {

    state = state.copyWith(isLoading: true);

    try {

      final strategies = await _repository.getStrategies(storeId: _storeId);

      if (strategies.isSuccess && strategies.data != null) {

        final routeStrategy = strategies.data!.firstWhere(

          (s) => s.category == StrategyCategory.visual && 

                 (s.name.toLowerCase().contains('rota') || s.name.toLowerCase().contains('route')),

          orElse: () => throw Exception('Estratgia de rotas não encontrada'),

        );

        

        await _repository.updateStrategyConfiguration(routeStrategy.id, {

          'intensidadeLed': state.intensidadeLed,

          'duracaoDestaque': state.duracaoDestaque,

          'corProgressiva': state.corProgressiva,

          'modoRota': state.modoRota,

          'feedbackSonoro': state.feedbackSonoro,

          'confirmarColeta': state.confirmarColeta,

          'integracaoWms': state.integracaoWms,

          'tempoPiscar': state.tempoPiscar,

          'confirmacaoScan': state.confirmacaoScan,

          'somConfirmacao': state.somConfirmacao,

          'mostrarProximoItem': state.mostrarProximoItem,

          'isActive': state.isStrategyActive,

        });

      }

      state = state.copyWith(isLoading: false);

    } catch (e) {

      state = state.copyWith(isLoading: false, error: e.toString());

    }

  }

}



// ============================================================================

// PROVIDERS

// ============================================================================



/// Provider para Mapa de Calor

final heatmapProvider = StateNotifierProvider<HeatmapNotifier, HeatmapState>((ref) {

  final repository = ref.watch(visualStrategiesRepositoryProvider);

  final currentStore = ref.watch(currentStoreProvider);

  final storeId = currentStore?.id ?? 'store-not-configured';

  return HeatmapNotifier(repository, storeId);

});



/// Provider para Ranking em Tempo Real

final realtimeRankingProvider = StateNotifierProvider<RealtimeRankingNotifier, RealtimeRankingState>((ref) {

  final repository = ref.watch(visualStrategiesRepositoryProvider);

  final currentStore = ref.watch(currentStoreProvider);

  final storeId = currentStore?.id ?? 'store-not-configured';

  return RealtimeRankingNotifier(repository, storeId);

});



/// Provider para Promoções Relmpago

final flashPromosProvider = StateNotifierProvider<FlashPromosNotifier, FlashPromosState>((ref) {

  final repository = ref.watch(visualStrategiesRepositoryProvider);

  final currentStore = ref.watch(currentStoreProvider);

  final storeId = currentStore?.id ?? 'store-not-configured';

  return FlashPromosNotifier(repository, storeId);

});



/// Provider para Rota Inteligente

final smartRouteProvider = StateNotifierProvider<SmartRouteNotifier, SmartRouteState>((ref) {

  final repository = ref.watch(visualStrategiesRepositoryProvider);

  final currentStore = ref.watch(currentStoreProvider);

  final storeId = currentStore?.id ?? 'store-not-configured';

  return SmartRouteNotifier(repository, storeId);

});







