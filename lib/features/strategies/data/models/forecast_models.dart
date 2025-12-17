import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/models/strategy_base_models.dart';

// ============================================================================
// FORECAST TREND ENUM
// ============================================================================

/// Tendência de previsão
enum ForecastTrend {
  alta('alta', 'Alta', AppThemeColors.success, Icons.trending_up_rounded),
  baixa('baixa', 'Baixa', AppThemeColors.error, Icons.trending_down_rounded),
  estavel('estavel', 'Estável', AppThemeColors.blueMain, Icons.trending_flat_rounded);

  const ForecastTrend(this.value, this.label, this.color, this.icon);
  final String value;
  final String label;
  final Color color;
  final IconData icon;

  /// Obtém a cor dinâmica da tendência (requer BuildContext)
  Color dynamicColor(BuildContext context) {
    final colors = ThemeColors.of(context);
    switch (this) {
      case ForecastTrend.alta:
        return colors.success;
      case ForecastTrend.baixa:
        return colors.error;
      case ForecastTrend.estavel:
        return colors.blueMain;
    }
  }

  static ForecastTrend fromString(String value) {
    final normalized = value.toLowerCase().trim();
    return ForecastTrend.values.firstWhere(
      (trend) => trend.value == normalized || trend.name.toLowerCase() == normalized,
      orElse: () => ForecastTrend.estavel,
    );
  }
}

// ============================================================================
// AI FORECAST / PREVISO COM IA MODELS
// ============================================================================

/// Modelo de Previs�o de Produto com IA
/// 
/// Representa uma previs�o de demanda para um produto espec�fico.
class ForecastPredictionModel {
  final String id;
  final String nome;
  final int vendasAtuais;
  final int previsao;
  final int confianca;
  final ForecastTrend tendencia;
  final Color cor;
  final String impacto;
  final String elasticidade;

  const ForecastPredictionModel({
    required this.id,
    required this.nome,
    required this.vendasAtuais,
    required this.previsao,
    required this.confianca,
    required this.tendencia,
    required this.cor,
    required this.impacto,
    required this.elasticidade,
  });

  ForecastPredictionModel copyWith({
    String? id,
    String? nome,
    int? vendasAtuais,
    int? previsao,
    int? confianca,
    ForecastTrend? tendencia,
    Color? cor,
    String? impacto,
    String? elasticidade,
  }) {
    return ForecastPredictionModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      vendasAtuais: vendasAtuais ?? this.vendasAtuais,
      previsao: previsao ?? this.previsao,
      confianca: confianca ?? this.confianca,
      tendencia: tendencia ?? this.tendencia,
      cor: cor ?? this.cor,
      impacto: impacto ?? this.impacto,
      elasticidade: elasticidade ?? this.elasticidade,
    );
  }

  double get diferencaPercentual {
    if (vendasAtuais == 0) return 0;
    return ((previsao - vendasAtuais) / vendasAtuais) * 100;
  }

  String get diferencaFormatted {
    final diff = diferencaPercentual;
    if (diff > 0) return '+${diff.toStringAsFixed(1)}%';
    if (diff < 0) return '${diff.toStringAsFixed(1)}%';
    return '0%';
  }
  
  // Aliases para compatibilidade
  ForecastTrend get trend => tendencia;
  Color get color => cor;
  String get name => nome;
  int get confidence => confianca;
  int get currentSales => vendasAtuais;
  int get predictedSales => previsao;
  String get impact => impacto;
  String get elasticity => elasticidade;

  factory ForecastPredictionModel.fromJson(Map<String, dynamic> json) {
    return ForecastPredictionModel(
      id: json['id'] as String? ?? '',
      nome: json['nome'] as String? ?? json['name'] as String? ?? '',
      vendasAtuais: json['vendas'] as int? ?? json['vendasAtuais'] as int? ?? json['currentSales'] as int? ?? 0,
      previsao: json['previsao'] as int? ?? json['forecast'] as int? ?? 0,
      confianca: json['confianca'] as int? ?? json['confidence'] as int? ?? 0,
      tendencia: ForecastTrend.fromString(json['tendencia'] as String? ?? json['trend'] as String? ?? 'estavel'),
      cor: StrategyModel.parseColor(json['cor'] ?? json['color']) ?? AppThemeColors.blueMain,
      impacto: json['impacto'] as String? ?? json['impact'] as String? ?? 'R\$ 0',
      elasticidade: json['elasticidade'] as String? ?? json['elasticity'] as String? ?? 'M�dia',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'vendasAtuais': vendasAtuais,
      'previsao': previsao,
      'confianca': confianca,
      'tendencia': tendencia.value,
      'impacto': impacto,
      'elasticidade': elasticidade,
    };
  }
}

/// Modelo de Fator de Peso para IA
/// 
/// Representa um fator que influencia a previs�o de demanda com seu peso.
class ForecastFactorModel {
  final String id;
  final String nome;
  final double peso;
  final Color cor;
  final IconData icone;
  final String descricao;

  const ForecastFactorModel({
    required this.id,
    required this.nome,
    required this.peso,
    required this.cor,
    required this.icone,
    required this.descricao,
  });

  ForecastFactorModel copyWith({
    String? id,
    String? nome,
    double? peso,
    Color? cor,
    IconData? icone,
    String? descricao,
  }) {
    return ForecastFactorModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      peso: peso ?? this.peso,
      cor: cor ?? this.cor,
      icone: icone ?? this.icone,
      descricao: descricao ?? this.descricao,
    );
  }

  String get pesoFormatted => '${peso.toStringAsFixed(0)}%';
  
  // Aliases
  double get weight => peso;
  String get name => nome;
  Color get color => cor;

  factory ForecastFactorModel.fromJson(Map<String, dynamic> json) {
    return ForecastFactorModel(
      id: json['id'] as String? ?? '',
      nome: json['nome'] as String? ?? json['name'] as String? ?? '',
      peso: (json['peso'] as num?)?.toDouble() ?? (json['weight'] as num?)?.toDouble() ?? 0.0,
      cor: StrategyModel.parseColor(json['cor'] ?? json['color']) ?? AppThemeColors.blueMain,
      icone: _parseForecastIcon(json['icone'] ?? json['icon']),
      descricao: json['descricao'] as String? ?? json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'peso': peso,
      'descricao': descricao,
    };
  }

  static IconData _parseForecastIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.analytics_rounded;
  }
}

/// Modelo de Status do Motor de IA
/// 
/// Representa o estado atual do modelo de machine learning.
class ForecastModelStatus {
  final bool isActive;
  final bool isTrained;
  final String lastTraining;
  final double precision;
  final int totalProducts;
  final int totalPredictions;

  const ForecastModelStatus({
    required this.isActive,
    required this.isTrained,
    required this.lastTraining,
    required this.precision,
    required this.totalProducts,
    required this.totalPredictions,
  });

  ForecastModelStatus copyWith({
    bool? isActive,
    bool? isTrained,
    String? lastTraining,
    double? precision,
    int? totalProducts,
    int? totalPredictions,
  }) {
    return ForecastModelStatus(
      isActive: isActive ?? this.isActive,
      isTrained: isTrained ?? this.isTrained,
      lastTraining: lastTraining ?? this.lastTraining,
      precision: precision ?? this.precision,
      totalProducts: totalProducts ?? this.totalProducts,
      totalPredictions: totalPredictions ?? this.totalPredictions,
    );
  }

  String get precisionFormatted => '${precision.toStringAsFixed(0)}%';

  factory ForecastModelStatus.fromJson(Map<String, dynamic> json) {
    return ForecastModelStatus(
      isActive: json['ativo'] as bool? ?? json['isActive'] as bool? ?? false,
      isTrained: json['treinado'] as bool? ?? json['isTrained'] as bool? ?? false,
      lastTraining: json['ultimoTreinamento'] as String? ?? json['lastTraining'] as String? ?? '',
      precision: (json['precisao'] as num?)?.toDouble() ?? (json['precision'] as num?)?.toDouble() ?? 0.0,
      totalProducts: json['totalProdutos'] as int? ?? json['totalProducts'] as int? ?? 0,
      totalPredictions: json['totalPrevisoes'] as int? ?? json['totalPredictions'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isActive': isActive,
      'isTrained': isTrained,
      'lastTraining': lastTraining,
      'precision': precision,
      'totalProducts': totalProducts,
      'totalPredictions': totalPredictions,
    };
  }
}

// ============================================================================
// AUTO AUDIT / AUDITORIA AUTOM�TICA MODELS
// ============================================================================

/// Modelo de Verifica��o de Auditoria
class AuditVerificationModel {
  final String id;
  final String nome;
  final bool ativo;
  final IconData icone;

  const AuditVerificationModel({
    required this.id,
    required this.nome,
    required this.ativo,
    required this.icone,
  });

  AuditVerificationModel copyWith({
    String? id,
    String? nome,
    bool? ativo,
    IconData? icone,
  }) {
    return AuditVerificationModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      ativo: ativo ?? this.ativo,
      icone: icone ?? this.icone,
    );
  }

  factory AuditVerificationModel.fromJson(Map<String, dynamic> json) {
    return AuditVerificationModel(
      id: json['id'] as String? ?? '',
      nome: json['nome'] as String? ?? json['name'] as String? ?? '',
      ativo: json['ativo'] as bool? ?? json['active'] as bool? ?? false,
      icone: _parseAuditIcon(json['icone'] ?? json['icon']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'ativo': ativo,
    };
  }

  static IconData _parseAuditIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.check_circle_rounded;
  }
}

/// Modelo de Registro de Auditoria
class AuditRecordModel {
  final String id;
  final String data;
  final int problemas;
  final String status;
  final Color cor;
  final String detalhes;
  final String duracao;
  final String acoes;

  const AuditRecordModel({
    required this.id,
    required this.data,
    required this.problemas,
    required this.status,
    required this.cor,
    required this.detalhes,
    required this.duracao,
    required this.acoes,
  });

  AuditRecordModel copyWith({
    String? id,
    String? data,
    int? problemas,
    String? status,
    Color? cor,
    String? detalhes,
    String? duracao,
    String? acoes,
  }) {
    return AuditRecordModel(
      id: id ?? this.id,
      data: data ?? this.data,
      problemas: problemas ?? this.problemas,
      status: status ?? this.status,
      cor: cor ?? this.cor,
      detalhes: detalhes ?? this.detalhes,
      duracao: duracao ?? this.duracao,
      acoes: acoes ?? this.acoes,
    );
  }

  bool get isSuccess => status.toLowerCase() == 'conclu�da';
  bool get needsAttention => status.toLowerCase() == 'aten��o';
  bool get hasNoProblems => problemas == 0;

  factory AuditRecordModel.fromJson(Map<String, dynamic> json) {
    return AuditRecordModel(
      id: json['id'] as String? ?? '',
      data: json['data'] as String? ?? '',
      problemas: json['problemas'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      cor: StrategyModel.parseColor(json['cor'] ?? json['color']) ?? const Color(0xFF4CAF50),
      detalhes: json['detalhes'] as String? ?? json['details'] as String? ?? '',
      duracao: json['duracao'] as String? ?? json['duration'] as String? ?? '',
      acoes: json['acoes'] as String? ?? json['actions'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'problemas': problemas,
      'status': status,
      'detalhes': detalhes,
      'duracao': duracao,
      'acoes': acoes,
    };
  }
}




