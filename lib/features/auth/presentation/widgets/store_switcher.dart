import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/design_system/theme/typography.dart';
import 'package:tagbean/features/auth/data/models/work_context_model.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
import 'package:tagbean/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:tagbean/shared/widgets/feedback/action_feedback.dart';

/// Widget de sele��o de loja com dropdown e bot�o de confirma��o
/// Exibe a loja atual e permite trocar para outra loja dispon�vel
class StoreSwitcher extends ConsumerStatefulWidget {
  /// Callback executado quando a loja � trocada com sucesso
  final VoidCallback? onStoreChanged;

  /// Se deve mostrar em modo compacto (apenas dropdown)
  final bool compact;

  /// Se deve mostrar o bot�o de confirma��o
  final bool showConfirmButton;

  const StoreSwitcher({
    super.key,
    this.onStoreChanged,
    this.compact = false,
    this.showConfirmButton = true,
  });

  @override
  ConsumerState<StoreSwitcher> createState() => _StoreSwitcherState();
}

class _StoreSwitcherState extends ConsumerState<StoreSwitcher> {
  String? _selectedStoreId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeSelection();
  }

  void _initializeSelection() {
    final context = ref.read(currentWorkContextProvider);
    _selectedStoreId = context.currentStoreId;
  }

  @override
  Widget build(BuildContext context) {
    final workContext = ref.watch(currentWorkContextProvider);
    final stores = workContext.availableStores;
    final isChanging = ref.watch(isChangingStoreProvider);

    // Se n�o tem m�ltiplas lojas, n�o mostrar o seletor
    if (stores.length <= 1) {
      return _buildSingleStoreDisplay(workContext);
    }

    // Atualizar sele��o se o contexto mudou externamente
    if (_selectedStoreId != workContext.currentStoreId && !_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedStoreId = workContext.currentStoreId;
          });
        }
      });
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.of(context).primaryOverlay20),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlackLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // �cone da loja
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).primaryOverlay10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.storefront_rounded,
              color: ThemeColors.of(context).primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Dropdown de sele��o
          Flexible(
            child: _buildDropdown(stores, isChanging),
          ),

          // Bot�o de confirma��o
          if (widget.showConfirmButton && _hasSelectionChanged(workContext)) ...[
            const SizedBox(width: 8),
            _buildConfirmButton(isChanging),
          ],
        ],
      ),
    );
  }

  /// Exibe apenas o nome da loja quando h� apenas uma
  Widget _buildSingleStoreDisplay(WorkContext workContext) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).primaryOverlay10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.storefront_rounded,
            color: ThemeColors.of(context).primary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            workContext.currentStoreName ?? 'Loja',
            style: AppTextStyles.bodyMedium.copyWith(
              color: ThemeColors.of(context).primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Constr�i o dropdown de sele��o
  Widget _buildDropdown(List<StoreInfo> stores, bool isChanging) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedStoreId,
        isExpanded: true,
        isDense: true,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: isChanging ? ThemeColors.of(context).textTertiary : ThemeColors.of(context).primary,
        ),
        hint: Text(
          'Selecione uma loja',
          style: TextStyle(color: ThemeColors.of(context).textSecondary, fontSize: 14),
        ),
        items: stores.map((store) {
          return DropdownMenuItem<String>(
            value: store.id,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        store.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (store.cnpj != null || store.address != null)
                        Text(
                          store.cnpj ?? store.address ?? '',
                          style: TextStyle(
                            fontSize: 11,
                            color: ThemeColors.of(context).textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: isChanging
            ? null
            : (value) {
                setState(() {
                  _selectedStoreId = value;
                });
                // Se n�o tem bot�o de confirma��o, trocar imediatamente
                if (!widget.showConfirmButton && value != null) {
                  _confirmChange();
                }
              },
      ),
    );
  }

  /// Constr�i o bot�o de confirma��o
  Widget _buildConfirmButton(bool isChanging) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: isChanging || _isLoading ? null : _confirmChange,
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.of(context).primary,
          foregroundColor: ThemeColors.of(context).surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: _isLoading || isChanging
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
                ),
              )
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_rounded, size: 18),
                  SizedBox(width: 4),
                  Text('OK'),
                ],
              ),
      ),
    );
  }

  /// Verifica se a sele��o foi alterada
  bool _hasSelectionChanged(WorkContext workContext) {
    return _selectedStoreId != null &&
        _selectedStoreId != workContext.currentStoreId;
  }

  /// Confirma a troca de loja
  Future<void> _confirmChange() async {
    if (_selectedStoreId == null) return;

    setState(() => _isLoading = true);

    try {
      final notifier = ref.read(workContextProvider.notifier);
      final success = await notifier.selectStore(_selectedStoreId!);

      if (success) {
        widget.onStoreChanged?.call();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                  const SizedBox(width: 8),
                  const Text('Loja alterada com sucesso!'),
                ],
              ),
              backgroundColor: ThemeColors.of(context).success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          final error = ref.read(workContextErrorProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error ?? 'Erro ao alterar loja'),
              backgroundColor: ThemeColors.of(context).error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
          // Reverter sele��o
          setState(() {
            _selectedStoreId = ref.read(currentWorkContextProvider).currentStoreId;
          });
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

/// Widget de card para troca de loja no dashboard
/// Vers�o com dropdown hier�rquico expans�vel
/// Mostra: Cliente > Lojas com op��o "Todas as lojas" para admins
class StoreSwitcherCard extends ConsumerStatefulWidget {
  /// Callback executado quando a loja � trocada com sucesso
  final VoidCallback? onStoreChanged;

  const StoreSwitcherCard({
    super.key,
    this.onStoreChanged,
  });

  @override
  ConsumerState<StoreSwitcherCard> createState() => _StoreSwitcherCardState();
}

class _StoreSwitcherCardState extends ConsumerState<StoreSwitcherCard> {
  String? _selectedStoreId;
  bool _isLoading = false;
  bool _isExpanded = false; // Controla se a lista est� expandida

  @override
  void initState() {
    super.initState();
    _initializeSelection();
  }

  void _initializeSelection() {
    final context = ref.read(currentWorkContextProvider);
    _selectedStoreId = context.currentStoreId;
  }

  @override
  Widget build(BuildContext context) {
    final workContext = ref.watch(currentWorkContextProvider);
    final stores = workContext.availableStores;
    final isChanging = ref.watch(isChangingStoreProvider);
    final canManageAll = workContext.canManageAllStores;
    final clientName = workContext.clientName ?? 'Empresa';

    // Sempre mostrar o card para usu�rios com acesso a lojas
    // (mesmo com 1 loja, mostra o contexto atual)

    // Verifica se est� em modo "Todas as lojas"
    final isAllStoresMode = _selectedStoreId == 'ALL_STORES' || 
        (workContext.workScope == WorkScope.allStores && _selectedStoreId == null);

    // Encontra a loja atual selecionada
    final currentStore = stores.firstWhere(
      (s) => s.id == (isAllStoresMode ? workContext.currentStoreId : _selectedStoreId),
      orElse: () => stores.isNotEmpty ? stores.first : StoreInfo(id: '', name: 'Nenhuma loja', isActive: false),
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header clic�vel (sempre vis�vel)
          InkWell(
            onTap: stores.length > 1 || canManageAll ? () {
              setState(() => _isExpanded = !_isExpanded);
            } : null,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // �cone principal
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isAllStoresMode
                          ? [ThemeColors.of(context).success, ThemeColors.of(context).greenDark]
                          : [ThemeColors.of(context).primary, ThemeColors.of(context).primary.withValues(alpha: 0.7)],
                    ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isAllStoresMode ? Icons.store_mall_directory_rounded : Icons.storefront_rounded,
                      color: ThemeColors.of(context).surface,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Info da loja/modo atual
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hierarquia: Cliente
                        Row(
                          children: [
                            Icon(Icons.business_rounded, size: 14, color: ThemeColors.of(context).textTertiary),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                clientName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ThemeColors.of(context).textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        // Nome da loja atual
                        Text(
                          isAllStoresMode 
                              ? '?? Todas as lojas (${stores.length})'
                              : currentStore.name,
                          style: AppTextStyles.h3.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isAllStoresMode ? ThemeColors.of(context).success : ThemeColors.of(context).textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!isAllStoresMode && currentStore.address != null)
                          Text(
                            currentStore.address!,
                            style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textTertiary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  
                  // Seta de expans�o (se tem m�ltiplas op��es)
                  if (stores.length > 1 || canManageAll)
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).overlay10,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: ThemeColors.of(context).textSecondary,
                          size: 24,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Lista expand�vel de lojas
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(stores, workContext, isChanging, canManageAll),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(List<StoreInfo> stores, WorkContext workContext, bool isChanging, bool canManageAll) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 400), // Limita altura m�xima
      decoration: BoxDecoration(
        color: ThemeColors.of(context).textTertiary.withValues(alpha: 0.03),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Op��o "Todas as lojas" (apenas para admins)
                  if (canManageAll) ...[
                    _buildAllStoresOption(workContext, isChanging),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Container(width: 20, height: 1, color: ThemeColors.of(context).grey300),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'ou selecione uma loja',
                              style: TextStyle(fontSize: 11, color: ThemeColors.of(context).textTertiary),
                            ),
                          ),
                          Expanded(child: Container(height: 1, color: ThemeColors.of(context).grey300)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  // Lista de lojas com hierarquia
                  ...stores.asMap().entries.map((entry) {
                    final index = entry.key;
                    final store = entry.value;
                    return _buildStoreOption(store, workContext, isChanging, index + 1, stores.length);
                  }),
                  
                  // Bot�o de confirma��o
                  if (_hasSelectionChanged(workContext)) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isChanging || _isLoading ? null : _confirmChange,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeColors.of(context).primary,
                          foregroundColor: ThemeColors.of(context).surface,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading || isChanging
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Alterando...'),
                                ],
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_rounded),
                                  SizedBox(width: 8),
                                  Text('Confirmar'),
                                ],
                              ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Op��o "Todas as lojas" para administradores
  Widget _buildAllStoresOption(WorkContext workContext, bool isChanging) {
    final isSelected = _selectedStoreId == 'ALL_STORES';
    final isCurrent = workContext.workScope == WorkScope.allStores;

    return InkWell(
      onTap: isChanging ? null : () {
        setState(() => _selectedStoreId = 'ALL_STORES');
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [ThemeColors.of(context).overlay15, ThemeColors.of(context).overlay05],
                )
              : null,
          color: isSelected ? null : ThemeColors.of(context).overlay05,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ThemeColors.of(context).blueCyan : ThemeColors.of(context).overlay20,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? ThemeColors.of(context).overlay20 : ThemeColors.of(context).overlay10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.store_mall_directory_rounded,
                color: isSelected ? ThemeColors.of(context).blueCyan : ThemeColors.of(context).textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '?? Todas as lojas',
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? ThemeColors.of(context).blueCyan : ThemeColors.of(context).textPrimary,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCurrent)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: ThemeColors.of(context).successLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Atual',
                            style: TextStyle(
                              color: ThemeColors.of(context).success,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    'Visualizar dados consolidados de todas as lojas',
                    style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textSecondary),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: ThemeColors.of(context).blueCyan, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreOption(StoreInfo store, WorkContext workContext, bool isChanging, int index, int total) {
    final isCurrentStore = workContext.currentStoreId == store.id && workContext.workScope == WorkScope.singleStore;
    final isSelected = _selectedStoreId == store.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: isChanging ? null : () {
          setState(() => _selectedStoreId = store.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? ThemeColors.of(context).primaryOverlay10
                : ThemeColors.of(context).surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isSelected ? ThemeColors.of(context).primary : ThemeColors.of(context).overlay20,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // N�mero da loja na hierarquia
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? ThemeColors.of(context).primaryOverlay20 
                      : ThemeColors.of(context).textTertiaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    store.number ?? index.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? ThemeColors.of(context).primary : ThemeColors.of(context).textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // �cone da loja
              Icon(
                Icons.storefront_rounded,
                color: isSelected ? ThemeColors.of(context).primary : ThemeColors.of(context).textTertiary,
                size: 18,
              ),
              const SizedBox(width: 8),

              // Info da loja
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            store.name,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? ThemeColors.of(context).primary : ThemeColors.of(context).textPrimary,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isCurrentStore)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: ThemeColors.of(context).successLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Atual',
                              style: TextStyle(
                                color: ThemeColors.of(context).success,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (store.address != null)
                      Text(
                        store.address!,
                        style: TextStyle(fontSize: 11, color: ThemeColors.of(context).textTertiary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Indicador de sele��o
              if (isSelected)
                Icon(Icons.check_circle, color: ThemeColors.of(context).primary, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasSelectionChanged(WorkContext workContext) {
    if (_selectedStoreId == null) return false;
    
    // Verifica se mudou para "Todas as lojas"
    if (_selectedStoreId == 'ALL_STORES') {
      return workContext.workScope != WorkScope.allStores;
    }
    
    // Verifica se mudou de loja
    return _selectedStoreId != workContext.currentStoreId;
  }

  Future<void> _confirmChange() async {
    if (_selectedStoreId == null) return;

    // Buscar nome da loja selecionada
    final workContext = ref.read(currentWorkContextProvider);
    String selectedStoreName = 'Todas as Lojas';
    bool isAllStores = _selectedStoreId == 'ALL_STORES';
    
    if (!isAllStores) {
      final store = workContext.availableStores.firstWhere(
        (s) => s.id == _selectedStoreId,
        orElse: () => workContext.availableStores.first,
      );
      selectedStoreName = store.name;
    }

    final oldStoreName = workContext.isAllStores 
        ? 'Todas as lojas' 
        : workContext.currentStoreName ?? 'Loja anterior';

    // Usar ConfirmationDialog do shared
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: isAllStores ? 'Mudar para Todas as Lojas?' : 'Trocar de Loja?',
      message: 'Voc� est� trocando de "$oldStoreName" para "$selectedStoreName".\n\n'
          'Os seguintes dados ser�o recarregados:\n'
          '� Produtos\n'
          '� Tags/Etiquetas\n'
          '� Pre�os e estrat�gias\n'
          '� Dashboard\n\n'
          'Nenhum dado ser� perdido.',
      confirmText: 'Confirmar',
      cancelText: 'Cancelar',
      icon: isAllStores ? Icons.store_mall_directory_rounded : Icons.swap_horiz_rounded,
    );

    // Se n�o confirmou, restaurar sele��o anterior e sair
    if (!confirmed) {
      setState(() {
        _selectedStoreId = workContext.currentStoreId;
      });
      return;
    }

    // Prosseguir com a mudan�a
    setState(() => _isLoading = true);

    try {
      final notifier = ref.read(workContextProvider.notifier);
      bool success;
      
      if (isAllStores) {
        success = await notifier.selectAllStores();
      } else {
        success = await notifier.selectStore(_selectedStoreId!);
      }

      if (success) {
        setState(() => _isExpanded = false);
        widget.onStoreChanged?.call();
        if (mounted) {
          ActionFeedback.showSuccess(
            context,
            isAllStores 
                ? 'Modo "Todas as lojas" ativado!' 
                : 'Agora trabalhando em: $selectedStoreName',
          );
        }
      } else {
        if (mounted) {
          final error = ref.read(workContextErrorProvider);
          ActionFeedback.showError(
            context,
            error ?? 'Erro ao alterar loja',
          );
          setState(() {
            _selectedStoreId = workContext.currentStoreId;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ActionFeedback.showError(
          context,
          'Erro inesperado ao trocar de loja',
        );
        setState(() {
          _selectedStoreId = workContext.currentStoreId;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}









