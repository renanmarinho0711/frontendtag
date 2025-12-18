import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tagbean/core/enums/loading_status.dart';

import 'package:tagbean/features/products/data/models/product_models.dart';

import 'package:tagbean/features/products/data/repositories/products_repository.dart';

import 'package:tagbean/features/tags/data/repositories/tags_repository.dart';

import 'package:tagbean/features/tags/data/models/tag_model.dart';

import 'package:tagbean/design_system/design_system.dart';




// =============================================================================

// TYPE ALIASES FOR BACKWARD COMPATIBILITY

// =============================================================================



/// Alias para StockItem (compatibilidade)

typedef StockItemModel = StockItem;



// Nota: PriceHistoryItem e PriceHistoryModel s�o definidos em product_models.dart

// O import j� traz essas defini��es, ent�o n�o precisamos redefinir aqui



// =============================================================================

// PRODUCTS LIST STATE

// =============================================================================



class ProductsListState {

  final LoadingStatus status;

  final List<ProductModel> products;

  final String searchQuery;

  final String filterCategoria;

  final String filterStatus;

  final int currentPage;

  final int totalPages;

  final int totalItems;

  final bool hasMorePages;

  final String? error;



  const ProductsListState({

    this.status = LoadingStatus.initial,

    this.products = const [],

    this.searchQuery = '',

    this.filterCategoria = 'Todas',

    this.filterStatus = 'Todos',

    this.currentPage = 1,

    this.totalPages = 1,

    this.totalItems = 0,

    this.hasMorePages = false,

    this.error,

  });



  List<ProductModel> get filteredProducts {

    return products.where((product) {

      final matchesSearch = searchQuery.isEmpty ||

          product.nome.toLowerCase().contains(searchQuery.toLowerCase()) ||

          product.codigo.toLowerCase().contains(searchQuery.toLowerCase());



      final matchesCategoria = filterCategoria == 'Todas' ||

          product.categoria == filterCategoria;



      final matchesStatus = filterStatus == 'Todos' ||

          product.status.label == filterStatus;



      return matchesSearch && matchesCategoria && matchesStatus;

    }).toList();

  }



  int get produtosComTag => products.where((p) => p.hasTag).length;

  int get produtosSemTag => products.where((p) => !p.hasTag).length;

  int get produtosAtivos => products.where((p) => p.status == ProductStatus.ativo).length;

  int get produtosInativos => products.where((p) => p.status == ProductStatus.inativo).length;



  ProductsListState copyWith({

    LoadingStatus? status,

    List<ProductModel>? products,

    String? searchQuery,

    String? filterCategoria,

    String? filterStatus,

    int? currentPage,

    int? totalPages,

    int? totalItems,

    bool? hasMorePages,

    String? error,

  }) {

    return ProductsListState(

      status: status ?? this.status,

      products: products ?? this.products,

      searchQuery: searchQuery ?? this.searchQuery,

      filterCategoria: filterCategoria ?? this.filterCategoria,

      filterStatus: filterStatus ?? this.filterStatus,

      currentPage: currentPage ?? this.currentPage,

      totalPages: totalPages ?? this.totalPages,

      totalItems: totalItems ?? this.totalItems,

      hasMorePages: hasMorePages ?? this.hasMorePages,

      error: error ?? this.error,

    );

  }



  factory ProductsListState.initial() => const ProductsListState();

}



class ProductsListNotifier extends StateNotifier<ProductsListState> {

  final ProdutoRepository? _repository;

  static const int _pageSize = 20;

  

  ProductsListNotifier([this._repository]) : super(ProductsListState.initial());



  /// Carrega produtos do backend

  /// GET /api/products

  Future<void> loadProducts({bool refresh = false}) async {

    if (refresh) {

      state = state.copyWith(

        status: LoadingStatus.loading,

        currentPage: 1,

        hasMorePages: true,

      );

    } else {

      state = state.copyWith(status: LoadingStatus.loading);

    }



    try {

      if (_repository != null) {

        final response = await _repository!.listarProdutos(

          page: state.currentPage,

          pageSize: _pageSize,

          search: state.searchQuery.isNotEmpty ? state.searchQuery : null,

          categoriaId: state.filterCategoria != 'Todas' ? state.filterCategoria : null,

          ativo: state.filterStatus == 'Ativos' ? true : 

                 state.filterStatus == 'Inativos' ? false : null,

        );



        if (response.isSuccess && response.data != null) {

          final newProducts = response.data!.map((p) => ProductModel.fromProduto(p)).toList();

          

          state = state.copyWith(

            status: LoadingStatus.success,

            products: refresh ? newProducts : [...state.products, ...newProducts],

            hasMorePages: newProducts.length >= _pageSize,

            currentPage: state.currentPage + 1,

            totalItems: state.products.length + newProducts.length,

          );

        } else {

          state = state.copyWith(

            status: LoadingStatus.error,

            error: response.errorMessage ?? 'Erro ao carregar produtos',

          );

        }

      } else {

        // Reposit�rio n�o dispon�vel - mostrar erro

        state = state.copyWith(

          status: LoadingStatus.error,

          error: 'Reposit�rio de produtos n�o configurado',

        );

      }

    } catch (e) {

      state = state.copyWith(

        status: LoadingStatus.error,

        error: 'Erro ao carregar produtos: $e',

      );

    }

  }



  /// Carrega mais produtos (pagina��o)

  Future<void> loadMoreProducts() async {

    if (!state.hasMorePages || state.status == LoadingStatus.loading) return;

    await loadProducts();

  }



  void setSearchQuery(String query) {

    state = state.copyWith(searchQuery: query);

  }



  void setFilterCategoria(String categoria) {

    state = state.copyWith(filterCategoria: categoria);

  }



  void setFilterStatus(String status) {

    state = state.copyWith(filterStatus: status);

  }



  void clearFilters() {

    state = state.copyWith(

      searchQuery: '',

      filterCategoria: 'Todas',

      filterStatus: 'Todos',

    );

  }



  Future<bool> deleteProduct(String productId) async {

    try {

      if (_repository != null) {

        final response = await _repository!.excluirProduto(productId);

        if (response.isSuccess) {

          final updatedProducts = state.products.where((p) => p.id != productId).toList();

          state = state.copyWith(

            products: updatedProducts,

            totalItems: updatedProducts.length,

          );

          return true;

        }

        state = state.copyWith(error: response.errorMessage);

        return false;

      } else {

        // Local delete

        final updatedProducts = state.products.where((p) => p.id != productId).toList();

        state = state.copyWith(

          products: updatedProducts,

          totalItems: updatedProducts.length,

        );

        return true;

      }

    } catch (e) {

      state = state.copyWith(error: 'Erro ao excluir: $e');

      return false;

    }

  }



  Future<bool> updateProduct(ProductModel product) async {

    try {

      if (_repository != null) {

        final response = await _repository!.atualizarProduto(

          id: product.id,

          codigo: product.codigo,

          nome: product.nome,

          preco: product.preco,

        );

        if (response.isSuccess) {

          final index = state.products.indexWhere((p) => p.id == product.id);

          if (index != -1) {

            final updatedProducts = List<ProductModel>.from(state.products);

            updatedProducts[index] = product;

            state = state.copyWith(products: updatedProducts);

          }

          return true;

        }

        state = state.copyWith(error: response.errorMessage);

        return false;

      } else {

        // Local update

        final index = state.products.indexWhere((p) => p.id == product.id);

        if (index != -1) {

          final updatedProducts = List<ProductModel>.from(state.products);

          updatedProducts[index] = product;

          state = state.copyWith(products: updatedProducts);

        }

        return true;

      }

    } catch (e) {

      state = state.copyWith(error: 'Erro ao atualizar: $e');

      return false;

    }

  }



  Future<ProductModel?> addProduct(ProductModel product, {required String storeId}) async {

    try {

      if (_repository != null) {

        final response = await _repository!.criarProduto(

          storeId: storeId,

          codigo: product.codigo,

          nome: product.nome,

          preco: product.preco,

          categoriaId: product.categoria,

          ativo: product.status == ProductStatus.ativo,

        );

        if (response.isSuccess && response.data != null) {

          final newProduct = ProductModel.fromProduto(response.data!);

          state = state.copyWith(

            products: [newProduct, ...state.products],

            totalItems: state.totalItems + 1,

          );

          return newProduct;

        }

        state = state.copyWith(error: response.errorMessage);

        return null;

      } else {

        // Local add

        final newProduct = product.copyWith(

          id: DateTime.now().millisecondsSinceEpoch.toString(),

        );

        state = state.copyWith(

          products: [newProduct, ...state.products],

          totalItems: state.totalItems + 1,

        );

        return newProduct;

      }

    } catch (e) {

      state = state.copyWith(error: 'Erro ao adicionar: $e');

      return null;

    }

  }



  /// Exclui m�ltiplos produtos em lote

  Future<int> deleteProductsInBatch(List<String> productIds) async {

    if (productIds.isEmpty) return 0;

    

    try {

      if (_repository != null) {

        final response = await _repository!.excluirEmLote(produtoIds: productIds);

        if (response.isSuccess) {

          final deletedCount = (response.data?['deletedCount'] as int?) ?? productIds.length;

          final updatedProducts = state.products

              .where((p) => !productIds.contains(p.id.toString()))

              .toList();

          state = state.copyWith(

            products: updatedProducts,

            totalItems: updatedProducts.length,

          );

          return deletedCount;

        }

        state = state.copyWith(error: response.errorMessage);

        return 0;

      } else {

        // Local delete

        final updatedProducts = state.products

            .where((p) => !productIds.contains(p.id.toString()))

            .toList();

        // ignore: argument_type_not_assignable
        state = state.copyWith(
 // ignore: argument_type_not_assignable

          // ignore: argument_type_not_assignable
          products: updatedProducts,
 // ignore: argument_type_not_assignable

          // ignore: argument_type_not_assignable
          totalItems: updatedProducts.length,
 // ignore: argument_type_not_assignable

        // ignore: argument_type_not_assignable
        );
 // ignore: argument_type_not_assignable

        // ignore: argument_type_not_assignable
        return productIds.length;

      }

    } catch (e.toDouble() ?? 0.0) {
 // ignore: argument_type_not_assignable

      // ignore: argument_type_not_assignable
      state = state.copyWith(error: 'Erro ao excluir em lote: $e');
 // ignore: argument_type_not_assignable

      return 0;

    }

  }



  /// Atualiza pre�os em lote

  // ignore: argument_type_not_assignable
  /// PUT /api/products/batch (ATUALIZADO para usar novo endpoint consolidado)
 // ignore: argument_type_not_assignable

  // ignore: argument_type_not_assignable
  Future<bool> updatePricesInBatch({
 // ignore: argument_type_not_assignable

    // ignore: argument_type_not_assignable
    required List<String> productIds,
 // ignore: argument_type_not_assignable

    double? fixedPrice,

    double? percentageIncrease,

    double? percentageDecrease,

    String? storeId,

  }) async {

    if (productIds.isEmpty) return false;

    

    try {

      if (_repository != null) {

        if (storeId == null || storeId.isEmpty) {

          state = state.copyWith(error: 'StoreId � obrigat�rio para opera��es em lote');

          return false;

        }

        // Usa o novo endpoint consolidado

        final response = await _repository!.atualizarProdutosEmLote(

          storeId: storeId,

          produtoIds: productIds,

          precoFixo: fixedPrice,

          percentualAumento: percentageIncrease,

          percentualDesconto: percentageDecrease,

        );

        if (response.isSuccess) {

          // Recarrega produtos para ter os pre�os atualizados

          await loadProducts(refresh: true);

          return true;

        }

        state = state.copyWith(error: response.errorMessage);

        return false;

      } else {

        // Local update

        final updatedProducts = state.products.map((p) {

          if (!productIds.contains(p.id.toString())) return p;

          

          double newPrice = p.preco;

          if (fixedPrice != null) {

            newPrice = fixedPrice;

          } else if (percentageIncrease != null) {

            newPrice = p.preco * (1 + percentageIncrease / 100);

          } else if (percentageDecrease != null) {

            newPrice = p.preco * (1 - percentageDecrease / 100);

          }

          return p.copyWith(preco: newPrice);

        }).toList();

        

        state = state.copyWith(products: updatedProducts);

        return true;

      }

    } catch (e) {

      state = state.copyWith(error: 'Erro ao atualizar pre�os: $e');

      return false;

    }

  }



  /// Atualiza categoria em lote

  /// PUT /api/products/batch (ATUALIZADO para usar novo endpoint consolidado)

  Future<bool> updateCategoryInBatch({

    required List<String> productIds,

    required String categoriaId,

    String? storeId,

  }) async {

    if (productIds.isEmpty) return false;

    

    try {

      if (_repository != null) {

        if (storeId == null || storeId.isEmpty) {

          state = state.copyWith(error: 'StoreId � obrigat�rio para opera��es em lote');

          return false;

        }

        // Usa o novo endpoint consolidado

        final response = await _repository!.atualizarProdutosEmLote(

          storeId: storeId,

          produtoIds: productIds,

          categoriaId: categoriaId,

        );

        if (response.isSuccess) {

          // Recarrega produtos para ter as categorias atualizadas

          await loadProducts(refresh: true);

          return true;

        }

        state = state.copyWith(error: response.errorMessage);

        return false;

      } else {

        // Local update

        final updatedProducts = state.products.map((p) {

          if (!productIds.contains(p.id.toString())) return p;

          return p.copyWith(categoria: categoriaId);

        }).toList();

        

        state = state.copyWith(products: updatedProducts);

        return true;

      }

    } catch (e) {

      state = state.copyWith(error: 'Erro ao atualizar categoria: $e');

      return false;

    }

  }



  /// Atualiza status (ativo/inativo) em lote

  /// PUT /api/products/batch

  Future<bool> updateStatusInBatch({

    required List<String> productIds,

    required bool ativo,

    String? storeId,

  }) async {

    if (productIds.isEmpty) return false;

    

    try {

      if (_repository != null) {

        if (storeId == null || storeId.isEmpty) {

          state = state.copyWith(error: 'StoreId � obrigat�rio para opera��es em lote');

          return false;

        }

        final response = await _repository!.atualizarProdutosEmLote(

          storeId: storeId,

          produtoIds: productIds,

          ativo: ativo,

        );

        if (response.isSuccess) {

          await loadProducts(refresh: true);

          return true;

        }

        state = state.copyWith(error: response.errorMessage);

        return false;

      } else {

        // Local update

        final updatedProducts = state.products.map((p) {

          if (!productIds.contains(p.id.toString())) return p;

          return p.copyWith(status: ativo ? ProductStatus.ativo : ProductStatus.inativo);

        }).toList();

        

        state = state.copyWith(products: updatedProducts);

        return true;

      }

    } catch (e) {

      state = state.copyWith(error: 'Erro ao atualizar status: $e');

      return false;

    }

  }



  void clearError() {

    state = state.copyWith(error: null);

  }

}



// =============================================================================

// PRODUCT STATISTICS STATE

// =============================================================================



class ProductStatisticsModel {

  final int totalProdutos;

  final int comTag;

  final int semTag;

  final int ativos;

  final int inativos;

  final int categorias;

  final double valorEstoque;

  final double ticketMedio;

  final double margemMedia;

  final DateTime? ultimaAtualizacao;

  final double crescimentoMensal;

  final int produtosMaisVendidos;

  final int alertasEstoque;

  final int tagsDisponiveis;



  const ProductStatisticsModel({

    this.totalProdutos = 0,

    this.comTag = 0,

    this.semTag = 0,

    this.ativos = 0,

    this.inativos = 0,

    this.categorias = 0,

    this.valorEstoque = 0,

    this.ticketMedio = 0,

    this.margemMedia = 0,

    this.ultimaAtualizacao,

    this.crescimentoMensal = 0,

    this.produtosMaisVendidos = 0,

    this.alertasEstoque = 0,

    this.tagsDisponiveis = 0,

  });



  ProductStatisticsModel copyWith({

    int? totalProdutos,

    int? comTag,

    int? semTag,

    int? ativos,

    int? inativos,

    int? categorias,

    double? valorEstoque,

    double? ticketMedio,

    double? margemMedia,

    DateTime? ultimaAtualizacao,

    double? crescimentoMensal,

    int? produtosMaisVendidos,

    int? alertasEstoque,

    int? tagsDisponiveis,

  }) {

    return ProductStatisticsModel(

      totalProdutos: totalProdutos ?? this.totalProdutos,

      comTag: comTag ?? this.comTag,

      semTag: semTag ?? this.semTag,

      ativos: ativos ?? this.ativos,

      inativos: inativos ?? this.inativos,

      categorias: categorias ?? this.categorias,

      valorEstoque: valorEstoque ?? this.valorEstoque,

      ticketMedio: ticketMedio ?? this.ticketMedio,

      margemMedia: margemMedia ?? this.margemMedia,

      ultimaAtualizacao: ultimaAtualizacao ?? this.ultimaAtualizacao,

      crescimentoMensal: crescimentoMensal ?? this.crescimentoMensal,

      produtosMaisVendidos: produtosMaisVendidos ?? this.produtosMaisVendidos,

      alertasEstoque: alertasEstoque ?? this.alertasEstoque,

      tagsDisponiveis: tagsDisponiveis ?? this.tagsDisponiveis,

    );

  }

}



class ProductCategoryStatsModel {

  final String id;

  final String nome;

  final IconData icone;
 // ignore: argument_type_not_assignable

  // ignore: argument_type_not_assignable
  final Color cor;
 // ignore: argument_type_not_assignable

  // ignore: argument_type_not_assignable
  final List<Color> gradient;
 // ignore: argument_type_not_assignable

  // ignore: argument_type_not_assignable
  final int quantidade;
 // ignore: argument_type_not_assignable

  // ignore: argument_type_not_assignable
  final double percentual;
 // ignore: argument_type_not_assignable

  final double faturamento;

  final double crescimento;

  final int tagAssociadas;



  const ProductCategoryStatsModel({

    required this.id,

    required this.nome,

    required this.icone,

    required this.cor,

    required this.gradient,

    this.quantidade = 0,

    this.percentual = 0,

    this.faturamento = 0,

    this.crescimento = 0,

    this.tagAssociadas = 0,

  });

}



class ProductStatisticsState {

  final LoadingStatus status;

  final ProductStatisticsModel? statistics;

  final List<ProductCategoryStatsModel> categoriesStats;

  final String? error;



  const ProductStatisticsState({

    this.status = LoadingStatus.initial,

    this.statistics,

    this.categoriesStats = const [],

    this.error,

  });



  ProductStatisticsState copyWith({

    LoadingStatus? status,

    ProductStatisticsModel? statistics,

    List<ProductCategoryStatsModel>? categoriesStats,

    String? error,

  }) {

    return ProductStatisticsState(

      status: status ?? this.status,

      statistics: statistics ?? this.statistics,

      categoriesStats: categoriesStats ?? this.categoriesStats,

      error: error ?? this.error,

    );

  }



  factory ProductStatisticsState.initial() => const ProductStatisticsState();

}



class ProductStatisticsNotifier extends StateNotifier<ProductStatisticsState> {

  final ProdutoRepository? _repository;

  String? _currentStoreId;

  

  ProductStatisticsNotifier([this._repository]) : super(ProductStatisticsState.initial());



  /// Define o storeId para chamadas de API

  void setStoreId(String storeId) {

    _currentStoreId = storeId;

  }



  /// Carrega estat�sticas do backend

  /// GET /api/products/store/{storeId}/statistics (ATUALIZADO)

  Future<void> loadStatistics({String? storeId}) async {

    state = state.copyWith(status: LoadingStatus.loading);

    

    // Usa storeId passado ou o armazenado

    final effectiveStoreId = storeId ?? _currentStoreId;



    try {

      if (_repository != null) {

        final response = await _repository!.getEstatisticas(storeId: effectiveStoreId);

        if (response.isSuccess && response.data != null) {

          final data = response.data!;

          final stats = ProductStatisticsModel(

            // ignore: argument_type_not_assignable
            totalProdutos: data['totalProducts'] ?? data['totalProdutos'] ?? 0,

            // ignore: argument_type_not_assignable
            comTag: data['withTag'] ?? data['comTag'] ?? 0,

            // ignore: argument_type_not_assignable
            semTag: data['withoutTag'] ?? data['semTag'] ?? 0,

            // ignore: argument_type_not_assignable
            ativos: data['active'] ?? data['ativos'] ?? 0,

            // ignore: argument_type_not_assignable
            inativos: data['inactive'] ?? data['inativos'] ?? 0,

            // ignore: argument_type_not_assignable
            categorias: data['categories'] ?? data['categorias'] ?? 0,

            // ignore: argument_type_not_assignable
            valorEstoque: (data['stockValue'] ?? data['valorEstoque'] ?? 0).toDouble(),

            // ignore: argument_type_not_assignable
            ticketMedio: (data['averageTicket'] ?? data['ticketMedio'] ?? 0).toDouble(),

            // ignore: argument_type_not_assignable
            margemMedia: (data['averageMargin'] ?? data['margemMedia'] ?? 0).toDouble(),

            ultimaAtualizacao: data['lastUpdate'] != null 

                ? DateTime.tryParse(data['lastUpdate'].toString()) ?? DateTime.now()

                : DateTime.now(),

            // ignore: argument_type_not_assignable
            crescimentoMensal: (data['monthlyGrowth'] ?? data['crescimentoMensal'] ?? 0).toDouble(),

            // ignore: argument_type_not_assignable
            produtosMaisVendidos: data['topSelling'] ?? data['produtosMaisVendidos'] ?? 0,

            // ignore: argument_type_not_assignable
            alertasEstoque: data['stockAlerts'] ?? data['alertasEstoque'] ?? 0,

            // ignore: argument_type_not_assignable
            tagsDisponiveis: data['availableTags'] ?? data['tagsDisponiveis'] ?? 0,

          );



          // Carregar estat�sticas por categoria se dispon�vel

          final categoryList = data['categoryStats'] as List?;

          List<ProductCategoryStatsModel>? categoryStats;

          if (categoryList != null) {

            categoryStats = categoryList.map((c) {

              final cat = c as Map<String, dynamic>;

              return ProductCategoryStatsModel(

                id: cat['id']?.toString() ?? '',

                nome: ((cat['name']).toString()).toString() ?? cat['nome'] ?? '',

                icone: _getCategoryIcon(((cat['name']).toString()).toString() ?? cat['nome'] ?? ''),

                cor: _getCategoryColor(((cat['name']).toString()).toString() ?? cat['nome'] ?? ''),

                gradient: _getCategoryGradient(((cat['name']).toString()).toString() ?? cat['nome'] ?? ''),

                // ignore: argument_type_not_assignable
                quantidade: cat['totalProducts'] ?? cat['totalProdutos'] ?? cat['quantidade'] ?? 0,

                // ignore: argument_type_not_assignable
                tagAssociadas: cat['withTag'] ?? cat['comTag'] ?? cat['tagAssociadas'] ?? 0,

              );

            }).toList();

          }



          state = state.copyWith(

            status: LoadingStatus.success,

            statistics: stats,

            categoriesStats: categoryStats,

          );

          return;

        }

      }



      // Fallback: valores zerados se n�o houver reposit�rio ou resposta

      state = state.copyWith(

        status: LoadingStatus.success,

        statistics: ProductStatisticsModel(

          totalProdutos: 0,

          comTag: 0,

          semTag: 0,

          ativos: 0,

          inativos: 0,

          categorias: 0,

          valorEstoque: 0,

          ticketMedio: 0,

          margemMedia: 0,

          ultimaAtualizacao: DateTime.now(),

          crescimentoMensal: 0,

          produtosMaisVendidos: 0,

          alertasEstoque: 0,

          tagsDisponiveis: 0,

        ),

      );

    } catch (e) {

      state = state.copyWith(

        status: LoadingStatus.error,

        error: e.toString(),

      );

    }

  }



  IconData _getCategoryIcon(String nome) {

    final lower = nome.toLowerCase();

    if (lower.contains('bebida')) return CategoryThemes.bebidas.icon;

    if (lower.contains('mercearia')) return CategoryThemes.mercearia.icon;

    if (lower.contains('perec�') || lower.contains('pereci')) return CategoryThemes.pereciveis.icon;

    if (lower.contains('limpeza')) return CategoryThemes.limpeza.icon;

    if (lower.contains('higiene')) return CategoryThemes.higiene.icon;

    if (lower.contains('hortifruti')) return CategoryThemes.hortifruti.icon;

    if (lower.contains('frios')) return CategoryThemes.frios.icon;

    if (lower.contains('padaria')) return CategoryThemes.padaria.icon;

    if (lower.contains('pet')) return CategoryThemes.pet.icon;

    return Icons.category_rounded;

  }



  Color _getCategoryColor(String nome) {

    final lower = nome.toLowerCase();

    if (lower.contains('bebida')) return CategoryThemes.bebidas.color;

    if (lower.contains('mercearia')) return CategoryThemes.mercearia.color;

    if (lower.contains('perec�') || lower.contains('pereci')) return CategoryThemes.pereciveis.color;

    if (lower.contains('limpeza')) return CategoryThemes.limpeza.color;

    if (lower.contains('higiene')) return CategoryThemes.higiene.color;

    if (lower.contains('hortifruti')) return CategoryThemes.hortifruti.color;

    if (lower.contains('frios')) return CategoryThemes.frios.color;

    if (lower.contains('padaria')) return CategoryThemes.padaria.color;

    if (lower.contains('pet')) return CategoryThemes.pet.color;

    return AppThemeColors.grey500;

  }



  List<Color> _getCategoryGradient(String nome) {

    final color = _getCategoryColor(nome);

    return [color, color];

  }



  /// Atualiza estat�sticas baseado na lista de produtos

  void updateFromProducts(List<ProductModel> products) {

    final comTag = products.where((p) => p.hasTag).length;

    final semTag = products.where((p) => !p.hasTag).length;

    final ativos = products.where((p) => p.status == ProductStatus.ativo).length;

    final inativos = products.where((p) => p.status == ProductStatus.inativo).length;



    final stats = ProductStatisticsModel(

      totalProdutos: products.length,

      comTag: comTag,

      semTag: semTag,

      ativos: ativos,

      inativos: inativos,

      categorias: state.statistics?.categorias ?? 0,

      valorEstoque: state.statistics?.valorEstoque ?? 0,

      ticketMedio: state.statistics?.ticketMedio ?? 0,

      margemMedia: state.statistics?.margemMedia ?? 0,

      ultimaAtualizacao: DateTime.now(),

      crescimentoMensal: state.statistics?.crescimentoMensal ?? 0,

      produtosMaisVendidos: state.statistics?.produtosMaisVendidos ?? 0,

      alertasEstoque: state.statistics?.alertasEstoque ?? 0,

      tagsDisponiveis: state.statistics?.tagsDisponiveis ?? 0,

    );



    state = state.copyWith(statistics: stats);

  }

}



// =============================================================================

// PRODUCT DETAILS STATE

// =============================================================================



// Nota: PriceHistoryModel � definido em product_models.dart

// O fromJson agora suporta tanto campos em portugu�s quanto em ingl�s



class ProductDetails {

  final ProductModel product;

  final List<PriceHistoryModel> historicoPrecos;

  final Map<String, dynamic>? estatisticas;



  const ProductDetails({

    required this.product,

    this.historicoPrecos = const [],

    this.estatisticas,

  });



  ProductDetails copyWith({

    ProductModel? product,

    List<PriceHistoryModel>? historicoPrecos,

    Map<String, dynamic>? estatisticas,

  }) {

    return ProductDetails(

      product: product ?? this.product,

      historicoPrecos: historicoPrecos ?? this.historicoPrecos,

      estatisticas: estatisticas ?? this.estatisticas,

    );

  }

}



class ProductDetailsState {

  final LoadingStatus status;

  final ProductDetails? details;

  final String? error;



  const ProductDetailsState({

    this.status = LoadingStatus.initial,

    this.details,

    this.error,

  });



  ProductDetailsState copyWith({

    LoadingStatus? status,

    ProductDetails? details,

    String? error,

  }) {

    return ProductDetailsState(

      status: status ?? this.status,

      details: details ?? this.details,

      error: error ?? this.error,

    );

  }



  factory ProductDetailsState.initial() => const ProductDetailsState();

}



class ProductDetailsNotifier extends StateNotifier<ProductDetailsState> {

  final ProdutoRepository? _repository;

  

  ProductDetailsNotifier([this._repository]) : super(ProductDetailsState.initial());



  /// Carrega detalhes do produto

  /// GET /api/products/{productId}

  Future<void> loadProductDetails(String productId) async {

    state = state.copyWith(status: LoadingStatus.loading);



    try {

      if (_repository != null) {

        final response = await _repository!.buscarProduto(productId);

        if (response.isSuccess && response.data != null) {

          final product = ProductModel.fromProduto(response.data!);

          

          // Buscar hist�rico de pre�os do backend

          List<PriceHistoryModel> historicoPrecos = [];

          try {

            final historyResponse = await _repository!.getHistoricoPrecos(productId);

            if (historyResponse.isSuccess && historyResponse.data != null) {

              historicoPrecos = historyResponse.data!

                  .map((json) => PriceHistoryModel.fromJson(json))

                  .toList();

            }

          } catch (e) {

            // Se falhar ao buscar hist�rico, continua sem ele

            debugPrint('Erro ao buscar hist�rico de pre�os: $e');

          }

          

          // Buscar estat�sticas de vendas do backend

          Map<String, dynamic>? estatisticas;

          try {

            final statsResponse = await _repository!.getProductStatistics(productId);

            if (statsResponse.isSuccess && statsResponse.data != null) {

              estatisticas = statsResponse.data;

            }

          } catch (e) {

            // Se falhar ao buscar estat�sticas, continua sem elas

            debugPrint('Erro ao buscar estat�sticas: $e');

          }

          

          state = state.copyWith(

            status: LoadingStatus.success,

            details: ProductDetails(

              product: product,

              historicoPrecos: historicoPrecos,

              estatisticas: estatisticas,

            ),

          );

          return;

        }

      }



      // Fallback: Sem dados

      state = state.copyWith(

        status: LoadingStatus.error,

        error: 'Produto n�o encontrado',

      );

    } catch (e) {

      state = state.copyWith(

        status: LoadingStatus.error,

        error: e.toString(),

      );

    }

  }



  /// Carrega detalhes a partir de um ProductModel existente

  void loadFromProduct(ProductModel product) {

    state = state.copyWith(

      status: LoadingStatus.success,

      details: ProductDetails(

        product: product,

        historicoPrecos: [],

      ),

    );

  }



  void clear() {

    state = ProductDetailsState.initial();

  }

}



// =============================================================================

// STOCK STATE

// =============================================================================



class StockItem {

  final String id;

  final String productId;

  final String nome;

  final String categoria;

  final int estoqueAtual;

  final int estoqueMinimo;

  final int estoqueMaximo;

  final String unidade;

  final DateTime? ultimaMovimentacao;

  final double custoUnitario;

  final double? valorTotal;

  final bool emAlerta;

  final bool esgotado;

  final Color? cor;

  final IconData? icone;



  const StockItem({

    required this.id,

    required this.productId,

    required this.nome,

    required this.categoria,

    this.estoqueAtual = 0,

    this.estoqueMinimo = 0,

    this.estoqueMaximo = 0,

    this.unidade = 'un',

    this.ultimaMovimentacao,

    this.custoUnitario = 0,

    this.valorTotal,

    this.emAlerta = false,

    this.esgotado = false,

    this.cor,

    this.icone,

  });



  String get statusEstoque {

    if (esgotado || estoqueAtual <= 0) return 'Esgotado';

    if (emAlerta || estoqueAtual <= estoqueMinimo) return 'Cr�tico';

    if (estoqueAtual <= estoqueMinimo * 1.5) return 'Baixo';

    return 'OK';

  }



  // Aliases para compatibilidade

  String get status => statusEstoque;

  int get quantidade => estoqueAtual;

  String get sku => id;

  DateTime? get ultimaAtualizacao => ultimaMovimentacao;

  double? get valorUnitario => custoUnitario;



  Color get statusColor {

    switch (statusEstoque) {

      case 'Esgotado': return AppThemeColors.errorIcon;

      case 'Crítico': return AppThemeColors.errorIcon;

      case 'Baixo': return AppThemeColors.warningIcon;

      default: return AppThemeColors.successIcon;

    }

  }



  /// Obtém a cor dinâmica do status (requer BuildContext)

  Color dynamicStatusColor(BuildContext context) {

    final colors = ThemeColors.of(context);

    switch (statusEstoque) {

      case 'Esgotado': return colors.errorIcon;

      case 'Crítico': return colors.errorIcon;

      case 'Baixo': return colors.warningIcon;

      default: return colors.successIcon;

    }

  }



  StockItem copyWith({

    String? id,

    String? productId,

    String? nome,

    String? categoria,

    int? estoqueAtual,

    int? estoqueMinimo,

    int? estoqueMaximo,

    String? unidade,

    DateTime? ultimaMovimentacao,

    double? custoUnitario,

    double? valorTotal,

    bool? emAlerta,

    bool? esgotado,

    Color? cor,

    IconData? icone,

  }) {

    return StockItem(

      id: id ?? this.id,

      productId: productId ?? this.productId,

      nome: nome ?? this.nome,

      categoria: categoria ?? this.categoria,

      estoqueAtual: estoqueAtual ?? this.estoqueAtual,

      estoqueMinimo: estoqueMinimo ?? this.estoqueMinimo,

      estoqueMaximo: estoqueMaximo ?? this.estoqueMaximo,

      unidade: unidade ?? this.unidade,

      ultimaMovimentacao: ultimaMovimentacao ?? this.ultimaMovimentacao,

      custoUnitario: custoUnitario ?? this.custoUnitario,

      valorTotal: valorTotal ?? this.valorTotal,

      emAlerta: emAlerta ?? this.emAlerta,

      esgotado: esgotado ?? this.esgotado,

      cor: cor ?? this.cor,

      icone: icone ?? this.icone,

    );

  }

}



class StockState {

  final LoadingStatus status;

  final List<StockItem> items;

  final String searchQuery;

  final String filterCategoria;

  final bool apenasAlerta;

  final String? error;



  const StockState({

    this.status = LoadingStatus.initial,

    this.items = const [],

    this.searchQuery = '',

    this.filterCategoria = 'Todas',

    this.apenasAlerta = false,

    this.error,

  });



  List<StockItem> get filteredItems {

    return items.where((item) {

      final matchesSearch = searchQuery.isEmpty ||

          item.nome.toLowerCase().contains(searchQuery.toLowerCase());



      final matchesCategoria = filterCategoria == 'Todas' ||

          item.categoria == filterCategoria;



      final matchesAlerta = !apenasAlerta || item.emAlerta || item.esgotado;



      return matchesSearch && matchesCategoria && matchesAlerta;

    }).toList();

  }



  int get totalEmAlerta => items.where((i) => i.emAlerta).length;

  int get totalEsgotado => items.where((i) => i.esgotado).length;

  int get totalBaixo => items.where((i) => i.estoqueAtual <= i.estoqueMinimo * 1.5 && !i.emAlerta && !i.esgotado).length;

  int get totalOk => items.where((i) => i.statusEstoque == 'OK').length;

  double get valorTotalEstoque => items.fold(0.0, (sum, item) => sum + (item.valorTotal ?? 0));



  StockState copyWith({

    LoadingStatus? status,

    List<StockItem>? items,

    String? searchQuery,

    String? filterCategoria,

    bool? apenasAlerta,

    String? error,

  }) {

    return StockState(

      status: status ?? this.status,

      items: items ?? this.items,

      searchQuery: searchQuery ?? this.searchQuery,

      filterCategoria: filterCategoria ?? this.filterCategoria,

      apenasAlerta: apenasAlerta ?? this.apenasAlerta,

      error: error ?? this.error,

    );

  }



  factory StockState.initial() => const StockState();

}



class StockNotifier extends StateNotifier<StockState> {

  final ProdutoRepository? _repository;

  String? _currentStoreId;

  

  StockNotifier([this._repository]) : super(StockState.initial());



  /// Define o storeId para chamadas de API

  void setStoreId(String storeId) {

    _currentStoreId = storeId;

  }



  /// Carrega estoque do backend

  /// GET /api/products/store/{storeId}/stock (ATUALIZADO)

  Future<void> loadStock({String? storeId, String? status}) async {

    state = state.copyWith(status: LoadingStatus.loading);

    

    // Usa storeId passado ou o armazenado

    final effectiveStoreId = storeId ?? _currentStoreId;



    try {

      if (_repository != null) {

        final response = await _repository!.getEstoque(

          storeId: effectiveStoreId,

          status: status,

        );

        if (response.isSuccess && response.data != null) {

          final items = response.data!.map((data) => StockItem(

            id: data['id']?.toString() ?? '',

            productId: data['productId']?.toString() ?? data['id']?.toString() ?? '',

            nome: ((data['name']).toString()).toString() ?? data['nome'] ?? '',

            categoria: ((data['category']).toString()).toString() ?? data['categoria'] ?? '',

            // ignore: argument_type_not_assignable
            estoqueAtual: data['currentStock'] ?? data['estoqueAtual'] ?? 0,

            // ignore: argument_type_not_assignable
            estoqueMinimo: data['minStock'] ?? data['estoqueMinimo'] ?? 0,

            // ignore: argument_type_not_assignable
            estoqueMaximo: data['maxStock'] ?? data['estoqueMaximo'] ?? 0,

            // ignore: argument_type_not_assignable
            custoUnitario: (data['unitCost'] ?? data['custoUnitario'] ?? 0).toDouble(),

            // ignore: argument_type_not_assignable
            valorTotal: (data['totalValue'] ?? data['valorTotal'] ?? 0).toDouble(),

            // ignore: argument_type_not_assignable
            emAlerta: data['isAlert'] ?? data['emAlerta'] ?? false,

            // ignore: argument_type_not_assignable
            esgotado: data['isOut'] ?? data['esgotado'] ?? false,

            ultimaMovimentacao: data['lastMovement'] != null

                ? DateTime.tryParse(data['lastMovement'].toString())

                : null,

          )).toList();



          state = state.copyWith(

            status: LoadingStatus.success,

            items: items,

          );

          return;

        }

      }



      // Fallback: lista vazia se n�o houver reposit�rio ou resposta

      state = state.copyWith(

        status: LoadingStatus.success,

        items: [],

      );

    } catch (e) {

      state = state.copyWith(

        status: LoadingStatus.error,

        error: e.toString(),

      );

    }

  }



  /// Atualiza estoque de um item individual

  /// PUT /api/products/{id}/stock

  Future<bool> updateSingleStock(String productId, int novaQuantidade, {String? motivo}) async {

    if (_repository == null) return false;

    

    try {

      final response = await _repository!.atualizarEstoque(

        productId: productId,

        novaQuantidade: novaQuantidade,

        motivo: motivo,

      );

      

      if (response.isSuccess) {

        // Atualiza item local

        final index = state.items.indexWhere((i) => i.productId == productId);

        if (index != -1) {

          final updatedItems = List<StockItem>.from(state.items);

          final estoqueMinimo = updatedItems[index].estoqueMinimo;

          updatedItems[index] = updatedItems[index].copyWith(

            estoqueAtual: novaQuantidade,

            emAlerta: novaQuantidade <= estoqueMinimo,

            esgotado: novaQuantidade <= 0,

          );

          state = state.copyWith(items: updatedItems);

        }

        return true;

      }

      state = state.copyWith(error: response.errorMessage);

      return false;

    } catch (e) {

      state = state.copyWith(error: 'Erro ao atualizar estoque: $e');

      return false;

    }

  }



  /// Atualiza estoque a partir da lista de produtos

  void updateFromProducts(List<ProductModel> products) {

    final stockItems = products.map((p) => StockItem(

      id: p.id,

      productId: p.id,

      nome: p.nome,

      categoria: p.categoria,

      estoqueAtual: p.estoque?.toInt() ?? 0,

      estoqueMinimo: 0,

      estoqueMaximo: 0,

      custoUnitario: p.preco,

      cor: p.cor,

      icone: p.icone,

    )).toList();



    state = state.copyWith(

      status: LoadingStatus.success,

      items: stockItems,

    );

  }



  void setSearchQuery(String query) {

    state = state.copyWith(searchQuery: query);

  }



  void setFilterCategoria(String categoria) {

    state = state.copyWith(filterCategoria: categoria);

  }



  void toggleApenasAlerta() {

    state = state.copyWith(apenasAlerta: !state.apenasAlerta);

  }



  Future<bool> updateStockItem(String productId, int novaQuantidade) async {

    try {

      if (_repository != null) {

        final response = await _repository!.updateStock(

          productId: productId,

          novaQuantidade: novaQuantidade,

        );

        if (!response.isSuccess) {

          state = state.copyWith(error: response.errorMessage ?? 'Erro ao atualizar estoque');

          return false;

        }

      }



      final index = state.items.indexWhere((i) => i.productId == productId);

      if (index != -1) {

        final updatedItems = List<StockItem>.from(state.items);

        updatedItems[index] = updatedItems[index].copyWith(

          estoqueAtual: novaQuantidade,

          emAlerta: novaQuantidade <= updatedItems[index].estoqueMinimo,

          esgotado: novaQuantidade <= 0,

        );

        state = state.copyWith(items: updatedItems);

      }

      return true;

    } catch (e) {

      state = state.copyWith(error: 'Erro ao atualizar estoque: $e');

      return false;

    }

  }



  void clearError() {

    state = state.copyWith(error: null);

  }

}



// =============================================================================

// PRODUCT IMPORT STATE

// =============================================================================



class ImportPreviewItem {

  final int linha;

  final String codigo;

  final String nome;

  final String preco;

  final String categoria;

  final String estoque;

  final bool valido;

  final String? erro;



  const ImportPreviewItem({

    required this.linha,

    required this.codigo,

    required this.nome,

    required this.preco,

    required this.categoria,

    required this.estoque,

    this.valido = true,

    this.erro,

  });

}



class ImportResultItem {

  final int linha;

  final String codigo;

  final String nome;

  final bool sucesso;

  final String? erro;

  final String? productId;



  const ImportResultItem({

    required this.linha,

    required this.codigo,

    required this.nome,

    this.sucesso = true,

    this.erro,

    this.productId,

  });

}



class ProductImportState {

  final LoadingStatus status;

  final int currentStep; // 1: Upload, 2: Preview, 3: Importando, 4: Resultado

  final String? arquivoNome;

  final List<ImportPreviewItem> previewItems;

  final List<ImportResultItem> resultItems;

  final int totalLinhas;

  final int linhasProcessadas;

  final int sucessos;

  final int erros;

  final String? error;



  const ProductImportState({

    this.status = LoadingStatus.initial,

    this.currentStep = 1,

    this.arquivoNome,

    this.previewItems = const [],

    this.resultItems = const [],

    this.totalLinhas = 0,

    this.linhasProcessadas = 0,

    this.sucessos = 0,

    this.erros = 0,

    this.error,

  });



  double get progressoImportacao => totalLinhas > 0 ? linhasProcessadas / totalLinhas : 0;

  int get validosNoPreview => previewItems.where((i) => i.valido).length;

  int get invalidosNoPreview => previewItems.where((i) => !i.valido).length;



  ProductImportState copyWith({

    LoadingStatus? status,

    int? currentStep,

    String? arquivoNome,

    List<ImportPreviewItem>? previewItems,

    List<ImportResultItem>? resultItems,

    int? totalLinhas,

    int? linhasProcessadas,

    int? sucessos,

    int? erros,

    String? error,

  }) {

    return ProductImportState(

      status: status ?? this.status,

      currentStep: currentStep ?? this.currentStep,

      arquivoNome: arquivoNome ?? this.arquivoNome,

      previewItems: previewItems ?? this.previewItems,

      resultItems: resultItems ?? this.resultItems,

      totalLinhas: totalLinhas ?? this.totalLinhas,

      linhasProcessadas: linhasProcessadas ?? this.linhasProcessadas,

      sucessos: sucessos ?? this.sucessos,

      erros: erros ?? this.erros,

      error: error ?? this.error,

    );

  }



  factory ProductImportState.initial() => const ProductImportState();

}



class ProductImportNotifier extends StateNotifier<ProductImportState> {

  final ProdutoRepository? _repository;

  

  ProductImportNotifier([this._repository]) : super(ProductImportState.initial());



  /// Processa arquivo selecionado

  Future<void> processFile(String fileName, List<Map<String, dynamic>> data) async {

    state = state.copyWith(

      status: LoadingStatus.loading,

      arquivoNome: fileName,

    );



    try {

      final previewItems = <ImportPreviewItem>[];

      

      for (int i = 0; i < data.length; i++) {

        final row = data[i];

        final erros = <String>[];

        

        // Valida��es

        if ((row['código']?.toString().length ?? 0) < 8) {

          erros.add('C�digo curto (m�n 8)');

        }

        if (row['nome']?.toString().isEmpty ?? true) {

          erros.add('Nome obrigat�rio');

        }

        if (double.tryParse(row['preco']?.toString() ?? '') == null) {

          erros.add('Pre�o inv�lido');

        }

        

        previewItems.add(ImportPreviewItem(

          linha: i + 1,

          codigo: row['código']?.toString() ?? '',

          nome: row['nome']?.toString() ?? '',

          preco: row['preco']?.toString() ?? '',

          categoria: row['categoria']?.toString() ?? '',

          estoque: row['estoque']?.toString() ?? '0',

          valido: erros.isEmpty,

          erro: erros.isNotEmpty ? erros.join(', ') : null,

        ));

      }



      state = state.copyWith(

        status: LoadingStatus.success,

        currentStep: 2,

        previewItems: previewItems,

        totalLinhas: previewItems.length,

      );

    } catch (e) {

      state = state.copyWith(

        status: LoadingStatus.error,

        error: 'Erro ao processar arquivo: $e',

      );

    }

  }



  /// Executa importa��o

  Future<void> executeImport({required String storeId}) async {

    state = state.copyWith(

      status: LoadingStatus.loading,

      currentStep: 3,

      linhasProcessadas: 0,

      sucessos: 0,

      erros: 0,

    );



    final resultItems = <ImportResultItem>[];

    int sucessos = 0;

    int erros = 0;



    for (int i = 0; i < state.previewItems.length; i++) {

      final item = state.previewItems[i];

      

      if (!item.valido) {

        resultItems.add(ImportResultItem(

          linha: item.linha,

          codigo: item.codigo,

          nome: item.nome,

          sucesso: false,

          erro: item.erro,

        ));

        erros++;

      } else {

        try {

          if (_repository != null) {

            final response = await _repository!.criarProduto(

              storeId: storeId,

              codigo: item.codigo,

              nome: item.nome,

              preco: double.parse(item.preco),

            );

            

            if (response.isSuccess) {

              resultItems.add(ImportResultItem(

                linha: item.linha,

                codigo: item.codigo,

                nome: item.nome,

                sucesso: true,

                productId: response.data?.id,

              ));

              sucessos++;

            } else {

              resultItems.add(ImportResultItem(

                linha: item.linha,

                codigo: item.codigo,

                nome: item.nome,

                sucesso: false,

                erro: response.errorMessage,

              ));

              erros++;

            }

          } else {

            // Reposit�rio n�o dispon�vel

            resultItems.add(ImportResultItem(

              linha: item.linha,

              codigo: item.codigo,

              nome: item.nome,

              sucesso: false,

              erro: 'Reposit�rio n�o configurado',

            ));

            erros++;

          }

        } catch (e) {

          resultItems.add(ImportResultItem(

            linha: item.linha,

            codigo: item.codigo,

            nome: item.nome,

            sucesso: false,

            erro: e.toString(),

          ));

          erros++;

        }

      }



      state = state.copyWith(

        linhasProcessadas: i + 1,

        sucessos: sucessos,

        erros: erros,

        resultItems: resultItems,

      );

    }



    state = state.copyWith(

      status: LoadingStatus.success,

      currentStep: 4,

    );

  }



  void goToStep(int step) {

    state = state.copyWith(currentStep: step);

  }



  void reset() {

    state = ProductImportState.initial();

  }



  void clearError() {

    state = state.copyWith(error: null);

  }

}



// =============================================================================

// QR/TAG BINDING STATE

// =============================================================================



class TagBindingState {

  final LoadingStatus status;

  final int currentStep; // 1: Ler Tag, 2: Ler Produto, 3: Confirmar, 4: Sucesso

  final String? tagId;

  final String? tagMacAddress;

  final ProductModel? product;

  final bool isScanning;

  final String? error;

  

  // Listas de produtos pendentes e vinculados

  final List<ProductModel> pendentes;

  final List<ProductModel> vinculados;

  final LoadingStatus pendentesStatus;

  final LoadingStatus vinculadosStatus;



  const TagBindingState({

    this.status = LoadingStatus.initial,

    this.currentStep = 1,

    this.tagId,

    this.tagMacAddress,

    this.product,

    this.isScanning = false,

    this.error,

    this.pendentes = const [],

    this.vinculados = const [],

    this.pendentesStatus = LoadingStatus.initial,

    this.vinculadosStatus = LoadingStatus.initial,

  });



  TagBindingState copyWith({

    LoadingStatus? status,

    int? currentStep,

    String? tagId,

    String? tagMacAddress,

    ProductModel? product,

    bool? isScanning,

    String? error,

    List<ProductModel>? pendentes,

    List<ProductModel>? vinculados,

    LoadingStatus? pendentesStatus,

    LoadingStatus? vinculadosStatus,

  }) {

    return TagBindingState(

      status: status ?? this.status,

      currentStep: currentStep ?? this.currentStep,

      tagId: tagId ?? this.tagId,

      tagMacAddress: tagMacAddress ?? this.tagMacAddress,

      product: product ?? this.product,

      isScanning: isScanning ?? this.isScanning,

      error: error ?? this.error,

      pendentes: pendentes ?? this.pendentes,

      vinculados: vinculados ?? this.vinculados,

      pendentesStatus: pendentesStatus ?? this.pendentesStatus,

      vinculadosStatus: vinculadosStatus ?? this.vinculadosStatus,

    );

  }



  factory TagBindingState.initial() => const TagBindingState();

}



class TagBindingNotifier extends StateNotifier<TagBindingState> {

  final TagsRepository? _tagsRepository;

  final ProdutoRepository? _produtoRepository;

  

  TagBindingNotifier([this._tagsRepository, this._produtoRepository]) : super(TagBindingState.initial());



  void startScanning() {

    state = state.copyWith(isScanning: true);

  }



  void stopScanning() {

    state = state.copyWith(isScanning: false);

  }



  void setTagId(String tagId, {String? macAddress}) {

    state = state.copyWith(

      tagId: tagId,

      tagMacAddress: macAddress,

      currentStep: 2,

      isScanning: false,

    );

  }



  void setProduct(ProductModel product) {

    state = state.copyWith(

      product: product,

      currentStep: 3,

      isScanning: false,

    );

  }



  Future<bool> confirmBinding() async {

    state = state.copyWith(status: LoadingStatus.loading);



    try {

      if (_tagsRepository != null && state.tagMacAddress != null && state.product != null) {

        // POST /api/tags/{mac}/bind - Conforme api_test.html

        final response = await _tagsRepository!.bindTag(

          state.tagMacAddress!,

          BindTagRequest(productId: state.product!.id),

        );

        

        if (response.isSuccess) {

          state = state.copyWith(

            status: LoadingStatus.success,

            currentStep: 4,

          );

          return true;

        } else {

          state = state.copyWith(

            status: LoadingStatus.error,

            error: response.errorMessage ?? 'Erro ao vincular tag',

          );

          return false;

        }

      } else {

        // Reposit�rio n�o dispon�vel

        state = state.copyWith(

          status: LoadingStatus.error,

          error: 'Reposit�rio de tags n�o configurado ou dados incompletos',

        );

        return false;

      }

    } catch (e) {

      state = state.copyWith(

        status: LoadingStatus.error,

        error: 'Erro ao vincular: $e',

      );

      return false;

    }

  }



  /// Desvincula uma tag por MAC address

  Future<bool> unbindTag(String macAddress) async {

    try {

      if (_tagsRepository != null) {

        final response = await _tagsRepository!.unbindTag(macAddress);

        if (response.isSuccess) {

          // Remove da lista de vinculados se existir

          final updatedVinculados = state.vinculados

              .where((p) => p.tag != macAddress)

              .toList();

          state = state.copyWith(vinculados: updatedVinculados);

          return true;

        } else {

          state = state.copyWith(error: response.errorMessage);

          return false;

        }

      }

      return false;

    } catch (e) {

      state = state.copyWith(error: 'Erro ao desvincular: $e');

      return false;

    }

  }



  /// Carrega lista de produtos pendentes (sem tag)

  Future<void> loadPendentes() async {

    state = state.copyWith(pendentesStatus: LoadingStatus.loading);

    

    try {

      if (_produtoRepository != null) {

        final response = await _produtoRepository!.listarProdutos();

        if (response.isSuccess && response.data != null) {

          final pendentes = response.data!

              .where((p) => !p.hasTag)

              .map((p) => ProductModel.fromProduto(p))

              .toList();

          state = state.copyWith(

            pendentes: pendentes,

            pendentesStatus: LoadingStatus.success,

          );

        } else {

          state = state.copyWith(

            pendentesStatus: LoadingStatus.error,

            error: response.errorMessage,

          );

        }

      }

    } catch (e) {

      state = state.copyWith(

        pendentesStatus: LoadingStatus.error,

        error: 'Erro ao carregar pendentes: $e',

      );

    }

  }



  /// Carrega lista de produtos vinculados (com tag)

  Future<void> loadVinculados() async {

    state = state.copyWith(vinculadosStatus: LoadingStatus.loading);

    

    try {

      if (_produtoRepository != null) {

        final response = await _produtoRepository!.listarProdutos();

        if (response.isSuccess && response.data != null) {

          final vinculados = response.data!

              .where((p) => p.hasTag)

              .map((p) => ProductModel.fromProduto(p))

              .toList();

          state = state.copyWith(

            vinculados: vinculados,

            vinculadosStatus: LoadingStatus.success,

          );

        } else {

          state = state.copyWith(

            vinculadosStatus: LoadingStatus.error,

            error: response.errorMessage,

          );

        }

      }

    } catch (e) {

      state = state.copyWith(

        vinculadosStatus: LoadingStatus.error,

        error: 'Erro ao carregar vinculados: $e',

      );

    }

  }



  void goToStep(int step) {

    state = state.copyWith(currentStep: step);

  }



  void reset() {

    state = TagBindingState.initial();

  }



  void clearError() {

    state = state.copyWith(error: null);

  }

}



// =============================================================================

// RIVERPOD PROVIDERS

// =============================================================================



/// Provider do Repository de Produtos (conectado � API)

final produtoRepositoryProvider = Provider<ProdutoRepository>((ref) {

  return ProdutoRepository();

});



/// Provider do Repository de Tags (conectado � API)

final tagsRepositoryProvider = Provider<TagsRepository>((ref) {

  return TagsRepository();

});



/// Provider de lista de produtos (Riverpod StateNotifier) - CONECTADO � API

final productsListRiverpodProvider = StateNotifierProvider<ProductsListNotifier, ProductsListState>(

  (ref) {

    final repository = ref.watch(produtoRepositoryProvider);

    return ProductsListNotifier(repository);

  },

);



/// Provider de estat�sticas de produtos (Riverpod StateNotifier) - CONECTADO � API

final productStatisticsRiverpodProvider = StateNotifierProvider<ProductStatisticsNotifier, ProductStatisticsState>(

  (ref) {

    final repository = ref.watch(produtoRepositoryProvider);

    return ProductStatisticsNotifier(repository);

  },

);



/// Provider de detalhes do produto (Riverpod StateNotifier)

final productDetailsRiverpodProvider = StateNotifierProvider<ProductDetailsNotifier, ProductDetailsState>(

  (ref) => ProductDetailsNotifier(),

);



/// Provider de estoque (Riverpod StateNotifier)

final stockRiverpodProvider = StateNotifierProvider<StockNotifier, StockState>(

  (ref) => StockNotifier(),

);



/// Provider de importa��o de produtos

final productImportProvider = StateNotifierProvider<ProductImportNotifier, ProductImportState>(

  (ref) => ProductImportNotifier(),

);





/// Provider de vincula��o Tag/QR - CONECTADO � API

final tagBindingProvider = StateNotifierProvider<TagBindingNotifier, TagBindingState>(

  (ref) {

    final tagsRepository = ref.watch(tagsRepositoryProvider);

    final produtoRepository = ref.watch(produtoRepositoryProvider);

    return TagBindingNotifier(tagsRepository, produtoRepository);

  },

);













