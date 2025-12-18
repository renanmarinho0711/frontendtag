// REMOVED: import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_routes.dart';
// REMOVED: import 'route_guards.dart';
import 'route_transitions.dart';

// ============================================================================
// IMPORTS DE TELAS
// ============================================================================

// Telas reais que existem no projeto
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';

// Providers
import '../../features/auth/presentation/providers/auth_provider.dart';

// Widgets stub para telas que ainda não foram implementadas
import '../widgets/stubs.dart';

/// # Sistema de Roteamento do TagBean
/// 
/// Gerencia toda a navegação do aplicativo usando GoRouter.
/// 
/// ## Estrutura de Rotas:
/// ```
/// /                     ← Splash/Loading
/// ├── /auth
/// │   ├── /login       ← Tela de login
/// │   ├── /register    ← Cadastro
/// │   └── /forgot      ← Recuperar senha
/// ├── /dashboard       ← Tela principal
/// ├── /products        ← Lista de produtos
/// │   ├── /new         ← Novo produto
/// │   └── /:id         ← Detalhes do produto
/// ├── /tags            ← Gerenciar tags
/// │   ├── /bind        ← Vincular tag
/// │   └── /:id         ← Detalhes da tag
/// ├── /reports         ← Relatórios
/// │   ├── /daily       ← Relatório diário
/// │   ├── /monthly     ← Relatório mensal
/// │   └── /custom      ← Relatório customizado
/// └── /settings        ← Configurações
///     ├── /profile     ← Perfil do usuário
///     ├── /store       ← Configurações da loja
///     └── /theme       ← Tema e aparência
/// ```
/// 
/// ## Guards e Redirects:
/// - Autenticação obrigatória para rotas protegidas
/// - Redirect automático após login
/// - Deep linking support
/// 
class AppRouter {
  final Ref _ref;
  
  AppRouter(this._ref);
  
  late final router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    
    // Redirect logic
    redirect: (context, state) async {
      final authState = _ref.read(authProvider);
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      
      // Se não está autenticado e não está em rota de auth, redireciona para login
      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }
      
      // Se está autenticado e está em rota de auth, redireciona para dashboard
      if (isAuthenticated && isAuthRoute) {
        return AppRoutes.dashboard;
      }
      
      // Se está no splash e já está autenticado, vai para dashboard
      if (state.matchedLocation == AppRoutes.splash && isAuthenticated) {
        return AppRoutes.dashboard;
      }
      
      return null;
    },
    
    // Error handler
    errorBuilder: (context, state) => ErrorPage(error: state.error),
    
    // Routes
    routes: [
      // Splash/Loading
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashPage(),
          transitionsBuilder: RouteTransitions.fade,
        ),
      ),
      
      // Auth routes
      GoRoute(
        path: '/auth',
        name: 'auth',
        redirect: (_, __) => AppRoutes.login,
        routes: [
          GoRoute(
            path: 'login',
            name: 'login',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const LoginScreen(),
              transitionsBuilder: RouteTransitions.slideFromBottom,
            ),
          ),
          GoRoute(
            path: 'forgot',
            name: 'forgot-password',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ForgotPasswordScreen(),
              transitionsBuilder: RouteTransitions.slideFromBottom,
            ),
          ),
          GoRoute(
            path: 'reset',
            name: 'reset-password',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ResetPasswordScreen(emailOrUsername: ''),
              transitionsBuilder: RouteTransitions.slideFromBottom,
            ),
          ),
        ],
      ),
      
      // Main app shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Dashboard
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const DashboardPage(),
            ),
          ),
          
          // Products
          GoRoute(
            path: '/products',
            name: 'products',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProductsPage(),
            ),
            routes: [
              GoRoute(
                path: 'new',
                name: 'new-product',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const NewProductPage(),
                  transitionsBuilder: RouteTransitions.slideFromRight,
                ),
              ),
              GoRoute(
                path: ':id',
                name: 'product-details',
                pageBuilder: (context, state) {
                  final productId = state.pathParameters['id']!;
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: ProductDetailsPage(productId: productId),
                    transitionsBuilder: RouteTransitions.slideFromRight,
                  );
                },
              ),
            ],
          ),
          
          // Tags
          GoRoute(
            path: '/tags',
            name: 'tags',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const TagsPage(),
            ),
            routes: [
              GoRoute(
                path: 'bind',
                name: 'bind-tag',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const BindTagPage(),
                  transitionsBuilder: RouteTransitions.slideFromBottom,
                ),
              ),
              GoRoute(
                path: ':id',
                name: 'tag-details',
                pageBuilder: (context, state) {
                  final tagId = state.pathParameters['id']!;
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: TagDetailsPage(tagId: tagId),
                    transitionsBuilder: RouteTransitions.slideFromRight,
                  );
                },
              ),
            ],
          ),
          
          // Reports
          GoRoute(
            path: '/reports',
            name: 'reports',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ReportsPage(),
            ),
            routes: [
              GoRoute(
                path: 'daily',
                name: 'daily-report',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const DailyReportPage(),
                  transitionsBuilder: RouteTransitions.slideFromRight,
                ),
              ),
              GoRoute(
                path: 'monthly',
                name: 'monthly-report',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const MonthlyReportPage(),
                  transitionsBuilder: RouteTransitions.slideFromRight,
                ),
              ),
              GoRoute(
                path: 'custom',
                name: 'custom-report',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const CustomReportPage(),
                  transitionsBuilder: RouteTransitions.slideFromRight,
                ),
              ),
            ],
          ),
          
          // Settings
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SettingsPage(),
            ),
            routes: [
              GoRoute(
                path: 'profile',
                name: 'profile',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ProfilePage(),
                  transitionsBuilder: RouteTransitions.slideFromRight,
                ),
              ),
              GoRoute(
                path: 'store',
                name: 'store-settings',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const StoreSettingsPage(),
                  transitionsBuilder: RouteTransitions.slideFromRight,
                ),
              ),
              GoRoute(
                path: 'theme',
                name: 'theme-settings',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ThemeSettingsPage(),
                  transitionsBuilder: RouteTransitions.slideFromRight,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Provider para o router
final appRouterProvider = Provider<AppRouter>((ref) {
  return AppRouter(ref);
});

/// Provider para GoRouter
final goRouterProvider = Provider<GoRouter>((ref) {
  return ref.watch(appRouterProvider).router;
});
