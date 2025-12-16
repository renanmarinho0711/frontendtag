import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/models/strategy_base_models.dart';

// ============================================================================
// TEMPERATURE/ENVIRONMENTAL MODELS
// ============================================================================

/// Modelo de Faixa de Temperatura
/// 
/// Representa uma faixa de temperatura com ajuste de pre�o associado.
/// Usado na estrat�gia de precifica��o por temperatura.
class TemperatureRangeModel {
  final String id;
  final String range;
  final String title;
  final double adjustment;
  final List<String> products;
  final String colorKey; // Semantic color key
  final IconData icon;
  final String description;

  const TemperatureRangeModel({
    required this.id,
    required this.range,
    required this.title,
    required this.adjustment,
    required this.products,
    required this.colorKey,
    required this.icon,
    required this.description,
  });

  TemperatureRangeModel copyWith({
    String? id,
    String? range,
    String? title,
    double? adjustment,
    List<String>? products,
    String? colorKey,
    IconData? icon,
    String? description,
  }) {
    return TemperatureRangeModel(
      id: id ?? this.id,
      range: range ?? this.range,
      title: title ?? this.title,
      adjustment: adjustment ?? this.adjustment,
      products: products ?? this.products,
      colorKey: colorKey ?? this.colorKey,
      icon: icon ?? this.icon,
      description: description ?? this.description,
    );
  }

  String get adjustmentFormatted {
    if (adjustment > 0) return '+${adjustment.toStringAsFixed(0)}%';
    if (adjustment < 0) return '${adjustment.toStringAsFixed(0)}%';
    return '0%';
  }

  bool get isPositiveAdjustment => adjustment > 0;
  bool get isNegativeAdjustment => adjustment < 0;
  bool get isNoAdjustment => adjustment == 0;

  factory TemperatureRangeModel.fromJson(Map<String, dynamic> json) {
    return TemperatureRangeModel(
      id: json['id'] as String? ?? '',
      range: json['faixa'] as String? ?? json['range'] as String? ?? '',
      title: json['titulo'] as String? ?? json['title'] as String? ?? '',
      adjustment: (json['ajuste'] as num?)?.toDouble() ?? (json['adjustment'] as num?)?.toDouble() ?? 0.0,
      products: (json['produtos'] as List<dynamic>?)?.cast<String>() ?? 
                (json['products'] as List<dynamic>?)?.cast<String>() ?? [],
      colorKey: _parseColorKey(json['cor'] ?? json['color']) ?? 'blueMain',
      icon: _parseTemperatureIcon(json['icone'] ?? json['icon']),
      description: json['descricao'] as String? ?? json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'range': range,
      'title': title,
      'adjustment': adjustment,
      'products': products,
      'description': description,
    };
  }

  static IconData _parseTemperatureIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.thermostat_rounded;
  }
}

/// Helper para parsear color key
String _parseColorKey(dynamic value) {
  if (value is String) return value;
  return 'primary'; // Default
}

/// Modelo de Hist�rico de Temperatura
/// 
/// Representa um registro de execu��o de ajuste baseado em temperatura.
class TemperatureHistoryModel {
  final String id;
  final String dateTime;
  final String temperature;
  final int adjustmentsCount;
  final String status;

  const TemperatureHistoryModel({
    required this.id,
    required this.dateTime,
    required this.temperature,
    required this.adjustmentsCount,
    required this.status,
  });

  TemperatureHistoryModel copyWith({
    String? id,
    String? dateTime,
    String? temperature,
    int? adjustmentsCount,
    String? status,
  }) {
    return TemperatureHistoryModel(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      temperature: temperature ?? this.temperature,
      adjustmentsCount: adjustmentsCount ?? this.adjustmentsCount,
      status: status ?? this.status,
    );
  }

  bool get isSuccess => status.toLowerCase() == 'executado';

  factory TemperatureHistoryModel.fromJson(Map<String, dynamic> json) {
    return TemperatureHistoryModel(
      id: json['id'] as String? ?? '',
      dateTime: json['data'] as String? ?? json['dateTime'] as String? ?? '',
      temperature: json['temp'] as String? ?? json['temperature'] as String? ?? '',
      adjustmentsCount: json['ajustes'] as int? ?? json['adjustmentsCount'] as int? ?? 0,
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime,
      'temperature': temperature,
      'adjustmentsCount': adjustmentsCount,
      'status': status,
    };
  }
}





