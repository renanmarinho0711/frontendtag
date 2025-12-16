/// Modelos de auditoria Autom�tica para Estrat�gias
/// 
/// Este arquivo cont�m os modelos relacionados � auditoria autom�tica
/// de precifica��o e verifica��o de conformidade.
library;

import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

import '../../../../design_system/theme/theme_colors.dart';
import 'strategy_base_models.dart';

// ============================================================================
// AUTO AUDIT / auditoria AUTOM�TICA MODELS
// ============================================================================

/// Modelo de Verifica��o de auditoria
/// 
/// Representa um tipo de verifica��o que pode ser habilitado/desabilitado
/// na auditoria autom�tica.
class AuditVerificationModel {
  final String id;
  final String nome;
  final bool ativo;
  final IconData icone;

  const AuditVerificationModel({
    required this.id,
    required this.nome,
    required this.ativo,
    required this.icone,
  });

  AuditVerificationModel copyWith({
    String? id,
    String? nome,
    bool? ativo,
    IconData? icone,
  }) {
    return AuditVerificationModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      ativo: ativo ?? this.ativo,
      icone: icone ?? this.icone,
    );
  }

  factory AuditVerificationModel.fromJson(Map<String, dynamic> json) {
    return AuditVerificationModel(
      id: json['id'] as String? ?? '',
      nome: json['nome'] as String? ?? json['name'] as String? ?? '',
      ativo: json['ativo'] as bool? ?? json['active'] as bool? ?? false,
      icone: _parseAuditIcon(json['icone'] ?? json['icon']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'ativo': ativo,
    };
  }

  static IconData _parseAuditIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.check_circle_rounded;
  }
}

/// Modelo de Registro de auditoria
/// 
/// Representa um registro hist�rico de execu��o de auditoria autom�tica.
class AuditRecordModel {
  final String id;
  final String data;
  final int problemas;
  final String status;
  final String corKey; // Semantic color key
  final String detalhes;
  final String duracao;
  final String acoes;

  const AuditRecordModel({
    required this.id,
    required this.data,
    required this.problemas,
    required this.status,
    required this.corKey,
    required this.detalhes,
    required this.duracao,
    required this.acoes,
  });

  AuditRecordModel copyWith({
    String? id,
    String? data,
    int? problemas,
    String? status,
    String? corKey,
    String? detalhes,
    String? duracao,
    String? acoes,
  }) {
    return AuditRecordModel(
      id: id ?? this.id,
      data: data ?? this.data,
      problemas: problemas ?? this.problemas,
      status: status ?? this.status,
      corKey: corKey ?? this.corKey,
      detalhes: detalhes ?? this.detalhes,
      duracao: duracao ?? this.duracao,
      acoes: acoes ?? this.acoes,
    );
  }

  /// Verifica se a auditoria foi conclu�da com sucesso
  bool get isSuccess => status.toLowerCase() == 'conclu�da';

  /// Verifica se requer aten��o
  bool get needsAttention => status.toLowerCase() == 'aten��o';

  /// Verifica se n�o teve problemas
  bool get hasNoProblems => problemas == 0;

  factory AuditRecordModel.fromJson(Map<String, dynamic> json) {
    return AuditRecordModel(
      id: json['id'] as String? ?? '',
      data: json['data'] as String? ?? '',
      problemas: json['problemas'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      corKey: _parseColorKey(json['cor'] ?? json['color']) ?? 'success',
      detalhes: json['detalhes'] as String? ?? json['details'] as String? ?? '',
      duracao: json['duracao'] as String? ?? json['duration'] as String? ?? '',
      acoes: json['acoes'] as String? ?? json['actions'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'problemas': problemas,
      'status': status,
      'detalhes': detalhes,
      'duracao': duracao,
      'acoes': acoes,
    };
  }
}

/// Helper para parsear color key
String _parseColorKey(dynamic value) {
  if (value is String) return value;
  return 'primary'; // Default
}




