// TagBean Dashboard Feature
/// 
/// Feature do painel principal.
/// 
/// Uso:
/// ```dart
/// import 'package:tagbean/features/dashboard/dashboard.dart';
/// ```

library dashboard;

// Data Layer
export 'data/models/dashboard_models.dart';
export 'data/repositories/dashboard_repository.dart';

// Presentation Layer
export 'presentation/providers/dashboard_provider.dart';
export 'presentation/screens/dashboard_screen.dart';
export 'presentation/widgets/compact_alerts_card.dart';
export 'presentation/widgets/compact_metrics_grid.dart';
export 'presentation/widgets/compact_sync_card.dart';
export 'presentation/widgets/estrategias_lucro_card.dart';
export 'presentation/widgets/quick_actions_card.dart';
export 'presentation/widgets/recent_activity_card.dart';
export 'presentation/widgets/sugestoes_ia_card.dart';
export 'presentation/widgets/welcome_section.dart';
