import '../enums/transfer_status.dart';

/// Progresso de upload/download
class TransferProgressModel {
  final double progress;
  final int bytesTransferred;
  final int totalBytes;
  final String? fileName;
  final TransferStatus status;
  final String? errorMessage;

  const TransferProgressModel({
    this.progress = 0.0,
    this.bytesTransferred = 0,
    this.totalBytes = 0,
    this.fileName,
    this.status = TransferStatus.idle,
    this.errorMessage,
  });

  double get progressPercentage => progress * 100;
  
  String get formattedProgress => '${progressPercentage.toStringAsFixed(1)}%';

  TransferProgressModel copyWith({
    double? progress,
    int? bytesTransferred,
    int? totalBytes,
    String? fileName,
    TransferStatus? status,
    String? errorMessage,
  }) {
    return TransferProgressModel(
      progress: progress ?? this.progress,
      bytesTransferred: bytesTransferred ?? this.bytesTransferred,
      totalBytes: totalBytes ?? this.totalBytes,
      fileName: fileName ?? this.fileName,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory TransferProgressModel.fromJson(Map<String, dynamic> json) {
    return TransferProgressModel(
      progress: (json['progress'] as double ?? 0).toDouble(),
      bytesTransferred: json['bytesTransferred'] as int ?? 0,
      totalBytes: json['totalBytes'] as int ?? 0,
      fileName: (json['fileName']).toString(),
      status: TransferStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => TransferStatus.idle,
      ),
      errorMessage: (json['errorMessage']).toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'progress': progress,
    'bytesTransferred': bytesTransferred,
    'totalBytes': totalBytes,
    if (fileName != null) 'fileName': fileName,
    'status': status.name,
    if (errorMessage != null) 'errorMessage': errorMessage,
  };
}
