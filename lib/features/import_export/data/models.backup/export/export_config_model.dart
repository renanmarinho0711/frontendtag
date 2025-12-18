import 'package:flutter/material.dart';
import '../enums/export_format.dart';
import '../enums/filter_status.dart';

/// Configuração de exportação
class ExportConfigModel {
  final ExportFormat format;
  final FilterStatus filterStatus;
  final bool includeLocation;
  final bool includeProducts;
  final bool includeMetrics;
  final bool includeHistory;
  final List<String> selectedColumns;
  final DateTimeRange? dateRange;
  final String? categoryId;
  final bool onlyActive;

  const ExportConfigModel({
    this.format = ExportFormat.excel,
    this.filterStatus = FilterStatus.all,
    this.includeLocation = true,
    this.includeProducts = true,
    this.includeMetrics = false,
    this.includeHistory = false,
    this.selectedColumns = const [],
    this.dateRange,
    this.categoryId,
    this.onlyActive = false,
  });

  int get totalColumns {
    int columns = 4; // Base columns
    if (includeLocation) columns += 2;
    if (includeProducts) columns += 3;
    if (includeMetrics) columns += 4;
    if (includeHistory) columns += 2;
    return columns;
  }

  ExportConfigModel copyWith({
    ExportFormat? format,
    FilterStatus? filterStatus,
    bool? includeLocation,
    bool? includeProducts,
    bool? includeMetrics,
    bool? includeHistory,
    List<String>? selectedColumns,
    DateTimeRange? dateRange,
    String? categoryId,
    bool? onlyActive,
  }) {
    return ExportConfigModel(
      format: format ?? this.format,
      filterStatus: filterStatus ?? this.filterStatus,
      includeLocation: includeLocation ?? this.includeLocation,
      includeProducts: includeProducts ?? this.includeProducts,
      includeMetrics: includeMetrics ?? this.includeMetrics,
      includeHistory: includeHistory ?? this.includeHistory,
      selectedColumns: selectedColumns ?? this.selectedColumns,
      dateRange: dateRange ?? this.dateRange,
      categoryId: categoryId ?? this.categoryId,
      onlyActive: onlyActive ?? this.onlyActive,
    );
  }

  Map<String, dynamic> toJson() => {
    'format': format.id,
    'filterStatus': filterStatus.id,
    'includeLocation': includeLocation,
    'includeProducts': includeProducts,
    'includeMetrics': includeMetrics,
    'includeHistory': includeHistory,
    'selectedColumns': selectedColumns,
    if (dateRange != null) 'dateRange': {
      'start': dateRange!.start.toIso8601String(),
      'end': dateRange!.end.toIso8601String(),
    },
    if (categoryId != null) 'categoryId': categoryId,
    'onlyActive': onlyActive,
  };
}
