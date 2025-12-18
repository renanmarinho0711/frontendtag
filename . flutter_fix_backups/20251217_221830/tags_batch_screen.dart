import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/tags/data/models/tag_model.dart';
import 'package:tagbean/features/tags/presentation/providers/tags_provider.dart';
import 'package:tagbean/features/sync/presentation/providers/sync_provider.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';

class EtiquetasOperacoesLoteScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  
  const EtiquetasOperacoesLoteScreen({super.key, this.onBack});

  @override
  ConsumerState<EtiquetasOperacoesLoteScreen> createState() => _EtiquetasOperacoesLoteScreenState();
}

class _EtiquetasOperacoesLoteScreenState extends ConsumerState<EtiquetasOperacoesLoteScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  int _operacaoSelecionada = 0; // 0: Desassociar, 1: Excluir, 2: Sincronizar
  
  final Set<String> _tagsDesassociar = {};
  // NOTA: _tagsExcluir removido (morto)
  String _filtroSincronizar = 'Todas';
  String _categoriaFiltro = 'Todas';
  bool _processando = false;

  /// Total de tags do provider
  int get _totalTags => ref.watch(tagsNotifierProvider).tags.length;

  // Operações disponíveis (configuração dinâmica com tema)
  List<Map<String, dynamic>> _getOperacoes(BuildContext context) => [
    {
      'id': 0,
      'titulo': 'Desassociar',
      'subtitulo': 'Remover vínculo com produtos',
      'icone': Icons.link_off_rounded,
      'cor': ThemeColors.of(context).orangeMain,
      'gradiente': [ThemeColors.of(context).orangeMain, ThemeColors.of(context).warning],
    },
    {
      'id': 1,
      'titulo': 'Excluir',
      'subtitulo': 'Remover tags do sistema',
      'icone': Icons.delete_rounded,
      'cor': ThemeColors.of(context).error,
      'gradiente': [ThemeColors.of(context).error, ThemeColors.of(context).errorDark],
    },
    {
      'id': 2,
      'titulo': 'Sincronizar',
      'subtitulo': 'Atualizar múltiplas tags',
      'icone': Icons.sync_rounded,
      'cor': ThemeColors.of(context).blueMain,
      'gradiente': [ThemeColors.of(context).blueMain, ThemeColors.of(context).blueDark],
    },
  ];

  // Obter tags disponíveis do provider
  List<TagModel> _getTagsDisponiveis(List<TagModel> allTags) {
    if (_categoriaFiltro == 'Associadas') {
      return allTags.where((t) => t.isBound).toList();
    } else if (_categoriaFiltro == 'Disponíveis') {
      return allTags.where((t) => !t.isBound).toList();
    }
    return allTags;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tagsState = ref.watch(tagsNotifierProvider);
    
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: tagsState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorWidget(error.toString()),
          data: (tags) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModernAppBar(),
                _buildOperationSelector(),
                Padding(
                  padding: EdgeInsets.all(
                    AppSizes.cardPadding.get(isMobile, isTablet),
                  ),
                  child: _buildOperationContent(tags),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: ThemeColors.of(context).error),
            SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
            const Text('Erro ao carregar tags', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
            Text(error, textAlign: TextAlign.center),
            SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(tagsNotifierProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernAppBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
        vertical: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).blueCyan,
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).surface,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              onPressed: widget.onBack ?? () => Navigator.pop(context),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingSmAlt.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
              ),
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
            child: Icon(
              Icons.layers_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Operações em Lote',
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
                Text(
                  'Gerenciar mãltiplas tags',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationSelector() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      height: ResponsiveHelper.getResponsiveHeight(
        context,
        mobile: 130,
        tablet: 135,
        desktop: 140,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _getOperacoes(context).length,
        itemBuilder: (context, index) {
          final op = _getOperacoes(context)[index];
          final isSelected = _operacaoSelecionada == op['id'];
          
          return TweenAnimationBuilder(
            duration: Duration(milliseconds: 300 + (index * 100)),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: Container(
              width: ResponsiveHelper.getResponsiveWidth(
                context,
                mobile: 130,
                tablet: 135,
                desktop: 140,
              ),
              margin: EdgeInsets.only(
                right: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _operacaoSelecionada = op['id'];
                  });
                },
                borderRadius: BorderRadius.circular(
                  isMobile ? 16 : (isTablet ? 18 : 20),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(
                    AppSizes.paddingMdAlt.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(colors: op['gradiente'])
                        : null,
                    color: isSelected ? null : ThemeColors.of(context).surface,
                    borderRadius: BorderRadius.circular(
                      isMobile ? 16 : (isTablet ? 18 : 20),
                    ),
                    border: Border.all(
                      color: isSelected
                          ? ThemeColors.of(context).transparent
                          : (op['cor'] as Color).withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? (op['cor'] as Color).withValues(alpha: 0.3)
                            : ThemeColors.of(context).textPrimaryOverlay05,
                        blurRadius: isMobile ? 15 : 20,
                        offset: Offset(0, isMobile ? 6 : 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                          AppSizes.paddingBase.get(isMobile, isTablet),
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ThemeColors.of(context).surfaceOverlay20
                              : (op['cor'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                        ),
                        child: Icon(
                          op['icone'],
                          color: isSelected ? ThemeColors.of(context).surface : op['cor'],
                          size: AppSizes.iconLarge.get(isMobile, isTablet),
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.paddingBase.get(isMobile, isTablet),
                      ),
                      Text(
                        op['titulo'],
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 13,
                            tabletFontSize: 13,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textPrimary,
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.paddingXxs.get(isMobile, isTablet),
                      ),
                      Text(
                        op['subtitulo'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 10,
                            mobileFontSize: 9,
                            tabletFontSize: 9,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: isSelected
                              ? ThemeColors.of(context).surfaceOverlay90
                              : ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOperationContent(List<TagModel> tags) {
    switch (_operacaoSelecionada) {
      case 0:
        return _buildDesassociarContent(tags);
      case 1:
        return _buildExcluirContent(tags);
      case 2:
        return _buildSincronizarContent(tags);
      default:
        return Container();
    }
  }

  Widget _buildDesassociarContent(List<TagModel> allTags) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final tagsAssociadas = allTags.where((t) => t.isBound).toList();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(
            AppSizes.paddingXl.get(isMobile, isTablet),
          ),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).surface,
            borderRadius: BorderRadius.circular(
              isMobile ? 16 : (isTablet ? 18 : 20),
            ),
            boxShadow: [
              BoxShadow(
                color: ThemeColors.of(context).textPrimaryOverlay05,
                blurRadius: isMobile ? 8 : 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      AppSizes.paddingXs.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ThemeColors.of(context).orangeMaterial, ThemeColors.of(context).warning],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                    ),
                    child: Icon(
                      Icons.link_off_rounded,
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconSmall.get(isMobile, isTablet),
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  Expanded(
                    child: Text(
                      'Desassociar Mãltiplas Tags',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 16,
                          mobileFontSize: 15,
                          tabletFontSize: 15,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  if (_tagsDesassociar.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                        vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).warningLight,
                        borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                      ),
                      child: Text(
                        '${_tagsDesassociar.length} selecionadas',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 11,
                            mobileFontSize: 10,
                            tabletFontSize: 10,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).warningDark,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
              ),
              Text(
                'Selecione as tags que deseja desassociar dos produtos:',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                    tabletFontSize: 12,
                  ),
                overflow: TextOverflow.ellipsis,
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
              ),
              ...tagsAssociadas.map((tag) {
                final isSelected = _tagsDesassociar.contains(tag.id);
                return Container(
                  margin: EdgeInsets.only(
                    bottom: AppSizes.paddingXs.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? ThemeColors.of(context).warningPastel : ThemeColors.of(context).textSecondary,
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                    border: Border.all(
                      color: isSelected ?  ThemeColors.of(context).warning : ThemeColors.of(context).textSecondary,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _tagsDesassociar.add(tag.id);
                        } else {
                          _tagsDesassociar.remove(tag.id);
                        }
                      });
                    },
                    title: Text(
                      tag.id,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 13,
                          mobileFontSize: 12,
                          tabletFontSize: 12,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      tag.productName ?? '',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 11,
                          mobileFontSize: 10,
                          tabletFontSize: 10,
                        ),
                      overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    secondary: Container(
                      padding: EdgeInsets.all(
                        AppSizes.paddingXs.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? ThemeColors.of(context).orangeMain : ThemeColors.of(context).textSecondaryOverlay40,
                        borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                      ),
                      child: Icon(
                        Icons.label_rounded,
                        color: ThemeColors.of(context).surface,
                        size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                      ),
                    ),
                    activeColor: ThemeColors.of(context).orangeMain,
                  ),
                );
              }),
              SizedBox(
                height: AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        size: AppSizes.iconSmall.get(isMobile, isTablet),
                      ),
                      label: Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 13,
                            tabletFontSize: 13,
                          ),
                        overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.paddingSm.get(isMobile, isTablet),
                        ),
                        side: BorderSide(color: ThemeColors.of(context).textSecondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _tagsDesassociar.isEmpty ?  null : _executarDesassociacao,
                      icon: Icon(
                        Icons.check_rounded,
                        size: AppSizes.iconSmall.get(isMobile, isTablet),
                      ),
                      label: Text(
                        'Executar DesassociAção',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 13,
                            tabletFontSize: 13,
                          ),
                        overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.paddingSm.get(isMobile, isTablet),
                        ),
                        backgroundColor: ThemeColors.of(context).orangeMain,
                        foregroundColor: ThemeColors.of(context).surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExcluirContent(List<TagModel> allTags) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final tagsDisponiveis = allTags;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(
            AppSizes.paddingXl.get(isMobile, isTablet),
          ),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).surface,
            borderRadius: BorderRadius.circular(
              isMobile ? 16 : (isTablet ? 18 : 20),
            ),
            boxShadow: [
              BoxShadow(
                color: ThemeColors.of(context).textPrimaryOverlay05,
                blurRadius: isMobile ? 8 : 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      AppSizes.paddingXs.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ThemeColors.of(context).error, ThemeColors.of(context).redDark],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                    ),
                    child: Icon(
                      Icons.delete_rounded,
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconSmall.get(isMobile, isTablet),
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  Text(
                    'Excluir Mãltiplas Tags',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 16,
                        mobileFontSize: 15,
                        tabletFontSize: 15,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
              ),
              Text(
                'Escolha o método de seleção:',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                    tabletFontSize: 12,
                  ),
                overflow: TextOverflow.ellipsis,
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: _buildExclusionMethod(
                      'Upload Planilha',
                      'Importar lista',
                      Icons.upload_file_rounded,
                      ThemeColors.of(context).blueMain,
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  Expanded(
                    child: _buildExclusionMethod(
                      'Seleção Manual',
                      'Escolher tags',
                      Icons.checklist_rounded,
                      ThemeColors.of(context).blueCyan,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingMdAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).errorPastel,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  border: Border.all(color: ThemeColors.of(context).errorLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: ThemeColors.of(context).errorDark,
                      size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                    ),
                    SizedBox(
                      width: AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    Expanded(
                      child: Text(
                        'ATENÇÃO: Esta operação não pode ser desfeita!',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 12,
                            mobileFontSize: 11,
                            tabletFontSize: 11,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).errorDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExclusionMethod(String title, String subtitle, IconData icon, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Abrindo $title...',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
      child: Container(
        padding: EdgeInsets.all(
          AppSizes.paddingMdAlt.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(
                AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
              child: Icon(
                icon,
                color: ThemeColors.of(context).surface,
                size: AppSizes.iconLarge.get(isMobile, isTablet),
              ),
            ),
            SizedBox(
              height: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(
              height: AppSizes.paddingXxs.get(isMobile, isTablet),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 10,
                  mobileFontSize: 9,
                  tabletFontSize: 9,
                ),
              overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSincronizarContent(List<TagModel> allTags) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final tagsDisponiveis = _getTagsDisponiveis(allTags);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(
            AppSizes.paddingXl.get(isMobile, isTablet),
          ),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).surface,
            borderRadius: BorderRadius.circular(
              isMobile ? 16 : (isTablet ? 18 : 20),
            ),
            boxShadow: [
              BoxShadow(
                color: ThemeColors.of(context).textPrimaryOverlay05,
                blurRadius: isMobile ?  8 : 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      AppSizes.paddingXs.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                    ),
                    child: Icon(
                      Icons.sync_rounded,
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconSmall.get(isMobile, isTablet),
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  Text(
                    'Sincronizar Grupo de Tags',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 16,
                        mobileFontSize: 15,
                        tabletFontSize: 15,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
              ),
              Text(
                'Filtros para seleção:',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                    tabletFontSize: 12,
                  ),
                overflow: TextOverflow.ellipsis,
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
              ),
              DropdownButtonFormField<String>(
                initialValue: _filtroSincronizar,
                decoration: InputDecoration(
                  labelText: 'Status',
                  labelStyle: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.filter_list_rounded,
                    size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                    vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                  ),
                  isDense: true,
                ),
                items: ['Todas', 'Associadas', 'Disponíveis', 'Offline']
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 13,
                                mobileFontSize: 12,
                                tabletFontSize: 12,
                              ),
                            overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _filtroSincronizar = value! ;
                  });
                },
              ),
              SizedBox(
                height: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              DropdownButtonFormField<String>(
                initialValue: _categoriaFiltro,
                decoration: InputDecoration(
                  labelText: 'Categoria de Produtos',
                  labelStyle: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.category_rounded,
                    size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                    vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                  ),
                  isDense: true,
                ),
                items: ['Todas', 'Bebidas', 'Mercearia', 'Perecveis']
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 13,
                                mobileFontSize: 12,
                                tabletFontSize: 12,
                              ),
                            overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _categoriaFiltro = value! ;
                  });
                },
              ),
              SizedBox(
                height: AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingMdAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).infoPastel,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  border: Border.all(color: ThemeColors.of(context).infoLight),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_rounded,
                          size: AppSizes.iconTiny.get(isMobile, isTablet),
                          color: ThemeColors.of(context).infoDark,
                        ),
                        SizedBox(
                          width: AppSizes.paddingXs.get(isMobile, isTablet),
                        ),
                        Text(
                          'Resumo da Sincronização',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 12,
                              mobileFontSize: 11,
                              tabletFontSize: 11,
                            ),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).infoDark,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    _buildSummaryRow(Icons.label_rounded, '$_totalTags tags encontradas'),
                    SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                    _buildSummaryRow(Icons.timer_rounded, 'Tempo estimado: ~2 minutos'),
                    SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                    _buildSummaryRow(Icons.data_usage_rounded, 'Dados: ~450 KB'),
                  ],
                ),
              ),
              SizedBox(
                height: AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)),
                      label: Text('Cancelar', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.paddingSm.get(isMobile, isTablet)),
                        side: BorderSide(color: ThemeColors.of(context).textSecondary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _processando ? null : _executarSincronizacao,
                      icon: _processando
                          ? SizedBox(
                              width: ResponsiveHelper.getResponsiveWidth(context, mobile: 14, tablet: 15, desktop: 16),
                              height: ResponsiveHelper.getResponsiveHeight(context, mobile: 14, tablet: 15, desktop: 16),
                              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface)),
                            )
                          : Icon(Icons.sync_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)),
                      label: Text(_processando ? 'Sincronizando...' : 'Executar Sincronização', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.paddingSm.get(isMobile, isTablet)),
                        backgroundColor: ThemeColors.of(context).blueMain,
                        foregroundColor: ThemeColors.of(context).surface,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSizes.iconExtraSmall.get(isMobile, isTablet), color: ThemeColors.of(context).textSecondary),
        SizedBox(width: AppSizes.paddingXs.get(isMobile, isTablet)),
        Text(text, style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11), color: ThemeColors.of(context).textSecondary)),
      ],
    );
  }

  void _executarDesassociacao() {
    final isMobile = ResponsiveHelper.isMobile(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet))),
        icon: Icon(Icons.link_off_rounded, color: ThemeColors.of(context).orangeMain, size: AppSizes.iconHeroSmAlt.get(isMobile, isTablet)),
        title: Text('Confirmar DesassociAção', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17))),
        content: Text('Deseja desassociar ${_tagsDesassociar.length} tag(s) selecionada(s)?', textAlign: TextAlign.center, style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13)))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _processando = true);
              
              try {
                // Obter storeId do work context
                final workContext = ref.read(workContextProvider);
                final storeId = workContext.context.currentStoreId ?? '';
                
                if (storeId.isEmpty) {
                  if (mounted) {
                    setState(() => _processando = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Selecione uma loja primeiro'),
                        backgroundColor: ThemeColors.of(context).errorIcon,
                      ),
                    );
                  }
                  return;
                }
                
                // Executar desassociAção em lote via notifier
                final result = await ref.read(tagsNotifierProvider.notifier).batchUnbindTags(
                  storeId: storeId,
                  macAddresses: _tagsDesassociar.toList(),
                );
                
                if (mounted) {
                  setState(() => _processando = false);
                  
                  if (result != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMediumSmall.get(isMobile, isTablet)),
                            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                            Expanded(
                              child: Text(
                                '${result.successCount} tags desassociadas!',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: ThemeColors.of(context).orangeMain,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
                      ),
                    );
                    setState(() => _tagsDesassociar.clear());
                  } else {
                    final error = ref.read(tagsNotifierProvider).error;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error ?? 'Erro ao desassociar tags'),
                        backgroundColor: ThemeColors.of(context).errorIcon,
                      ),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  setState(() => _processando = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro: $e'),
                      backgroundColor: ThemeColors.of(context).errorIcon,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: ThemeColors.of(context).orangeMain, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)))),
            child: Text('Confirmar', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
          ),
        ],
      ),
    );
  }

  void _executarSincronizacao() async {
    final isMobile = ResponsiveHelper.isMobile(context);
    setState(() => _processando = true);
    
    try {
      // Obter storeId do work context
      final workContext = ref.read(workContextProvider);
      final storeId = workContext.context.currentStoreId ?? '';
      
      if (storeId.isEmpty) {
        if (mounted) {
          setState(() => _processando = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Selecione uma loja primeiro'),
              backgroundColor: ThemeColors.of(context).errorIcon,
            ),
          );
        }
        return;
      }
      
      // Executar sincronização real via provider
      final result = await ref.read(syncProvider.notifier).syncTags(storeId);
      
      if (mounted) {
        setState(() => _processando = false);
        Navigator.pop(context);
        
        if (result != null && result.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMediumSmall.get(isMobile, isTablet)),
                  SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                  Flexible(
                    child: Text(
                      'Sincronização Concluída! ${result.successCount} de ${result.totalProcessed} tags.',
                      style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13)),
                    ),
                  ),
                ],
              ),
              backgroundColor: ThemeColors.of(context).blueMain,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
              duration: const Duration(seconds: 3),
            ),
          );
          
          // Atualizar lista de tags
          ref.read(tagsNotifierProvider.notifier).refresh();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result?.errors.firstOrNull ?? 'Erro ao sincronizar'),
              backgroundColor: ThemeColors.of(context).errorIcon,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _processando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: ThemeColors.of(context).errorIcon,
          ),
        );
      }
    }
  }
}






