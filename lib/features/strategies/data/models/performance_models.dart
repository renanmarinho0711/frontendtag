import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/models/strategy_base_models.dart';

// ============================================================================
// PEAK HOURS MODELS
// ============================================================================

/// Modelo de Hor�rio de Pico
///
/// Representa um per�odo do dia com ajuste de pre�o baseado no fluxo de clientes.
/// Usado na estrat�gia de precifica��o por hor�rio de pico.
class PeakHourModel {
  final String id;
  final String periodo;
  final String horario;
  final String tipo;
  final double ajuste;
  final String corKey; // Semantic color key
  final IconData icone;
  final String descricao;
  final List<String> produtos;

  const PeakHourModel({
    required this.id,
    required this.periodo,
    required this.horario,
    required this.tipo,
    required this.ajuste,
    required this.corKey,
    required this.icone,
    required this.descricao,
    required this.produtos,
  });

  PeakHourModel copyWith({
    String? id,
    String? periodo,
    String? horario,
    String? tipo,
    double? ajuste,
    String? corKey,
    IconData? icone,
    String? descricao,
    List<String>? produtos,
  }) {
    return PeakHourModel(
      id: id ?? this.id,
      periodo: periodo ?? this.periodo,
      horario: horario ?? this.horario,
      tipo: tipo ?? this.tipo,
      ajuste: ajuste ?? this.ajuste,
      corKey: corKey ?? this.corKey,
      icone: icone ?? this.icone,
      descricao: descricao ?? this.descricao,
      produtos: produtos ?? this.produtos,
    );
  }

  String get ajusteFormatted {
    if (ajuste > 0) return '+${ajuste.toStringAsFixed(0)}%';
    if (ajuste < 0) return '${ajuste.toStringAsFixed(0)}%';
    return '0%';
  }

  bool get isPositiveAdjustment => ajuste > 0;
  bool get isNegativeAdjustment => ajuste < 0;
  bool get isNoAdjustment => ajuste == 0;

  factory PeakHourModel.fromJson(Map<String, dynamic> json) {
    return PeakHourModel(
      id: json['id'] as String? ?? '',
      periodo: json['periodo'] as String? ?? '',
      horario: json['horario'] as String? ?? '',
      tipo: json['tipo'] as String? ?? '',
      ajuste: (json['ajuste'] as num?)?.toDouble() ?? 0.0,
      corKey: _parseColorKey(json['cor'] ?? json['color']) ?? 'blueMain',
      icone: _parsePeakHourIcon(json['icone'] ?? json['icon']),
      descricao: json['descricao'] as String? ?? json['description'] as String? ?? '',
      produtos: (json['produtos'] as List<dynamic>?)?.cast<String>() ??
                (json['products'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'periodo': periodo,
      'horario': horario,
      'tipo': tipo,
      'ajuste': ajuste,
      'descricao': descricao,
      'produtos': produtos,
    };
  }

  static IconData _parsePeakHourIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.schedule_rounded;
  }
}

/// Modelo de Dia da Semana
///
/// Representa um dia da semana com seu n�vel de movimento e status ativo.
class WeekDayModel {
  final String id;
  final String dia;
  final double movimento;
  final bool ativo;

  const WeekDayModel({
    required this.id,
    required this.dia,
    required this.movimento,
    required this.ativo,
  });

  WeekDayModel copyWith({
    String? id,
    String? dia,
    double? movimento,
    bool? ativo,
  }) {
    return WeekDayModel(
      id: id ?? this.id,
      dia: dia ?? this.dia,
      movimento: movimento ?? this.movimento,
      ativo: ativo ?? this.ativo,
    );
  }

  String get movimentoFormatted => '${(movimento * 100).toStringAsFixed(0)}%';

  factory WeekDayModel.fromJson(Map<String, dynamic> json) {
    return WeekDayModel(
      id: json['id'] as String? ?? '',
      dia: json['dia'] as String? ?? '',
      movimento: (json['movimento'] as num?)?.toDouble() ?? 0.0,
      ativo: json['ativo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dia': dia,
      'movimento': movimento,
      'ativo': ativo,
    };
  }
}

/// Modelo de Hist�rico de Execu��o de Hor�rio de Pico
///
/// Representa um registro de execu��o de ajuste baseado em hor�rio de pico.
class PeakHourHistoryModel {
  final String id;
  final String data;
  final String periodo;
  final int ajustes;
  final String tipo;

  const PeakHourHistoryModel({
    required this.id,
    required this.data,
    required this.periodo,
    required this.ajustes,
    required this.tipo,
  });

  PeakHourHistoryModel copyWith({
    String? id,
    String? data,
    String? periodo,
    int? ajustes,
    String? tipo,
  }) {
    return PeakHourHistoryModel(
      id: id ?? this.id,
      data: data ?? this.data,
      periodo: periodo ?? this.periodo,
      ajustes: ajustes ?? this.ajustes,
      tipo: tipo ?? this.tipo,
    );
  }

  factory PeakHourHistoryModel.fromJson(Map<String, dynamic> json) {
    return PeakHourHistoryModel(
      id: json['id'] as String? ?? '',
      data: json['data'] as String? ?? '',
      periodo: json['periodo'] as String? ?? '',
      ajustes: json['ajustes'] as int? ?? 0,
      tipo: json['tipo'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'periodo': periodo,
      'ajustes': ajustes,
      'tipo': tipo,
    };
  }
}

/// Helper para parsear color key
String _parseColorKey(dynamic value) {
  if (value is String) return value;
  return 'primary'; // Default
}





