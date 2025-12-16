mport 'package:tagbean/core/network/api_client.dart';
import 'package:tagbean/core/network/api_response.dart';
import 'package:tagbean/features/categories/data/models/category_models.dart';

/// Repository para gerenciamento de categorias
/// Comunicação com endpoints de categorias do backend
class CategoriesRepository {
  final ApiService _apiService;

  CategoriesRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Lista todas as categorias
  /// GET /api/categories
  Future<ApiResponse<List<CategoryModel>>> getCategories() async {
    return await _apiService.get<List<CategoryModel>>(
      '/categories',
      parser: (data) {
        if (data is List) {
          return data.map((item) => CategoryModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
  }

  /// Lista apenas categorias ativas
  /// GET /api/categories/active
  Future<ApiResponse<List<CategoryModel>>> getActiveCategories() async {
    return await _apiService.get<List<CategoryModel>>(
      '/categories/active',
      parser: (data) {
        if (data is List) {
          return data.map((item) => CategoryModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
  }

  /// Obtém categorias sugeridas (pré-definidas pelo sistema)
  /// GET /api/categories/suggested
  Future<ApiResponse<List<SuggestedCategoryModel>>> getSuggestedCategories() async {
    return await _apiService.get<List<SuggestedCategoryModel>>(
      '/categories/suggested',
      parser: (data) {
        if (data is List) {
          return data.map((item) => SuggestedCategoryModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
  }

  /// Obtém uma categoria por ID
  /// GET /api/categories/:id
  Future<ApiResponse<CategoryModel>> getCategoryById(String id) async {
    return await _apiService.get<CategoryModel>(
      '/categories/$id',
      parser: (data) => CategoryModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Obtém produtos de uma categoria
  /// GET /api/categories/:id/products
  Future<ApiResponse<List<CategoryProductModel>>> getCategoryProducts(String categoryId) async {
    return await _apiService.get<List<CategoryProductModel>>(
      '/categories/$categoryId/products',
      parser: (data) {
        if (data is List) {
          return data.map((item) => CategoryProductModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
  }

  /// Obtém todas as categorias com seus produtos
  /// GET /api/categories/with-products
  Future<ApiResponse<List<CategoryWithProductsModel>>> getCategoriesWithProducts() async {
    return await _apiService.get<List<CategoryWithProductsModel>>(
      '/categories/with-products',
      parser: (data) {
        if (data is List) {
          return data.map((item) => CategoryWithProductsModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
  }

  /// Cria uma nova categoria
  /// POST /api/categories
  Future<ApiResponse<CategoryModel>> createCategory({
    required String nome,
    String? descricao,
    String? icone,
    String? cor,
    int displayOrder = 0,
  }) async {
    final body = {
      'name': nome,
      if (descricao != null) 'description': descricao,
      if (icone != null) 'icon': icone,
      if (cor != null) 'color': cor,
      'displayOrder': displayOrder,
    };

    return await _apiService.post<CategoryModel>(
      '/categories',
      body: body,
      parser: (data) => CategoryModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Atualiza uma categoria
  /// PUT /api/categories/:id
  Future<ApiResponse<CategoryModel>> updateCategory({
    required String id,
    String? nome,
    String? descricao,
    String? icone,
    String? cor,
    bool? ativo,
    int? displayOrder,
  }) async {
    final body = <String, dynamic>{};
    if (nome != null) body['name'] = nome;
    if (descricao != null) body['description'] = descricao;
    if (icone != null) body['icon'] = icone;
    if (cor != null) body['color'] = cor;
    if (ativo != null) body['isActive'] = ativo;
    if (displayOrder != null) body['displayOrder'] = displayOrder;

    return await _apiService.put<CategoryModel>(
      '/categories/$id',
      body: body,
      parser: (data) => CategoryModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Exclui uma categoria
  /// DELETE /api/categories/:id
  Future<ApiResponse<void>> deleteCategory(String id) async {
    return await _apiService.delete('/categories/$id');
  }

  /// Vincula um produto a uma categoria (atualiza categoryId do produto)
  /// PUT /api/products/:productId
  Future<ApiResponse<void>> addProductToCategory({
    required String productId,
    required String categoryId,
  }) async {
    return await _apiService.put<void>(
      '/products/$productId',
      body: {'categoryId': categoryId},
      parser: (_) => null,
    );
  }

  /// Remove um produto de uma categoria (limpa categoryId do produto)
  /// PUT /api/products/:productId
  Future<ApiResponse<void>> removeProductFromCategory({
    required String productId,
  }) async {
    return await _apiService.put<void>(
      '/products/$productId',
      body: {'categoryId': null},
      parser: (_) => null,
    );
  }

  /// Busca produtos disponíveis para vincular (sem categoria ou de outra categoria)
  /// GET /api/products
  Future<ApiResponse<List<CategoryProductModel>>> getAvailableProducts({
    String? search,
    int page = 1,
    int pageSize = 50,
  }) async {
    return await _apiService.get<List<CategoryProductModel>>(
      '/products',
      queryParams: {
        'page': page,
        'pageSize': pageSize,
        if (search != null && search.isNotEmpty) 'search': search,
      },
      parser: (data) {
        if (data is List) {
          return data.map((item) => CategoryProductModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
  }

  /// Libera recursos
  void dispose() {
    _apiService.dispose();
  }
}



