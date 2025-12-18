/// Models robustos para o módulo Import/Export
/// 
/// Estrutura modularizada:
/// - enums/: Enumerações (ExportFormat, ImportStatus, etc.)
/// - import/: Models relacionados a importação
/// - export/: Models relacionados a exportação
/// - batch/: Models de operações em lote
/// - common/: Models compartilhados (validação, progresso, etc.)
/// - stats/: Models de estatísticas
/// 
/// Este arquivo é um barrel file que re-exporta todos os models
/// para manter compatibilidade com imports existentes.
library import_export_models;

// Enums
export 'enums/enums.dart';

// Import Models
export 'import/import.dart';

// Export Models
export 'export/export.dart';

// Batch/Bulk Operations
export 'batch/batch.dart';

// Common Models
export 'common/common.dart';

// Statistics Models
export 'stats/stats.dart';
