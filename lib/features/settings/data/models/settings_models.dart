// Models robustos para o m�dulo Settings
/// Parte da migra��o para arquitetura Riverpod StateNotifierProvider
/// 
/// Estrutura:
/// - Enums: NotificationChannel, NotificationEvent
/// - Models: StoreSettings, ERPSettings, NotificationSettings, BackupInfo

library settings_models;

import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

// =============================================================================
// ENUMS
// =============================================================================

/// Status de carregamento espec�fico para Settings
/// Inclui estados extras (saving, saved) para opera��es de persist�ncia
enum SettingsLoadingStatus {
  initial,
  loading,
  loaded,
  saving,
  saved,
  error,
}

/// Canais de notifica��o
enum NotificationChannel {
  email('Email', Icons.email_rounded),
  sms('SMS', Icons.sms_rounded),
  push('Push', Icons.notifications_rounded);

  const NotificationChannel(this.label, this.icon);
  
  final String label;
  final IconData icon;
}

/// Tipos de eventos de notifica��o
enum NotificationEvent {
  syncError('Erro de Sincroniza��o', 'sync_error', true),
  tagOffline('Tag Offline', 'tag_offline', true),
  productNoPrice('Produto sem Pre�o', 'product_no_price', true),
  negativeMargin('Margem Negativa', 'negative_margin', true),
  importComplete('Importa��o Conclu�da', 'import_complete', false),
  strategyExecuted('Estrat�gia Executada', 'strategy_executed', true),
  backupComplete('Backup Realizado', 'backup_complete', false),
  newLogin('Novo Login Detectado', 'new_login', true);

  const NotificationEvent(this.label, this.key, this.defaultEnabled);
  
  final String label;
  final String key;
  final bool defaultEnabled;
}

/// Status de conex�o ERP
enum ERPConnectionStatus {
  connected('Conectado', 'statusConnected'),
  disconnected('Desconectado', 'statusError'),
  testing('Testando...', 'statusWarning'),
  error('Erro', 'statusError');

  const ERPConnectionStatus(this.label, this.colorKey);
  
  final String label;
  final String colorKey; // Semantic color key - resolve at UI layer with ThemeColors.of(context)
}

/// Tipo de integra��o ERP
enum ERPIntegrationType {
  none('Nenhum', 'none'),
  totvs('TOTVS', 'totvs'),
  sap('SAP', 'sap'),
  oracle('Oracle', 'oracle'),
  sage('Sage', 'sage'),
  bling('Bling', 'bling'),
  tiny('Tiny', 'tiny'),
  custom('Personalizado', 'custom');

  const ERPIntegrationType(this.label, this.key);
  
  final String label;
  final String key;
}

/// Frequ�ncia de backup
enum BackupFrequency {
  daily('Di�rio', 'daily'),
  weekly('Semanal', 'weekly'),
  monthly('Mensal', 'monthly'),
  manual('Manual', 'manual');

  const BackupFrequency(this.label, this.key);
  
  final String label;
  final String key;
}

// =============================================================================
// MODELS
// =============================================================================

/// Configura��es da Loja
class StoreSettingsModel {
  final String nome;
  final String cnpj;
  final String endereco;
  final String cidade;
  final String estado;
  final String cep;
  final String telefone;
  final String email;
  final String? logoUrl;
  final String? website;
  final Map<String, dynamic> horarioFuncionamento;
  final bool ativo;

  const StoreSettingsModel({
    this.nome = '',
    this.cnpj = '',
    this.endereco = '',
    this.cidade = '',
    this.estado = '',
    this.cep = '',
    this.telefone = '',
    this.email = '',
    this.logoUrl,
    this.website,
    this.horarioFuncionamento = const {},
    this.ativo = true,
  });

  bool get isValid {
    return nome.isNotEmpty && 
           cnpj.isNotEmpty && 
           email.isNotEmpty;
  }

  StoreSettingsModel copyWith({
    String? nome,
    String? cnpj,
    String? endereco,
    String? cidade,
    String? estado,
    String? cep,
    String? telefone,
    String? email,
    String? logoUrl,
    String? website,
    Map<String, dynamic>? horarioFuncionamento,
    bool? ativo,
  }) {
    return StoreSettingsModel(
      nome: nome ?? this.nome,
      cnpj: cnpj ?? this.cnpj,
      endereco: endereco ?? this.endereco,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      cep: cep ?? this.cep,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      logoUrl: logoUrl ?? this.logoUrl,
      website: website ?? this.website,
      horarioFuncionamento: horarioFuncionamento ?? this.horarioFuncionamento,
      ativo: ativo ?? this.ativo,
    );
  }

  factory StoreSettingsModel.fromJson(Map<String, dynamic> json) {
    return StoreSettingsModel(
      nome: json['nome'] ?? '',
      cnpj: json['cnpj'] ?? '',
      endereco: json['endereco'] ?? '',
      cidade: json['cidade'] ?? '',
      estado: json['estado'] ?? '',
      cep: json['cep'] ?? '',
      telefone: json['telefone'] ?? '',
      email: json['email'] ?? '',
      logoUrl: json['logoUrl'],
      website: json['website'],
      horarioFuncionamento: json['horarioFuncionamento'] ?? {},
      ativo: json['ativo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cnpj': cnpj,
      'endereco': endereco,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
      'telefone': telefone,
      'email': email,
      'logoUrl': logoUrl,
      'website': website,
      'horarioFuncionamento': horarioFuncionamento,
      'ativo': ativo,
    };
  }
}

/// Configura��es de Integra��o ERP
class ERPSettingsModel {
  final ERPIntegrationType tipo;
  final String? url;
  final String? apiKey;
  final String? usuario;
  final String? senha;
  final bool autoSync;
  final int syncIntervalMinutes;
  final ERPConnectionStatus connectionStatus;
  final DateTime? lastSync;
  final String? lastError;
  final Map<String, bool> syncOptions;

  const ERPSettingsModel({
    this.tipo = ERPIntegrationType.custom,
    this.url,
    this.apiKey,
    this.usuario,
    this.senha,
    this.autoSync = false,
    this.syncIntervalMinutes = 30,
    this.connectionStatus = ERPConnectionStatus.disconnected,
    this.lastSync,
    this.lastError,
    this.syncOptions = const {},
  });

  bool get isConfigured {
    return url != null && url!.isNotEmpty;
  }

  bool get hasCredentials {
    return (apiKey != null && apiKey!.isNotEmpty) ||
           (usuario != null && senha != null);
  }

  ERPSettingsModel copyWith({
    ERPIntegrationType? tipo,
    String? url,
    String? apiKey,
    String? usuario,
    String? senha,
    bool? autoSync,
    int? syncIntervalMinutes,
    ERPConnectionStatus? connectionStatus,
    DateTime? lastSync,
    String? lastError,
    Map<String, bool>? syncOptions,
  }) {
    return ERPSettingsModel(
      tipo: tipo ?? this.tipo,
      url: url ?? this.url,
      apiKey: apiKey ?? this.apiKey,
      usuario: usuario ?? this.usuario,
      senha: senha ?? this.senha,
      autoSync: autoSync ?? this.autoSync,
      syncIntervalMinutes: syncIntervalMinutes ?? this.syncIntervalMinutes,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      lastSync: lastSync ?? this.lastSync,
      lastError: lastError ?? this.lastError,
      syncOptions: syncOptions ?? this.syncOptions,
    );
  }

  factory ERPSettingsModel.fromJson(Map<String, dynamic> json) {
    return ERPSettingsModel(
      tipo: ERPIntegrationType.values.firstWhere(
        (t) => t.key == json['tipo'],
        orElse: () => ERPIntegrationType.custom,
      ),
      url: json['url'],
      apiKey: json['apiKey'],
      usuario: json['usuario'],
      senha: json['senha'],
      autoSync: json['autoSync'] ?? false,
      syncIntervalMinutes: json['syncIntervalMinutes'] ?? 30,
      connectionStatus: ERPConnectionStatus.values.firstWhere(
        (s) => s.name == json['connectionStatus'],
        orElse: () => ERPConnectionStatus.disconnected,
      ),
      lastSync: json['lastSync'] != null 
          ? DateTime.parse(json['lastSync']) 
          : null,
      lastError: json['lastError'],
      syncOptions: (json['syncOptions'] as Map<String, dynamic>?)?.cast<String, bool>() ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo.key,
      'url': url,
      'apiKey': apiKey,
      'usuario': usuario,
      'senha': senha,
      'autoSync': autoSync,
      'syncIntervalMinutes': syncIntervalMinutes,
      'connectionStatus': connectionStatus.name,
      'lastSync': lastSync?.toIso8601String(),
      'lastError': lastError,
      'syncOptions': syncOptions,
    };
  }
}

/// Configura��es de Notifica��o
class NotificationSettingsModel {
  final Map<NotificationChannel, bool> channels;
  final Map<String, bool> events;
  final bool doNotDisturb;
  final TimeOfDay doNotDisturbStart;
  final TimeOfDay doNotDisturbEnd;
  final List<String> emailRecipients;
  final List<String> smsRecipients;
  final bool soundEnabled;
  final bool vibrationEnabled;

  const NotificationSettingsModel({
    this.channels = const {
      NotificationChannel.email: true,
      NotificationChannel.sms: false,
      NotificationChannel.push: true,
    },
    this.events = const {},
    this.doNotDisturb = false,
    this.doNotDisturbStart = const TimeOfDay(hour: 22, minute: 0),
    this.doNotDisturbEnd = const TimeOfDay(hour: 7, minute: 0),
    this.emailRecipients = const [],
    this.smsRecipients = const [],
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  bool isChannelEnabled(NotificationChannel channel) {
    return channels[channel] ?? false;
  }

  bool isEventEnabled(NotificationEvent event) {
    return events[event.key] ?? event.defaultEnabled;
  }

  NotificationSettingsModel copyWith({
    Map<NotificationChannel, bool>? channels,
    Map<String, bool>? events,
    bool? doNotDisturb,
    TimeOfDay? doNotDisturbStart,
    TimeOfDay? doNotDisturbEnd,
    List<String>? emailRecipients,
    List<String>? smsRecipients,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return NotificationSettingsModel(
      channels: channels ?? this.channels,
      events: events ?? this.events,
      doNotDisturb: doNotDisturb ?? this.doNotDisturb,
      doNotDisturbStart: doNotDisturbStart ?? this.doNotDisturbStart,
      doNotDisturbEnd: doNotDisturbEnd ?? this.doNotDisturbEnd,
      emailRecipients: emailRecipients ?? this.emailRecipients,
      smsRecipients: smsRecipients ?? this.smsRecipients,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }

  NotificationSettingsModel toggleChannel(NotificationChannel channel) {
    final newChannels = Map<NotificationChannel, bool>.from(channels);
    newChannels[channel] = !(newChannels[channel] ?? false);
    return copyWith(channels: newChannels);
  }

  NotificationSettingsModel toggleEvent(String eventKey) {
    final newEvents = Map<String, bool>.from(events);
    newEvents[eventKey] = !(newEvents[eventKey] ?? true);
    return copyWith(events: newEvents);
  }

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      channels: (json['channels'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(
          NotificationChannel.values.firstWhere((c) => c.name == k),
          v as bool,
        ),
      ) ?? {},
      events: (json['events'] as Map<String, dynamic>?)?.cast<String, bool>() ?? {},
      doNotDisturb: json['doNotDisturb'] ?? false,
      doNotDisturbStart: _timeFromJson(json['doNotDisturbStart']) ?? const TimeOfDay(hour: 22, minute: 0),
      doNotDisturbEnd: _timeFromJson(json['doNotDisturbEnd']) ?? const TimeOfDay(hour: 7, minute: 0),
      emailRecipients: (json['emailRecipients'] as List?)?.cast<String>() ?? [],
      smsRecipients: (json['smsRecipients'] as List?)?.cast<String>() ?? [],
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
    );
  }

  static TimeOfDay? _timeFromJson(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Map<String, dynamic> toJson() {
    return {
      'channels': channels.map((k, v) => MapEntry(k.name, v)),
      'events': events,
      'doNotDisturb': doNotDisturb,
      'doNotDisturbStart': '${doNotDisturbStart.hour}:${doNotDisturbStart.minute}',
      'doNotDisturbEnd': '${doNotDisturbEnd.hour}:${doNotDisturbEnd.minute}',
      'emailRecipients': emailRecipients,
      'smsRecipients': smsRecipients,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
    };
  }
}

/// Informa��es de Backup
class BackupInfoModel {
  final String id;
  final String name;
  final DateTime createdAt;
  final String size;
  final BackupFrequency frequency;
  final bool isAutomatic;
  final bool isComplete;
  final String? downloadUrl;
  final Map<String, int> itemCounts;

  const BackupInfoModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.size,
    this.frequency = BackupFrequency.manual,
    this.isAutomatic = false,
    this.isComplete = true,
    this.downloadUrl,
    this.itemCounts = const {},
  });

  factory BackupInfoModel.fromJson(Map<String, dynamic> json) {
    return BackupInfoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      size: json['size'] as String,
      frequency: BackupFrequency.values.firstWhere(
        (f) => f.key == json['frequency'],
        orElse: () => BackupFrequency.manual,
      ),
      isAutomatic: json['isAutomatic'] ?? false,
      isComplete: json['isComplete'] ?? true,
      downloadUrl: json['downloadUrl'],
      itemCounts: (json['itemCounts'] as Map<String, dynamic>?)?.cast<String, int>() ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'size': size,
      'frequency': frequency.key,
      'isAutomatic': isAutomatic,
      'isComplete': isComplete,
      'downloadUrl': downloadUrl,
      'itemCounts': itemCounts,
    };
  }
}

/// Op��o de menu de configura��es
class SettingsMenuOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final String? badge;
  final bool isNew;
  final bool requiresAuth;
  final Widget? targetScreen;

  const SettingsMenuOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    this.badge,
    this.isNew = false,
    this.requiresAuth = false,
    this.targetScreen,
  });
}





