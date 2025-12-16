import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/tags/data/models/tag_model.dart';
import 'package:tagbean/features/tags/data/repositories/tags_repository.dart';

/// Provider para gerenciamento de etiquetas eletrônicas (ESL)
/// Utiliza TagsRepository para comunicação com o backend
class TagsProvider with ChangeNotifier {
  final TagsRepository _repository;

  List<TagModel> _tags = [];
  bool _isLoading = false;
  String? _error;
  String? _currentStoreId;
  int _currentPage = 1;
  int _pageSize = 50;
  int _totalCount = 0;
  int _totalPages = 0;
  bool _hasMorePages = true;

  /// Construtor com injeção de dependência opcional
  TagsProvider({TagsRepository? repository})
      : _repository = repository ?? TagsRepository();

  // Getters
  List<TagModel> get tags => _tags;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentStoreId => _currentStoreId;
  int get currentPage => _currentPage;
  int get totalCount => _totalCount;
  int get totalPages => _totalPages;
  bool get hasMorePages => _hasMorePages;

  /// Estatísticas das tags
  Map<String, int> get stats {
    final total = _tags.length;
    final online = _tags.where((t) => t.isOnline).length;
    final bound = _tags.where((t) => t.isBound).length;
    final lowBattery = _tags.where((t) => t.isLowBattery).length;

    return {
      'total': total,
      'online': online,
      'offline': total - online,
      'bound': bound,
      'available': total - bound,
      'lowBattery': lowBattery,
    };
  }

  /// Carrega todas as tags (sem paginação)
  /// GET /api/tags
  Future<void> loadAllTags() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.getAllTags();
      if (response.isSuccess && response.data != null) {
        _tags = response.data!;
      } else {
        _error = response.errorMessage ?? 'Erro ao carregar tags';
      }
    } catch (e) {
      _error = 'Erro ao carregar tags: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Carrega tags de uma loja específica
  /// GET /api/tags/store/:storeId
  Future<void> loadTagsByStore(String storeId) async {
    _isLoading = true;
    _error = null;
    _currentStoreId = storeId;
    notifyListeners();

    try {
      final response = await _repository.getTagsByStore(storeId);
      if (response.isSuccess && response.data != null) {
        _tags = response.data!;
      } else {
        _error = response.errorMessage ?? 'Erro ao carregar tags da loja';
      }
    } catch (e) {
      _error = 'Erro ao carregar tags: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Carrega tags com paginação
  /// GET /api/tags/store/:storeId/paged
  Future<void> loadTagsPaged({
    required String storeId,
    bool refresh = false,
    String? search,
    String? status,
    int? type,
    bool? isBound,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasMorePages = true;
    }

    if (!_hasMorePages && !refresh) return;

    _isLoading = true;
    _error = null;
    _currentStoreId = storeId;
    notifyListeners();

    try {
      final response = await _repository.getTagsPaged(
        storeId: storeId,
        page: _currentPage,
        size: _pageSize,
        search: search,
        status: status,
        type: type,
        isBound: isBound,
      );

      if (response.isSuccess && response.data != null) {
        final pagedResponse = response.data!;
        
        if (refresh) {
          _tags = pagedResponse.items;
        } else {
          _tags.addAll(pagedResponse.items);
        }
        
        _totalCount = pagedResponse.totalCount;
        _totalPages = pagedResponse.totalPages;
        _hasMorePages = _currentPage < _totalPages;
        
        if (_hasMorePages) _currentPage++;
      } else {
        _error = response.errorMessage ?? 'Erro ao carregar tags';
      }
    } catch (e) {
      _error = 'Erro ao carregar tags: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Busca tag por MAC address
  /// GET /api/tags/:macAddress
  Future<TagModel?> getTagByMac(String macAddress) async {
    try {
      final response = await _repository.getTagByMac(macAddress);
      if (response.isSuccess && response.data != null) {
        return response.data;
      }
      _error = response.errorMessage ?? 'Tag não encontrada';
      notifyListeners();
      return null;
    } catch (e) {
      _error = 'Erro ao buscar tag: $e';
      notifyListeners();
      return null;
    }
  }

  /// Cria uma nova tag
  /// POST /api/tags
  Future<bool> createTag({
    required String macAddress,
    required String storeId,
    int type = 0,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = CreateTagRequest(
        macAddress: macAddress,
        storeId: storeId,
        type: type,
      );

      final response = await _repository.createTag(request);
      
      if (response.isSuccess && response.data != null) {
        _tags.insert(0, response.data!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.errorMessage ?? 'Erro ao criar tag';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erro ao criar tag: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Adiciona tags em lote
  /// POST /api/tags/batch
  Future<BatchOperationResult?> batchAddTags({
    required String storeId,
    required List<String> macAddresses,
    int type = 0,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = BatchAddTagsRequest(
        storeId: storeId,
        macAddresses: macAddresses,
        type: type,
      );

      final response = await _repository.batchAddTags(request);
      
      if (response.isSuccess && response.data != null) {
        // Recarrega a lista
        await loadTagsByStore(storeId);
        return response.data;
      } else {
        _error = response.errorMessage ?? 'Erro ao adicionar tags em lote';
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = 'Erro ao adicionar tags: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Vincula tag a produto
  /// POST /api/tags/:macAddress/bind
  Future<bool> bindTag(String macAddress, String productId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = BindTagRequest(productId: productId);
      final response = await _repository.bindTag(macAddress, request);
      
      if (response.isSuccess && response.data != null) {
        // Atualiza localmente
        final index = _tags.indexWhere((t) => t.macAddress == macAddress);
        if (index >= 0) {
          _tags[index] = response.data!;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.errorMessage ?? 'Erro ao vincular tag';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erro ao vincular tag: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Desvincula tag de produto
  /// POST /api/tags/:macAddress/unbind
  Future<bool> unbindTag(String macAddress) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.unbindTag(macAddress);
      
      if (response.isSuccess && response.data != null) {
        // Atualiza localmente
        final index = _tags.indexWhere((t) => t.macAddress == macAddress);
        if (index >= 0) {
          _tags[index] = response.data!;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.errorMessage ?? 'Erro ao desvincular tag';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erro ao desvincular tag: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Vincula tags em lote
  /// POST /api/tags/batch/bind
  Future<BatchOperationResult?> batchBindTags({
    required String storeId,
    required List<TagProductBinding> bindings,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = BatchBindTagsRequest(
        storeId: storeId,
        bindings: bindings,
      );

      final response = await _repository.batchBindTags(request);
      
      if (response.isSuccess && response.data != null) {
        // Recarrega a lista
        await loadTagsByStore(storeId);
        return response.data;
      } else {
        _error = response.errorMessage ?? 'Erro na vinculação em lote';
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = 'Erro na vinculação em lote: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Aciona flash da tag
  /// POST /api/tags/:macAddress/flash
  Future<bool> flashTag(
    String macAddress, {
    String color = 'green',
    int durationSeconds = 5,
  }) async {
    try {
      final response = await _repository.flashTag(
        macAddress,
        color: color,
        durationSeconds: durationSeconds,
      );
      
      if (response.isSuccess) {
        return true;
      } else {
        _error = response.errorMessage ?? 'Erro ao acionar flash';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erro ao acionar flash: $e';
      notifyListeners();
      return false;
    }
  }

  /// Atualiza display da tag
  /// POST /api/tags/:macAddress/refresh
  Future<bool> refreshTag(String macAddress) async {
    try {
      final response = await _repository.refreshTag(macAddress);
      
      if (response.isSuccess) {
        return true;
      } else {
        _error = response.errorMessage ?? 'Erro ao atualizar display';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erro ao atualizar display: $e';
      notifyListeners();
      return false;
    }
  }

  /// Sincroniza tags com Minew
  /// POST /api/tags/store/:storeId/sync
  Future<BatchOperationResult?> syncTags(String storeId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.syncTags(storeId);
      
      if (response.isSuccess && response.data != null) {
        // Recarrega a lista
        await loadTagsByStore(storeId);
        return response.data;
      } else {
        _error = response.errorMessage ?? 'Erro ao sincronizar tags';
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = 'Erro ao sincronizar tags: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Exclui uma tag
  /// DELETE /api/tags/:macAddress
  Future<bool> deleteTag(String macAddress) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.deleteTag(macAddress);
      
      if (response.isSuccess) {
        _tags.removeWhere((t) => t.macAddress == macAddress);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.errorMessage ?? 'Erro ao excluir tag';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erro ao excluir tag: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Filtra tags localmente
  List<TagModel> filterTags({
    String? search,
    TagStatus? status,
    TagType? type,
    bool? isBound,
  }) {
    return _tags.where((tag) {
      // Filtro por busca
      final matchSearch = search == null ||
          search.isEmpty ||
          tag.macAddress.toLowerCase().contains(search.toLowerCase()) ||
          (tag.productName?.toLowerCase().contains(search.toLowerCase()) ?? false);

      // Filtro por status
      final matchStatus = status == null || tag.status == status;

      // Filtro por tipo
      final matchType = type == null || tag.type == type;

      // Filtro por vinculação
      final matchBound = isBound == null || tag.isBound == isBound;

      return matchSearch && matchStatus && matchType && matchBound;
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

// =============================================================================
// RIVERPOD PROVIDERS
// =============================================================================

/// Estado para o TagsNotifier
class TagsState {
  final List<TagModel> tags;
  final bool isLoading;
  final String? error;
  final String? currentStoreId;

  const TagsState({
    this.tags = const [],
    this.isLoading = false,
    this.error,
    this.currentStoreId,
  });

  TagsState copyWith({
    List<TagModel>? tags,
    bool? isLoading,
    String? error,
    String? currentStoreId,
  }) {
    return TagsState(
      tags: tags ?? this.tags,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentStoreId: currentStoreId ?? this.currentStoreId,
    );
  }
  
  /// Método when para simular o padrão AsyncValue
  /// Permite usar state.when(loading:, error:, data:)
  T when<T>({
    required T Function() loading,
    required T Function(String error, StackTrace? stack) error,
    required T Function(List<TagModel> tags) data,
  }) {
    if (isLoading) {
      return loading();
    }
    if (this.error != null) {
      return error(this.error!, null);
    }
    return data(tags);
  }
}

/// StateNotifier para gerenciamento de tags com Riverpod
class TagsNotifier extends StateNotifier<TagsState> {
  final TagsRepository _repository;
  int _currentPage = 1;
  int _pageSize = 50;
  int _totalCount = 0;
  int _totalPages = 0;
  bool _hasMorePages = true;

  TagsNotifier(this._repository) : super(const TagsState());

  // Getters para paginação
  int get currentPage => _currentPage;
  int get totalCount => _totalCount;
  int get totalPages => _totalPages;
  bool get hasMorePages => _hasMorePages;

  /// Estatísticas das tags
  Map<String, int> get stats {
    final total = state.tags.length;
    final online = state.tags.where((t) => t.isOnline).length;
    final bound = state.tags.where((t) => t.isBound).length;
    final lowBattery = state.tags.where((t) => t.isLowBattery).length;

    return {
      'total': total,
      'online': online,
      'offline': total - online,
      'bound': bound,
      'available': total - bound,
      'lowBattery': lowBattery,
    };
  }

  /// Carrega todas as tags (sem paginação)
  /// GET /api/tags
  Future<void> loadAllTags() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.getAllTags();
      if (response.isSuccess && response.data != null) {
        state = state.copyWith(tags: response.data!, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Erro ao carregar tags',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao carregar tags: $e');
    }
  }

  /// Carrega tags por loja
  Future<void> loadTagsByStore(String storeId) async {
    state = state.copyWith(isLoading: true, error: null, currentStoreId: storeId);

    try {
      final response = await _repository.getTagsByStore(storeId);
      if (response.isSuccess && response.data != null) {
        state = state.copyWith(tags: response.data!, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Erro ao carregar tags',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro: $e');
    }
  }

  /// Carrega tags com paginação
  /// GET /api/tags/store/:storeId/paged
  Future<void> loadTagsPaged({
    required String storeId,
    bool refresh = false,
    String? search,
    String? status,
    int? type,
    bool? isBound,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasMorePages = true;
    }

    if (!_hasMorePages && !refresh) return;

    state = state.copyWith(isLoading: true, error: null, currentStoreId: storeId);

    try {
      final response = await _repository.getTagsPaged(
        storeId: storeId,
        page: _currentPage,
        size: _pageSize,
        search: search,
        status: status,
        type: type,
        isBound: isBound,
      );

      if (response.isSuccess && response.data != null) {
        final pagedResponse = response.data!;
        
        List<TagModel> updatedTags;
        if (refresh) {
          updatedTags = pagedResponse.items;
        } else {
          updatedTags = [...state.tags, ...pagedResponse.items];
        }
        
        _totalCount = pagedResponse.totalCount;
        _totalPages = pagedResponse.totalPages;
        _hasMorePages = _currentPage < _totalPages;
        
        if (_hasMorePages) _currentPage++;
        
        state = state.copyWith(tags: updatedTags, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Erro ao carregar tags',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao carregar tags: $e');
    }
  }

  /// Busca tag por MAC address
  /// GET /api/tags/:macAddress
  Future<TagModel?> getTagByMac(String macAddress) async {
    try {
      final response = await _repository.getTagByMac(macAddress);
      if (response.isSuccess && response.data != null) {
        return response.data;
      }
      state = state.copyWith(error: response.errorMessage ?? 'Tag não encontrada');
      return null;
    } catch (e) {
      state = state.copyWith(error: 'Erro ao buscar tag: $e');
      return null;
    }
  }

  /// Cria uma nova tag
  /// POST /api/tags
  Future<bool> createTag({
    required String macAddress,
    required String storeId,
    int type = 0,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = CreateTagRequest(
        macAddress: macAddress,
        storeId: storeId,
        type: type,
      );

      final response = await _repository.createTag(request);
      
      if (response.isSuccess && response.data != null) {
        final updatedTags = [response.data!, ...state.tags];
        state = state.copyWith(tags: updatedTags, isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Erro ao criar tag',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao criar tag: $e');
      return false;
    }
  }

  /// Adiciona tags em lote
  /// POST /api/tags/batch
  Future<BatchOperationResult?> batchAddTags({
    required String storeId,
    required List<String> macAddresses,
    int type = 0,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = BatchAddTagsRequest(
        storeId: storeId,
        macAddresses: macAddresses,
        type: type,
      );

      final response = await _repository.batchAddTags(request);
      
      if (response.isSuccess && response.data != null) {
        // Recarrega a lista
        await loadTagsByStore(storeId);
        return response.data;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Erro ao adicionar tags em lote',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao adicionar tags: $e');
      return null;
    }
  }

  /// Recarrega tags atuais
  Future<void> refresh() async {
    if (state.currentStoreId != null) {
      await loadTagsByStore(state.currentStoreId!);
    }
  }

  /// Vincula tag a produto
  /// POST /api/tags/:macAddress/bind
  Future<bool> bindTag(String macAddress, String productId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = BindTagRequest(productId: productId);
      final response = await _repository.bindTag(macAddress, request);
      
      if (response.isSuccess && response.data != null) {
        // Atualiza localmente
        final updatedTags = state.tags.map((t) {
          if (t.macAddress == macAddress) {
            return response.data!;
          }
          return t;
        }).toList();
        
        state = state.copyWith(tags: updatedTags, isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Erro ao vincular tag',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao vincular tag: $e');
      return false;
    }
  }

  /// Desvincula tag de produto
  /// POST /api/tags/:macAddress/unbind
  Future<bool> unbindTag(String macAddress) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.unbindTag(macAddress);
      
      if (response.isSuccess && response.data != null) {
        // Atualiza localmente
        final updatedTags = state.tags.map((t) {
          if (t.macAddress == macAddress) {
            return response.data!;
          }
          return t;
        }).toList();
        
        state = state.copyWith(tags: updatedTags, isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Erro ao desvincular tag',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao desvincular tag: $e');
      return false;
    }
  }

  /// Vincula tags em lote
  /// POST /api/tags/batch/bind
  Future<BatchOperationResult?> batchBindTags({
    required String storeId,
    required List<TagProductBinding> bindings,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = BatchBindTagsRequest(
        storeId: storeId,
        bindings: bindings,
      );

      final response = await _repository.batchBindTags(request);
      
      if (response.isSuccess && response.data != null) {
        // Recarrega a lista
        await loadTagsByStore(storeId);
        return response.data;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Erro na vinculação em lote',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro na vinculação em lote: $e');
      return null;
    }
  }

  /// Desvincula tags em lote
  /// POST /api/tags/batch/unbind
  Future<BatchOperationResult?> batchUnbindTags({
    required String storeId,
    required List<String> macAddresses,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.batchUnbindTags(
        storeId: storeId,
        macAddresses: macAddresses,
      );
      
      if (response.isSuccess && response.data != null) {
        // Recarrega a lista
        await loadTagsByStore(storeId);
        return response.data;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Erro ao desvincular tags em lote',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao desvincular tags: $e');
      return null;
    }
  }

  /// Aciona flash da tag
  /// POST /api/tags/:macAddress/flash
  Future<bool> flashTag(
    String macAddress, {
    String color = 'green',
    int durationSeconds = 5,
  }) async {
    try {
      final response = await _repository.flashTag(
        macAddress,
        color: color,
        durationSeconds: durationSeconds,
      );
      
      if (response.isSuccess) {
        return true;
      } else {
        state = state.copyWith(error: response.errorMessage ?? 'Erro ao acionar flash');
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: 'Erro ao acionar flash: $e');
      return false;
    }
  }

  /// Atualiza display da tag
  /// POST /api/tags/:macAddress/refresh
  Future<bool> refreshTag(String macAddress) async {
    try {
      final response = await _repository.refreshTag(macAddress);
      
      if (response.isSuccess) {
        return true;
      } else {
        state = state.copyWith(error: response.errorMessage ?? 'Erro ao atualizar display');
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: 'Erro ao atualizar display: $e');
      return false;
    }
  }

  /// Atualiza displays em lote
  /// POST /api/tags/batch/refresh
  Future<BatchOperationResult?> batchRefreshTags({
    required String storeId,
    required List<String> macAddresses,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.batchRefreshTags(
        storeId: storeId,
        macAddresses: macAddresses,
      );
      
      if (response.isSuccess && response.data != null) {
        state = state.copyWith(isLoading: false);
        return response.data;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Erro ao atualizar displays',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao atualizar displays: $e');
      return null;
    }
  }

  /// Sincroniza tags com Minew
  /// POST /api/tags/store/:storeId/sync
  Future<BatchOperationResult?> syncTags(String storeId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.syncTags(storeId);
      
      if (response.isSuccess && response.data != null) {
        // Recarrega a lista
        await loadTagsByStore(storeId);
        return response.data;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Erro ao sincronizar tags',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao sincronizar tags: $e');
      return null;
    }
  }

  /// Exclui uma tag
  /// DELETE /api/tags/:macAddress
  Future<bool> deleteTag(String macAddress) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.deleteTag(macAddress);
      
      if (response.isSuccess) {
        final updatedTags = state.tags.where((t) => t.macAddress != macAddress).toList();
        state = state.copyWith(tags: updatedTags, isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Erro ao excluir tag',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao excluir tag: $e');
      return false;
    }
  }

  /// Exclui tags em lote
  /// DELETE /api/tags/batch
  Future<BatchOperationResult?> batchDeleteTags({
    required String storeId,
    required List<String> macAddresses,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.batchDeleteTags(
        storeId: storeId,
        macAddresses: macAddresses,
      );
      
      if (response.isSuccess && response.data != null) {
        // Recarrega a lista
        await loadTagsByStore(storeId);
        return response.data;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Erro ao excluir tags',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao excluir tags: $e');
      return null;
    }
  }

  /// Atualiza uma tag
  /// PUT /api/tags/:macAddress
  Future<bool> updateTag(String macAddress, UpdateTagDto dto) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.updateTag(macAddress, dto);
      
      if (response.isSuccess && response.data != null) {
        final updatedTags = state.tags.map((t) {
          if (t.macAddress == macAddress) {
            return response.data!;
          }
          return t;
        }).toList();
        
        state = state.copyWith(tags: updatedTags, isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Erro ao atualizar tag',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao atualizar tag: $e');
      return false;
    }
  }

  /// Filtra tags localmente
  List<TagModel> filterTags({
    String? search,
    TagStatus? status,
    TagType? type,
    bool? isBound,
  }) {
    return state.tags.where((tag) {
      // Filtro por busca
      final matchSearch = search == null ||
          search.isEmpty ||
          tag.macAddress.toLowerCase().contains(search.toLowerCase()) ||
          (tag.productName?.toLowerCase().contains(search.toLowerCase()) ?? false);

      // Filtro por status
      final matchStatus = status == null || tag.status == status;

      // Filtro por tipo
      final matchType = type == null || tag.type == type;

      // Filtro por vinculação
      final matchBound = isBound == null || tag.isBound == isBound;

      return matchSearch && matchStatus && matchType && matchBound;
    }).toList();
  }

  /// Limpa o erro atual
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider do TagsNotifier
final tagsNotifierProvider = StateNotifierProvider<TagsNotifier, TagsState>((ref) {
  final repository = TagsRepository();
  return TagsNotifier(repository);
});

/// Provider para estatísticas de tags
final tagStatsProvider = FutureProvider.family<TagStats?, String>((ref, storeId) async {
  final repository = TagsRepository();
  final response = await repository.getTagStats(storeId);
  return response.isSuccess ? response.data : null;
});

/// Provider para histórico de importações
final tagImportHistoryProvider = FutureProvider.family<List<TagImportHistory>, String>((ref, storeId) async {
  final repository = TagsRepository();
  final response = await repository.getImportHistory(storeId: storeId);
  return response.isSuccess ? response.data ?? [] : [];
});

/// Alias para compatibilidade (alguns arquivos usam 'tagsImportHistoryProvider')
final tagsImportHistoryProvider = tagImportHistoryProvider;

// =============================================================================
// IMPORT TAGS PROVIDER
// =============================================================================

/// Estado para a importação de tags
class TagsImportState {
  final bool isImporting;
  final double progress;
  final String? error;
  final TagImportResult? result;

  const TagsImportState({
    this.isImporting = false,
    this.progress = 0.0,
    this.error,
    this.result,
  });

  TagsImportState copyWith({
    bool? isImporting,
    double? progress,
    String? error,
    TagImportResult? result,
  }) {
    return TagsImportState(
      isImporting: isImporting ?? this.isImporting,
      progress: progress ?? this.progress,
      error: error,
      result: result ?? this.result,
    );
  }
}

/// StateNotifier para gerenciamento de importação de tags
class TagsImportNotifier extends StateNotifier<TagsImportState> {
  final TagsRepository _repository;

  TagsImportNotifier(this._repository) : super(const TagsImportState());

  /// Importa tags a partir de uma lista de items
  Future<TagImportResult?> importTags({
    required String storeId,
    required List<TagImportItem> items,
    String format = 'csv',
    bool overwriteExisting = false,
    bool validateBeforeImport = true,
  }) async {
    state = state.copyWith(isImporting: true, progress: 0.0, error: null, result: null);

    try {
      // Simular progresso de upload (0-50%)
      state = state.copyWith(progress: 0.25);
      
      final response = await _repository.importTags(
        storeId: storeId,
        items: items,
        format: format,
        overwriteExisting: overwriteExisting,
        validateBeforeImport: validateBeforeImport,
      );

      state = state.copyWith(progress: 0.75);

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          isImporting: false,
          progress: 1.0,
          result: response.data,
        );
        return response.data;
      } else {
        state = state.copyWith(
          isImporting: false,
          error: response.errorMessage ?? 'Erro ao importar tags',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        isImporting: false,
        error: 'Erro: $e',
      );
      return null;
    }
  }

  /// Limpa o estado da importação
  void reset() {
    state = const TagsImportState();
  }
}

/// Provider do TagsImportNotifier
final tagsImportNotifierProvider = StateNotifierProvider<TagsImportNotifier, TagsImportState>((ref) {
  final repository = TagsRepository();
  return TagsImportNotifier(repository);
});




