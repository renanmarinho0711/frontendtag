import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tagbean/features/settings/data/repositories/backup_repository.dart';

import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';



export 'package:tagbean/features/settings/data/repositories/backup_repository.dart' 

    show BackupModel;



/// Provider para o repository de backup

final backupRepositoryProvider = Provider<BackupRepository>((ref) {

  return BackupRepository();

});



/// Estado do módulo de backup

class BackupState {

  final List<BackupModel> backups;

  final BackupConfigModel config;

  final int totalBackups;

  final int totalSizeBytes;

  final String totalSizeFormatted;

  final bool isLoading;

  final bool isCreating;

  final bool isRestoring;

  final String? errorMessage;

  final String? successMessage;



  const BackupState({

    this.backups = const [],

    this.config = const BackupConfigModel(),

    this.totalBackups = 0,

    this.totalSizeBytes = 0,

    this.totalSizeFormatted = '0 B',

    this.isLoading = false,

    this.isCreating = false,

    this.isRestoring = false,

    this.errorMessage,

    this.successMessage,

  });



  BackupState copyWith({

    List<BackupModel>? backups,

    BackupConfigModel? config,

    int? totalBackups,

    int? totalSizeBytes,

    String? totalSizeFormatted,

    bool? isLoading,

    bool? isCreating,

    bool? isRestoring,

    String? errorMessage,

    String? successMessage,

  }) {

    return BackupState(

      backups: backups ?? this.backups,

      config: config ?? this.config,

      totalBackups: totalBackups ?? this.totalBackups,

      totalSizeBytes: totalSizeBytes ?? this.totalSizeBytes,

      totalSizeFormatted: totalSizeFormatted ?? this.totalSizeFormatted,

      isLoading: isLoading ?? this.isLoading,

      isCreating: isCreating ?? this.isCreating,

      isRestoring: isRestoring ?? this.isRestoring,

      errorMessage: errorMessage,

      successMessage: successMessage,

    );

  }



  /// Último backup realizado (se houver)

  BackupModel? get lastBackup {

    if (backups.isEmpty) return null;

    return backups.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);

  }



  /// Verifica se tem backups

  bool get hasBackups => backups.isNotEmpty;

}



/// Valor padrão para BackupConfigModel

class BackupConfigModel {

  final bool autoBackupEnabled;

  final String backupFrequency;

  final int backupHour;

  final int maxBackupsToKeep;

  final bool includeImages;

  final bool includeLogs;

  final bool notifyOnSuccess;

  final bool notifyOnFailure;

  final DateTime? lastBackupAt;

  final String? lastBackupStatus;



  const BackupConfigModel({

    this.autoBackupEnabled = true,

    this.backupFrequency = 'daily',

    this.backupHour = 3,

    this.maxBackupsToKeep = 30,

    this.includeImages = true,

    this.includeLogs = false,

    this.notifyOnSuccess = false,

    this.notifyOnFailure = true,

    this.lastBackupAt,

    this.lastBackupStatus,

  });

}



/// Notifier para gerenciamento de backup

class BackupNotifier extends StateNotifier<BackupState> {

  final BackupRepository _repository;

  final Ref _ref;



  BackupNotifier(this._repository, this._ref) : super(const BackupState());



  /// Obtém o storeId atual

  String get _currentStoreId {

    final currentStore = _ref.read(currentStoreProvider);

    return currentStore?.id ?? 'store-not-configured';

  }



  /// Carrega a lista de backups e configuração

  Future<void> loadBackups({int page = 1, int pageSize = 20}) async {

    state = state.copyWith(isLoading: true, errorMessage: null);



    try {

      final response = await _repository.getBackups(

        storeId: _currentStoreId,

        page: page,

        pageSize: pageSize,

      );



      if (response.isSuccess && response.data != null) {

        final data = response.data!;

        state = state.copyWith(

          backups: data.backups,

          config: _mapConfig(data.config),

          totalBackups: data.total,

          totalSizeBytes: data.totalSizeBytes,

          totalSizeFormatted: data.totalSizeFormatted,

          isLoading: false,

        );

      } else {

        state = state.copyWith(

          isLoading: false,

          errorMessage: response.message ?? 'Erro ao carregar backups',

        );

      }

    } catch (e) {

      state = state.copyWith(

        isLoading: false,

        errorMessage: 'Erro ao carregar backups: $e',

      );

    }

  }



  /// Cria um novo backup

  Future<bool> createBackup({

    String? name,

    String? description,

    bool includeImages = true,

    bool includeLogs = false,

  }) async {

    state = state.copyWith(isCreating: true, errorMessage: null, successMessage: null);



    try {

      final response = await _repository.createBackup(

        storeId: _currentStoreId,

        name: name,

        description: description,

        includeImages: includeImages,

        includeLogs: includeLogs,

      );



      if (response.isSuccess && response.data != null) {

        // Adicionar novo backup à lista

        state = state.copyWith(

          backups: [response.data!, ...state.backups],

          totalBackups: state.totalBackups + 1,

          isCreating: false,

          successMessage: 'Backup criado com sucesso!',
 // ignore: argument_type_not_assignable

        // ignore: argument_type_not_assignable
        );
 // ignore: argument_type_not_assignable

        // ignore: argument_type_not_assignable
        return true;
 // ignore: argument_type_not_assignable

      // ignore: argument_type_not_assignable
      } else {
 // ignore: argument_type_not_assignable

        // ignore: argument_type_not_assignable
        state = state.copyWith(
 // ignore: argument_type_not_assignable

          // ignore: argument_type_not_assignable
          isCreating: false,

          errorMessage: response.message ?? 'Erro ao criar backup',

        );

        return false;

      }

    } catch (e) {

      state = state.copyWith(

        isCreating: false,

        errorMessage: 'Erro ao criar backup: $e',

      );

      return false;

    }

  }



  /// Restaura um backup

  Future<bool> restoreBackup(String backupId) async {

    state = state.copyWith(isRestoring: true, errorMessage: null, successMessage: null);



    try {

      final response = await _repository.restoreBackup(

        backupId: backupId,

        storeId: _currentStoreId,

      );



      if (response.isSuccess && response.data != null) {

        final result = response.data!;

        state = state.copyWith(

          isRestoring: false,

          successMessage: result.message,

        );

        return result.success;

      } else {

        state = state.copyWith(

          isRestoring: false,

          errorMessage: response.message ?? 'Erro ao restaurar backup',

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



  /// Exclui um backup

  Future<bool> deleteBackup(String backupId) async {

    try {

      final response = await _repository.deleteBackup(

        backupId: backupId,

        storeId: _currentStoreId,

      );



      if (response.isSuccess) {

        // Remover backup da lista

        state = state.copyWith(

          backups: state.backups.where((b) => b.id != backupId).toList(),

          totalBackups: state.totalBackups - 1,

          successMessage: 'Backup excluído com sucesso!',

        );

        return true;

      } else {

        state = state.copyWith(

          errorMessage: response.message ?? 'Erro ao excluir backup',

        );

        return false;

      }

    } catch (e) {

      state = state.copyWith(

        errorMessage: 'Erro ao excluir backup: $e',

      );

      return false;

    }

  }



  /// Atualiza a configuração de backup

  Future<bool> updateConfig({

    bool? autoBackupEnabled,

    String? backupFrequency,

    int? backupHour,

    int? maxBackupsToKeep,

    bool? includeImages,

    bool? includeLogs,

    bool? notifyOnSuccess,

    bool? notifyOnFailure,

  }) async {

    try {

      final response = await _repository.updateBackupConfig(

        storeId: _currentStoreId,

        autoBackupEnabled: autoBackupEnabled,

        backupFrequency: backupFrequency,

        backupHour: backupHour,

        maxBackupsToKeep: maxBackupsToKeep,

        includeImages: includeImages,

        includeLogs: includeLogs,

        notifyOnSuccess: notifyOnSuccess,

        notifyOnFailure: notifyOnFailure,

      );



      if (response.isSuccess && response.data != null) {

        state = state.copyWith(

          config: _mapConfig(response.data!),

          successMessage: 'Configuração atualizada!',

        );

        return true;

      } else {

        state = state.copyWith(

          errorMessage: response.message ?? 'Erro ao atualizar configuração',

        );

        return false;

      }

    } catch (e) {

      state = state.copyWith(

        errorMessage: 'Erro ao atualizar configuração: $e',

      );

      return false;

    }

  }



  /// Executa limpeza de backups antigos

  Future<int> cleanupOldBackups() async {

    try {

      final response = await _repository.cleanupOldBackups(

        storeId: _currentStoreId,

      );



      if (response.isSuccess && response.data != null) {

        final deletedCount = response.data!['deletedCount'] as int? ?? 0;

        if (deletedCount > 0) {

          // Recarregar lista

          await loadBackups();

          state = state.copyWith(

            successMessage: '$deletedCount backup(s) antigo(s) removido(s)!',

          );

        }

        return deletedCount;

      }

      return 0;

    } catch (e) {

      state = state.copyWith(

        errorMessage: 'Erro na limpeza: $e',

      );

      return 0;

    }

  }



  /// Obtém URL de download de um backup

  String getDownloadUrl(String backupId) {

    return _repository.getBackupDownloadUrl(

      backupId: backupId,

      storeId: _currentStoreId,

    );

  }



  /// Limpa mensagens de erro/sucesso

  void clearMessages() {

    state = state.copyWith(errorMessage: null, successMessage: null);

  }



  /// Converte BackupConfigModel do repository para o do provider

  BackupConfigModel _mapConfig(dynamic repoConfig) {

    if (repoConfig is BackupConfigModel) {

      return repoConfig;

    }

    // Se vier do repository como outro tipo

    final config = repoConfig as dynamic;

    return BackupConfigModel(

      autoBackupEnabled: config.autoBackupEnabled ?? true,

      backupFrequency: config.backupFrequency ?? 'daily',

      backupHour: config.backupHour ?? 3,

      maxBackupsToKeep: config.maxBackupsToKeep ?? 30,

      includeImages: config.includeImages ?? true,

      includeLogs: config.includeLogs ?? false,

      notifyOnSuccess: config.notifyOnSuccess ?? false,

      notifyOnFailure: config.notifyOnFailure ?? true,

      lastBackupAt: config.lastBackupAt,

      lastBackupStatus: config.lastBackupStatus,

    );

  }

}



/// Provider do notifier de backup

final backupNotifierProvider = StateNotifierProvider<BackupNotifier, BackupState>((ref) {

  final repository = ref.watch(backupRepositoryProvider);

  return BackupNotifier(repository, ref);

});



/// Provider para obter a lista de backups

final backupsListProvider = Provider<List<BackupModel>>((ref) {

  return ref.watch(backupNotifierProvider).backups;

});



/// Provider para obter a configuração de backup

final backupConfigProvider = Provider<BackupConfigModel>((ref) {

  return ref.watch(backupNotifierProvider).config;

});



/// Provider para verificar se está carregando

final isBackupLoadingProvider = Provider<bool>((ref) {

  return ref.watch(backupNotifierProvider).isLoading;

});



/// Provider para verificar se está criando backup

final isCreatingBackupProvider = Provider<bool>((ref) {

  return ref.watch(backupNotifierProvider).isCreating;

});







