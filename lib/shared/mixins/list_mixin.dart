mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Mixin para funcionalidades comuns de listas com paginação
mixin ListMixin<T extends StatefulWidget, I> on State<T> {
  /// Lista de itens
  List<I> items = [];

  /// Estado de loading
  bool isLoading = false;

  /// Estado de loading de mais itens
  bool isLoadingMore = false;

  /// Flag indicando se há mais itens
  bool hasMore = true;

  /// Número da página atual
  int currentPage = 1;

  /// Tamanho da página
  int get pageSize => 20;

  /// Mensagem de erro
  String? error;

  /// Controller do scroll para paginação
  late final ScrollController scrollController;

  /// Distância do final para carregar mais
  double get loadMoreThreshold => 200;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    loadInitial();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  /// Listener de scroll para carregar mais
  void _onScroll() {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;

    if (maxScroll - currentScroll <= loadMoreThreshold) {
      loadMore();
    }
  }

  /// Carrega dados iniciais - deve ser implementado
  Future<List<I>> fetchItems(int page, int pageSize);

  /// Carrega dados iniciais
  Future<void> loadInitial() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      error = null;
      currentPage = 1;
    });

    try {
      final result = await fetchItems(currentPage, pageSize);
      if (mounted) {
        setState(() {
          items = result;
          hasMore = result.length >= pageSize;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  /// Carrega mais itens
  Future<void> loadMore() async {
    if (isLoading || isLoadingMore || !hasMore) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      final nextPage = currentPage + 1;
      final result = await fetchItems(nextPage, pageSize);
      if (mounted) {
        setState(() {
          items.addAll(result);
          currentPage = nextPage;
          hasMore = result.length >= pageSize;
          isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  /// Atualiza lista (pull to refresh)
  Future<void> refresh() async {
    setState(() {
      currentPage = 1;
      hasMore = true;
    });
    await loadInitial();
  }

  /// Adiciona item no início
  void addItem(I item) {
    setState(() {
      items.insert(0, item);
    });
  }

  /// Adiciona item no final
  void appendItem(I item) {
    setState(() {
      items.add(item);
    });
  }

  /// Remove item
  void removeItem(I item) {
    setState(() {
      items.remove(item);
    });
  }

  /// Remove item por índice
  void removeItemAt(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  /// Atualiza item
  void updateItem(int index, I item) {
    setState(() {
      items[index] = item;
    });
  }

  /// Atualiza item que corresponde à condição
  void updateItemWhere(bool Function(I) test, I item) {
    final index = items.indexWhere(test);
    if (index != -1) {
      updateItem(index, item);
    }
  }

  /// Retorna se lista está vazia
  bool get isEmpty => items.isEmpty && !isLoading;

  /// Retorna se tem itens
  bool get hasItems => items.isNotEmpty;

  /// Retorna quantidade de itens
  int get itemCount => items.length;

  /// Constrói ListView com pull to refresh
  Widget buildRefreshableList({
    required Widget Function(BuildContext, int) itemBuilder,
    Widget? separatorBuilder,
    Widget? emptyWidget,
    Widget? errorWidget,
    Widget? loadingWidget,
    EdgeInsetsGeometry? padding,
  }) {
    if (isLoading && items.isEmpty) {
      return loadingWidget ??
          const Center(child: CircularProgressIndicator());
    }

    if (error != null && items.isEmpty) {
      return errorWidget ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: ThemeColors.of(context).redMain),
                const SizedBox(height: 16),
                Text(error!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: loadInitial,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
    }

    if (items.isEmpty) {
      return emptyWidget ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 48, color: ThemeColors.of(context).grey500),
                SizedBox(height: 16),
                Text('Nenhum item encontrado'),
              ],
            ),
          );
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.separated(
        controller: scrollController,
        padding: padding,
        itemCount: items.length + (isLoadingMore || hasMore ? 1 : 0),
        separatorBuilder: (context, index) =>
            separatorBuilder ?? const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index == items.length) {
            return isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }
          return itemBuilder(context, index);
        },
      ),
    );
  }

  /// Constrói GridView com pull to refresh
  Widget buildRefreshableGrid({
    required Widget Function(BuildContext, int) itemBuilder,
    required int crossAxisCount,
    double mainAxisSpacing = 8,
    double crossAxisSpacing = 8,
    double childAspectRatio = 1,
    Widget? emptyWidget,
    Widget? errorWidget,
    Widget? loadingWidget,
    EdgeInsetsGeometry? padding,
  }) {
    if (isLoading && items.isEmpty) {
      return loadingWidget ??
          const Center(child: CircularProgressIndicator());
    }

    if (error != null && items.isEmpty) {
      return errorWidget ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: ThemeColors.of(context).redMain),
                const SizedBox(height: 16),
                Text(error!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: loadInitial,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
    }

    if (isEmpty) {
      return emptyWidget ??
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 48, color: ThemeColors.of(context).grey500),
                SizedBox(height: 16),
                Text('Nenhum item encontrado'),
              ],
            ),
          );
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: GridView.builder(
        controller: scrollController,
        padding: padding,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: items.length,
        itemBuilder: itemBuilder,
      ),
    );
  }
}

/// Mixin para lista com busca
mixin SearchableListMixin<T extends StatefulWidget, I> on ListMixin<T, I> {
  /// Termo de busca
  String searchQuery = '';

  /// Controller do campo de busca
  late final TextEditingController searchController;

  /// Debounce para busca
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// Atualiza busca
  void updateSearch(String query) {
    if (query == searchQuery) return;

    setState(() {
      searchQuery = query;
    });

    // Debounce simples
    if (!_isSearching) {
      _isSearching = true;
      Future.delayed(const Duration(milliseconds: 300), () {
        _isSearching = false;
        loadInitial();
      });
    }
  }

  /// Limpa busca
  void clearSearch() {
    searchController.clear();
    updateSearch('');
  }

  /// Constrói campo de busca
  Widget buildSearchField({
    String hint = 'Buscar...',
    bool autofocus = false,
  }) {
    return TextField(
      controller: searchController,
      autofocus: autofocus,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                onPressed: clearSearch,
                icon: const Icon(Icons.clear),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: updateSearch,
    );
  }
}

/// Mixin para lista com filtros
mixin FilterableListMixin<T extends StatefulWidget, I> on ListMixin<T, I> {
  /// Filtros ativos
  Map<String, dynamic> activeFilters = {};

  /// Atualiza filtro
  void updateFilter(String key, dynamic value) {
    setState(() {
      if (value == null) {
        activeFilters.remove(key);
      } else {
        activeFilters[key] = value;
      }
    });
    loadInitial();
  }

  /// Limpa filtros
  void clearFilters() {
    setState(() {
      activeFilters.clear();
    });
    loadInitial();
  }

  /// Retorna se tem filtros ativos
  bool get hasActiveFilters => activeFilters.isNotEmpty;

  /// Retorna quantidade de filtros ativos
  int get activeFilterCount => activeFilters.length;

  /// Constrói badge de filtro
  Widget buildFilterBadge({
    required Widget child,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          if (hasActiveFilters)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).redMain,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$activeFilterCount',
                  style: TextStyle(
                    color: ThemeColors.of(context).surface,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Mixin para lista com seleção
mixin SelectableListMixin<T extends StatefulWidget, I> on ListMixin<T, I> {
  /// Itens selecionados
  Set<I> selectedItems = {};

  /// Modo de seleção ativo
  bool isSelectionMode = false;

  /// Ativa modo de seleção
  void enterSelectionMode() {
    setState(() {
      isSelectionMode = true;
    });
  }

  /// Desativa modo de seleção
  void exitSelectionMode() {
    setState(() {
      isSelectionMode = false;
      selectedItems.clear();
    });
  }

  /// Toggle seleção de item
  void toggleSelection(I item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
        if (selectedItems.isEmpty) {
          isSelectionMode = false;
        }
      } else {
        selectedItems.add(item);
        isSelectionMode = true;
      }
    });
  }

  /// Seleciona todos
  void selectAll() {
    setState(() {
      selectedItems = Set.from(items);
    });
  }

  /// Desseleciona todos
  void deselectAll() {
    setState(() {
      selectedItems.clear();
    });
  }

  /// Retorna se item está selecionado
  bool isSelected(I item) => selectedItems.contains(item);

  /// Retorna quantidade de selecionados
  int get selectedCount => selectedItems.length;

  /// Retorna se todos estão selecionados
  bool get isAllSelected =>
      items.isNotEmpty && selectedItems.length == items.length;

  /// Constrói AppBar de seleção
  PreferredSizeWidget? buildSelectionAppBar({
    required List<Widget> actions,
    VoidCallback? onClose,
  }) {
    if (!isSelectionMode) return null;

    return AppBar(
      leading: IconButton(
        onPressed: onClose ?? exitSelectionMode,
        icon: const Icon(Icons.close),
      ),
      title: Text('$selectedCount selecionado(s)'),
      actions: [
        IconButton(
          onPressed: isAllSelected ? deselectAll : selectAll,
          icon: Icon(
            isAllSelected
                ? Icons.check_box
                : Icons.check_box_outline_blank,
          ),
          tooltip: isAllSelected ? 'Desselecionar todos' : 'Selecionar todos',
        ),
        ...actions,
      ],
    );
  }
}





