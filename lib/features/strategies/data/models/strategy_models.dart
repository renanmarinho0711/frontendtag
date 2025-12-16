// Strategy Models - Barrel File (Compatibilidade)
/// 
/// Este arquivo mant�m compatibilidade com imports existentes.
/// O c�digo foi dividido em m�dulos menores para melhor manuten��o.
/// 
/// Arquivos modulares:
/// - strategy_base_models.dart: Enums e StrategyModel principal
/// - calendar_models.dart: HolidayEventModel, LongHolidayModel, SalaryCycleModel
/// - sports_models.dart: SportsEventModel, SportsTeamModel, SportsGameModel
/// - environmental_models.dart: TemperatureRangeModel, TemperatureHistoryModel
/// - performance_models.dart: PeakHourModel, WeekDayModel, PeakHourHistoryModel
/// - clearance_models.dart: ClearancePhaseModel, ClearanceProductModel
/// - markdown_models.dart: MarkdownRuleModel, MarkdownProductModel
/// - forecast_models.dart: ForecastTrend, ForecastPredictionModel
/// - audit_models.dart: AuditVerificationModel, AuditRecordModel
/// - engagement_models.dart: HeatmapZoneModel, RankingProductModel, FlashPromoModel, SmartRouteModel
/// - cross_selling_models.dart: NearbyProductSuggestionModel, OffersTrailModel, SmartComboModel
///
/// Para novos imports, use:
/// `dart
/// import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
/// `
/// Ou importe m�dulos especficos para melhor tree-shaking:
/// `dart
/// import 'package:tagbean/features/strategies/data/models/calendar_models.dart';
/// `
library;

// Re-exporta todos os modelos para compatibilidade retroativa
export 'strategy_models_all.dart';




