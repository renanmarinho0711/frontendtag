// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
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
        return 'auditoria';
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

/// Enum para trend do relat�rio
enum ReportTrend {
  up,
  down,
  stable;

  /// Returns semantic color key (resolved at runtime in UI)
  String get colorKey {
    switch (this) {
      case ReportTrend.up:
        return 'success'; // Verde
      case ReportTrend.down:
        return 'error'; // Vermelho
      case ReportTrend.stable:
        return 'disabled'; // Cinza
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
  final String corKey; // Semantic color key
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
    required this.corKey,
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
      corKey: _parseColorKey(json['cor']) ?? 'primary',
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

  @Deprecated('Use corKey instead')
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

  static String? _parseColorKey(dynamic colorValue) {
    if (colorValue is String) return colorValue;
    return null;
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
}

/// Modelo de Relat�rio de auditoria
class AuditReportModel {
  final String id;
  final String titulo;
  final String descricao;
  final DateTime dataauditoria;
  final String auditor;
  final int itensVerificados;
  final int itensComProblema;
  final double percentualConformidade;
  final List<AuditItemModel> itens;

  const AuditReportModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.dataauditoria,
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
      dataauditoria: DateTime.parse(json['dataauditoria'] as String),
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
  final String corKey; // Semantic color key
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
    required this.corKey,
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
      corKey: SalesReportModel._parseColorKey(json['cor']) ?? 'primary',
      valor: json['valor'] as String,
      unidade: json['unidade'] as String? ?? '',
      percentualMeta: (json['percentualMeta'] as num?)?.toDouble() ?? 0.0,
      trend: SalesReportModel._parseTrend(json['trend']),
      periodo: json['periodo'] as String? ?? '',
    );
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



