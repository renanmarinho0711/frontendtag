/// Modelos de Cross-Selling para Estrat�gias
/// 
/// Este arquivo cont�m os modelos relacionados a estrat�gias de cross-selling:
/// sugest�es de produtos vizinhos, trilhas de ofertas e combos inteligentes.
library;

import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

import 'strategy_base_models.dart';

// ============================================================================
// CROSS-SELLING MODELS
// ============================================================================

/// Modelo de Sugest�o de Produto Vizinho
/// 
/// Representa uma sugest�o de cross-selling baseada em proximidade de produtos.
class NearbyProductSuggestionModel {
  final String id;
  final String produto;
  final String sugere;
  final int correlacao;
  final String distancia;
  final int conversao;
  final Color cor;
  final int vendas;
  final IconData icone;

  const NearbyProductSuggestionModel({
    required this.id,
    required this.produto,
    required this.sugere,
    required this.correlacao,
    required this.distancia,
    required this.conversao,
    required this.cor,
    required this.vendas,
    required this.icone,
  });

  NearbyProductSuggestionModel copyWith({
    String? id,
    String? produto,
    String? sugere,
    int? correlacao,
    String? distancia,
    int? conversao,
    Color? cor,
    int? vendas,
    IconData? icone,
  }) {
    return NearbyProductSuggestionModel(
      id: id ?? this.id,
      produto: produto ?? this.produto,
      sugere: sugere ?? this.sugere,
      correlacao: correlacao ?? this.correlacao,
      distancia: distancia ?? this.distancia,
      conversao: conversao ?? this.conversao,
      cor: cor ?? this.cor,
      vendas: vendas ?? this.vendas,
      icone: icone ?? this.icone,
    );
  }

  /// Correlação formatada
  String get correlacaoFormatted => '$correlacao%';

  /// Conversão formatada
  String get conversaoFormatted => '$conversao%';

  /// Vendas formatadas
  String get vendasFormatted => '$vendas vendas';

  /// Obtém a cor dinâmica baseada na correlação (requer BuildContext)
  Color dynamicColor(BuildContext context) {
    final colors = ThemeColors.of(context);
    if (correlacao >= 80) return colors.success;
    if (correlacao >= 50) return colors.primary;
    return colors.warning;
  }

  factory NearbyProductSuggestionModel.fromJson(Map<String, dynamic> json) {
    return NearbyProductSuggestionModel(
      id: json['id'] as String? ?? '',
      produto: json['produto'] as String? ?? json['product'] as String? ?? '',
      sugere: json['sugere'] as String? ?? json['suggests'] as String? ?? '',
      correlacao: json['correlacao'] as int? ?? json['correlation'] as int? ?? 0,
      distancia: json['distancia'] as String? ?? json['distance'] as String? ?? '',
      conversao: json['conversão'] as int? ?? json['conversion'] as int? ?? 0,
      cor: StrategyModel.parseColor(json['cor'] ?? json['color']) ?? const Color(0xFF2196F3),
      vendas: json['vendas'] as int? ?? json['sales'] as int? ?? 0,
      icone: _parseNearbyIcon(json['icone'] ?? json['icon']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'produto': produto,
      'sugere': sugere,
      'correlacao': correlacao,
      'distancia': distancia,
      'conversão': conversao,
      'vendas': vendas,
    };
  }

  static IconData _parseNearbyIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.local_offer_rounded;
  }
}

/// Modelo de Trilha de Ofertas
/// 
/// Representa um caminho visual de ofertas entre corredores.
class OffersTrailModel {
  final String id;
  final String nome;
  final List<String> produtos;
  final List<String> corredores;
  final bool ativa;
  final int conversao;
  final Color cor;
  final IconData icone;
  final int vendas;
  final String ticketMedio;

  const OffersTrailModel({
    required this.id,
    required this.nome,
    required this.produtos,
    required this.corredores,
    required this.ativa,
    required this.conversao,
    required this.cor,
    required this.icone,
    required this.vendas,
    required this.ticketMedio,
  });

  OffersTrailModel copyWith({
    String? id,
    String? nome,
    List<String>? produtos,
    List<String>? corredores,
    bool? ativa,
    int? conversao,
    Color? cor,
    IconData? icone,
    int? vendas,
    String? ticketMedio,
  }) {
    return OffersTrailModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      produtos: produtos ?? this.produtos,
      corredores: corredores ?? this.corredores,
      ativa: ativa ?? this.ativa,
      conversao: conversao ?? this.conversao,
      cor: cor ?? this.cor,
      icone: icone ?? this.icone,
      vendas: vendas ?? this.vendas,
      ticketMedio: ticketMedio ?? this.ticketMedio,
    );
  }

  /// Conversão formatada
  String get conversaoFormatted => '$conversao%';

  /// Total de produtos na trilha
  int get totalProdutos => produtos.length;

  /// Vendas formatadas
  String get vendasFormatted => '$vendas vendas';

  /// Obtém a cor dinâmica baseada no status (requer BuildContext)
  Color dynamicColor(BuildContext context) {
    final colors = ThemeColors.of(context);
    if (ativa) {
      if (conversao >= 50) return colors.success;
      return colors.primary;
    }
    return colors.grey500;
  }

  factory OffersTrailModel.fromJson(Map<String, dynamic> json) {
    return OffersTrailModel(
      id: json['id'] as String? ?? '',
      nome: json['nome'] as String? ?? json['name'] as String? ?? '',
      produtos: (json['produtos'] as List<dynamic>?)?.cast<String>() ?? 
                (json['products'] as List<dynamic>?)?.cast<String>() ?? [],
      corredores: (json['corredores'] as List<dynamic>?)?.cast<String>() ?? 
                  (json['aisles'] as List<dynamic>?)?.cast<String>() ?? [],
      ativa: json['ativa'] as bool? ?? json['active'] as bool? ?? false,
      conversao: json['conversão'] as int? ?? json['conversion'] as int? ?? 0,
      cor: StrategyModel.parseColor(json['cor'] ?? json['color']) ?? const Color(0xFF2196F3),
      icone: _parseTrailIcon(json['icone'] ?? json['icon']),
      vendas: json['vendas'] as int? ?? json['sales'] as int? ?? 0,
      ticketMedio: json['ticket_medio'] as String? ?? json['avgTicket'] as String? ?? 'R\$ 0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'produtos': produtos,
      'corredores': corredores,
      'ativa': ativa,
      'conversão': conversao,
      'vendas': vendas,
      'ticketMedio': ticketMedio,
    };
  }

  static IconData _parseTrailIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.route_rounded;
  }
}

/// Modelo de Combo Inteligente
/// 
/// Representa um combo de produtos gerado por IA.
class SmartComboModel {
  final String id;
  final String nome;
  final String emoji;
  final List<String> produtos;
  final double precoNormal;
  final double precoCombo;
  final double economia;
  final int vendas;
  final int conversao;
  final Color cor;
  final bool ativo;
  final IconData icone;
  final double margem;

  const SmartComboModel({
    required this.id,
    required this.nome,
    required this.emoji,
    required this.produtos,
    required this.precoNormal,
    required this.precoCombo,
    required this.economia,
    required this.vendas,
    required this.conversao,
    required this.cor,
    required this.ativo,
    required this.icone,
    required this.margem,
  });

  SmartComboModel copyWith({
    String? id,
    String? nome,
    String? emoji,
    List<String>? produtos,
    double? precoNormal,
    double? precoCombo,
    double? economia,
    int? vendas,
    int? conversao,
    Color? cor,
    bool? ativo,
    IconData? icone,
    double? margem,
  }) {
    return SmartComboModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      emoji: emoji ?? this.emoji,
      produtos: produtos ?? this.produtos,
      precoNormal: precoNormal ?? this.precoNormal,
      precoCombo: precoCombo ?? this.precoCombo,
      economia: economia ?? this.economia,
      vendas: vendas ?? this.vendas,
      conversao: conversao ?? this.conversao,
      cor: cor ?? this.cor,
      ativo: ativo ?? this.ativo,
      icone: icone ?? this.icone,
      margem: margem ?? this.margem,
    );
  }

  /// Pre�o normal formatado
  String get precoNormalFormatted => 'R\$ ${precoNormal.toStringAsFixed(2)}';

  /// Pre�o combo formatado
  String get precoComboFormatted => 'R\$ ${precoCombo.toStringAsFixed(2)}';

  /// Economia formatada
  String get economiaFormatted => 'R\$ ${economia.toStringAsFixed(2)}';

  /// Percentual de economia
  double get economiaPercent => precoNormal > 0 ? (economia / precoNormal) * 100 : 0;

  /// Economia percentual formatada
  String get economiaPercentFormatted => '${economiaPercent.toStringAsFixed(0)}%';

  /// Conversão formatada
  String get conversaoFormatted => '$conversao%';

  /// Margem formatada
  String get margemFormatted => '${margem.toStringAsFixed(1)}%';

  /// Total de produtos no combo
  int get totalProdutos => produtos.length;

  /// Vendas formatadas
  String get vendasFormatted => '$vendas vendas';

  /// Obtém a cor dinâmica baseada no status (requer BuildContext)
  Color dynamicColor(BuildContext context) {
    final colors = ThemeColors.of(context);
    if (ativo) {
      if (margem >= 20) return colors.success;
      return colors.primary;
    }
    return colors.grey500;
  }

  factory SmartComboModel.fromJson(Map<String, dynamic> json) {
    return SmartComboModel(
      id: json['id'] as String? ?? '',
      nome: json['nome'] as String? ?? json['name'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '??',
      produtos: (json['produtos'] as List<dynamic>?)?.cast<String>() ?? 
                (json['products'] as List<dynamic>?)?.cast<String>() ?? [],
      precoNormal: (json['preco_normal'] as num?)?.toDouble() ?? 
                   (json['normalPrice'] as num?)?.toDouble() ?? 0.0,
      precoCombo: (json['preco_combo'] as num?)?.toDouble() ?? 
                  (json['comboPrice'] as num?)?.toDouble() ?? 0.0,
      economia: (json['economia'] as num?)?.toDouble() ?? 
                (json['savings'] as num?)?.toDouble() ?? 0.0,
      vendas: json['vendas'] as int? ?? json['sales'] as int? ?? 0,
      conversao: json['conversão'] as int? ?? json['conversion'] as int? ?? 0,
      cor: StrategyModel.parseColor(json['cor'] ?? json['color']) ?? const Color(0xFF2196F3),
      ativo: json['ativo'] as bool? ?? json['active'] as bool? ?? false,
      icone: _parseComboIcon(json['icone'] ?? json['icon']),
      margem: (json['margem'] as num?)?.toDouble() ?? 
              (json['margin'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'emoji': emoji,
      'produtos': produtos,
      'precoNormal': precoNormal,
      'precoCombo': precoCombo,
      'economia': economia,
      'vendas': vendas,
      'conversão': conversao,
      'ativo': ativo,
      'margem': margem,
    };
  }

  static IconData _parseComboIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.card_giftcard_rounded;
  }
}




