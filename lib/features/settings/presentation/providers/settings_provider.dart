/// Providers Riverpod para o módulo Settings

/// Migração completa para StateNotifierProvider

/// 

/// Estrutura:

/// - States: Estados imutáveis para cada tela

/// - Notifiers: StateNotifier para lógica de negócio

/// - Providers: StateNotifierProvider exportados



library settings_provider;



import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tagbean/features/settings/data/models/settings_models.dart';

import 'package:tagbean/shared/data/repositories/settings_repository.dart';

import 'package:tagbean/core/storage/storage_service.dart';



/// Provider do SettingsRepository

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {

  return SettingsRepository();

});



/// Provider para obter o storeId atual (async)

final currentStoreIdProvider = FutureProvider<String?>((ref) async {

  // Retorna o storeId do storage

  // Em produção, isso vem do contexto de trabalho do usuário logado

  return StorageService().getString('currentStoreId');

});



// =============================================================================

// SETTINGS MENU STATE

// =============================================================================



/// Estado do menu de configurações

class SettingsMenuState {

  final SettingsLoadingStatus status;

  final List<SettingsMenuOption> menuOptions;

  final String? selectedTitle;

  final Widget? selectedScreen;

  final String? errorMessage;



  const SettingsMenuState({

    this.status = SettingsLoadingStatus.initial,

    this.menuOptions = const [],

    this.selectedTitle,

    this.selectedScreen,

    this.errorMessage,

  });



  SettingsMenuState copyWith({

    SettingsLoadingStatus? status,

    List<SettingsMenuOption>? menuOptions,

    String? selectedTitle,

    Widget? selectedScreen,

    String? errorMessage,

  }) {

    return SettingsMenuState(

      status: status ?? this.status,

      menuOptions: menuOptions ?? this.menuOptions,

      selectedTitle: selectedTitle ?? this.selectedTitle,

      selectedScreen: selectedScreen ?? this.selectedScreen,

      errorMessage: errorMessage ?? this.errorMessage,

    );

  }

}



/// Notifier para menu de configurações

class SettingsMenuNotifier extends StateNotifier<SettingsMenuState> {

  SettingsMenuNotifier() : super(const SettingsMenuState());



  void setLoading() {

    state = state.copyWith(status: SettingsLoadingStatus.loading);

  }



  void setLoaded({List<SettingsMenuOption>? options}) {

    state = state.copyWith(

      status: SettingsLoadingStatus.loaded,

      menuOptions: options ?? state.menuOptions,

    );

  }



  void setError(String message) {

    state = state.copyWith(

      status: SettingsLoadingStatus.error,

      errorMessage: message,

    );

  }



  void selectScreen(String title, Widget screen) {

    state = state.copyWith(

      selectedTitle: title,

      selectedScreen: screen,

    );

  }



  void clearSelection() {

    state = state.copyWith(

      selectedTitle: null,

      selectedScreen: null,

    );

  }

}



/// Provider do menu de configurações

final settingsMenuProvider = 

    StateNotifierProvider<SettingsMenuNotifier, SettingsMenuState>((ref) {

  return SettingsMenuNotifier();

});



// =============================================================================

// STORE SETTINGS STATE

// =============================================================================



/// Estado das configurações da loja

class StoreSettingsState {

  final SettingsLoadingStatus status;

  final StoreSettingsModel settings;

  final bool hasChanges;

  final String? errorMessage;

  final List<String>? validationErrors;



  const StoreSettingsState({

    this.status = SettingsLoadingStatus.initial,

    this.settings = const StoreSettingsModel(),

    this.hasChanges = false,

    this.errorMessage,

    this.validationErrors,

  });



  StoreSettingsState copyWith({

    SettingsLoadingStatus? status,

    StoreSettingsModel? settings,

    bool? hasChanges,

    String? errorMessage,

    List<String>? validationErrors,

  }) {

    return StoreSettingsState(

      status: status ?? this.status,

      settings: settings ?? this.settings,

      // ignore: argument_type_not_assignable
      hasChanges: hasChanges ?? this.hasChanges,
 // ignore: argument_type_not_assignable

      // ignore: argument_type_not_assignable
      errorMessage: errorMessage ?? this.errorMessage,
 // ignore: argument_type_not_assignable

      // ignore: argument_type_not_assignable
      validationErrors: validationErrors ?? this.validationErrors,
 // ignore: argument_type_not_assignable

    // ignore: argument_type_not_assignable
    );
 // ignore: argument_type_not_assignable

  }

}



/// Notifier para configurações da loja

class StoreSettingsNotifier extends StateNotifier<StoreSettingsState> {

  final SettingsRepository _repository;

  final String? _storeId;

  

  StoreSettingsNotifier(this._repository, this._storeId) 

      : super(const StoreSettingsState());



  void setLoading() {

    state = state.copyWith(status: SettingsLoadingStatus.loading);

  }



  void setLoaded(StoreSettingsModel settings) {

    state = state.copyWith(

      status: SettingsLoadingStatus.loaded,

      settings: settings,

      hasChanges: false,

    );

  }



  void setSaving() {

    state = state.copyWith(status: SettingsLoadingStatus.saving);

  }



  void setSaved() {

    state = state.copyWith(

      status: SettingsLoadingStatus.saved,

      hasChanges: false,

    );

  }



  void setError(String message) {

    state = state.copyWith(

      status: SettingsLoadingStatus.error,

      errorMessage: message,

    );

  }



  void updateNome(String nome) {

    state = state.copyWith(

      settings: state.settings.copyWith(nome: nome),

      hasChanges: true,

    );

  }



  void updateCnpj(String cnpj) {

    state = state.copyWith(

      settings: state.settings.copyWith(cnpj: cnpj),

      hasChanges: true,

    );

  }



  void updateendereco(String endereco) {

    state = state.copyWith(

      settings: state.settings.copyWith(endereco: endereco),

      hasChanges: true,

    );

  }



  void updateCidade(String cidade) {

    state = state.copyWith(

      settings: state.settings.copyWith(cidade: cidade),

      hasChanges: true,

    );

  }



  void updateEstado(String estado) {

    state = state.copyWith(

      settings: state.settings.copyWith(estado: estado),

      hasChanges: true,

    );

  }



  void updateCep(String cep) {

    state = state.copyWith(

      settings: state.settings.copyWith(cep: cep),

      hasChanges: true,

    );

  }



  void updateTelefone(String telefone) {

    state = state.copyWith(

      settings: state.settings.copyWith(telefone: telefone),

      hasChanges: true,

    );

  }



  void updateEmail(String email) {

    state = state.copyWith(

      settings: state.settings.copyWith(email: email),

      hasChanges: true,

    );

  }

 // ignore: argument_type_not_assignable

 // ignore: argument_type_not_assignable

  // ignore: argument_type_not_assignable
  void updateSettings(StoreSettingsModel settings) {
 // ignore: argument_type_not_assignable

    // ignore: argument_type_not_assignable
    state = state.copyWith(

      settings: settings,

      hasChanges: true,

    );

  }



  List<String> validate() {

    final errors = <String>[];

    if (state.settings.nome.isEmpty) {

      errors.add('Nome da loja é obrigatório');

    }

    if (state.settings.cnpj.isEmpty) {

      errors.add('CNPJ é obrigatório');

    }

    if (state.settings.email.isEmpty) {

      errors.add('Email é obrigatório');

    }

    state = state.copyWith(validationErrors: errors);

    return errors;

  }



  Future<void> loadSettings() async {

    setLoading();

    try {

      // API: GET /api/stores/:storeId

      if (_storeId == null) {

        // SEM STORE ID: Mostrar erro

        setError('StoreId não configurado. Faça login novamente.');

        return;

      }

      

      final response = await _repository.getStoreSettings(_storeId!);

      

      if (response.isSuccess && response.data != null) {

        final data = response.data!;

        setLoaded(StoreSettingsModel(

          nome: (data['name']).toString() ?? '',

          cnpj: (data['cnpj']).toString() ?? '',

          endereco: (data['address']).toString() ?? '',

          cidade: (data['city']).toString() ?? '',

          estado: (data['state']).toString() ?? '',

          cep: (data['zipCode']).toString() ?? '',

          telefone: (data['phone']).toString() ?? '',

          email: (data['email']).toString() ?? '',

        ));

      } else {

        setError(response.errorMessage ?? 'Erro ao carregar configurações da API');

      }

    } catch (e) {

      setError('Falha ao conectar com o servidor: $e');

    }

  }



  Future<bool> saveSettings() async {

    final errors = validate();

    if (errors.isNotEmpty) return false;



    setSaving();

    try {

      // API: PUT /api/stores/:storeId

      if (_storeId == null) {

        // SEM STORE ID: Propaga erro

        setError('StoreId não configurado. Faça login novamente.');

        return false;

      }

      

      final response = await _repository.updateStoreSettings(

        storeId: _storeId!,

        nome: state.settings.nome,

        cnpj: state.settings.cnpj,

        endereco: state.settings.endereco,

        cidade: state.settings.cidade,

        estado: state.settings.estado,

        cep: state.settings.cep,

        telefone: state.settings.telefone,

        email: state.settings.email,

      );

      

      if (response.isSuccess) {

        setSaved();

        return true;

      } else {

        setError(response.errorMessage ?? 'Erro ao salvar');

        return false;

      }

    } catch (e) {

      setError('Erro ao salvar configurações: $e');

      return false;

    }

  }



  void reset() {

    state = const StoreSettingsState();

  }

}



/// Provider de configurações da loja

final storeSettingsProvider = 

    StateNotifierProvider<StoreSettingsNotifier, StoreSettingsState>((ref) {

  final repository = ref.watch(settingsRepositoryProvider);

  final storeIdAsync = ref.watch(currentStoreIdProvider);

  final storeId = storeIdAsync.valueOrNull;

  return StoreSettingsNotifier(repository, storeId);

});



// =============================================================================

// ERP SETTINGS STATE

// =============================================================================



/// Estado das configurações ERP

class ERPSettingsState {

  final SettingsLoadingStatus status;

  final ERPSettingsModel settings;

  final bool hasChanges;

  final bool isTesting;

  final String? errorMessage;



  const ERPSettingsState({

    this.status = SettingsLoadingStatus.initial,

    this.settings = const ERPSettingsModel(),

    this.hasChanges = false,

    this.isTesting = false,

    this.errorMessage,

  });



  ERPSettingsState copyWith({

    SettingsLoadingStatus? status,

    ERPSettingsModel? settings,

    bool? hasChanges,

    bool? isTesting,

    String? errorMessage,

  }) {

    return ERPSettingsState(

      status: status ?? this.status,

      settings: settings ?? this.settings,

      hasChanges: hasChanges ?? this.hasChanges,

      isTesting: isTesting ?? this.isTesting,

      errorMessage: errorMessage ?? this.errorMessage,

    );
 // ignore: argument_type_not_assignable

  // ignore: argument_type_not_assignable
  }

}



/// Notifier para configurações ERP

class ERPSettingsNotifier extends StateNotifier<ERPSettingsState> {

  final SettingsRepository _repository;

  

  ERPSettingsNotifier(this._repository) : super(const ERPSettingsState());



  void setLoading() {

    state = state.copyWith(status: SettingsLoadingStatus.loading);

  }



  void setLoaded(ERPSettingsModel settings) {

    state = state.copyWith(

      status: SettingsLoadingStatus.loaded,

      settings: settings,

      hasChanges: false,

    );

  }



  void setSaving() {

    state = state.copyWith(status: SettingsLoadingStatus.saving);

  }



  void setSaved() {

    state = state.copyWith(

      status: SettingsLoadingStatus.saved,

      hasChanges: false,

    );

  }



  void setError(String message) {

    state = state.copyWith(

      status: SettingsLoadingStatus.error,

      errorMessage: message,

    );

  }



  void updateTipo(ERPIntegrationType tipo) {

    state = state.copyWith(

      settings: state.settings.copyWith(tipo: tipo),

      hasChanges: true,

    );

  }



  void updateUrl(String url) {

    state = state.copyWith(

      settings: state.settings.copyWith(url: url),

      hasChanges: true,

    );

  }



  void updateApiKey(String apiKey) {

    state = state.copyWith(

      settings: state.settings.copyWith(apiKey: apiKey),

      hasChanges: true,

    );

  }



  void updateCredentials(String usuario, String senha) {

    state = state.copyWith(

      settings: state.settings.copyWith(usuario: usuario, senha: senha),

      hasChanges: true,

    );

  }



  void toggleAutoSync() {

    state = state.copyWith(

      settings: state.settings.copyWith(autoSync: !state.settings.autoSync),

      hasChanges: true,

    );

  }



  void updateSyncInterval(int minutes) {

    state = state.copyWith(

      settings: state.settings.copyWith(syncIntervalMinutes: minutes),

      hasChanges: true,

    );

  }

 // ignore: argument_type_not_assignable

 // ignore: argument_type_not_assignable

  // ignore: argument_type_not_assignable
  void updateSettings(ERPSettingsModel settings) {
 // ignore: argument_type_not_assignable

    state = state.copyWith(

      settings: settings,

      hasChanges: true,

    );

  }



  Future<void> loadSettings() async {

    setLoading();

    try {

      // API: GET /api/configurations/erp

      final response = await _repository.getERPSettings();

      

      if (response.isSuccess && response.data != null) {

        final data = response.data!;

        setLoaded(ERPSettingsModel(

          tipo: _parseERPType((data['type']).toString()),
 // ignore: argument_type_not_assignable

          url: (data['apiUrl']).toString() ?? '',
 // ignore: argument_type_not_assignable

          apiKey: (data['apiKey']).toString() ?? '',

          // ignore: argument_type_not_assignable
          autoSync: data['syncProducts'] ?? true,

          // ignore: argument_type_not_assignable
          syncIntervalMinutes: data['syncInterval'] ?? 30,

        ));

      } else {

        // Fallback para config padrão

        setLoaded(const ERPSettingsModel());

      }

    } catch (e) {

      setError('Erro ao carregar configurações: $e');

    }

  }

  

  ERPIntegrationType _parseERPType(String? type) {

    switch (type?.toLowerCase()) {

      case 'sap':

        return ERPIntegrationType.sap;

      case 'totvs':

        return ERPIntegrationType.totvs;

      case 'bling':

        return ERPIntegrationType.bling;

      case 'tiny':

        return ERPIntegrationType.tiny;

      case 'custom':

        return ERPIntegrationType.custom;

      default:

        return ERPIntegrationType.none;

    }

  }



  Future<bool> testConnection() async {

    state = state.copyWith(

      isTesting: true,

      settings: state.settings.copyWith(

        connectionStatus: ERPConnectionStatus.testing,

      ),

    );



    try {

      // API: POST /api/configurations/erp/test

      final response = await _repository.testERPConnection(

        type: state.settings.tipo.name,

        apiUrl: state.settings.url ?? '',

        apiKey: state.settings.apiKey ?? '',

      );

      

      if (response.isSuccess) {

        state = state.copyWith(

          isTesting: false,

          settings: state.settings.copyWith(

            connectionStatus: ERPConnectionStatus.connected,

            lastSync: DateTime.now(),

          ),

        );

        return true;

      } else {

        state = state.copyWith(

          isTesting: false,

          settings: state.settings.copyWith(

            connectionStatus: ERPConnectionStatus.error,

            lastError: response.errorMessage,

          ),

        );

        return false;

      }

    } catch (e) {

      state = state.copyWith(

        isTesting: false,

        settings: state.settings.copyWith(

          connectionStatus: ERPConnectionStatus.error,

          lastError: e.toString(),

        ),

      );

      return false;

    }

  }



  Future<bool> saveSettings() async {

    setSaving();

    try {

      // API: PUT /api/configurations/erp

      final response = await _repository.saveERPSettings(

        type: state.settings.tipo.name,

        apiUrl: state.settings.url ?? '',

        apiKey: state.settings.apiKey ?? '',

        syncProducts: state.settings.autoSync,

        syncInterval: state.settings.syncIntervalMinutes,

      );

      

      if (response.isSuccess) {

        setSaved();

        return true;

      } else {

        setError(response.errorMessage ?? 'Erro ao salvar');

        return false;

      }

    } catch (e) {

      setError('Erro ao salvar configurações: $e');

      return false;

    }

  }



  void reset() {

    state = const ERPSettingsState();

  }

}



/// Provider de configurações ERP

final erpSettingsProvider = 

    StateNotifierProvider<ERPSettingsNotifier, ERPSettingsState>((ref) {

  final repository = ref.watch(settingsRepositoryProvider);

  return ERPSettingsNotifier(repository);

});



// =============================================================================

// NOTIFICATIONS SETTINGS STATE

// =============================================================================



/// Estado das configurações de notificação

class NotificationSettingsState {

  final SettingsLoadingStatus status;

  final NotificationSettingsModel settings;

  final bool hasChanges;

  final String? errorMessage;



  const NotificationSettingsState({

    this.status = SettingsLoadingStatus.initial,

    this.settings = const NotificationSettingsModel(),

    this.hasChanges = false,

    this.errorMessage,

  });



  NotificationSettingsState copyWith({

    SettingsLoadingStatus? status,

    NotificationSettingsModel? settings,

    bool? hasChanges,

    String? errorMessage,

  }) {

    return NotificationSettingsState(

      status: status ?? this.status,

      settings: settings ?? this.settings,

      hasChanges: hasChanges ?? this.hasChanges,

      errorMessage: errorMessage ?? this.errorMessage,

    );

  }

}



/// Notifier para configurações de notificação

class NotificationSettingsNotifier extends StateNotifier<NotificationSettingsState> {

  final SettingsRepository _repository;

  

  NotificationSettingsNotifier(this._repository) : super(const NotificationSettingsState());



  void setLoading() {

    state = state.copyWith(status: SettingsLoadingStatus.loading);

  }



  void setLoaded(NotificationSettingsModel settings) {

    state = state.copyWith(

      status: SettingsLoadingStatus.loaded,

      settings: settings,

      hasChanges: false,

    );

  }



  void setSaving() {

    state = state.copyWith(status: SettingsLoadingStatus.saving);

  }



  void setSaved() {

    state = state.copyWith(

      status: SettingsLoadingStatus.saved,

      hasChanges: false,

    );

  }



  void setError(String message) {

    state = state.copyWith(

      status: SettingsLoadingStatus.error,

      errorMessage: message,

    );

  }



  void toggleChannel(NotificationChannel channel) {

    state = state.copyWith(

      settings: state.settings.toggleChannel(channel),

      hasChanges: true,

    );

  }



  void toggleEvent(String eventKey) {

    state = state.copyWith(

      settings: state.settings.toggleEvent(eventKey),

      hasChanges: true,

    );

  }



  void toggleDoNotDisturb() {

    state = state.copyWith(

      settings: state.settings.copyWith(

        doNotDisturb: !state.settings.doNotDisturb,

      ),

      hasChanges: true,

    );

  }



  void updateDoNotDisturbStart(TimeOfDay time) {

    state = state.copyWith(

      settings: state.settings.copyWith(doNotDisturbStart: time),

      hasChanges: true,

    );

  }



  void updateDoNotDisturbEnd(TimeOfDay time) {

    state = state.copyWith(

      settings: state.settings.copyWith(doNotDisturbEnd: time),

      hasChanges: true,

    );

  }



  void addEmailRecipient(String email) {

    final emails = List<String>.from(state.settings.emailRecipients)..add(email);

    state = state.copyWith(

      settings: state.settings.copyWith(emailRecipients: emails),

      hasChanges: true,

    );

  }



  void removeEmailRecipient(String email) {

    final emails = List<String>.from(state.settings.emailRecipients)..remove(email);

    state = state.copyWith(

      settings: state.settings.copyWith(emailRecipients: emails),

      hasChanges: true,

    );

  }



  void addSmsRecipient(String phone) {

    final phones = List<String>.from(state.settings.smsRecipients)..add(phone);

    state = state.copyWith(

      settings: state.settings.copyWith(smsRecipients: phones),

      hasChanges: true,

    );

  }



  void removeSmsRecipient(String phone) {

    final phones = List<String>.from(state.settings.smsRecipients)..remove(phone);

    state = state.copyWith(

      settings: state.settings.copyWith(smsRecipients: phones),

      hasChanges: true,

    );

  }



  void updateSettings(NotificationSettingsModel settings) {

    state = state.copyWith(

      settings: settings,

      hasChanges: true,

    );

  }



  Future<void> loadSettings() async {

    setLoading();

    try {

      // API: GET /api/configurations/notifications

      final response = await _repository.getNotificationSettings();

      

      if (response.isSuccess && response.data != null) {

        final data = response.data!;

        setLoaded(NotificationSettingsModel(

          channels: {

            NotificationChannel.email: data['emailEnabled'] ?? true,

            NotificationChannel.sms: false,

            NotificationChannel.push: data['pushEnabled'] ?? true,

          },

          events: {

            'price_alerts': data['priceAlerts'] ?? true,

            'stock_alerts': data['stockAlerts'] ?? true,

            'sync_alerts': data['syncAlerts'] ?? true,

            'error_alerts': data['errorAlerts'] ?? true,

          },

          // ignore: argument_type_not_assignable
          emailRecipients: List<String>.from(data['emailRecipients'] ?? []),

          // ignore: argument_type_not_assignable
          smsRecipients: List<String>.from(data['smsRecipients'] ?? []),

        ));

      } else {

        // Fallback para config padrão

        setLoaded(NotificationSettingsModel(

          channels: const {

            NotificationChannel.email: true,

            NotificationChannel.sms: false,

            NotificationChannel.push: true,

          },

          events: {

            for (var e in NotificationEvent.values) e.key: e.defaultEnabled,

          },

          emailRecipients: ['admin@tagbeans.com', 'gerente@tagbeans.com'],

          smsRecipients: ['+55 (11) 99999-0001'],

        ));

      }

    } catch (e) {

      setError('Erro ao carregar configurações: $e');

    }

  }



  Future<bool> saveSettings() async {

    setSaving();

    try {

      // API: PUT /api/configurations/notifications

      final response = await _repository.saveNotificationSettings(

        emailEnabled: state.settings.channels[NotificationChannel.email] ?? true,

        pushEnabled: state.settings.channels[NotificationChannel.push] ?? true,

        priceAlerts: state.settings.events['price_alerts'] ?? true,

        stockAlerts: state.settings.events['stock_alerts'] ?? true,

        syncAlerts: state.settings.events['sync_alerts'] ?? true,

        errorAlerts: state.settings.events['error_alerts'] ?? true,

      );

      

      if (response.isSuccess) {

        setSaved();

        return true;

      } else {

        setError(response.errorMessage ?? 'Erro ao salvar');

        return false;

      }

    } catch (e) {

      setError('Erro ao salvar configurações: $e');

      return false;

    }

  }



  /// Envia notificação de teste via API

  Future<bool> sendTestNotification() async {

    try {

      final response = await _repository.sendTestNotification();

      return response.isSuccess;

    } catch (e) {

      return false;

    }

  }



  void reset() {

    state = const NotificationSettingsState();

  }

}



/// Provider de configurações de notificação

final notificationSettingsProvider = 

    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettingsState>((ref) {

  final repository = ref.watch(settingsRepositoryProvider);

  return NotificationSettingsNotifier(repository);

});



// =============================================================================

// BACKUP STATE

// =============================================================================



/// Estado da tela de backup

class BackupState {

  final SettingsLoadingStatus status;

  final List<BackupInfoModel> backups;

  final BackupInfoModel? lastBackup;

  final BackupFrequency autoBackupFrequency;

  final bool isBackingUp;

  final double backupProgress;

  final bool isRestoring;

  final String? errorMessage;



  const BackupState({

    this.status = SettingsLoadingStatus.initial,

    this.backups = const [],

    this.lastBackup,

    this.autoBackupFrequency = BackupFrequency.daily,

    this.isBackingUp = false,

    this.backupProgress = 0.0,

    this.isRestoring = false,

    this.errorMessage,

  });



  BackupState copyWith({

    SettingsLoadingStatus? status,

    List<BackupInfoModel>? backups,

    BackupInfoModel? lastBackup,

    BackupFrequency? autoBackupFrequency,

    bool? isBackingUp,

    double? backupProgress,

    bool? isRestoring,

    String? errorMessage,

  }) {

    return BackupState(

      status: status ?? this.status,

      backups: backups ?? this.backups,

      lastBackup: lastBackup ?? this.lastBackup,

      autoBackupFrequency: autoBackupFrequency ?? this.autoBackupFrequency,

      isBackingUp: isBackingUp ?? this.isBackingUp,

      backupProgress: backupProgress ?? this.backupProgress,

      isRestoring: isRestoring ?? this.isRestoring,

      errorMessage: errorMessage ?? this.errorMessage,

    );

  }

}



/// Notifier para backup

class BackupNotifier extends StateNotifier<BackupState> {

  final SettingsRepository _repository;

  

  BackupNotifier(this._repository) : super(const BackupState());



  void setLoading() {

    state = state.copyWith(status: SettingsLoadingStatus.loading);

  }



  void setLoaded({

    List<BackupInfoModel>? backups,

    BackupInfoModel? lastBackup,

  }) {

    state = state.copyWith(

      status: SettingsLoadingStatus.loaded,

      backups: backups ?? state.backups,

      lastBackup: lastBackup ?? state.lastBackup,

    );

  }



  void setError(String message) {

    state = state.copyWith(

      status: SettingsLoadingStatus.error,

      errorMessage: message,

    );

  }



  void setAutoBackupFrequency(BackupFrequency frequency) {

    state = state.copyWith(autoBackupFrequency: frequency);

  }



  Future<void> loadBackups() async {

    setLoading();

    try {

      // API: GET /api/configurations/backups

      final response = await _repository.getBackups();

      

      if (response.isSuccess && response.data != null) {

        final backups = response.data!.map((data) => BackupInfoModel(

          id: data['id']?.toString() ?? '',

          name: (data['name']).toString() ?? '',

          createdAt: DateTime.tryParse((data['createdAt']).toString() ?? '') ?? DateTime.now(),

          size: (data['size']).toString() ?? '0 MB',

          // ignore: argument_type_not_assignable
          isAutomatic: data['isAutomatic'] ?? false,

        )).toList();

        

        setLoaded(

          backups: backups,

          lastBackup: backups.isNotEmpty ? backups.first : null,

        );

      } else {

        setLoaded();

      }

    } catch (e) {

      setError('Erro ao carregar backups: $e');

    }

  }



  Future<bool> createBackup() async {

    state = state.copyWith(isBackingUp: true, backupProgress: 0.0);



    try {

      // API: POST /api/configurations/backups

      state = state.copyWith(backupProgress: 0.3);

      

      final response = await _repository.createBackup(

        description: 'Backup manual - ${DateTime.now().toString().substring(0, 10)}',

      );

      

      state = state.copyWith(backupProgress: 0.8);



      if (response.isSuccess && response.data != null) {

        final data = response.data!;

        final newBackup = BackupInfoModel(

          id: data['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),

          name: (data['name']).toString() ?? 'Backup_${DateTime.now().toString().substring(0, 10)}',

          createdAt: DateTime.tryParse((data['createdAt']).toString() ?? '') ?? DateTime.now(),

          size: (data['size']).toString() ?? '0 MB',

          isAutomatic: false,

        );



        state = state.copyWith(

          isBackingUp: false,

          backupProgress: 1.0,

          lastBackup: newBackup,

          backups: [newBackup, ...state.backups],

        );

        return true;

      } else {

        state = state.copyWith(

          isBackingUp: false,

          errorMessage: response.errorMessage ?? 'Erro ao criar backup',

        );

        return false;

      }

    } catch (e) {

      state = state.copyWith(

        isBackingUp: false,

        errorMessage: 'Erro ao criar backup: $e',

      );

      return false;

    }

  }



  Future<bool> restoreBackup(String backupId) async {

    state = state.copyWith(isRestoring: true);



    try {

      // API: POST /api/configurations/backups/:id/restore

      final response = await _repository.restoreBackup(backupId);

      

      state = state.copyWith(isRestoring: false);

      

      if (response.isSuccess) {

        return true;

      } else {

        state = state.copyWith(

          errorMessage: response.errorMessage ?? 'Erro ao restaurar backup',

        );

        return false;

      }

    } catch (e) {

      state = state.copyWith(

        isRestoring: false,

        errorMessage: 'Erro ao restaurar backup: $e',

      );

      return false;

    }

  }



  Future<bool> deleteBackup(String backupId) async {

    try {

      // API: DELETE /api/configurations/backups/:id

      final response = await _repository.deleteBackup(backupId);

      

      if (response.isSuccess) {

        state = state.copyWith(

          backups: state.backups.where((b) => b.id != backupId).toList(),

        );

        return true;

      } else {

        setError(response.errorMessage ?? 'Erro ao excluir backup');

        return false;

      }

    } catch (e) {

      setError('Erro ao excluir backup: $e');

      return false;

    }

  }



  void reset() {

    state = const BackupState();

  }

}



/// Provider de backup

final backupProvider = 

    StateNotifierProvider<BackupNotifier, BackupState>((ref) {

  final repository = ref.watch(settingsRepositoryProvider);

  return BackupNotifier(repository);

});







