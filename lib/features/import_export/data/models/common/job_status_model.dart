/// Status de job da API
class JobStatusModel {
  final String id;
  final String status;
  final double progress;
  final String? currentStep;
  final int? totalSteps;
  final Map<String, dynamic>? result;
  final String? error;

  const JobStatusModel({
    required this.id,
    required this.status,
    this.progress = 0,
    this.currentStep,
    this.totalSteps,
    this.result,
    this.error,
  });

  factory JobStatusModel.fromJson(Map<String, dynamic> json) {
    return JobStatusModel(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      progress: (json['progress'] ?? 0).toDouble(),
      currentStep: json['currentStep'],
      totalSteps: json['totalSteps'],
      result: json['result'] as Map<String, dynamic>?,
      error: json['error'],
    );
  }

  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';
  bool get isRunning => status == 'running' || status == 'processing';

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'progress': progress,
    if (currentStep != null) 'currentStep': currentStep,
    if (totalSteps != null) 'totalSteps': totalSteps,
    if (result != null) 'result': result,
    if (error != null) 'error': error,
  };
}

/// Operação agendada
class ScheduledOperation {
  final String id;
  final String name;
  final String operationType;
  final String dataType;
  final String format;
  final String cronExpression;
  final bool isActive;
  final DateTime? lastRun;
  final DateTime? nextRun;
  final String? templateId;

  const ScheduledOperation({
    required this.id,
    required this.name,
    required this.operationType,
    required this.dataType,
    required this.format,
    required this.cronExpression,
    required this.isActive,
    this.lastRun,
    this.nextRun,
    this.templateId,
  });

  factory ScheduledOperation.fromJson(Map<String, dynamic> json) {
    return ScheduledOperation(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      operationType: json['operationType'] ?? '',
      dataType: json['dataType'] ?? '',
      format: json['format'] ?? '',
      cronExpression: json['cronExpression'] ?? '',
      isActive: json['isActive'] ?? false,
      lastRun: json['lastRun'] != null 
          ? DateTime.tryParse(json['lastRun']) 
          : null,
      nextRun: json['nextRun'] != null 
          ? DateTime.tryParse(json['nextRun']) 
          : null,
      templateId: json['templateId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'operationType': operationType,
    'dataType': dataType,
    'format': format,
    'cronExpression': cronExpression,
    'isActive': isActive,
    if (lastRun != null) 'lastRun': lastRun!.toIso8601String(),
    if (nextRun != null) 'nextRun': nextRun!.toIso8601String(),
    if (templateId != null) 'templateId': templateId,
  };
}
