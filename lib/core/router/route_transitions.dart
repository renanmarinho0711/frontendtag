import 'package:flutter/material.dart';

/// # Transições de Rota Customizadas
/// 
/// Define animações de transição entre páginas.
/// Mantém consistência visual em toda navegação.
class RouteTransitions {
  /// Fade in/out
  static Widget fade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
  
  /// Slide from right (iOS style)
  static Widget slideFromRight(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOutCubic;
    
    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );
    
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
  
  /// Slide from bottom (Modal style)
  static Widget slideFromBottom(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;
    
    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );
    
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
  
  /// Scale (zoom in/out)
  static Widget scale(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const curve = Curves.easeInOutCubic;
    
    var tween = Tween(begin: 0.0, end: 1.0).chain(
      CurveTween(curve: curve),
    );
    
    return ScaleTransition(
      scale: animation.drive(tween),
      child: child,
    );
  }
  
  /// Shared axis transition (Material You)
  static Widget sharedAxis(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeThroughTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}

/// Fade through transition widget
class FadeThroughTransition extends StatelessWidget {
  const FadeThroughTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation.drive(
        CurveTween(curve: Curves.easeOut),
      ),
      child: FadeTransition(
        opacity: secondaryAnimation.drive(
          Tween<double>(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
        ),
        child: child,
      ),
    );
  }
}
