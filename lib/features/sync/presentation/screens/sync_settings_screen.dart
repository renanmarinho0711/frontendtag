import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/sync/presentation/providers/sync_provider.dart';
import 'package:tagbean/features/sync/data/models/sync_models.dart';
import 'package:tagbean/features/sync/data/repositories/sync_repository.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

class SincronizacaoConfiguracoesScreen extends ConsumerStatefulWidget {
  const SincronizacaoConfiguracoesScreen({super.key});

  @override
  ConsumerState<SincronizacaoConfiguracoesScreen> createState() => _SincronizacaoConfiguracoesScreenState();
}

class _SincronizacaoConfiguracoesScreenState extends ConsumerState<SincronizacaoConfiguracoesScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  final _intervaloController = TextEditingController(text: '15');
  String _modo = 'Passivo';
  bool _notificarErro = true;
  bool _notificarSucesso = false;
  bool _sincPrecos = true;
  bool _sincEstoque = false;
  bool _sincProdutosNovos = true;
  bool _sincImagens = false;
  bool _testando = false;

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
    _intervaloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModernAppBar(),
              Padding(
                padding: EdgeInsets.all(
                  AppSizes.cardPadding.get(isMobile, isTablet),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildIntervaloCard(),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    _buildModoCard(),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    _buildDadosCard(),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    _buildNotificacoesCard(),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    _buildConexaoCard(),
                    SizedBox(
                      height: AppSizes.cardPadding.get(isMobile, isTablet),
                    ),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ],
          ),
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
              color: ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textSecondary,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              onPressed: () => Navigator.pop(context),
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
                colors: [ThemeColors.of(context).primary, ThemeColors.of(context).info],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.settings_rounded,
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
                  'Configura??es',
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
                  'Par?metros de sincroniza??o',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
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

  Widget _buildIntervaloCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.schedule_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Intervalo de Sincroniza??o',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          TextFormField(
            controller: _intervaloController,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
              ),
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Intervalo do Job (minutos)',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 12,
                  mobileFontSize: 11,
                ),
              ),
              hintText: 'Ex: 15',
              prefixIcon: Icon(
                Icons.timer_rounded,
                size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
              ),
              suffixText: 'min',
              helperText: 'Tempo entre sincroniza??es autom?ticas',
              helperStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 11,
                  mobileFontSize: 10,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                vertical: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              isDense: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).infoPastel,
              borderRadius: BorderRadius.circular(
                isMobile ? 8 : 10,
              ),
              border: Border.all(color: ThemeColors.of(context).infoLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_rounded,
                  size: AppSizes.iconTiny.get(isMobile, isTablet),
                  color: ThemeColors.of(context).infoDark,
                ),
                SizedBox(
                  width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                ),
                Expanded(
                  child: Text(
                    'Intervalo m?nimo recomendado: 5 minutos',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                      ),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).infoDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.mode_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Modo de Opera??o',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _buildModoButton('Passivo', Icons.visibility_rounded),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildModoButton('Ativo', Icons.bolt_rounded),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: _modo == 'Passivo' ? ThemeColors.of(context).warningPastel : ThemeColors.of(context).successPastel,
              borderRadius: BorderRadius.circular(
                isMobile ? 8 : 10,
              ),
              border: Border.all(
                color: _modo == 'Passivo' ? ThemeColors.of(context).warningLight : ThemeColors.of(context).successLight,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_rounded,
                  size: AppSizes.iconTiny.get(isMobile, isTablet),
                  color: _modo == 'Passivo' ? ThemeColors.of(context).warningDark : ThemeColors.of(context).successIcon,
                ),
                SizedBox(
                  width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                ),
                Expanded(
                  child: Text(
                    _modo == 'Passivo'
                        ? 'Modo Passivo: Apenas l? dados do ERP'
                        : 'Modo Ativo: Envia e recebe dados do ERP',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                      ),
                    overflow: TextOverflow.ellipsis,
                      color: _modo == 'Passivo' ? ThemeColors.of(context).warningDark : ThemeColors.of(context).successText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModoButton(String modo, IconData icon) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isSelected = _modo == modo;
    
    return InkWell(
      onTap: () {
        setState(() {
          _modo = modo;
        });
      },
      borderRadius: BorderRadius.circular(
        isMobile ? 10 : 12,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingSm.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: isSelected ? ThemeColors.of(context).primaryPastel : ThemeColors.of(context).textSecondary,
          borderRadius: BorderRadius.circular(
            isMobile ? 10 : 12,
          ),
          border: Border.all(
            color: isSelected ? ThemeColors.of(context).blueCyan : ThemeColors.of(context).textSecondaryOverlay40,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? ThemeColors.of(context).blueCyan : ThemeColors.of(context).textSecondary,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
            ),
            Text(
              modo,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? ThemeColors.of(context).blueCyan : ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDadosCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).primaryPastel, ThemeColors.of(context).yellowGold],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ?  10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.data_usage_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Dados para Sincronizar',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          _buildDadoSwitch(
            'Pre?os',
            'Sincronizar pre?os dos produtos',
            _sincPrecos,
            Icons.attach_money_rounded,
            (value) => setState(() => _sincPrecos = value),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildDadoSwitch(
            'Estoque',
            'Sincronizar quantidade em estoque',
            _sincEstoque,
            Icons.inventory_rounded,
            (value) => setState(() => _sincEstoque = value),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildDadoSwitch(
            'Produtos Novos',
            'Importar produtos cadastrados no ERP',
            _sincProdutosNovos,
            Icons.new_releases_rounded,
            (value) => setState(() => _sincProdutosNovos = value),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildDadoSwitch(
            'Imagens',
            'Sincronizar imagens dos produtos',
            _sincImagens,
            Icons.image_rounded,
            (value) => setState(() => _sincImagens = value),
          ),
        ],
      ),
    );
  }

  Widget _buildDadoSwitch(
    String title,
    String subtitle,
    bool value,
    IconData icon,
    Function(bool) onChanged,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: value ? ThemeColors.of(context).primaryPastel : ThemeColors.of(context).textSecondary,
        borderRadius: BorderRadius.circular(
          isMobile ? 10 : 12,
        ),
        border: Border.all(
          color: value ? ThemeColors.of(context).blueCyanLight : ThemeColors.of(context).textSecondaryOverlay30,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            color: value ? ThemeColors.of(context).blueCyan : ThemeColors.of(context).textSecondary,
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
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                    color: value ? ThemeColors.of(context).blueCyanDark : ThemeColors.of(context).textSecondary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: ThemeColors.of(context).blueCyan,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificacoesCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).blueLight],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.notifications_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Notifica??es',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          CheckboxListTile(
            value: _notificarErro,
            onChanged: (value) => setState(() => _notificarErro = value! ),
            title: Text(
              'Notificar erros por email',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Receba alertas quando houver falhas',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 11,
                  mobileFontSize: 10,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            dense: true,
            activeColor: ThemeColors.of(context).error,
            secondary: Icon(
              Icons.error_rounded,
              color: ThemeColors.of(context).error,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            height: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
          ),
          CheckboxListTile(
            value: _notificarSucesso,
            onChanged: (value) => setState(() => _notificarSucesso = value!),
            title: Text(
              'Notificar sincroniza??es bem-sucedidas',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Receba confirma??o de sucesso',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 11,
                  mobileFontSize: 10,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            dense: true,
            activeColor: ThemeColors.of(context).success,
            secondary: Icon(
              Icons.check_circle_rounded,
              color: ThemeColors.of(context).success,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConexaoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).cyanMainLight],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
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
                Icons.cable_rounded,
                size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                color: ThemeColors.of(context).infoDark,
              ),
              SizedBox(
                width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
              ),
              Text(
                'Testar Conex?o',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
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
          Text(
            'Verifique se a conex?o com o ERP est? funcionando corretamente antes de salvar.',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                mobileFontSize: 11,
              ),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _testando ? null : _testarConexao,
              icon: _testando
                  ? SizedBox(
                      width: AppSizes.iconTiny.get(isMobile, isTablet),
                      height: AppSizes.iconTiny.get(isMobile, isTablet),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
                      ),
                    )
                  : Icon(
                      Icons.wifi_rounded,
                      size: AppSizes.iconSmall.get(isMobile, isTablet),
                    ),
              label: Text(
                _testando ? 'Testando...' : 'Testar Conex?o',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                overflow: TextOverflow.ellipsis,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.paddingSm.get(isMobile, isTablet),
                ),
                backgroundColor: ThemeColors.of(context).primary,
                foregroundColor: ThemeColors.of(context).surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return isMobile
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
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
                      ),
                    overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                    ),
                    side: BorderSide(color: ThemeColors.of(context).textSecondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvarConfiguracoes,
                  icon: Icon(
                    Icons.check_rounded,
                    size: AppSizes.iconSmall.get(isMobile, isTablet),
                  ),
                  label: Text(
                    'Salvar Configura??es',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                      ),
                    overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                    ),
                    backgroundColor: ThemeColors.of(context).success,
                    foregroundColor: ThemeColors.of(context).surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    size: ResponsiveHelper.getResponsiveIconSize(
                      context,
                      tablet: 17,
                      desktop: 18,
                    ),
                  ),
                  label: Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                      ),
                    overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveHelper.getResponsivePadding(
                        context,
                        tablet: 15,
                        desktop: 16,
                      ),
                    ),
                    side: BorderSide(color: ThemeColors.of(context).textSecondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _salvarConfiguracoes,
                  icon: Icon(
                    Icons.check_rounded,
                    size: ResponsiveHelper.getResponsiveIconSize(
                      context,
                      tablet: 17,
                      desktop: 18,
                    ),
                  ),
                  label: Text(
                    'Salvar Configura??es',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                      ),
                    overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveHelper.getResponsivePadding(
                        context,
                        tablet: 15,
                        desktop: 16,
                      ),
                    ),
                    backgroundColor: ThemeColors.of(context).success,
                    foregroundColor: ThemeColors.of(context).surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  void _testarConexao() async {
    final isMobile = ResponsiveHelper.isMobile(context);

    setState(() {
      _testando = true;
    });

    // Obter storeId do work context
    final workContext = ref.read(workContextProvider);
    final storeId = workContext.context.currentStoreId ?? '';
    
    // Testar conex?o real com a API
    SyncConnectionTestResult? result;
    if (storeId.isNotEmpty) {
      result = await ref.read(syncProvider.notifier).testConnection(storeId);
    }

    setState(() {
      _testando = false;
    });

    if (mounted) {
      final success = result?.success ?? false;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
          ),
          icon: Icon(
            success ? Icons.check_circle_rounded : Icons.error_rounded,
            color: success ? ThemeColors.of(context).success : ThemeColors.of(context).errorIcon,
            size: ResponsiveHelper.getResponsiveIconSize(
              context,
              mobile: 40,
              tablet: 44,
              desktop: 48,
            ),
          ),
          title: Text(
            success ? 'Conex?o Estabelecida!' : 'Falha na Conex?o',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 18,
                mobileFontSize: 16,
              ),
            overflow: TextOverflow.ellipsis,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                result?.message ?? (success ? 'A conex?o est? funcionando corretamente.' : 'N?o foi poss?vel estabelecer conex?o.'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                '${success ? "?" : "?"} Ping: ${result?.pingMs ?? 0}ms\n${result?.authStatus == "OK" ? "?" : "?"} Autentica??o: ${result?.authStatus ?? "N/A"}\n${result?.permissionsStatus == "OK" ? "?" : "?"} Permiss?es: ${result?.permissionsStatus ?? "N/A"}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 12,
                    mobileFontSize: 11,
                  ),
                overflow: TextOverflow.ellipsis,
                  color: success ? ThemeColors.of(context).success : ThemeColors.of(context).errorIcon,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: success ? ThemeColors.of(context).success : ThemeColors.of(context).errorIcon,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
              ),
              child: Text(
                'Fechar',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
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

  void _salvarConfiguracoes() {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    // Atualiza configura??es no provider
    final newSettings = SyncSettings(
      autoSync: _modo == 'Ativo',
      autoSyncIntervalMinutes: int.tryParse(_intervaloController.text) ?? 15,
      syncOnStartup: _sincProdutosNovos,
      notifyOnComplete: _notificarSucesso,
      notifyOnError: _notificarErro,
      defaultSyncType: SyncType.full,
    );
    
    ref.read(syncProvider.notifier).updateSettings(newSettings);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            Text(
              'Configura??es salvas com sucesso!',
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
        backgroundColor: ThemeColors.of(context).success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        ),
      ),
    );
  }
}









