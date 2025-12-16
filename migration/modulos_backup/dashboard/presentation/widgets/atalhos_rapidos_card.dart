mport 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';

/// BLOCO 6: Atalhos de Teclado / Gestãos
/// Acelera operações para usuários frequentes
class AtalhosRapidosCard extends StatelessWidget {
  final VoidCallback? onNovoProduto;
  final VoidCallback? onNovaTag;
  final VoidCallback? onVincular;
  final VoidCallback? onSincronizar;
  final VoidCallback? onBuscar;
  final VoidCallback? onAtualizar;

  const AtalhosRapidosCard({
    super.key,
    this.onNovoProduto,
    this.onNovaTag,
    this.onVincular,
    this.onSincronizar,
    this.onBuscar,
    this.onAtualizar,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    // Em mobile, não mostra atalhos de teclado
    if (isMobile) {
      return _buildMobileGestures(context);
    }
    
    return _buildDesktopShortcuts(context);
  }

  Widget _buildDesktopShortcuts(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppThemeColors.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemeColors.grey200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.keyboard_rounded,
                color: AppThemeColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'ATALHOS RÁPIDOS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => _showAllShortcuts(context),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text(
                    'Ver Todos',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppThemeColors.greenMaterial,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Atalhos em wrap
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildShortcut('Ctrl+P', 'Novo Produto', onNovoProduto),
              _buildShortcut('Ctrl+T', 'Nova Tag', onNovaTag),
              _buildShortcut('Ctrl+V', 'Vincular', onVincular),
              _buildShortcut('Ctrl+S', 'Sincronizar', onSincronizar),
              _buildShortcut('Ctrl+B', 'Buscar', onBuscar),
              _buildShortcut('F5', 'Atualizar', onAtualizar),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileGestures(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppThemeColors.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemeColors.grey200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.touch_app_rounded,
                color: AppThemeColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'GESTOS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildGesture(Icons.swipe_right_rounded, 'Deslizar →', 'Menu'),
              _buildGesture(Icons.swipe_down_rounded, 'Deslizar ↓', 'Atualizar'),
              _buildGesture(Icons.touch_app_rounded, '2 toques', 'Busca'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortcut(String keys, String action, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppThemeColors.grey200,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppThemeColors.grey300),
              ),
              child: Text(
                keys,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppThemeColors.grey700,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              action,
              style: TextStyle(
                fontSize: 11,
                color: AppThemeColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGesture(IconData icon, String gesture, String action) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppThemeColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            '$gesture: $action',
            style: TextStyle(
              fontSize: 11,
              color: AppThemeColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showAllShortcuts(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.keyboard_rounded, color: AppThemeColors.greenMaterial),
            const SizedBox(width: 12),
            const Text('Atalhos de Teclado'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShortcutCategory('Navegação', [
                ('Ctrl+1-9', 'Ir para seção'),
                ('Ctrl+D', 'Dashboard'),
                ('Esc', 'Fechar diálogo'),
              ]),
              const Divider(height: 24),
              _buildShortcutCategory('Ações Rápidas', [
                ('Ctrl+P', 'Novo Produto'),
                ('Ctrl+T', 'Nova Tag'),
                ('Ctrl+V', 'Vincular Tag'),
                ('Ctrl+S', 'Sincronizar'),
              ]),
              const Divider(height: 24),
              _buildShortcutCategory('Busca e Filtros', [
                ('Ctrl+B', 'Buscar'),
                ('Ctrl+F', 'Filtrar lista'),
                ('F5', 'Atualizar'),
              ]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutCategory(String title, List<(String, String)> shortcuts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppThemeColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        ...shortcuts.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Container(
                width: 80,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppThemeColors.grey100,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppThemeColors.grey300),
                ),
                child: Text(
                  s.$1,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                    color: AppThemeColors.grey700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                s.$2,
                style: TextStyle(
                  fontSize: 13,
                  color: AppThemeColors.textPrimary,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}

/// Mixin para adicionar suporte a atalhos de teclado
mixin KeyboardShortcutsMixin<T extends StatefulWidget> on State<T> {
  late FocusNode _focusNode;
  
  Map<LogicalKeySet, VoidCallback> get keyboardShortcuts;
  
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }
  
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  
  Widget buildWithKeyboardShortcuts({required Widget child}) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: child,
    );
  }
  
  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    
    final ctrl = HardwareKeyboard.instance.isControlPressed;
    final key = event.logicalKey;
    
    // Mapear atalhos
    if (ctrl && key == LogicalKeyboardKey.keyP) {
      keyboardShortcuts[LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyP)]?.call();
    } else if (ctrl && key == LogicalKeyboardKey.keyT) {
      keyboardShortcuts[LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyT)]?.call();
    } else if (ctrl && key == LogicalKeyboardKey.keyV) {
      keyboardShortcuts[LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyV)]?.call();
    } else if (ctrl && key == LogicalKeyboardKey.keyS) {
      keyboardShortcuts[LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS)]?.call();
    } else if (ctrl && key == LogicalKeyboardKey.keyB) {
      keyboardShortcuts[LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyB)]?.call();
    } else if (key == LogicalKeyboardKey.f5) {
      keyboardShortcuts[LogicalKeySet(LogicalKeyboardKey.f5)]?.call();
    }
  }
}
