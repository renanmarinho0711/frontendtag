import 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

class SugestoesIaScreen extends StatefulWidget {
  const SugestoesIaScreen({super.key});

  @override
  State<SugestoesIaScreen> createState() => _SugestoesIaScreenState();
}

class _SugestoesIaScreenState extends State<SugestoesIaScreen> with ResponsiveCache {
  String _filtroTipo = 'todos';
  bool _carregando = false;
  bool _showSpeedDial = false;

  // TODO: BACKEND - GET /api/ia/estrategias/sugestoes
  List<Map<String, dynamic>> get _sugestoes => _sugestoesMock;
  static final List<Map<String, dynamic>> _sugestoesMock = [
    {
      'produto': 'Coca-Cola 2L',
      'preco_atual': 8.90,
      'preco_sugerido': 9.50,
      'variacao': 6.7,
      'tipo': 'aumento',
      'confianca': 92,
      'motivo': 'Demanda alta e concorr?ncia com pre?os elevados',
      'impacto_vendas': '+8%',
      'impacto_margem': '+12%',
      'cor': ThemeColors.of(context).success,
    },
    {
      'produto': 'Arroz Tipo 1 5kg',
      'preco_atual': 24.90,
      'preco_sugerido': 22.90,
      'variacao': -8.0,
      'tipo': 'reducao',
      'confianca': 88,
      'motivo': 'Concorr?ncia 15% mais barata, estoque alto',
      'impacto_vendas': '+22%',
      'impacto_margem': '-5%',
      'cor': ThemeColors.of(context).errorMain,
    },
    {
      'produto': 'Detergente L?quido',
      'preco_atual': 2.49,
      'preco_sugerido': 2.49,
      'variacao': 0.0,
      'tipo': 'manutencao',
      'confianca': 95,
      'motivo': 'Pre?o competitivo, margem ideal',
      'impacto_vendas': '0%',
      'impacto_margem': '0%',
      'cor': ThemeColors.of(context).info,
    },
    {
      'produto': 'Cerveja Heineken',
      'preco_atual': 4.20,
      'preco_sugerido': 4.80,
      'variacao': 14.3,
      'tipo': 'aumento',
      'confianca': 85,
      'motivo': 'Evento esportivo pr?ximo, pico de demanda esperado',
      'impacto_vendas': '+5%',
      'impacto_margem': '+18%',
      'cor': ThemeColors.of(context).success,
    },
    {
      'produto': 'Macarr?o 500g',
      'preco_atual': 4.59,
      'preco_sugerido': 4.20,
      'variacao': -8.5,
      'tipo': 'reducao',
      'confianca': 78,
      'motivo': 'Produto parado h? 15 dias, acelerar giro',
      'impacto_vendas': '+18%',
      'impacto_margem': '-8%',
      'cor': ThemeColors.of(context).errorMain,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final sugestoesFiltradas = _filtrarSugestoes();
    final aumentos = _sugestoes.where((s) => s['tipo'] == 'aumento').length;
    final reducoes = _sugestoes.where((s) => s['tipo'] == 'reducao').length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sugest?es da IA',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 20,
              mobileFontSize: 18,
              tabletFontSize: 19,
            ),
          overflow: TextOverflow.ellipsis,
          ),
        ),
        backgroundColor: ThemeColors.of(context).primary,
        foregroundColor: ThemeColors.of(context).surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
            ),
            onPressed: _regenerarSugestoes,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: ThemeColors.of(context).backgroundLight,
        ),
        child: _carregando
            ? _buildLoadingState()
            : sugestoesFiltradas.isEmpty
                ? _buildEmptyState()
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildResumoCard(aumentos, reducoes),
                      ),
                      SliverToBoxAdapter(
                        child: _buildFilterBar(),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.all(
                          AppSizes.paddingMdAlt.get(isMobile, isTablet),
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: AppSizes.spacingBase.get(isMobile, isTablet),
                                ),
                                child: _buildSugestaoCard(sugestoesFiltradas[index], index),
                              );
                            },
                            childCount: sugestoesFiltradas.length,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
      floatingActionButton: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_showSpeedDial) ...[
                FloatingActionButton(
                  heroTag: 'fab_filtrar',
                  onPressed: () {
                    _mostrarDialogoFiltro();
                    setState(() => _showSpeedDial = false);
                  },
                  backgroundColor: ThemeColors.of(context).blueMain,
                  child: Icon(
                    Icons.filter_list_rounded,
                    size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
                  ),
                ),
                const SizedBox(height: 12),
                FloatingActionButton(
                  heroTag: 'fab_aplicar',
                  onPressed: () {
                    _aplicarTodasSugestoes();
                    setState(() => _showSpeedDial = false);
                  },
                  backgroundColor: ThemeColors.of(context).primary,
                  child: Icon(
                    Icons.done_all_rounded,
                    size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
          Positioned(
            right: 0,
            bottom: 66,
            child: FloatingActionButton(
              heroTag: 'fab_toggle',
              onPressed: () => setState(() => _showSpeedDial = !_showSpeedDial),
              backgroundColor: _showSpeedDial ? ThemeColors.of(context).error : ThemeColors.of(context).success,
              child: Icon(
                _showSpeedDial ? Icons.close : Icons.menu,
                size: AppSizes.iconLargeFloat.get(isMobile, isTablet),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoFiltro() {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Filtrar Sugest?es',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 18,
              mobileFontSize: 16,
              tabletFontSize: 17,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Todas'),
              value: 'todos',
              groupValue: _filtroTipo,
              onChanged: (value) {
                setState(() => _filtroTipo = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Aumentos'),
              value: 'aumento',
              groupValue: _filtroTipo,
              onChanged: (value) {
                setState(() => _filtroTipo = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Redu??es'),
              value: 'reducao',
              groupValue: _filtroTipo,
              onChanged: (value) {
                setState(() => _filtroTipo = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumoCard(int aumentos, int reducoes) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMdAlt.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingMdAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueCyan],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).primaryLight,
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 12,
              tablet: 13.5,
              desktop: 15,
            ),
            offset: Offset(
              0,
              ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 5,
                tablet: 5.5,
                desktop: 6,
              ),
            ),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 9,
                    tablet: 9.5,
                    desktop: 10,
                  ),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.psychology_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'An?lise Inteligente',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 16,
                          mobileFontSize: 15,
                          tabletFontSize: 15.5,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        mobile: 2,
                        tablet: 2.5,
                        desktop: 2,
                      ),
                    ),
                    Text(
                      'Baseado em IA e Machine Learning',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 11,
                          mobileFontSize: 10,
                          tabletFontSize: 10.5,
                        ),
                      overflow: TextOverflow.ellipsis,
                        color: ThemeColors.of(context).surfaceOverlay70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(
                    ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 9,
                      tablet: 9.5,
                      desktop: 10,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).surfaceOverlay15,
                    borderRadius: BorderRadius.circular(
                      isMobile ? 8 : 10,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        color: ThemeColors.of(context).surface,
                        size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          mobile: 3,
                          tablet: 3.5,
                          desktop: 4,
                        ),
                      ),
                      Text(
                        '$aumentos',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 18,
                            mobileFontSize: 16,
                            tabletFontSize: 17,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).surface,
                        ),
                      ),
                      Text(
                        'Aumentos',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 10,
                            mobileFontSize: 9,
                            tabletFontSize: 9.5,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).surfaceOverlay70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(
                    ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 9,
                      tablet: 9.5,
                      desktop: 10,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).surfaceOverlay15,
                    borderRadius: BorderRadius.circular(
                      isMobile ?  8 : 10,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_down_rounded,
                        color: ThemeColors.of(context).surface,
                        size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          mobile: 3,
                          tablet: 3.5,
                          desktop: 4,
                        ),
                      ),
                      Text(
                        '$reducoes',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 18,
                            mobileFontSize: 16,
                            tabletFontSize: 17,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).surface,
                        ),
                      ),
                      Text(
                        'Redu??es',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 10,
                            mobileFontSize: 9,
                            tabletFontSize: 9.5,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).surfaceOverlay70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet),
        vertical: AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      color: ThemeColors.of(context).surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterChip('Todos', 'todos', Icons.list_rounded),
            SizedBox(
              width: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 7,
                tablet: 7.5,
                desktop: 8,
              ),
            ),
            _buildFilterChip('Aumentos', 'aumento', Icons.trending_up_rounded),
            SizedBox(
              width: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 7,
                tablet: 7.5,
                desktop: 8,
              ),
            ),
            _buildFilterChip('Redu??es', 'reducao', Icons.trending_down_rounded),
            SizedBox(
              width: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 7,
                tablet: 7.5,
                desktop: 8,
              ),
            ),
            _buildFilterChip('Manter', 'manutencao', Icons.horizontal_rule_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon) {
    final isSelected = _filtroTipo == value;
    final isMobile = ResponsiveHelper.isMobile(context);

    return InkWell(
      onTap: () => setState(() => _filtroTipo = value),
      borderRadius: BorderRadius.circular(
        isMobile ? 18 : 20,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSm.get(isMobile, isTablet),
          vertical: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 7,
            tablet: 7.5,
            desktop: 8,
          ),
        ),
        decoration: BoxDecoration(
          color: isSelected ?  ThemeColors.of(context).primaryLight : ThemeColors.of(context).textSecondary,
          borderRadius: BorderRadius.circular(
            isMobile ? 18 : 20,
          ),
          border: Border.all(
            color: isSelected ? ThemeColors.of(context).primary : ThemeColors.of(context).borderLight,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 15,
                tablet: 15.5,
                desktop: 16,
              ),
              color: isSelected ? ThemeColors.of(context).primary : ThemeColors.of(context).textSecondary,
            ),
            SizedBox(
              width: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 5,
                tablet: 5.5,
                desktop: 6,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12.5,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? ThemeColors.of(context).primary : ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSugestaoCard(Map<String, dynamic> sugestao, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 14 : (isTablet ? 15 : 16),
          ),
          border: Border.all(
            color: (sugestao['cor'] as Color)Light,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (sugestao['cor'] as Color)Light,
              blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
                context,
                mobile: 12,
                tablet: 13.5,
                desktop: 15,
              ),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(
                AppSizes.paddingMdAlt.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: (sugestao['cor'] as Color)Light,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    isMobile ? 12 : 14,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 9,
                        tablet: 9.5,
                        desktop: 10,
                      ),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [sugestao['cor'], (sugestao['cor'] as Color).withValues(alpha: 0.7)],
                      ),
                      borderRadius: BorderRadius.circular(
                        isMobile ? 8 : 10,
                      ),
                    ),
                    child: Icon(
                      _getTipoIcon(sugestao['tipo']),
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.spacingBase.get(isMobile, isTablet),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sugestao['produto'],
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 16,
                              mobileFontSize: 15,
                              tabletFontSize: 15.5,
                            ),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            mobile: 3,
                            tablet: 3.5,
                            desktop: 4,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: ResponsiveHelper.getResponsiveIconSize(
                                context,
                                mobile: 13,
                                tablet: 13.5,
                                desktop: 14,
                              ),
                              color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.7),
                            ),
                            SizedBox(
                              width: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                mobile: 3,
                                tablet: 3.5,
                                desktop: 4,
                              ),
                            ),
                            Text(
                              'Confian?a: ${sugestao['confianca']}%',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 12,
                                  mobileFontSize: 11,
                                  tabletFontSize: 11.5,
                                ),
                              overflow: TextOverflow.ellipsis,
                                color: ThemeColors.of(context).primaryDark,
                                fontWeight: FontWeight.w600,
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
            Padding(
              padding: EdgeInsets.all(
                AppSizes.paddingMdAlt.get(isMobile, isTablet),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pre?o Atual',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 12,
                                  mobileFontSize: 11,
                                  tabletFontSize: 11.5,
                                ),
                              overflow: TextOverflow.ellipsis,
                                color: ThemeColors.of(context).textSecondary,
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                mobile: 3,
                                tablet: 3.5,
                                desktop: 4,
                              ),
                            ),
                            Text(
                              'R\$ ${sugestao['preco_atual'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 18,
                                  mobileFontSize: 16,
                                  tabletFontSize: 17,
                                ),
                              overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: ThemeColors.of(context).textSecondaryOverlay80,
                                decoration: sugestao['tipo'] != 'manutencao'
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: sugestao['cor'],
                        size: AppSizes.iconLargeAlt.get(isMobile, isTablet),
                      ),
                      SizedBox(
                        width: AppSizes.spacingBase.get(isMobile, isTablet),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pre?o Sugerido',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 12,
                                  mobileFontSize: 11,
                                  tabletFontSize: 11.5,
                                ),
                              overflow: TextOverflow.ellipsis,
                                color: ThemeColors.of(context).textSecondary,
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                mobile: 3,
                                tablet: 3.5,
                                desktop: 4,
                              ),
                            ),
                            Text(
                              'R\$ ${sugestao['preco_sugerido'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 20,
                                  mobileFontSize: 18,
                                  tabletFontSize: 19,
                                ),
                              overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: sugestao['cor'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (sugestao['variacao'] != 0) ...[
                    SizedBox(
                      height: AppSizes.spacingBase.get(isMobile, isTablet),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.getResponsivePadding(
                          context,
                          mobile: 9,
                          tablet: 9.5,
                          desktop: 10,
                        ),
                        vertical: ResponsiveHelper.getResponsivePadding(
                          context,
                          mobile: 5,
                          tablet: 5.5,
                          desktop: 6,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: (sugestao['cor'] as Color)Light,
                        borderRadius: BorderRadius.circular(
                          isMobile ?  7 : 8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            sugestao['variacao'] > 0
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            size: ResponsiveHelper.getResponsiveIconSize(
                              context,
                              mobile: 15,
                              tablet: 15.5,
                              desktop: 16,
                            ),
                            color: sugestao['cor'],
                          ),
                          SizedBox(
                            width: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              mobile: 5,
                              tablet: 5.5,
                              desktop: 6,
                            ),
                          ),
                          Text(
                            '${sugestao['variacao'] > 0 ? '+' : ''}${sugestao['variacao'].toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 14,
                                mobileFontSize: 13,
                                tabletFontSize: 13.5,
                              ),
                            overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: sugestao['cor'],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(
                    height: AppSizes.spacingMdAlt.get(isMobile, isTablet),
                  ),
                  const Divider(height: 1),
                  SizedBox(
                    height: AppSizes.spacingBase.get(isMobile, isTablet),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lightbulb_rounded,
                        size: ResponsiveHelper.getResponsiveIconSize(
                          context,
                          mobile: 17,
                          tablet: 17.5,
                          desktop: 18,
                        ),
                        color: ThemeColors.of(context).warningDark,
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          mobile: 7,
                          tablet: 7.5,
                          desktop: 8,
                        ),
                      ),
                      Text(
                        'Motivo:',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 13,
                            mobileFontSize: 12,
                            tabletFontSize: 12.5,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(
                      context,
                      mobile: 5,
                      tablet: 5.5,
                      desktop: 6,
                    ),
                  ),
                  Text(
                    sugestao['motivo'],
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 13,
                        mobileFontSize: 12,
                        tabletFontSize: 12.5,
                      ),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).textSecondary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.spacingBase.get(isMobile, isTablet),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(
                            ResponsiveHelper.getResponsivePadding(
                              context,
                              mobile: 9,
                              tablet: 9.5,
                              desktop: 10,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: ThemeColors.of(context).textSecondary,
                            borderRadius: BorderRadius.circular(
                              isMobile ? 7 : 8,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Vendas',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 11,
                                    mobileFontSize: 10,
                                    tabletFontSize: 10.5,
                                  ),
                                overflow: TextOverflow.ellipsis,
                                  color: ThemeColors.of(context).textSecondary,
                                ),
                              ),
                              SizedBox(
                                height: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  mobile: 3,
                                  tablet: 3.5,
                                  desktop: 4,
                                ),
                              ),
                              Text(
                                sugestao['impacto_vendas'],
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 14,
                                    mobileFontSize: 13,
                                    tabletFontSize: 13.5,
                                  ),
                                overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          mobile: 9,
                          tablet: 9.5,
                          desktop: 10,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(
                            ResponsiveHelper.getResponsivePadding(
                              context,
                              mobile: 9,
                              tablet: 9.5,
                              desktop: 10,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: ThemeColors.of(context).textSecondary,
                            borderRadius: BorderRadius.circular(
                              isMobile ? 7 : 8,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Margem',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 11,
                                    mobileFontSize: 10,
                                    tabletFontSize: 10.5,
                                  ),
                                overflow: TextOverflow.ellipsis,
                                  color: ThemeColors.of(context).textSecondary,
                                ),
                              ),
                              SizedBox(
                                height: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  mobile: 3,
                                  tablet: 3.5,
                                  desktop: 4,
                                ),
                              ),
                              Text(
                                sugestao['impacto_margem'],
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 14,
                                    mobileFontSize: 13,
                                    tabletFontSize: 13.5,
                                  ),
                                overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppSizes.spacingBase.get(isMobile, isTablet),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _rejeitarSugestao(sugestao),
                          icon: Icon(
                            Icons.close_rounded,
                            size: ResponsiveHelper.getResponsiveIconSize(
                              context,
                              mobile: 17,
                              tablet: 17.5,
                              desktop: 18,
                            ),
                          ),
                          label: Text(
                            'Rejeitar',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 13,
                                mobileFontSize: 12,
                                tabletFontSize: 12.5,
                              ),
                            overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ThemeColors.of(context).textSecondary,
                            side: BorderSide(color: ThemeColors.of(context).textSecondary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isMobile ? 8 : 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          mobile: 9,
                          tablet: 9.5,
                          desktop: 10,
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _aplicarSugestao(sugestao),
                          icon: Icon(
                            Icons.check_rounded,
                            size: ResponsiveHelper.getResponsiveIconSize(
                              context,
                              mobile: 17,
                              tablet: 17.5,
                              desktop: 18,
                            ),
                          ),
                          label: Text(
                            'Aplicar',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 13,
                                mobileFontSize: 12,
                                tabletFontSize: 12.5,
                              ),
                            overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: sugestao['cor'],
                            foregroundColor: ThemeColors.of(context).surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isMobile ? 8 : 10,
                              ),
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
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).primary),
          ),
          SizedBox(
            height: AppSizes.spacingLg.get(isMobile, isTablet),
          ),
          Text(
            'Analisando produtos...',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 16,
                mobileFontSize: 15,
                tabletFontSize: 15.5,
              ),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: AppSizes.iconHeroXl.get(isMobile, isTablet),
            color: ThemeColors.of(context).success,
          ),
          SizedBox(
            height: AppSizes.spacingMdAlt.get(isMobile, isTablet),
          ),
          Text(
            'Nenhuma sugest?o nesta categoria',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 16,
                mobileFontSize: 15,
                tabletFontSize: 15.5,
              ),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTipoIcon(String tipo) {
    switch (tipo) {
      case 'aumento':
        return Icons.trending_up_rounded;
      case 'reducao':
        return Icons.trending_down_rounded;
      default:
        return Icons.horizontal_rule_rounded;
    }
  }

  List<Map<String, dynamic>> _filtrarSugestoes() {
    if (_filtroTipo == 'todos') return _sugestoes;
    return _sugestoes.where((s) => s['tipo'] == _filtroTipo).toList();
  }

  void _regenerarSugestoes() {
    final isMobile = ResponsiveHelper.isMobile(context);

    setState(() => _carregando = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: ThemeColors.of(context).surface,
                size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Text(
                'Sugest?es atualizadas pela IA',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: ThemeColors.of(context).primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              isMobile ? 10 : 12,
            ),
          ),
        ),
      );
    });
  }

  void _aplicarSugestao(Map<String, dynamic> sugestao) {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 18 : 20,
          ),
        ),
        title: Text(
          'Aplicar Sugest?o',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 18,
              mobileFontSize: 16,
              tabletFontSize: 17,
            ),
          overflow: TextOverflow.ellipsis,
          ),
        ),
        content: Text(
          'Alterar pre?o de "${sugestao['produto']}" para R\$ ${sugestao['preco_sugerido'].toStringAsFixed(2)}?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
              tabletFontSize: 13.5,
            ),
          overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13.5,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _sugestoes.remove(sugestao);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: ThemeColors.of(context).surface,
                        size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                      ),
                      SizedBox(
                        width: AppSizes.spacingBase.get(isMobile, isTablet),
                      ),
                      Text(
                        'Pre?o aplicado com sucesso',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 13,
                          ),
                        overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: ThemeColors.of(context).greenMain,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      isMobile ? 10 : 12,
                    ),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: sugestao['cor'],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
            ),
            child: Text(
              'Aplicar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13.5,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _rejeitarSugestao(Map<String, dynamic> sugestao) {
    final isMobile = ResponsiveHelper.isMobile(context);

    setState(() {
      _sugestoes.remove(sugestao);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.spacingBase.get(isMobile, isTablet),
            ),
            Text(
              'Sugest?o rejeitada',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: ThemeColors.of(context).textSecondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 10 : 12,
          ),
        ),
      ),
    );
  }

  void _aplicarTodasSugestoes() {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 18 : 20,
          ),
        ),
        icon: Icon(
          Icons.done_all_rounded,
          color: ThemeColors.of(context).primary,
          size: AppSizes.iconHeroSm.get(isMobile, isTablet),
        ),
        title: Text(
          'Aplicar Todas',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 18,
              mobileFontSize: 16,
              tabletFontSize: 17,
            ),
          overflow: TextOverflow.ellipsis,
          ),
        ),
        content: Text(
          'Aplicar ${_sugestoes.length} sugest?es da IA automaticamente?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
              tabletFontSize: 13.5,
            ),
          overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13.5,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final total = _sugestoes.length;
              setState(() {
                _sugestoes.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: ThemeColors.of(context).surface,
                        size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                      ),
                      SizedBox(
                        width: AppSizes.spacingBase.get(isMobile, isTablet),
                      ),
                      Text(
                        '$total sugest?es aplicadas',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 13,
                          ),
                        overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: ThemeColors.of(context).greenMain,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
            ),
            child: Text(
              'Confirmar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13.5,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}












