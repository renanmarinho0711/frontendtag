/// Providers Riverpod para o módulo Import/Export
/// Migração completa para StateNotifierProvider
/// 
/// Estrutura:
/// - States: Estados imutáveis para cada tela
/// - Notifiers: StateNotifier para lógica de negócio
/// - Providers: StateNotifierProvider exportados

library import_export_provider;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/import_export/data/models/import_export_models.dart';
import 'package:tagbean/features/import_export/data/repositories/import_export_repository.dart';

// =============================================================================
// REPOSITORY PROVIDER
// =============================================================================

/// Provider do ImportExportRepository
final importExportRepositoryProvider = Provider<ImportExportRepository>((ref) {
  return ImportExportRepository();
});

// =============================================================================
// IMPORT MENU STATE
// =============================================================================

/// Estado do menu de importação/exportação
class ImportMenuState {
  final ImportExportLoadingStatus status;
  final List<ImportStatsModel> statistics;
  final List<ImportExportMenuOption> menuOptions;
  final String? errorMessage;
  final int hoveredIndex;
  /// Última importação de produtos
  final String? lastProductImport;
  /// Última importação de tags
  final String? lastTagImport;
  /// Última exportação de produtos
  final String? lastProductExport;
  /// Última exportação de tags
  final String? lastTagExport;
  /// Última operação em lote
  final String? lastBatchOperation;

  const ImportMenuState({
    this.status = ImportExportLoadingStatus.initial,
    this.statistics = const [],
    this.menuOptions = const [],
    this.errorMessage,
    this.hoveredIndex = -1,
    this.lastProductImport,
    this.lastTagImport,
    this.lastProductExport,
    this.lastTagExport,
    this.lastBatchOperation,
  });

  ImportMenuState copyWith({
    ImportExportLoadingStatus? status,
    List<ImportStatsModel>? statistics,
    List<ImportExportMenuOption>? menuOptions,
    String? errorMessage,
    int? hoveredIndex,
    String? lastProductImport,
    String? lastTagImport,
    String? lastProductExport,
    String? lastTagExport,
    String? lastBatchOperation,
  }) {
    return ImportMenuState(
      status: status ?? this.status,
      statistics: statistics ?? this.statistics,
      menuOptions: menuOptions ?? this.menuOptions,
      errorMessage: errorMessage ?? this.errorMessage,
      hoveredIndex: hoveredIndex ?? this.hoveredIndex,
      lastProductImport: lastProductImport ?? this.lastProductImport,
      lastTagImport: lastTagImport ?? this.lastTagImport,
      lastProductExport: lastProductExport ?? this.lastProductExport,
      lastTagExport: lastTagExport ?? this.lastTagExport,
      lastBatchOperation: lastBatchOperation ?? this.lastBatchOperation,
    );
  }
}

/// Notifier para menu de importação
class ImportMenuNotifier extends StateNotifier<ImportMenuState> {
  final ImportExportRepository _repository;
  
  ImportMenuNotifier(this._repository) : super(const ImportMenuState());

  void setLoading() {
    state = state.copyWith(status: ImportExportLoadingStatus.loading);
  }

  void setLoaded({
    List<ImportStatsModel>? statistics,
    List<ImportExportMenuOption>? menuOptions,
  }) {
    state = state.copyWith(
      status: ImportExportLoadingStatus.loaded,
      statistics: statistics ?? state.statistics,
      menuOptions: menuOptions ?? state.menuOptions,
    );
  }

  void setError(String message) {
    state = state.copyWith(
      status: ImportExportLoadingStatus.error,
      errorMessage: message,
    );
  }

  void setHoveredIndex(int index) {
    state = state.copyWith(hoveredIndex: index);
  }

  void clearHover() {
    state = state.copyWith(hoveredIndex: -1);
  }

  Future<void> loadStatistics() async {
    setLoading();
    try {
      final response = await _repository.getStatistics();
      if (response.isSuccess && response.data != null) {
        final stats = response.data!;
        state = state.copyWith(
          status: ImportExportLoadingStatus.loaded,
          lastProductImport: stats.lastImportAt?.toIso8601String(),
          lastProductExport: stats.lastExportAt?.toIso8601String(),
        );
      } else {
        setLoaded();
      }
    } catch (e) {
      setError('Erro ao carregar estatísticas: $e');
    }
  }
}

/// Provider do menu de importação
final importMenuProvider = 
    StateNotifierProvider<ImportMenuNotifier, ImportMenuState>((ref) {
  return ImportMenuNotifier(ref.watch(importExportRepositoryProvider));
});

// =============================================================================
// IMPORT PRODUCTS STATE
// =============================================================================

/// Estado de importação de produtos
class ImportProductsState {
  final ImportExportLoadingStatus status;
  final int currentStep;
  final ExportFormat selectedFormat;
  final bool isUploading;
  final double uploadProgress;
  final String? selectedFileName;
  final FileValidationResult? validationResult;
  final ImportResult? importResult;
  final List<ImportHistoryModel> importHistory;
  final ImportConfigModel config;
  final String? errorMessage;

  const ImportProductsState({
    this.status = ImportExportLoadingStatus.initial,
    this.currentStep = 0,
    this.selectedFormat = ExportFormat.excel,
    this.isUploading = false,
    this.uploadProgress = 0.0,
    this.selectedFileName,
    this.validationResult,
    this.importResult,
    this.importHistory = const [],
    this.config = const ImportConfigModel(),
    this.errorMessage,
  });

  ImportProductsState copyWith({
    ImportExportLoadingStatus? status,
    int? currentStep,
    ExportFormat? selectedFormat,
    bool? isUploading,
    double? uploadProgress,
    String? selectedFileName,
    FileValidationResult? validationResult,
    ImportResult? importResult,
    List<ImportHistoryModel>? importHistory,
    ImportConfigModel? config,
    String? errorMessage,
  }) {
    return ImportProductsState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      selectedFormat: selectedFormat ?? this.selectedFormat,
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      selectedFileName: selectedFileName ?? this.selectedFileName,
      validationResult: validationResult ?? this.validationResult,
      importResult: importResult ?? this.importResult,
      importHistory: importHistory ?? this.importHistory,
      config: config ?? this.config,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier para importação de produtos com integração API
class ImportProductsNotifier extends StateNotifier<ImportProductsState> {
  final ImportExportRepository _repository;

  ImportProductsNotifier(this._repository) : super(const ImportProductsState());

  void setLoading() {
    state = state.copyWith(status: ImportExportLoadingStatus.loading);
  }

  void setLoaded({List<ImportHistoryModel>? history}) {
    state = state.copyWith(
      status: ImportExportLoadingStatus.loaded,
      importHistory: history ?? state.importHistory,
    );
  }

  void setError(String message) {
    state = state.copyWith(
      status: ImportExportLoadingStatus.error,
      errorMessage: message,
    );
  }

  void setFormat(ExportFormat format) {
    state = state.copyWith(selectedFormat: format);
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void setFile(String fileName) {
    state = state.copyWith(
      selectedFileName: fileName,
      currentStep: 1,
    );
  }

  void clearFile() {
    state = state.copyWith(
      selectedFileName: null,
      validationResult: null,
      currentStep: 0,
    );
  }

  void setUploading(bool uploading, {double progress = 0.0}) {
    state = state.copyWith(
      isUploading: uploading,
      uploadProgress: progress,
    );
  }

  void startUpload() {
    state = state.copyWith(
      isUploading: true,
      uploadProgress: 0.0,
      currentStep: 1,
    );
  }

  void setUploadProgress(double progress) {
    state = state.copyWith(uploadProgress: progress);
  }

  void completeUpload() {
    state = state.copyWith(
      isUploading: false,
      currentStep: 2,
    );
  }

  void updateProgress(double progress) {
    state = state.copyWith(uploadProgress: progress);
  }

  void setValidationResult(FileValidationResult result) {
    state = state.copyWith(
      validationResult: result,
      currentStep: result.isValid ? 2 : 1,
    );
  }

  void updateConfig(ImportConfigModel config) {
    state = state.copyWith(config: config);
  }

  Future<void> loadHistory() async {
    setLoading();
    try {
      final response = await _repository.getHistory(
        type: 'products',
        operation: 'import',
      );
      if (response.isSuccess) {
        setLoaded(history: response.data ?? []);
      } else {
        setError('Erro ao carregar histórico: ${response.errorMessage}');
      }
    } catch (e) {
      setError('Erro ao carregar histórico: $e');
    }
  }

  Future<void> importProducts(List<Map<String, dynamic>> records) async {
    if (state.selectedFileName == null) return;
    
    state = state.copyWith(isUploading: true, uploadProgress: 0.0);
    
    try {
      // Preview e validação primeiro
      state = state.copyWith(uploadProgress: 0.2);
      
      final validateResponse = await _repository.validateData(
        dataType: 'products',
        records: records,
      );
      
      if (!validateResponse.isSuccess || 
          (validateResponse.data != null && !validateResponse.data!.isValid)) {
        state = state.copyWith(
          isUploading: false,
          errorMessage: 'Dados inválidos: ${validateResponse.data?.errors.map((e) => e.message).join(', ')}',
        );
        return;
      }
      
      state = state.copyWith(uploadProgress: 0.4);
      
      // Executar importação
      final response = await _repository.executeImport(
        dataType: 'products',
        records: records,
        updateExisting: state.config.validateBeforeImport,
        skipErrors: !state.config.stopOnError,
      );
      
      state = state.copyWith(uploadProgress: 0.9);
      
      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          isUploading: false,
          uploadProgress: 1.0,
          currentStep: 2,
        );
        // Recarregar histórico
        await loadHistory();
      } else {
        state = state.copyWith(
          isUploading: false,
          errorMessage: 'Erro na importação: ${response.errorMessage}',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        errorMessage: 'Erro na importação: $e',
      );
    }
  }

  void reset() {
    state = const ImportProductsState();
  }
}

/// Provider de importação de produtos
final importProductsProvider = 
    StateNotifierProvider<ImportProductsNotifier, ImportProductsState>((ref) {
  return ImportProductsNotifier(ref.watch(importExportRepositoryProvider));
});

// =============================================================================
// IMPORT TAGS STATE
// =============================================================================

/// Estado de importação de tags
class ImportTagsState {
  final ImportExportLoadingStatus status;
  final int currentStep;
  final bool isUploading;
  final double uploadProgress;
  final String? selectedFileName;
  final FileValidationResult? validationResult;
  final List<ImportHistoryModel> importHistory;
  final String? errorMessage;

  const ImportTagsState({
    this.status = ImportExportLoadingStatus.initial,
    this.currentStep = 0,
    this.isUploading = false,
    this.uploadProgress = 0.0,
    this.selectedFileName,
    this.validationResult,
    this.importHistory = const [],
    this.errorMessage,
  });

  ImportTagsState copyWith({
    ImportExportLoadingStatus? status,
    int? currentStep,
    bool? isUploading,
    double? uploadProgress,
    String? selectedFileName,
    FileValidationResult? validationResult,
    List<ImportHistoryModel>? importHistory,
    String? errorMessage,
  }) {
    return ImportTagsState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      selectedFileName: selectedFileName ?? this.selectedFileName,
      validationResult: validationResult ?? this.validationResult,
      importHistory: importHistory ?? this.importHistory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier para importação de tags com integração API
class ImportTagsNotifier extends StateNotifier<ImportTagsState> {
  final ImportExportRepository _repository;

  ImportTagsNotifier(this._repository) : super(const ImportTagsState());

  void setLoading() {
    state = state.copyWith(status: ImportExportLoadingStatus.loading);
  }

  void setLoaded({List<ImportHistoryModel>? history}) {
    state = state.copyWith(
      status: ImportExportLoadingStatus.loaded,
      importHistory: history ?? state.importHistory,
    );
  }

  void setError(String message) {
    state = state.copyWith(
      status: ImportExportLoadingStatus.error,
      errorMessage: message,
    );
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void setFile(String fileName) {
    state = state.copyWith(
      selectedFileName: fileName,
      currentStep: 1,
    );
  }

  void clearFile() {
    state = state.copyWith(
      selectedFileName: null,
      validationResult: null,
      currentStep: 0,
    );
  }

  void setUploading(bool uploading, {double progress = 0.0}) {
    state = state.copyWith(
      isUploading: uploading,
      uploadProgress: progress,
    );
  }

  void startUpload() {
    state = state.copyWith(
      isUploading: true,
      uploadProgress: 0.0,
      currentStep: 1,
    );
  }

  void setUploadProgress(double progress) {
    state = state.copyWith(uploadProgress: progress);
  }

  void completeUpload() {
    state = state.copyWith(
      isUploading: false,
      currentStep: 2,
    );
  }

  void updateProgress(double progress) {
    state = state.copyWith(uploadProgress: progress);
  }

  void setValidationResult(FileValidationResult result) {
    state = state.copyWith(
      validationResult: result,
      currentStep: result.isValid ? 2 : 1,
    );
  }

  Future<void> loadHistory() async {
    setLoading();
    try {
      final response = await _repository.getHistory(
        type: 'tags',
        operation: 'import',
      );
      if (response.isSuccess) {
        setLoaded(history: response.data ?? []);
      } else {
        setError('Erro ao carregar histórico: ${response.errorMessage}');
      }
    } catch (e) {
      setError('Erro ao carregar histórico: $e');
    }
  }

  Future<void> importTags(List<Map<String, dynamic>> records, [String? storeId]) async {
    if (state.selectedFileName == null) return;
    
    state = state.copyWith(isUploading: true, uploadProgress: 0.0);
    
    try {
      state = state.copyWith(uploadProgress: 0.3);
      
      // Usar endpoint genérico de importação
      final response = await _repository.executeImport(
        dataType: 'tags',
        records: storeId != null 
            ? records.map((r) => {...r, 'storeId': storeId}).toList()
            : records,
      );
      
      state = state.copyWith(uploadProgress: 0.9);
      
      if (response.isSuccess) {
        state = state.copyWith(
          isUploading: false,
          uploadProgress: 1.0,
          currentStep: 2,
        );
        await loadHistory();
      } else {
        state = state.copyWith(
          isUploading: false,
          errorMessage: 'Erro na importação: ${response.errorMessage}',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        errorMessage: 'Erro na importação: $e',
      );
    }
  }

  void reset() {
    state = const ImportTagsState();
  }
}

/// Provider de importação de tags
final importTagsProvider = 
    StateNotifierProvider<ImportTagsNotifier, ImportTagsState>((ref) {
  return ImportTagsNotifier(ref.watch(importExportRepositoryProvider));
});

// =============================================================================
// EXPORT PRODUCTS STATE
// =============================================================================

/// Estado de exportação de produtos
class ExportProductsState {
  final ImportExportLoadingStatus status;
  final int currentStep;
  final ExportConfigModel config;
  final bool isExporting;
  final double exportProgress;
  final ExportResultModel? result;
  final List<ExportHistoryModel> exportHistory;
  final int totalProducts;
  final String? errorMessage;

  const ExportProductsState({
    this.status = ImportExportLoadingStatus.initial,
    this.currentStep = 0,
    this.config = const ExportConfigModel(),
    this.isExporting = false,
    this.exportProgress = 0.0,
    this.result,
    this.exportHistory = const [],
    this.totalProducts = 0,
    this.errorMessage,
  });

  /// Getter para formato selecionado (usado na tela)
  ExportFormat get selectedFormat => config.format;

  ExportProductsState copyWith({
    ImportExportLoadingStatus? status,
    int? currentStep,
    ExportConfigModel? config,
    bool? isExporting,
    double? exportProgress,
    ExportResultModel? result,
    List<ExportHistoryModel>? exportHistory,
    int? totalProducts,
    String? errorMessage,
  }) {
    return ExportProductsState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      config: config ?? this.config,
      isExporting: isExporting ?? this.isExporting,
      exportProgress: exportProgress ?? this.exportProgress,
      result: result ?? this.result,
      exportHistory: exportHistory ?? this.exportHistory,
      totalProducts: totalProducts ?? this.totalProducts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier para exportação de produtos com integração API
class ExportProductsNotifier extends StateNotifier<ExportProductsState> {
  final ImportExportRepository _repository;

  ExportProductsNotifier(this._repository) : super(const ExportProductsState());

  void setLoading() {
    state = state.copyWith(status: ImportExportLoadingStatus.loading);
  }

  void setLoaded({
    List<ExportHistoryModel>? history,
    int? totalProducts,
  }) {
    state = state.copyWith(
      status: ImportExportLoadingStatus.loaded,
      exportHistory: history ?? state.exportHistory,
      totalProducts: totalProducts ?? state.totalProducts,
    );
  }

  void setError(String message) {
    state = state.copyWith(
      status: ImportExportLoadingStatus.error,
      errorMessage: message,
    );
  }

  void setFormat(ExportFormat format) {
    state = state.copyWith(
      config: state.config.copyWith(format: format),
    );
  }

  void updateConfig(ExportConfigModel config) {
    state = state.copyWith(config: config);
  }

  void toggleIncludeLocation() {
    state = state.copyWith(
      config: state.config.copyWith(
        includeLocation: !state.config.includeLocation,
      ),
    );
  }

  void toggleIncludeProducts() {
    state = state.copyWith(
      config: state.config.copyWith(
        includeProducts: !state.config.includeProducts,
      ),
    );
  }

  void toggleIncludeMetrics() {
    state = state.copyWith(
      config: state.config.copyWith(
        includeMetrics: !state.config.includeMetrics,
      ),
    );
  }

  void toggleIncludeHistory() {
    state = state.copyWith(
      config: state.config.copyWith(
        includeHistory: !state.config.includeHistory,
      ),
    );
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void startExport() {
    state = state.copyWith(
      isExporting: true,
      exportProgress: 0.0,
      currentStep: 1,
    );
  }

  void setExportProgress(double progress) {
    state = state.copyWith(exportProgress: progress);
  }

  void completeExport() {
    state = state.copyWith(
      isExporting: false,
      currentStep: 2,
    );
  }

  Future<void> loadHistory() async {
    setLoading();
    try {
      final response = await _repository.getHistory(
        type: 'products',
        operation: 'export',
      );
      if (response.isSuccess) {
        setLoaded(totalProducts: 0); // Total será carregado separadamente
      } else {
        setError('Erro ao carregar histórico: ${response.errorMessage}');
      }
    } catch (e) {
      setError('Erro ao carregar histórico: $e');
    }
  }

  Future<void> exportProducts() async {
    state = state.copyWith(isExporting: true, exportProgress: 0.0);
    
    try {
      state = state.copyWith(exportProgress: 0.3);
      
      final formatString = state.config.format == ExportFormat.excel 
          ? 'excel' 
          : state.config.format == ExportFormat.csv 
              ? 'csv' 
              : 'json';
      
      final response = await _repository.exportData(
        dataType: 'products',
        format: formatString,
        filters: {
          if (state.config.categoryId != null) 'categoryId': state.config.categoryId,
          'isActive': state.config.onlyActive,
        },
        includeHeaders: true,
      );
      
      state = state.copyWith(exportProgress: 0.8);
      
      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          isExporting: false,
          exportProgress: 1.0,
          result: response.data,
        );
        
        // Se tem downloadUrl, iniciar download
        if (response.data!.downloadUrl != null && response.data!.jobId != null) {
          await _repository.downloadExport(
            jobId: response.data!.jobId!,
            fileName: 'produtos_export.$formatString',
          );
        }
      } else {
        state = state.copyWith(
          isExporting: false,
          errorMessage: 'Erro na exportação: ${response.errorMessage}',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        errorMessage: 'Erro na exportação: $e',
      );
    }
  }

  void reset() {
    state = const ExportProductsState();
  }
}

/// Provider de exportação de produtos
final exportProductsProvider = 
    StateNotifierProvider<ExportProductsNotifier, ExportProductsState>((ref) {
  return ExportProductsNotifier(ref.watch(importExportRepositoryProvider));
});

// =============================================================================
// EXPORT TAGS STATE
// =============================================================================

/// Estado de exportação de tags
class ExportTagsState {
  final ImportExportLoadingStatus status;
  final ExportConfigModel config;
  final bool isExporting;
  final double exportProgress;
  final ExportResultModel? result;
  final int totalTags;
  final String? errorMessage;

  const ExportTagsState({
    this.status = ImportExportLoadingStatus.initial,
    this.config = const ExportConfigModel(),
    this.isExporting = false,
    this.exportProgress = 0.0,
    this.result,
    this.totalTags = 0,
    this.errorMessage,
  });

  int get tagCount {
    switch (config.filterStatus) {
      case FilterStatus.associated:
        return 1127;
      case FilterStatus.available:
        return 121;
      case FilterStatus.offline:
        return 28;
      default:
        return 1248;
    }
  }

  ExportTagsState copyWith({
    ImportExportLoadingStatus? status,
    ExportConfigModel? config,
    bool? isExporting,
    double? exportProgress,
    ExportResultModel? result,
    int? totalTags,
    String? errorMessage,
  }) {
    return ExportTagsState(
      status: status ?? this.status,
      config: config ?? this.config,
      isExporting: isExporting ?? this.isExporting,
      exportProgress: exportProgress ?? this.exportProgress,
      result: result ?? this.result,
      totalTags: totalTags ?? this.totalTags,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier para exportação de tags com integração API
class ExportTagsNotifier extends StateNotifier<ExportTagsState> {
  final ImportExportRepository _repository;

  ExportTagsNotifier(this._repository) : super(const ExportTagsState());

  void setLoading() {
    state = state.copyWith(status: ImportExportLoadingStatus.loading);
  }

  void setLoaded({int? totalTags}) {
    state = state.copyWith(
      status: ImportExportLoadingStatus.loaded,
      totalTags: totalTags ?? state.totalTags,
    );
  }

  void setError(String message) {
    state = state.copyWith(
      status: ImportExportLoadingStatus.error,
      errorMessage: message,
    );
  }

  void setFormat(ExportFormat format) {
    state = state.copyWith(
      config: state.config.copyWith(format: format),
    );
  }

  void setFilter(FilterStatus filterStatus) {
    state = state.copyWith(
      config: state.config.copyWith(filterStatus: filterStatus),
    );
  }

  void setFilterStatus(FilterStatus filterStatus) {
    state = state.copyWith(
      config: state.config.copyWith(filterStatus: filterStatus),
    );
  }

  void updateConfig(ExportConfigModel config) {
    state = state.copyWith(config: config);
  }

  void toggleIncludeLocation() {
    state = state.copyWith(
      config: state.config.copyWith(
        includeLocation: !state.config.includeLocation,
      ),
    );
  }

  void toggleIncludeProducts() {
    state = state.copyWith(
      config: state.config.copyWith(
        includeProducts: !state.config.includeProducts,
      ),
    );
  }

  void toggleIncludeMetrics() {
    state = state.copyWith(
      config: state.config.copyWith(
        includeMetrics: !state.config.includeMetrics,
      ),
    );
  }

  void toggleIncludeHistory() {
    state = state.copyWith(
      config: state.config.copyWith(
        includeHistory: !state.config.includeHistory,
      ),
    );
  }

  Future<void> loadData() async {
    setLoading();
    try {
      // Carrega histórico de exportações de tags
      final response = await _repository.getHistory(
        type: 'tags',
        operation: 'export',
      );
      if (response.isSuccess) {
        setLoaded(totalTags: 0); // Total carregado separadamente via TagsController
      } else {
        setError('Erro ao carregar dados: ${response.errorMessage}');
      }
    } catch (e) {
      setError('Erro ao carregar dados: $e');
    }
  }

  Future<void> exportTags(String storeId) async {
    state = state.copyWith(isExporting: true, exportProgress: 0.0);
    
    try {
      state = state.copyWith(exportProgress: 0.3);
      
      final formatString = state.config.format == ExportFormat.excel 
          ? 'excel' 
          : state.config.format == ExportFormat.csv 
              ? 'csv' 
              : 'json';
      
      final statusFilter = state.config.filterStatus == FilterStatus.associated 
          ? 'bound'
          : state.config.filterStatus == FilterStatus.available 
              ? 'available'
              : state.config.filterStatus == FilterStatus.offline 
                  ? 'offline'
                  : null;
      
      final response = await _repository.exportTags(
        storeId: storeId,
        format: formatString,
        status: statusFilter,
      );
      
      state = state.copyWith(exportProgress: 0.8);
      
      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          isExporting: false,
          exportProgress: 1.0,
          result: response.data,
        );
        
        // Se tem downloadUrl, iniciar download
        if (response.data!.downloadUrl != null && response.data!.jobId != null) {
          await _repository.downloadExport(
            jobId: response.data!.jobId!,
            fileName: 'tags_export.$formatString',
          );
        }
      } else {
        state = state.copyWith(
          isExporting: false,
          errorMessage: 'Erro na exportação: ${response.errorMessage}',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        errorMessage: 'Erro na exportação: $e',
      );
    }
  }

  void reset() {
    state = const ExportTagsState();
  }
}

/// Provider de exportação de tags
final exportTagsProvider = 
    StateNotifierProvider<ExportTagsNotifier, ExportTagsState>((ref) {
  return ExportTagsNotifier(ref.watch(importExportRepositoryProvider));
});

// =============================================================================
// BATCH OPERATIONS STATE
// =============================================================================

/// Estado de operações em lote
class BatchOperationsState {
  final ImportExportLoadingStatus status;
  final List<BatchOperationModel> operations;
  final BatchOperationModel? selectedOperation;
  final bool isProcessing;
  final double processingProgress;
  final String? selectedFileName;
  final FileValidationResult? validationResult;
  final ImportHistoryModel? lastResult;
  final String? errorMessage;

  const BatchOperationsState({
    this.status = ImportExportLoadingStatus.initial,
    this.operations = const [],
    this.selectedOperation,
    this.isProcessing = false,
    this.processingProgress = 0.0,
    this.selectedFileName,
    this.validationResult,
    this.lastResult,
    this.errorMessage,
  });

  BatchOperationsState copyWith({
    ImportExportLoadingStatus? status,
    List<BatchOperationModel>? operations,
    BatchOperationModel? selectedOperation,
    bool? isProcessing,
    double? processingProgress,
    String? selectedFileName,
    FileValidationResult? validationResult,
    ImportHistoryModel? lastResult,
    String? errorMessage,
  }) {
    return BatchOperationsState(
      status: status ?? this.status,
      operations: operations ?? this.operations,
      selectedOperation: selectedOperation ?? this.selectedOperation,
      isProcessing: isProcessing ?? this.isProcessing,
      processingProgress: processingProgress ?? this.processingProgress,
      selectedFileName: selectedFileName ?? this.selectedFileName,
      validationResult: validationResult ?? this.validationResult,
      lastResult: lastResult ?? this.lastResult,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier para operações em lote com integração API
class BatchOperationsNotifier extends StateNotifier<BatchOperationsState> {
  final ImportExportRepository _repository;

  BatchOperationsNotifier(this._repository) : super(const BatchOperationsState());

  void setLoading() {
    state = state.copyWith(status: ImportExportLoadingStatus.loading);
  }

  void setLoaded({List<BatchOperationModel>? operations}) {
    state = state.copyWith(
      status: ImportExportLoadingStatus.loaded,
      operations: operations ?? state.operations,
    );
  }

  void setError(String message) {
    state = state.copyWith(
      status: ImportExportLoadingStatus.error,
      errorMessage: message,
    );
  }

  void selectOperation(BatchOperationModel operation) {
    state = state.copyWith(selectedOperation: operation);
  }

  void clearSelection() {
    state = state.copyWith(
      selectedOperation: null,
      selectedFileName: null,
      validationResult: null,
    );
  }

  void setFile(String fileName) {
    state = state.copyWith(selectedFileName: fileName);
  }

  void clearFile() {
    state = state.copyWith(
      selectedFileName: null,
      validationResult: null,
    );
  }

  void setValidationResult(FileValidationResult result) {
    state = state.copyWith(validationResult: result);
  }

  Future<void> loadOperations() async {
    setLoading();
    try {
      // Carrega templates disponíveis para operações em lote
      final productsTemplate = await _repository.getTemplate('products');
      final tagsTemplate = await _repository.getTemplate('tags');
      
      // Construir lista de operações disponíveis
      final operations = <BatchOperationModel>[];
      if (productsTemplate.isSuccess) {
        operations.add(BatchOperationModel.simple(
          id: 'products-update',
          name: 'Atualização de Produtos',
          description: 'Atualizar preços, estoque e informações em lote',
          type: 'update_prices',
        ));
      }
      if (tagsTemplate.isSuccess) {
        operations.add(BatchOperationModel.simple(
          id: 'tags-update',
          name: 'Atualização de Tags',
          description: 'Atualizar informações de tags ESL em lote',
          type: 'associate_tags',
        ));
      }
      
      setLoaded(operations: operations);
    } catch (e) {
      setError('Erro ao carregar operações: $e');
    }
  }

  Future<void> executeOperation(List<String> ids, {Map<String, dynamic>? updateData}) async {
    if (state.selectedOperation == null) {
      return;
    }

    state = state.copyWith(isProcessing: true, processingProgress: 0.0);
    
    try {
      state = state.copyWith(processingProgress: 0.3);
      
      final response = await _repository.executeBulkOperation(
        operation: 'update',
        dataType: state.selectedOperation!.type.id,
        ids: ids,
        updateData: updateData,
      );
      
      state = state.copyWith(processingProgress: 0.9);
      
      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          isProcessing: false,
          processingProgress: 1.0,
          lastResult: ImportHistoryModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            fileName: state.selectedFileName ?? 'bulk_operation',
            dateTime: DateTime.now(),
            totalRecords: response.data!.totalRequested,
            successCount: response.data!.succeeded,
            errorCount: response.data!.failed,
            duration: '${(response.data!.totalProcessed / 100).ceil()}s',
            status: response.data!.success ? ImportStatus.completed : ImportStatus.completedWithErrors,
          ),
        );
      } else {
        state = state.copyWith(
          isProcessing: false,
          errorMessage: 'Erro na operação: ${response.errorMessage}',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Erro na operação: $e',
      );
    }
  }

  Future<void> downloadTemplate(BatchOperationModel operation) async {
    try {
      final response = await _repository.getTemplate(operation.type.id);
      if (response.isSuccess && response.data != null) {
        // Template obtido, pode processar sampleData para download
        // O download será tratado pela UI
      }
    } catch (e) {
      setError('Erro ao baixar template: $e');
    }
  }

  void reset() {
    state = const BatchOperationsState();
  }
}

/// Provider de operações em lote
final batchOperationsProvider = 
    StateNotifierProvider<BatchOperationsNotifier, BatchOperationsState>((ref) {
  return BatchOperationsNotifier(ref.watch(importExportRepositoryProvider));
});

// =============================================================================
// TRANSFER PROGRESS STATE (compartilhado)
// =============================================================================

/// Estado de progresso de transferência
class TransferProgressState {
  final TransferProgressModel progress;
  final bool isActive;

  const TransferProgressState({
    this.progress = const TransferProgressModel(),
    this.isActive = false,
  });

  TransferProgressState copyWith({
    TransferProgressModel? progress,
    bool? isActive,
  }) {
    return TransferProgressState(
      progress: progress ?? this.progress,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Notifier para progresso de transferência
class TransferProgressNotifier extends StateNotifier<TransferProgressState> {
  TransferProgressNotifier() : super(const TransferProgressState());

  void startTransfer(String fileName, TransferStatus status) {
    state = TransferProgressState(
      progress: TransferProgressModel(
        fileName: fileName,
        status: status,
        progress: 0.0,
      ),
      isActive: true,
    );
  }

  void updateProgress(double progress) {
    state = state.copyWith(
      progress: state.progress.copyWith(progress: progress),
    );
  }

  void completeTransfer() {
    state = state.copyWith(
      progress: state.progress.copyWith(
        progress: 1.0,
        status: TransferStatus.completed,
      ),
      isActive: false,
    );
  }

  void failTransfer(String errorMessage) {
    state = state.copyWith(
      progress: state.progress.copyWith(
        status: TransferStatus.failed,
        errorMessage: errorMessage,
      ),
      isActive: false,
    );
  }

  void cancelTransfer() {
    state = state.copyWith(
      progress: state.progress.copyWith(
        status: TransferStatus.cancelled,
      ),
      isActive: false,
    );
  }

  void reset() {
    state = const TransferProgressState();
  }
}

/// Provider de progresso de transferência
final transferProgressProvider = 
    StateNotifierProvider<TransferProgressNotifier, TransferProgressState>((ref) {
  return TransferProgressNotifier();
});

// =============================================================================
// IMPORT HISTORY PROVIDER
// =============================================================================

/// Provider para histórico de importação/exportação
/// Carrega histórico do backend para exibição no menu
final importHistoryProvider = FutureProvider<List<ImportHistoryModel>>((ref) async {
  final repository = ref.watch(importExportRepositoryProvider);
  try {
    final response = await repository.getImportHistory();
    if (response.isSuccess && response.data != null) {
      return response.data!;
    }
    return [];
  } catch (e) {
    return [];
  }
});



