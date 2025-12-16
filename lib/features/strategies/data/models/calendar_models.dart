import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/models/strategy_base_models.dart';

// ============================================================================
// CALENDAR EVENT MODELS
// ============================================================================

/// Modelo de Evento Comemorativo (Datas Comemorativas)
/// 
/// Representa um feriado ou data comemorativa que pode ter ajuste de pre?o autom?tico.
class HolidayEventModel {
  final String id;
  final String name;
  final String emoji;
  final String dateLabel;
  final bool isActive;
  final double adjustment;
  final int daysInAdvance;
  final List<String> categories;
  final IconData icon;
  final String colorKey; // Semantic color key
  final String description;
  final String nextDate;

  const HolidayEventModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.dateLabel,
    required this.isActive,
    required this.adjustment,
    required this.daysInAdvance,
    required this.categories,
    required this.icon,
    required this.colorKey,
    required this.description,
    required this.nextDate,
  });

  HolidayEventModel copyWith({
    String? id,
    String? name,
    String? emoji,
    String? dateLabel,
    bool? isActive,
    double? adjustment,
    int? daysInAdvance,
    List<String>? categories,
    IconData? icon,
    String? colorKey,
    String? description,
    String? nextDate,
  }) {
    return HolidayEventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      dateLabel: dateLabel ?? this.dateLabel,
      isActive: isActive ?? this.isActive,
      adjustment: adjustment ?? this.adjustment,
      daysInAdvance: daysInAdvance ?? this.daysInAdvance,
      categories: categories ?? this.categories,
      icon: icon ?? this.icon,
      colorKey: colorKey ?? this.colorKey,
      description: description ?? this.description,
      nextDate: nextDate ?? this.nextDate,
    );
  }

  String get adjustmentFormatted {
    if (adjustment > 0) return '+${adjustment.toStringAsFixed(0)}%';
    if (adjustment < 0) return '${adjustment.toStringAsFixed(0)}%';
    return '0%';
  }

  bool get isPositiveAdjustment => adjustment > 0;
  bool get isNegativeAdjustment => adjustment < 0;

  factory HolidayEventModel.fromJson(Map<String, dynamic> json) {
    return HolidayEventModel(
      id: json['id'] as String? ?? '',
      name: json['nome'] as String? ?? json['name'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '??',
      dateLabel: json['data'] as String? ?? json['dateLabel'] as String? ?? '',
      isActive: json['ativo'] as bool? ?? json['isActive'] as bool? ?? false,
      adjustment: (json['ajuste'] as num?)?.toDouble() ?? (json['adjustment'] as num?)?.toDouble() ?? 0.0,
      daysInAdvance: json['diasAntecedencia'] as int? ?? json['daysInAdvance'] as int? ?? 0,
      categories: (json['categorias'] as List<dynamic>?)?.cast<String>() ?? 
                  (json['categories'] as List<dynamic>?)?.cast<String>() ?? [],
      icon: _parseIcon(json['icone'] ?? json['icon']),
      colorKey: _parseColorKey(json['cor'] ?? json['color']) ?? 'blueMain',
      description: json['descricao'] as String? ?? json['description'] as String? ?? '',
      nextDate: json['proximaData'] as String? ?? json['nextDate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'dateLabel': dateLabel,
      'isActive': isActive,
      'adjustment': adjustment,
      'daysInAdvance': daysInAdvance,
      'categories': categories,
      'description': description,
      'nextDate': nextDate,
    };
  }

  static IconData _parseIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.celebration_rounded;
  }
}

/// Modelo de Feriado Prolongado
class LongHolidayModel {
  final String id;
  final String name;
  final String startDate;
  final String endDate;
  final int days;
  final bool isActive;
  final double adjustment;
  final List<String> categories;
  final IconData icon;
  final String colorKey; // Semantic color key
  final String description;
  final String tipo;
  final int diasPonte;
  final String data;

  const LongHolidayModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.isActive,
    required this.adjustment,
    required this.categories,
    required this.icon,
    required this.colorKey,
    required this.description,
    this.tipo = 'Normal',
    this.diasPonte = 1,
    this.data = '',
  });

  LongHolidayModel copyWith({
    String? id,
    String? name,
    String? startDate,
    String? endDate,
    int? days,
    bool? isActive,
    double? adjustment,
    List<String>? categories,
    IconData? icon,
    String? colorKey,
    String? description,
    String? tipo,
    int? diasPonte,
    String? data,
  }) {
    return LongHolidayModel(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      days: days ?? this.days,
      isActive: isActive ?? this.isActive,
      adjustment: adjustment ?? this.adjustment,
      categories: categories ?? this.categories,
      icon: icon ?? this.icon,
      colorKey: colorKey ?? this.colorKey,
      description: description ?? this.description,
      tipo: tipo ?? this.tipo,
      diasPonte: diasPonte ?? this.diasPonte,
      data: data ?? this.data,
    );
  }

  String get adjustmentFormatted {
    if (adjustment > 0) return '+${adjustment.toStringAsFixed(0)}%';
    if (adjustment < 0) return '${adjustment.toStringAsFixed(0)}%';
    return '0%';
  }

  String get dateRange => '$startDate - $endDate';

  factory LongHolidayModel.fromJson(Map<String, dynamic> json) {
    return LongHolidayModel(
      id: json['id'] as String? ?? '',
      name: json['nome'] as String? ?? json['name'] as String? ?? '',
      startDate: json['dataInicio'] as String? ?? json['startDate'] as String? ?? '',
      endDate: json['dataFim'] as String? ?? json['endDate'] as String? ?? '',
      days: json['dias'] as int? ?? json['days'] as int? ?? 1,
      isActive: json['ativo'] as bool? ?? json['isActive'] as bool? ?? false,
      adjustment: (json['ajuste'] as num?)?.toDouble() ?? (json['adjustment'] as num?)?.toDouble() ?? 0.0,
      categories: (json['categorias'] as List<dynamic>?)?.cast<String>() ?? 
                  (json['categories'] as List<dynamic>?)?.cast<String>() ?? [],
      icon: _parseHolidayIcon(json['icone'] ?? json['icon']),
      colorKey: _parseColorKey(json['cor'] ?? json['color']) ?? 'blueMain',
      description: json['descricao'] as String? ?? json['description'] as String? ?? '',
      tipo: json['tipo'] as String? ?? 'Normal',
      diasPonte: json['diasPonte'] as int? ?? 1,
      data: json['data'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'days': days,
      'isActive': isActive,
      'adjustment': adjustment,
      'categories': categories,
      'description': description,
      'tipo': tipo,
      'diasPonte': diasPonte,
      'data': data,
    };
  }

  static IconData _parseHolidayIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.event_available_rounded;
  }
}

/// Modelo de Ciclo de Sal?rio
class SalaryCycleModel {
  final String id;
  final String name;
  final int dayOfMonth;
  final bool isActive;
  final double adjustment;
  final int daysRange;
  final List<String> categories;
  final IconData icon;
  final String colorKey; // Semantic color key
  final String description;

  const SalaryCycleModel({
    required this.id,
    required this.name,
    required this.dayOfMonth,
    required this.isActive,
    required this.adjustment,
    required this.daysRange,
    required this.categories,
    required this.icon,
    required this.colorKey,
    required this.description,
  });

  SalaryCycleModel copyWith({
    String? id,
    String? name,
    int? dayOfMonth,
    bool? isActive,
    double? adjustment,
    int? daysRange,
    List<String>? categories,
    IconData? icon,
    String? colorKey,
    String? description,
  }) {
    return SalaryCycleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      isActive: isActive ?? this.isActive,
      adjustment: adjustment ?? this.adjustment,
      daysRange: daysRange ?? this.daysRange,
      categories: categories ?? this.categories,
      icon: icon ?? this.icon,
      colorKey: colorKey ?? this.colorKey,
      description: description ?? this.description,
    );
  }

  String get adjustmentFormatted {
    if (adjustment > 0) return '+${adjustment.toStringAsFixed(0)}%';
    if (adjustment < 0) return '${adjustment.toStringAsFixed(0)}%';
    return '0%';
  }

  factory SalaryCycleModel.fromJson(Map<String, dynamic> json) {
    return SalaryCycleModel(
      id: json['id'] as String? ?? '',
      name: json['nome'] as String? ?? json['name'] as String? ?? '',
      dayOfMonth: json['diaMes'] as int? ?? json['dayOfMonth'] as int? ?? 5,
      isActive: json['ativo'] as bool? ?? json['isActive'] as bool? ?? false,
      adjustment: (json['ajuste'] as num?)?.toDouble() ?? (json['adjustment'] as num?)?.toDouble() ?? 0.0,
      daysRange: json['diasRange'] as int? ?? json['daysRange'] as int? ?? 3,
      categories: (json['categorias'] as List<dynamic>?)?.cast<String>() ?? 
                  (json['categories'] as List<dynamic>?)?.cast<String>() ?? [],
      icon: _parseSalaryIcon(json['icone'] ?? json['icon']),
      colorKey: _parseColorKey(json['cor'] ?? json['color']) ?? 'success',
      description: json['descricao'] as String? ?? json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dayOfMonth': dayOfMonth,
      'isActive': isActive,
      'adjustment': adjustment,
      'daysRange': daysRange,
      'categories': categories,
      'description': description,
    };
  }

  static IconData _parseSalaryIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.attach_money_rounded;
  }
}

/// Modelo de Hist?rico de Ajustes do Ciclo de Sal?rio
class SalaryAdjustmentHistoryModel {
  final String id;
  final String periodo;
  final String dateRange;
  final double adjustment;
  final int productsCount;
  final String revenue;
  final String colorKey; // Semantic color key

  const SalaryAdjustmentHistoryModel({
    required this.id,
    required this.periodo,
    required this.dateRange,
    required this.adjustment,
    required this.productsCount,
    required this.revenue,
    required this.colorKey,
  });

  String get adjustmentFormatted {
    if (adjustment > 0) return '+${adjustment.toStringAsFixed(0)}%';
    if (adjustment < 0) return '${adjustment.toStringAsFixed(0)}%';
    return '0%';
  }

  bool get isPositiveAdjustment => adjustment > 0;
  bool get isNegativeAdjustment => adjustment < 0;

  factory SalaryAdjustmentHistoryModel.fromJson(Map<String, dynamic> json) {
    return SalaryAdjustmentHistoryModel(
      id: json['id'] as String? ?? '',
      periodo: json['periodo'] as String? ?? '',
      dateRange: json['dateRange'] as String? ?? '',
      adjustment: (json['adjustment'] as num?)?.toDouble() ?? 0.0,
      productsCount: json['productsCount'] as int? ?? 0,
      revenue: json['revenue'] as String? ?? 'R\$ 0',
      colorKey: _parseColorKey(json['color']),
    );
  }
}

/// Helper para parsear color key
String _parseColorKey(dynamic value) {
  if (value is String) return value;
  return 'success'; // Default
}






