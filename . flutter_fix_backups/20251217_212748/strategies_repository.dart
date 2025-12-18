import 'package:flutter/material.dart';

import 'package:tagbean/core/network/api_client.dart';

import 'package:tagbean/core/network/api_response.dart';

import 'package:tagbean/design_system/theme/theme_colors.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

import 'package:tagbean/features/strategies/data/models/strategy_models.dart';



// ============================================================================

// STRATEGIES REPOSITORY - INTEGRADO COM BACKEND

// ============================================================================



/// Repository para gerenciamento de estrat�gias de precifica��o.

/// Totalmente integrado com o backend TagBean.

/// 

/// Endpoints utilizados:

/// - GET /api/strategies/store/{storeId}

/// - GET /api/strategies/{id}

/// - POST /api/strategies

/// - PUT /api/strategies/{id}

/// - PUT /api/strategies/{id}/activate

/// - PUT /api/strategies/{id}/deactivate

/// - POST /api/strategies/{id}/execute

/// - DELETE /api/strategies/{id}

/// - GET /api/strategies/{id}/executions

class StrategiesRepository {

  final ApiService _apiService;



  StrategiesRepository({ApiService? apiService})

      : _apiService = apiService ?? ApiService();



  // ============================================================================

  // STRATEGIES CRUD

  // ============================================================================



  /// Busca todas as estrat�gias de uma loja

  /// GET /api/strategies/store/{storeId}

  Future<ApiResponse<List<StrategyModel>>> getStrategies({

    required String storeId,

    StrategyStatus? status,

    StrategyCategory? category,

  }) async {

    final queryParams = <String, dynamic>{};

    if (status != null) queryParams['status'] = status.name;

    if (category != null) queryParams['category'] = category.name;



    return await _apiService.get<List<StrategyModel>>(

      '/strategies/store/$storeId',

      queryParams: queryParams.isNotEmpty ? queryParams : null,

      parser: (data) {

        if (data is List) {

          return data.map((item) => _parseStrategy(item as Map<String, dynamic>)).toList();

        }

        return [];

      },

    );

  }



  /// Busca estratgia por ID

  /// GET /api/strategies/{id}

  Future<ApiResponse<StrategyModel>> getStrategyById(String id) async {

    return await _apiService.get<StrategyModel>(

      '/strategies/$id',

      parser: (data) => _parseStrategy(data as Map<String, dynamic>),

    );

  }



  /// Cria uma nova estratgia

  /// POST /api/strategies

  Future<ApiResponse<StrategyModel>> createStrategy({

    required String storeId,

    required String name,

    required String description,

    required String category,

    String? fullDescription,

    Map<String, dynamic>? configuration,

  }) async {

    final body = {

      'storeId': storeId,

      'name': name,

      'description': description,

      'category': category,

      if (fullDescription != null) 'fullDescription': fullDescription,

      if (configuration != null) 'configuration': configuration,

    };



    return await _apiService.post<StrategyModel>(

      '/strategies',

      body: body,

      parser: (data) => _parseStrategy(data as Map<String, dynamic>),

    );

  }



  /// Atualiza uma estratgia

  /// PUT /api/strategies/{id}

  Future<ApiResponse<StrategyModel>> updateStrategy({

    required String id,

    String? name,

    String? description,

    String? fullDescription,

    Map<String, dynamic>? configuration,

  }) async {

    final body = <String, dynamic>{};

    if (name != null) body['name'] = name;

    if (description != null) body['description'] = description;

    if (fullDescription != null) body['fullDescription'] = fullDescription;

    if (configuration != null) body['configuration'] = configuration;



    return await _apiService.put<StrategyModel>(

      '/strategies/$id',

      body: body,

      parser: (data) => _parseStrategy(data as Map<String, dynamic>),

    );

  }



  /// Exclui uma estratgia

  /// DELETE /api/strategies/{id}

  Future<ApiResponse<void>> deleteStrategy(String id) async {

    return await _apiService.delete('/strategies/$id');

  }



  /// Ativa uma estratgia

  /// PUT /api/strategies/{id}/activate

  Future<ApiResponse<StrategyModel>> activateStrategy(String id) async {

    return await _apiService.put<StrategyModel>(

      '/strategies/$id/activate',

      parser: (data) => _parseStrategy(data as Map<String, dynamic>),

    );

  }



  /// Desativa uma estratgia

  /// PUT /api/strategies/{id}/deactivate

  Future<ApiResponse<StrategyModel>> deactivateStrategy(String id) async {

    return await _apiService.put<StrategyModel>(

      '/strategies/$id/deactivate',

      parser: (data) => _parseStrategy(data as Map<String, dynamic>),

    );

  }



  /// Executa uma estratgia manualmente

  /// POST /api/strategies/{id}/execute

  Future<ApiResponse<StrategyExecution>> executeStrategy(String id) async {

    return await _apiService.post<StrategyExecution>(

      '/strategies/$id/execute',

      parser: (data) => _parseExecution(data as Map<String, dynamic>),

    );

  }



  // ============================================================================

  // EXECUTIONS

  // ============================================================================



  /// Busca execu��es de uma estratgia

  /// GET /api/strategies/{strategyId}/executions

  Future<ApiResponse<List<StrategyExecution>>> getExecutionsByStrategy(String strategyId) async {

    return await _apiService.get<List<StrategyExecution>>(

      '/strategies/$strategyId/executions',

      parser: (data) {

        if (data is List) {

          return data.map((item) => _parseExecution(item as Map<String, dynamic>)).toList();

        }

        return [];

      },

    );

  }



  /// Busca execu��es recentes de todas as estrat�gias de uma loja

  /// GET /api/strategies/store/{storeId}/executions

  Future<ApiResponse<List<StrategyExecution>>> getRecentExecutions({

    required String storeId,

    int limit = 10,

  }) async {

    return await _apiService.get<List<StrategyExecution>>(

      '/strategies/store/$storeId/executions',

      queryParams: {'limit': limit},

      parser: (data) {

        if (data is List) {

          return data.map((item) => _parseExecution(item as Map<String, dynamic>)).toList();

        }

        return [];

      },

    );

  }



  // ============================================================================

  // STATISTICS & RESULTS

  // ============================================================================



  /// Busca estat�sticas de uma estratgia

  /// GET /api/strategies/{id}/stats

  Future<ApiResponse<StrategyStats>> getStrategyStats(String id) async {

    return await _apiService.get<StrategyStats>(

      '/strategies/$id/stats',

      parser: (data) => _parseStats(data as Map<String, dynamic>),

    );

  }



  /// Busca top produtos afetados por estrat�gias

  /// GET /api/strategies/store/{storeId}/top-products

  Future<ApiResponse<List<TopProductResult>>> getTopProducts({

    required String storeId,

    int limit = 5,

  }) async {

    return await _apiService.get<List<TopProductResult>>(

      '/strategies/store/$storeId/top-products',

      queryParams: {'limit': limit},

      parser: (data) {

        if (data is List) {

          return data.map((item) => _parseTopProduct(item as Map<String, dynamic>)).toList();

        }

        return [];

      },

    );

  }



  /// Busca top produtos de uma estratgia especfica

  /// GET /api/strategies/{id}/top-products

  Future<ApiResponse<List<TopProductResult>>> getTopProductsByStrategy({

    required String strategyId,

    int limit = 5,

  }) async {

    return await _apiService.get<List<TopProductResult>>(

      '/strategies/$strategyId/top-products',

      queryParams: {'limit': limit},

      parser: (data) {

        if (data is List) {

          return data.map((item) => _parseTopProduct(item as Map<String, dynamic>)).toList();

        }

        return [];

      },

    );

  }



  /// Busca estat�sticas de perodo de uma estratgia

  /// GET /api/strategies/{id}/stats?period={period}

  Future<ApiResponse<StrategyPeriodStats>> getStrategyPeriodStats({

    required String strategyId,

    required String period,

  }) async {

    return await _apiService.get<StrategyPeriodStats>(

      '/strategies/$strategyId/stats',

      queryParams: {'period': period},

      parser: (data) => _parsePeriodStats(data as Map<String, dynamic>),

    );

  }



  /// Busca hist�rico de execu��es de uma estratgia

  /// GET /api/strategies/{id}/history

  Future<ApiResponse<List<StrategyExecution>>> getExecutionHistory(String strategyId) async {

    return await _apiService.get<List<StrategyExecution>>(

      '/strategies/$strategyId/history',

      parser: (data) {

        if (data is List) {

          return data.map((item) => _parseExecution(item as Map<String, dynamic>)).toList();

        }

        return [];

      },

    );

  }



  /// Busca dados de vendas dirias de uma estratgia

  /// GET /api/strategies/{id}/daily-sales

  Future<ApiResponse<List<DailySalesData>>> getDailySalesData({

    required String strategyId,

    int days = 7,

  }) async {

    return await _apiService.get<List<DailySalesData>>(

      '/strategies/$strategyId/daily-sales',

      queryParams: {'days': days},

      parser: (data) {

        if (data is List) {

          return data.map((item) => _parseDailySales(item as Map<String, dynamic>)).toList();

        }

        return [];

      },

    );

  }



  // ============================================================================

  // HELPERS - PARSERS

  // ============================================================================



  StrategyModel _parseStrategy(Map<String, dynamic> data) {

    final category = _parseCategory(data['category']);

    final themeData = _getCategoryTheme(category);

    

    return StrategyModel(

      id: data['id']?.toString() ?? '',

      name: data['name'] ?? '',

      description: data['description'] ?? '',

      fullDescription: data['fullDescription'] ?? data['description'] ?? '',

      category: category,

      status: _parseStatus(data['status']),

      icon: themeData['icon'] as IconData,

      primaryColor: themeData['color'] as Color,

      gradient: (((themeData['gradient'] ?? []) as List<dynamic>?) ?? []).cast<Color>()

      impactPercentage: data['impactPercentage'] ?? '+0%',

      impactValue: data['impactValue'] ?? 'R\$ 0',

      affectedProducts: data['affectedProducts'] ?? 0,

      lastExecution: data['lastExecution']?.toString(),

      nextExecution: data['nextExecution']?.toString(),

      frequency: data['frequency'] ?? 'Manual',

      reliability: ((data['reliability'] ?? 0) as num?)?.toDouble() ?? 0.0,

      savings: data['savings'] ?? 'R\$ 0',

      roi: data['roi'] ?? '0%',

      successfulExecutions: data['successfulExecutions'] ?? 0,

      totalExecutions: data['totalExecutions'] ?? 0,

      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),

      updatedAt: DateTime.tryParse(data['updatedAt'] ?? '') ?? DateTime.now(),

    );

  }



  StrategyExecution _parseExecution(Map<String, dynamic> data) {

    return StrategyExecution(

      id: data['id']?.toString() ?? '',

      strategyId: data['strategyId']?.toString() ?? '',

      strategyName: data['strategyName'] ?? '',

      executedAt: DateTime.tryParse(data['executedAt'] ?? '') ?? DateTime.now(),

      isSuccess: data['status'] == 'Completed' || data['isSuccess'] == true,

      productsAffected: data['productsAffected'] ?? 0,

      priceChanges: data['priceChanges'] ?? 0,

      impactValue: data['impactValue'] ?? 'R\$ 0',

      status: _parseExecutionStatus(data['status']),

      duration: Duration(milliseconds: data['durationMs'] ?? 0),

      details: data['details']?.toString(),

      error: data['errorMessage']?.toString(),

    );

  }



  StrategyStats _parseStats(Map<String, dynamic> data) {

    return StrategyStats(

      totalExecutions: data['totalExecutions'] ?? 0,

      successfulExecutions: data['successfulExecutions'] ?? 0,

      failedExecutions: data['failedExecutions'] ?? 0,

      totalProductsAffected: data['totalProductsAffected'] ?? 0,

      totalPriceChanges: data['totalPriceChanges'] ?? 0,

      totalImpactValue: ((data['totalImpactValue'] ?? 0) as num?)?.toDouble() ?? 0.0,

      averageExecutionTime: Duration(milliseconds: data['averageExecutionTimeMs'] ?? 0),

      lastExecutedAt: DateTime.tryParse(data['lastExecutedAt'] ?? ''),

    );

  }



  TopProductResult _parseTopProduct(Map<String, dynamic> data) {

    final strategyCategory = _parseCategory(data['strategyCategory']);

    final themeData = _getCategoryTheme(strategyCategory);

    

    return TopProductResult(

      id: data['id']?.toString() ?? '',

      name: data['name'] ?? '',

      sku: data['sku'] ?? data['código'] ?? '',

      strategy: data['strategyName'] ?? data['category'] ?? '',

      gain: data['gain'] ?? 'R\$ ${(data['revenue'] ?? 0).toStringAsFixed(2)}',

      quantity: data['quantity'] ?? data['unitsSold'] ?? 0,

      color: themeData['color'] as Color,

      profitMargin: ((data['profitMargin'] ?? 0) as num?)?.toDouble() ?? 0.0,

      salesVariation: ((data['salesVariation'] ?? 0) as num?)?.toDouble() ?? 0.0,

    );

  }



  StrategyPeriodStats _parsePeriodStats(Map<String, dynamic> data) {

    return StrategyPeriodStats(

      period: data['period'] ?? '',

      totalSales: data['totalSales'] ?? 0,

      totalRevenue: ((data['totalRevenue'] ?? 0) as num?)?.toDouble() ?? 0.0,

      averageTicket: ((data['averageTicket'] ?? 0) as num?)?.toDouble() ?? 0.0,

      roi: ((data['roi'] ?? 0) as num?)?.toDouble() ?? 0.0,

      savings: ((data['savings'] ?? 0) as num?)?.toDouble() ?? 0.0,

      conversionRate: ((data['conversionRate'] ?? 0) as num?)?.toDouble() ?? 0.0,

      productsAffected: data['productsAffected'] ?? 0,

      salesVariation: ((data['salesVariation'] ?? 0) as num?)?.toDouble() ?? 0.0,

      revenueVariation: ((data['revenueVariation'] ?? 0) as num?)?.toDouble() ?? 0.0,

    );

  }



  DailySalesData _parseDailySales(Map<String, dynamic> data) {

    return DailySalesData(

      date: DateTime.tryParse(data['date'] ?? '') ?? DateTime.now(),

      sales: data['sales'] ?? 0,

      revenue: ((data['revenue'] ?? 0) as num?)?.toDouble() ?? 0.0,

    );

  }



  StrategyCategory _parseCategory(dynamic category) {

    if (category == null) return StrategyCategory.calendar;

    final cat = category.toString().toLowerCase();

    if (cat.contains('calendar') || cat.contains('data')) return StrategyCategory.calendar;

    if (cat.contains('environment') || cat.contains('ambiente')) return StrategyCategory.environmental;

    if (cat.contains('visual')) return StrategyCategory.visual;

    if (cat.contains('cross') || cat.contains('cruzad')) return StrategyCategory.crossSelling;

    if (cat.contains('performance') || cat.contains('desempenho')) return StrategyCategory.performance;

    if (cat.contains('engagement') || cat.contains('engaj')) return StrategyCategory.engagement;

    return StrategyCategory.calendar;

  }



  StrategyStatus _parseStatus(dynamic status) {

    if (status == null) return StrategyStatus.draft;

    final st = status.toString().toLowerCase();

    if (st == 'active' || st == 'ativo') return StrategyStatus.active;

    if (st == 'paused' || st == 'pausado') return StrategyStatus.paused;

    if (st == 'scheduled' || st == 'agendado') return StrategyStatus.scheduled;

    if (st == 'executing' || st == 'executando') return StrategyStatus.executing;

    if (st == 'inactive' || st == 'inativo') return StrategyStatus.inactive;

    return StrategyStatus.draft;

  }



  ExecutionStatus _parseExecutionStatus(dynamic status) {

    if (status == null) return ExecutionStatus.completed;

    final st = status.toString().toLowerCase();

    if (st == 'running' || st == 'executando') return ExecutionStatus.running;

    if (st == 'completed' || st == 'concluido') return ExecutionStatus.completed;

    if (st == 'failed' || st == 'falhou') return ExecutionStatus.failed;

    if (st == 'partial' || st == 'parcial') return ExecutionStatus.partial;

    return ExecutionStatus.completed;

  }



  Map<String, dynamic> _getCategoryTheme(StrategyCategory category) {

    switch (category) {

      case StrategyCategory.calendar:

        return {

          'icon': Icons.celebration_rounded,

          'color': AppThemeColors.yellowGold,

          'gradient': [AppThemeColors.yellowGold, AppThemeColors.warning],

        };

      case StrategyCategory.environmental:

        return {

          'icon': Icons.thermostat_rounded,

          'color': AppThemeColors.yellowGold,

          'gradient': [AppThemeColors.yellowGold, AppThemeColors.warning],

        };

      case StrategyCategory.visual:

        return {

          'icon': Icons.visibility_rounded,

          'color': AppThemeColors.blueCyan,

          'gradient': [AppThemeColors.blueCyan, AppThemeColors.primary],

        };

      case StrategyCategory.crossSelling:

        return {

          'icon': Icons.compare_arrows_rounded,

          'color': AppThemeColors.brownMain,

          'gradient': [AppThemeColors.brownMain, AppThemeColors.brownDark],

        };

      case StrategyCategory.performance:

        return {

          'icon': Icons.trending_up_rounded,

          'color': AppThemeColors.success,

          'gradient': [AppThemeColors.success, AppThemeColors.greenDark],

        };

      case StrategyCategory.engagement:

        return {

          'icon': Icons.map_rounded,

          'color': AppThemeColors.urgent,

          'gradient': [AppThemeColors.urgent, AppThemeColors.urgentDark],

        };

    }

  }



  /// Versão dinâmica com cores do tema (use quando tiver BuildContext)

  static Map<String, dynamic> getDynamicCategoryTheme(BuildContext context, StrategyCategory category) {

    final colors = ThemeColors.of(context);

    switch (category) {

      case StrategyCategory.calendar:

        return {

          'icon': Icons.celebration_rounded,

          'color': colors.yellowGold,

          'gradient': [colors.yellowGold, colors.warning],

        };

      case StrategyCategory.environmental:

        return {

          'icon': Icons.thermostat_rounded,

          'color': colors.yellowGold,

          'gradient': [colors.yellowGold, colors.warning],

        };

      case StrategyCategory.visual:

        return {

          'icon': Icons.visibility_rounded,

          'color': colors.blueCyan,

          'gradient': [colors.blueCyan, colors.primary],

        };

      case StrategyCategory.crossSelling:

        return {

          'icon': Icons.compare_arrows_rounded,

          'color': colors.brownMain,

          'gradient': [colors.brownMain, colors.brownDark],

        };

      case StrategyCategory.performance:

        return {

          'icon': Icons.trending_up_rounded,

          'color': colors.success,

          'gradient': [colors.success, colors.greenDark],

        };

      case StrategyCategory.engagement:

        return {

          'icon': Icons.map_rounded,

          'color': colors.urgent,

          'gradient': [colors.urgent, colors.urgentDark],

        };

    }

  }



  /// Libera recursos

  void dispose() {

    _apiService.dispose();

  }



  // ============================================================================

  // STRATEGY-SPECIFIC CONFIGURATIONS

  // ============================================================================



  /// Busca configura��o especfica de uma estratgia

  /// GET /api/strategies/{id}/configuration

  Future<ApiResponse<Map<String, dynamic>>> getStrategyConfiguration(String id) async {

    return await _apiService.get<Map<String, dynamic>>(

      '/strategies/$id/configuration',

      parser: (data) => data is Map<String, dynamic> ? data : {},

    );

  }



  /// Atualiza configura��o especfica de uma estratgia

  /// PUT /api/strategies/{id}/configuration

  Future<ApiResponse<Map<String, dynamic>>> updateStrategyConfiguration(

    String id,

    Map<String, dynamic> configuration,

  ) async {

    return await _apiService.put<Map<String, dynamic>>(

      '/strategies/$id/configuration',

      body: configuration,

      parser: (data) => data is Map<String, dynamic> ? data : {},

    );

  }



  /// Testa conexo/configura��o de uma estratgia

  /// POST /api/strategies/{id}/test

  Future<ApiResponse<Map<String, dynamic>>> testStrategyConfiguration(String id) async {

    return await _apiService.post<Map<String, dynamic>>(

      '/strategies/$id/test',

      parser: (data) => data is Map<String, dynamic> ? data : {},

    );

  }



  /// Simula execu��o de uma estratgia sem aplicar mudanas

  /// POST /api/strategies/{id}/simulate

  Future<ApiResponse<Map<String, dynamic>>> simulateStrategy(

    String id, {

    Map<String, dynamic>? params,

  }) async {

    return await _apiService.post<Map<String, dynamic>>(

      '/strategies/$id/simulate',

      body: params,

      parser: (data) => data is Map<String, dynamic> ? data : {},

    );

  }



  // ============================================================================

  // CATEGORY-SPECIFIC ENDPOINTS

  // ============================================================================



  /// Busca dados especficos de calendrio

  /// GET /api/strategies/calendar/events

  Future<ApiResponse<List<Map<String, dynamic>>>> getCalendarEvents({

    required String storeId,

    String? type, // 'holiday', 'sports', 'extended', 'salary'

    DateTime? startDate,

    DateTime? endDate,

  }) async {

    final params = <String, dynamic>{'storeId': storeId};

    if (type != null) params['type'] = type;

    if (startDate != null) params['startDate'] = startDate.toIso8601String();

    if (endDate != null) params['endDate'] = endDate.toIso8601String();



    return await _apiService.get<List<Map<String, dynamic>>>(

      '/strategies/calendar/events',

      queryParams: params,

      parser: (data) {

        if (data is List) {

          return data.map((e) => e as Map<String, dynamic>).toList();

        }

        return [];

      },

    );

  }



  /// Atualiza evento de calendrio

  /// PUT /api/strategies/calendar/events/{eventId}

  Future<ApiResponse<Map<String, dynamic>>> updateCalendarEvent(

    String eventId,

    Map<String, dynamic> eventData,

  ) async {

    return await _apiService.put<Map<String, dynamic>>(

      '/strategies/calendar/events/$eventId',

      body: eventData,

      parser: (data) => data is Map<String, dynamic> ? data : {},

    );

  }



  /// Busca dados de calendrio (datas comemorativas, eventos esportivos, etc)

  /// GET /api/strategies/calendar/data

  Future<ApiResponse<Map<String, dynamic>>> getCalendarData(

    String storeId, {

    String? type, // 'datas-comemorativas', 'eventos-esportivos', 'times', 'feriados-prolongados', 'ciclo-salario'

  }) async {

    final params = <String, dynamic>{'storeId': storeId};

    if (type != null) params['type'] = type;



    return await _apiService.get<Map<String, dynamic>>(

      '/strategies/calendar/data',

      queryParams: params,

      parser: (data) => data is Map<String, dynamic> ? data : {},

    );

  }



  /// Busca dados de temperatura

  /// GET /api/strategies/environmental/temperature

  Future<ApiResponse<Map<String, dynamic>>> getTemperatureData(String storeId) async {

    return await _apiService.get<Map<String, dynamic>>(

      '/strategies/environmental/temperature',

      queryParams: {'storeId': storeId},

      parser: (data) => data is Map<String, dynamic> ? data : {},

    );

  }



  /// Busca dados ambientais (temperatura, horrio de pico, etc)

  /// GET /api/strategies/environmental/data

  Future<ApiResponse<Map<String, dynamic>>> getEnvironmentalData(

    String storeId, {

    String? type, // 'temperatura', 'horario-pico'

  }) async {

    final params = <String, dynamic>{'storeId': storeId};

    if (type != null) params['type'] = type;



    return await _apiService.get<Map<String, dynamic>>(

      '/strategies/environmental/data',

      queryParams: params,

      parser: (data) => data is Map<String, dynamic> ? data : {},

    );

  }



  /// Busca dados de horrio de pico

  /// GET /api/strategies/environmental/peak-hours

  Future<ApiResponse<List<Map<String, dynamic>>>> getPeakHoursData(String storeId) async {

    return await _apiService.get<List<Map<String, dynamic>>>(

      '/strategies/environmental/peak-hours',

      queryParams: {'storeId': storeId},

      parser: (data) {

        if (data is List) {

          return data.map((e) => e as Map<String, dynamic>).toList();

        }

        return [];

      },

    );

  }



  /// Busca dados de cross-selling

  /// GET /api/strategies/cross-selling/data

  Future<ApiResponse<Map<String, dynamic>>> getCrossSellingData(

    String storeId, {

    String? type, // 'neighbors', 'trails', 'combos'

  }) async {

    final params = <String, dynamic>{'storeId': storeId};

    if (type != null) params['type'] = type;



    return await _apiService.get<Map<String, dynamic>>(

      '/strategies/cross-selling/data',

      queryParams: params,

      parser: (data) => data is Map<String, dynamic> ? data : {},

    );

  }



  /// Busca dados visuais (mapa de calor, ranking, promo��es)

  /// GET /api/strategies/visual/data

  Future<ApiResponse<Map<String, dynamic>>> getVisualData(

    String storeId, {

    String? type, // 'heatmap', 'ranking', 'promotions', 'routes'

  }) async {

    final params = <String, dynamic>{'storeId': storeId};

    if (type != null) params['type'] = type;



    return await _apiService.get<Map<String, dynamic>>(

      '/strategies/visual/data',

      queryParams: params,

      parser: (data) => data is Map<String, dynamic> ? data : {},

    );

  }



  /// Busca dados de performance (liquida��o, markdown, previso IA)

  /// GET /api/strategies/performance/data

  Future<ApiResponse<Map<String, dynamic>>> getPerformanceData(

    String storeId, {

    String? type, // 'clearance', 'markdown', 'ai-prediction', 'audit'

  }) async {

    final params = <String, dynamic>{'storeId': storeId};

    if (type != null) params['type'] = type;



    return await _apiService.get<Map<String, dynamic>>(

      '/strategies/performance/data',

      queryParams: params,

      parser: (data) => data is Map<String, dynamic> ? data : {},

    );

  }

}



/// Estat�sticas de uma estratgia

class StrategyStats {

  final int totalExecutions;

  final int successfulExecutions;

  final int failedExecutions;

  final int totalProductsAffected;

  final int totalPriceChanges;

  final double totalImpactValue;

  final Duration averageExecutionTime;

  final DateTime? lastExecutedAt;



  const StrategyStats({

    this.totalExecutions = 0,

    this.successfulExecutions = 0,

    this.failedExecutions = 0,

    this.totalProductsAffected = 0,

    this.totalPriceChanges = 0,

    this.totalImpactValue = 0.0,

    this.averageExecutionTime = Duration.zero,

    this.lastExecutedAt,

  });



  double get successRate => totalExecutions > 0 

      ? (successfulExecutions / totalExecutions) * 100 

      : 0.0;

}









