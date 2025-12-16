// Modelos específicos para integração com Minew Cloud.
/// 
/// Este arquivo re-exporta os modelos relacionados à Minew
/// para facilitar imports mais semânticos.
/// 
/// Exemplo:
/// ```dart
/// import 'package:tagbean/features/sync/data/models/minew_models.dart';
/// ```
library;

// Re-exporta modelos de sync_models.dart relacionados à Minew
export 'sync_models.dart' show
    MinewStoreStats,
    StoreSyncSummary,
    SyncOperationResult,
    StatsSyncResult,
    MinewSyncResult,
    ImportTagsResult;
