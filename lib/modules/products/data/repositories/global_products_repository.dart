mport 'package:tagbean/core/network/api_response.dart';
import 'package:tagbean/core/network/api_client.dart';

/// Modelo de produto do catálogo global
class GlobalProduct {
  final String id;
  final String gtin;
  final String name;
  final String? description;
  final String? brand;
  final String? category;
  final String? ncm;
  final String? unit;
  final double? netWeight;
  final double? grossWeight;
  final String? imageUrl;
  final String? countryOfOrigin;
  final double? referencePrice;
  final bool isVerified;
  final bool found;

  GlobalProduct({
    required this.id,
    required this.gtin,
    required this.name,
    this.description,
    this.brand,
    this.category,
    this.ncm,
    this.unit,
    this.netWeight,
    this.grossWeight,
    this.imageUrl,
    this.countryOfOrigin,
    this.referencePrice,
    this.isVerified = false,
    this.found = true,
  });

  factory GlobalProduct.fromJson(Map<String, dynamic> json) {
    return GlobalProduct(
      id: json['id'] ?? '',
      gtin: json['gtin'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      brand: json['brand'],
      category: json['category'],
      ncm: json['ncm'],
      unit: json['unit'],
      netWeight: json['netWeight']?.toDouble(),
      grossWeight: json['grossWeight']?.toDouble(),
      imageUrl: json['imageUrl'],
      countryOfOrigin: json['countryOfOrigin'],
      referencePrice: json['referencePrice']?.toDouble(),
      isVerified: json['isVerified'] ?? false,
      found: json['found'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gtin': gtin,
      'name': name,
      'description': description,
      'brand': brand,
      'category': category,
      'ncm': ncm,
      'unit': unit,
      'netWeight': netWeight,
      'grossWeight': grossWeight,
      'imageUrl': imageUrl,
      'countryOfOrigin': countryOfOrigin,
      'referencePrice': referencePrice,
      'isVerified': isVerified,
      'found': found,
    };
  }
}

/// Repository para acesso ao catálogo global de produtos
class GlobalProductsRepository {
  final ApiService _apiService;

  GlobalProductsRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Busca um produto pelo código de barras no catálogo global
  /// GET /api/globalproducts/barcode/{barcode}
  Future<ApiResponse<GlobalProduct>> buscarPorBarcode(String barcode) async {
    return await _apiService.get<GlobalProduct>(
      '/globalproducts/barcode/$barcode',
      parser: (data) => GlobalProduct.fromJson(data),
    );
  }

  /// Pesquisa produtos no catálogo global
  /// GET /api/globalproducts/search
  Future<ApiResponse<List<GlobalProduct>>> pesquisar({
    String? termo,
    String? categoria,
    String? marca,
    int page = 1,
    int size = 20,
  }) async {
    final queryParams = <String, dynamic>{
      if (termo != null && termo.isNotEmpty) 'term': termo,
      if (categoria != null) 'category': categoria,
      if (marca != null) 'brand': marca,
      'page': page,
      'size': size,
    };

    return await _apiService.get<List<GlobalProduct>>(
      '/globalproducts/search',
      queryParams: queryParams,
      parser: (data) {
        if (data is Map && data['items'] is List) {
          return (data['items'] as List)
              .map((item) => GlobalProduct.fromJson(item))
              .toList();
        }
        if (data is List) {
          return data.map((item) => GlobalProduct.fromJson(item)).toList();
        }
        return [];
      },
    );
  }

  /// Adiciona um novo produto ao catálogo global
  /// POST /api/globalproducts
  Future<ApiResponse<GlobalProduct>> criar({
    required String gtin,
    required String nome,
    String? descricao,
    String? marca,
    String? categoria,
    String? ncm,
    String? unidade,
    double? pesoLiquido,
    double? pesoBruto,
    String? imagemUrl,
    String? paisOrigem,
    double? precoReferencia,
    String? fonteApi,
  }) async {
    final body = {
      'gtin': gtin,
      'name': nome,
      if (descricao != null) 'description': descricao,
      if (marca != null) 'brand': marca,
      if (categoria != null) 'category': categoria,
      if (ncm != null) 'ncm': ncm,
      if (unidade != null) 'unit': unidade,
      if (pesoLiquido != null) 'netWeight': pesoLiquido,
      if (pesoBruto != null) 'grossWeight': pesoBruto,
      if (imagemUrl != null) 'imageUrl': imagemUrl,
      if (paisOrigem != null) 'countryOfOrigin': paisOrigem,
      if (precoReferencia != null) 'referencePrice': precoReferencia,
      if (fonteApi != null) 'dataSource': fonteApi,
    };

    return await _apiService.post<GlobalProduct>(
      '/globalproducts',
      body: body,
      parser: (data) => GlobalProduct.fromJson(data),
    );
  }

  /// Importa um produto do catálogo global para uma loja
  /// POST /api/globalproducts/{globalProductId}/import/{storeId}
  Future<ApiResponse<Map<String, dynamic>>> importarParaLoja({
    required String globalProductId,
    required String storeId,
    double? preco,
    int? estoque,
  }) async {
    final body = <String, dynamic>{};
    if (preco != null) body['price'] = preco;
    if (estoque != null) body['stock'] = estoque;

    return await _apiService.post<Map<String, dynamic>>(
      '/globalproducts/$globalProductId/import/$storeId',
      body: body,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Obtém lista de categorias do catálogo global
  /// GET /api/globalproducts/categories
  Future<ApiResponse<List<String>>> getCategorias() async {
    return await _apiService.get<List<String>>(
      '/globalproducts/categories',
      parser: (data) {
        if (data is List) {
          return data.map((e) => e.toString()).toList();
        }
        return [];
      },
    );
  }

  /// Obtém lista de marcas do catálogo global
  /// GET /api/globalproducts/brands
  Future<ApiResponse<List<String>>> getMarcas({String? categoria}) async {
    final queryParams = <String, dynamic>{};
    if (categoria != null) queryParams['category'] = categoria;

    return await _apiService.get<List<String>>(
      '/globalproducts/brands',
      queryParams: queryParams,
      parser: (data) {
        if (data is List) {
          return data.map((e) => e.toString()).toList();
        }
        return [];
      },
    );
  }

  /// Obtém estatísticas do catálogo global
  /// GET /api/globalproducts/statistics
  Future<ApiResponse<Map<String, dynamic>>> getEstatisticas() async {
    return await _apiService.get<Map<String, dynamic>>(
      '/globalproducts/statistics',
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  void dispose() {
    _apiService.dispose();
  }
}



