import 'package:tagbean/core/constants/api_constants.dart';
import 'package:tagbean/core/network/api_client.dart';
import 'package:tagbean/core/network/api_response.dart';
import 'package:tagbean/features/dashboard/data/models/dashboard_models.dart';

/// Repositório para dados do Dashboard
/// Combina dados de múltiplos endpoints do backend
class DashboardRepository {
  final ApiService _apiService;

  DashboardRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Obtém estatísticas da loja
  /// GET /api/stores/:storeId/stats
  Future<ApiResponse<StoreStats>> getStoreStats(String storeId) async {
    return await _apiService.get<StoreStats>(
      ApiConstants.storeStats(storeId),
      // ignore: argument_type_not_assignable
      parser: (data) => StoreStats.fromJson(data),
    );
  }

  /// Obtém estatísticas de estratégias (da loja)
  /// GET /api/strategies/store/:storeId + agregação
  Future<ApiResponse<StrategiesStats>> getStrategiesStats(String storeId) async {
    try {
      // Busca estratégias da loja
      final response = await _apiService.get<List<dynamic>>(
        ApiConstants.strategiesByStore(storeId),
        parser: (data) => data is List ? data : [],
      );

      if (response.isSuccess && response.data != null) {
        final strategies = response.data!;
        
        // Calcula estatísticas agregadas
        final activeStrategies = strategies.where((s) => s['isActive'] == true).toList();
        double totalMonthlyGain = 0.0;
        double totalTodayGain = 0.0;
        int totalProducts = 0;

        final strategyDetails = <StrategyDetails>[];

        for (final strategy in activeStrategies) {
          final gain = (strategy['estimatedGain'] as num?)?.toDouble() ?? 0.0;
          final products = strategy['affectedProductsCount'] as int? ?? 0;
          
          totalMonthlyGain += gain;
          totalTodayGain += gain / 30; // Estimativa diária
          totalProducts += products;

          strategyDetails.add(StrategyDetails(
            id: strategy['id'] as String? ?? '',
            name: strategy['name'] as String? ?? '',
            status: strategy['isActive'] == true ? 'Ativa' : 'Inativa',
            gain: gain,
            productsCount: products,
            colorValue: _getColorForStrategy(strategy['type'] as String?),
          ));
        }

        // Calcula crescimento baseado em ganho diário vs mensal
        // Nota: Quando disponível, usar endpoint GET /api/dashboard/stats para fornecer crescimento real
        // Por enquanto, calcula proporção entre ganho diário e mensal estimado
        final growth = totalMonthlyGain > 0 ? '+${((totalTodayGain / totalMonthlyGain) * 100).toStringAsFixed(1)}%' : '0%';

        final stats = StrategiesStats(
          activeCount: activeStrategies.length,
          affectedProductsCount: totalProducts,
          monthlyGain: totalMonthlyGain,
          todayGain: totalTodayGain,
          growthPercentage: growth,
          strategies: strategyDetails,
        );

        return ApiResponse.success(stats);
      }

      return ApiResponse.error(response.errorMessage ?? 'Erro ao buscar estratégias');
    } catch (e) {
      return ApiResponse.error('Erro ao calcular estatísticas: $e');
    }
  }

  /// Gera alertas baseado nos dados
  /// Combina informações de múltiplos endpoints
  Future<ApiResponse<List<DashboardAlert>>> getAlerts(String storeId) async {
    try {
      final alerts = <DashboardAlert>[];

      // Busca produtos para verificar problemas
      final productsResponse = await _apiService.get<List<dynamic>>(
        ApiConstants.productsByStore(storeId),
        parser: (data) => data is List ? data : [],
      );

      if (productsResponse.isSuccess && productsResponse.data != null) {
        final products = productsResponse.data!;
        
        // Alerta: Produtos sem preço
        final noPrice = products.where((p) => 
            (p['preco'] as num?)?.toDouble() == 0 || p['preco'] == null).length;
        if (noPrice > 0) {
          alerts.add(DashboardAlert(
            type: 'Produtos sem preço',
            count: noPrice,
            description: '$noPrice itens',
            iconCodePoint: 0xe8ae, // Icons.money_off_rounded
            colorValue: 0xFFFF9800, // AppThemeColors.orangeMaterial
            details: 'Produtos cadastrados sem preço de venda definido. Isso impede a sincronização com as tags ESL.',
          ));
        }

        // Alerta: Margem negativa
        final negativaMargin = products.where((p) {
          final preco = (p['preco'] as num?)?.toDouble() ?? 0;
          final custo = (p['precoCusto'] as num?)?.toDouble() ?? 0;
          return custo > 0 && preco < custo;
        }).length;
        
        if (negativaMargin > 0) {
          alerts.add(DashboardAlert(
            type: 'Margem negativa',
            count: negativaMargin,
            description: '$negativaMargin produtos',
            iconCodePoint: 0xe8e2, // Icons.trending_down_rounded
            colorValue: 0xFFFF5722, // AppThemeColors.urgent
            details: 'Produtos com preço de venda menor que o custo. Ajuste urgente necessário.',
          ));
        }
      }

      // Busca tags para verificar problemas
      final tagsResponse = await _apiService.get<List<dynamic>>(
        ApiConstants.tagsByStore(storeId),
        parser: (data) => data is List ? data : [],
      );

      if (tagsResponse.isSuccess && tagsResponse.data != null) {
        final tags = tagsResponse.data!;
        
        // Alerta: Tags offline (status = 2)
        final offlineTags = tags.where((t) => t['status'] == 2).length;
        if (offlineTags > 0) {
          alerts.add(DashboardAlert(
            type: 'Tags offline',
            count: offlineTags,
            description: '$offlineTags tags há mais de 24h',
            iconCodePoint: 0xe69a, // Icons.signal_wifi_off_rounded
            colorValue: 0xFFF44336, // AppThemeColors.redMain
            details: 'Tags ESL não estão respondendo há mais de 24 horas. Verifique a conexão e bateria.',
          ));
        }

        // Alerta: Bateria baixa (batteryLevel < 20)
        final lowBattery = tags.where((t) => 
            (t['batteryLevel'] as int? ?? 100) < 20).length;
        if (lowBattery > 0) {
          alerts.add(DashboardAlert(
            type: 'Bateria baixa',
            count: lowBattery,
            description: '$lowBattery tags',
            iconCodePoint: 0xe19c, // Icons.battery_alert_rounded
            colorValue: 0xFFF57C00, // AppThemeColors.orangeMain (warning)
            details: 'Tags com bateria baixa. Considere substituir as baterias em breve.',
          ));
        }
      }

      return ApiResponse.success(alerts);
    } catch (e) {
      return ApiResponse.error('Erro ao gerar alertas: $e');
    }
  }

  /// Carrega todos os dados do dashboard de uma vez
  Future<ApiResponse<DashboardData>> loadDashboardData(String storeId) async {
    try {
      // Executa todas as requisições em paralelo
      final results = await Future.wait([
        getStoreStats(storeId),
        getStrategiesStats(storeId),
        getAlerts(storeId),
      ]);

      final storeStatsResult = results[0] as ApiResponse<StoreStats>;
      final strategiesResult = results[1] as ApiResponse<StrategiesStats>;
      final alertsResult = results[2] as ApiResponse<List<DashboardAlert>>;

      // Constrói o DashboardData com os resultados
      final dashboardData = DashboardData(
        storeStats: storeStatsResult.data ?? StoreStats.empty,
        strategiesStats: strategiesResult.data ?? StrategiesStats.empty,
        alerts: alertsResult.data ?? [],
        lastUpdate: DateTime.now(),
      );

      // Se pelo menos um teve sucesso, retorna os dados
      if (storeStatsResult.isSuccess || strategiesResult.isSuccess) {
        return ApiResponse.success(dashboardData);
      }

      return ApiResponse.error('Erro ao carregar dados do dashboard');
    } catch (e) {
      return ApiResponse.error('Erro ao carregar dashboard: $e');
    }
  }

  /// Retorna cor baseada no tipo de estratégia
  int _getColorForStrategy(String? type) {
    switch (type?.toLowerCase()) {
      case 'dynamicpricing':
      case 'dynamic_pricing':
        return 0xFF4CAF50; // Green
      case 'markdown':
      case 'markdown_auto':
        return 0xFF2196F3; // Blue
      case 'minimummargin':
      case 'minimum_margin':
        return 0xFFFF9800; // Orange
      case 'competitive':
      case 'competitividade':
        return 0xFF9C27B0; // Purple
      default:
        return 0xFF607D8B; // BlueGrey
    }
  }

  /// Libera recursos
  void dispose() {
    _apiService.dispose();
  }
}



