import 'package:tagbean/core/enums/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/reports/presentation/providers/reports_provider.dart';

class RelatoriosAuditoriaScreen extends ConsumerStatefulWidget {
  const RelatoriosAuditoriaScreen({super.key});

  @override
  ConsumerState<RelatoriosAuditoriaScreen> createState() => _RelatoriosAuditoriaScreenState();
}

class _RelatoriosAuditoriaScreenState extends ConsumerState<RelatoriosAuditoriaScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  late AnimationController _refreshController;
  String _filtroTipo = 'Todos';
  String _filtroUsuario = 'Todos';
  // NOTA: _filtroPeriodo removido (morto)
  bool _apenasImportantes = false;
  
  // OTIMIZAããO: Cache de logs filtrados
  List<Map<String, dynamic>>? _cachedLogsFiltrados;
  String _lastFiltroTipo = 'Todos';
  String _lastFiltroUsuario = 'Todos';
  bool _lastApenasImportantes = false;

  // Getter conectado ao Provider - dados reais do backend
  AuditReportsState get _auditState => ref.watch(auditReportsProvider);
  
  // Converte os modelos do provider para o formato Map esperado pelos widgets
  List<Map<String, dynamic>> get _logs {
    if (_auditState.reports.isEmpty) {
      return [];
    }
    return _auditState.reports.map((report) {
      return {
        'tipo': report.titulo,
        'data': _formatDate(report.dataAuditoria),
        'usuario': report.auditor,
        'descricao': report.descricao,
        'icone': _getIconForType(report.titulo),
        'cor': _getColorForType(report.titulo),
        'dispositivo': 'Sistema',
        'ip': 'N/A',
        'categoria': report.hasProblems ? 'Crãtica' : 'Normal',
        'antes': '${report.itensVerificados} itens',
        'depois': '${report.itensVerificados - report.itensComProblema} OK',
        'impacto': '${report.percentualConformidade.toStringAsFixed(1)}%',
      };
    }).toList();
  }
  
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
  
  IconData _getIconForType(String type) {
    if (type.toLowerCase().contains('preço')) return Icons.attach_money_rounded;
    if (type.toLowerCase().contains('tag')) return Icons.link_rounded;
    if (type.toLowerCase().contains('import')) return Icons.upload_file_rounded;
    if (type.toLowerCase().contains('estratãg')) return Icons.auto_awesome_rounded;
    if (type.toLowerCase().contains('login')) return Icons.login_rounded;
    if (type.toLowerCase().contains('backup')) return Icons.backup_rounded;
    return Icons.info_outline_rounded;
  }
  
  Color _getColorForType(String type) {
    if (type.toLowerCase().contains('preço')) return ThemeColors.of(context).success;
    if (type.toLowerCase().contains('tag')) return ThemeColors.of(context).primary;
    if (type.toLowerCase().contains('import')) return ThemeColors.of(context).greenDark;
    if (type.toLowerCase().contains('estratãg')) return ThemeColors.of(context).cyanMain;
    if (type.toLowerCase().contains('login')) return ThemeColors.of(context).cyanMain;
    return ThemeColors.of(context).primary;
  }

  // OTIMIZAããO: Getter com cache
  List<Map<String, dynamic>> get _logsFiltrados {
    if (_cachedLogsFiltrados != null &&
        _lastFiltroTipo == _filtroTipo &&
        _lastFiltroUsuario == _filtroUsuario &&
        _lastApenasImportantes == _apenasImportantes) {
      return _cachedLogsFiltrados!;
    }
    
    _lastFiltroTipo = _filtroTipo;
    _lastFiltroUsuario = _filtroUsuario;
    _lastApenasImportantes = _apenasImportantes;
    
    _cachedLogsFiltrados = _logs.where((log) {
      final tipoMatch = _filtroTipo == 'Todos' || log['tipo'] == _filtroTipo;
      final usuarioMatch = _filtroUsuario == 'Todos' || log['usuario'] == _filtroUsuario;
      final importanteMatch = !_apenasImportantes || log['categoria'] == 'Crãtica';
      return tipoMatch && usuarioMatch && importanteMatch;
    }).toList();
    
    return _cachedLogsFiltrados!;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController.forward();
    
    // Carregar dados do backend
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(auditReportsProvider);
      if (state.status == LoadingStatus.initial) {
        ref.read(auditReportsProvider.notifier).loadReports();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
      )
    );
  }

  Widget _buildContent() {
    // Tratamento de estados de loading e erro
    if (_auditState.status == LoadingStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_auditState.status == LoadingStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: ThemeColors.of(context).error),
            const SizedBox(height: 16),
            Text(
              _auditState.error ?? 'Erro ao carregar dados',
              textAlign: TextAlign.center,
              style: TextStyle(color: ThemeColors.of(context).textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(auditReportsProvider.notifier).loadReports(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }
    
    if (_logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security_outlined, size: 64, color: ThemeColors.of(context).textSecondary),
            const SizedBox(height: 16),
            Text(
              'Nenhum registro de auditoria disponível',
              style: TextStyle(color: ThemeColors.of(context).textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Os registros aparecerão conforme as ações forem realizadas',
              style: TextStyle(color: ThemeColors.of(context).textSecondaryOverlay70, fontSize: 14),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildEnhancedStatsHeader(),
            _buildEnhancedFilterBar(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: _logsFiltrados.length + 1,
              itemBuilder: (context, index) {
                if (index == _logsFiltrados.length) {
                  return _buildSecurityInfo();
                }
                return _buildEnhancedLogCard(_logsFiltrados[index], index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.08),
            blurRadius: 25,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textSecondary,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).cyanMain, ThemeColors.of(context).infoDark],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.security_rounded,
              color: ThemeColors.of(context).surface,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Relatórios de Auditoria',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.8,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Histórico e Rastreabilidade',
                  style: TextStyle(
                    fontSize: 13,
                    color: ThemeColors.of(context).textSecondary,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.mediumPadding.get(isMobile, isTablet), vertical: 6),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).successPastel,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ThemeColors.of(context).success),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: ThemeColors.of(context).successIcon,
                ),
                const SizedBox(width: 6),
                Text(
                  'Guia',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).successIcon,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatsHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ThemeColors.of(context).cyanMain, ThemeColors.of(context).infoDark],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).primary.withValues(alpha: 0.4),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ThemeColors.of(context).surfaceOverlay30, width: 1.5),
                ),
                child: AnimatedBuilder(
                  animation: _refreshController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _refreshController.value * 6.28,
                      child: Icon(Icons.shield_rounded, color: ThemeColors.of(context).surface, size: 22),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1.247 Eventos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Auditoria Completa é últimos 30 dias',
                      style: const TextStyle(
                        fontSize: 13,
                        letterSpacing: 0.2,
                      ).copyWith(color: ThemeColors.of(context).surfaceOverlay70),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).success.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ThemeColors.of(context).success.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_rounded, size: 16, color: ThemeColors.of(context).surface),
                    const SizedBox(width: 6),
                    Text(
                      'Seguro',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay15,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeColors.of(context).surfaceOverlay30, width: 1.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem('847', 'Usuário', Icons.person_rounded),
                ),
                Container(width: 1, height: 40, color: ThemeColors.of(context).surfaceOverlay30),
                Expanded(
                  child: _buildStatItem('400', 'Sistema', Icons.computer_rounded),
                ),
                Container(width: 1, height: 40, color: ThemeColors.of(context).surfaceOverlay30),
                Expanded(
                  child: _buildStatItem('67', 'Crãticos', Icons.error_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: ThemeColors.of(context).surface, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ThemeColors.of(context).surface,
            letterSpacing: -0.8,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: ThemeColors.of(context).surfaceOverlay90,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedFilterBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).infoPastel,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.filter_alt_rounded, size: 18, color: ThemeColors.of(context).infoDark),
              ),
              const SizedBox(width: 12),
              const Text(
                'Filtros Avançados',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _apenasImportantes,
                  onChanged: (value) => setState(() => _apenasImportantes = value),
                  activeThumbColor: ThemeColors.of(context).error,
                ),
              ),
              const Text(
                'Crãticos',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _filtroTipo,
                  style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Tipo',
                    labelStyle: const TextStyle(fontSize: 11),
                    prefixIcon: Icon(Icons.category_rounded, size: 16, color: ThemeColors.of(context).infoDark),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                  items: ['Todos', 'AlterAção de PREÇO', 'Login', 'Importação', 'Backup', 'Exclusão de Produto']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _filtroTipo = value!);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _filtroUsuario,
                  style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Usuário',
                    labelStyle: const TextStyle(fontSize: 11),
                    prefixIcon: Icon(Icons.person_rounded, size: 16, color: ThemeColors.of(context).infoDark),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                  items: ['Todos', 'Admin Master', 'Gerente Loja', 'Sistema']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _filtroUsuario = value!);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedLogCard(Map<String, dynamic> log, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: (log['cor'] as Color).withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (log['cor'] as Color).withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: ThemeColors.of(context).transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(18),
            childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [log['cor'], (log['cor'] as Color).withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (log['cor'] as Color).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(log['icone'], color: ThemeColors.of(context).surface, size: 28),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    log['tipo'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.extraSmallPadding.get(isMobile, isTablet), vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoriaCor(log['categoria']).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _getCategoriaCor(log['categoria']).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    log['categoria'],
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: _getCategoriaCor(log['categoria']),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  log['descricao'],
                  style: TextStyle(
                    fontSize: 13,
                    color: ThemeColors.of(context).textSecondary,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(Icons.person_rounded, log['usuario'], ThemeColors.of(context).primary),
                    _buildInfoChip(Icons.access_time_rounded, log['data'].split(' ')[1], ThemeColors.of(context).blueCyan),
                    _buildInfoChip(Icons.devices_rounded, log['dispositivo'].split(' - ')[0], ThemeColors.of(context).success),
                  ],
                ),
              ],
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ThemeColors.of(context).textSecondary,
                      ThemeColors.of(context).textSecondaryOverlay50,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (log['cor'] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.info_rounded,
                            size: 16,
                            color: log['cor'],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Detalhes da OperAção',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildDetailRow('Antes', log['antes']),
                    const SizedBox(height: 8),
                    _buildDetailRow('Depois', log['depois']),
                    const SizedBox(height: 8),
                    _buildDetailRow('Impacto', log['impacto']),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ThemeColors.of(context).textSecondary),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.computer_rounded, size: 14, color: ThemeColors.of(context).textSecondary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  log['dispositivo'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: ThemeColors.of(context).textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded, size: 14, color: ThemeColors.of(context).textSecondary),
                              const SizedBox(width: 8),
                              Text(
                                'IP: ${log['ip']}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: ThemeColors.of(context).textSecondary,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ThemeColors.of(context).textSecondary),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).successPastel, ThemeColors.of(context).infoPastel],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.of(context).successLight, width: 2),
      ),
      child: Column(
        children: [
          Icon(Icons.verified_user_rounded, size: 40, color: ThemeColors.of(context).successIcon),
          const SizedBox(height: 12),
          Text(
            'Sistema Seguro e Auditado',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Todos os logs são criptografados e armazenados\npor 90 dias para garantir compliance e segurança',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: ThemeColors.of(context).textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSecurityBadge(Icons.lock_rounded, 'Criptografado'),
              const SizedBox(width: 12),
              _buildSecurityBadge(Icons.backup_rounded, '90 dias'),
              const SizedBox(width: 12),
              _buildSecurityBadge(Icons.verified_rounded, 'Compliance'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ThemeColors.of(context).success),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: ThemeColors.of(context).successIcon),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).successIcon,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoriaCor(String categoria) {
    switch (categoria) {
      case 'Crãtica':
        return ThemeColors.of(context).error;
      case 'Segurança':
        return ThemeColors.of(context).yellowGold;
      case 'Sistema':
        return ThemeColors.of(context).blueCyan;
      default:
        return ThemeColors.of(context).primary;
    }
  }

  Future<void> _refreshData() async {
    _refreshController.repeat();
    
    // Recarregar dados do backend
    await ref.read(auditReportsProvider.notifier).loadReports();
    
    _refreshController.reset();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface),
              const SizedBox(width: 12),
              const Text('Logs atualizados!'),
            ],
          ),
          backgroundColor: ThemeColors.of(context).successIcon,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}






