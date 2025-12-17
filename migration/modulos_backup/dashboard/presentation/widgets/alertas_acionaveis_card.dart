import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:tagbean/features/dashboard/data/models/dashboard_models.dart';

/// Enumeração para severidade de alertas
enum AlertaSeveridade {
  critico, // Vermelho - Ação imediata
  atencao, // Laranja - Resolver hoje
  aviso,   // Amarelo - Pode esperar
}

/// Modelo de alerta acionável
class AlertaAcionavel {
  final String id;
  final AlertaSeveridade severidade;
  final String titulo;
  final int quantidade;
  final String? acaoPrincipal;
  final String? acaoSecundaria;
  final VoidCallback? onAcaoPrincipal;
  final VoidCallback? onAcaoSecundaria;
  final VoidCallback? onIgnorar;

  const AlertaAcionavel({
    required this.id,
    required this.severidade,
    required this.titulo,
    required this.quantidade,
    this.acaoPrincipal,
    this.acaoSecundaria,
    this.onAcaoPrincipal,
    this.onAcaoSecundaria,
    this.onIgnorar,
  });
}

/// Card de alertas acionáveis com hierarquia de cores e ações diretas
/// Só aparece se houver alertas - Mostra no máximo 3 alertas críticos primeiro
class AlertasAcionaveisCard extends ConsumerStatefulWidget {
  final VoidCallback? onVerTodos;
  final List<AlertaAcionavel>? customAlertas;
  
  // Callbacks para ações de navegação
  final VoidCallback? onVerTags;
  final VoidCallback? onVerProdutos;
  final VoidCallback? onVerProdutosSemPreco;
  final VoidCallback? onAgendarTroca;
  
  const AlertasAcionaveisCard({
    super.key,
    this.onVerTodos,
    this.customAlertas,
    this.onVerTags,
    this.onVerProdutos,
    this.onVerProdutosSemPreco,
    this.onAgendarTroca,
  });

  @override
  ConsumerState<AlertasAcionaveisCard> createState() => _AlertasAcionaveisCardState();
}

class _AlertasAcionaveisCardState extends ConsumerState<AlertasAcionaveisCard> {
  bool _expanded = false;
  final Set<String> _ignorados = {};

  List<AlertaAcionavel> _buildAlertasFromProvider(List<DashboardAlert> providerAlerts) {
    // Converte os alertas do provider para o novo formato acionável
    final List<AlertaAcionavel> alertas = [];
    
    // Agrupa alertas por tipo e conta
    int tagsOffline = 0;
    int produtosSemPreco = 0;
    int bateriasBaixas = 0;
    int errosSync = 0;
    int produtosSemCategoria = 0;
    
    for (final alert in providerAlerts) {
      final alertType = alert.type.toLowerCase();
      if (alertType.contains('offline') || alertType.contains('tag')) {
        tagsOffline += alert.count;
      } else if (alertType.contains('battery') || alertType.contains('bateria')) {
        bateriasBaixas += alert.count;
      } else if (alertType.contains('price') || alertType.contains('preco') || alertType.contains('preço')) {
        produtosSemPreco += alert.count;
      } else if (alertType.contains('sync') || alertType.contains('sinc')) {
        errosSync += alert.count;
      } else {
        produtosSemCategoria += alert.count;
      }
    }
    
    // Tags Offline - CRÍTICO
    if (tagsOffline > 0) {
      alertas.add(AlertaAcionavel(
        id: 'tags_offline',
        severidade: AlertaSeveridade.critico,
        titulo: '$tagsOffline tags offline',
        quantidade: tagsOffline,
        acaoPrincipal: 'Ver Tags',
        acaoSecundaria: 'Ignorar Hoje',
        onAcaoPrincipal: widget.onVerTags,
        onIgnorar: () => setState(() => _ignorados.add('tags_offline')),
      ));
    }
    
    // Erros de Sync - CRÍTICO
    if (errosSync > 0) {
      alertas.add(AlertaAcionavel(
        id: 'sync_error',
        severidade: AlertaSeveridade.critico,
        titulo: '$errosSync erros de sincronização',
        quantidade: errosSync,
        acaoPrincipal: 'Resolver',
        onAcaoPrincipal: widget.onVerTags,
      ));
    }
    
    // Produtos sem preço - ATENÇÃO
    if (produtosSemPreco > 0) {
      alertas.add(AlertaAcionavel(
        id: 'sem_preco',
        severidade: AlertaSeveridade.atencao,
        titulo: '$produtosSemPreco produtos sem preço',
        quantidade: produtosSemPreco,
        acaoPrincipal: 'Corrigir',
        acaoSecundaria: 'Ver Lista',
        onAcaoPrincipal: widget.onVerProdutosSemPreco,
        onAcaoSecundaria: widget.onVerProdutos,
      ));
    }
    
    // Baterias baixas - AVISO
    if (bateriasBaixas > 0) {
      alertas.add(AlertaAcionavel(
        id: 'bateria_baixa',
        severidade: AlertaSeveridade.aviso,
        titulo: '$bateriasBaixas tags com bateria <20%',
        quantidade: bateriasBaixas,
        acaoPrincipal: 'Agendar Troca',
        onAcaoPrincipal: widget.onAgendarTroca,
      ));
    }
    
    // Produtos sem categoria - AVISO
    if (produtosSemCategoria > 0) {
      alertas.add(AlertaAcionavel(
        id: 'sem_categoria',
        severidade: AlertaSeveridade.aviso,
        titulo: '$produtosSemCategoria produtos sem categoria',
        quantidade: produtosSemCategoria,
        acaoPrincipal: 'Categorizar',
        onAcaoPrincipal: widget.onVerProdutos,
      ));
    }
    
    // Ordena por severidade (crítico primeiro)
    alertas.sort((a, b) => a.severidade.index.compareTo(b.severidade.index));
    
    return alertas;
  }

  Color _getCorSeveridade(AlertaSeveridade severidade) {
    switch (severidade) {
      case AlertaSeveridade.critico:
        return AppThemeColors.redMain;
      case AlertaSeveridade.atencao:
        return AppThemeColors.orangeMain;
      case AlertaSeveridade.aviso:
        return AppThemeColors.warning;
    }
  }

  Color _getCorFundo(AlertaSeveridade severidade) {
    switch (severidade) {
      case AlertaSeveridade.critico:
        return AppThemeColors.redMain.withValues(alpha: 0.08);
      case AlertaSeveridade.atencao:
        return AppThemeColors.orangeMain.withValues(alpha: 0.08);
      case AlertaSeveridade.aviso:
        return AppThemeColors.warning.withValues(alpha: 0.08);
    }
  }

  IconData _getIconeSeveridade(AlertaSeveridade severidade) {
    switch (severidade) {
      case AlertaSeveridade.critico:
        return Icons.error_rounded;
      case AlertaSeveridade.atencao:
        return Icons.warning_rounded;
      case AlertaSeveridade.aviso:
        return Icons.info_rounded;
    }
  }

  String _getLabelSeveridade(AlertaSeveridade severidade) {
    switch (severidade) {
      case AlertaSeveridade.critico:
        return 'CRÍTICO';
      case AlertaSeveridade.atencao:
        return 'ATENÇÃO';
      case AlertaSeveridade.aviso:
        return 'AVISO';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Obtém alertas do provider ou usa customizados
    final providerAlerts = ref.watch(dashboardAlertsProvider);
    final alertas = widget.customAlertas ?? _buildAlertasFromProvider(providerAlerts);
    
    // Filtra alertas ignorados
    final alertasAtivos = alertas.where((a) => !_ignorados.contains(a.id)).toList();
    
    // Se não há alertas, não mostra o card
    if (alertasAtivos.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Mostra no máximo 3 alertas (ou todos se expandido)
    final alertasVisiveis = _expanded ? alertasAtivos : alertasAtivos.take(3).toList();
    final temMaisAlertas = alertasAtivos.length > 3;

    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(
          color: _getCorSeveridade(alertasAtivos.first.severidade).withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _getCorSeveridade(alertasAtivos.first.severidade).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getCorSeveridade(alertasAtivos.first.severidade).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.notifications_active_rounded,
                    color: _getCorSeveridade(alertasAtivos.first.severidade),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alertas Acionáveis',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 16,
                            mobileFontSize: 14,
                            tabletFontSize: 15,
                          ),
                          fontWeight: FontWeight.bold,
                          color: AppThemeColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${alertasAtivos.length} ${alertasAtivos.length == 1 ? 'item requer' : 'itens requerem'} atenção',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppThemeColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de alertas
          ...alertasVisiveis.map((alerta) => _buildAlertaItem(alerta, isMobile, isTablet)),
          
          // Botão "Ver todos" se houver mais alertas
          if (temMaisAlertas)
            InkWell(
              onTap: () {
                if (widget.onVerTodos != null) {
                  widget.onVerTodos!();
                } else {
                  setState(() => _expanded = !_expanded);
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  color: AppThemeColors.backgroundLight,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(isMobile ? 16 : 20),
                    bottomRight: Radius.circular(isMobile ? 16 : 20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: AppThemeColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _expanded 
                          ? 'Mostrar menos' 
                          : 'Ver todos os ${alertasAtivos.length} alertas',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppThemeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAlertaItem(AlertaAcionavel alerta, bool isMobile, bool isTablet) {
    final cor = _getCorSeveridade(alerta.severidade);
    final corFundo = _getCorFundo(alerta.severidade);
    final icone = _getIconeSeveridade(alerta.severidade);
    final label = _getLabelSeveridade(alerta.severidade);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
        vertical: AppSizes.paddingXs.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // Badge de severidade
          Flexible(
            flex: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: cor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icone, color: AppThemeColors.surface, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppThemeColors.surface,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Título do alerta
          Expanded(
            child: Text(
              alerta.titulo,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppThemeColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          
          // Botões de ação em container flexível
          Flexible(
            flex: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isMobile && alerta.acaoSecundaria != null && alerta.onAcaoSecundaria != null)
                  TextButton(
                    onPressed: alerta.onAcaoSecundaria,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 32),
                    ),
                    child: Text(
                      alerta.acaoSecundaria!,
                      style: TextStyle(
                        fontSize: 12,
                        color: cor,
                      ),
                    ),
                  ),
                
                if (alerta.acaoPrincipal != null && alerta.onAcaoPrincipal != null)
                  ElevatedButton(
                    onPressed: alerta.onAcaoPrincipal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cor,
                      foregroundColor: AppThemeColors.surface,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 10 : 14,
                        vertical: 6,
                      ),
                      minimumSize: const Size(0, 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      alerta.acaoPrincipal!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                
                // Botão ignorar
                if (alerta.onIgnorar != null && !isMobile)
                  IconButton(
                    onPressed: alerta.onIgnorar,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppThemeColors.textSecondary,
                      size: 18,
                    ),
                    tooltip: 'Ignorar hoje',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
