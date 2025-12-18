import 'package:flutter/material.dart';

import 'package:tagbean/design_system/theme/theme_colors.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';



// ============================================================================

// STRATEGY ENUMS

// ============================================================================



/// Categoria da estrat�gia de precifica��o

enum StrategyCategory {

  calendar('Calend�rio', Icons.celebration_rounded, AppThemeColors.yellowGold),

  performance('Performance', Icons.trending_up_rounded, AppThemeColors.success),

  environmental('Ambiental', Icons.thermostat_rounded, AppThemeColors.yellowGold),

  engagement('Engajamento', Icons.map_rounded, AppThemeColors.urgent),

  crossSelling('Cross-Selling', Icons.compare_arrows_rounded, AppThemeColors.brownMain),

  visual('Visual', Icons.visibility_rounded, AppThemeColors.blueCyan);



  const StrategyCategory(this.label, this.icon, this.color);

  final String label;

  final IconData icon;

  final Color color;



  /// Parse from string (case-insensitive)

  static StrategyCategory fromString(String value) {

    final normalized = value.toLowerCase().trim();

    return StrategyCategory.values.firstWhere(

      (cat) => cat.label.toLowerCase() == normalized || cat.name.toLowerCase() == normalized,

      orElse: () => StrategyCategory.performance,

    );

  }

}



/// Status da estrat�gia

enum StrategyStatus {

  active('ativa', 'Ativa', AppThemeColors.success, Icons.play_circle_filled_rounded),

  paused('pausada', 'Pausada', AppThemeColors.warning, Icons.pause_circle_filled_rounded),

  inactive('inativa', 'Inativa', AppThemeColors.textLight, Icons.cancel_rounded),

  draft('rascunho', 'Rascunho', AppThemeColors.textSecondary, Icons.edit_rounded),

  scheduled('agendada', 'Agendada', AppThemeColors.blueMain, Icons.schedule_rounded),

  executing('executando', 'Executando', AppThemeColors.orangeMain, Icons.sync_rounded);



  const StrategyStatus(this.value, this.label, this.color, this.icon);

  final String value;

  final String label;

  final Color color;

  final IconData icon;



  /// Parse from string (case-insensitive)

  static StrategyStatus fromString(String value) {

    final normalized = value.toLowerCase().trim();

    return StrategyStatus.values.firstWhere(

      (status) => status.value == normalized || status.name.toLowerCase() == normalized,

      orElse: () => StrategyStatus.inactive,

    );

  }



  bool get isActive => this == StrategyStatus.active;

  bool get isPaused => this == StrategyStatus.paused;

  bool get isInactive => this == StrategyStatus.inactive;

  bool get isDraft => this == StrategyStatus.draft;

  bool get isScheduled => this == StrategyStatus.scheduled;

  bool get isExecuting => this == StrategyStatus.executing;

}



/// Status de execu��o de estrat�gia

enum ExecutionStatus {

  running('running', 'Em Execu��o', AppThemeColors.blueMain),

  completed('completed', 'Conclu�do', AppThemeColors.success),

  failed('failed', 'Falhou', AppThemeColors.error),

  partial('partial', 'Parcial', AppThemeColors.warning);



  const ExecutionStatus(this.value, this.label, this.color);

  final String value;

  final String label;

  final Color color;

}



// ============================================================================

// STRATEGY MODEL

// ============================================================================



/// Modelo principal de Estrat�gia de Precifica��o

/// 

/// Representa uma estrat�gia configur�vel que pode ser ativada, pausada ou inativa.

/// Cont�m m�tricas de desempenho, configura��es de execu��o e estat�sticas.

class StrategyModel {

  final String id;

  final String name;

  final String description;

  final String fullDescription;

  final StrategyCategory category;

  final StrategyStatus status;

  final IconData icon;

  final Color primaryColor;

  final List<Color> gradient;



  // M�tricas de impacto

  final String impactPercentage;

  final String impactValue;

  final int affectedProducts;



  // Execu��o

  final String? lastExecution;

  final String? nextExecution;

  final String frequency;



  // Performance

  final int reliability;

  final String savings;

  final String roi;

  final int successfulExecutions;

  final int totalExecutions;



  // Metadados

  final DateTime? createdAt;

  final DateTime? updatedAt;



  const StrategyModel({

    required this.id,

    required this.name,

    required this.description,

    required this.fullDescription,

    required this.category,

    required this.status,

    required this.icon,

    required this.primaryColor,

    required this.gradient,

    this.impactPercentage = '+0%',

    this.impactValue = 'R\$ 0',

    this.affectedProducts = 0,

    this.lastExecution,

    this.nextExecution,

    this.frequency = '',

    this.reliability = 0,

    this.savings = 'R\$ 0',

    this.roi = '0%',

    this.successfulExecutions = 0,

    this.totalExecutions = 0,

    this.createdAt,

    this.updatedAt,

  });



  // ============================================================================

  // COMPUTED PROPERTIES

  // ============================================================================



  /// Taxa de sucesso das execu��es (0-100)

  double get successRate {

    if (totalExecutions == 0) return 0;

    return (successfulExecutions / totalExecutions) * 100;

  }



  /// Verifica se a estrat�gia est� operacional

  bool get isOperational => status.isActive && affectedProducts > 0;


 // ignore: unused_element

  /// Cor do badge de status

  Color get statusColor => status.color;



  /// �cone do status

  IconData get statusIcon => status.icon;



  /// Label formatada do status

  String get statusLabel => status.label;



  /// �Última execu��o formatada (ou "-" se nunca executou)

  String get lastExecutionFormatted => lastExecution ?? '-';



  /// Pr�xima execu��o formatada (ou "-" se n�o agendada)

  String get nextExecutionFormatted => nextExecution ?? '-';

  

  /// Aliases para compatibilidade com telas

  String get impact => impactValue;

  int get products => affectedProducts;

  

  /// Alias para verificar se est� ativa

  bool get isActive => status.isActive;

  

  /// Aliases para compatibilidade com ai_suggestions_screen

  double get priceVariationPercent => 0.0; // Placeholder - estrat�gias n�o t�m esse dado diretamente

  double get targetMarginPercent => 0.0; // Placeholder - estrat�gias n�o t�m esse dado diretamente

  int get priority => reliability; // Usa reliability como proxy para prioridade



  // ============================================================================

  // COPY WITH

  // ============================================================================



  StrategyModel copyWith({

    String? id,

    String? name,

    String? description,

    String? fullDescription,

    StrategyCategory? category,

    StrategyStatus? status,

    IconData? icon,

    Color? primaryColor,

    List<Color>? gradient,

    String? impactPercentage,

    String? impactValue,

    int? affectedProducts,

    String? lastExecution,

    String? nextExecution,

    String? frequency,

    int? reliability,

    String? savings,

    String? roi,

    int? successfulExecutions,

    int? totalExecutions,

    DateTime? createdAt,

    DateTime? updatedAt,

  }) {

    return StrategyModel(

      id: id ?? this.id,

      name: name ?? this.name,

      description: description ?? this.description,

      fullDescription: fullDescription ?? this.fullDescription,

      category: category ?? this.category,

      status: status ?? this.status,

      icon: icon ?? this.icon,

      primaryColor: primaryColor ?? this.primaryColor,

      gradient: gradient ?? this.gradient,

      impactPercentage: impactPercentage ?? this.impactPercentage,

      impactValue: impactValue ?? this.impactValue,

      affectedProducts: affectedProducts ?? this.affectedProducts,

      lastExecution: lastExecution ?? this.lastExecution,

      nextExecution: nextExecution ?? this.nextExecution,

      frequency: frequency ?? this.frequency,

      reliability: reliability ?? this.reliability,

      savings: savings ?? this.savings,

      roi: roi ?? this.roi,

      successfulExecutions: successfulExecutions ?? this.successfulExecutions,

      totalExecutions: totalExecutions ?? this.totalExecutions,

      createdAt: createdAt ?? this.createdAt,

      updatedAt: updatedAt ?? this.updatedAt,

    );

  }



  // ============================================================================

  // JSON SERIALIZATION

  // ============================================================================



  factory StrategyModel.fromJson(Map<String, dynamic> json) {

    return StrategyModel(

      id: json['id'] as String? ?? '',

      name: json['nome'] as String? ?? json['name'] as String? ?? '',

      description: json['descricao'] as String? ?? json['description'] as String? ?? '',

      fullDescription: json['descricaoCompleta'] as String? ?? json['fullDescription'] as String? ?? '',

      category: StrategyCategory.fromString(json['categoria'] as String? ?? json['category'] as String? ?? ''),

      status: StrategyStatus.fromString(json['status'] as String? ?? ''),

      icon: _parseIcon(json['icone'] ?? json['icon']),

      primaryColor: parseColor(json['cor'] ?? json['color']) ?? const Color(0xFF2196F3),

      gradient: _parseGradient(json['gradiente'] ?? json['gradient']),

      impactPercentage: json['impacto'] as String? ?? json['impactPercentage'] as String? ?? '+0%',

      impactValue: json['impactoValor'] as String? ?? json['impactValue'] as String? ?? 'R\$ 0',

      affectedProducts: json['produtos'] as int? ?? json['affectedProducts'] as int? ?? 0,

      lastExecution: json['ultimaExecucao'] as String? ?? json['lastExecution'] as String?,

      nextExecution: json['proximaExecucao'] as String? ?? json['nextExecution'] as String?,

      frequency: json['frequencia'] as String? ?? json['frequency'] as String? ?? '',

      reliability: json['confiabilidade'] as int? ?? json['reliability'] as int? ?? 0,

      savings: json['economia'] as String? ?? json['savings'] as String? ?? 'R\$ 0',

      roi: json['roi'] as String? ?? '0%',

      successfulExecutions: json['execucoesSucesso'] as int? ?? json['successfulExecutions'] as int? ?? 0,

      totalExecutions: json['execucoesTotal'] as int? ?? json['totalExecutions'] as int? ?? 0,

      createdAt: _parseDateTime(json['createdAt']),

      updatedAt: _parseDateTime(json['updatedAt']),

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'name': name,

      'description': description,

      'fullDescription': fullDescription,

      'category': category.name,

      'status': status.value,

      'impactPercentage': impactPercentage,

      'impactValue': impactValue,

      'affectedProducts': affectedProducts,

      'lastExecution': lastExecution,

      'nextExecution': nextExecution,

      'frequency': frequency,

      'reliability': reliability,

      'savings': savings,

      'roi': roi,

      'successfulExecutions': successfulExecutions,

      'totalExecutions': totalExecutions,

      'createdAt': createdAt?.toIso8601String(),

      'updatedAt': updatedAt?.toIso8601String(),

    };

  }



  // ============================================================================

  // HELPER METHODS (static for reuse)

  // ============================================================================



  static IconData _parseIcon(dynamic icon) {

    if (icon is IconData) return icon;

    return Icons.auto_awesome_rounded;

  }



  /// M�todo p�blico para parsing de cor que pode ser usado pelos modelos relacionados

  static Color? parseColor(dynamic color) {

    if (color is Color) return color;

    if (color is int) return Color(color);

    return null;

  }

  

  /// Alias para compatibilidade interna (deprecated)

  @Deprecated('Use parseColor instead')

  // ignore: unused_element
  static Color? _parseColor(dynamic color) => parseColor(color);



  static List<Color> _parseGradient(dynamic gradient) {

    if (gradient is List) {

      return gradient.whereType<Color>().toList();

    }

    return [const Color(0xFF2196F3), const Color(0xFF1976D2)];

  }



  static DateTime? _parseDateTime(dynamic value) {

    if (value == null) return null;

    if (value is DateTime) return value;

    if (value is String) return DateTime.tryParse(value);

    return null;

  }



  @override

  bool operator ==(Object other) =>

      identical(this, other) ||

      other is StrategyModel && runtimeType == other.runtimeType && id == other.id;



  @override

  int get hashCode => id.hashCode;



  @override

  String toString() => 'StrategyModel(id: $id, name: $name, status: ${status.value})';

}



// ============================================================================

// STRATEGY EXECUTION MODEL

// ============================================================================



/// Representa uma execu��o de estrat�gia

class StrategyExecution {

  final String id;

  final String strategyId;

  final String strategyName;

  final DateTime executedAt;

  final bool isSuccess;

  final int productsAffected;

  final int priceChanges;

  final String impactValue;

  final String? error;

  final Duration duration;

  final ExecutionStatus status;

  final String? details;



  const StrategyExecution({

    required this.id,

    required this.strategyId,

    required this.strategyName,

    required this.executedAt,

    bool? isSuccess,

    this.productsAffected = 0,

    this.priceChanges = 0,

    this.impactValue = 'R\$ 0',

    this.error,

    this.duration = Duration.zero,

    this.status = ExecutionStatus.completed,

    this.details,

  }) : isSuccess = isSuccess ?? (status == ExecutionStatus.completed);



  /// Status icon

  IconData get statusIcon => isSuccess 

      ? Icons.check_circle_rounded 

      : Icons.error_rounded;



  /// Status color

  Color get statusColor => isSuccess 

      ? const Color(0xFF4CAF50) 

      : const Color(0xFFFF5252);



  /// Status label

  String get statusLabel => isSuccess ? 'Sucesso' : 'Erro';



  /// Formatted execution time

  String get executedAtFormatted {

    final now = DateTime.now();

    final diff = now.difference(executedAt);

    

    if (diff.inMinutes < 1) return 'Agora';

    if (diff.inMinutes < 60) return 'H� ${diff.inMinutes}min';

    if (diff.inHours < 24) return 'H� ${diff.inHours}h�';

    if (diff.inDays < 7) return 'H� ${diff.inDays}d';

    

    return '${executedAt.day.toString().padLeft(2, '0')}/${executedAt.month.toString().padLeft(2, '0')}/${executedAt.year}';

  }



  /// Formatted duration

  String get durationFormatted {

    if (duration.inSeconds < 60) return '${duration.inSeconds}s';

    if (duration.inMinutes < 60) return '${duration.inMinutes}min';

    return '${duration.inHours}h� ${duration.inMinutes % 60}min';

  }



  factory StrategyExecution.fromJson(Map<String, dynamic> json) {

    return StrategyExecution(

      id: json['id'] as String? ?? '',

      strategyId: json['strategyId'] as String? ?? '',

      strategyName: json['strategyName'] as String? ?? json['nome'] as String? ?? '',

      executedAt: DateTime.tryParse(json['executedAt'] as String? ?? '') ?? DateTime.now(),

      isSuccess: json['isSuccess'] as bool? ?? json['sucesso'] as bool? ?? false,

      productsAffected: json['productsAffected'] as int? ?? json['produtos'] as int? ?? 0,

      priceChanges: json['priceChanges'] as int? ?? 0,

      impactValue: json['impactValue'] as String? ?? json['impacto'] as String? ?? 'R\$ 0',

      error: json['error'] as String? ?? json['erro'] as String?,

      duration: Duration(milliseconds: json['durationMs'] as int? ?? json['durationSeconds'] as int? ?? 0),

      details: json['details'] as String?,

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'strategyId': strategyId,

      'strategyName': strategyName,

      'executedAt': executedAt.toIso8601String(),

      'isSuccess': isSuccess,

      'productsAffected': productsAffected,

      'priceChanges': priceChanges,

      'impactValue': impactValue,

      'error': error,

      'durationMs': duration.inMilliseconds,

      'details': details,

    };

  }

}



// ============================================================================

// STATS MODELS

// ============================================================================



/// Modelo para produtos top nas estrat�gias

class TopProductResult {

  final String id;

  final String name;

  final String sku;

  final String strategy;

  final String gain;

  final int quantity;

  final Color color;

  final double profitMargin;

  final double salesVariation;



  const TopProductResult({

    required this.id,

    required this.name,

    required this.sku,

    required this.strategy,

    required this.gain,

    required this.quantity,

    required this.color,

    this.profitMargin = 0.0,

    this.salesVariation = 0.0,

  });



  factory TopProductResult.fromJson(Map<String, dynamic> json) {

    return TopProductResult(

      id: json['id'] as String? ?? '',

      name: json['nome'] as String? ?? json['name'] as String? ?? '',

      sku: json['sku'] as String? ?? '',

      strategy: json['estrategia'] as String? ?? json['strategy'] as String? ?? '',

      gain: json['ganho'] as String? ?? json['gain'] as String? ?? 'R\$ 0',

      quantity: json['quantidade'] as int? ?? json['quantity'] as int? ?? 0,

      color: StrategyModel.parseColor(json['cor'] ?? json['color']) ?? const Color(0xFF2196F3),

      // ignore: argument_type_not_assignable
      profitMargin: (json['profitMargin'] ?? json['margemLucro'] ?? 0).toDouble(),

      // ignore: argument_type_not_assignable
      salesVariation: (json['salesVariation'] ?? json['variacaoVendas'] ?? 0).toDouble(),

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'name': name,

      'sku': sku,

      'strategy': strategy,

      'gain': gain,

      'quantity': quantity,

      'profitMargin': profitMargin,

      'salesVariation': salesVariation,

    };

  }



  String get variacaoVendasFormatted => '+${salesVariation.toStringAsFixed(0)}%';

  String get margemLucroFormatted => '${profitMargin.toStringAsFixed(1)}%';

}



/// Estat�sticas de per�odo de uma estrat�gia

class StrategyPeriodStats {

  final String period;

  final int totalSales;

  final double totalRevenue;

  final double averageTicket;

  final double roi;

  final double savings;

  final double conversionRate;

  final int productsAffected;

  final double salesVariation;

  final double revenueVariation;



  const StrategyPeriodStats({

    required this.period,

    this.totalSales = 0,

    this.totalRevenue = 0.0,

    this.averageTicket = 0.0,

    this.roi = 0.0,

    this.savings = 0.0,

    this.conversionRate = 0.0,

    this.productsAffected = 0,

    this.salesVariation = 0.0,

    this.revenueVariation = 0.0,

  });



  factory StrategyPeriodStats.fromJson(Map<String, dynamic> json) {

    return StrategyPeriodStats(

      period: json['period'] as String? ?? '',

      totalSales: json['totalSales'] as int? ?? 0,

      // ignore: argument_type_not_assignable
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),

      // ignore: argument_type_not_assignable
      averageTicket: (json['averageTicket'] ?? 0).toDouble(),

      // ignore: argument_type_not_assignable
      roi: (json['roi'] ?? 0).toDouble(),

      // ignore: argument_type_not_assignable
      savings: (json['savings'] ?? 0).toDouble(),

      // ignore: argument_type_not_assignable
      conversionRate: (json['conversionRate'] ?? 0).toDouble(),

      productsAffected: json['productsAffected'] as int? ?? 0,

      // ignore: argument_type_not_assignable
      salesVariation: (json['salesVariation'] ?? 0).toDouble(),

      // ignore: argument_type_not_assignable
      revenueVariation: (json['revenueVariation'] ?? 0).toDouble(),

    );

  }



  String get totalFaturamentoFormatted => 'R\$ ${(totalRevenue / 1000).toStringAsFixed(1)}k';

  String get ticketMedioFormatted => 'R\$ ${averageTicket.toStringAsFixed(2)}';

  String get roiFormatted => '${roi.toStringAsFixed(0)}%';

  String get economiaFormatted => 'R\$ ${(savings / 1000).toStringAsFixed(1)}k';

  String get conversaoFormatted => '${conversionRate.toStringAsFixed(1)}%';

  String get variacaoVendasFormatted => '${salesVariation >= 0 ? '+' : ''}${salesVariation.toStringAsFixed(0)}%';

  String get variacaoFaturamentoFormatted => '${revenueVariation >= 0 ? '+' : ''}${revenueVariation.toStringAsFixed(0)}%';

  

  String get variacaoTicketFormatted {

    final variacao = revenueVariation - salesVariation;

    return '${variacao >= 0 ? '+' : ''}${variacao.toStringAsFixed(0)}%';

  }

  

  String get variacaoEconomiaFormatted {

    final variacao = roi > 0 ? roi / 10 : 0;

    return '${variacao >= 0 ? '+' : ''}${variacao.toStringAsFixed(0)}%';

  }

  

  String get variacaoConversaoFormatted {

    final variacao = conversionRate > 0 ? conversionRate / 10 : 0;

    return '${variacao >= 0 ? '+' : ''}${variacao.toStringAsFixed(0)}%';

  }

}



/// Dados de vendas diárias

class DailySalesData {

  final DateTime date;

  final int sales;

  final double revenue;



  const DailySalesData({

    required this.date,

    this.sales = 0,

    this.revenue = 0.0,

  });



  factory DailySalesData.fromJson(Map<String, dynamic> json) {

    return DailySalesData(

      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),

      sales: json['sales'] as int? ?? 0,

      // ignore: argument_type_not_assignable
      revenue: (json['revenue'] ?? 0).toDouble(),

    );

  }



  String get dayAbbreviation {

    const days = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

    return days[date.weekday % 7];

  }

}



// ============================================================================

// EXTENSIONS PARA CORES DINÂMICAS

// ============================================================================



/// Extension para obter cor dinâmica de StrategyCategory

extension StrategyCategoryDynamicColor on StrategyCategory {

  /// Obtém a cor do tema dinâmico (requer BuildContext)

  Color dynamicColor(BuildContext context) {

    final colors = ThemeColors.of(context);

    switch (this) {

      case StrategyCategory.calendar:

        return colors.yellowGold;

      case StrategyCategory.performance:

        return colors.success;

      case StrategyCategory.environmental:

        return colors.yellowGold;

      case StrategyCategory.engagement:

        return colors.urgent;

      case StrategyCategory.crossSelling:

        return colors.brownMain;

      case StrategyCategory.visual:

        return colors.blueCyan;

    }

  }

}



/// Extension para obter cor dinâmica de StrategyStatus

extension StrategyStatusDynamicColor on StrategyStatus {

  /// Obtém a cor do tema dinâmico (requer BuildContext)

  Color dynamicColor(BuildContext context) {

    final colors = ThemeColors.of(context);

    switch (this) {

      case StrategyStatus.active:

        return colors.success;

      case StrategyStatus.paused:

        return colors.warning;

      case StrategyStatus.inactive:

        return colors.textLight;

      case StrategyStatus.draft:

        return colors.textSecondary;

      case StrategyStatus.scheduled:

        return colors.blueMain;

      case StrategyStatus.executing:

        return colors.orangeMain;

    }

  }

}



/// Extension para obter cor dinâmica de ExecutionStatus

extension ExecutionStatusDynamicColor on ExecutionStatus {

  /// Obtém a cor do tema dinâmico (requer BuildContext)

  Color dynamicColor(BuildContext context) {

    final colors = ThemeColors.of(context);

    switch (this) {

      case ExecutionStatus.running:

        return colors.blueMain;

      case ExecutionStatus.completed:

        return colors.success;

      case ExecutionStatus.failed:

        return colors.error;

      case ExecutionStatus.partial:

        return colors.warning;

    }

  }

}

