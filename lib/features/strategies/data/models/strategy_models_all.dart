/// Strategy Models - Barrel File
/// 
/// Este arquivo exporta todos os modelos de estratgia do módulo.
/// Permite importar todos os modelos com um nico import:
/// 
/// ```dart
/// import 'package:tagbean/features/strategies/data/models/strategy_models_all.dart';
/// ```
library;

// Modelos base de estratgia
export 'strategy_base_models.dart';

// Modelos de calendrio e eventos
export 'calendar_models.dart';

// Modelos de eventos esportivos
export 'sports_models.dart';

// Modelos de temperatura e ambiente
export 'environmental_models.dart';

// Modelos de horrios de pico e performance
export 'performance_models.dart';

// Modelos de liquidação automtica (hide duplicates)
export 'clearance_models.dart' hide MarkdownRuleModel, MarkdownProductModel, MarkdownHistoryModel;

// Modelos de markdown por validade (canonical MarkdownRuleModel, MarkdownProductModel)
export 'markdown_models.dart';

// Modelos de previso com IA (hide duplicates)
export 'forecast_models.dart' hide AuditVerificationModel, AuditRecordModel;

// Modelos de auditoria automtica (canonical AuditVerificationModel, AuditRecordModel)
export 'audit_models.dart';

// Modelos de engajamento visual (heatmap, ranking, promos, rotas)
export 'engagement_models.dart';

// Modelos de cross-selling
export 'cross_selling_models.dart';




