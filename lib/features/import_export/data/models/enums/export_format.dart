import 'package:flutter/material.dart';

/// Formatos de exportação suportados
enum ExportFormat {
  excel('excel', 'Microsoft Excel', '.xlsx', Icons.table_chart_rounded),
  csv('csv', 'CSV', '.csv', Icons.article_rounded),
  json('json', 'JSON', '.json', Icons.code_rounded),
  pdf('pdf', 'PDF', '.pdf', Icons.picture_as_pdf_rounded);

  const ExportFormat(this.id, this.name, this.extension, this.icon);
  
  final String id;
  final String name;
  final String extension;
  final IconData icon;
}
