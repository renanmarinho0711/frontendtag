import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

class ConfiguracoesLojaScreen extends ConsumerStatefulWidget {
  const ConfiguracoesLojaScreen({super.key});

  @override
  ConsumerState<ConfiguracoesLojaScreen> createState() => _ConfiguracoesLojaScreenState();
}

class _ConfiguracoesLojaScreenState extends ConsumerState<ConfiguracoesLojaScreen> with ResponsiveCache {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController(text: 'TagBeans Store');
  final _cnpjController = TextEditingController(text: '12.345.678/0001-90');
  final _enderecoController = TextEditingController(text: 'Av. Paulista, 1000');
  final _cidadeController = TextEditingController(text: 'So Paulo');
  final _estadoController = TextEditingController(text: 'SP');
  final _cepController = TextEditingController(text: '01310-100');
  final _telefoneController = TextEditingController(text: '(11) 3000-0000');
  final _emailController = TextEditingController(text: 'contato@tagbeans.com');
  
  bool _alteracoesFeitas = false;

  @override
  void initState() {
    super.initState();
    _nomeController.addListener(() => setState(() => _alteracoesFeitas = true));
    _cnpjController.addListener(() => setState(() => _alteracoesFeitas = true));
    _enderecoController.addListener(() => setState(() => _alteracoesFeitas = true));
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cnpjController.dispose();
    _enderecoController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.of(context).surfaceSecondary,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModernAppBar(),
            Padding(
              padding: EdgeInsets.all(
                AppSizes.paddingXlAlt.get(isMobile, isTablet),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLogoCard(),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    _buildInfoCard(),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    _buildAddressCard(),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    _buildContactCard(),
                    SizedBox(
                      height: AppSizes.paddingXl.get(isMobile, isTablet),
                    ),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
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
        gradient: AppGradients.darkBackground(context),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.4),
            blurRadius: isMobile ? 15 : 20,
            offset: Offset(0, isMobile ? 6 : 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Boto de voltar
          Material(
            color: ThemeColors.of(context).transparent,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
              child: Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay15,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
              ),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay20,
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.store_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dados da Loja',
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
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Informaes do estabelecimento',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 10,
                      tabletFontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).surfaceOverlay70,
                  ),
                ),
              ],
            ),
          ),
          if (_alteracoesFeitas)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).yellowGoldLight,
                borderRadius: BorderRadius.circular(
                  isMobile ? 6 : 8,
                ),
                border: Border.all(color: ThemeColors.of(context).yellowGold.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_rounded,
                    size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                    color: ThemeColors.of(context).yellowGold,
                  ),
                  SizedBox(
                    width: AppSizes.paddingXxs.get(isMobile, isTablet),
                  ),
                  Text(
                    'Modificado',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 9,
                        tabletFontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.of(context).surface,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXl.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).greenGradientLight,
            blurRadius: isMobile ? 15 : 20,
            offset: Offset(0, isMobile ? 8 : 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: ResponsiveHelper.getResponsiveWidth(
              context,
              mobile: 80,
              tablet: 90,
              desktop: 100,
            ),
            height: ResponsiveHelper.getResponsiveHeight(
              context,
              mobile: 80,
              tablet: 90,
              desktop: 100,
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surface,
              borderRadius: BorderRadius.circular(
                isMobile ? 16 : (isTablet ? 18 : 20),
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).textPrimaryOverlay10,
                  blurRadius: isMobile ? 8 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.store_rounded,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 40,
                tablet: 45,
                desktop: 50,
              ),
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Funo de upload de logo ser implementada',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 12,
                        tabletFontSize: 13,
                      ),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      isMobile ? 10 : 12,
                    ),
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.upload_rounded,
              size: AppSizes.iconSmallMedium.get(isMobile, isTablet),
            ),
            label: Text(
              'Alterar Logo',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 12,
                  tabletFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).surface,
              foregroundColor: ThemeColors.of(context).brandPrimaryGreen,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXl.get(isMobile, isTablet),
                vertical: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
            ),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Text(
            'Tamanho recomendado: 512x512px',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 11,
                mobileFontSize: 9,
                tabletFontSize: 10,
              ),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).surfaceOverlay80,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
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
                  Icons.business_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Informaes Bsicas',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 18,
                    mobileFontSize: 15,
                    tabletFontSize: 16,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          TextFormField(
            controller: _nomeController,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
                tabletFontSize: 13,
              ),
            ),
            decoration: InputDecoration(
              labelText: 'Nome da Loja *',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 12,
                  tabletFontSize: 13,
                ),
              ),
              prefixIcon: Icon(
                Icons.storefront_rounded,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              filled: true,
              fillColor: ThemeColors.of(context).surfaceSecondary,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                vertical: AppSizes.paddingMdAlt2.get(isMobile, isTablet),
              ),
            ),
            validator: (value) {
              if (value == null || value. isEmpty) {
                return 'Campo obrigatrio';
              }
              return null;
            },
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          TextFormField(
            controller: _cnpjController,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
                tabletFontSize: 13,
              ),
            ),
            decoration: InputDecoration(
              labelText: 'CNPJ *',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 12,
                  tabletFontSize: 13,
                ),
              ),
              prefixIcon: Icon(
                Icons.badge_rounded,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              filled: true,
              fillColor: ThemeColors.of(context).surfaceSecondary,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                vertical: AppSizes.paddingMdAlt2.get(isMobile, isTablet),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(14),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatrio';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
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
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ?  10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Endereo',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 18,
                    mobileFontSize: 15,
                    tabletFontSize: 16,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          TextFormField(
            controller: _enderecoController,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
                tabletFontSize: 13,
              ),
            ),
            decoration: InputDecoration(
              labelText: 'Logradouro *',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 12,
                  tabletFontSize: 13,
                ),
              ),
              prefixIcon: Icon(
                Icons.map_rounded,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              filled: true,
              fillColor: ThemeColors.of(context).surfaceSecondary,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                vertical: AppSizes.paddingMdAlt2.get(isMobile, isTablet),
              ),
            ),
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _cidadeController,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 13,
                      tabletFontSize: 13,
                    ),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Cidade *',
                    labelStyle: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 12,
                        tabletFontSize: 13,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.location_city_rounded,
                      size: AppSizes.iconMedium.get(isMobile, isTablet),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                    filled: true,
                    fillColor: ThemeColors.of(context).surfaceSecondary,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                      vertical: AppSizes.paddingMdAlt2.get(isMobile, isTablet),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: TextFormField(
                  controller: _estadoController,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 13,
                      tabletFontSize: 13,
                    ),
                  ),
                  decoration: InputDecoration(
                    labelText: 'UF *',
                    labelStyle: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 12,
                        tabletFontSize: 13,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                    filled: true,
                    fillColor: ThemeColors.of(context).surfaceSecondary,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                      vertical: AppSizes.paddingMdAlt2.get(isMobile, isTablet),
                    ),
                  ),
                  textCapitalization: TextCapitalization. characters,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          TextFormField(
            controller: _cepController,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
                tabletFontSize: 13,
              ),
            ),
            decoration: InputDecoration(
              labelText: 'CEP *',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 12,
                  tabletFontSize: 13,
                ),
              ),
              prefixIcon: Icon(
                Icons.markunread_mailbox_rounded,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              filled: true,
              fillColor: ThemeColors.of(context).surfaceSecondary,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                vertical: AppSizes.paddingMdAlt2.get(isMobile, isTablet),
              ),
            ),
            keyboardType: TextInputType. number,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
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
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ?  10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.contact_phone_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Contato',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 18,
                    mobileFontSize: 15,
                    tabletFontSize: 16,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          TextFormField(
            controller: _telefoneController,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
                tabletFontSize: 13,
              ),
            ),
            decoration: InputDecoration(
              labelText: 'Telefone *',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 12,
                  tabletFontSize: 13,
                ),
              ),
              prefixIcon: Icon(
                Icons.phone_rounded,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              filled: true,
              fillColor: ThemeColors.of(context).surfaceSecondary,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                vertical: AppSizes.paddingMdAlt2.get(isMobile, isTablet),
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          TextFormField(
            controller: _emailController,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
                tabletFontSize: 13,
              ),
            ),
            decoration: InputDecoration(
              labelText: 'E-mail *',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 12,
                  tabletFontSize: 13,
                ),
              ),
              prefixIcon: Icon(
                Icons.email_rounded,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              filled: true,
              fillColor: ThemeColors.of(context).surfaceSecondary,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                vertical: AppSizes.paddingMdAlt2.get(isMobile, isTablet),
              ),
            ),
            keyboardType: TextInputType. emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatrio';
              }
              if (!value.contains('@')) {
                return 'E-mail invlido';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close_rounded,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
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
                vertical: AppSizes.paddingMdLg.get(isMobile, isTablet),
              ),
              side: BorderSide(color: ThemeColors.of(context).textSecondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 12 : (isTablet ? 14 : 16),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: AppSizes.paddingMd.get(isMobile, isTablet),
        ),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                            AppSizes.paddingXs.get(isMobile, isTablet),
                          ),
                          decoration: BoxDecoration(
                            color: ThemeColors.of(context).surfaceOverlay20,
                            borderRadius: BorderRadius.circular(
                              isMobile ? 6 : 8,
                            ),
                          ),
                          child: Icon(
                            Icons.check_circle_rounded,
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
                                'Sucesso!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 14,
                                    mobileFontSize: 13,
                                    tabletFontSize: 13,
                                  ),
                                overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'Dados salvos com sucesso',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 12,
                                    mobileFontSize: 11,
                                    tabletFontSize: 11,
                                  ),
                                overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: ThemeColors.of(context).success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isMobile ? 12 : (isTablet ? 14 : 16),
                      ),
                    ),
                    padding: EdgeInsets.all(
                      AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                  ),
                );
                setState(() {
                  _alteracoesFeitas = false;
                });
              }
            },
            icon: Icon(
              Icons.check_rounded,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            ),
            label: Text(
              'Salvar Alteraes',
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
                vertical: AppSizes.paddingMdLg.get(isMobile, isTablet),
              ),
              backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
              foregroundColor: ThemeColors.of(context).surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 12 : (isTablet ? 14 : 16),
                ),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}










