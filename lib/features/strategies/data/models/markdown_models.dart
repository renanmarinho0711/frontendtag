/// Modelos de Dynamic Markdown para Estrat�gias
/// 
/// Este arquivo cont�m os modelos relacionados � redu��o din�mica
/// de pre�os baseada em validade de produtos (markdown por validade).
library;

import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

import '../../../../design_system/theme/theme_colors.dart';
import 'strategy_base_models.dart';

// ============================================================================
// DYNAMIC MARKDOWN / REDU�O POR VALIDADE MODELS
// ============================================================================

/// Modelo de Faixa de Validade para Dynamic Markdown
/// 
/// Representa uma faixa de dias restantes at� a validade com desconto associado.
/// Quanto mais pr�ximo da validade, maior o desconto aplicado.
class MarkdownRuleModel {
  final String id;
  final String faixa;
  final double desconto;
  final Color cor;
  final IconData icone;
  final String descricao;
  final bool aplicavel;

  const MarkdownRuleModel({
    required this.id,
    required this.faixa,
    required this.desconto,
    required this.cor,
    required this.icone,
    required this.descricao,
    this.aplicavel = true,
  });

  MarkdownRuleModel copyWith({
    String? id,
    String? faixa,
    double? desconto,
    Color? cor,
    IconData? icone,
    String? descricao,
    bool? aplicavel,
  }) {
    return MarkdownRuleModel(
      id: id ?? this.id,
      faixa: faixa ?? this.faixa,
      desconto: desconto ?? this.desconto,
      cor: cor ?? this.cor,
      icone: icone ?? this.icone,
      descricao: descricao ?? this.descricao,
      aplicavel: aplicavel ?? this.aplicavel,
    );
  }

  /// Formata o desconto como string com sinal
  String get descontoFormatted => desconto == 0 ? '0%' : '-${desconto.toStringAsFixed(0)}%';

  /// Verifica se tem desconto
  bool get hasDesconto => desconto > 0;

  factory MarkdownRuleModel.fromJson(Map<String, dynamic> json) {
    return MarkdownRuleModel(
      id: json['id'] as String? ?? '',
      faixa: json['faixa'] as String? ?? json['range'] as String? ?? '',
      desconto: (json['desconto'] as num?)?.toDouble() ?? (json['discount'] as num?)?.toDouble() ?? 0.0,
      cor: StrategyModel.parseColor(json['cor'] ?? json['color']) ?? AppThemeColors.greenMain,
      icone: _parseMarkdownIcon(json['icone'] ?? json['icon']),
      descricao: json['descricao'] as String? ?? json['description'] as String? ?? '',
      aplicavel: json['aplicavel'] as bool? ?? json['applicable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'faixa': faixa,
      'desconto': desconto,
      'descricao': descricao,
      'aplicavel': aplicavel,
    };
  }

  static IconData _parseMarkdownIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.schedule_rounded;
  }
}

/// Modelo de Produto Afetado pelo Dynamic Markdown
/// 
/// Representa um produto que est� com desconto devido � proximidade da validade.
class MarkdownProductModel {
  final String id;
  final String nome;
  final String validade;
  final int diasRestantes;
  final String precoOriginal;
  final String precoAtual;
  final int desconto;

  const MarkdownProductModel({
    required this.id,
    required this.nome,
    required this.validade,
    required this.diasRestantes,
    required this.precoOriginal,
    required this.precoAtual,
    required this.desconto,
  });

  MarkdownProductModel copyWith({
    String? id,
    String? nome,
    String? validade,
    int? diasRestantes,
    String? precoOriginal,
    String? precoAtual,
    int? desconto,
  }) {
    return MarkdownProductModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      validade: validade ?? this.validade,
      diasRestantes: diasRestantes ?? this.diasRestantes,
      precoOriginal: precoOriginal ?? this.precoOriginal,
      precoAtual: precoAtual ?? this.precoAtual,
      desconto: desconto ?? this.desconto,
    );
  }

  /// Formata o desconto como string com sinal
  String get descontoFormatted => '-$desconto%';

  /// Retorna a cor baseada nos dias restantes
  Color get statusColor {
    if (diasRestantes == 0) return const Color(0xFFFF5252);
    if (diasRestantes <= 2) return AppThemeColors.orangeDark;
    if (diasRestantes <= 4) return AppThemeColors.orangeMain;
    return AppThemeColors.greenMain;
  }

  /// Retorna a cor dinâmica baseada nos dias restantes (requer BuildContext)
  Color dynamicStatusColor(BuildContext context) {
    final colors = ThemeColors.of(context);
    if (diasRestantes == 0) return colors.error;
    if (diasRestantes <= 2) return colors.orangeDark;
    if (diasRestantes <= 4) return colors.orangeMain;
    return colors.greenMain;
  }

  /// Retorna o ícone baseado nos dias restantes
  IconData get statusIcon {
    if (diasRestantes == 0) return Icons.dangerous_rounded;
    if (diasRestantes <= 2) return Icons.error_rounded;
    return Icons.access_time_rounded;
  }

  /// Retorna o texto de dias restantes formatado
  String get diasRestantesFormatted => diasRestantes == 0 ? 'HOJE' : '$diasRestantes dias';

  factory MarkdownProductModel.fromJson(Map<String, dynamic> json) {
    return MarkdownProductModel(
      id: json['id'] as String? ?? '',
      nome: json['nome'] as String? ?? json['name'] as String? ?? '',
      validade: json['validade'] as String? ?? json['expiryDate'] as String? ?? '',
      diasRestantes: json['diasRestantes'] as int? ?? json['daysRemaining'] as int? ?? 0,
      precoOriginal: json['precoOriginal'] as String? ?? json['originalPrice'] as String? ?? 'R\$ 0',
      precoAtual: json['precoAtual'] as String? ?? json['currentPrice'] as String? ?? 'R\$ 0',
      desconto: json['desconto'] as int? ?? json['discount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'validade': validade,
      'diasRestantes': diasRestantes,
      'precoOriginal': precoOriginal,
      'precoAtual': precoAtual,
      'desconto': desconto,
    };
  }
}

/// Modelo de Hist�rico de Execu��o do Dynamic Markdown
/// 
/// Representa um registro de execu��o de ajuste baseado em validade.
class MarkdownHistoryModel {
  final String id;
  final String dataHora;
  final int produtosAjustados;
  final String economia;
  final String status;

  const MarkdownHistoryModel({
    required this.id,
    required this.dataHora,
    required this.produtosAjustados,
    required this.economia,
    required this.status,
  });

  MarkdownHistoryModel copyWith({
    String? id,
    String? dataHora,
    int? produtosAjustados,
    String? economia,
    String? status,
  }) {
    return MarkdownHistoryModel(
      id: id ?? this.id,
      dataHora: dataHora ?? this.dataHora,
      produtosAjustados: produtosAjustados ?? this.produtosAjustados,
      economia: economia ?? this.economia,
      status: status ?? this.status,
    );
  }

  /// Verifica se a execu��o foi bem-sucedida
  bool get isSuccess => status.toLowerCase() == 'executado' || status.toLowerCase() == 'sucesso';

  factory MarkdownHistoryModel.fromJson(Map<String, dynamic> json) {
    return MarkdownHistoryModel(
      id: json['id'] as String? ?? '',
      dataHora: json['dataHora'] as String? ?? json['dateTime'] as String? ?? '',
      produtosAjustados: json['produtosAjustados'] as int? ?? json['productsAdjusted'] as int? ?? 0,
      economia: json['economia'] as String? ?? json['savings'] as String? ?? 'R\$ 0',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataHora': dataHora,
      'produtosAjustados': produtosAjustados,
      'economia': economia,
      'status': status,
    };
  }
}




