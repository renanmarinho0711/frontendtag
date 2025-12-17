import 'package:tagbean/core/network/api_client.dart';
import 'package:tagbean/core/network/api_response.dart';

/// Repository para gerenciamento de precificação
/// Comunicação com endpoints do PricingController no backend
class PricingRepository {
  final ApiService _apiService;

  PricingRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // =========================================================================
  // DASHBOARD
  // =========================================================================

  /// Obtém dashboard completo de precificação
  /// GET /api/pricing/dashboard
  Future<ApiResponse<Map<String, dynamic>>> getDashboard() async {
    return await _apiService.get<Map<String, dynamic>>(
      '/pricing/dashboard',
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  // =========================================================================
  // SIMULAÇÀO E AJUSTES
  // =========================================================================

  /// Simula ajuste de preços sem aplicar
  /// POST /api/pricing/simulate
  Future<ApiResponse<Map<String, dynamic>>> simulatePriceAdjustment({
    required String adjustmentType, // "percentual" ou "valor"
    required String operationType,  // "aumentar" ou "diminuir"
    required double value,
    required String applyScope,     // "todos", "categoria", "marca", "selecionados"
    String? categoryId,
    String? brand,
    List<String>? productIds,
    double? minMargin,
  }) async {
    final body = {
      'adjustmentType': adjustmentType,
      'operationType': operationType,
      'value': value,
      'applyScope': applyScope,
      if (categoryId != null) 'categoryId': categoryId,
      if (brand != null) 'brand': brand,
      if (productIds != null) 'productIds': productIds,
      if (minMargin != null) 'minMargin': minMargin,
    };

    return await _apiService.post<Map<String, dynamic>>(
      '/pricing/simulate',
      body: body,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Aplica ajuste de preços em lote
  /// POST /api/pricing/apply
  Future<ApiResponse<Map<String, dynamic>>> applyPriceAdjustment({
    required String adjustmentType,
    required String operationType,
    required double value,
    required List<String> productIds,
    String? reason,
  }) async {
    final body = {
      'adjustmentType': adjustmentType,
      'operationType': operationType,
      'value': value,
      'productIds': productIds,
      if (reason != null) 'reason': reason,
    };

    return await _apiService.post<Map<String, dynamic>>(
      '/pricing/apply',
      body: body,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Atualiza preço de um produto individual
  /// PUT /api/pricing/products/:productId/price
  Future<ApiResponse<Map<String, dynamic>>> updateProductPrice({
    required String productId,
    required double newPrice,
    String? reason,
  }) async {
    final body = {
      'newPrice': newPrice,
      if (reason != null) 'reason': reason,
    };

    return await _apiService.put<Map<String, dynamic>>(
      '/pricing/products/$productId/price',
      body: body,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  // =========================================================================
  // ANÁLISE DE MARGENS
  // =========================================================================

  /// Obtém análise completa de margens
  /// GET /api/pricing/margins/analysis
  Future<ApiResponse<Map<String, dynamic>>> getMarginAnalysis({
    double targetMargin = 30,
  }) async {
    return await _apiService.get<Map<String, dynamic>>(
      '/pricing/margins/analysis',
      queryParams: {'targetMargin': targetMargin},
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Obtém produtos com margens críticas
  /// GET /api/pricing/margins/critical
  Future<ApiResponse<List<Map<String, dynamic>>>> getCriticalMargins({
    double minMargin = 10,
  }) async {
    return await _apiService.get<List<Map<String, dynamic>>>(
      '/pricing/margins/critical',
      queryParams: {'minMargin': minMargin},
      parser: (data) {
        if (data is List) {
          return data.map((item) => item as Map<String, dynamic>).toList();
        }
        return [];
      },
    );
  }

  /// Obtém margens por categoria
  /// GET /api/pricing/margins/by-category
  Future<ApiResponse<List<Map<String, dynamic>>>> getMarginsByCategory() async {
    return await _apiService.get<List<Map<String, dynamic>>>(
      '/pricing/margins/by-category',
      parser: (data) {
        if (data is List) {
          return data.map((item) => item as Map<String, dynamic>).toList();
        }
        return [];
      },
    );
  }

  // =========================================================================
  // HISTÓRICO
  // =========================================================================

  /// Obtém histórico geral de alterações de preço
  /// GET /api/pricing/history
  Future<ApiResponse<List<Map<String, dynamic>>>> getPriceHistory({
    int limit = 50,
  }) async {
    return await _apiService.get<List<Map<String, dynamic>>>(
      '/pricing/history',
      queryParams: {'limit': limit},
      parser: (data) {
        if (data is List) {
          return data.map((item) => item as Map<String, dynamic>).toList();
        }
        return [];
      },
    );
  }

  /// Obtém histórico de preços de um produto específico
  /// GET /api/pricing/products/:productId/history
  Future<ApiResponse<List<Map<String, dynamic>>>> getProductPriceHistory({
    required String productId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _apiService.get<List<Map<String, dynamic>>>(
      '/pricing/products/$productId/history',
      queryParams: {
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
      },
      parser: (data) {
        if (data is List) {
          return data.map((item) => item as Map<String, dynamic>).toList();
        }
        return [];
      },
    );
  }

  // =========================================================================
  // LISTAGEM E BUSCA
  // =========================================================================

  /// Lista produtos com preços (paginado e filtrado)
  /// GET /api/pricing/products
  Future<ApiResponse<Map<String, dynamic>>> getProductPrices({
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minMargin,
    double? maxMargin,
    String? marginStatus, // "critical", "warning", "healthy", "all"
    String? searchTerm,
    int page = 1,
    int pageSize = 50,
    String sortBy = 'name',
    bool sortDescending = false,
  }) async {
    return await _apiService.get<Map<String, dynamic>>(
      '/pricing/products',
      queryParams: {
        if (categoryId != null) 'categoryId': categoryId,
        if (minPrice != null) 'minPrice': minPrice,
        if (maxPrice != null) 'maxPrice': maxPrice,
        if (minMargin != null) 'minMargin': minMargin,
        if (maxMargin != null) 'maxMargin': maxMargin,
        if (marginStatus != null) 'marginStatus': marginStatus,
        if (searchTerm != null) 'searchTerm': searchTerm,
        'page': page,
        'pageSize': pageSize,
        'sortBy': sortBy,
        'sortDescending': sortDescending,
      },
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Busca produtos por nome ou código de barras
  /// GET /api/pricing/products/search
  Future<ApiResponse<List<Map<String, dynamic>>>> searchProducts({
    required String query,
    int limit = 20,
  }) async {
    return await _apiService.get<List<Map<String, dynamic>>>(
      '/pricing/products/search',
      queryParams: {'q': query, 'limit': limit},
      parser: (data) {
        if (data is List) {
          return data.map((item) => item as Map<String, dynamic>).toList();
        }
        return [];
      },
    );
  }

  // =========================================================================
  // OTIMIZAÇÀO
  // =========================================================================

  /// Obtém sugestões de otimização de preços
  /// GET /api/pricing/optimization/suggestions
  Future<ApiResponse<List<Map<String, dynamic>>>> getOptimizationSuggestions({
    double targetMargin = 30,
  }) async {
    return await _apiService.get<List<Map<String, dynamic>>>(
      '/pricing/optimization/suggestions',
      queryParams: {'targetMargin': targetMargin},
      parser: (data) {
        if (data is List) {
          return data.map((item) => item as Map<String, dynamic>).toList();
        }
        return [];
      },
    );
  }

  /// Calcula preço a partir de margem desejada
  /// GET /api/pricing/calculate/price-from-margin
  Future<ApiResponse<Map<String, dynamic>>> calculatePriceFromMargin({
    required double cost,
    required double targetMargin,
  }) async {
    return await _apiService.get<Map<String, dynamic>>(
      '/pricing/calculate/price-from-margin',
      queryParams: {'cost': cost, 'targetMargin': targetMargin},
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Calcula margem a partir de preço e custo
  /// GET /api/pricing/calculate/margin
  Future<ApiResponse<Map<String, dynamic>>> calculateMargin({
    required double price,
    required double cost,
  }) async {
    return await _apiService.get<Map<String, dynamic>>(
      '/pricing/calculate/margin',
      queryParams: {'price': price, 'cost': cost},
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  // =========================================================================
  // PRECIFICAÇÀO DINÂMICA
  // =========================================================================

  /// Obtém configuração de precificação dinâmica
  /// GET /api/pricing/dynamic/config
  Future<ApiResponse<Map<String, dynamic>>> getDynamicPricingConfig() async {
    return await _apiService.get<Map<String, dynamic>>(
      '/pricing/dynamic/config',
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Atualiza configuração de precificação dinâmica
  /// PUT /api/pricing/dynamic/config
  Future<ApiResponse<Map<String, dynamic>>> updateDynamicPricingConfig({
    required Map<String, dynamic> config,
  }) async {
    return await _apiService.put<Map<String, dynamic>>(
      '/pricing/dynamic/config',
      body: config,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Libera recursos
  void dispose() {
    _apiService.dispose();
  }
}



