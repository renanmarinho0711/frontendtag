// Enum para status de carregamento de dados
/// 
/// Usado por todos os providers/notifiers do sistema para
/// representar o estado de operações assíncronas.
enum LoadingStatus {
  /// Estado inicial - nenhuma operação realizada
  initial,
  
  /// Carregando dados
  loading,
  
  /// Operação concluída com sucesso
  success,
  
  /// Operação falhou com erro
  error,
}



