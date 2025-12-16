import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider global para o NavigationService
final navigationServiceProvider = Provider<NavigationService>((ref) {
  return NavigationService();
});

/// Serviço centralizado de navegação
/// 
/// Permite navegação de qualquer lugar do app sem acesso ao BuildContext
class NavigationService {
  /// GlobalKey para acessar o NavigatorState
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Contexto atual (se disponível)
  BuildContext? get context => navigatorKey.currentContext;

  /// NavigatorState atual
  NavigatorState? get navigator => navigatorKey.currentState;

  /// Navega para uma rota nomeada
  Future<T?>? navigateTo<T>(String routeName, {Object? arguments}) {
    return navigator?.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Navega e substitui a rota atual
  Future<T?>? navigateReplaceTo<T>(String routeName, {Object? arguments}) {
    return navigator?.pushReplacementNamed<T, dynamic>(
      routeName,
      arguments: arguments,
    );
  }

  /// Navega e remove todas as rotas anteriores
  Future<T?>? navigateAndRemoveAll<T>(String routeName, {Object? arguments}) {
    return navigator?.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Navega e remove até encontrar a rota especificada
  Future<T?>? navigateAndRemoveUntil<T>(
    String routeName,
    String untilRouteName, {
    Object? arguments,
  }) {
    return navigator?.pushNamedAndRemoveUntil<T>(
      routeName,
      ModalRoute.withName(untilRouteName),
      arguments: arguments,
    );
  }

  /// Volta para a tela anterior
  void goBack<T>([T? result]) {
    if (navigator?.canPop() ?? false) {
      navigator?.pop<T>(result);
    }
  }

  /// Volta até a rota especificada
  void popUntil(String routeName) {
    navigator?.popUntil(ModalRoute.withName(routeName));
  }

  /// Volta para a primeira rota (root)
  void popToFirst() {
    navigator?.popUntil((route) => route.isFirst);
  }

  /// Verifica se pode voltar
  bool canGoBack() {
    return navigator?.canPop() ?? false;
  }

  /// Navega com uma rota personalizada (PageRouteBuilder, etc.)
  Future<T?>? navigateWithRoute<T>(Route<T> route) {
    return navigator?.push<T>(route);
  }

  /// Navega para um widget diretamente
  Future<T?>? navigateToWidget<T>(Widget widget, {String? routeName}) {
    return navigator?.push<T>(
      MaterialPageRoute<T>(
        builder: (context) => widget,
        settings: RouteSettings(name: routeName),
      ),
    );
  }

  /// Navega com transição customizada
  Future<T?>? navigateWithTransition<T>({
    required Widget page,
    required Duration duration,
    Curve curve = Curves.easeInOut,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    return navigator?.push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: transitionsBuilder ??
            (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation.drive(CurveTween(curve: curve)),
                child: child,
              );
            },
      ),
    );
  }

  /// Exibe um dialog modal
  Future<T?> showAppDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
  }) async {
    if (context == null) return null;

    return showDialog<T>(
      context: context!,
      barrierDismissible: barrierDismissible,
      builder: (_) => dialog,
    );
  }

  /// Exibe um BottomSheet modal
  Future<T?> showAppBottomSheet<T>({
    required Widget Function(BuildContext) builder,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    ShapeBorder? shape,
  }) async {
    if (context == null) return null;

    return showModalBottomSheet<T>(
      context: context!,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
      builder: builder,
    );
  }
}

/// Rotas nomeadas da aplicação
class AppRoutes {
  AppRoutes._();

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Main
  static const String dashboard = '/dashboard';
  static const String home = '/';

  // Products
  static const String products = '/products';
  static const String productList = '/products/list';
  static const String productDetails = '/products/details';
  static const String productAdd = '/products/add';
  static const String productEdit = '/products/edit';
  static const String productStock = '/products/stock';
  static const String productImport = '/products/import';
  static const String productQr = '/products/qr';

  // Tags
  static const String tags = '/tags';
  static const String tagList = '/tags/list';
  static const String tagDetails = '/tags/details';
  static const String tagBind = '/tags/bind';
  static const String tagBatch = '/tags/batch';
  static const String tagDiagnostic = '/tags/diagnostic';
  static const String tagStoreMap = '/tags/store-map';
  static const String tagOperations = '/tags/operations';

  // Strategies
  static const String strategies = '/strategies';
  static const String strategyCreate = '/strategies/create';
  static const String strategyDetails = '/strategies/details';
  static const String strategyTemplates = '/strategies/templates';

  // Sync
  static const String sync = '/sync';
  static const String syncHistory = '/sync/history';
  static const String syncConflicts = '/sync/conflicts';

  // Pricing
  static const String pricing = '/pricing';
  static const String priceDetails = '/pricing/details';
  static const String priceSimulator = '/pricing/simulator';
  static const String priceHistory = '/pricing/history';
  static const String priceRules = '/pricing/rules';

  // Categories
  static const String categories = '/categories';
  static const String categoryList = '/categories/list';
  static const String categoryDetails = '/categories/details';
  static const String categoryAdd = '/categories/add';
  static const String categoryEdit = '/categories/edit';

  // Import/Export
  static const String importExport = '/import-export';
  static const String importProducts = '/import/products';
  static const String exportProducts = '/export/products';

  // Reports
  static const String reports = '/reports';
  static const String reportDetails = '/reports/details';

  // Settings
  static const String settings = '/settings';
  static const String settingsProfile = '/settings/profile';
  static const String storeSettings = '/settings/store';
  static const String users = '/settings/users';
  static const String notifications = '/settings/notifications';
  static const String settingsAppearance = '/settings/appearance';
  
  // Developer/Testing
  static const String apiTest = '/dev/api-test';
  static const String fullApiTest = '/dev/full-api-test';
  static const String completeTest = '/dev/complete-test';
}



