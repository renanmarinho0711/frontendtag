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
      id: (((json['id'] ?? '') as String?) ?? ''),
      status: (((json['status'] ?? '') as String?) ?? ''),
      progress: ((json['progress'] ?? 0) as num?)?.toDouble() ?? 0.0,
      currentStep: (json['currentStep'] as String?),
      totalSteps: (json['totalSteps'] as int?),
      result: (json['result'] as Map<String, dynamic>?),
      error: (json['error'] as String?),
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
      id: (((json['id'] ?? '') as String?) ?? ''),
      name: (((json['name'] ?? '') as String?) ?? ''),
      operationType: (((json['operationType'] ?? '') as String?) ?? ''),
      dataType: (((json['dataType'] ?? '') as String?) ?? ''),
      format: (((json['format'] ?? '') as String?) ?? ''),
      cronExpression: (((json['cronExpression'] ?? '') as String?) ?? ''),
      isActive: (((json['isActive'] ?? false) as bool?) ?? false),
      lastRun: (json['lastRun'] as String?) != null
          ? DateTime.tryParse(json['lastRun'] as String)
          : null,
      nextRun: (json['nextRun'] as String?) != null
          ? DateTime.tryParse(json['nextRun'] as String)
          : null,
      templateId: (json['templateId'] as String?),
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
