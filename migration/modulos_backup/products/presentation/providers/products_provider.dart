import 'package:flutter/foundation.dart';
import 'package:tagbean/features/products/data/repositories/products_repository.dart';
import 'package:tagbean/shared/models/models.dart';

/// Provider para gerenciamento de produtos
/// Utiliza ProdutoRepository para comunicação com o backend
class ProdutoProvider with ChangeNotifier {
  final ProdutoRepository _repository;
  
  List<Produto> _produtos = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMorePages = true;

  /// Construtor com injeção de dependência opcional
  ProdutoProvider({ProdutoRepository? repository})
      : _repository = repository ?? ProdutoRepository();

  // Getters
  List<Produto> get produtos => _produtos;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMorePages => _hasMorePages;
  int get currentPage => _currentPage;

  /// Carrega produtos do backend
  /// GET /api/products
  Future<void> carregarProdutos({
    bool refresh = false,
    String? search,
    String? categoriaId,
    bool? ativo,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasMorePages = true;
    }

    if (!_hasMorePages && !refresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.listarProdutos(
        page: _currentPage,
        pageSize: _pageSize,
        search: search,
        categoriaId: categoriaId,
        ativo: ativo,
      );

      if (response.isSuccess && response.data != null) {
        if (refresh) {
          _produtos = response.data!;
        } else {
          _produtos.addAll(response.data!);
        }
        
        // Verifica se tem mais páginas
        _hasMorePages = response.data!.length >= _pageSize;
        if (_hasMorePages) _currentPage++;
      } else {
        _error = response.errorMessage ?? 'Erro ao carregar produtos';
      }
    } catch (e) {
      _error = 'Erro ao carregar produtos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Busca um produto específico por ID
  /// GET /api/products/:id
  Future<Produto?> buscarProdutoPorId(String id) async {
    try {
      final response = await _repository.buscarProduto(id);
      if (response.isSuccess && response.data != null) {
        return response.data;
      } else {
        _error = response.errorMessage ?? 'Produto não encontrado';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = 'Erro ao buscar produto: $e';
      notifyListeners();
      return null;
    }
  }

  /// Cria um novo produto
  /// POST /api/products
  Future<bool> criarProduto({
    required String storeId,
    required String codigo,
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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.criarProduto(
        storeId: storeId,
        codigo: codigo,
        nome: nome,
        descricao: descricao,
        preco: preco,
        precoCusto: precoCusto,
        precoPromocional: precoPromocional,
        categoriaId: categoriaId,
        codigoBarras: codigoBarras,
        estoque: estoque,
        ativo: ativo,
      );

      if (response.isSuccess && response.data != null) {
        _produtos.insert(0, response.data!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.errorMessage ?? 'Erro ao criar produto';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erro ao criar produto: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Atualiza um produto existente
  /// PUT /api/products/:id
  Future<bool> atualizarProduto({
    required String id,
    String? codigo,
    String? nome,
    String? descricao,
    double? preco,
    double? precoCusto,
    double? precoPromocional,
    String? categoriaId,
    String? codigoBarras,
    int? estoque,
    bool? ativo,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.atualizarProduto(
        id: id,
        codigo: codigo,
        nome: nome,
        descricao: descricao,
        preco: preco,
        precoCusto: precoCusto,
        precoPromocional: precoPromocional,
        categoriaId: categoriaId,
        codigoBarras: codigoBarras,
        estoque: estoque,
        ativo: ativo,
      );

      if (response.isSuccess && response.data != null) {
        // Atualiza na lista local
        final index = _produtos.indexWhere((p) => p.id == id);
        if (index >= 0) {
          _produtos[index] = response.data!;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.errorMessage ?? 'Erro ao atualizar produto';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erro ao atualizar produto: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Exclui um produto
  /// DELETE /api/products/:id
  Future<bool> excluirProduto(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.excluirProduto(id);

      if (response.isSuccess) {
        _produtos.removeWhere((p) => p.id == id);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.errorMessage ?? 'Erro ao excluir produto';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erro ao excluir produto: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Busca produtos por código de barras
  /// GET /api/products/search?codigoBarras=xxx
  Future<List<Produto>> buscarPorCodigoBarras(String codigoBarras) async {
    try {
      final response = await _repository.buscarPorCodigoBarras(codigoBarras);
      if (response.isSuccess && response.data != null) {
        return response.data!;
      }
      return [];
    } catch (e) {
      _error = 'Erro ao buscar por código de barras: $e';
      notifyListeners();
      return [];
    }
  }

  /// Atualização em lote de produtos
  /// POST /api/products/bulk
  Future<bool> atualizarEmLote({
    required List<String> produtoIds,
    double? ajustePreco,
    double? ajustePrecoPercentual,
    String? categoriaId,
    bool? ativo,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.atualizarEmLote(
        produtoIds: produtoIds,
        ajustePreco: ajustePreco,
        ajustePrecoPercentual: ajustePrecoPercentual,
        categoriaId: categoriaId,
        ativo: ativo,
      );

      if (response.isSuccess) {
        // Recarrega a lista para refletir as mudanças
        await carregarProdutos(refresh: true);
        return true;
      } else {
        _error = response.errorMessage ?? 'Erro na atualização em lote';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erro na atualização em lote: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Obtém estatísticas dos produtos
  Map<String, int> getEstatisticas() {
    final total = _produtos.length;
    final ativos = _produtos.where((p) => p.ativo).length;
    final inativos = total - ativos;
    final comPromo = _produtos.where((p) => p.precoPromocional != null).length;

    return {
      'total': total,
      'ativos': ativos,
      'inativos': inativos,
      'comPromocao': comPromo,
    };
  }

  /// Filtra produtos localmente
  List<Produto> filtrarProdutos({
    String? searchQuery,
    String? categoriaId,
    bool? apenasAtivos,
    bool? comPromocao,
  }) {
    return _produtos.where((produto) {
      // Filtro por busca
      final matchSearch = searchQuery == null ||
          searchQuery.isEmpty ||
          produto.nome.toLowerCase().contains(searchQuery.toLowerCase()) ||
          produto.codigo.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (produto.codigoBarras?.contains(searchQuery) ?? false);

      // Filtro por categoria
      final matchCategoria = categoriaId == null ||
          categoriaId.isEmpty ||
          produto.categoriaId == categoriaId;

      // Filtro por status
      final matchAtivo = apenasAtivos == null || produto.ativo == apenasAtivos;

      // Filtro por promoção
      final matchPromo = comPromocao == null ||
          (comPromocao && produto.precoPromocional != null) ||
          (!comPromocao && produto.precoPromocional == null);

      return matchSearch && matchCategoria && matchAtivo && matchPromo;
    }).toList();
  }

  /// Limpa o erro atual
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Libera recursos
  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
