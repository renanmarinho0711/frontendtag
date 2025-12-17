// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Enum para tipos de relat�rio
enum ReportType {
  sales,
  audit,
  operational,
  performance;

  String get label {
    switch (this) {
      case ReportType.sales:
        return 'Vendas';
      case ReportType.audit:
        return 'Auditoria';
      case ReportType.operational:
        return 'Operacional';
      case ReportType.performance:
        return 'Performance';
    }
  }

  IconData get icon {
    switch (this) {
      case ReportType.sales:
        return Icons.point_of_sale_rounded;
      case ReportType.audit:
        return Icons.fact_check_rounded;
      case ReportType.operational:
        return Icons.settings_rounded;
      case ReportType.performance:
        return Icons.speed_rounded;
    }
  }
}

/// Enum para trend do relatório
enum ReportTrend {
  up,
  down,
  stable;

  Color get color {
    switch (this) {
      case ReportTrend.up:
        return const Color(0xFF4CAF50);
      case ReportTrend.down:
        return const Color(0xFFFF5252);
      case ReportTrend.stable:
        return const Color(0xFF9E9E9E);
    }
  }

  /// Obtém a cor dinâmica do trend (requer BuildContext)
  Color dynamicColor(BuildContext context) {
    final colors = ThemeColors.of(context);
    switch (this) {
      case ReportTrend.up:
        return colors.success;
      case ReportTrend.down:
        return colors.error;
      case ReportTrend.stable:
        return colors.grey500;
    }
  }

  IconData get icon {
    switch (this) {
      case ReportTrend.up:
        return Icons.trending_up_rounded;
      case ReportTrend.down:
        return Icons.trending_down_rounded;
      case ReportTrend.stable:
        return Icons.trending_flat_rounded;
    }
  }
}

/// Modelo de Relat�rio de Vendas
class SalesReportModel {
  final String id;
  final String titulo;
  final String subtitulo;
  final IconData icone;
  final Color cor;
  final String valor;
  final double valorNumerico;
  final String quantidade;
  final int quantidadeNumerica;
  final String detalhes;
  final String meta;
  final double percentual;
  final ReportTrend trend;
  final String crescimento;
  final String? badge;

  const SalesReportModel({
    required this.id,
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.cor,
    required this.valor,
    required this.valorNumerico,
    required this.quantidade,
    required this.quantidadeNumerica,
    required this.detalhes,
    required this.meta,
    required this.percentual,
    required this.trend,
    required this.crescimento,
    this.badge,
  });

  factory SalesReportModel.fromJson(Map<String, dynamic> json) {
    return SalesReportModel(
      id: json['id'] as String? ?? '',
      titulo: json['titulo'] as String,
      subtitulo: json['subtitulo'] as String,
      icone: Icons.analytics_rounded, // Default - parsing de IconData � complexo
      cor: _parseColor(json['cor']),
      valor: json['valor'] as String,
      valorNumerico: (json['valorNumerico'] as num?)?.toDouble() ?? 0.0,
      quantidade: json['quantidade'] as String,
      quantidadeNumerica: json['quantidadeNumerica'] as int? ?? 0,
      detalhes: json['detalhes'] as String,
      meta: json['meta'] as String,
      percentual: (json['percentual'] as num?)?.toDouble() ?? 0.0,
      trend: _parseTrend(json['trend']),
      crescimento: json['crescimento'] as String,
      badge: json['badge'] as String?,
    );
  }

  static Color _parseColor(dynamic colorValue) {
    if (colorValue == null) return const Color(0xFF9E9E9E);
    if (colorValue is Color) return colorValue;
    if (colorValue is int) return Color(colorValue);
    if (colorValue is String) {
      String hex = colorValue.replaceAll('#', '');
      if (hex.length == 6) hex = 'FF$hex';
      return Color(int.parse(hex, radix: 16));
    }
    return const Color(0xFF9E9E9E);
  }

  static ReportTrend _parseTrend(dynamic trendValue) {
    if (trendValue == null) return ReportTrend.stable;
    if (trendValue is String) {
      switch (trendValue.toLowerCase()) {
        case 'up':
          return ReportTrend.up;
        case 'down':
          return ReportTrend.down;
        default:
          return ReportTrend.stable;
      }
    }
    return ReportTrend.stable;
  }

  /// Obtém a cor dinâmica baseada no trend (requer BuildContext)
  /// Use este método em widgets ao invés da propriedade [cor]
  Color dynamicCor(BuildContext context) {
    final colors = ThemeColors.of(context);
    return trend == ReportTrend.up ? colors.success : 
           trend == ReportTrend.down ? colors.error : colors.primary;
  }
}

/// Modelo de Relat�rio de Auditoria
class AuditReportModel {
  final String id;
  final String titulo;
  final String descricao;
  final DateTime dataAuditoria;
  final String auditor;
  final int itensVerificados;
  final int itensComProblema;
  final double percentualConformidade;
  final List<AuditItemModel> itens;

  const AuditReportModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.dataAuditoria,
    required this.auditor,
    required this.itensVerificados,
    required this.itensComProblema,
    required this.percentualConformidade,
    this.itens = const [],
  });

  bool get hasProblems => itensComProblema > 0;

  factory AuditReportModel.fromJson(Map<String, dynamic> json) {
    return AuditReportModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String? ?? '',
      dataAuditoria: DateTime.parse(json['dataAuditoria'] as String),
      auditor: json['auditor'] as String,
      itensVerificados: json['itensVerificados'] as int? ?? 0,
      itensComProblema: json['itensComProblema'] as int? ?? 0,
      percentualConformidade: (json['percentualConformidade'] as num?)?.toDouble() ?? 0.0,
      itens: (json['itens'] as List<dynamic>?)
          ?.map((e) => AuditItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

/// Item de auditoria
class AuditItemModel {
  final String id;
  final String descricao;
  final bool conforme;
  final String? observacao;

  const AuditItemModel({
    required this.id,
    required this.descricao,
    required this.conforme,
    this.observacao,
  });

  factory AuditItemModel.fromJson(Map<String, dynamic> json) {
    return AuditItemModel(
      id: json['id'] as String,
      descricao: json['descricao'] as String,
      conforme: json['conforme'] as bool? ?? true,
      observacao: json['observacao'] as String?,
    );
  }
}

/// Modelo de Relat�rio Operacional
class OperationalReportModel {
  final String id;
  final String titulo;
  final String categoria;
  final IconData icone;
  final Color cor;
  final String valor;
  final String unidade;
  final double percentualMeta;
  final ReportTrend trend;
  final String periodo;

  const OperationalReportModel({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.icone,
    required this.cor,
    required this.valor,
    required this.unidade,
    required this.percentualMeta,
    required this.trend,
    required this.periodo,
  });

  factory OperationalReportModel.fromJson(Map<String, dynamic> json) {
    return OperationalReportModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      categoria: json['categoria'] as String,
      icone: Icons.settings_rounded,
      cor: SalesReportModel._parseColor(json['cor']),
      valor: json['valor'] as String,
      unidade: json['unidade'] as String? ?? '',
      percentualMeta: (json['percentualMeta'] as num?)?.toDouble() ?? 0.0,
      trend: SalesReportModel._parseTrend(json['trend']),
      periodo: json['periodo'] as String? ?? '',
    );
  }

  /// Obtém a cor dinâmica baseada no percentual da meta (requer BuildContext)
  /// Use este método em widgets ao invés da propriedade [cor]
  Color dynamicCor(BuildContext context) {
    final colors = ThemeColors.of(context);
    if (percentualMeta >= 100) return colors.success;
    if (percentualMeta >= 80) return colors.primary;
    if (percentualMeta >= 50) return colors.warning;
    return colors.error;
  }
}

/// Modelo de Relat�rio de Performance
class PerformanceReportModel {
  final String id;
  final String metrica;
  final String descricao;
  final double valorAtual;
  final double valorAnterior;
  final double meta;
  final String unidade;
  final ReportTrend trend;
  final double variacao;

  const PerformanceReportModel({
    required this.id,
    required this.metrica,
    required this.descricao,
    required this.valorAtual,
    required this.valorAnterior,
    required this.meta,
    required this.unidade,
    required this.trend,
    required this.variacao,
  });

  double get percentualMeta => meta > 0 ? (valorAtual / meta) * 100 : 0;
  bool get metaAtingida => valorAtual >= meta;

  factory PerformanceReportModel.fromJson(Map<String, dynamic> json) {
    return PerformanceReportModel(
      id: json['id'] as String,
      metrica: json['metrica'] as String,
      descricao: json['descricao'] as String? ?? '',
      valorAtual: (json['valorAtual'] as num?)?.toDouble() ?? 0.0,
      valorAnterior: (json['valorAnterior'] as num?)?.toDouble() ?? 0.0,
      meta: (json['meta'] as num?)?.toDouble() ?? 0.0,
      unidade: json['unidade'] as String? ?? '',
      trend: SalesReportModel._parseTrend(json['trend']),
      variacao: (json['variacao'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// Resumo geral de relat�rios
class ReportsSummaryModel {
  final int totalVendas;
  final double faturamentoTotal;
  final int produtosVendidos;
  final double ticketMedio;
  final int auditoriasPendentes;
  final double conformidadeGeral;

  const ReportsSummaryModel({
    required this.totalVendas,
    required this.faturamentoTotal,
    required this.produtosVendidos,
    required this.ticketMedio,
    required this.auditoriasPendentes,
    required this.conformidadeGeral,
  });

  factory ReportsSummaryModel.fromJson(Map<String, dynamic> json) {
    return ReportsSummaryModel(
      totalVendas: json['totalVendas'] as int? ?? 0,
      faturamentoTotal: (json['faturamentoTotal'] as num?)?.toDouble() ?? 0.0,
      produtosVendidos: json['produtosVendidos'] as int? ?? 0,
      ticketMedio: (json['ticketMedio'] as num?)?.toDouble() ?? 0.0,
      auditoriasPendentes: json['auditoriasPendentes'] as int? ?? 0,
      conformidadeGeral: (json['conformidadeGeral'] as num?)?.toDouble() ?? 0.0,
    );
  }
}



