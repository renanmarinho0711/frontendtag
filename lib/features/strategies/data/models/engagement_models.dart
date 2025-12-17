/// Modelos de Engajamento Visual para Estrat�gias
/// 
/// Este arquivo cont�m os modelos relacionados a estrat�gias visuais
/// de engajamento: heatmap, ranking, promo��es rel�mpago e rotas.
library;

import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

import '../../../../design_system/theme/theme_colors.dart';
import 'strategy_base_models.dart';

// ============================================================================
// VISUAL STRATEGY MODELS - HEATMAP / RANKING / PROMOS / ROUTE
// ============================================================================

/// Modelo de Zona do Mapa de Calor
/// 
/// Representa uma zona da loja com informa��es de tr�fego e temperatura.
class HeatmapZoneModel {
  final String id;
  final String nome;
  final int trafego;
  final String status;
  final Color cor;
  final IconData icone;
  final int tags;
  final int variacao;
  final int pessoas;

  const HeatmapZoneModel({
    required this.id,
    required this.nome,
    required this.trafego,
    required this.status,
    required this.cor,
    required this.icone,
    required this.tags,
    required this.variacao,
    required this.pessoas,
  });

  HeatmapZoneModel copyWith({
    String? id,
    String? nome,
    int? trafego,
    String? status,
    Color? cor,
    IconData? icone,
    int? tags,
    int? variacao,
    int? pessoas,
  }) {
    return HeatmapZoneModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      trafego: trafego ?? this.trafego,
      status: status ?? this.status,
      cor: cor ?? this.cor,
      icone: icone ?? this.icone,
      tags: tags ?? this.tags,
      variacao: variacao ?? this.variacao,
      pessoas: pessoas ?? this.pessoas,
    );
  }

  /// Verifica se é zona quente
  bool get isHot => trafego >= 70;

  /// Verifica se é zona fria
  bool get isCold => trafego < 40;

  /// Variação formatada com sinal
  String get variacaoFormatted => variacao >= 0 ? '+$variacao%' : '$variacao%';

  /// Obtém a cor dinâmica baseada no tráfego (requer BuildContext)
  Color dynamicColor(BuildContext context) {
    final colors = ThemeColors.of(context);
    if (isHot) return colors.error;
    if (isCold) return colors.blueCyan;
    return colors.success;
  }

  factory HeatmapZoneModel.fromJson(Map<String, dynamic> json) {
    return HeatmapZoneModel(
      id: json['id'] as String? ?? '',
      nome: json['nome'] as String? ?? json['name'] as String? ?? '',
      trafego: json['trafego'] as int? ?? json['traffic'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      cor: StrategyModel.parseColor(json['cor'] ?? json['color']) ?? AppThemeColors.blueMain,
      icone: _parseHeatmapIcon(json['icone'] ?? json['icon']),
      tags: json['tags'] as int? ?? 0,
      variacao: json['variacao'] as int? ?? json['variation'] as int? ?? 0,
      pessoas: json['pessoas'] as int? ?? json['people'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'trafego': trafego,
      'status': status,
      'tags': tags,
      'variacao': variacao,
      'pessoas': pessoas,
    };
  }

  static IconData _parseHeatmapIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.thermostat_rounded;
  }
}

/// Modelo de Produto Top no Ranking
/// 
/// Representa um produto no ranking de vendas em tempo real.
class RankingProductModel {
  final String id;
  final int posicao;
  final String nome;
  final int vendas;
  final int variacao;
  final Color cor;
  final IconData icone;
  final String faturamento;
  final double margem;

  const RankingProductModel({
    required this.id,
    required this.posicao,
    required this.nome,
    required this.vendas,
    required this.variacao,
    required this.cor,
    required this.icone,
    required this.faturamento,
    required this.margem,
  });

  RankingProductModel copyWith({
    String? id,
    int? posicao,
    String? nome,
    int? vendas,
    int? variacao,
    Color? cor,
    IconData? icone,
    String? faturamento,
    double? margem,
  }) {
    return RankingProductModel(
      id: id ?? this.id,
      posicao: posicao ?? this.posicao,
      nome: nome ?? this.nome,
      vendas: vendas ?? this.vendas,
      variacao: variacao ?? this.variacao,
      cor: cor ?? this.cor,
      icone: icone ?? this.icone,
      faturamento: faturamento ?? this.faturamento,
      margem: margem ?? this.margem,
    );
  }

  /// Verifica se está subindo no ranking
  bool get isRising => variacao > 0;

  /// Verifica se está caindo no ranking
  bool get isFalling => variacao < 0;

  /// Variação formatada com sinal
  String get variacaoFormatted => variacao >= 0 ? '+$variacao%' : '$variacao%';

  /// Margem formatada
  String get margemFormatted => '${margem.toStringAsFixed(1)}%';

  /// Verifica se é pódio (top 3)
  bool get isPodium => posicao <= 3;

  /// Obtém a cor dinâmica baseada na variação (requer BuildContext)
  Color dynamicColor(BuildContext context) {
    final colors = ThemeColors.of(context);
    if (isRising) return colors.success;
    if (isFalling) return colors.error;
    return colors.orangeMaterial;
  }

  factory RankingProductModel.fromJson(Map<String, dynamic> json) {
    return RankingProductModel(
      id: json['id'] as String? ?? '',
      posicao: json['posicao'] as int? ?? json['position'] as int? ?? 0,
      nome: json['nome'] as String? ?? json['name'] as String? ?? '',
      vendas: json['vendas'] as int? ?? json['sales'] as int? ?? 0,
      variacao: json['variacao'] as int? ?? json['variation'] as int? ?? 0,
      cor: StrategyModel.parseColor(json['cor'] ?? json['color']) ?? const Color(0xFFFF9800),
      icone: _parseRankingIcon(json['icone'] ?? json['icon']),
      faturamento: json['faturamento'] as String? ?? json['revenue'] as String? ?? 'R\$ 0',
      margem: (json['margem'] as num?)?.toDouble() ?? (json['margin'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'posicao': posicao,
      'nome': nome,
      'vendas': vendas,
      'variacao': variacao,
      'faturamento': faturamento,
      'margem': margem,
    };
  }

  static IconData _parseRankingIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.star_rounded;
  }
}

/// Modelo de Promo��o Rel�mpago
/// 
/// Representa uma promo��o de curta dura��o com contagem regressiva.
class FlashPromoModel {
  final String id;
  final String horario;
  final bool ativa;
  final int desconto;
  final int produtos;
  final Color cor;
  final String status;
  final String tempoRestante;
  final List<String> produtosLista;
  final int vendasPrevistas;
  final String nome;
  final int duracaoMinutos;
  final double precoOriginal;
  final double precoPromo;
  final int vendas;

  const FlashPromoModel({
    required this.id,
    required this.horario,
    required this.ativa,
    required this.desconto,
    required this.produtos,
    required this.cor,
    required this.status,
    required this.tempoRestante,
    required this.produtosLista,
    required this.vendasPrevistas,
    this.nome = '',
    this.duracaoMinutos = 30,
    this.precoOriginal = 0.0,
    this.precoPromo = 0.0,
    this.vendas = 0,
  });

  FlashPromoModel copyWith({
    String? id,
    String? horario,
    bool? ativa,
    int? desconto,
    int? produtos,
    Color? cor,
    String? status,
    String? tempoRestante,
    List<String>? produtosLista,
    int? vendasPrevistas,
    String? nome,
    int? duracaoMinutos,
    double? precoOriginal,
    double? precoPromo,
    int? vendas,
  }) {
    return FlashPromoModel(
      id: id ?? this.id,
      horario: horario ?? this.horario,
      ativa: ativa ?? this.ativa,
      desconto: desconto ?? this.desconto,
      produtos: produtos ?? this.produtos,
      cor: cor ?? this.cor,
      status: status ?? this.status,
      tempoRestante: tempoRestante ?? this.tempoRestante,
      produtosLista: produtosLista ?? this.produtosLista,
      vendasPrevistas: vendasPrevistas ?? this.vendasPrevistas,
      nome: nome ?? this.nome,
      duracaoMinutos: duracaoMinutos ?? this.duracaoMinutos,
      precoOriginal: precoOriginal ?? this.precoOriginal,
      precoPromo: precoPromo ?? this.precoPromo,
      vendas: vendas ?? this.vendas,
    );
  }

  /// Verifica se é a próxima promoção
  bool get isNext => status == 'Próxima';

  /// Verifica se está agendada
  bool get isScheduled => status == 'Agendada';

  /// Verifica se está inativa
  bool get isInactive => !ativa;

  /// Desconto formatado
  String get descontoFormatted => '$desconto%';

  /// Obtém a cor dinâmica baseada no status (requer BuildContext)
  Color dynamicColor(BuildContext context) {
    final colors = ThemeColors.of(context);
    if (ativa) return colors.success;
    if (isNext) return colors.warning;
    return colors.grey500;
  }

  factory FlashPromoModel.fromJson(Map<String, dynamic> json) {
    return FlashPromoModel(
      id: json['id'] as String? ?? '',
      horario: json['horario'] as String? ?? json['schedule'] as String? ?? '',
      ativa: json['ativa'] as bool? ?? json['active'] as bool? ?? false,
      desconto: json['desconto'] as int? ?? json['discount'] as int? ?? 0,
      produtos: json['produtos'] as int? ?? json['products'] as int? ?? 0,
      cor: StrategyModel.parseColor(json['cor'] ?? json['color']) ?? const Color(0xFFFF5252),
      status: json['status'] as String? ?? '',
      tempoRestante: json['tempo_restante'] as String? ?? json['timeRemaining'] as String? ?? '',
      produtosLista: (json['produtos_lista'] as List<dynamic>?)?.cast<String>() ?? 
                     (json['productsList'] as List<dynamic>?)?.cast<String>() ?? [],
      vendasPrevistas: json['vendas_previstas'] as int? ?? json['expectedSales'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'horario': horario,
      'ativa': ativa,
      'desconto': desconto,
      'produtos': produtos,
      'status': status,
      'tempoRestante': tempoRestante,
      'produtosLista': produtosLista,
      'vendasPrevistas': vendasPrevistas,
    };
  }
}

/// Modelo de Rota Inteligente
/// 
/// Representa uma rota de separa��o/picking ativa no sistema.
class SmartRouteModel {
  final String id;
  final String numero;
  final int itens;
  final int progresso;
  final String setor;
  final String status;
  final Color cor;
  final String tempo;
  final String operador;
  final String prioridade;
  final Color corRota;
  final int itensColetados;
  final int totalItens;
  final String tempoDecorrido;
  final String zonaAtual;

  const SmartRouteModel({
    required this.id,
    required this.numero,
    required this.itens,
    required this.progresso,
    required this.setor,
    required this.status,
    required this.cor,
    required this.tempo,
    required this.operador,
    required this.prioridade,
    Color? corRota,
    int? itensColetados,
    int? totalItens,
    this.tempoDecorrido = '00:00',
    this.zonaAtual = 'A',
  }) : corRota = corRota ?? cor,
       itensColetados = itensColetados ?? progresso,
       totalItens = totalItens ?? itens;

  SmartRouteModel copyWith({
    String? id,
    String? numero,
    int? itens,
    int? progresso,
    String? setor,
    String? status,
    Color? cor,
    String? tempo,
    String? operador,
    String? prioridade,
    Color? corRota,
    int? itensColetados,
    int? totalItens,
    String? tempoDecorrido,
    String? zonaAtual,
  }) {
    return SmartRouteModel(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      itens: itens ?? this.itens,
      progresso: progresso ?? this.progresso,
      setor: setor ?? this.setor,
      status: status ?? this.status,
      cor: cor ?? this.cor,
      tempo: tempo ?? this.tempo,
      operador: operador ?? this.operador,
      prioridade: prioridade ?? this.prioridade,
      corRota: corRota ?? this.corRota,
      itensColetados: itensColetados ?? this.itensColetados,
      totalItens: totalItens ?? this.totalItens,
      tempoDecorrido: tempoDecorrido ?? this.tempoDecorrido,
      zonaAtual: zonaAtual ?? this.zonaAtual,
    );
  }

  /// Verifica se está em andamento
  bool get isInProgress => status == 'Em andamento';

  /// Verifica se está na fila
  bool get isQueued => status == 'Na fila';

  /// Verifica se está concluída
  bool get isCompleted => status == 'Concluído';

  /// Percentual de progresso
  double get progressPercent => itens > 0 ? (progresso / itens) * 100 : 0;

  /// Progresso formatado
  String get progressFormatted => '$progresso/$itens';

  /// Verifica se é alta prioridade
  bool get isHighPriority => prioridade == 'Alta';

  /// Obtém a cor dinâmica baseada no status (requer BuildContext)
  Color dynamicColor(BuildContext context) {
    final colors = ThemeColors.of(context);
    if (isCompleted) return colors.success;
    if (isInProgress) return colors.primary;
    return colors.grey500;
  }

  factory SmartRouteModel.fromJson(Map<String, dynamic> json) {
    return SmartRouteModel(
      id: json['id'] as String? ?? '',
      numero: json['número'] as String? ?? json['number'] as String? ?? '',
      itens: json['itens'] as int? ?? json['items'] as int? ?? 0,
      progresso: json['progresso'] as int? ?? json['progress'] as int? ?? 0,
      setor: json['setor'] as String? ?? json['sector'] as String? ?? '',
      status: json['status'] as String? ?? '',
      cor: StrategyModel.parseColor(json['cor'] ?? json['color']) ?? AppThemeColors.greenMain,
      tempo: json['tempo'] as String? ?? json['time'] as String? ?? '',
      operador: json['operador'] as String? ?? json['operator'] as String? ?? '',
      prioridade: json['prioridade'] as String? ?? json['priority'] as String? ?? 'M�dia',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'número': numero,
      'itens': itens,
      'progresso': progresso,
      'setor': setor,
      'status': status,
      'tempo': tempo,
      'operador': operador,
      'prioridade': prioridade,
    };
  }
}




