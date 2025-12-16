import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/design_system/theme/spacing.dart';
import 'package:tagbean/design_system/theme/typography.dart';
import 'package:tagbean/features/auth/data/models/work_context_model.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
import 'package:tagbean/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:tagbean/shared/widgets/feedback/action_feedback.dart';

/// Widget de sele��o de loja/contexto de trabalho
/// Exibe um dropdown estilo ComboBox para alternar entre lojas
class StoreSelector extends ConsumerStatefulWidget {
  /// Se deve mostrar o indicador de loading
  final bool showLoading;

  /// Callback quando o contexto � alterado
  final VoidCallback? onContextChanged;

  /// Se est� em modo compacto (apenas �cone + nome)
  final bool compact;

  const StoreSelector({
    super.key,
    this.showLoading = true,
    this.onContextChanged,
    this.compact = false,
  });

  @override
  ConsumerState<StoreSelector> createState() => _StoreSelectorState();
}

class _StoreSelectorState extends ConsumerState<StoreSelector> {
  bool _isChangingStore = false;

  @override
  Widget build(BuildContext context) {
    final workContextState = ref.watch(workContextProvider);
    final canSwitch = ref.watch(canSwitchStoreProvider);
    final isChanging = ref.watch(isChangingStoreProvider);

    // Se n�o pode trocar de loja, mostrar apenas texto
    if (!canSwitch) {
      return _buildReadOnly(context, workContextState.context);
    }

    return _buildComboBox(context, workContextState, isChanging);
  }

  /// Constr�i a vers�o somente leitura (quando n�o pode trocar)
  Widget _buildReadOnly(BuildContext context, WorkContext workContext) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).primaryOverlay10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(workContext.scope),
            size: 18,
            color: ThemeColors.of(context).primary,
          ),
          SizedBox(width: Spacing.xs),
          if (!widget.compact)
            Flexible(
              child: Text(
                workContext.formattedDisplayText,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: ThemeColors.of(context).primary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  /// Constr�i o ComboBox de sele��o de loja
  Widget _buildComboBox(
    BuildContext context,
    WorkContextState state,
    bool isChanging,
  ) {
    final workContext = state.context;
    final stores = workContext.availableStores;
    final currentStoreId = workContext.currentStoreId;

    // Adicionar op��o "Todas as lojas" no in�cio se permitido
    final List<DropdownMenuItem<String>> items = [];
    
    if (workContext.canSwitchScope) {
      items.add(
        DropdownMenuItem<String>(
          value: 'all',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.store_rounded, size: 18, color: ThemeColors.of(context).success),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Todas as lojas (${stores.length})',
                  style: TextStyle(
                    fontWeight: workContext.isAllStores ? FontWeight.w600 : FontWeight.normal,
                    color: workContext.isAllStores ? ThemeColors.of(context).primary : null,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Adicionar cada loja
    for (final store in stores) {
      final isSelected = currentStoreId == store.id && workContext.isSingleStore;
      items.add(
        DropdownMenuItem<String>(
          value: store.id,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.storefront_rounded, 
                size: 18, 
                color: isSelected ? ThemeColors.of(context).primary : ThemeColors.of(context).grey600,
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(
                  store.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? ThemeColors.of(context).primary : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Determinar valor atual
    String? currentValue;
    if (workContext.isAllStores) {
      currentValue = 'all';
    } else if (currentStoreId != null) {
      currentValue = currentStoreId;
    }

    // Usa MediaQuery para definir maxWidth responsivo
    final screenWidth = MediaQuery.of(context).size.width;
    final maxSelectorWidth = screenWidth < 600 ? 180.0 : (screenWidth < 1024 ? 220.0 : 280.0);
    
    return Container(
      constraints: BoxConstraints(maxWidth: maxSelectorWidth),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ThemeColors.of(context).primaryOverlay30,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).primaryOverlay10,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // �cone da loja
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).primaryOverlay10,
              borderRadius: BorderRadius.circular(6),
            ),
            child: _isChangingStore || isChanging
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).primary),
                    ),
                  )
                : Icon(
                    _getIcon(workContext.scope),
                    size: 16,
                    color: ThemeColors.of(context).primary,
                  ),
          ),
          const SizedBox(width: 8),

          // Dropdown
          Flexible(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentValue,
                isExpanded: true,
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isChanging ? ThemeColors.of(context).grey500 : ThemeColors.of(context).primary,
                ),
                hint: Text(
                  'Selecione uma loja',
                  style: TextStyle(color: ThemeColors.of(context).grey600, fontSize: 13),
                ),
                style: TextStyle(
                  color: ThemeColors.of(context).grey800,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                dropdownColor: ThemeColors.of(context).surface,
                borderRadius: BorderRadius.circular(12),
                items: items,
                onChanged: isChanging || _isChangingStore
                    ? null
                    : (value) => _onStoreSelected(value, workContext),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Quando uma loja � selecionada
  Future<void> _onStoreSelected(String? value, WorkContext currentContext) async {
    if (value == null) return;

    // Verificar se � a mesma loja
    if (value == 'all' && currentContext.isAllStores) return;
    if (value != 'all' && value == currentContext.currentStoreId && currentContext.isSingleStore) return;

    // Obter nome da loja antiga e nova
    final oldStoreName = currentContext.isAllStores 
        ? 'Todas as lojas' 
        : currentContext.currentStoreName ?? 'Loja anterior';
    
    String newStoreName;
    String newStoreId = value;
    bool isAllStores = value == 'all';
    
    if (isAllStores) {
      newStoreName = 'Todas as lojas (${currentContext.availableStores.length})';
    } else {
      final store = currentContext.availableStores.firstWhere(
        (s) => s.id == value,
        orElse: () => StoreInfo(id: value, name: 'Nova loja'),
      );
      newStoreName = store.name;
    }

    // Mostrar popup de confirma��o usando ConfirmationDialog
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: isAllStores ? 'Mudar para Todas as Lojas?' : 'Trocar de Loja?',
      message: 'Voc� est� trocando de "$oldStoreName" para "$newStoreName".\n\n'
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

    if (!confirmed || !mounted) return;

    setState(() => _isChangingStore = true);

    try {
      final notifier = ref.read(workContextProvider.notifier);
      bool success;

      if (isAllStores) {
        success = await notifier.selectAllStores();
      } else {
        success = await notifier.selectStore(newStoreId);
      }

      if (success) {
        widget.onContextChanged?.call();
        if (mounted) {
          ActionFeedback.showSuccess(
            context,
            'Agora trabalhando em: $newStoreName',
          );
        }
      } else {
        if (mounted) {
          final error = ref.read(workContextErrorProvider);
          ActionFeedback.showError(
            context,
            error ?? 'Erro ao alterar loja',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ActionFeedback.showError(
          context,
          'Erro inesperado ao trocar de loja',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isChangingStore = false);
      }
    }
  }

  /// Retorna o �cone baseado no escopo
  IconData _getIcon(WorkScope scope) {
    switch (scope) {
      case WorkScope.singleStore:
        return Icons.storefront_rounded;
      case WorkScope.allStores:
        return Icons.store_rounded;
      case WorkScope.platform:
        return Icons.admin_panel_settings_rounded;
    }
  }
}

/// Widget indicador de contexto atual (vers�o simplificada)
class WorkContextBadge extends ConsumerWidget {
  const WorkContextBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayText = ref.watch(workContextDisplayTextProvider);
    final scope = ref.watch(currentWorkScopeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getBackgroundColor(scope),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(scope),
            size: 16,
            color: _getIconColor(scope),
          ),
          const SizedBox(width: 6),
          Text(
            displayText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _getIconColor(scope),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(WorkScope scope) {
    switch (scope) {
      case WorkScope.singleStore:
        return Icons.storefront_rounded;
      case WorkScope.allStores:
        return Icons.store_rounded;
      case WorkScope.platform:
        return Icons.admin_panel_settings_rounded;
    }
  }

  Color _getBackgroundColor(WorkScope scope) {
    switch (scope) {
      case WorkScope.singleStore:
        return ThemeColors.of(context).overlay10;  // Usando overlay universal
      case WorkScope.allStores:
        return ThemeColors.of(context).successOverlay10;  // Verde 10%
      case WorkScope.platform:
        return ThemeColors.of(context).overlay10;  // Usando overlay universal
    }
  }

  Color _getIconColor(WorkScope scope) {
    switch (scope) {
      case WorkScope.singleStore:
        return ThemeColors.of(context).blueDark;
      case WorkScope.allStores:
        return ThemeColors.of(context).green700;
      case WorkScope.platform:
        return ThemeColors.of(context).blueCyan;
    }
  }
}

/// Dialog para sele��o de loja (alternativa ao dropdown)
class StoreSelectorDialog extends ConsumerStatefulWidget {
  const StoreSelectorDialog({super.key});

  @override
  ConsumerState<StoreSelectorDialog> createState() => _StoreSelectorDialogState();

  /// Mostra o dialog de sele��o de loja
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => const StoreSelectorDialog(),
    );
  }
}

class _StoreSelectorDialogState extends ConsumerState<StoreSelectorDialog> {
  String? _selectedStoreId;
  bool _selectAll = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final context = ref.read(currentWorkContextProvider);
    _selectedStoreId = context.currentStoreId;
    _selectAll = context.isAllStores;
  }

  @override
  Widget build(BuildContext context) {
    final workContext = ref.watch(currentWorkContextProvider);
    final stores = workContext.availableStores;

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.store_rounded),
          SizedBox(width: 12),
          Text('Selecionar Loja'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Op��o "Todas as lojas"
            if (workContext.canSwitchScope) ...[
              _buildOption(
                title: 'Todas as lojas',
                subtitle: 'Visualizar dados consolidados de ${stores.length} lojas',
                icon: Icons.store_rounded,
                isSelected: _selectAll,
                onTap: () {
                  setState(() {
                    _selectAll = true;
                    _selectedStoreId = null;
                  });
                },
              ),
              const Divider(height: 24),
            ],

            // Lista de lojas
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  return _buildOption(
                    title: store.name,
                    subtitle: store.cnpj ?? store.address,
                    icon: Icons.storefront_rounded,
                    isSelected: !_selectAll && _selectedStoreId == store.id,
                    onTap: () {
                      setState(() {
                        _selectAll = false;
                        _selectedStoreId = store.id;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _confirm,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Confirmar'),
        ),
      ],
    );
  }

  Widget _buildOption({
    required String title,
    String? subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? ThemeColors.of(context).primary : ThemeColors.of(context).grey500,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: isSelected
          ? Icon(Icons.check_circle, color: ThemeColors.of(context).primary)
          : null,
      selected: isSelected,
      selectedTileColor: ThemeColors.of(context).primaryOverlay05,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: onTap,
    );
  }

  Future<void> _confirm() async {
    setState(() => _isLoading = true);

    final notifier = ref.read(workContextProvider.notifier);
    bool success;

    if (_selectAll) {
      success = await notifier.selectAllStores();
    } else if (_selectedStoreId != null) {
      success = await notifier.selectStore(_selectedStoreId!);
    } else {
      setState(() => _isLoading = false);
      return;
    }

    if (mounted) {
      Navigator.pop(context, success);
    }
  }
}



