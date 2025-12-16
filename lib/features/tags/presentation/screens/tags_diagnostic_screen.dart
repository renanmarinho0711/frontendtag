import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/tags/data/models/tag_model.dart';
import 'package:tagbean/features/tags/presentation/providers/tags_provider.dart';
import 'package:tagbean/features/tags/presentation/screens/tag_edit_screen.dart';

class TagsDiagnosticoScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  
  const TagsDiagnosticoScreen({super.key, this.onBack});

  @override
  ConsumerState<TagsDiagnosticoScreen> createState() =>
      _TagsDiagnosticoScreenState();
}

class _TagsDiagnosticoScreenState extends ConsumerState<TagsDiagnosticoScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  bool _isScanning = false;
  late AnimationController _scanAnimationController;
  String _filtroSelecionado = 'todos';

  @override
  void initState() {
    super.initState();
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    super.dispose();
  }

  // Calcular estat?sticas de problemas baseadas nas tags reais
  List<Map<String, dynamic>> _getProblemas(List<TagModel> tags) {
    final lowBattery =
        tags.where((t) => t.batteryLevel < 20 && t.batteryLevel > 0).length;
    final offline = tags.where((t) => t.status == TagStatus.offline).length;
    final unbound = tags.where((t) => !t.isBound).length;
    final criticalBattery = tags.where((t) => t.batteryLevel <= 5).length;

    return [
      {
        'tipo': 'Bateria Baixa',
        'quantidade': lowBattery,
        'cor': ThemeColors.of(context).warning,
        'icone': Icons.battery_alert_rounded,
        'descricao': 'Menos de 20% de carga',
        'filter': 'bateria',
      },
      {
        'tipo': 'Sem Comunica??o',
        'quantidade': offline,
        'cor': ThemeColors.of(context).error,
        'icone': Icons.signal_wifi_off_rounded,
        'descricao': 'Offline h? mais de 2h',
        'filter': 'offline',
      },
      {
        'tipo': 'N?o Vinculadas',
        'quantidade': unbound,
        'cor': ThemeColors.of(context).warning,
        'icone': Icons.link_off_rounded,
        'descricao': 'Sem produto associado',
        'filter': 'unbound',
      },
      {
        'tipo': 'Bateria Cr?tica',
        'quantidade': criticalBattery,
        'cor': ThemeColors.of(context).error,
        'icone': Icons.battery_0_bar_rounded,
        'descricao': 'Menos de 5% de carga',
        'filter': 'critica',
      },
    ];
  }

  // Filtrar tags com problemas
  List<TagModel> _getTagsComProblema(List<TagModel> tags) {
    return tags.where((tag) {
      if (_filtroSelecionado == 'todos') {
        return tag.batteryLevel < 20 ||
            tag.status == TagStatus.offline ||
            !tag.isBound;
      }
      if (_filtroSelecionado == 'bateria') {
        return tag.batteryLevel < 20 && tag.batteryLevel > 5;
      }
      if (_filtroSelecionado == 'offline') {
        return tag.status == TagStatus.offline;
      }
      if (_filtroSelecionado == 'unbound') {
        return !tag.isBound;
      }
      if (_filtroSelecionado == 'critica') {
        return tag.batteryLevel <= 5;
      }
      return false;
    }).toList()
      ..sort((a, b) {
        // Ordenar por prioridade (bateria mais baixa primeiro)
        if (a.batteryLevel != b.batteryLevel) {
          return a.batteryLevel.compareTo(b.batteryLevel);
        }
        // Depois por status offline
        if (a.status == TagStatus.offline && b.status != TagStatus.offline) {
          return -1;
        }
        return 0;
      });
  }

  String _getPrioridade(TagModel tag) {
    if (tag.batteryLevel <= 5 || tag.status == TagStatus.offline) {
      return 'critica';
    }
    if (tag.batteryLevel < 20) {
      return 'alta';
    }
    if (!tag.isBound) {
      return 'media';
    }
    return 'baixa';
  }

  String _getProblemaDescricao(TagModel tag) {
    final problemas = <String>[];
    if (tag.batteryLevel <= 5) {
      problemas.add('Bateria Cr?tica (${tag.batteryLevel}%)');
    } else if (tag.batteryLevel < 20) {
      problemas.add('Bateria Baixa (${tag.batteryLevel}%)');
    }
    if (tag.status == TagStatus.offline) {
      problemas.add('Sem Comunica??o');
    }
    if (!tag.isBound) {
      problemas.add('N?o Vinculada');
    }
    return problemas.isNotEmpty ? problemas.join(', ') : 'Verificar';
  }

  String _formatUltimaAtualizacao(DateTime? lastSync) {
    if (lastSync == null) return 'Nunca';
    final diff = DateTime.now().difference(lastSync);
    if (diff.inMinutes < 1) return 'Agora';
    if (diff.inMinutes < 60) return '${diff.inMinutes}min atr?s';
    if (diff.inHours < 24) return '${diff.inHours}h? atr?s';
    return '${diff.inDays}d atr?s';
  }

  @override
  Widget build(BuildContext context) {
    final tagsState = ref.watch(tagsNotifierProvider);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surfaceSecondary,
      body: SafeArea(
        child: tagsState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorWidget(error.toString()),
          data: (tags) => _buildContent(tags),
        ),
      ),
      floatingActionButton: _buildScanButton(),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: ThemeColors.of(context).error,
            ),
            SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
            Text(
              'Erro ao carregar dados',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 18,
                  mobileFontSize: 16,
                  tabletFontSize: 17,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ThemeColors.of(context).textSecondary,
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
            ),
            SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(tagsNotifierProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tentar Novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.of(context).info,
                foregroundColor: ThemeColors.of(context).surface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<TagModel> tags) {
    final problemas = _getProblemas(tags);
    final tagsComProblema = _getTagsComProblema(tags);
    final totalProblemas =
        problemas.fold<int>(0, (sum, p) => sum + (p['quantidade'] as int));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(totalProblemas),
          Padding(
            padding: EdgeInsets.all(
              AppSizes.paddingMdAlt.get(isMobile, isTablet),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildResumoCard(tags, totalProblemas),
                SizedBox(
                  height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                ),
                _buildFiltroChips(),
                SizedBox(
                  height: AppSizes.paddingLgAlt.get(isMobile, isTablet),
                ),
                Text(
                  'Categorias de Problemas',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 18,
                      mobileFontSize: 16,
                      tabletFontSize: 17,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(
                  height: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                _buildProblemasGrid(problemas),
                SizedBox(
                  height: AppSizes.paddingXl.get(isMobile, isTablet),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Tags Cr?ticas',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 18,
                            mobileFontSize: 16,
                            tabletFontSize: 17,
                          ),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            AppSizes.paddingSmAlt.get(isMobile, isTablet),
                        vertical:
                            AppSizes.paddingXsAlt5.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).errorPastel,
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.isMobile(context) ? 6 : 8,
                        ),
                        border: Border.all(color: ThemeColors.of(context).error),
                      ),
                      child: Text(
                        '${tagsComProblema.length} tags',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 12,
                            mobileFontSize: 11,
                            tabletFontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).errorDark,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                if (tagsComProblema.isEmpty)
                  _buildEmptyState()
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tagsComProblema.length,
                    itemBuilder: (context, index) =>
                        _buildTagCard(tagsComProblema[index], index),
                  ),
                SizedBox(
                  height: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 70,
                    tablet: 75,
                    desktop: 80,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).successPastel,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(color: ThemeColors.of(context).successLight),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: AppSizes.iconHeroSmAlt.get(isMobile, isTablet),
            color: ThemeColors.of(context).success,
          ),
          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
          Text(
            'Nenhum problema encontrado!',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 16,
                mobileFontSize: 14,
                tabletFontSize: 15,
              ),
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).successIcon,
            ),
          ),
          SizedBox(height: AppSizes.paddingXs.get(isMobile, isTablet)),
          Text(
            'Todas as tags est?o funcionando normalmente.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 12,
                tabletFontSize: 13,
              ),
              color: ThemeColors.of(context).successIconDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int totalProblemas) {
    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
        vertical: AppSizes.paddingMdLg.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 20 : (isTablet ? 22 : 24),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.08),
            blurRadius: isMobile ? 20 : 25,
            offset: Offset(0, isMobile ? 5 : 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Bot?o de voltar
          if (widget.onBack != null) ...[            Container(
              decoration: BoxDecoration(
                color: ThemeColors.of(context).tealMain,
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
                onPressed: widget.onBack,
              ),
            ),
            SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          ],
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).error, ThemeColors.of(context).errorDark],
              ),
              borderRadius: BorderRadius.circular(
                  AppSizes.paddingLg.get(isMobile, isTablet)),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).errorLight,
                  blurRadius: isMobile ? 10 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.troubleshoot_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconLarge.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diagn?stico de Tags',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 20,
                      mobileFontSize: 18,
                      tabletFontSize: 19,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(
                  height: AppSizes.paddingXxs.get(isMobile, isTablet),
                ),
                Text(
                  totalProblemas > 0
                      ? '$totalProblemas problemas encontrados'
                      : 'Sistema funcionando normalmente',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                      tabletFontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: totalProblemas > 0
                        ? ThemeColors.of(context).warning
                        : ThemeColors.of(context).success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => ref.invalidate(tagsNotifierProvider),
            icon: Icon(
              Icons.refresh_rounded,
              color: ThemeColors.of(context).textSecondary,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoCard(List<TagModel> tags, int totalProblemas) {
    final total = tags.length;
    final online =
        tags.where((t) => t.status == TagStatus.online).length;
    final percentOk =
        total > 0 ? ((total - totalProblemas) / total * 100).toStringAsFixed(0) : '100';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: totalProblemas > 0
              ? [ThemeColors.of(context).yellowGold, ThemeColors.of(context).warning]
              : [ThemeColors.of(context).success, ThemeColors.of(context).tealMain],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: (totalProblemas > 0
                    ? ThemeColors.of(context).warning
                    : ThemeColors.of(context).success)
                Light,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildResumoItem('Total', total.toString(), Icons.label_rounded),
              _buildResumoItem(
                  'Online', online.toString(), Icons.wifi_rounded),
              _buildResumoItem(
                  'Problemas', totalProblemas.toString(), Icons.warning_rounded),
              _buildResumoItem('Sa?de', '$percentOk%', Icons.favorite_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: ThemeColors.of(context).surface,
          size: AppSizes.iconMedium.get(isMobile, isTablet),
        ),
        SizedBox(height: AppSizes.paddingXs.get(isMobile, isTablet)),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 20,
              mobileFontSize: 18,
              tabletFontSize: 19,
            ),
            fontWeight: FontWeight.bold,
            color: ThemeColors.of(context).surface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 11,
              mobileFontSize: 10,
              tabletFontSize: 10,
            ),
            color: ThemeColors.of(context).surfaceOverlay90,
          ),
        ),
      ],
    );
  }

  Widget _buildFiltroChips() {
    final filtros = [
      {'id': 'todos', 'label': 'Todos'},
      {'id': 'bateria', 'label': 'Bateria Baixa'},
      {'id': 'offline', 'label': 'Offline'},
      {'id': 'unbound', 'label': 'N?o Vinculadas'},
      {'id': 'critica', 'label': 'Cr?ticos'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filtros.map((filtro) {
          final isSelected = _filtroSelecionado == filtro['id'];
          return Padding(
            padding: EdgeInsets.only(
              right: AppSizes.paddingXs.get(isMobile, isTablet),
            ),
            child: ChoiceChip(
              label: Text(
                filtro['label']!,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 12,
                    mobileFontSize: 11,
                    tabletFontSize: 11,
                  ),
                  color: isSelected
                      ? ThemeColors.of(context).surface
                      : ThemeColors.of(context).textPrimary,
                ),
              ),
              selected: isSelected,
              selectedColor: ThemeColors.of(context).success,
              onSelected: (selected) {
                setState(() => _filtroSelecionado = filtro['id']!);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProblemasGrid(List<Map<String, dynamic>> problemas) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = isMobile ? 2 : (isTablet ? 2 : 4);
        final spacing = AppSizes.paddingBase.get(isMobile, isTablet);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: isMobile ? 1.3 : 1.5,
          ),
          itemCount: problemas.length,
          itemBuilder: (context, index) => _buildProblemaCard(problemas[index]),
        );
      },
    );
  }

  Widget _buildProblemaCard(Map<String, dynamic> problema) {
    final Color cor = problema['cor'] as Color;

    return InkWell(
      onTap: () {
        setState(() => _filtroSelecionado = problema['filter'] as String);
      },
      borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          color: corLight,
          borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
          border: Border.all(color: corLight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              problema['icone'] as IconData,
              color: cor,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
            SizedBox(height: AppSizes.paddingXs.get(isMobile, isTablet)),
            Text(
              problema['quantidade'].toString(),
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 24,
                  mobileFontSize: 20,
                  tabletFontSize: 22,
                ),
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
            Text(
              problema['tipo'] as String,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 12,
                  mobileFontSize: 10,
                  tabletFontSize: 11,
                ),
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagCard(TagModel tag, int index) {
    final prioridade = _getPrioridade(tag);
    final corPrioridade = prioridade == 'critica'
        ? ThemeColors.of(context).error
        : prioridade == 'alta'
            ? ThemeColors.of(context).warning
            : ThemeColors.of(context).warning;

    return Container(
      margin: EdgeInsets.only(
        bottom: AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
        border: Border.all(color: corPrioridadeLight),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _openTagDetail(tag),
        borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
          child: Row(
            children: [
              // Indicador de prioridade
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: corPrioridade,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
              // ?cone de bateria
              Container(
                padding:
                    EdgeInsets.all(AppSizes.paddingXs.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  color: corPrioridadeLight,
                  borderRadius: BorderRadius.circular(
                      AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  _getBatteryIcon(tag.batteryLevel),
                  color: corPrioridade,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
              // Informa??es
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tag.macAddress,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 14,
                                mobileFontSize: 13,
                                tabletFontSize: 13,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                AppSizes.paddingXs.get(isMobile, isTablet),
                            vertical:
                                AppSizes.paddingXxs.get(isMobile, isTablet),
                          ),
                          decoration: BoxDecoration(
                            color: corPrioridadeLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            prioridade.toUpperCase(),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: corPrioridade,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                    Text(
                      tag.productName ?? 'Sem produto vinculado',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 12,
                          mobileFontSize: 11,
                          tabletFontSize: 11,
                        ),
                        color: ThemeColors.of(context).textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                        height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                    Text(
                      _getProblemaDescricao(tag),
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 11,
                          mobileFontSize: 10,
                          tabletFontSize: 10,
                        ),
                        color: corPrioridade,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // ?ltima atualiza??o
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatUltimaAtualizacao(tag.lastSync),
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 10,
                        mobileFontSize: 9,
                        tabletFontSize: 9,
                      ),
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingXs.get(isMobile, isTablet)),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: ThemeColors.of(context).textSecondary,
                    size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getBatteryIcon(int level) {
    if (level >= 80) return Icons.battery_full_rounded;
    if (level >= 60) return Icons.battery_5_bar_rounded;
    if (level >= 40) return Icons.battery_3_bar_rounded;
    if (level >= 20) return Icons.battery_2_bar_rounded;
    if (level > 5) return Icons.battery_1_bar_rounded;
    return Icons.battery_alert_rounded;
  }

  void _openTagDetail(TagModel tag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EtiquetasEditarScreen(tag: tag),
      ),
    );
  }

  Widget _buildScanButton() {
    return FloatingActionButton.extended(
      onPressed: _isScanning ? null : _startScan,
      backgroundColor:
          _isScanning ? ThemeColors.of(context).textSecondary : ThemeColors.of(context).success,
      icon: _isScanning
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
              ),
            )
          : const Icon(Icons.radar_rounded),
      label: Text(_isScanning ? 'Escaneando...' : 'Escanear Tags'),
    );
  }

  Future<void> _startScan() async {
    setState(() => _isScanning = true);
    _scanAnimationController.repeat();

    // Recarregar dados do backend
    final tagsNotifier = ref.read(tagsNotifierProvider.notifier);
    await tagsNotifier.refresh();

    if (mounted) {
      setState(() => _isScanning = false);
      _scanAnimationController.stop();
      _scanAnimationController.reset();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: ThemeColors.of(context).surface,
                size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              const Expanded(child: Text('Diagn?stico atualizado!')),
            ],
          ),
          backgroundColor: ThemeColors.of(context).success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                AppSizes.paddingBase.get(isMobile, isTablet)),
          ),
        ),
      );
    }
  }
}








