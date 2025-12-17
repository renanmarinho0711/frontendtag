import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/models/strategy_base_models.dart';

// ============================================================================
// AUTO CLEARANCE / LIQUIDA�O AUTOM�TICA MODELS
// ============================================================================

/// Modelo de Fase de Liquida��o Autom�tica
/// 
/// Representa uma fase da liquida��o progressiva com seus parmetros.
/// Os produtos entram em fases diferentes conforme o tempo sem vendas.
class ClearancePhaseModel {
  final String id;
  final String fase;
  final String titulo;
  final int dias;
  final double desconto;
  final Color cor;
  final IconData icone;
  final String descricao;

  const ClearancePhaseModel({
    required this.id,
    required this.fase,
    required this.titulo,
    required this.dias,
    required this.desconto,
    required this.cor,
    required this.icone,
    required this.descricao,
  });

  ClearancePhaseModel copyWith({
    String? id,
    String? fase,
    String? titulo,
    int? dias,
    double? desconto,
    Color? cor,
    IconData? icone,
    String? descricao,
  }) {
    return ClearancePhaseModel(
      id: id ?? this.id,
      fase: fase ?? this.fase,
      titulo: titulo ?? this.titulo,
      dias: dias ?? this.dias,
      desconto: desconto ?? this.desconto,
      cor: cor ?? this.cor,
      icone: icone ?? this.icone,
      descricao: descricao ?? this.descricao,
    );
  }

  String get descontoFormatted => '-${desconto.toStringAsFixed(0)}%';

  factory ClearancePhaseModel.fromJson(Map<String, dynamic> json) {
    return ClearancePhaseModel(
      id: json['id'] as String? ?? '',
      fase: json['fase'] as String? ?? '',
      titulo: json['titulo'] as String? ?? json['title'] as String? ?? '',
      dias: json['dias'] as int? ?? json['days'] as int? ?? 0,
      desconto: (json['desconto'] as num?)?.toDouble() ?? (json['discount'] as num?)?.toDouble() ?? 0.0,
      cor: StrategyModel.parseColor(json['cor'] ?? json['color']) ?? const Color(0xFFFF5252),
      icone: _parseClearanceIcon(json['icone'] ?? json['icon']),
      descricao: json['descricao'] as String? ?? json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fase': fase,
      'titulo': titulo,
      'dias': dias,
      'desconto': desconto,
      'descricao': descricao,
    };
  }

  static IconData _parseClearanceIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.timer_rounded;
  }
}

/// Modelo de Produto em Liquida��o
/// 
/// Representa um produto que est� em processo de liquida��o autom�tica.
class ClearanceProductModel {
  final String id;
  final String nome;
  final int diasParado;
  final int fase;
  final String precoOriginal;
  final String precoAtual;
  final int desconto;
  final int estoque;

  const ClearanceProductModel({
    required this.id,
    required this.nome,
    required this.diasParado,
    required this.fase,
    required this.precoOriginal,
    required this.precoAtual,
    required this.desconto,
    required this.estoque,
  });

  ClearanceProductModel copyWith({
    String? id,
    String? nome,
    int? diasParado,
    int? fase,
    String? precoOriginal,
    String? precoAtual,
    int? desconto,
    int? estoque,
  }) {
    return ClearanceProductModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      diasParado: diasParado ?? this.diasParado,
      fase: fase ?? this.fase,
      precoOriginal: precoOriginal ?? this.precoOriginal,
      precoAtual: precoAtual ?? this.precoAtual,
      desconto: desconto ?? this.desconto,
      estoque: estoque ?? this.estoque,
    );
  }

  String get descontoFormatted => '-$desconto%';

  factory ClearanceProductModel.fromJson(Map<String, dynamic> json) {
    return ClearanceProductModel(
      id: json['id'] as String? ?? '',
      nome: json['nome'] as String? ?? json['name'] as String? ?? '',
      diasParado: json['diasParado'] as int? ?? json['daysIdle'] as int? ?? 0,
      fase: json['fase'] as int? ?? json['phase'] as int? ?? 1,
      precoOriginal: json['precoOriginal'] as String? ?? json['originalPrice'] as String? ?? 'R\$ 0',
      precoAtual: json['precoAtual'] as String? ?? json['currentPrice'] as String? ?? 'R\$ 0',
      desconto: json['desconto'] as int? ?? json['discount'] as int? ?? 0,
      estoque: json['estoque'] as int? ?? json['stock'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'diasParado': diasParado,
      'fase': fase,
      'precoOriginal': precoOriginal,
      'precoAtual': precoAtual,
      'desconto': desconto,
      'estoque': estoque,
    };
  }
}

// ============================================================================
// DYNAMIC MARKDOWN / REDU�O POR VALIDADE MODELS
// ============================================================================

/// Modelo de Faixa de Validade para Dynamic Markdown
/// 
/// Representa uma faixa de dias restantes at� a validade com desconto associado.
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

  String get descontoFormatted => desconto == 0 ? '0%' : '-${desconto.toStringAsFixed(0)}%';
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

  String get descontoFormatted => '-$desconto%';

  Color get statusColor {
    if (diasRestantes == 0) return const Color(0xFFFF5252);
    if (diasRestantes <= 2) return AppThemeColors.orangeDark;
    if (diasRestantes <= 4) return AppThemeColors.orangeMain;
    return AppThemeColors.greenMain;
  }

  /// Obtém a cor dinâmica do status (requer BuildContext)
  Color dynamicStatusColor(BuildContext context) {
    final colors = ThemeColors.of(context);
    if (diasRestantes == 0) return colors.error;
    if (diasRestantes <= 2) return colors.orangeDark;
    if (diasRestantes <= 4) return colors.orangeMain;
    return colors.greenMain;
  }

  IconData get statusIcon {
    if (diasRestantes == 0) return Icons.dangerous_rounded;
    if (diasRestantes <= 2) return Icons.error_rounded;
    return Icons.access_time_rounded;
  }

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




