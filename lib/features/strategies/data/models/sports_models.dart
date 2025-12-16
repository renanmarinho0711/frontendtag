import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/models/strategy_base_models.dart';

// ============================================================================
// SPORTS EVENT MODELS
// ============================================================================

/// Modelo de Evento Esportivo
class SportsEventModel {
  final String id;
  final String name;
  final String emoji;
  final String date;
  final bool isActive;
  final double adjustment;
  final String type;
  final List<String> categories;
  final IconData icon;
  final String colorKey; // Semantic color key
  final String description;
  final int expectedAudience;

  const SportsEventModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.date,
    required this.isActive,
    required this.adjustment,
    required this.type,
    required this.categories,
    required this.icon,
    required this.colorKey,
    required this.description,
    required this.expectedAudience,
  });

  SportsEventModel copyWith({
    String? id,
    String? name,
    String? emoji,
    String? date,
    bool? isActive,
    double? adjustment,
    String? type,
    List<String>? categories,
    IconData? icon,
    String? colorKey,
    String? description,
    int? expectedAudience,
  }) {
    return SportsEventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      date: date ?? this.date,
      isActive: isActive ?? this.isActive,
      adjustment: adjustment ?? this.adjustment,
      type: type ?? this.type,
      categories: categories ?? this.categories,
      icon: icon ?? this.icon,
      colorKey: colorKey ?? this.colorKey,
      description: description ?? this.description,
      expectedAudience: expectedAudience ?? this.expectedAudience,
    );
  }

  String get adjustmentFormatted {
    if (adjustment > 0) return '+${adjustment.toStringAsFixed(0)}%';
    if (adjustment < 0) return '${adjustment.toStringAsFixed(0)}%';
    return '0%';
  }

  factory SportsEventModel.fromJson(Map<String, dynamic> json) {
    return SportsEventModel(
      id: json['id'] as String? ?? '',
      name: json['nome'] as String? ?? json['name'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '?',
      date: json['data'] as String? ?? json['date'] as String? ?? '',
      isActive: json['ativo'] as bool? ?? json['isActive'] as bool? ?? false,
      adjustment: (json['ajuste'] as num?)?.toDouble() ?? (json['adjustment'] as num?)?.toDouble() ?? 0.0,
      type: json['tipo'] as String? ?? json['type'] as String? ?? '',
      categories: (json['categorias'] as List<dynamic>?)?.cast<String>() ?? 
                  (json['categories'] as List<dynamic>?)?.cast<String>() ?? [],
      icon: _parseIcon(json['icone'] ?? json['icon']),
      colorKey: _parseColorKey(json['cor'] ?? json['color']) ?? 'blueMain',
      description: json['descricao'] as String? ?? json['description'] as String? ?? '',
      expectedAudience: json['publicoEsperado'] as int? ?? json['expectedAudience'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'date': date,
      'isActive': isActive,
      'adjustment': adjustment,
      'type': type,
      'categories': categories,
      'description': description,
      'expectedAudience': expectedAudience,
    };
  }

  static IconData _parseIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.sports_soccer_rounded;
  }
}

/// Helper para parsear color key
String _parseColorKey(dynamic value) {
  if (value is String) return value;
  return 'primary'; // Default
}

/// Modelo de Time Esportivo
/// 
/// Representa um time/equipe monitorado para ajuste de pre?os em dias de jogos.
class SportsTeamModel {
  final String id;
  final String name;
  final bool isActive;
  final double adjustment;
  final List<String> products;
  final IconData icon;
  final Color color;
  final String badge;
  final String nextGame;

  const SportsTeamModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.adjustment,
    required this.products,
    required this.icon,
    required this.color,
    required this.badge,
    required this.nextGame,
  });

  SportsTeamModel copyWith({
    String? id,
    String? name,
    bool? isActive,
    double? adjustment,
    List<String>? products,
    IconData? icon,
    Color? color,
    String? badge,
    String? nextGame,
  }) {
    return SportsTeamModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      adjustment: adjustment ?? this.adjustment,
      products: products ?? this.products,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      badge: badge ?? this.badge,
      nextGame: nextGame ?? this.nextGame,
    );
  }

  String get adjustmentFormatted {
    if (adjustment > 0) return '+${adjustment.toStringAsFixed(0)}%';
    if (adjustment < 0) return '${adjustment.toStringAsFixed(0)}%';
    return '0%';
  }

  factory SportsTeamModel.fromJson(Map<String, dynamic> json) {
    return SportsTeamModel(
      id: json['id'] as String? ?? '',
      name: json['nome'] as String? ?? json['name'] as String? ?? '',
      isActive: json['ativo'] as bool? ?? json['isActive'] as bool? ?? false,
      adjustment: (json['ajuste'] as num?)?.toDouble() ?? (json['adjustment'] as num?)?.toDouble() ?? 0.0,
      products: (json['produtos'] as List<dynamic>?)?.cast<String>() ?? 
                (json['products'] as List<dynamic>?)?.cast<String>() ?? [],
      icon: _parseTeamIcon(json['icone'] ?? json['icon']),
      color: StrategyModel.parseColor(json['cor'] ?? json['color']) ?? const Color(0xFF2196F3),
      badge: json['escudo'] as String? ?? json['badge'] as String? ?? '?',
      nextGame: json['proxJogo'] as String? ?? json['nextGame'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
      'adjustment': adjustment,
      'products': products,
      'badge': badge,
      'nextGame': nextGame,
    };
  }

  static IconData _parseTeamIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.sports_soccer_rounded;
  }
}

/// Modelo de Jogo/Partida
/// 
/// Representa um jogo agendado de um time monitorado.
class SportsGameModel {
  final String id;
  final String team;
  final String opponent;
  final String date;
  final String time;
  final String championship;
  final String location;

  const SportsGameModel({
    required this.id,
    required this.team,
    required this.opponent,
    required this.date,
    required this.time,
    required this.championship,
    required this.location,
  });

  SportsGameModel copyWith({
    String? id,
    String? team,
    String? opponent,
    String? date,
    String? time,
    String? championship,
    String? location,
  }) {
    return SportsGameModel(
      id: id ?? this.id,
      team: team ?? this.team,
      opponent: opponent ?? this.opponent,
      date: date ?? this.date,
      time: time ?? this.time,
      championship: championship ?? this.championship,
      location: location ?? this.location,
    );
  }

  /// T?tulo formatado do jogo
  String get matchTitle => '$team vs $opponent';

  /// Data e hora formatados
  String get dateTimeFormatted => '$date ?s $time';

  factory SportsGameModel.fromJson(Map<String, dynamic> json) {
    return SportsGameModel(
      id: json['id'] as String? ?? '',
      team: json['time'] as String? ?? json['team'] as String? ?? '',
      opponent: json['adversario'] as String? ?? json['opponent'] as String? ?? '',
      date: json['data'] as String? ?? json['date'] as String? ?? '',
      time: json['horario'] as String? ?? json['time'] as String? ?? '',
      championship: json['campeonato'] as String? ?? json['championship'] as String? ?? '',
      location: json['local'] as String? ?? json['location'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team': team,
      'opponent': opponent,
      'date': date,
      'time': time,
      'championship': championship,
      'location': location,
    };
  }
}






