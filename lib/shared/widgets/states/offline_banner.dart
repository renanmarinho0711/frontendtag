import 'package:flutter/material.dart';


import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';



/// Banner de estado offline

/// 

/// Exibe uma barra de notificação quando o utilizador está offline.

/// Pode incluir um botão de reconexão opcional.

/// 

/// Uso:

/// ```dart

/// if (!isOnline)

///   OfflineBanner(

///     message: 'Você está offline. Dados podem estar desatualizados.',

///     onRetry: () => _checkConnection(),

///   ),

/// ```

class OfflineBanner extends StatelessWidget {

  final String message;

  final VoidCallback? onRetry;

  final bool showIcon;

  final Color? backgroundColor;

  final Color? textColor;



  const OfflineBanner({

    super.key,

    this.message = 'Você está offline',

    this.onRetry,

    this.showIcon = true,

    this.backgroundColor,

    this.textColor,

  });



  /// Factory para banner de sincronização pendente

  factory OfflineBanner.syncPending({VoidCallback? onRetry}) {

    return OfflineBanner(

      message: 'Sincronização pendente. Conecte-se para sincronizar.',

      onRetry: onRetry,

    );

  }



  /// Factory para banner de dados desatualizados

  factory OfflineBanner.staleData({VoidCallback? onRetry}) {

    return OfflineBanner(

      message: 'Dados podem estar desatualizados.',

      onRetry: onRetry,

    );

  }



  @override

  Widget build(BuildContext context) {

    final colors = ThemeColors.of(context);

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

      decoration: BoxDecoration(

        color: backgroundColor ?? colors.warning,

        boxShadow: [

          BoxShadow(

            color: colors.overlay10,

            blurRadius: 4,

            offset: const Offset(0, 2),

          ),

        ],

      ),

      child: Row(

        children: [

          if (showIcon) ...[

            Icon(Icons.check_rounded, color: colors.surface, size: 20),

            const SizedBox(width: 12),

          ],

          Expanded(

            child: Text(

              message,

              style: TextStyle(

                color: textColor ?? colors.surface,

                fontSize: 13,

                fontWeight: FontWeight.w500,

              ),

            ),

          ),

          if (onRetry != null)

            TextButton(

              onPressed: onRetry,

              style: TextButton.styleFrom(

                foregroundColor: textColor ?? colors.surface,

                padding: const EdgeInsets.symmetric(horizontal: 12),

              ),

              child: const Text('Reconectar'),

            ),

        ],

      ),

    );

  }

}



/// Banner compacto para uso em AppBar ou contextos menores

class OfflineIndicator extends StatelessWidget {

  final bool isOffline;

  final VoidCallback? onTap;



  const OfflineIndicator({

    super.key,

    required this.isOffline,

    this.onTap,

  });



  @override

  Widget build(BuildContext context) {

    if (!isOffline) return const SizedBox.shrink();

    final colors = ThemeColors.of(context);



    return GestureDetector(

      onTap: onTap,

      child: Container(

        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

        decoration: BoxDecoration(

          color: colors.warningPastel,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: colors.warning, width: 1),

        ),

        child: Row(

          mainAxisSize: MainAxisSize.min,

          children: [

            Icon(

              Icons.cloud_off,

              color: colors.warning,

              size: 16,

            ),

            const SizedBox(width: 4),

            Text(

              'Offline',

              style: TextStyle(

                color: colors.warning,

                fontSize: 12,

                fontWeight: FontWeight.w600,

              ),

            ),

          ],

        ),

      ),

    );

  }

}













