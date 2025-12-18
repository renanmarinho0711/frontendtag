import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

import 'package:tagbean/design_system/theme/theme_provider.dart';



import '../core/services/navigation_service.dart';

import '../core/services/feedback_service.dart';

import '../design_system/theme/app_theme.dart';

// REMOVED: import '../shared/models/models.dart';

import '../features/products/data/models/product_models.dart';

// Auth

import '../features/auth/presentation/screens/login_screen.dart';

import '../features/auth/presentation/screens/forgot_password_screen.dart';

import '../features/auth/presentation/screens/reset_password_screen.dart';



// Dashboard

import '../features/dashboard/presentation/screens/dashboard_screen.dart';



// Products

import '../features/products/presentation/screens/products_dashboard_screen.dart';

import '../features/products/presentation/screens/products_list_screen.dart';

import '../features/products/presentation/screens/products_stock_screen.dart';

import '../features/products/presentation/screens/products_import_screen.dart';

import '../features/products/presentation/screens/product_add_screen.dart';

import '../features/products/presentation/screens/product_details_screen.dart';

import '../features/products/presentation/screens/product_edit_screen.dart';



// Tags

import '../features/tags/presentation/screens/tags_dashboard_screen.dart';

import '../features/tags/presentation/screens/tags_list_screen.dart';

import '../features/tags/presentation/screens/tags_diagnostic_screen.dart';

import '../features/tags/presentation/screens/tags_batch_screen.dart';

import '../features/tags/presentation/screens/tags_store_map_screen.dart';



// Categories

import '../features/categories/presentation/screens/categories_menu_screen.dart';

import '../features/categories/presentation/screens/categories_list_screen.dart';

import '../features/categories/presentation/screens/category_add_screen.dart';

import '../features/categories/presentation/screens/category_edit_screen.dart';

import '../features/categories/data/models/category_models.dart';



// Strategies

import '../features/strategies/presentation/screens/strategies_panel_screen.dart';



// Sync

import '../features/sync/presentation/screens/sync_control_screen.dart';

import '../features/sync/presentation/screens/sync_log_screen.dart';



// Pricing

import '../features/pricing/presentation/screens/pricing_menu_screen.dart';



// Reports

import '../features/reports/presentation/screens/reports_menu_screen.dart';



// Settings

import '../features/settings/presentation/screens/settings_menu_screen.dart';

import '../features/settings/presentation/screens/store_settings_screen.dart';

import '../features/settings/presentation/screens/users_screen.dart';

import '../features/settings/presentation/screens/notifications_screen.dart';



// Import/Export

import '../features/import_export/presentation/screens/import_menu_screen.dart';



/// Widget principal da aplicação TagBean

class TagBeanApp extends ConsumerWidget {

  const TagBeanApp({super.key});



  @override

  Widget build(BuildContext context, WidgetRef ref) {

    final navigationService = ref.watch(navigationServiceProvider);

    final feedbackService = ref.watch(feedbackServiceProvider);

    

    // Observa o tema atual para aplicar cores dinâmicas

    final themeColors = ref.watch(dynamicThemeColorsProvider);

    debugPrint('?? TEMA ATUAL: ${themeColors.themeId}');



    // Configura o provider de contexto para o FeedbackService

    feedbackService.setContextProvider(() => navigationService.context);



    return ThemeColors(

      colors: themeColors,

      child: MaterialApp(

        title: 'TagBean',

        debugShowCheckedModeBanner: false,



        // Tema dinâmico baseado na seleção do Usuário

        theme: AppTheme.generateTheme(

          primaryColor: themeColors.primary,

          secondaryColor: themeColors.secondary,

        ),

        darkTheme: AppTheme.darkTheme,

        themeMode: ThemeMode.light,



        // Navegação

        navigatorKey: navigationService.navigatorKey,

        scaffoldMessengerKey: feedbackService.scaffoldMessengerKey,



        // Rotas

        initialRoute: AppRoutes.login,

        routes: _buildRoutes(),

        onGenerateRoute: _generateRoute,

        onUnknownRoute: _unknownRoute,

      ),

    );

  }



  /// Mapa de rotas estáticas

  Map<String, WidgetBuilder> _buildRoutes() {

    return {

      // Auth

      AppRoutes.login: (context) => const LoginScreen(),

      AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),

      // ResetPasswordScreen requer emailOrUsername - usa onGenerateRoute



      // Main

      AppRoutes.dashboard: (context) => const DashboardScreen(),

      AppRoutes.home: (context) => const DashboardScreen(),



      // Products

      AppRoutes.products: (context) => const ProdutosDashboardScreen(),

      AppRoutes.productList: (context) => const ProdutosListaScreen(),

      AppRoutes.productStock: (context) => const ProdutosEstoqueScreen(),

      AppRoutes.productImport: (context) => const ProdutosImportarScreen(),

      AppRoutes.productAdd: (context) => const ProdutosAdicionarScreen(),



      // Tags

      AppRoutes.tags: (context) => const TagsDashboardScreen(),

      AppRoutes.tagList: (context) => const EtiquetasListaScreen(),

      AppRoutes.tagDiagnostic: (context) => const TagsDiagnosticoScreen(),

      AppRoutes.tagBatch: (context) => const EtiquetasOperacoesLoteScreen(),

      AppRoutes.tagStoreMap: (context) => const TagsMapaLojaScreen(),



      // Strategies

      AppRoutes.strategies: (context) => const EstrategiasMenuScreen(),



      // Sync

      AppRoutes.sync: (context) => const SincronizacaoControleScreen(),

      AppRoutes.syncHistory: (context) => const SincronizacaoLogScreen(),



      // Pricing

      AppRoutes.pricing: (context) => const PrecificacaoMenuScreen(),



      // Categories

      AppRoutes.categories: (context) => const CategoriasMenuScreen(),

      AppRoutes.categoryList: (context) => const CategoriasListaScreen(),

      AppRoutes.categoryAdd: (context) => const CategoriasAdicionarScreen(),



      // Import/Export

      AppRoutes.importExport: (context) => const ImportacaoMenuScreen(),



      // Reports

      AppRoutes.reports: (context) => const RelatoriosMenuScreen(),



      // Settings

      AppRoutes.settings: (context) => const ConfiguracoesMenuScreen(),

      AppRoutes.storeSettings: (context) => const ConfiguracoesLojaScreen(),

      AppRoutes.users: (context) => const ConfiguracoesUsuariosScreen(),

      AppRoutes.notifications: (context) => const ConfiguracoesNotificacoesScreen(),

    };

  }



  /// Gerador de rotas dinâmicas (com parâmetros)

  Route<dynamic>? _generateRoute(RouteSettings settings) {

    // Extrai argumentos

    final args = settings.arguments;



    switch (settings.name) {

      // Product Details - recebe ProductModel

      case AppRoutes.productDetails:

        if (args != null) {

          return MaterialPageRoute(

            builder: (_) => ProdutosDetalhesScreen(product: args as ProductModel),

            settings: settings,

          );

        }

        break;



      // Product Edit - recebe ProductModel

      case AppRoutes.productEdit:

        if (args != null) {

          return MaterialPageRoute(

            builder: (_) => ProdutosEditarScreen(product: args as ProductModel),

            settings: settings,

          );

        }

        break;



      // Category Edit - recebe CategoryModel

      case AppRoutes.categoryEdit:

        if (args is CategoryModel) {

          return MaterialPageRoute(

            builder: (_) => CategoriasEditarScreen(categoria: args),

            settings: settings,

          );

        }

        break;



      // Reset Password - recebe emailOrUsername

      case AppRoutes.resetPassword:

        if (args is String) {

          return MaterialPageRoute(

            builder: (_) => ResetPasswordScreen(emailOrUsername: args),

            settings: settings,

          );

        }

        break;

    }



    // Se não encontrou, retorna null para usar onUnknownRoute

    return null;

  }



  /// Rota para páginas não encontradas

  Route<dynamic> _unknownRoute(RouteSettings settings) {

    return MaterialPageRoute(

      builder: (context) => Scaffold(

        appBar: AppBar(title: const Text('Página não encontrada')),

        body: Center(

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Icon(

                Icons.error_outline,

                size: 80,

                color: ThemeColors.of(context).grey500,

              ),

              const SizedBox(height: 16),

              Text(

                'Rota "${settings.name}" não encontrada',

                style: Theme.of(context).textTheme.titleMedium,

              ),

              const SizedBox(height: 24),

              ElevatedButton(

                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(

                  AppRoutes.dashboard,

                  (route) => false,

                ),

                child: const Text('Voltar ao início'),

              ),

            ],

          ),

        ),

      ),

      settings: settings,

    );

  }

}







