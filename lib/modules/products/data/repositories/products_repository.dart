import 'package:tagbean/core/constants/api_constants.dart';

import 'package:tagbean/core/network/api_response.dart';

import 'package:tagbean/shared/models/models.dart';

import 'package:tagbean/core/network/api_client.dart';



/// Repository para gerenciar produtos

/// Este é um exemplo de como implementar a camada de repository

/// que abstrai as chamadas à API e fornece uma interface limpa para as telas

class ProdutoRepository {

  final ApiService _apiService;



  ProdutoRepository({ApiService? apiService})

      : _apiService = apiService ?? ApiService();



  /// Lista todos os produtos

  /// GET /api/produtos

  Future<ApiResponse<List<Produto>>> listarProdutos({

    int page = 1,

    // ignore: argument_type_not_assignable
    int pageSize = 20,

    String? search,

    String? categoriaId,

    bool? ativo,

  }) async {

    final queryParams = <String, dynamic>{

      // ignore: argument_type_not_assignable
      'page': page,

      'pageSize': pageSize,

      if (search != null && search.isNotEmpty) 'search': search,

      if (categoriaId != null) 'categoriaId': categoriaId,

      if (ativo != null) 'ativo': ativo,
 // ignore: argument_type_not_assignable

    };



    return await _apiService.get<List<Produto>>(

      ApiConstants.produtos,

      queryParams: queryParams,

      // ignore: argument_type_not_assignable
      parser: (data) {

        if (data is List) {

          return data.map((item) => Produto.fromJson(item)).toList();

        }

        return [];

      },

    );

  }



  /// Busca um produto por ID

  /// GET /api/produtos/:id

  Future<ApiResponse<Produto>> buscarProduto(String id) async {

    return await _apiService.get<Produto>(

      ApiConstants.produtoById(id),

      parser: (data) => Produto.fromJson(data),

    );

  }


 // ignore: argument_type_not_assignable

  /// Busca um produto por código de barras
 // ignore: argument_type_not_assignable

  /// GET /api/products/barcode/:barcode

  Future<ApiResponse<Produto>> buscarProdutoPorBarcode(String barcode) async {

    return await _apiService.get<Produto>(

      '/products/barcode/$barcode',

      parser: (data) => Produto.fromJson(data),

    );

  }



  /// Lista produtos de uma loja específica (sem paginação)

  /// GET /api/products/store/{storeId}

  Future<ApiResponse<List<Produto>>> listarProdutosPorLoja(String storeId) async {

    return await _apiService.get<List<Produto>>(

      ApiConstants.productsByStore(storeId),

      parser: (data) {

        if (data is List) {

          return data.map((item) => Produto.fromJson(item)).toList();

        }

        return [];

      },

    );

  }



  /// Cria um novo produto

  /// POST /api/products

  /// Backend espera: StoreId (obrigatório), Barcode, Name, Price, Category

  Future<ApiResponse<Produto>> criarProduto({

    required String storeId,

    required String codigo,
 // ignore: argument_type_not_assignable

    required String nome,

    String? descricao,

    required double preco,

    double? precoCusto,

    double? precoPromocional,

    String? categoriaId,

    String? codigoBarras,

    int? estoque,

    bool ativo = true,

  }) async {

    final body = {

      'storeId': storeId,

      'barcode': codigo, // Backend usa 'barcode' não 'código'

      'name': nome, // Backend usa 'name' não 'nome'

      'price': preco, // Backend usa 'price' não 'preco'

      if (descricao != null) 'description': descricao,

      if (estoque != null) 'stock': estoque,

      // Categoria mapeada para enum do backend

      'category': _mapCategoryToBackend(categoriaId),

    };



    return await _apiService.post<Produto>(

      ApiConstants.products,

      body: body,

      parser: (data) => Produto.fromJson(data),

    );

  }

  

  /// Mapeia categoria do frontend para enum do backend

  int _mapCategoryToBackend(String? categoria) {

    // ProductCategory enum no backend:

    // 0 = Food, 1 = Beverage, 2 = Electronics, 3 = Clothing, 4 = Home, 5 = Other

    switch (categoria?.toLowerCase()) {

      case 'bebidas':

        return 1; // Beverage

      case 'mercearia':

        return 0; // Food

      case 'perecíveis':

      case 'pereciveis':

        return 0; // Food
 // ignore: argument_type_not_assignable

      case 'limpeza':

        return 4; // Home

      case 'higiene':

        return 5; // Other

      default:

        return 5; // Other

    }

  }



  /// Atualiza um produto existente

  /// PUT /api/produtos/:id

  Future<ApiResponse<Produto>> atualizarProduto({

    required String id,

    String? codigo,

    String? nome,

    String? descricao,

    double? preco,

    double? precoCusto,

    double? precoPromocional,

    String? categoriaId,

    String? codigoBarras,
 // ignore: argument_type_not_assignable

    int? estoque,

    bool? ativo,

  }) async {

    final body = <String, dynamic>{};



    if (codigo != null) body['código'] = codigo;

    if (nome != null) body['nome'] = nome;

    if (descricao != null) body['descricao'] = descricao;

    if (preco != null) body['preco'] = preco;

    if (precoCusto != null) body['precoCusto'] = precoCusto;

    if (precoPromocional != null) body['precoPromocional'] = precoPromocional;

    if (categoriaId != null) body['categoriaId'] = categoriaId;

    if (codigoBarras != null) body['codigoBarras'] = codigoBarras;

    if (estoque != null) body['estoque'] = estoque;

    if (ativo != null) body['ativo'] = ativo;



    return await _apiService.put<Produto>(

      ApiConstants.produtoById(id),

      body: body,

      parser: (data) => Produto.fromJson(data),

    );

  }



  // ignore: argument_type_not_assignable
  /// Exclui um produto

  /// DELETE /api/produtos/:id

  Future<ApiResponse<void>> excluirProduto(String id) async {

    return await _apiService.delete(

      ApiConstants.produtoById(id),

    );

  }



  /// Exclui múltiplos produtos em lote
 // ignore: argument_type_not_assignable

  /// DELETE /api/products/batch

  Future<ApiResponse<Map<String, dynamic>>> excluirEmLote({

    required List<String> produtoIds,

  }) async {

    return await _apiService.delete<Map<String, dynamic>>(

      ApiConstants.productsBatch,

      body: {'productIds': produtoIds},

      parser: (data) => data as Map<String, dynamic>,

    );

  }



  /// Obtém estatísticas globais dos produtos

  /// GET /api/products/store/{storeId}/statistics (ATUALIZADO conforme novo endpoint)

  Future<ApiResponse<Map<String, dynamic>>> getEstatisticas({String? storeId}) async {

    final endpoint = storeId != null 

        ? ApiConstants.productsStatisticsByStore(storeId)

        : '/products/statistics'; // Fallback para endpoint antigo

    return await _apiService.get<Map<String, dynamic>>(

      endpoint,

      parser: (data) => data as Map<String, dynamic>,

    );

  }



  /// Obtém estatísticas de estoque

  /// GET /api/products/store/{storeId}/stock (ATUALIZADO conforme novo endpoint)

  Future<ApiResponse<List<Map<String, dynamic>>>> getEstoque({

    String? storeId,

    String? categoriaId,

    String? status, // 'critical', 'low', 'normal', 'outofstock'

    int page = 1,

    int pageSize = 50,

  }) async {

    final endpoint = storeId != null 

        ? ApiConstants.productsStockByStore(storeId)

        : '/products/stock'; // Fallback

    return await _apiService.get<List<Map<String, dynamic>>>(

      endpoint,

      queryParams: {

        if (categoriaId != null) 'categoryId': categoriaId,

        if (status != null) 'status': status,

        'page': page,

        'pageSize': pageSize,

      },

      parser: (data) {

        if (data is List) {

          return data.map((item) => item as Map<String, dynamic>).toList();

        }

        return [];

      },

    );

  }



  /// Atualiza estoque de um produto individual

  /// PUT /api/products/{id}/stock (NOVO conforme relatório)

  Future<ApiResponse<Produto>> atualizarEstoque({

    required String productId,

    required int novaQuantidade,

    String? motivo,

  }) async {

    final body = {

      'stock': novaQuantidade,

      if (motivo != null) 'reason': motivo,

    };



    return await _apiService.put<Produto>(

      ApiConstants.productStock(productId),

      body: body,

      parser: (data) => Produto.fromJson(data),

    );

  }



  /// Atualiza múltiplos produtos em lote

  /// PUT /api/products/batch (NOVO conforme relatório)

  Future<ApiResponse<Map<String, dynamic>>> atualizarProdutosEmLote({

    required String storeId,

    required List<String> produtoIds,

    double? precoFixo,

    double? percentualAumento,

    double? percentualDesconto,

    String? categoriaId,

    bool? ativo,

  }) async {

    final body = {

      'storeId': storeId,

      'productIds': produtoIds,

      if (precoFixo != null) 'fixedPrice': precoFixo,

      if (percentualAumento != null) 'percentageIncrease': percentualAumento,

      if (percentualDesconto != null) 'percentageDecrease': percentualDesconto,

      if (categoriaId != null) 'category': _mapCategoryToBackend(categoriaId),

      if (ativo != null) 'isActive': ativo,

    };



    return await _apiService.put<Map<String, dynamic>>(

      ApiConstants.productsBatch,

      body: body,

      parser: (data) => data as Map<String, dynamic>,

    );

  }



  /// Busca produtos por código de barras

  /// GET /api/produtos/search?codigoBarras=xxx

  Future<ApiResponse<List<Produto>>> buscarPorCodigoBarras(

    String codigoBarras,

  ) async {

    return await _apiService.get<List<Produto>>(

      ApiConstants.produtosSearch,

      queryParams: {'codigoBarras': codigoBarras},

      parser: (data) {

        if (data is List) {

          return data.map((item) => Produto.fromJson(item)).toList();

        }

        return [];

      },

    );

  }



  /// Atualização em lote

  /// POST /api/produtos/bulk

  Future<ApiResponse<Map<String, dynamic>>> atualizarEmLote({

    required List<String> produtoIds,

    double? ajustePreco,

    double? ajustePrecoPercentual,

    String? categoriaId,

    bool? ativo,

  }) async {

    final body = {

      'produtoIds': produtoIds,

      if (ajustePreco != null) 'ajustePreco': ajustePreco,

      if (ajustePrecoPercentual != null)

        'ajustePrecoPercentual': ajustePrecoPercentual,

      if (categoriaId != null) 'categoriaId': categoriaId,

      if (ativo != null) 'ativo': ativo,

    };



    return await _apiService.post<Map<String, dynamic>>(

      ApiConstants.productsBatch,

      body: body,

      parser: (data) => data as Map<String, dynamic>,

    );

  }



  /// Atualiza o preço de um produto

  /// PUT /api/products/:id/price

  Future<ApiResponse<Produto>> atualizarPreco({

    required String productId,

    required double novoPreco,

    double? precoPromocional,

  }) async {

    final body = {

      'price': novoPreco,

      if (precoPromocional != null) 'promotionalPrice': precoPromocional,

    };



    return await _apiService.put<Produto>(

      ApiConstants.products.price(productId),

      body: body,

      parser: (data) => Produto.fromJson(data),

    );

  }



  /// Atualiza o estoque de um produto

  /// PUT /api/products/:id/stock

  Future<ApiResponse<Produto>> updateStock({

    required String productId,

    required int novaQuantidade,

  }) async {

    final body = {

      'stock': novaQuantidade,

    };



    return await _apiService.put<Produto>(

      '/products/$productId/stock',

      body: body,

      parser: (data) => Produto.fromJson(data),

    );

  }



  /// Obtém histórico de preços de um produto

  /// GET /api/products/:id/price-history

  Future<ApiResponse<List<Map<String, dynamic>>>> getHistoricoPrecos(String productId) async {

    return await _apiService.get<List<Map<String, dynamic>>>(

      '/products/$productId/price-history',

      parser: (data) {

        if (data is List) {

          return data.map((item) => item as Map<String, dynamic>).toList();

        }

        return [];

      },

    );

  }



  /// Obtém estatísticas de vendas de um produto

  /// GET /api/products/:id/statistics

  Future<ApiResponse<Map<String, dynamic>>> getProductStatistics(String productId) async {

    return await _apiService.get<Map<String, dynamic>>(

      '/products/$productId/statistics',

      parser: (data) => data as Map<String, dynamic>,

    );

  }



  /// Sincroniza um produto do Minew para o banco local

  /// POST /api/products/:id/sync?storeId=xxx

  /// Retorna SyncProductResultDto com informações da sincronização

  Future<ApiResponse<Map<String, dynamic>>> syncProductFromMinew({

    required String productId,

    required String storeId,

  }) async {

    return await _apiService.post<Map<String, dynamic>>(

      '/products/$productId/sync?storeId=$storeId',

      parser: (data) => data as Map<String, dynamic>,

    );

  }



  /// Atualiza produtos e sincroniza tags em lote

  /// PUT /api/products/batch/sync

  /// Retorna SyncTagsResultDto com estatísticas da operação

  Future<ApiResponse<Map<String, dynamic>>> updateProductsAndSyncTags({

    required String storeId,

    required List<String> productIds,

    double? fixedPrice,

    double? percentageIncrease,

    double? percentageDecrease,

    String? category,

    bool? isActive,

  }) async {

    final body = {

      'storeId': storeId,

      'productIds': productIds,

      if (fixedPrice != null) 'fixedPrice': fixedPrice,

      if (percentageIncrease != null) 'percentageIncrease': percentageIncrease,

      if (percentageDecrease != null) 'percentageDecrease': percentageDecrease,

      if (category != null) 'category': _mapCategoryToBackend(category),

      if (isActive != null) 'isActive': isActive,

    };



    return await _apiService.put<Map<String, dynamic>>(

      '/products/batch/sync',

      body: body,

      parser: (data) => data as Map<String, dynamic>,

    );

  }



  /// Dispose do serviço

  void dispose() {

    _apiService.dispose();

  }

}



// ============================================================================

// EXEMPLO DE USO EM UMA TELA

// ============================================================================



/*

class ProdutosListaScreen extends StatefulWidget {

  const ProdutosListaScreen({super.key});



  @override

  State<ProdutosListaScreen> createState() => _ProdutosListaScreenState();

}



class _ProdutosListaScreenState extends State<ProdutosListaScreen> {

  final _repository = ProdutoRepository();

  List<Produto> _produtos = [];

  bool _isLoading = false;

  String _searchQuery = '';



  @override

  void initState() {

    super.initState();

    _carregarProdutos();

  }



  @override

  void dispose() {

    _repository.dispose();

    super.dispose();

  }



  Future<void> _carregarProdutos() async {

    setState(() => _isLoading = true);



    final response = await _repository.listarProdutos(

      search: _searchQuery.isEmpty ? null : _searchQuery,

    );



    setState(() => _isLoading = false);



    response.when(

      success: (produtos) {

        setState(() {

          _produtos = produtos ?? [];

        });

      },

      error: (message, statusCode) {

        DialogHelper.showError(context, message: message);

      },

    );

  }



  Future<void> _excluirProduto(String id) async {

    final confirmed = await DialogHelper.confirmDelete(context);

    if (confirmed != true) return;



    LoadingDialog.show(context, message: 'Excluindo produto...');



    final response = await _repository.excluirProduto(id);



    LoadingDialog.hide(context);



    response.when(

      success: (_) {

        DialogHelper.showSuccess(

          context,

          message: 'Produto excluído com sucesso!',

        );

        _carregarProdutos(); // Recarrega lista

      },

      error: (message, statusCode) {

        DialogHelper.showError(context, message: message);

      },

    );

  }



  @override

  Widget build(BuildContext context) {

    if (_isLoading) {

      return const LoadingWidget(message: 'Carregando produtos...');

    }



    if (_produtos.isEmpty) {

      return EmptyCard(

        message: 'Nenhum produto encontrado',

        subtitle: 'Adicione produtos para começar',

        icon: Icons.inventory_2_rounded,

      );

    }



    return ListView.builder(

      itemCount: _produtos.length,

      itemBuilder: (context, index) {

        final produto = _produtos[index];

        return ListTile(

          title: Text(produto.nome),

          subtitle: Text(produto.preco.toCurrency()),

          trailing: IconButton(

            icon: const Icon(Icons.delete_rounded),

            onPressed: () => _excluirProduto(produto.id),

          ),

        );

      },

    );

  }

}

*/








