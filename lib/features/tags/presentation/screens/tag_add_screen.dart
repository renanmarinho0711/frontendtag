import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/features/tags/presentation/providers/tags_provider.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';

class EtiquetasAdicionarScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  
  const EtiquetasAdicionarScreen({super.key, this.onBack});

  @override
  ConsumerState<EtiquetasAdicionarScreen> createState() => _EtiquetasAdicionarScreenState();
}

class _EtiquetasAdicionarScreenState extends ConsumerState<EtiquetasAdicionarScreen> with SingleTickerProviderStateMixin, ResponsiveCache {
  int _tipoAdicao = 0; // 0: Manual, 1: Importar Excel
  late AnimationController _animationController;
  
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _localizacaoController = TextEditingController();
  final _observacoesController = TextEditingController();
  
  bool _alteracoesFeitas = false;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
    
    _idController.addListener(() => setState(() => _alteracoesFeitas = true));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _idController.dispose();
    _localizacaoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).backgroundLight,
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
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
                      _buildTypeSelector(),
                      SizedBox(
                        height: AppSizes.cardPadding.get(isMobile, isTablet),
                      ),
                      if (_tipoAdicao == 0) _buildManualForm() else _buildImportForm(),
                    ],
                  ),
                ),
              ],
            ),
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
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
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
                colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark],
              ),
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
            child: Icon(
              Icons.add_box_rounded,
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
                  'Adicionar Tags',
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
                  'Registrar novas ESLs',
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

  Widget _buildTypeSelector() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXxs.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: _buildTypeOption(
              'Manual',
              'Adicionar uma tag',
              Icons.edit_rounded,
              0,
            ),
          ),
          Expanded(
            child: _buildTypeOption(
              'Importar Excel',
              'Mãltiplas tags',
              Icons.upload_file_rounded,
              1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(String title, String subtitle, IconData icon, int value) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isSelected = _tipoAdicao == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _tipoAdicao = value;
        });
      },
      borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark],
                )
              : null,
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
              size: AppSizes.iconLarge.get(isMobile, isTablet),
            ),
            SizedBox(
              height: AppSizes.paddingXs.get(isMobile, isTablet),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: isSelected ?  ThemeColors.of(context).surface : ThemeColors.of(context).textSecondaryOverlay80,
              ),
            ),
            SizedBox(
              height: AppSizes.paddingMicro2.get(isMobile, isTablet),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 10,
                  mobileFontSize: 9,
                  tabletFontSize: 9,
                ),
              overflow: TextOverflow.ellipsis,
                color: isSelected ? ThemeColors.of(context).surfaceOverlay90 : ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualForm() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
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
      child: Form(
        key: _formKey,
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
                      colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                  ),
                  child: Icon(
                    Icons.label_rounded,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconSmall.get(isMobile, isTablet),
                  ),
                ),
                SizedBox(
                  width: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                Text(
                  'Informações da Tag',
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
              height: AppSizes.cardPadding.get(isMobile, isTablet),
            ),
            TextFormField(
              controller: _idController,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
              decoration: InputDecoration(
                labelText: 'ID da Tag *',
                labelStyle: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 12,
                    mobileFontSize: 11,
                    tabletFontSize: 11,
                  ),
                ),
                hintText: 'Ex: TAG-001',
                prefixIcon: Icon(
                  Icons.label_rounded,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                  vertical: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                isDense: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9\-]')),
              ],
            ),
            SizedBox(
              height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
            ),
            TextFormField(
              controller: _localizacaoController,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
              decoration: InputDecoration(
                labelText: 'LocalizAção Fãsica (opcional)',
                labelStyle: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 12,
                    mobileFontSize: 11,
                    tabletFontSize: 11,
                  ),
                ),
                hintText: 'Ex: Corredor 3, Prateleira 2',
                prefixIcon: Icon(
                  Icons.location_on_rounded,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                  vertical: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                isDense: true,
              ),
            ),
            SizedBox(
              height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
            ),
            TextFormField(
              controller: _observacoesController,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Observações (opcional)',
                labelStyle: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 12,
                    mobileFontSize: 11,
                    tabletFontSize: 11,
                  ),
                ),
                hintText: 'Informações adicionais',
                prefixIcon: Icon(
                  Icons.note_rounded,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                  vertical: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                isDense: true,
              ),
            ),
            SizedBox(
              height: AppSizes.paddingXl.get(isMobile, isTablet),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildImportForm() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

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
                        colors: [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                    ),
                    child: Icon(
                      Icons.upload_file_rounded,
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconSmall.get(isMobile, isTablet),
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  Text(
                    'Importar via Excel',
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
                height: AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingMdAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).bluePastel,
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
                          size: AppSizes.iconSmall.get(isMobile, isTablet),
                          color: ThemeColors.of(context).infoDark,
                        ),
                        SizedBox(
                          width: AppSizes.paddingXs.get(isMobile, isTablet),
                        ),
                        Text(
                          'Como importar',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 13,
                              mobileFontSize: 12,
                              tabletFontSize: 12,
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
                    _buildStep('1', 'Faça o download do template Excel'),
                    SizedBox(
                      height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                    ),
                    _buildStep('2', 'Preencha com os dados das tags'),
                    SizedBox(
                      height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                    ),
                    _buildStep('3', 'Faça o upload do arquivo preenchido'),
                  ],
                ),
              ),
              SizedBox(
                height: AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.download_rounded,
                              color: ThemeColors.of(context).surface,
                              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                            ),
                            SizedBox(
                              width: AppSizes.paddingBase.get(isMobile, isTablet),
                            ),
                            Text(
                              'Baixando template...',
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
                          ],
                        ),
                        backgroundColor: ThemeColors.of(context).greenMain,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.download_rounded,
                    size: AppSizes.iconSmall.get(isMobile, isTablet),
                  ),
                  label: Text(
                    'Baixar Template Excel',
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
                    backgroundColor: ThemeColors.of(context).greenMain,
                    foregroundColor: ThemeColors.of(context).surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: AppSizes.cardPadding.get(isMobile, isTablet),
        ),
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
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _uploading = true;
                  });
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      _uploading = false;
                    });
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
                              width: AppSizes.paddingBase.get(isMobile, isTablet),
                            ),
                            Text(
                              '47 tags importadas com sucesso! ',
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
                          ],
                        ),
                        backgroundColor: ThemeColors.of(context).greenMain,
                        behavior: SnackBarBehavior. floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                        ),
                      ),
                    );
                  });
                },
                borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
                child: Container(
                  padding: EdgeInsets.all(
                    ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 40,
                      tablet: 44,
                      desktop: 48,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ThemeColors.of(context).blueCyan,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
                    color: ThemeColors.of(context).blueCyanOverlay05,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_uploading) ...[
                        SizedBox(
                          width: ResponsiveHelper.getResponsiveWidth(
                            context,
                            mobile: 40,
                            tablet: 44,
                            desktop: 48,
                          ),
                          height: ResponsiveHelper.getResponsiveHeight(
                            context,
                            mobile: 40,
                            tablet: 44,
                            desktop: 48,
                          ),
                          child: const CircularProgressIndicator(),
                        ),
                        SizedBox(
                          height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                        ),
                        Text(
                          'Processando arquivo...',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 14,
                              mobileFontSize: 13,
                              tabletFontSize: 13,
                            ),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ] else ...[
                        Icon(
                          Icons.cloud_upload_rounded,
                          size: AppSizes.iconHeroXl.get(isMobile, isTablet),
                          color: ThemeColors.of(context).blueCyan,
                        ),
                        SizedBox(
                          height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                        ),
                        Text(
                          'Arraste o arquivo Excel aqui',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 16,
                              mobileFontSize: 15,
                              tabletFontSize: 15,
                            ),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.paddingXs.get(isMobile, isTablet),
                        ),
                        Text(
                          'ou clique para selecionar',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 13,
                              mobileFontSize: 12,
                              tabletFontSize: 12,
                            ),
                          overflow: TextOverflow.ellipsis,
                            color: ThemeColors.of(context).textSecondaryOverlay70,
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingLgAlt.get(isMobile, isTablet),
                            vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark],
                            ),
                            borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                          ),
                          child: Text(
                            'Selecionar Arquivo',
                            style: TextStyle(
                              color: ThemeColors.of(context).surface,
                              fontWeight: FontWeight.w600,
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 14,
                                mobileFontSize: 13,
                                tabletFontSize: 13,
                              ),
                            overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep(String number, String text) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: ResponsiveHelper.getResponsiveWidth(
            context,
            mobile: 22,
            tablet: 23,
            desktop: 24,
          ),
          height: ResponsiveHelper.getResponsiveHeight(
            context,
            mobile: 22,
            tablet: 23,
            desktop: 24,
          ),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).infoDark,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 12,
                  mobileFontSize: 11,
                  tabletFontSize: 11,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).surface,
              ),
            ),
          ),
        ),
        SizedBox(
          width: AppSizes.paddingXs.get(isMobile, isTablet),
        ),
        Expanded(
          child: Text(
            text,
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
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                onPressed: _salvarTag,
                icon: Icon(
                  Icons.check_rounded,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                ),
                label: Text(
                  'Salvar Tag',
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
                  backgroundColor: ThemeColors.of(context).blueCyan,
                  foregroundColor: ThemeColors.of(context).surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppSizes.paddingSmAlt.get(isMobile, isTablet),
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              if (_formKey.currentState! .validate()) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code_scanner_rounded,
                          color: ThemeColors.of(context).surface,
                          size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                        ),
                        SizedBox(
                          width: AppSizes.paddingBase.get(isMobile, isTablet),
                        ),
                        Text(
                          'Tag salva!  Associe a um produto agora.',
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
                      ],
                    ),
                    backgroundColor: ThemeColors.of(context).orangeMain,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                    ),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.link_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            label: Text(
              'Salvar e Associar Produto',
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
              foregroundColor: ThemeColors.of(context).orangeMain,
              side: BorderSide(color: ThemeColors.of(context).orangeMain),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _salvarTag() async {
    final isMobile = ResponsiveHelper.isMobile(context);

    if (_formKey.currentState!.validate()) {
      setState(() => _uploading = true);
      
      // Obter storeId do contexto de trabalho
      final currentStore = ref.read(currentStoreProvider);
      final storeId = currentStore?.id ?? 'store-not-configured';
      
      // Chamar o backend para criar a tag
      final success = await ref.read(tagsNotifierProvider.notifier).createTag(
        macAddress: _idController.text.trim(),
        storeId: storeId,
        type: 0, // Tipo padrão
      );
      
      if (!mounted) return;
      
      setState(() => _uploading = false);
      
      if (success) {
        Navigator.pop(context);
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
                    color: ThemeColors.of(context).surfacePastel,
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
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
                        'Tag Adicionada!',
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
                        'Tag ${_idController.text} registrada com sucesso',
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
            backgroundColor: ThemeColors.of(context).greenMain,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
            ),
            padding: EdgeInsets.all(
              AppSizes.paddingMdAlt.get(isMobile, isTablet),
            ),
          ),
        );
      } else {
        final error = ref.read(tagsNotifierProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                const SizedBox(width: 12),
                Expanded(child: Text(error ?? 'Erro ao adicionar tag')),
              ],
            ),
            backgroundColor: ThemeColors.of(context).error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}








