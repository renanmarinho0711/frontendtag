/// Status de transferência de arquivos
enum TransferStatus {
  idle,
  preparing,
  uploading,
  downloading,
  processing,
  completed,
  failed,
  cancelled,
}
