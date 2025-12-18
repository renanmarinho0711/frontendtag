import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tagbean/core/constants/api_constants.dart';
import 'package:tagbean/features/products/data/models/product_tag_model.dart';

/// Serviço para gerenciar vinculações Produto-Tag (N:N)
class ProductTagService {
  final String baseUrl;
  final String? authToken;

  ProductTagService({
    String? baseUrl,
    this.authToken,
  }) : baseUrl = baseUrl ?? ApiConstants.baseUrl;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (authToken != null) 'Authorization': 'Bearer $authToken',
  };

  // ===== CRUD =====

  /// Cria uma nova vinculação produto-tag
  Future<ProductTagModel> create(String storeId, CreateProductTagDto dto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/stores/$storeId/product-tags'),
      headers: _headers,
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // ignore: argument_type_not_assignable
      return ProductTagModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Erro ao criar vinculação: ${response.body}');
  }

  /// Obtém uma vinculação por ID
  Future<ProductTagModel?> getById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/product-tags/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      // ignore: argument_type_not_assignable
      return ProductTagModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    }
    throw Exception('Erro ao buscar vinculação: ${response.body}');
  }

  /// Atualiza uma vinculação
  Future<ProductTagModel?> update(int id, UpdateProductTagDto dto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/product-tags/$id'),
      headers: _headers,
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode == 200) {
      // ignore: argument_type_not_assignable
      return ProductTagModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    }
    throw Exception('Erro ao atualizar vinculação: ${response.body}');
  }

  /// Remove uma vinculação
  Future<bool> delete(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/product-tags/$id'),
      headers: _headers,
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }

  // ===== QUERIES =====

  /// Lista todas as tags vinculadas a um produto
  Future<ProductTagsList?> getTagsByProduct(String productId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/products/$productId/tags'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      // ignore: argument_type_not_assignable
      return ProductTagsList.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    }
    throw Exception('Erro ao buscar tags do produto: ${response.body}');
  }

  /// Lista todas as vinculações de uma loja
  Future<List<ProductTagModel>> getByStore(String storeId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/stores/$storeId/product-tags'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // ignore: argument_type_not_assignable
      return data.map((e) => ProductTagModel.fromJson(e)).toList();
    }
    throw Exception('Erro ao buscar vinculações: ${response.body}');
  }

  // ===== PRICE SYNC =====

  /// Sincroniza o preço de um produto para TODAS as tags vinculadas
  /// Este é o método principal para garantir que todas as tags
  /// exibam o mesmo preço quando ele é alterado
  Future<List<PriceSyncResult>> syncPriceToAllTags(String productId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/products/$productId/sync-price'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // ignore: argument_type_not_assignable
      return data.map((e) => PriceSyncResult.fromJson(e)).toList();
    }
    throw Exception('Erro ao sincronizar preços: ${response.body}');
  }

  /// Sincroniza preço para uma vinculação específica
  Future<PriceSyncResult> syncPrice(int productTagId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/product-tags/$productTagId/sync'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      // ignore: argument_type_not_assignable
      return PriceSyncResult.fromJson(jsonDecode(response.body));
    }
    throw Exception('Erro ao sincronizar: ${response.body}');
  }

  /// Sincroniza todos os produtos de uma loja
  Future<List<PriceSyncResult>> syncAllStore(String storeId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/stores/$storeId/sync-all-prices'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // ignore: argument_type_not_assignable
      return data.map((e) => PriceSyncResult.fromJson(e)).toList();
    }
    throw Exception('Erro ao sincronizar loja: ${response.body}');
  }

  // ===== BATCH OPERATIONS =====

  /// Vincula múltiplas tags a um produto
  Future<List<ProductTagModel>> linkMultipleTags(
    String storeId, 
    String productId, 
    List<String> tagMacAddresses,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/stores/$storeId/products/$productId/link-tags'),
      headers: _headers,
      body: jsonEncode({'tagMacAddresses': tagMacAddresses}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = jsonDecode(response.body);
      // ignore: argument_type_not_assignable
      return data.map((e) => ProductTagModel.fromJson(e)).toList();
    }
    throw Exception('Erro ao vincular tags: ${response.body}');
  }

  /// Desvincula todas as tags de um produto
  Future<int> unlinkAllTagsFromProduct(String productId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/products/$productId/unlink-all-tags'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['count'] ?? 0;
    }
    throw Exception('Erro ao desvincular: ${response.body}');
  }
}