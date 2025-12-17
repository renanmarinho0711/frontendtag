import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/products/data/models/product_tag_model.dart';
import 'package:tagbean/features/products/presentation/providers/product_tag_provider.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
/// Widget para exibir e gerenciar tags vinculadas a um produto
class ProductTagsWidget extends ConsumerWidget {
  final String productId;
  final String productName;
  final double currentPrice;
  final bool editable;
  final VoidCallback? onAddTag;

  const ProductTagsWidget({
    super.key,
    required this.productId,
    required this.productName,
    required this.currentPrice,
    this.editable = true,
    this.onAddTag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(productTagsProvider(productId));

    return tagsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => _buildErrorState(context, error.toString()),
      data: (productTags) {
        if (productTags == null) {
          return _buildEmptyState(context);
        }
        return _buildTagsList(context, ref, productTags);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.label_off_outlined,
              size: 48,
              color: ThemeColors.of(context).grey400,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Nenhuma tag vinculada',
              style: TextStyle(
                color: ThemeColors.of(context).grey600,
                fontSize: 14,
              ),
            ),
            if (editable) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: onAddTag,
                icon: const Icon(Icons.add),
                label: const Text('Vincular Tag'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: ThemeColors.of(context).red400,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Erro ao carregar tags',
              style: TextStyle(
                color: ThemeColors.of(context).redMain,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsList(BuildContext context, WidgetRef ref, ProductTagsList productTags) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Icon(
                  Icons.label,
                  color: ThemeColors.of(context).blueCyan,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Tags Vinculadas (${productTags.linkedTags.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (editable)
                  IconButton(
                    onPressed: onAddTag,
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: 'Vincular nova tag',
                    color: ThemeColors.of(context).blueCyan,
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Lista de tags
          if (productTags.linkedTags.isEmpty)
            _buildEmptyState(context)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productTags.linkedTags.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final tag = productTags.linkedTags[index];
                return _TagListItem(
                  tag: tag,
                  editable: editable,
                  onDelete: editable ? () => _confirmDelete(context, ref, tag) : null,
                  onSync: () => _syncTag(ref, tag),
                );
              },
            ),
            
          // Botão de sincronizar todos
          if (productTags.linkedTags.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _syncAllTags(ref),
                  icon: const Icon(Icons.sync),
                  label: const Text('Sincronizar Preço em Todas as Tags'),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, TagBinding tag) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desvincular Tag'),
        content: Text('Deseja remover a vinculação com a tag ${tag.tagMacAddress}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).redMain,
            ),
            child: const Text('Desvincular'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(productTagProvider.notifier).deleteBinding(tag.productTagId);
      ref.invalidate(productTagsProvider(productId));
    }
  }

  Future<void> _syncTag(WidgetRef ref, TagBinding tag) async {
    // Sincroniza uma tag espec�fica
    final notifier = ref.read(productTagProvider.notifier);
    await notifier.syncPriceToAllTags(productId);
    ref.invalidate(productTagsProvider(productId));
  }

  Future<void> _syncAllTags(WidgetRef ref) async {
    final notifier = ref.read(productTagProvider.notifier);
    await notifier.syncPriceToAllTags(productId);
    ref.invalidate(productTagsProvider(productId));
  }
}

/// Item individual de tag na lista
class _TagListItem extends StatelessWidget {
  final TagBinding tag;
  final bool editable;
  final VoidCallback? onDelete;
  final VoidCallback? onSync;

  const _TagListItem({
    required this.tag,
    this.editable = true,
    this.onDelete,
    this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildStatusIcon(context),
      title: Row(
        children: [
          Text(
            tag.tagMacAddress,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w500,
            ),
          ),
          if (tag.isPrimary) ...[
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Principal',
                style: TextStyle(
                  fontSize: 10,
                  color: ThemeColors.of(context).blueCyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tag.location != null)
            Text('Local: ${tag.location}'),
          Text(
            _getSyncStatusText(),
            style: TextStyle(
              fontSize: 12,
              color: _getSyncStatusColor(),
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onSync,
            icon: const Icon(Icons.sync, size: 20),
            tooltip: 'Sincronizar',
          ),
          if (editable && onDelete != null)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.link_off, size: 20),
              tooltip: 'Desvincular',
              color: ThemeColors.of(context).redMain,
            ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context) {
    Color color;
    IconData icon;

    switch (tag.syncStatus) {
      case TagSyncStatus.synced:
        color = ThemeColors.of(context).greenMain;
        icon = Icons.check_circle;
        break;
      case TagSyncStatus.syncing:
        color = ThemeColors.of(context).orangeMain;
        icon = Icons.sync;
        break;
      case TagSyncStatus.error:
        color = ThemeColors.of(context).redMain;
        icon = Icons.error;
        break;
      case TagSyncStatus.pending:
        color = ThemeColors.of(context).grey500;
        icon = Icons.schedule;
        break;
    }

    return CircleAvatar(
      backgroundColor: color.withValues(alpha: 0.1),
      child: Icon(icon, color: color, size: 20),
    );
  }

  String _getSyncStatusText() {
    switch (tag.syncStatus) {
      case TagSyncStatus.synced:
        final date = tag.lastPriceSync;
        if (date != null) {
          return 'Sincronizado em ${_formatDate(date)}';
        }
        return 'Sincronizado';
      case TagSyncStatus.syncing:
        return 'Sincronizando...';
      case TagSyncStatus.error:
        return 'Erro na sincronização';
      case TagSyncStatus.pending:
        return 'Aguardando sincronização';
    }
  }

  Color _getSyncStatusColor() {
    switch (tag.syncStatus) {
      case TagSyncStatus.synced:
        return ThemeColors.of(context).greenMain;
      case TagSyncStatus.syncing:
        return ThemeColors.of(context).orangeMain;
      case TagSyncStatus.error:
        return ThemeColors.of(context).redMain;
      case TagSyncStatus.pending:
        return ThemeColors.of(context).grey500;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}