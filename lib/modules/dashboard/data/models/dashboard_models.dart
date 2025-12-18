/// Modelo de estatísticas da loja

/// Mapeado para: StoreStatsDto do backend

class StoreStats {

  final int productsCount;

  final int tagsCount;

  final int boundTagsCount;

  final int availableTagsCount;

  final int todaySalesCount;

  final DateTime? lastSyncDate;

  // Novos campos para Status Geral e Fluxos Inteligentes

  final int productsWithoutPrice;

  final int productsWithoutTag;

  final int tagsWithoutProduct;

  final int importsWithErrors;



  const StoreStats({

    required this.productsCount,

    required this.tagsCount,

    required this.boundTagsCount,

    required this.availableTagsCount,

    this.todaySalesCount = 0,

    this.lastSyncDate,

    this.productsWithoutPrice = 0,

    this.productsWithoutTag = 0,

    this.tagsWithoutProduct = 0,

    this.importsWithErrors = 0,

  });



  /// Tags online (estimativa: tags vinculadas são consideradas online)

  int get onlineTagsCount => boundTagsCount;



  /// Percentual de tags vinculadas

  double get bindingPercentage =>

      tagsCount > 0 ? (boundTagsCount / tagsCount) * 100 : 0;



  factory StoreStats.fromJson(Map<String, dynamic> json) {

    return StoreStats(

      productsCount: json['productsCount'] as int? ?? 0,

      tagsCount: json['tagsCount'] as int? ?? 0,

      boundTagsCount: json['boundTagsCount'] as int? ?? 0,

      availableTagsCount: json['availableTagsCount'] as int? ?? 0,

      todaySalesCount: json['todaySalesCount'] as int? ?? 0,

      lastSyncDate: json['lastSyncDate'] != null

          ? DateTime.parse(json['lastSyncDate'] as String)

          : null,

      productsWithoutPrice: json['productsWithoutPrice'] as int? ?? 0,

      productsWithoutTag: json['productsWithoutTag'] as int? ?? 0,

      tagsWithoutProduct: json['tagsWithoutProduct'] as int? ?? 0,

      importsWithErrors: json['importsWithErrors'] as int? ?? 0,

    );

  }



  Map<String, dynamic> toJson() {

    return {
 // ignore: argument_type_not_assignable

      'productsCount': productsCount,

      'tagsCount': tagsCount,

      'boundTagsCount': boundTagsCount,

      'availableTagsCount': availableTagsCount,

      'todaySalesCount': todaySalesCount,

      'lastSyncDate': lastSyncDate?.toIso8601String(),

      'productsWithoutPrice': productsWithoutPrice,

      'productsWithoutTag': productsWithoutTag,

      'tagsWithoutProduct': tagsWithoutProduct,

      'importsWithErrors': importsWithErrors,

    };

  }



  /// Stats vazio para fallback

  static const StoreStats empty = StoreStats(

    productsCount: 0,

    tagsCount: 0,

    boundTagsCount: 0,

    availableTagsCount: 0,

    todaySalesCount: 0,

    productsWithoutPrice: 0,

    productsWithoutTag: 0,

    tagsWithoutProduct: 0,

    importsWithErrors: 0,

  );

}



/// Modelo de estatísticas de estratégias de precificação

class StrategiesStats {

  final int activeCount;

  final int affectedProductsCount;

  final double monthlyGain;

  final double todayGain;

  final String growthPercentage;

  final List<StrategyDetails> strategies;



  const StrategiesStats({

    required this.activeCount,

    required this.affectedProductsCount,

    required this.monthlyGain,

    required this.todayGain,

    required this.growthPercentage,

    required this.strategies,

  });



  factory StrategiesStats.fromJson(Map<String, dynamic> json) {

    return StrategiesStats(

      activeCount: json['activeCount'] as int? ?? 0,

      affectedProductsCount: json['affectedProductsCount'] as int? ?? 0,

      monthlyGain: (json['monthlyGain'] as num?)?.toDouble() ?? 0.0,

      todayGain: (json['todayGain'] as num?)?.toDouble() ?? 0.0,

      growthPercentage: json['growthPercentage'] as String? ?? '0%',

      strategies: (json['strategies'] as List? ?? [])

          // ignore: argument_type_not_assignable
          .map((s) => StrategyDetails.fromJson(s))

          .toList(),

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'activeCount': activeCount,

      'affectedProductsCount': affectedProductsCount,

      'monthlyGain': monthlyGain,

      'todayGain': todayGain,

      // ignore: argument_type_not_assignable
      'growthPercentage': growthPercentage,
 // ignore: argument_type_not_assignable

      'strategies': strategies.map((s) => s.toJson()).toList(),
 // ignore: argument_type_not_assignable

    };

  }



  /// Stats vazio para fallback

  static const StrategiesStats empty = StrategiesStats(

    activeCount: 0,

    affectedProductsCount: 0,

    monthlyGain: 0.0,

    todayGain: 0.0,

    growthPercentage: '0%',

    strategies: [],

  );

}



/// Detalhes de uma estratégia

class StrategyDetails {

  final String id;

  final String name;

  final String status;

  final double gain;

  final int productsCount;

  final int colorValue;



  const StrategyDetails({

    required this.id,

    required this.name,

    required this.status,

    required this.gain,

    required this.productsCount,

    this.colorValue = 0xFF4CAF50, // Green default

  });



  factory StrategyDetails.fromJson(Map<String, dynamic> json) {

    return StrategyDetails(

      id: json['id'] as String? ?? '',

      name: json['name'] as String? ?? json['nome'] as String? ?? '',

      status: json['status'] as String? ?? 'Inativa',

      gain: (json['gain'] as num?)?.toDouble() ?? 

            (json['ganho'] as num?)?.toDouble() ?? 0.0,

      productsCount: json['productsCount'] as int? ?? 

                     json['produtos'] as int? ?? 0,

      colorValue: json['colorValue'] as int? ?? 0xFF4CAF50,

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'name': name,

      'status': status,

      'gain': gain,

      'productsCount': productsCount,

      'colorValue': colorValue,

    };

  }

}



/// Modelo de alerta do dashboard

class DashboardAlert {

  final String type;

  final int count;

  final String description;

  final int iconCodePoint;

  final int colorValue;

  final String details;



  const DashboardAlert({

    required this.type,

    required this.count,

    required this.description,

    required this.iconCodePoint,

    required this.colorValue,

    required this.details,

  });



  factory DashboardAlert.fromJson(Map<String, dynamic> json) {

    return DashboardAlert(

      type: json['type'] as String? ?? json['tipo'] as String? ?? '',

      count: json['count'] as int? ?? json['qtd'] as int? ?? 0,

      description: json['description'] as String? ?? 

                   json['descricao'] as String? ?? '',

      iconCodePoint: json['iconCodePoint'] as int? ?? 0xe047,

      colorValue: json['colorValue'] as int? ?? 0xFFFF9800,

      details: json['details'] as String? ?? 

               json['detalhes'] as String? ?? '',

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'type': type,

      'count': count,

      'description': description,

      'iconCodePoint': iconCodePoint,

      'colorValue': colorValue,

      'details': details,

    };

  }

}



/// Dados completos do dashboard

class DashboardData {

  final StoreStats storeStats;

  final StrategiesStats strategiesStats;

  final List<DashboardAlert> alerts;

  final DateTime? lastUpdate;



  const DashboardData({

    required this.storeStats,

    required this.strategiesStats,

    required this.alerts,

    this.lastUpdate,

  });



  factory DashboardData.fromJson(Map<String, dynamic> json) {

    return DashboardData(

      // ignore: argument_type_not_assignable
      storeStats: StoreStats.fromJson(json['storeStats'] ?? {}),

      // ignore: argument_type_not_assignable
      strategiesStats: StrategiesStats.fromJson(json['strategiesStats'] ?? {}),

      alerts: (json['alerts'] as List? ?? [])

          // ignore: argument_type_not_assignable
          .map((a) => DashboardAlert.fromJson(a))

          .toList(),

      lastUpdate: json['lastUpdate'] != null

          ? DateTime.parse(json['lastUpdate'] as String)

          : DateTime.now(),

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'storeStats': storeStats.toJson(),

      'strategiesStats': strategiesStats.toJson(),

      'alerts': alerts.map((a) => a.toJson()).toList(),

      'lastUpdate': lastUpdate?.toIso8601String(),

    };

  }



  /// Dashboard vazio para fallback

  static DashboardData get empty => DashboardData(

    storeStats: StoreStats.empty,

    strategiesStats: StrategiesStats.empty,

    alerts: const [],

    lastUpdate: DateTime.now(),

  );



  /// Getter para status de sincronização (derivado dos stats)

  DashboardSyncInfo? get syncStatus => DashboardSyncInfo(

    isConnected: true, // TODO: obter do estado real do ERP

    lastSync: storeStats.lastSyncDate ?? DateTime.now().subtract(const Duration(minutes: 5)),

    pendingCount: 0,

  );

}



/// Modelo de status de sincronização do Dashboard

/// Renomeado de SyncStatus para evitar conflito com enum SyncStatus do módulo sync

class DashboardSyncInfo {

  final bool isConnected;

  final DateTime? lastSync;

  final int pendingCount;



  const DashboardSyncInfo({

    required this.isConnected,

    this.lastSync,

    this.pendingCount = 0,

  });



  factory DashboardSyncInfo.fromJson(Map<String, dynamic> json) {

    return DashboardSyncInfo(

      isConnected: json['isConnected'] as bool? ?? false,

      lastSync: json['lastSync'] != null

          ? DateTime.parse(json['lastSync'] as String)

          : null,

      pendingCount: json['pendingCount'] as int? ?? 0,

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'isConnected': isConnected,

      'lastSync': lastSync?.toIso8601String(),

      'pendingCount': pendingCount,

    };

  }



  static const DashboardSyncInfo empty = DashboardSyncInfo(

    isConnected: false,

    lastSync: null,

    pendingCount: 0,

  );

}







