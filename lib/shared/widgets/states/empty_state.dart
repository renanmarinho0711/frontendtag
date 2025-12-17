import 'package:flutter/material.dart';


import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';



/// Widget de estado vazio (quando não existem dados)

class EmptyState extends StatelessWidget {

  final String title;

  final String? message;

  final IconData icon;

  final Color? iconColor;

  final String? actionLabel;

  final VoidCallback? onAction;

  final Widget? customAction;



  const EmptyState({

    super.key,

    required this.title,

    this.message,

    this.icon = Icons.inbox_outlined,

    this.iconColor,

    this.actionLabel,

    this.onAction,

    this.customAction,

  });



  /// Factory para lista de produtos vazia

  factory EmptyState.products({VoidCallback? onAdd}) {

    return EmptyState(

      title: 'Nenhum produto encontrado',

      message: 'Adicione produtos para começar a gerenciar seu estoque.',

      icon: Icons.inventory_2_outlined,

      actionLabel: 'Adicionar Produto',

      onAction: onAdd,

    );

  }



  /// Factory para lista de tags vazia

  factory EmptyState.tags({VoidCallback? onScan}) {

    return EmptyState(

      title: 'Nenhuma tag encontrada',

      message: 'Escaneie tags ESL para visualizá-las aqui.',

      icon: Icons.nfc_outlined,

      actionLabel: 'Escanear Tags',

      onAction: onScan,

    );

  }



  /// Factory para resultados de busca vazia

  factory EmptyState.search({String? query}) {

    return EmptyState(

      title: 'Nenhum resultado encontrado',

      message: query != null

          ? 'Não encontramos resultados para "$query".'

          : 'Tente buscar por outro termo.',

      icon: Icons.search_off_outlined,

    );

  }



  /// Factory para lista de estratégias vazia

  factory EmptyState.strategies({VoidCallback? onCreate}) {

    return EmptyState(

      title: 'Nenhuma estratégia ativa',

      message: 'Crie estratégias de precificação para aumentar seus lucros.',

      icon: Icons.trending_up_outlined,

      actionLabel: 'Criar Estratégia',

      onAction: onCreate,

    );

  }



  /// Factory para lista de categorias vazia

  factory EmptyState.categories({VoidCallback? onCreate}) {

    return EmptyState(

      title: 'Nenhuma categoria',

      message: 'Organize seus produtos criando categorias.',

      icon: Icons.folder_outlined,

      actionLabel: 'Criar Categoria',

      onAction: onCreate,

    );

  }



  /// Factory para histórico vazio

  factory EmptyState.history() {

    return const EmptyState(

      title: 'Sem histórico',

      message: 'O histórico de atividades aparecerá aqui.',

      icon: Icons.history_outlined,

    );

  }



  /// Factory para notificações vazias

  factory EmptyState.notifications() {

    return const EmptyState(

      title: 'Sem notificações',

      message: 'Você não tem notificações no momento.',

      icon: Icons.notifications_off_outlined,

    );

  }



  @override

  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final colors = ThemeColors.of(context);

    final color = iconColor ?? colors.grey400;



    return Center(

      child: Padding(

        padding: const EdgeInsets.all(32),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(

              icon,

              size: 80,

              color: color,

            ),

            const SizedBox(height: 24),

            Text(

              title,

              style: theme.textTheme.titleLarge?.copyWith(

                color: colors.grey700,

                fontWeight: FontWeight.w600,

              ),

              textAlign: TextAlign.center,

            ),

            if (message != null) ...[

              const SizedBox(height: 8),

              Text(

                message!,

                style: theme.textTheme.bodyMedium?.copyWith(

                  color: colors.grey500,

                ),

                textAlign: TextAlign.center,

              ),

            ],

            if (customAction != null) ...[

              const SizedBox(height: 24),

              customAction!,

            ] else if (onAction != null && actionLabel != null) ...[

              const SizedBox(height: 24),

              ElevatedButton.icon(

                onPressed: onAction,

                icon: const Icon(Icons.add),

                label: Text(actionLabel!),

                style: ElevatedButton.styleFrom(

                  padding: const EdgeInsets.symmetric(

                    horizontal: 24,

                    vertical: 12,

                  ),

                ),

              ),

            ],

          ],

        ),

      ),

    );

  }

}



/// Versão compacta do EmptyState para listas inline

class InlineEmpty extends StatelessWidget {

  final String message;

  final IconData icon;



  const InlineEmpty({

    super.key,

    required this.message,

    this.icon = Icons.inbox_outlined,

  });



  @override

  Widget build(BuildContext context) {

    final colors = ThemeColors.of(context);

    return Padding(

      padding: const EdgeInsets.all(24),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(icon, size: 20, color: colors.grey400),

          const SizedBox(width: 8),

          Text(

            message,

            style: TextStyle(

              color: colors.grey500,

              fontSize: 14,

            ),

          ),

        ],

      ),

    );

  }

}









