import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/reports/data/models/report_models.dart';
import 'package:tagbean/features/reports/data/repositories/reports_repository.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/core/enums/loading_status.dart';

// =============================================================================
// REPOSITORY PROVIDER
// =============================================================================

/// Provider do ReportsRepository
final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository();
});

// =============================================================================
// SALES REPORTS STATE
// =============================================================================

class SalesReportsState {
  final LoadingStatus status;
  final List<SalesReportModel> reports;
  final String periodoSelecionado;
  final String visualizacao; // 'cards', 'list', 'chart'
  final String? error;

  const SalesReportsState({
    this.status = LoadingStatus.initial,
    this.reports = const [],
    this.periodoSelecionado = '30 dias',
    this.visualizacao = 'cards',
    this.error,
  });

  /// Total de vendas (soma de todos os valorNumerico)
  double get totalVendas => reports.fold(0.0, (sum, r) => sum + r.valorNumerico);
  
  /// Total de vendas formatado
  String get totalVendasFormatted {
    final total = totalVendas;
    if (total >= 1000000) {
      return 'R\$ ${(total / 1000000).toStringAsFixed(2).replaceAll('.', ',')}M';
    } else if (total >= 1000) {
      return 'R\$ ${(total / 1000).toStringAsFixed(1).replaceAll('.', ',')}K';
    }
    return 'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}';
  }
  
  /// Total de itens vendidos
  int get totalItensVendidos => reports.fold(0, (sum, r) => sum + r.quantidadeNumerica);
  
  /// Ticket Médio
  double get ticketMedio => totalItensVendidos > 0 ? totalVendas / totalItensVendidos : 0.0;
  
  /// Ticket Médio formatado
  String get ticketMedioFormatted {
    final ticket = ticketMedio;
    return 'R\$ ${ticket.toStringAsFixed(2).replaceAll('.', ',')}';
  }
  
  /// Crescimento Médio
  String get crescimentoMedio {
    if (reports.isEmpty) return '0%';
    // Pega o crescimento do primeiro relatãrio ou calcula mãdia
    final report = reports.isNotEmpty ? reports.first : null;
    return report?.crescimento ?? '0%';
  }
  
  /// Total de produtos vendidos (diferentes)
  int get totalProdutosVendidos => reports.length;

  SalesReportsState copyWith({
    LoadingStatus? status,
    List<SalesReportModel>? reports,
    String? periodoSelecionado,
    String? visualizacao,
    String? error,
  }) {
    return SalesReportsState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      periodoSelecionado: periodoSelecionado ?? this.periodoSelecionado,
      visualizacao: visualizacao ?? this.visualizacao,
      error: error ?? this.error,
    );
  }

  factory SalesReportsState.initial() => const SalesReportsState();
}

class SalesReportsNotifier extends StateNotifier<SalesReportsState> {
  final ReportsRepository _repository;
  
  SalesReportsNotifier(this._repository) : super(SalesReportsState.initial());

  Future<void> loadReports() async {
    state = state.copyWith(status: LoadingStatus.loading, error: null);
    
    try {
      // API: GET /api/reports/sales
      final response = await _repository.getSalesReport(
        periodo: state.periodoSelecionado.replaceAll(' ', ''),
      );
      
      if (response.isSuccess && response.data != null) {
        // Parsear resposta da API
        final data = response.data!;
        final apiReports = <SalesReportModel>[];
        
        // Suporta formato antigo (items) e novo (Items do backend)
        final items = data['reports'] ?? data['items'] ?? data['Items'] ?? [];
        if (items is List) {
          for (final item in items) {
            apiReports.add(SalesReportModel(
              id: item['id']?.toString() ?? '',
              titulo: (item['titulo']).toString() ?? item['title'] ?? '',
              subtitulo: (item['subtitulo']).toString() ?? item['subtitle'] ?? '',
              icone: Icons.trending_up_rounded,
              cor: AppThemeColors.success,
              valor: (item['valor']).toString() ?? item['value'] ?? '',
              valorNumerico: ((item['valorNumerico'] ?? item['numericValue'] ?? 0) as num?)?.toDouble() ?? 0.0,
              quantidade: (item['quantidade']).toString() ?? item['quantity'] ?? '',
              quantidadeNumerica: (((item['quantidadeNumerica'] ?? item['numericQuantity'] ?? 0) as int?) ?? 0),
              detalhes: (item['detalhes']).toString() ?? item['details'] ?? '',
              meta: (item['meta']).toString() ?? item['target'] ?? '',
              percentual: ((item['percentual'] ?? item['percentage'] ?? item['Percentual'] ?? 0) as num?)?.toDouble() ?? 0.0,
              trend: _parseTrend(item['trend'] ?? item['Trend']),
              crescimento: (item['crescimento']).toString() ?? item['growth'] ?? item['Crescimento'] ?? '',
              badge: (item['badge']).toString() ?? item['Badge'],
            ));
          }
        }
        
        state = state.copyWith(
          status: LoadingStatus.success,
          reports: apiReports,
          error: null,
        );
      } else {
        // ERRO: API retornou falha - NãO usar mock silenciosamente
        state = state.copyWith(
          status: LoadingStatus.error,
          error: response.message ?? 'Erro ao carregar relatórios da API',
          reports: [],
        );
      }
    } catch (e) {
      // ERRO: Exceãão na chamada - mostrar erro ao Usuário
      state = state.copyWith(
        status: LoadingStatus.error,
        error: 'Falha ao conectar com o servidor: ${e.toString()}',
        reports: [],
      );
    }
  }
  
  ReportTrend _parseTrend(dynamic trend) {
    if (trend == null) return ReportTrend.stable;
    final trendStr = trend.toString().toLowerCase();
    if (trendStr == 'up') return ReportTrend.up;
    if (trendStr == 'down') return ReportTrend.down;
    return ReportTrend.stable;
  }

  void setPeriodo(String periodo) {
    state = state.copyWith(periodoSelecionado: periodo);
    loadReports();
  }

  void setVisualizacao(String visualizacao) {
    state = state.copyWith(visualizacao: visualizacao);
  }

  // _getMockSalesReports removido - agora usa dados reais do backend
}

// =============================================================================
// AUDIT REPORTS STATE
// =============================================================================

class AuditReportsState {
  final LoadingStatus status;
  final List<AuditReportModel> reports;
  final String? error;

  const AuditReportsState({
    this.status = LoadingStatus.initial,
    this.reports = const [],
    this.error,
  });

  int get totalAuditorias => reports.length;
  int get auditoriasComProblemas => reports.where((r) => r.hasProblems).length;
  double get conformidadeMedia => 
      reports.isNotEmpty 
          ? reports.fold(0.0, (sum, r) => sum + r.percentualConformidade) / reports.length 
          : 0;

  AuditReportsState copyWith({
    LoadingStatus? status,
    List<AuditReportModel>? reports,
    String? error,
  }) {
    return AuditReportsState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      error: error ?? this.error,
    );
  }

  factory AuditReportsState.initial() => const AuditReportsState();
}

class AuditReportsNotifier extends StateNotifier<AuditReportsState> {
  final ReportsRepository _repository;
  
  AuditReportsNotifier(this._repository) : super(AuditReportsState.initial());

  Future<void> loadReports() async {
    state = state.copyWith(status: LoadingStatus.loading, error: null);
    
    try {
      // API: GET /api/reports/audit
      final response = await _repository.getAuditReport();
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final apiReports = <AuditReportModel>[];
        
        final events = data['events'] ?? data['Events'] ?? data['reports'] ?? [];
        if (events is List) {
          for (final item in events) {
            apiReports.add(AuditReportModel(
              id: item['id']?.toString() ?? '',
              titulo: (item['titulo']).toString() ?? item['title'] ?? item['tipo'] ?? item['Tipo'] ?? '',
              descricao: (item['descricao']).toString() ?? item['description'] ?? item['Descricao'] ?? '',
              dataAuditoria: DateTime.tryParse((item['dataAuditoria']).toString() ?? item['auditDate'] ?? item['dataHora'] ?? item['DataHora'] ?? '') ?? DateTime.now(),
              auditor: (item['auditor']).toString() ?? item['usuario'] ?? item['Usuario'] ?? 'Sistema',
              // ignore: argument_type_not_assignable
              itensVerificados: item['itensVerificados'] ?? item['itemsVerified'] ?? 1,
              // ignore: argument_type_not_assignable
              itensComProblema: item['itensComProblema'] ?? item['itemsWithProblem'] ?? 0,
              percentualConformidade: ((item['percentualConformidade'] ?? item['compliancePercentage'] ?? 100) as num?)?.toDouble() ?? 100.0,
              itens: [],
            ));
          }
        }
        
        state = state.copyWith(
          status: LoadingStatus.success,
          reports: apiReports,
          error: null,
        );
      } else {
        state = state.copyWith(
          status: LoadingStatus.error,
          error: response.message ?? 'Erro ao carregar relatãrio de auditoria',
          reports: [],
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: LoadingStatus.error,
        error: 'Falha ao conectar com o servidor: ${e.toString()}',
        reports: [],
      );
    }
  }
  
  // _getMockAuditReports removido - agora usa dados reais do backend
}

// =============================================================================
// OPERATIONAL REPORTS STATE
// =============================================================================

class OperationalReportsState {
  final LoadingStatus status;
  final List<OperationalReportModel> reports;
  final String? error;

  const OperationalReportsState({
    this.status = LoadingStatus.initial,
    this.reports = const [],
    this.error,
  });

  OperationalReportsState copyWith({
    LoadingStatus? status,
    List<OperationalReportModel>? reports,
    String? error,
  }) {
    return OperationalReportsState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      error: error ?? this.error,
    );
  }

  factory OperationalReportsState.initial() => const OperationalReportsState();
}

class OperationalReportsNotifier extends StateNotifier<OperationalReportsState> {
  final ReportsRepository _repository;
  
  OperationalReportsNotifier(this._repository) : super(OperationalReportsState.initial());

  Future<void> loadReports() async {
    state = state.copyWith(status: LoadingStatus.loading, error: null);
    
    try {
      // API: GET /api/reports/operational
      final response = await _repository.getOperationalReport();
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final apiReports = <OperationalReportModel>[];
        
        final items = data['items'] ?? data['Items'] ?? data['reports'] ?? [];
        if (items is List) {
          for (final item in items) {
            apiReports.add(OperationalReportModel(
              id: item['id']?.toString() ?? '',
              titulo: (item['titulo']).toString() ?? item['title'] ?? item['Titulo'] ?? '',
              categoria: (item['categoria']).toString() ?? item['category'] ?? 'Operacional',
              icone: Icons.analytics_rounded,
              cor: AppThemeColors.primary,
              valor: (item['valor']).toString() ?? item['value'] ?? item['Valor'] ?? '',
              unidade: (item['unidade']).toString() ?? item['unit'] ?? '',
              percentualMeta: ((item['percentualMeta'] ?? item['targetPercentage'] ?? 0) as num?)?.toDouble() ?? 0.0,
              trend: _parseTrend(item['trend'] ?? item['status'] ?? item['Status']),
              periodo: (item['periodo']).toString() ?? item['period'] ?? '',
            ));
          }
        }
        
        state = state.copyWith(
          status: LoadingStatus.success,
          reports: apiReports,
          error: null,
        );
      } else {
        state = state.copyWith(
          status: LoadingStatus.error,
          error: response.message ?? 'Erro ao carregar relatãrio operacional',
          reports: [],
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: LoadingStatus.error,
        error: 'Falha ao conectar com o servidor: ${e.toString()}',
        reports: [],
      );
    }
  }
  
  ReportTrend _parseTrend(dynamic trend) {
    if (trend == null) return ReportTrend.stable;
    final trendStr = trend.toString().toLowerCase();
    if (trendStr == 'up') return ReportTrend.up;
    if (trendStr == 'down') return ReportTrend.down;
    return ReportTrend.stable;
  }
  
  // _getMockOperationalReports removido - agora usa dados reais do backend
}

// =============================================================================
// PERFORMANCE REPORTS STATE
// =============================================================================

class PerformanceReportsState {
  final LoadingStatus status;
  final List<PerformanceReportModel> reports;
  final String? error;

  const PerformanceReportsState({
    this.status = LoadingStatus.initial,
    this.reports = const [],
    this.error,
  });

  int get metasAtingidas => reports.where((r) => r.metaAtingida).length;
  double get percentualMetasAtingidas => 
      reports.isNotEmpty ? (metasAtingidas / reports.length) * 100 : 0;

  /// Potencial de ganho mensal (soma das variações positivas * 1000)
  double get potencialGanhoMensal {
    return reports
        .where((r) => r.variacao > 0)
        .fold(0.0, (sum, r) => sum + (r.variacao * 100));
  }
  
  /// Potencial de ganho formatado
  String get potencialGanhoFormatted {
    final potencial = potencialGanhoMensal;
    if (potencial >= 1000) {
      return 'R\$ ${(potencial / 1000).toStringAsFixed(2).replaceAll('.', ',')}K/mãs';
    }
    return 'R\$ ${potencial.toStringAsFixed(0)}/mãs';
  }
  
  /// Ações urgentes (reports com variAção negativa)
  int get acoesUrgentes => reports.where((r) => r.variacao < 0 && !r.metaAtingida).length;
  
  /// Oportunidades de crescimento (reports com trend positivo)
  int get oportunidadesCrescimento => reports.where((r) => r.trend == ReportTrend.up).length;
  
  /// Crescimento previsto (mãdia das variações positivas)
  double get crescimentoPrevisto {
    final positivos = reports.where((r) => r.variacao > 0).toList();
    if (positivos.isEmpty) return 0;
    return positivos.fold(0.0, (sum, r) => sum + r.variacao) / positivos.length;
  }
  
  /// Crescimento previsto formatado
  String get crescimentoPrevistoFormatted {
    return '+${crescimentoPrevisto.toStringAsFixed(0)}% crescimento em 60 dias';
  }

  PerformanceReportsState copyWith({
    LoadingStatus? status,
    List<PerformanceReportModel>? reports,
    String? error,
  }) {
    return PerformanceReportsState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      error: error ?? this.error,
    );
  }

  factory PerformanceReportsState.initial() => const PerformanceReportsState();
}

class PerformanceReportsNotifier extends StateNotifier<PerformanceReportsState> {
  final ReportsRepository _repository;
  
  PerformanceReportsNotifier(this._repository) : super(PerformanceReportsState.initial());

  Future<void> loadReports() async {
    state = state.copyWith(status: LoadingStatus.loading, error: null);
    
    try {
      // API: GET /api/reports/performance
      final response = await _repository.getPerformanceReport();
      
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final apiReports = <PerformanceReportModel>[];
        
        final items = data['items'] ?? data['Items'] ?? data['reports'] ?? [];
        if (items is List) {
          for (final item in items) {
            apiReports.add(PerformanceReportModel(
              id: item['id']?.toString() ?? '',
              metrica: (item['metrica']).toString() ?? item['metric'] ?? item['titulo'] ?? item['Titulo'] ?? '',
              descricao: (item['descricao']).toString() ?? item['description'] ?? '',
              valorAtual: ((item['valorAtual'] ?? item['currentValue'] ?? item['percentual'] ?? item['Percentual'] ?? 0) as num?)?.toDouble() ?? 0.0,
              valorAnterior: ((item['valorAnterior'] ?? item['previousValue'] ?? 0) as num?)?.toDouble() ?? 0.0,
              meta: ((item['meta'] ?? item['target'] ?? 100) as num?)?.toDouble() ?? 100.0,
              unidade: (item['unidade']).toString() ?? item['unit'] ?? item['valor'] ?? item['Valor'] ?? '',
              trend: _parseTrend(item['trend'] ?? item['Trend']),
              variacao: ((item['variacao'] ?? item['variation'] ?? 0) as num?)?.toDouble() ?? 0.0,
            ));
          }
        }
        
        state = state.copyWith(
          status: LoadingStatus.success,
          reports: apiReports,
          error: null,
        );
      } else {
        state = state.copyWith(
          status: LoadingStatus.error,
          error: response.message ?? 'Erro ao carregar relatãrio de performance',
          reports: [],
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: LoadingStatus.error,
        error: 'Falha ao conectar com o servidor: ${e.toString()}',
        reports: [],
      );
    }
  }
  
  ReportTrend _parseTrend(dynamic trend) {
    if (trend == null) return ReportTrend.stable;
    final trendStr = trend.toString().toLowerCase();
    if (trendStr == 'up') return ReportTrend.up;
    if (trendStr == 'down') return ReportTrend.down;
    return ReportTrend.stable;
  }
  
  // _getMockPerformanceReports removido - agora usa dados reais do backend
}

// =============================================================================
// PROVIDERS
// =============================================================================

/// Provider de relatórios de vendas
final salesReportsProvider = StateNotifierProvider<SalesReportsNotifier, SalesReportsState>(
  (ref) {
    final repository = ref.watch(reportsRepositoryProvider);
    return SalesReportsNotifier(repository);
  },
);

/// Provider de relatórios de auditoria
final auditReportsProvider = StateNotifierProvider<AuditReportsNotifier, AuditReportsState>(
  (ref) {
    final repository = ref.watch(reportsRepositoryProvider);
    return AuditReportsNotifier(repository);
  },
);

/// Provider de relatórios operacionais
final operationalReportsProvider = StateNotifierProvider<OperationalReportsNotifier, OperationalReportsState>(
  (ref) {
    final repository = ref.watch(reportsRepositoryProvider);
    return OperationalReportsNotifier(repository);
  },
);

/// Provider de relatórios de performance
final performanceReportsProvider = StateNotifierProvider<PerformanceReportsNotifier, PerformanceReportsState>(
  (ref) {
    final repository = ref.watch(reportsRepositoryProvider);
    return PerformanceReportsNotifier(repository);
  },
);




