mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'product_tag_model.dart';

class ProdutoModel {
  final String codigo;
  final String nome;
  final double preco;
  final double? precoKg;
  final String categoria;
  
  /// Tags vinculadas ao produto (N:N)
  /// Um produto pode ter múltiplas tags
  final List<TagBinding> tags;
  
  /// Tag principal (primeira da lista ou a marcada como isPrimary)
  /// Mantido para retrocompatibilidade
  @Deprecated('Usar tags para relacionamento N:N')
  final String? tag;
  
  final String status;
  final String? descricao;
  final String ultimaAtualizacao;
  final Color cor;
  final IconData icone;
  final List<HistoricoPreco>? historicoPrecos;

  ProdutoModel({
    required this.codigo,
    required this.nome,
    required this.preco,
    this.precoKg,
    required this.categoria,
    this.tags = const [],
    this.tag,
    required this.status,
    this.descricao,
    required this.ultimaAtualizacao,
    required this.cor,
    required this.icone,
    this.historicoPrecos,
  });

  /// Retorna a tag principal
  TagBinding? get tagPrincipal {
    if (tags.isEmpty) return null;
    return tags.firstWhere(
      (t) => t.isPrimary,
      orElse: () => tags.first,
    );
  }

  /// Retorna quantas tags estão vinculadas
  int get tagCount => tags.length;

  /// Verifica se o produto tem múltiplas tags
  bool get hasMultipleTags => tags.length > 1;

  /// Copia o produto com alterações
  ProdutoModel copyWith({
    String? codigo,
    String? nome,
    double? preco,
    double? precoKg,
    String? categoria,
    List<TagBinding>? tags,
    String? tag,
    String? status,
    String? descricao,
    String? ultimaAtualizacao,
    Color? cor,
    IconData? icone,
    List<HistoricoPreco>? historicoPrecos,
  }) {
    return ProdutoModel(
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      preco: preco ?? this.preco,
      precoKg: precoKg ?? this.precoKg,
      categoria: categoria ?? this.categoria,
      tags: tags ?? this.tags,
      tag: tag ?? this.tag,
      status: status ?? this.status,
      descricao: descricao ?? this.descricao,
      ultimaAtualizacao: ultimaAtualizacao ?? this.ultimaAtualizacao,
      cor: cor ?? this.cor,
      icone: icone ?? this.icone,
      historicoPrecos: historicoPrecos ?? this.historicoPrecos,
    );
  }

  /// Converte para Map
  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'nome': nome,
      'preco': preco,
      'precoKg': precoKg,
      'categoria': categoria,
      'tags': tags.map((t) => {
        'productTagId': t.productTagId,
        'tagMacAddress': t.tagMacAddress,
        'location': t.location,
        'isPrimary': t.isPrimary,
        'isActive': t.isActive,
      }).toList(),
      'tag': tag,
      'status': status,
      'descricao': descricao,
      'ultimaAtualizacao': ultimaAtualizacao,
      'cor': cor.value,
      'icone': icone.codePoint,
    };
  }

  /// Cria a partir de Map
  factory ProdutoModel.fromMap(Map<String, dynamic> map) {
    List<TagBinding> tagsList = [];
    
    // Tentar ler tags como lista
    if (map['tags'] != null && map['tags'] is List) {
      tagsList = (map['tags'] as List)
          .map((t) => TagBinding.fromJson(t))
          .toList();
    }
    // Fallback: converter tag única para lista
    else if (map['tag'] != null && map['tag'].toString().isNotEmpty) {
      tagsList = [
        TagBinding(
          productTagId: 0,
          tagMacAddress: map['tag'].toString(),
          isPrimary: true,
          isActive: true,
        ),
      ];
    }
    
    return ProdutoModel(
      codigo: map['codigo'] ?? '',
      nome: map['nome'] ?? '',
      preco: map['preco']?.toDouble() ?? 0.0,
      precoKg: map['precoKg']?.toDouble(),
      categoria: map['categoria'] ?? '',
      tags: tagsList,
      tag: map['tag'],
      status: map['status'] ?? 'Ativo',
      descricao: map['descricao'],
      ultimaAtualizacao: map['ultimaAtualizacao'] ?? '',
      cor: Color(map['cor'] ?? 0xFF2196F3),
      icone: IconData(map['icone'] ?? 0xe047, fontFamily: 'MaterialIcons'),
    );
  }
}

class HistoricoPreco {
  final String data;
  final double precoAnterior;
  final double precoNovo;
  final String usuario;

  HistoricoPreco({
    required this.data,
    required this.precoAnterior,
    required this.precoNovo,
    required this.usuario,
  });

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'precoAnterior': precoAnterior,
      'precoNovo': precoNovo,
      'usuario': usuario,
    };
  }

  factory HistoricoPreco.fromMap(Map<String, dynamic> map) {
    return HistoricoPreco(
      data: map['data'] ?? '',
      precoAnterior: map['precoAnterior']?.toDouble() ?? 0.0,
      precoNovo: map['precoNovo']?.toDouble() ?? 0.0,
      usuario: map['usuario'] ?? '',
    );
  }
}

/// Helper para obter cor e ícone por categoria
class CategoriaHelper {
  static Map<String, dynamic> getCategoriaInfo(String categoria) {
    switch (categoria) {
      case 'Bebidas':
        return {
          'cor': AppThemeColors.blueMaterial,
          'icone': Icons.local_drink_rounded,
        };
      case 'Mercearia':
        return {
          'cor': AppThemeColors.brownMain,
          'icone': Icons.shopping_basket_rounded,
        };
      case 'Perecíveis':
        return {
          'cor': AppThemeColors.greenMaterial,
          'icone': Icons.eco_rounded,
        };
      case 'Limpeza':
        return {
          'cor': AppThemeColors.blueCyan,
          'icone': Icons.cleaning_services_rounded,
        };
      case 'Higiene':
        return {
          'cor': AppThemeColors.blueLight,
          'icone': Icons.soap_rounded,
        };
      default:
        return {
          'cor': AppThemeColors.blueMaterial,
          'icone': Icons.inventory_2_rounded,
        };
    }
  }

  static List<String> getCategorias() {
    return ['Bebidas', 'Mercearia', 'Perecíveis', 'Limpeza', 'Higiene'];
  }
}