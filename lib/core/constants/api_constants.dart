/// Constantes para integração com API Backend (.NET Core)
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

  // Endpoints legados (dados)
  static const String produtos = '/products';
  static String produtoById(String id) => '/products/$id';
  static const String etiquetas = '/tags';
  static String etiquetaByMac(String mac) => '/tags/$mac';
  static const String estrategias = '/strategies';
  static String estrategiaById(String id) => '/strategies/$id';

  // ============================================================================
  // MÉTODOS DE COMPATIBILIDADE (mapeamento de nomes antigos para novos)
  // ============================================================================
  
  // Dashboard
  static String storeStats(String storeId) => stores.stats(storeId);
  static String strategiesByStore(String storeId) => '/stores/$storeId/strategies';
  static String productsByStore(String storeId) => '/stores/$storeId/products';
  static String tagsByStore(String storeId) => tags.byStore(storeId);
  
  // Products
  static const String productsBatch = '/products/batch';
  static String productsStatisticsByStore(String storeId) => '/products/statistics?storeId=$storeId';
  static String productsStockByStore(String storeId) => '/products/stock?storeId=$storeId';
  static String productStock(String productId) => '/products/$productId/stock';
  static const String produtosSearch = '/products/search';
  
  // Tags
  static String tagsPagedByStore(String storeId) => tags.pagedByStore(storeId);
  static String tagsAvailable(String storeId) => tags.available(storeId);
  static String tagsBound(String storeId) => tags.bound(storeId);
  static String tagBinding(String macAddress) => tags.binding(macAddress);
  static String tagBind(String macAddress) => tags.bind(macAddress);
  static String tagUnbind(String macAddress) => tags.unbind(macAddress);
  static const String tagsBatchBind = '/tags/batch/bind';
  static const String tagsBatchUnbind = '/tags/batch/unbind';
  static String tagFlash(String macAddress) => tags.flash(macAddress);
  static String tagRefresh(String macAddress) => tags.refresh(macAddress);
  static const String tagsBatchRefresh = '/tags/batch/refresh';
  static String tagsStoreSync(String storeId) => tags.storeSync(storeId);
  static const String tagsBatch = '/tags/batch';
  
  // Backup
  static String backupById(String backupId) => backup.byId(backupId);
  static String backupRestore(String backupId) => backup.restore(backupId);
  static const String backupConfig = '/backup/config';
  static const String backupCleanup = '/backup/cleanup';
  static String backupDownload(String backupId) => backup.download(backupId);

  // ============================================================================
  // ENDPOINTS ORGANIZADOS POR DOMÍNIO
  // ============================================================================
  static const auth = AuthEndpoints();
  static const clients = ClientsEndpoints();
  static const stores = StoresEndpoints();
  static const products = ProductsEndpoints();
  static const tags = TagsEndpoints();
  static const gateways = GatewaysEndpoints();
  static const strategies = StrategiesEndpoints();
  static const templates = TemplatesEndpoints();
  static const users = UsersEndpoints();
  static const backup = BackupEndpoints();
  static const workContext = WorkContextEndpoints();
}

/// Endpoints de Autenticação (AuthController)
class AuthEndpoints {
  const AuthEndpoints();

  String get login => '/auth/login';
  String get register => '/auth/register';
  String get refreshToken => '/auth/refresh';
  String get changePassword => '/auth/change-password';
  String get users => '/auth/users';
  String userById(String id) => '/auth/users/$id';
  String get workContext => '/auth/work-context';
  String get workContextSwitch => '/auth/work-context/switch';
}

/// Endpoints de Clientes (ClientsController) - PlatformAdmin only
class ClientsEndpoints {
  const ClientsEndpoints();

  String get list => '/clients';
  String byId(String id) => '/clients/$id';
  String deactivate(String id) => '/clients/$id/deactivate';
}

/// Endpoints de Lojas (StoresController)
class StoresEndpoints {
  const StoresEndpoints();

  String get list => '/stores';
  String get paged => '/stores/paged';
  String byId(String id) => '/stores/$id';
  String stats(String id) => '/stores/$id/stats';
  String statistics(String id) => '/stores/$id/statistics';
}

/// Endpoints de Produtos (ProductsController)
class ProductsEndpoints {
  const ProductsEndpoints();

  String get list => '/products';
  String get search => '/products/search';
  String get batch => '/products/batch';
  String byId(String id) => '/products/$id';
  String byStore(String storeId) => '/products/store/$storeId';
  String pagedByStore(String storeId) => '/products/store/$storeId/paged';
  String tags(String id) => '/products/$id/tags';
  String price(String id) => '/products/$id/price';
  String stock(String id) => '/products/$id/stock';
  String statisticsByStore(String storeId) => '/products/store/$storeId/statistics';
  String stockByStore(String storeId) => '/products/store/$storeId/stock';
}

/// Endpoints de Tags/Etiquetas (TagsController)
class TagsEndpoints {
  const TagsEndpoints();

  String get list => '/tags';
  String get batch => '/tags/batch';
  String get batchBind => '/tags/batch/bind';
  String get batchUnbind => '/tags/batch/unbind';
  String get batchRefresh => '/tags/batch/refresh';
  String get callbacks => '/callbacks';
  
  String byMac(String mac) => '/tags/$mac';
  String binding(String mac) => '/tags/$mac/binding';
  String bind(String mac) => '/tags/$mac/bind';
  String unbind(String mac) => '/tags/$mac/unbind';
  String flash(String mac) => '/tags/$mac/flash';
  String refresh(String mac) => '/tags/$mac/refresh';
  
  String byStore(String storeId) => '/tags/store/$storeId';
  String pagedByStore(String storeId) => '/tags/store/$storeId/paged';
  String available(String storeId) => '/tags/store/$storeId/available';
  String bound(String storeId) => '/tags/store/$storeId/bound';
  String storeSync(String storeId) => '/tags/store/$storeId/sync';
}

/// Endpoints de Gateways (GatewaysController)
class GatewaysEndpoints {
  const GatewaysEndpoints();

  String byStore(String storeId) => '/stores/$storeId/gateways';
  String status(String storeId, String gatewayId) => 
      '/stores/$storeId/gateways/$gatewayId/status';
  String reboot(String storeId, String gatewayId) => 
      '/stores/$storeId/gateways/$gatewayId/reboot';
  String sync(String storeId) => '/stores/$storeId/gateways/sync';
}

/// Endpoints de Estratégias (StrategiesController)
class StrategiesEndpoints {
  const StrategiesEndpoints();

  String get list => '/strategies';
  String byId(String id) => '/strategies/$id';
  String byStore(String storeId) => '/strategies/store/$storeId';
  String activate(String id) => '/strategies/$id/activate';
  String deactivate(String id) => '/strategies/$id/deactivate';
  String execute(String id) => '/strategies/$id/execute';
}

/// Endpoints de Templates (TemplatesController)
class TemplatesEndpoints {
  const TemplatesEndpoints();

  String get list => '/templates';
  String get defaults => '/templates/default';
  String byId(String id) => '/templates/$id';
  String byStore(String storeId) => '/templates/store/$storeId';
}

/// Endpoints de Usuários (UsersController)
class UsersEndpoints {
  const UsersEndpoints();

  String get list => '/users';
  String byId(String id) => '/users/$id';
  String roles(String id, String roleName) => '/users/$id/roles/$roleName';
}

/// Endpoints de Backup (BackupController)
class BackupEndpoints {
  const BackupEndpoints();

  String get list => '/backup';
  String get config => '/backup/config';
  String get cleanup => '/backup/cleanup';
  String byId(String id) => '/backup/$id';
  String restore(String id) => '/backup/$id/restore';
  String download(String id) => '/backup/$id/download';
}

/// Endpoints de Work Context
class WorkContextEndpoints {
  const WorkContextEndpoints();

  String get context => '/auth/work-context';
  String get contextSwitch => '/auth/work-context/switch';
}



