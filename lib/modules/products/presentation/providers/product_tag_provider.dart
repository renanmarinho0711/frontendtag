import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/products/data/models/product_tag_model.dart';
import 'package:tagbean/features/products/data/services/product_tag_service.dart';

/// Provider para o serviço de ProductTag
/// O token será obtido pelo ApiClient automaticamente
final productTagServiceProvider = Provider<ProductTagService>((ref) {
  return ProductTagService();
});

/// Estado das vinculações produto-tag
class ProductTagState {
  final bool isLoading;
  final String? error;
  final List<ProductTagModel> bindings;
  final ProductTagsList? currentProductTags;
  final List<PriceSyncResult> lastSyncResults;

  ProductTagState({
    this.isLoading = false,
    this.error,
    this.bindings = const [],
    this.currentProductTags,
    this.lastSyncResults = const [],
  });

  ProductTagState copyWith({
    bool? isLoading,
    String? error,
    List<ProductTagModel>? bindings,
    ProductTagsList? currentProductTags,
    List<PriceSyncResult>? lastSyncResults,
  }) {
    return ProductTagState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      bindings: bindings ?? this.bindings,
      currentProductTags: currentProductTags ?? this.currentProductTags,
      lastSyncResults: lastSyncResults ?? this.lastSyncResults,
    );
  }
}

/// Notifier para gerenciar estado de vinculações
class ProductTagNotifier extends StateNotifier<ProductTagState> {
  final ProductTagService _service;

  ProductTagNotifier(this._service) : super(ProductTagState());

  /// Carrega tags vinculadas a um produto
  Future<void> loadTagsByProduct(String productId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _service.getTagsByProduct(productId);
      state = state.copyWith(
        isLoading: false,
        currentProductTags: result,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Carrega todas as vinculações de uma loja
  Future<void> loadByStore(String storeId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _service.getByStore(storeId);
      state = state.copyWith(
        isLoading: false,
        bindings: result,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Cria uma nova vinculação
  Future<ProductTagModel?> createBinding(String storeId, CreateProductTagDto dto) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _service.create(storeId, dto);
      state = state.copyWith(
        isLoading: false,
        bindings: [...state.bindings, result],
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Remove uma vinculação
  Future<bool> deleteBinding(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final success = await _service.delete(id);
      if (success) {
        state = state.copyWith(
          isLoading: false,
          bindings: state.bindings.where((b) => b.id != id).toList(),
        );
      }
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Sincroniza preço para TODAS as tags de um produto
  /// Chamado automaticamente quando o preço do produto é alterado
  Future<List<PriceSyncResult>> syncPriceToAllTags(String productId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final results = await _service.syncPriceToAllTags(productId);
      state = state.copyWith(
        isLoading: false,
        lastSyncResults: results,
      );
      return results;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return [];
    }
  }

  /// Vincula múltiplas tags a um produto
  Future<List<ProductTagModel>> linkMultipleTags(
    String storeId,
    String productId,
    List<String> tagMacAddresses,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final results = await _service.linkMultipleTags(storeId, productId, tagMacAddresses);
      state = state.copyWith(
        isLoading: false,
        bindings: [...state.bindings, ...results],
      );
      return results;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return [];
    }
  }

  /// Limpa erro
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider principal para ProductTag
final productTagProvider = StateNotifierProvider<ProductTagNotifier, ProductTagState>((ref) {
  final service = ref.watch(productTagServiceProvider);
  return ProductTagNotifier(service);
});

/// Provider para tags de um produto específico
final productTagsProvider = FutureProvider.family<ProductTagsList?, String>((ref, productId) async {
  final service = ref.watch(productTagServiceProvider);
  return service.getTagsByProduct(productId);
});


