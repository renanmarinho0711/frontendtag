import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/auth/presentation/providers/auth_provider.dart';

/// # Guards de Rota
/// 
/// Controla acesso às rotas baseado em condições.
/// 
/// ## Tipos de Guards:
/// - **Auth Guard**: Verifica autenticação
/// - **Role Guard**: Verifica permissões
/// - **Subscription Guard**: Verifica plano/assinatura
/// - **Onboarding Guard**: Verifica se completou onboarding
class RouteGuards {
  /// Verifica se usuário está autenticado
  static Future<bool> authGuard(Ref ref) async {
    final authState = ref.read(authProvider);
    return authState.status == AuthStatus.authenticated;
  }
  
  /// Verifica se usuário tem role específica
  static Future<bool> roleGuard(Ref ref, String requiredRole) async {
    final authState = ref.read(authProvider);
    if (authState.status != AuthStatus.authenticated) return false;
    
    final userRole = authState.user?.role ?? '';
    return userRole == requiredRole || userRole == 'admin';
  }
  
  /// Verifica se usuário tem plano premium
  static Future<bool> premiumGuard(Ref ref) async {
    final authState = ref.read(authProvider);
    if (authState.status != AuthStatus.authenticated) return false;
    
    return authState.user?.isPremium ?? false;
  }
  
  /// Verifica se usuário completou onboarding
  static Future<bool> onboardingGuard(Ref ref) async {
    final authState = ref.read(authProvider);
    if (authState.status != AuthStatus.authenticated) return false;
    
    return authState.user?.hasCompletedOnboarding ?? false;
  }
}

/// Modelo de usuário - Importado de auth_models.dart
// (User model é definido em features/auth/data/models/)
