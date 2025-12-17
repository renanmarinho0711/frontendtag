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
    final colors = ThemeColors.of(context);

    return Scaffold(
      backgroundColor: colors.surface,
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
    final colors = ThemeColors.of(context);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
        vertical: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimaryOverlay05,
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
              color: colors.textSecondary,
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: colors.textSecondary,
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
                colors: [colors.primary, colors.blueMain],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.settings_rounded,
              color: colors.surface,
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
                  'Configurações',
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
                  'Parâmetros de sincronização',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: colors.textSecondary,
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
    final colors = ThemeColors.of(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimaryOverlay05,
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
                    colors: [colors.primary, colors.blueDark],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.schedule_rounded,
                  color: colors.surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Intervalo de SincronizAÃ§ão',
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
              helperText: 'Tempo entre sincronizações automáticas',
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
              color: colors.infoPastel,
              borderRadius: BorderRadius.circular(
                isMobile ? 8 : 10,
              ),
              border: Border.all(color: colors.infoLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_rounded,
                  size: AppSizes.iconTiny.get(isMobile, isTablet),
                  color: colors.infoDark,
                ),
                SizedBox(
                  width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                ),
                Expanded(
                  child: Text(
                    'Intervalo mínimo recomendado: 5 minutos',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                      ),
                    overflow: TextOverflow.ellipsis,
                      color: colors.infoDark,
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
    final colors = ThemeColors.of(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimaryOverlay05,
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
                    colors: [colors.greenGradient, colors.greenGradientEnd],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.mode_rounded,
                  color: colors.surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Modo de OperAÃ§ão',
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
              color: _modo == 'Passivo' ? colors.warningPastel : colors.successPastel,
              borderRadius: BorderRadius.circular(
                isMobile ? 8 : 10,
              ),
              border: Border.all(
                color: _modo == 'Passivo' ? colors.warningLight : colors.successLight,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_rounded,
                  size: AppSizes.iconTiny.get(isMobile, isTablet),
                  color: _modo == 'Passivo' ? colors.warningDark : colors.successIcon,
                ),
                SizedBox(
                  width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                ),
                Expanded(
                  child: Text(
                    _modo == 'Passivo'
                        ? 'Modo Passivo: Apenas lÃ¡ dados do ERP'
                        : 'Modo Ativo: Envia e recebe dados do ERP',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                      ),
                    overflow: TextOverflow.ellipsis,
                      color: _modo == 'Passivo' ? colors.warningDark : colors.successText,
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
    final colors = ThemeColors.of(context);
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
          color: isSelected ? colors.primaryPastel : colors.textSecondary,
          borderRadius: BorderRadius.circular(
            isMobile ? 10 : 12,
          ),
          border: Border.all(
            color: isSelected ? colors.blueCyan : colors.textSecondaryOverlay40,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? colors.blueCyan : colors.textSecondary,
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
                color: isSelected ? colors.blueCyan : colors.textSecondary,
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
    final colors = ThemeColors.of(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimaryOverlay05,
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
                    colors: [colors.primaryPastel, colors.yellowGold],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ?  10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.data_usage_rounded,
                  color: colors.surface,
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
            'PREÃOs',
            'Sincronizar preços dos produtos',
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
    final colors = ThemeColors.of(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: value ? colors.primaryPastel : colors.textSecondary,
        borderRadius: BorderRadius.circular(
          isMobile ? 10 : 12,
        ),
        border: Border.all(
          color: value ? colors.blueCyan.withValues(alpha: 0.3) : colors.textSecondaryOverlay30,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            color: value ? colors.blueCyan : colors.textSecondary,
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
                    color: value ? colors.blueCyan.withValues(alpha: 0.8) : colors.textSecondary,
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
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: colors.blueCyan,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificacoesCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final colors = ThemeColors.of(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimaryOverlay05,
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
                    colors: [colors.blueCyan, colors.blueLight],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.notifications_rounded,
                  color: colors.surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Notificações',
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
            activeColor: colors.error,
            secondary: Icon(
              Icons.error_rounded,
              color: colors.error,
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
              'Notificar sincronizações bem-sucedidas',
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
              'Receba confirmAÃ§ão de sucesso',
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
            activeColor: colors.success,
            secondary: Icon(
              Icons.check_circle_rounded,
              color: colors.success,
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
    final colors = ThemeColors.of(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.infoPastel, colors.cyanMain.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        border: Border.all(color: colors.infoLight),
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
                color: colors.infoDark,
              ),
              SizedBox(
                width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
              ),
              Text(
                'Testar Conexão',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: colors.infoDark,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Text(
            'Verifique se a conexão com o ERP estã funcionando corretamente antes de salvar.',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                mobileFontSize: 11,
              ),
            overflow: TextOverflow.ellipsis,
              color: colors.textSecondary,
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
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(colors.surface),
                      ),
                    )
                  : Icon(
                      Icons.wifi_rounded,
                      size: AppSizes.iconSmall.get(isMobile, isTablet),
                    ),
              label: Text(
                _testando ? 'Testando...' : 'Testar Conexão',
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
                backgroundColor: colors.primary,
                foregroundColor: colors.surface,
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
    final colors = ThemeColors.of(context);

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
                    side: BorderSide(color: colors.textSecondary),
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
                    'Salvar Configurações',
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
                    backgroundColor: colors.success,
                    foregroundColor: colors.surface,
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
                    side: BorderSide(color: colors.textSecondary),
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
                    'Salvar Configurações',
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
                    backgroundColor: colors.success,
                    foregroundColor: colors.surface,
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
    final colors = ThemeColors.of(context);

    setState(() {
      _testando = true;
    });

    // Obter storeId do work context
    final workContext = ref.read(workContextProvider);
    final storeId = workContext.context.currentStoreId ?? '';
    
    // Testar conexão real com a API
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
            color: success ? colors.success : colors.errorIcon,
            size: ResponsiveHelper.getResponsiveIconSize(
              context,
              mobile: 40,
              tablet: 44,
              desktop: 48,
            ),
          ),
          title: Text(
            success ? 'Conexão Estabelecida!' : 'Falha na Conexão',
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
                result?.message ?? (success ? 'A conexão estã funcionando corretamente.' : 'NÃÂ£o foi possível estabelecer conexão.'),
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
                '${success ? "?" : "?"} Ping: ${result?.pingMs ?? 0}ms\n${result?.authStatus == "OK" ? "?" : "?"} Autenticação: ${result?.authStatus ?? "N/A"}\n${result?.permissionsStatus == "OK" ? "?" : "?"} Permissões: ${result?.permissionsStatus ?? "N/A"}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 12,
                    mobileFontSize: 11,
                  ),
                overflow: TextOverflow.ellipsis,
                  color: success ? colors.success : colors.errorIcon,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: success ? colors.success : colors.errorIcon,
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
    final colors = ThemeColors.of(context);
    
    // Atualiza configurações no provider
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
              color: colors.surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            Text(
              'Configurações salvas com sucesso!',
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
        backgroundColor: colors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        ),
      ),
    );
  }
}






