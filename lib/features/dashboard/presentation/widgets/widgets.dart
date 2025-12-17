/// Barrel file para todos os widgets do dashboard
/// 
/// Este arquivo exporta todos os widgets usados no dashboard,
/// facilitando imports únicos.
library;

// Cards de métricas e resumo
export 'welcome_section.dart';
export 'resumo_do_dia_card.dart';
export 'compact_metrics_grid.dart';
export 'status_geral_sistema_card.dart';

// Cards de alertas e ações
export 'alertas_acionaveis_card.dart';
export 'acoes_frequentes_card.dart';
export 'quick_actions_card.dart';
export 'compact_alerts_card.dart';

// Cards de estratégias e oportunidades
export 'estrategias_ativas_card.dart';
export 'estrategias_lucro_card.dart';
export 'oportunidades_lucro_card.dart';
export 'sugestoes_ia_card.dart';
export 'fluxos_inteligentes_card.dart';

// Cards de sincronização
export 'compact_sync_card.dart';

// Cards de onboarding e atividade
export 'onboarding_steps_card.dart';
export 'next_action_card.dart';
export 'recent_activity_card.dart';
export 'recent_activity_dashboard_card.dart';

// Cards administrativos
export 'admin_panel_card.dart';

// Cards utilitários (legado - avaliar remoção)
export 'atalhos_rapidos_card.dart';
export 'scanner_central_card.dart';

// Navegação
export 'navigation/navigation.dart';
