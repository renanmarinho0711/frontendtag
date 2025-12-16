import 'package:tagbean/core/network/api_client.dart';
import 'package:tagbean/core/network/api_response.dart';
// REMOVIDO: Models nao existem

class CategoriesRepository {
  final ApiService _apiService;

  CategoriesRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Exclui uma categoria - DELETE /api/categories/:id
  Future<ApiResponse<void>> deleteCategory(String id) async {
    return await _apiService.delete('/categories/');
  }

  /// Vincula um produto a uma categoria
  Future<ApiResponse<void>> addProductToCategory({
    required String productId,
    required String categoryId,
  }) async {
    return await _apiService.put<void>(
      '/products/',
      body: {'categoryId': categoryId},
      parser: (_) => null,
    );
  }

  /// Remove um produto de uma categoria
  Future<ApiResponse<void>> removeProductFromCategory({
    required String productId,
  }) async {
    return await _apiService.put<void>(
      '/products/',
      body: {'categoryId': null},
      parser: (_) => null,
    );
  }

  void dispose() {
    _apiService.dispose();
  }
}

