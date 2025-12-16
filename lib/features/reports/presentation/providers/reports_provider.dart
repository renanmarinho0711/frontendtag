import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/reports/data/models/report_models.dart';
import 'package:tagbean/features/reports/data/repositories/reports_repository.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
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
  
  /// Ticket m�dio
  double get ticketMedio => totalItensVendidos > 0 ? totalVendas / totalItensVendidos : 0.0;
  
  /// Ticket m�dio formatado
  String get ticketMedioFormatted {
    final ticket = ticketMedio;
    return 'R\$ ${ticket.toStringAsFixed(2).replaceAll('.', ',')}';
  }
  
  /// Crescimento m�dio
  String get crescimentoMedio {
    if (reports.isEmpty) return '0%';
    // Pega o crescimento do primeiro relat�rio ou calcula m�dia
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
              titulo: item['titulo'] ?? item['title'] ?? '',
              subtitulo: item['subtitulo'] ?? item['subtitle'] ?? '',
              icone: Icons.trending_up_rounded,
              corKey: 'success',
              valor: item['valor'] ?? item['value'] ?? '',
              valorNumerico: (item['valorNumerico'] ?? item['numericValue'] ?? 0).toDouble(),
              quantidade: item['quantidade'] ?? item['quantity'] ?? '',
              quantidadeNumerica: (item['quantidadeNumerica'] ?? item['numericQuantity'] ?? 0).toInt(),
              detalhes: item['detalhes'] ?? item['details'] ?? '',
              meta: item['meta'] ?? item['target'] ?? '',
              percentual: (item['percentual'] ?? item['percentage'] ?? item['Percentual'] ?? 0).toDouble(),
              trend: _parseTrend(item['trend'] ?? item['Trend']),
              crescimento: item['crescimento'] ?? item['growth'] ?? item['Crescimento'] ?? '',
              badge: item['badge'] ?? item['Badge'],
            ));
          }
        }
        
        state = state.copyWith(
          status: LoadingStatus.success,
          reports: apiReports,
          error: null,
        );
      } else {
        // ERRO: API retornou falha - N�O usar mock silenciosamente
        state = state.copyWith(
          status: LoadingStatus.error,
          error: response.message ?? 'Erro ao carregar relat�rios da API',
          reports: [],
        );
      }
    } catch (e) {
      // ERRO: Exce��o na chamada - mostrar erro ao usu�rio
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

  int get totalauditorias => reports.length;
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
              titulo: item['titulo'] ?? item['title'] ?? item['tipo'] ?? item['Tipo'] ?? '',
              descricao: item['descricao'] ?? item['description'] ?? item['Descricao'] ?? '',
              dataauditoria: DateTime.tryParse(item['dataauditoria'] ?? item['auditDate'] ?? item['dataHora'] ?? item['DataHora'] ?? '') ?? DateTime.now(),
              auditor: item['auditor'] ?? item['usuario'] ?? item['Usuario'] ?? 'Sistema',
              itensVerificados: item['itensVerificados'] ?? item['itemsVerified'] ?? 1,
              itensComProblema: item['itensComProblema'] ?? item['itemsWithProblem'] ?? 0,
              percentualConformidade: (item['percentualConformidade'] ?? item['compliancePercentage'] ?? 100).toDouble(),
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
          error: response.message ?? 'Erro ao carregar relat�rio de auditoria',
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
              titulo: item['titulo'] ?? item['title'] ?? item['Titulo'] ?? '',
              categoria: item['categoria'] ?? item['category'] ?? 'Operacional',
              icone: Icons.analytics_rounded,
              corKey: 'primary',
              valor: item['valor'] ?? item['value'] ?? item['Valor'] ?? '',
              unidade: item['unidade'] ?? item['unit'] ?? '',
              percentualMeta: (item['percentualMeta'] ?? item['targetPercentage'] ?? 0).toDouble(),
              trend: _parseTrend(item['trend'] ?? item['status'] ?? item['Status']),
              periodo: item['periodo'] ?? item['period'] ?? '',
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
          error: response.message ?? 'Erro ao carregar relat�rio operacional',
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

  /// Potencial de ganho mensal (soma das varia��es positivas * 1000)
  double get potencialGanhoMensal {
    return reports
        .where((r) => r.variacao > 0)
        .fold(0.0, (sum, r) => sum + (r.variacao * 100));
  }
  
  /// Potencial de ganho formatado
  String get potencialGanhoFormatted {
    final potencial = potencialGanhoMensal;
    if (potencial >= 1000) {
      return 'R\$ ${(potencial / 1000).toStringAsFixed(2).replaceAll('.', ',')}K/m�s';
    }
    return 'R\$ ${potencial.toStringAsFixed(0)}/m�s';
  }
  
  /// A��es urgentes (reports com varia��o negativa)
  int get acoesUrgentes => reports.where((r) => r.variacao < 0 && !r.metaAtingida).length;
  
  /// Oportunidades de crescimento (reports com trend positivo)
  int get oportunidadesCrescimento => reports.where((r) => r.trend == ReportTrend.up).length;
  
  /// Crescimento previsto (m�dia das varia��es positivas)
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
              metrica: item['metrica'] ?? item['metric'] ?? item['titulo'] ?? item['Titulo'] ?? '',
              descricao: item['descricao'] ?? item['description'] ?? '',
              valorAtual: (item['valorAtual'] ?? item['currentValue'] ?? item['percentual'] ?? item['Percentual'] ?? 0).toDouble(),
              valorAnterior: (item['valorAnterior'] ?? item['previousValue'] ?? 0).toDouble(),
              meta: (item['meta'] ?? item['target'] ?? 100).toDouble(),
              unidade: item['unidade'] ?? item['unit'] ?? item['valor'] ?? item['Valor'] ?? '',
              trend: _parseTrend(item['trend'] ?? item['Trend']),
              variacao: (item['variacao'] ?? item['variation'] ?? 0).toDouble(),
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
          error: response.message ?? 'Erro ao carregar relat�rio de performance',
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

/// Provider de relat�rios de vendas
final salesReportsProvider = StateNotifierProvider<SalesReportsNotifier, SalesReportsState>(
  (ref) {
    final repository = ref.watch(reportsRepositoryProvider);
    return SalesReportsNotifier(repository);
  },
);

/// Provider de relat�rios de auditoria
final auditReportsProvider = StateNotifierProvider<AuditReportsNotifier, AuditReportsState>(
  (ref) {
    final repository = ref.watch(reportsRepositoryProvider);
    return AuditReportsNotifier(repository);
  },
);

/// Provider de relat�rios operacionais
final operationalReportsProvider = StateNotifierProvider<OperationalReportsNotifier, OperationalReportsState>(
  (ref) {
    final repository = ref.watch(reportsRepositoryProvider);
    return OperationalReportsNotifier(repository);
  },
);

/// Provider de relat�rios de performance
final performanceReportsProvider = StateNotifierProvider<PerformanceReportsNotifier, PerformanceReportsState>(
  (ref) {
    final repository = ref.watch(reportsRepositoryProvider);
    return PerformanceReportsNotifier(repository);
  },
);





