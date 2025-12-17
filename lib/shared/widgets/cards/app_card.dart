import 'package:flutter/material.dart';


import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';



/// Card base customizado do app

class AppCard extends StatelessWidget {

  final Widget child;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  final Color? backgroundColor;

  final Color? borderColor;

  final double borderRadius;

  final double elevation;

  final VoidCallback? onTap;

  final VoidCallback? onLongPress;



  const AppCard({

    super.key,

    required this.child,

    this.padding,

    this.margin,

    this.backgroundColor,

    this.borderColor,

    this.borderRadius = 12,

    this.elevation = 1,

    this.onTap,

    this.onLongPress,

  });



  /// Factory para card sem elevao (flat)

  /// Para cor dinâmica da borda, use o construtor padrão com ThemeColors.of(context).grey200

  factory AppCard.flat({

    required Widget child,

    EdgeInsetsGeometry? padding,

    EdgeInsetsGeometry? margin,

    Color? backgroundColor,

    Color? borderColor,

    double borderRadius = 12,

    VoidCallback? onTap,

  }) =>

      AppCard(

        padding: padding,

        margin: margin,

        backgroundColor: backgroundColor,

        borderColor: borderColor ?? const Color(0xFFEEEEEE), // grey200 default

        borderRadius: borderRadius,

        elevation: 0,

        onTap: onTap,

        child: child,

      );



  /// Factory para card com outline

  /// Para cor dinâmica da borda, use o construtor padrão com ThemeColors.of(context).grey300

  factory AppCard.outlined({

    required Widget child,

    EdgeInsetsGeometry? padding,

    EdgeInsetsGeometry? margin,

    Color? borderColor,

    double borderRadius = 12,

    VoidCallback? onTap,

  }) =>

      AppCard(

        padding: padding,

        margin: margin,

        borderColor: borderColor ?? const Color(0xFFE0E0E0), // grey300 default

        borderRadius: borderRadius,

        elevation: 0,

        onTap: onTap,

        child: child,

      );



  /// Factory para card elevado

  factory AppCard.elevated({

    required Widget child,

    EdgeInsetsGeometry? padding,

    EdgeInsetsGeometry? margin,

    Color? backgroundColor,

    double borderRadius = 12,

    double elevation = 4,

    VoidCallback? onTap,

  }) =>

      AppCard(

        padding: padding,

        margin: margin,

        backgroundColor: backgroundColor,

        borderRadius: borderRadius,

        elevation: elevation,

        onTap: onTap,

        child: child,

      );



  @override

  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final colors = ThemeColors.of(context);



    Widget card = Container(

      margin: margin,

      decoration: BoxDecoration(

        color: backgroundColor ?? theme.cardColor,

        borderRadius: BorderRadius.circular(borderRadius),

        border: borderColor != null

            ? Border.all(color: borderColor!, width: 1)

            : null,

        boxShadow: elevation > 0

            ? [

                BoxShadow(

                  color: colors.shadowLight,

                  blurRadius: elevation * 2,

                  offset: Offset(0, elevation),

                ),

              ]

            : null,

      ),

      child: ClipRRect(

        borderRadius: BorderRadius.circular(borderRadius),

        child: padding != null

            ? Padding(padding: padding!, child: child)

            : child,

      ),

    );



    if (onTap != null || onLongPress != null) {

      return Material(

        color: colors.transparent,

        child: InkWell(

          onTap: onTap,

          onLongPress: onLongPress,

          borderRadius: BorderRadius.circular(borderRadius),

          child: card,

        ),

      );

    }



    return card;

  }

}



/// Card com header e contedo

class AppCardWithHeader extends StatelessWidget {

  final String title;

  final String? subtitle;

  final IconData? icon;

  final Color? iconColor;

  final Widget child;

  final Widget? action;

  final EdgeInsetsGeometry? contentPadding;

  final VoidCallback? onTap;



  const AppCardWithHeader({

    super.key,

    required this.title,

    this.subtitle,

    this.icon,

    this.iconColor,

    required this.child,

    this.action,

    this.contentPadding,

    this.onTap,

  });



  @override

  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final colors = ThemeColors.of(context);



    return AppCard(

      onTap: onTap,

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        mainAxisSize: MainAxisSize.min,

        children: [

          Padding(

            padding: const EdgeInsets.all(16),

            child: Row(

              children: [

                if (icon != null) ...[

                  Container(

                    padding: const EdgeInsets.all(8),

                    decoration: BoxDecoration(

                      color: Color.alphaBlend(colors.surface.withValues(alpha: 0.9), iconColor ?? theme.primaryColor),

                      borderRadius: BorderRadius.circular(8),

                    ),

                    child: Icon(

                      icon,

                      size: 20,

                      color: iconColor ?? theme.primaryColor,

                    ),

                  ),

                  const SizedBox(width: 12),

                ],

                Expanded(

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(

                        title,

                        style: theme.textTheme.titleMedium?.copyWith(

                          fontWeight: FontWeight.w600,

                        ),

                      ),

                      if (subtitle != null) ...[

                        const SizedBox(height: 2),

                        Text(

                          subtitle!,

                          style: theme.textTheme.bodySmall?.copyWith(

                            color: colors.grey600,

                          ),

                        ),

                      ],

                    ],

                  ),

                ),

                if (action != null) action!,

              ],

            ),

          ),

          const Divider(height: 1),

          Padding(

            padding: contentPadding ?? const EdgeInsets.all(16),

            child: child,

          ),

        ],

      ),

    );

  }

}











