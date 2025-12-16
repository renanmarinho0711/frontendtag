import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/core/constants/app_constants.dart' as AppConst;
import 'package:tagbean/features/settings/presentation/providers/settings_provider.dart';
import 'package:tagbean/features/settings/data/models/settings_models.dart';

class ConfiguracoesNotificacoesScreen extends ConsumerStatefulWidget {
  const ConfiguracoesNotificacoesScreen({super.key});

  @override
  ConsumerState<ConfiguracoesNotificacoesScreen> createState() =>
      _ConfiguracoesNotificacoesScreenState();
}

class _ConfiguracoesNotificacoesScreenState
    extends ConsumerState<ConfiguracoesNotificacoesScreen> with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;

  // Canais de notificao
  bool _notificarEmail = true;
  bool _notificarSMS = false;
  bool _notificarPush = true;

  // Eventos para notificar
  final Map<String, bool> _eventosNotificacao = {
    'Erro de Sincronizao': true,
    'Tag Offline': true,
    'Produto sem Preo': true,
    'Margem Negativa': true,
    'Importao Concluda': false,
    'Estratgia Executada': true,
    'Backup Realizado': false,
    'Novo Login Detectado': true,
  };

  // Horrios
  bool _naoPerturbar = false;
  TimeOfDay _inicioNaoPerturbar = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _fimNaoPerturbar = const TimeOfDay(hour: 7, minute: 0);

  // Contatos
  final List<String> _emailsNotificacao = [
    'admin@tagbeans.com',
    'gerente@tagbeans.com',
  ];
  final List<String> _telefonesNotificacao = [
    '+55 (11) 99999-0001',
  ];

  bool _alteracoesFeitas = false;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
    
    // Carregar configuraes do backend
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }
  
  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(notificationSettingsProvider.notifier).loadSettings();
      final state = ref.read(notificationSettingsProvider);
      
      // Sincronizar estado local com o provider
      setState(() {
        _notificarEmail = state.settings.channels[NotificationChannel.email] ?? true;
        _notificarSMS = state.settings.channels[NotificationChannel.sms] ?? false;
        _notificarPush = state.settings.channels[NotificationChannel.push] ?? true;
        _naoPerturbar = state.settings.doNotDisturb;
        _inicioNaoPerturbar = state.settings.doNotDisturbStart;
        _fimNaoPerturbar = state.settings.doNotDisturbEnd;
        
        // Atualizar eventos
        for (var key in state.settings.events.keys) {
          final eventName = _mapEventKeyToName(key);
          if (eventName != null && _eventosNotificacao.containsKey(eventName)) {
            _eventosNotificacao[eventName] = state.settings.events[key] ?? true;
          }
        }
        
        // Atualizar contatos
        if (state.settings.emailRecipients.isNotEmpty) {
          _emailsNotificacao.clear();
          _emailsNotificacao.addAll(state.settings.emailRecipients);
        }
        if (state.settings.smsRecipients.isNotEmpty) {
          _telefonesNotificacao.clear();
          _telefonesNotificacao.addAll(state.settings.smsRecipients);
        }
        
        _isLoading = false;
        _alteracoesFeitas = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar configuraes: $e')),
        );
      }
    }
  }
  
  String? _mapEventKeyToName(String key) {
    const mapping = {
      'sync_alerts': 'Erro de Sincronizao',
      'error_alerts': 'Tag Offline',
      'price_alerts': 'Produto sem Preo',
      'stock_alerts': 'Margem Negativa',
      'import_alerts': 'Importao Concluda',
      'strategy_alerts': 'Estratgia Executada',
      'backup_alerts': 'Backup Realizado',
      'login_alerts': 'Novo Login Detectado',
    };
    return mapping[key];
  }
  
  String _mapEventNameToKey(String name) {
    const mapping = {
      'Erro de Sincronizao': 'sync_alerts',
      'Tag Offline': 'error_alerts',
      'Produto sem Preo': 'price_alerts',
      'Margem Negativa': 'stock_alerts',
      'Importao Concluda': 'import_alerts',
      'Estratgia Executada': 'strategy_alerts',
      'Backup Realizado': 'backup_alerts',
      'Novo Login Detectado': 'login_alerts',
    };
    return mapping[name] ?? name;
  }
  
  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    
    try {
      // Converter eventos para o formato do provider
      final events = <String, bool>{};
      for (var entry in _eventosNotificacao.entries) {
        events[_mapEventNameToKey(entry.key)] = entry.value;
      }
      
      // Atualizar o modelo no provider
      final notifier = ref.read(notificationSettingsProvider.notifier);
      notifier.updateSettings(NotificationSettingsModel(
        channels: {
          NotificationChannel.email: _notificarEmail,
          NotificationChannel.sms: _notificarSMS,
          NotificationChannel.push: _notificarPush,
        },
        events: events,
        doNotDisturb: _naoPerturbar,
        doNotDisturbStart: _inicioNaoPerturbar,
        doNotDisturbEnd: _fimNaoPerturbar,
        emailRecipients: _emailsNotificacao,
        smsRecipients: _telefonesNotificacao,
      ));
      
      // Salvar no backend
      final success = await notifier.saveSettings();
      
      setState(() => _isSaving = false);
      
      if (success && mounted) {
        setState(() => _alteracoesFeitas = false);
        _showSuccessSnackBar('Configuraes salvas com sucesso!');
      } else if (mounted) {
        final errorMessage = ref.read(notificationSettingsProvider).errorMessage;
        _showErrorSnackBar(errorMessage ?? 'Erro ao salvar configuraes');
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        _showErrorSnackBar('Erro ao salvar: $e');
      }
    }
  }
  
  void _showSuccessSnackBar(String message) {
    final isMobile = ResponsiveHelper.isMobile(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface),
            SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ThemeColors.of(context).success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
        ),
      ),
    );
  }
  
  void _showErrorSnackBar(String message) {
    final isMobile = ResponsiveHelper.isMobile(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_rounded, color: ThemeColors.of(context).surface),
            SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ThemeColors.of(context).errorDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super. dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppConst.AppColors.configuracoesGradient,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModernAppBar(),
            Padding(
              padding: EdgeInsets.all(
                AppSizes.paddingXlAlt.get(isMobile, isTablet),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildChannelsCard(),
                  SizedBox(
                    height: AppSizes.spacingMd.get(isMobile, isTablet),
                  ),
                  _buildEventsCard(),
                  SizedBox(
                    height: AppSizes.spacingMd.get(isMobile, isTablet),
                  ),
                  _buildScheduleCard(),
                  SizedBox(
                    height: AppSizes.spacingMd.get(isMobile, isTablet),
                  ),
                  _buildContactsCard(),
                  SizedBox(
                    height: AppSizes.spacingMd.get(isMobile, isTablet),
                  ),
                  _buildTestCard(),
                  SizedBox(
                    height: AppSizes.spacingXl.get(isMobile, isTablet),
                  ),
                  _buildActionButtons(),
                ],
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
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).shadowSubtle(0.05),
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 15,
              tablet: 18,
              desktop: 20,
            ),
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
                ResponsiveHelper.getResponsiveBorderRadius(
                  context,
                  mobile: 10,
                  tablet: 11,
                  desktop: 12,
                ),
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textSecondary,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              onPressed: () => Navigator. pop(context),
            ),
          ),
          SizedBox(
            width: AppSizes.spacingMd.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notificaes',
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
                Text(
                  'Configure alertas e avisos',
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
          if (_alteracoesFeitas)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                vertical: AppSizes.paddingXsAlt4.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).warningPastel,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getResponsiveBorderRadius(
                    context,
                    mobile: 7,
                    tablet: 7,
                    desktop: 8,
                  ),
                ),
                border: Border.all(color: ThemeColors.of(context).warningLight),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_rounded,
                    size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                    color: ThemeColors.of(context).warningDark,
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getResponsiveSpacing(
                      context,
                      mobile: 3,
                      tablet: 3,
                      desktop: 4,
                    ),
                  ),
                  Text(
                    'Modificado',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.of(context).warningDark,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChannelsCard() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary. withOpacity(0.05),
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
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
                    colors: [ThemeColors.of(context).purpleMaterial, ThemeColors.of(context).purpleDark],
                  ),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getResponsiveBorderRadius(
                      context,
                      mobile: 10,
                      tablet: 11,
                      desktop: 12,
                    ),
                  ),
                ),
                child: Icon(
                  Icons.notifications_active_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Text(
                'Canais de Notificao',
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
            ],
          ),
          SizedBox(
            height: AppSizes.spacingLgAlt.get(isMobile, isTablet),
          ),
          _buildChannelSwitch(
            'E-mail',
            'Receba notificaes por e-mail',
            Icons.email_rounded,
            _notificarEmail,
            ThemeColors.of(context).primary,
            (value) {
              setState(() {
                _notificarEmail = value;
                _alteracoesFeitas = true;
              });
            },
          ),
          SizedBox(
            height: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          _buildChannelSwitch(
            'SMS',
            'Receba notificaes por mensagem de texto',
            Icons.sms_rounded,
            _notificarSMS,
            ThemeColors.of(context).success,
            (value) {
              setState(() {
                _notificarSMS = value;
                _alteracoesFeitas = true;
              });
            },
          ),
          SizedBox(
            height: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          _buildChannelSwitch(
            'Push',
            'Notificaes instantneas no aplicativo',
            Icons.notifications_rounded,
            _notificarPush,
            ThemeColors.of(context).warning,
            (value) {
              setState(() {
                _notificarPush = value;
                _alteracoesFeitas = true;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChannelSwitch(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Color color,
    Function(bool) onChanged,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: value ? color. withOpacity(0.05) : ThemeColors.of(context).textSecondary,
        borderRadius: BorderRadius.circular(
          AppSizes.paddingLg.get(isMobile, isTablet),
        ),
        border: Border.all(
          color: value ? colorLight : ThemeColors.of(context).textSecondary,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: value ? color. withOpacity(0.1) : ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getResponsiveBorderRadius(
                  context,
                  mobile: 10,
                  tablet: 11,
                  desktop: 12,
                ),
              ),
            ),
            child: Icon(
              icon,
              color: value ?  color : ThemeColors.of(context).textSecondary,
              size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.spacingMd.get(isMobile, isTablet),
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
                      baseFontSize: 15,
                      mobileFontSize: 14,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: value ? ThemeColors.of(context).textPrimary : ThemeColors.of(context).textSecondary,
                  ),
                ),
                SizedBox(
                  height: AppSizes.spacingMicro.get(isMobile, isTablet),
                ),
                Text(
                  subtitle,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
          ),
        ],
      ),
    );
  }

  Widget _buildEventsCard() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).shadowSubtle(0.05),
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
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
                    colors: [ThemeColors.of(context).pinkRose, ThemeColors.of(context).error],
                  ),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getResponsiveBorderRadius(
                      context,
                      mobile: 10,
                      tablet: 11,
                      desktop: 12,
                    ),
                  ),
                ),
                child: Icon(
                  Icons.event_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Eventos para Notificar',
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
              TextButton(
                onPressed: () {
                  setState(() {
                    final allEnabled = _eventosNotificacao.values.every((v) => v);
                    _eventosNotificacao.updateAll((key, value) => !allEnabled);
                    _alteracoesFeitas = true;
                  });
                },
                child: Text(
                  _eventosNotificacao.values.every((v) => v)
                      ? 'Desmarcar'
                      : 'Marcar Todos',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                    ),
                  overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.spacingLgAlt.get(isMobile, isTablet),
          ),
          ..._eventosNotificacao.entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: AppSizes.spacingXs.get(isMobile, isTablet),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: entry.value ? ThemeColors.of(context).primaryPastel : ThemeColors.of(context).textSecondary,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getResponsiveBorderRadius(
                      context,
                      mobile: 10,
                      tablet: 11,
                      desktop: 12,
                    ),
                  ),
                  border: Border. all(
                    color: entry.value ? ThemeColors.of(context).primaryLight : ThemeColors.of(context).textSecondary,
                  ),
                ),
                child: CheckboxListTile(
                  value: entry.value,
                  onChanged: (value) {
                    setState(() {
                      _eventosNotificacao[entry.key] = value! ;
                      _alteracoesFeitas = true;
                    });
                  },
                  title: Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                      color: entry.value ? ThemeColors.of(context).primaryDark : ThemeColors.of(context).textSecondary,
                    ),
                  ),
                  secondary: Icon(
                    _getIconForEvent(entry.key),
                    color: entry.value ? ThemeColors.of(context).purpleMedium : ThemeColors.of(context).textSecondary.withOpacity(0.6),
                    size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                  ),
                  activeColor: ThemeColors.of(context).purpleMedium,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getResponsiveBorderRadius(
                        context,
                        mobile: 10,
                        tablet: 11,
                        desktop: 12,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  IconData _getIconForEvent(String event) {
    switch (event) {
      case 'Erro de Sincronizao':
        return Icons.sync_problem_rounded;
      case 'Tag Offline':
        return Icons.signal_wifi_off_rounded;
      case 'Produto sem Preo':
        return Icons.money_off_rounded;
      case 'Margem Negativa':
        return Icons.trending_down_rounded;
      case 'Importao Concluda':
        return Icons.upload_file_rounded;
      case 'Estratgia Executada':
        return Icons.auto_awesome_rounded;
      case 'Backup Realizado':
        return Icons.backup_rounded;
      case 'Novo Login Detectado':
        return Icons.login_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Widget _buildScheduleCard() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).shadowSubtle(0.05),
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
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
                    colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).blueLight],
                  ),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getResponsiveBorderRadius(
                      context,
                      mobile: 10,
                      tablet: 11,
                      desktop: 12,
                    ),
                  ),
                ),
                child: Icon(
                  Icons.bedtime_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Text(
                'Modo No Perturbe',
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
            ],
          ),
          SizedBox(
            height: AppSizes.spacingLgAlt.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingMd.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: _naoPerturbar ?  ThemeColors.of(context).infoPastel : ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(
                AppSizes.paddingLg.get(isMobile, isTablet),
              ),
              border: Border.all(
                color: _naoPerturbar ? ThemeColors.of(context).infoLight : ThemeColors.of(context).textSecondary,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets. all(
                    AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    color: _naoPerturbar
                        ? ThemeColors.of(context).infoLight
                        : ThemeColors.of(context).textSecondary,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getResponsiveBorderRadius(
                        context,
                        mobile: 10,
                        tablet: 11,
                        desktop: 12,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.do_not_disturb_on_rounded,
                    color: _naoPerturbar ? ThemeColors.of(context).primaryDark : ThemeColors.of(context).textSecondary.withOpacity(0.6),
                    size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
                  ),
                ),
                SizedBox(
                  width: AppSizes.spacingMd.get(isMobile, isTablet),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Silenciar notificaes',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 15,
                            mobileFontSize: 14,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.spacingMicro.get(isMobile, isTablet),
                      ),
                      Text(
                        'Pausar alertas em horrios especficos',
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
                Switch(
                  value: _naoPerturbar,
                  onChanged: (value) {
                    setState(() {
                      _naoPerturbar = value;
                      _alteracoesFeitas = true;
                    });
                  },
                  activeColor: ThemeColors.of(context).primary,
                ),
              ],
            ),
          ),
          if (_naoPerturbar) ...[
            SizedBox(
              height: AppSizes.spacingMd.get(isMobile, isTablet),
            ),
            Container(
              padding: EdgeInsets.all(
                AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).infoPastel,
                borderRadius: BorderRadius. circular(
                  ResponsiveHelper.getResponsiveBorderRadius(
                    context,
                    mobile: 10,
                    tablet: 11,
                    desktop: 12,
                  ),
                ),
                border: Border.all(color: ThemeColors.of(context).infoLight),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Incio',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 11,
                              mobileFontSize: 10,
                            ),
                          overflow: TextOverflow.ellipsis,
                            color: ThemeColors.of(context).textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.spacingXxs.get(isMobile, isTablet),
                        ),
                        InkWell(
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: _inicioNaoPerturbar,
                            );
                            if (time != null) {
                              setState(() {
                                _inicioNaoPerturbar = time;
                                _alteracoesFeitas = true;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                              vertical: AppSizes.paddingXs.get(isMobile, isTablet),
                            ),
                            decoration: BoxDecoration(
                              color: ThemeColors.of(context).surface,
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.getResponsiveBorderRadius(
                                  context,
                                  mobile: 7,
                                  tablet: 7,
                                  desktop: 8,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                                  color: ThemeColors.of(context).infoDark,
                                ),
                                SizedBox(
                                  width: AppSizes.spacingXs.get(isMobile, isTablet),
                                ),
                                Text(
                                  _inicioNaoPerturbar. format(context),
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      baseFontSize: 16,
                                      mobileFontSize: 14,
                                      tabletFontSize: 15,
                                    ),
                                  overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    color: ThemeColors.of(context).infoDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.spacingMd.get(isMobile, isTablet),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: ThemeColors.of(context).textSecondary,
                    size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                  ),
                  SizedBox(
                    width: AppSizes.spacingMd.get(isMobile, isTablet),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fim',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 11,
                              mobileFontSize: 10,
                            ),
                          overflow: TextOverflow.ellipsis,
                            color: ThemeColors.of(context).textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.spacingXxs.get(isMobile, isTablet),
                        ),
                        InkWell(
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: _fimNaoPerturbar,
                            );
                            if (time != null) {
                              setState(() {
                                _fimNaoPerturbar = time;
                                _alteracoesFeitas = true;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                              vertical: AppSizes.paddingXs.get(isMobile, isTablet),
                            ),
                            decoration: BoxDecoration(
                              color: ThemeColors.of(context).surface,
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.getResponsiveBorderRadius(
                                  context,
                                  mobile: 7,
                                  tablet: 7,
                                  desktop: 8,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                                  color: ThemeColors.of(context).infoDark,
                                ),
                                SizedBox(
                                  width: AppSizes.spacingXs.get(isMobile, isTablet),
                                ),
                                Text(
                                  _fimNaoPerturbar.format(context),
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      baseFontSize: 16,
                                      mobileFontSize: 14,
                                      tabletFontSize: 15,
                                    ),
                                  overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    color: ThemeColors.of(context).infoDark,
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }

  Widget _buildContactsCard() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).shadowSubtle(0.05),
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
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
                    colors: [ThemeColors.of(context).success, ThemeColors.of(context).successEnd],
                  ),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getResponsiveBorderRadius(
                      context,
                      mobile: 10,
                      tablet: 11,
                      desktop: 12,
                    ),
                  ),
                ),
                child: Icon(
                  Icons.contacts_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Text(
                'Contatos',
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
            ],
          ),
          SizedBox(
            height: AppSizes.spacingLgAlt.get(isMobile, isTablet),
          ),
          Text(
            'E-mails',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 13,
                mobileFontSize: 12,
              ),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          SizedBox(
            height: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          ..._emailsNotificacao.map((email) {
            return Container(
              margin: EdgeInsets.only(
                bottom: AppSizes.spacingXs.get(isMobile, isTablet),
              ),
              padding: EdgeInsets.all(
                AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).textSecondary,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getResponsiveBorderRadius(
                    context,
                    mobile: 10,
                    tablet: 11,
                    desktop: 12,
                  ),
                ),
                border: Border.all(color: ThemeColors.of(context).textSecondary),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      AppSizes.paddingXs.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).infoLight,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getResponsiveBorderRadius(
                          context,
                          mobile: 7,
                          tablet: 7,
                          desktop: 8,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.email_rounded,
                      size: AppSizes.iconSmall.get(isMobile, isTablet),
                      color: ThemeColors.of(context).infoDark,
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.spacingBase.get(isMobile, isTablet),
                  ),
                  Expanded(
                    child: Text(
                      email,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 13,
                          mobileFontSize: 12,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      size: AppSizes.iconSmall.get(isMobile, isTablet),
                      color: ThemeColors.of(context).textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _emailsNotificacao.remove(email);
                        _alteracoesFeitas = true;
                      });
                    },
                  ),
                ],
              ),
            );
          }). toList(),
          TextButton. icon(
            onPressed: () {
              // Adicionar novo e-mail
            },
            icon: Icon(
              Icons.add_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            label: Text(
              'Adicionar E-mail',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            height: AppSizes.spacingMd.get(isMobile, isTablet),
          ),
          Text(
            'Telefones (SMS)',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 13,
                mobileFontSize: 12,
              ),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          SizedBox(
            height: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          ..._telefonesNotificacao. map((telefone) {
            return Container(
              margin: EdgeInsets. only(
                bottom: AppSizes.spacingXs.get(isMobile, isTablet),
              ),
              padding: EdgeInsets.all(
                AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).textSecondary,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getResponsiveBorderRadius(
                    context,
                    mobile: 10,
                    tablet: 11,
                    desktop: 12,
                  ),
                ),
                border: Border. all(color: ThemeColors.of(context).textSecondaryLight),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      AppSizes.paddingXs.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).successLight,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getResponsiveBorderRadius(
                          context,
                          mobile: 7,
                          tablet: 7,
                          desktop: 8,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.phone_rounded,
                      size: AppSizes.iconSmall.get(isMobile, isTablet),
                      color: ThemeColors.of(context).successIcon,
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.spacingBase.get(isMobile, isTablet),
                  ),
                  Expanded(
                    child: Text(
                      telefone,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 13,
                          mobileFontSize: 12,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      size: AppSizes.iconSmall.get(isMobile, isTablet),
                      color: ThemeColors.of(context).textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _telefonesNotificacao.remove(telefone);
                        _alteracoesFeitas = true;
                      });
                    },
                  ),
                ],
              ),
            );
          }).toList(),
          TextButton.icon(
            onPressed: () {
              // Adicionar novo telefone
            },
            icon: Icon(
              Icons.add_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            label: Text(
              'Adicionar Telefone',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCard() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).warningPastel, ThemeColors.of(context).orangeAmberLight],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        border: Border.all(color: ThemeColors.of(context).warningLight),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.science_rounded,
                color: ThemeColors.of(context).warningDark,
                size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Text(
                'Testar Notificaes',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).warningDark,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          Text(
            'Envie uma notificao de teste para verificar se tudo est funcionando corretamente.',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 13,
                mobileFontSize: 12,
              ),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          SizedBox(
            height: AppSizes.spacingMd.get(isMobile, isTablet),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton. icon(
              onPressed: _enviarNotificacaoTeste,
              icon: Icon(
                Icons.send_rounded,
                size: AppSizes.iconSmall.get(isMobile, isTablet),
              ),
              label: Text(
                'Enviar Notificao de Teste',
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
                backgroundColor: ThemeColors.of(context).orangeMaterial,
                foregroundColor: ThemeColors.of(context).surface,
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.paddingSm.get(isMobile, isTablet),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getResponsiveBorderRadius(
                      context,
                      mobile: 10,
                      tablet: 11,
                      desktop: 12,
                    ),
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
                vertical: AppSizes.paddingMdLg.get(isMobile, isTablet),
              ),
              side: BorderSide(color: ThemeColors.of(context).textSecondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppSizes.paddingLg.get(isMobile, isTablet),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: AppSizes.spacingMd.get(isMobile, isTablet),
        ),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveSettings,
            icon: _isSaving 
              ? SizedBox(
                  width: AppSizes.iconSmall.get(isMobile, isTablet),
                  height: AppSizes.iconSmall.get(isMobile, isTablet),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
                  ),
                )
              : Icon(
                  Icons.check_rounded,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                ),
            label: Text(
              _isSaving ? 'Salvando...' : 'Salvar Configuraes',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
            style: ElevatedButton. styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.paddingMdLg.get(isMobile, isTablet),
              ),
              backgroundColor: ThemeColors.of(context).pinkRose,
              foregroundColor: ThemeColors.of(context).surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppSizes.paddingLg.get(isMobile, isTablet),
                ),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  void _enviarNotificacaoTeste() async {
    final isMobile = ResponsiveHelper.isMobile(context);

    // Mostrar dialog de loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getResponsiveBorderRadius(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: ResponsiveHelper.getResponsiveWidth(
                  context,
                  mobile: 40,
                  tablet: 45,
                  desktop: 50,
                ),
                height: ResponsiveHelper.getResponsiveHeight(
                  context,
                  mobile: 40,
                  tablet: 45,
                  desktop: 50,
                ),
                child: const CircularProgressIndicator(),
              ),
              SizedBox(
                height: AppSizes.spacingLgAlt.get(isMobile, isTablet),
              ),
              Text(
                'Enviando notificao de teste...',
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
        );
      },
    );

    // Chamar API real
    final success = await ref.read(notificationSettingsProvider.notifier).sendTestNotification();

    if (!mounted) return;

    // Fechar dialog
    Navigator.pop(context);

    // Mostrar resultado
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
                color: ThemeColors.of(context).surfaceLight,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getResponsiveBorderRadius(
                    context,
                    mobile: 7,
                    tablet: 7,
                    desktop: 8,
                  ),
                ),
              ),
              child: Icon(
                success ? Icons.mark_email_read_rounded : Icons.error_outline,
                color: ThemeColors.of(context).surface,
                size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
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
                    success ? 'Notificao Enviada!' : 'Erro no Envio',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    success 
                        ? 'Verifique sua caixa de entrada' 
                        : 'Tente novamente mais tarde',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 12,
                        mobileFontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: success ? ThemeColors.of(context).success : ThemeColors.of(context).error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.paddingLg.get(isMobile, isTablet),
          ),
        ),
        padding: EdgeInsets.all(
          AppSizes.paddingMdAlt.get(isMobile, isTablet),
        ),
      ),
    );
  }
}








