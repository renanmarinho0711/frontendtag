/// Status de carregamento específico para Import/Export
/// Usa 'loaded' em vez de 'success' pois representa dados carregados, não operação concluída
enum ImportExportLoadingStatus {
  initial,
  loading,
  loaded,
  error,
}
