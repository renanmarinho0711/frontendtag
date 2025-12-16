import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/settings/presentation/providers/settings_provider.dart';
import 'package:tagbean/features/settings/data/models/settings_models.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Tela de configuraes de integrao ERP
/// Permite configurar conexo com sistemas ERP externos
class ConfiguracoesERPScreen extends ConsumerStatefulWidget {
  const ConfiguracoesERPScreen({super.key});

  @override
  ConsumerState<ConfiguracoesERPScreen> createState() => _ConfiguracoesERPScreenState();
}

class _ConfiguracoesERPScreenState extends ConsumerState<ConfiguracoesERPScreen> with ResponsiveCache {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para os campos
  final _apiUrlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();
  
  // Estado local para UI
  bool _showApiKey = false;
  bool _showSenha = false;
  bool _isInitialized = false;
  
  // Getters do state
  ERPSettingsState get _state => ref.watch(erpSettingsProvider);
  ERPSettingsNotifier get _notifier => ref.read(erpSettingsProvider.notifier);
  ERPSettingsModel get _settings => _state.settings;
  
  // Opes de ERP disponveis
  final List<Map<String, dynamic>> _erpOptions = [
    {'type': ERPIntegrationType.none, 'name': 'Nenhum', 'icon': Icons.block, 'color': ThemeColors.of(context).grey500},
    {'type': ERPIntegrationType.sap, 'name': 'SAP Business One', 'icon': Icons.business, 'color': ThemeColors.of(context).erpSAP},
    {'type': ERPIntegrationType.totvs, 'name': 'TOTVS Protheus', 'icon': Icons.precision_manufacturing, 'color': ThemeColors.of(context).erpTOTVS},
    {'type': ERPIntegrationType.sage, 'name': 'Sage', 'icon': Icons.corporate_fare, 'color': ThemeColors.of(context).erpOracle},
    {'type': ERPIntegrationType.oracle, 'name': 'Oracle NetSuite', 'icon': Icons.cloud, 'color': ThemeColors.of(context).erpSenior},
    {'type': ERPIntegrationType.bling, 'name': 'Bling', 'icon': Icons.shopping_bag, 'color': ThemeColors.of(context).erpSankhya},
    {'type': ERPIntegrationType.tiny, 'name': 'Tiny ERP', 'icon': Icons.inventory_2, 'color': ThemeColors.of(context).erpOmie},
    {'type': ERPIntegrationType.custom, 'name': 'API Customizada', 'icon': Icons.code, 'color': ThemeColors.of(context).erpBling},
  ];
  
  final List<Map<String, dynamic>> _syncIntervalOptions = [
    {'value': 5, 'label': '5 minutos'},
    {'value': 15, 'label': '15 minutos'},
    {'value': 30, 'label': '30 minutos'},
    {'value': 60, 'label': '1 hora'},
    {'value': 120, 'label': '2 horas'},
    {'value': 360, 'label': '6 horas'},
    {'value': 720, 'label': '12 horas'},
    {'value': 1440, 'label': '24 horas'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  @override
  void dispose() {
    _apiUrlController.dispose();
    _apiKeyController.dispose();
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    await _notifier.loadSettings();
  }
  
  void _syncControllersWithState() {
    if (!_isInitialized && _state.status == SettingsLoadingStatus.loaded) {
      _apiUrlController.text = _settings.url ?? '';
      _apiKeyController.text = _settings.apiKey ?? '';
      _usuarioController.text = _settings.usuario ?? '';
      _senhaController.text = _settings.senha ?? '';
      _isInitialized = true;
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Atualizar o state com valores dos controllers
    _notifier.updateUrl(_apiUrlController.text.trim());
    _notifier.updateApiKey(_apiKeyController.text.trim());
    _notifier.updateCredentials(
      _usuarioController.text.trim(),
      _senhaController.text.trim(),
    );
    
    final success = await _notifier.saveSettings();
    
    if (success) {
      _showSuccessSnackBar('Configuraes salvas com sucesso!');
    } else {
      _showErrorSnackBar(_state.errorMessage ?? 'Erro ao salvar');
    }
  }

  Future<void> _testConnection() async {
    if (_apiUrlController.text.isEmpty) {
      _showErrorSnackBar('Informe a URL da API');
      return;
    }
    
    // Atualizar o state com valores atuais antes de testar
    _notifier.updateUrl(_apiUrlController.text.trim());
    _notifier.updateApiKey(_apiKeyController.text.trim());
    
    final success = await _notifier.testConnection();
    
    if (success) {
      _showSuccessSnackBar('Conexo testada com sucesso!');
    } else {
      _showErrorSnackBar(_settings.lastError ?? 'Falha na conexo');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeColors.of(context).success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeColors.of(context).error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sincronizar controllers quando state atualizar
    _syncControllersWithState();
    
    final isLoading = _state.status == SettingsLoadingStatus.loading || 
                      _state.status == SettingsLoadingStatus.saving;
    final isConnected = _settings.connectionStatus == ERPConnectionStatus.connected;
    final isTesting = _state.isTesting;
    
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).backgroundLight,
      ),
      child: isLoading && !_isInitialized
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                          _buildConnectionStatusCard(isConnected),
                          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
                          _buildERPSelectionCard(),
                          if (_settings.tipo != ERPIntegrationType.none) ...[
                            SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
                            _buildCredentialsCard(isTesting),
                            SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
                            _buildSyncOptionsCard(),
                          ],
                          SizedBox(height: AppSizes.paddingXl.get(isMobile, isTablet)),
                          _buildActionButtons(isLoading),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildModernAppBar() {
    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
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
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
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
              Icons.integration_instructions_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Integrao ERP',
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
                  'Configure a conexo com seu sistema ERP',
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
        ],
      ),
    );
  }

  Widget _buildConnectionStatusCard(bool isConnected) {
    final selectedErp = _erpOptions.firstWhere(
      (e) => e['type'] == _settings.tipo,
      orElse: () => _erpOptions.first,
    );
    final isNone = _settings.tipo == ERPIntegrationType.none;
    
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: isConnected 
            ? ThemeColors.of(context).success.withValues(alpha: 0.1)
            : isNone 
                ? ThemeColors.of(context).backgroundLight
                : ThemeColors.of(context).warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
        border: Border.all(
          color: isConnected 
              ? ThemeColors.of(context).success
              : isNone 
                  ? ThemeColors.of(context).textSecondary
                  : ThemeColors.of(context).warning,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: (selectedErp['color'] as Color).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isConnected 
                  ? Icons.cloud_done
                  : isNone
                      ? Icons.cloud_off
                      : Icons.cloud_queue,
              color: selectedErp['color'] as Color,
              size: AppSizes.iconLg,
            ),
          ),
          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isConnected 
                      ? 'Conectado: ${selectedErp['name']}'
                      : isNone
                          ? 'Nenhum ERP configurado'
                          : 'Aguardando conexo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 16,
                      mobileFontSize: 14,
                      tabletFontSize: 15,
                    ),
                    fontWeight: FontWeight.bold,
                    color: isConnected 
                        ? ThemeColors.of(context).success
                        : isNone
                            ? ThemeColors.of(context).textSecondary
                            : ThemeColors.of(context).warning,
                  ),
                ),
                if (_settings.lastSync != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'ltima sinc: ${_formatDateTime(_settings.lastSync!)}',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 12,
                        mobileFontSize: 11,
                        tabletFontSize: 11.5,
                      ),
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
                ],
                if (_settings.lastError != null && !isConnected) ...[
                  const SizedBox(height: 4),
                  Text(
                    _settings.lastError!,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 12,
                        mobileFontSize: 11,
                        tabletFontSize: 11.5,
                      ),
                      color: ThemeColors.of(context).error,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildERPSelectionCard() {
    return _buildCard(
      title: 'Sistema ERP',
      icon: Icons.integration_instructions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecione o sistema ERP que deseja integrar:',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
                tabletFontSize: 13.5,
              ),
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
          Wrap(
            spacing: AppSizes.paddingSm.get(isMobile, isTablet),
            runSpacing: AppSizes.paddingSm.get(isMobile, isTablet),
            children: _erpOptions.map((erp) => _buildERPOption(erp)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildERPOption(Map<String, dynamic> erp) {
    final erpType = erp['type'] as ERPIntegrationType;
    final isSelected = _settings.tipo == erpType;
    final color = erp['color'] as Color;
    
    return InkWell(
      onTap: () => _notifier.updateTipo(erpType),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
          vertical: AppSizes.paddingSm.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : ThemeColors.of(context).transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : ThemeColors.of(context).textSecondaryOverlay30,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              erp['icon'] as IconData,
              color: isSelected ? color : ThemeColors.of(context).textSecondary,
              size: AppSizes.iconSm,
            ),
            SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
            Text(
              erp['name'] as String,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 12,
                  tabletFontSize: 13,
                ),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : ThemeColors.of(context).textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialsCard(bool isTesting) {
    return _buildCard(
      title: 'Credenciais de Acesso',
      icon: Icons.vpn_key,
      child: Column(
        children: [
          _buildTextField(
            controller: _apiUrlController,
            label: 'URL da API',
            hint: 'https://api.seu-erp.com/v1',
            icon: Icons.link,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe a URL da API';
              }
              if (!value.startsWith('http://') && !value.startsWith('https://')) {
                return 'URL deve comear com http:// ou https://';
              }
              return null;
            },
          ),
          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
          _buildTextField(
            controller: _apiKeyController,
            label: 'Chave de API / Token',
            hint: 'Sua chave de API ou token de acesso',
            icon: Icons.key,
            obscureText: !_showApiKey,
            suffixIcon: IconButton(
              onPressed: () => setState(() => _showApiKey = !_showApiKey),
              icon: Icon(_showApiKey ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
          _buildTextField(
            controller: _usuarioController,
            label: 'Usurio (opcional)',
            hint: 'Usurio de acesso',
            icon: Icons.person,
          ),
          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
          _buildTextField(
            controller: _senhaController,
            label: 'Senha (opcional)',
            hint: 'Senha de acesso',
            icon: Icons.lock,
            obscureText: !_showSenha,
            suffixIcon: IconButton(
              onPressed: () => setState(() => _showSenha = !_showSenha),
              icon: Icon(_showSenha ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isTesting ? null : _testConnection,
              icon: isTesting 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: ThemeColors.of(context).surface),
                    )
                  : const Icon(Icons.wifi_tethering),
              label: Text(isTesting ? 'Testando...' : 'Testar Conexo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.of(context).success,
                foregroundColor: ThemeColors.of(context).surface,
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.paddingMd.get(isMobile, isTablet),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncOptionsCard() {
    return _buildCard(
      title: 'Opes de Sincronizao',
      icon: Icons.sync,
      child: Column(
        children: [
          _buildSwitchTile(
            title: 'Sincronizao Automtica',
            subtitle: 'Sincronizar periodicamente com o ERP',
            value: _settings.autoSync,
            onChanged: (value) => _notifier.toggleAutoSync(),
            icon: Icons.autorenew,
          ),
          if (_settings.autoSync) ...[
            SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
            Row(
              children: [
                Icon(
                  Icons.timer,
                  color: ThemeColors.of(context).textSecondary,
                  size: AppSizes.iconSm,
                ),
                SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
                Text(
                  'Intervalo:',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 13,
                      tabletFontSize: 13.5,
                    ),
                  ),
                ),
                const Spacer(),
                DropdownButton<int>(
                  value: _settings.syncIntervalMinutes,
                  underline: const SizedBox(),
                  items: _syncIntervalOptions.map((option) {
                    return DropdownMenuItem<int>(
                      value: option['value'] as int,
                      child: Text(option['label'] as String),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _notifier.updateSyncInterval(value);
                    }
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: ThemeColors.of(context).success,
                  size: AppSizes.iconMd,
                ),
              ),
              SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
              Text(
                title,
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
            ],
          ),
          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ThemeColors.of(context).textSecondaryOverlay30,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ThemeColors.of(context).success,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.paddingSm.get(isMobile, isTablet) / 2,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: value ? ThemeColors.of(context).success : ThemeColors.of(context).textSecondary,
            size: AppSizes.iconSm,
          ),
          SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 13,
                      tabletFontSize: 13.5,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11.5,
                    ),
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: ThemeColors.of(context).success,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isLoading) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _state.hasChanges ? () {
              _isInitialized = false;
              _loadSettings();
            } : null,
            icon: const Icon(Icons.refresh),
            label: const Text('Desfazer'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              side: BorderSide(
                color: _state.hasChanges 
                    ? ThemeColors.of(context).textSecondary 
                    : ThemeColors.of(context).textSecondaryOverlay30,
              ),
            ),
          ),
        ),
        SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _state.hasChanges && !isLoading ? _saveSettings : null,
            icon: isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: ThemeColors.of(context).surface),
                  )
                : const Icon(Icons.save),
            label: Text(isLoading ? 'Salvando...' : 'Salvar Configuraes'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).success,
              foregroundColor: ThemeColors.of(context).surface,
              disabledBackgroundColor: ThemeColors.of(context).success.withValues(alpha: 0.5),
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.paddingMd.get(isMobile, isTablet),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    
    if (diff.inMinutes < 1) {
      return 'Agora mesmo';
    } else if (diff.inMinutes < 60) {
      return 'H ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'H ${diff.inHours}h';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}








