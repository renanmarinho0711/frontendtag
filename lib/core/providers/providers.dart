/// Providers centralizados do TagBean
/// 
/// Este arquivo exporta todos os providers principais do sistema
/// para facilitar o uso em toda a aplicação.
library providers;

// Core Services
export 'package:tagbean/features/auth/presentation/providers/auth_provider.dart'
    show apiServiceProvider, storageServiceProvider, authProvider, authRepositoryProvider,
         currentUserProvider, isLoggedInProvider, authLoadingProvider, authErrorProvider;

// Connectivity
export 'connectivity_provider.dart'
    show connectivityProvider, connectivityStatusProvider, ConnectivityStatus, ConnectivityStatusX;

// Products
export 'package:tagbean/features/products/presentation/providers/products_state_provider.dart'
    show produtoRepositoryProvider, tagsRepositoryProvider, productsListRiverpodProvider,
         productStatisticsRiverpodProvider, productDetailsRiverpodProvider, 
         stockRiverpodProvider, productImportProvider, tagBindingProvider;

// Tags
export 'package:tagbean/features/tags/presentation/providers/tags_provider.dart';

// Users
export 'package:tagbean/features/settings/presentation/providers/users_provider.dart'
    show usersRepositoryProvider, usersProvider, usersListProvider, filteredUsersProvider,
         usersLoadingProvider, activeUsersCountProvider, inactiveUsersCountProvider;

// Settings
export 'package:tagbean/features/settings/presentation/providers/settings_provider.dart'
    show settingsRepositoryProvider, currentStoreIdProvider, settingsMenuProvider,
         storeSettingsProvider, erpSettingsProvider, notificationSettingsProvider,
         backupProvider;

// Reports
export 'package:tagbean/features/reports/presentation/providers/reports_provider.dart'
    show reportsRepositoryProvider, salesReportsProvider, auditReportsProvider,
         operationalReportsProvider, performanceReportsProvider;



