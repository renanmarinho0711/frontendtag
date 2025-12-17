import 'package:flutter/material.dart';


import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';



/// Widget de estado de erro

class ErrorState extends StatelessWidget {

  final String message;

  final String? details;

  final VoidCallback? onRetry;

  final IconData icon;

  final Color? iconColor;



  const ErrorState({

    super.key,

    required this.message,

    this.details,

    this.onRetry,

    this.icon = Icons.error_outline,

    this.iconColor,

  });



  /// Factory para erro de rede

  factory ErrorState.network({VoidCallback? onRetry}) {

    return ErrorState(

      message: 'Sem conexão com a internet',

      details: 'Verifique sua conexão e tente novamente.',

      icon: Icons.wifi_off_outlined,

      onRetry: onRetry,

    );

  }



  /// Factory para erro de servidor

  factory ErrorState.server({VoidCallback? onRetry}) {

    return ErrorState(

      message: 'Erro no servidor',

      details: 'Ocorreu um erro. Tente novamente em alguns minutos.',

      icon: Icons.cloud_off_outlined,

      onRetry: onRetry,

    );

  }



  /// Factory para erro de autenticação

  factory ErrorState.auth({VoidCallback? onRetry}) {

    return ErrorState(

      message: 'Sessão expirada',

      details: 'Faça login novamente para continuar.',

      icon: Icons.lock_outline,

      onRetry: onRetry,

    );

  }



  @override

  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final colors = ThemeColors.of(context);

    return Center(

      child: Padding(

        padding: const EdgeInsets.all(32),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(

              icon,

              size: 64,

              color: colors.errorIcon,

            ),

            const SizedBox(height: 16),

            Text(

              message,

              style: theme.textTheme.titleMedium?.copyWith(

                color: colors.grey800,

                fontWeight: FontWeight.w600,

              ),

              textAlign: TextAlign.center,

            ),

            if (details != null) ...[

              const SizedBox(height: 8),

              Text(

                details!,

                style: theme.textTheme.bodyMedium?.copyWith(

                  color: colors.grey600,

                ),

                textAlign: TextAlign.center,

              ),

            ],

            if (onRetry != null) ...[

              const SizedBox(height: 24),

              ElevatedButton.icon(

                onPressed: onRetry,

                icon: const Icon(Icons.refresh),

                label: const Text('Tentar novamente'),

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



/// Versão compacta do ErrorState para uso inline

class InlineError extends StatelessWidget {

  final String message;

  final VoidCallback? onRetry;



  const InlineError({

    super.key,

    required this.message,

    this.onRetry,

  });



  @override

  Widget build(BuildContext context) {

    final colors = ThemeColors.of(context);

    return Container(

      padding: const EdgeInsets.all(12),

      margin: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: colors.errorPastel,

        borderRadius: BorderRadius.circular(8),

        border: Border.all(color: colors.errorLight),

      ),

      child: Row(

        children: [

          Icon(Icons.error_outline, color: colors.redMain, size: 20),

          const SizedBox(width: 12),

          Expanded(

            child: Text(

              message,

              style: TextStyle(

                color: colors.redMain,

                fontSize: 14,

              ),

            ),

          ),

          if (onRetry != null) ...[

            const SizedBox(width: 8),

            TextButton(

              onPressed: onRetry,

              child: const Text('Tentar'),

            ),

          ],

        ],

      ),

    );

  }

}









