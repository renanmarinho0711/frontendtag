// Constantes para integração com API Backend (.NET Core)
/// Endpoints mapeados conforme TagBean.Api Controllers
class ApiConstants {
  // Prevent instantiation
  ApiConstants._();

  // Base URLs - configurar de acordo com ambiente
  // Para desenvolvimento local com backend .NET:
  // - Windows: http://localhost:5000/api
  // - Android Emulator: http://10.0.2.2:5000/api
  // - iOS Simulator: http://localhost:5000/api
  // - Dispositivo físico: http://<IP_DA_MAQUINA>:5000/api
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5000/api',
  );

  // Timeout padrão para requisições
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(minutes: 5);

  // Headers padrão
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ============================================================================
  // ENDPOINTS - MAPEADOS CONFORME BACKEND .NET
  // ============================================================================

  // === AUTENTICAÇÃO (AuthController) ===
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String changePassword = '/auth/change-password';
  static const String authUsers = '/auth/users';
  static String authUserById(String id) => '/auth/users/$id';

  // === CLIENTES (ClientsController) - PlatformAdmin only ===
  static const String clients = '/clients';
  static String clientById(String id) => '/clients/$id';
  static String clientDeactivate(String id) => '/clients/$id/deactivate';

  // === LOJAS (StoresController) ===
  static const String stores = '/stores';
  static String storeById(String id) => '/stores/$id';
  static String storeStats(String id) => '/stores/$id/stats';
  static String storeStatistics(String id) => '/stores/$id/statistics';
  static const String storesPaged = '/stores/paged';

  // === PRODUTOS (ProductsController) ===
  static const String products = '/products';
  static String productById(String id) => '/products/$id';
  static String productsByStore(String storeId) => '/products/store/$storeId';
  static String productsPagedByStore(String storeId) => '/products/store/$storeId/paged';
  static String productTags(String id) => '/products/$id/tags';
  static String productPrice(String id) => '/products/$id/price';
  static const String produtosSearch = '/products/search';
  static const String productsBatch = '/products/batch';
  // Novos endpoints (conforme relatório de mapeamento)
  static String productStock(String id) => '/products/$id/stock';
  static String productsStatisticsByStore(String storeId) => '/products/store/$storeId/statistics';
  static String productsStockByStore(String storeId) => '/products/store/$storeId/stock';

  // === ETIQUETAS/TAGS (TagsController) ===
  static const String tags = '/tags';
  static String tagByMac(String mac) => '/tags/$mac';
  static String tagsByStore(String storeId) => '/tags/store/$storeId';
  static String tagsPagedByStore(String storeId) => '/tags/store/$storeId/paged';
  static String tagsAvailable(String storeId) => '/tags/store/$storeId/available';
  static String tagsBound(String storeId) => '/tags/store/$storeId/bound';
  static String tagsStoreSync(String storeId) => '/tags/store/$storeId/sync';
  static String tagBinding(String mac) => '/tags/$mac/binding';
  static String tagBind(String mac) => '/tags/$mac/bind';
  static String tagUnbind(String mac) => '/tags/$mac/unbind';
  static String tagFlash(String mac) => '/tags/$mac/flash';
  static String tagRefresh(String mac) => '/tags/$mac/refresh';
  static const String tagsBatch = '/tags/batch';
  static const String tagsBatchBind = '/tags/batch/bind';
  static const String tagsBatchUnbind = '/tags/batch/unbind';
  static const String tagsBatchRefresh = '/tags/batch/refresh';

  // === GATEWAYS (GatewaysController) ===
  static String gatewaysByStore(String storeId) => '/stores/$storeId/gateways';
  static String gatewayStatus(String storeId, String gatewayId) => 
      '/stores/$storeId/gateways/$gatewayId/status';
  static String gatewayReboot(String storeId, String gatewayId) => 
      '/stores/$storeId/gateways/$gatewayId/reboot';
  static String gatewaysSync(String storeId) => '/stores/$storeId/gateways/sync';

  // === ESTRATÉGIAS (StrategiesController) ===
  static const String strategies = '/strategies';
  static String strategyById(String id) => '/strategies/$id';
  static String strategiesByStore(String storeId) => '/strategies/store/$storeId';
  static String strategyActivate(String id) => '/strategies/$id/activate';
  static String strategyDeactivate(String id) => '/strategies/$id/deactivate';
  static String strategyExecute(String id) => '/strategies/$id/execute';

  // === TEMPLATES (TemplatesController) ===
  static const String templates = '/templates';
  static String templateById(String id) => '/templates/$id';
  static String templatesByStore(String storeId) => '/templates/store/$storeId';
  static const String templatesDefault = '/templates/default';

  // === USUÁRIOS (UsersController) ===
  static const String users = '/users';
  static String userById(String id) => '/users/$id';
  static String userRoles(String id, String roleName) => '/users/$id/roles/$roleName';

  // === BACKUP (BackupController) ===
  static const String backup = '/backup';
  static String backupById(String id) => '/backup/$id';
  static String backupRestore(String id) => '/backup/$id/restore';
  static String backupDownload(String id) => '/backup/$id/download';
  static const String backupConfig = '/backup/config';
  static const String backupCleanup = '/backup/cleanup';

  // === CALLBACKS (CallbacksController) - Para webhooks Minew ===
  static const String callbacks = '/callbacks';

  // === WORK CONTEXT ===
  static const String workContext = '/auth/work-context';
  static const String workContextSwitch = '/auth/work-context/switch';

  // ============================================================================
  // ENDPOINTS LEGADOS (mantidos para compatibilidade)
  // ============================================================================
  
  // Produtos (aliases)
  static const String produtos = '/products';
  static String produtoById(String id) => '/products/$id';
  
  // Etiquetas (aliases)  
  static const String etiquetas = '/tags';
  static String etiquetaByMac(String mac) => '/tags/$mac';

  // Estratégias (aliases)
  static const String estrategias = '/strategies';
  static String estrategiaById(String id) => '/strategies/$id';
}



