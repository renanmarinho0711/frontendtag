import 'package:flutter/material.dart';

/// Cores do aplicativo TagBean
abstract class AppColors {
  // Cores Primárias
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  
  // Cores Secundárias
  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF059669);
  
  // Cores de Acento
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentDark = Color(0xFFD97706);
  
  // Cores Neutras
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  
  /// ## Grey 600
  /// 
  /// **Onde usar:**
  /// - Texto de corpo secundário
  /// - Subtítulos em modo escuro
  /// - Headers de tabelas
  static const Color grey600 = Color(0xFF4B5563);
  
  /// ## Grey 700
  /// 
  /// **Onde usar:**
  /// - Texto principal em modo claro
  /// - Títulos e headers principais
  /// - Valores em formulários
  /// 
  /// **Exemplo:**
  /// ```
  /// ┌─────────────────────────────────┐
  /// │  Título Principal               │ ← grey700 (modo claro)
  /// │  Subtítulo ou descrição         │ ← grey500
  /// │                                 │
  /// │  Campo: Valor digitado          │ ← Label: grey500, Valor: grey700
  /// └─────────────────────────────────┘
  /// ```
  static const Color grey700 = Color(0xFF374151);
  
  /// ## Grey 800
  /// 
  /// **Onde usar:**
  /// - Background de cards no modo escuro
  /// - AppBar no modo escuro
  /// - Texto de alta ênfase no modo escuro
  static const Color grey800 = Color(0xFF1F2937);
  
  /// ## Grey 900
  /// 
  /// **Onde usar:**
  /// - Background principal no modo escuro
  /// - Texto sobre white
  /// - Ícones de máximo contraste
  /// 
  /// **Exemplo:**
  /// ```
  /// ┌─────────────────────────────────┐ ← Scaffold bg: grey900
  /// │  ┌───────────────────────────┐  │
  /// │  │  Card (grey800)           │  │ ← Card bg: grey800
  /// │  │  Texto (grey100)          │  │ ← Texto: grey100
  /// │  └───────────────────────────┘  │
  /// └─────────────────────────────────┘
  /// ```
  static const Color grey900 = Color(0xFF111827);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CORES SEMÂNTICAS (FEEDBACK)
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// ## Success - Verde Sucesso
  /// 
  /// **Onde usar:**
  /// - Mensagens de sucesso
  /// - Ícone de check/confirmação
  /// - Border de campos válidos
  /// - Status de operação bem-sucedida
  /// - Toast/Snackbar de sucesso
  /// 
  /// **Exemplo:**
  /// ```
  /// ┌─────────────────────────────────┐
  /// │  ✓ Operação realizada com       │ ← success
  /// │    sucesso!                     │   
  /// └─────────────────────────────────┘
  /// 
  /// ┌─────────────────────────────────┐
  /// │  Email válido ✓                 │ ← Border: success
  /// └─────────────────────────────────┘
  /// ```
  static const Color success = Color(0xFF22C55E);
  
  /// ## Success Light
  /// 
  /// **Onde usar:**
  /// - Background de alertas de sucesso
  /// - Container de mensagens positivas
  /// - Background de badges de sucesso
  static const Color successLight = Color(0xFFDCFCE7);
  
  /// ## Warning - Amarelo Aviso
  /// 
  /// **Onde usar:**
  /// - Alertas de atenção
  /// - Ícones de aviso
  /// - Estados de validação parcial
  /// - Indicadores de ação necessária
  /// 
  /// **Exemplo:**
  /// ```
  /// ┌─────────────────────────────────┐
  /// │  ⚠️ Atenção: Ação irreversível  │ ← warning
  /// └─────────────────────────────────┘
  /// ```
  static const Color warning = Color(0xFFF59E0B);
  
  /// ## Warning Light
  /// 
  /// **Onde usar:**
  /// - Background de alertas de aviso
  /// - Container de mensagens de atenção
  static const Color warningLight = Color(0xFFFEF3C7);
  
  /// ## Error - Vermelho Erro
  /// 
  /// **Onde usar:**
  /// - Mensagens de erro
  /// - Borda de campos inválidos
  /// - Ícones de erro/X
  /// - Texto de validação de erro
  /// - Badges de notificação urgente
  /// - Botões destrutivos (deletar)
  /// 
  /// **Exemplo:**
  /// ```
  /// ┌─────────────────────────────────┐
  /// │  Email inválido                 │ ← Border: error
  /// │  ⚬ Formato de email incorreto   │ ← Text: error
  /// └─────────────────────────────────┘
  /// 
  /// ┌─────────────────────────────────┐
  /// │  ✕ Erro ao salvar               │ ← error
  /// └─────────────────────────────────┘
  /// ```
  static const Color error = Color(0xFFEF4444);
  
  /// ## Error Light
  /// 
  /// **Onde usar:**
  /// - Background de alertas de erro
  /// - Container de mensagens de erro
  /// - Background sutil para estados de erro
  static const Color errorLight = Color(0xFFFEE2E2);
  
  /// ## Info - Azul Informação
  /// 
  /// **Onde usar:**
  /// - Mensagens informativas
  /// - Tooltips e hints
  /// - Links informativos
  /// - Ícones de ajuda
  /// 
  /// **Exemplo:**
  /// ```
  /// ┌─────────────────────────────────┐
  /// │  ℹ️ Dica: Use tags para         │ ← info
  /// │    organizar melhor             │
  /// └─────────────────────────────────┘
  /// ```
  static const Color info = Color(0xFF3B82F6);
  
  /// ## Info Light
  /// 
  /// **Onde usar:**
  /// - Background de tooltips
  /// - Container de dicas
  /// - Background de mensagens informativas
  static const Color infoLight = Color(0xFFDBEAFE);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CORES DE BACKGROUND E SUPERFÍCIE
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// ## Background Light - Fundo Principal (Modo Claro)
  /// 
  /// **Onde usar:**
  /// - Scaffold background
  /// - Background geral da aplicação
  /// - Fundo de páginas
  /// 
  /// **Layout Hierarchy (Light Mode):**
  /// ```
  /// backgroundLight (grey50)
  ///   └── surfaceLight (white) - Cards, AppBar, BottomNav
  ///         └── surfaceVariant - Elevated elements
  /// ```
  static const Color backgroundLight = Color(0xFFF9FAFB);
  
  /// ## Background Dark - Fundo Principal (Modo Escuro)
  /// 
  /// **Onde usar:**
  /// - Scaffold background no modo escuro
  /// - Background geral da aplicação (dark mode)
  static const Color backgroundDark = Color(0xFF111827);
  
  /// ## Surface Light - Superfície (Modo Claro)
  /// 
  /// **Onde usar:**
  /// - Cards e containers
  /// - AppBar background
  /// - BottomNavigationBar background
  /// - Drawer background
  /// - Dialog/Modal background
  /// - Dropdown menus
  static const Color surfaceLight = Color(0xFFFFFFFF);
  
  /// ## Surface Dark - Superfície (Modo Escuro)
  /// 
  /// **Onde usar:**
  /// - Cards e containers (dark mode)
  /// - AppBar background (dark mode)
  /// - BottomNavigationBar background (dark mode)
  static const Color surfaceDark = Color(0xFF1F2937);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CORES DE TEXTO
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// ## Text Primary Light - Texto Principal (Modo Claro)
  /// 
  /// **Onde usar:**
  /// - Títulos principais
  /// - Body text principal
  /// - Labels ativos
  /// - Valores em formulários
  /// 
  /// **Hierarquia de Texto (Light Mode):**
  /// ```
  /// Título Principal ────── textPrimaryLight (grey900)
  /// Subtítulo ──────────── textSecondaryLight (grey600)
  /// Body Text ──────────── textPrimaryLight (grey900)
  /// Caption/Helper ──────── textSecondaryLight (grey500)
  /// Disabled ───────────── grey400
  /// ```
  static const Color textPrimaryLight = Color(0xFF111827);
  
  /// ## Text Secondary Light - Texto Secundário (Modo Claro)
  /// 
  /// **Onde usar:**
  /// - Subtítulos
  /// - Descrições
  /// - Helper text
  /// - Timestamps
  /// - Metadata
  static const Color textSecondaryLight = Color(0xFF6B7280);
  
  /// ## Text Primary Dark - Texto Principal (Modo Escuro)
  /// 
  /// **Onde usar:**
  /// - Títulos principais (dark mode)
  /// - Body text principal (dark mode)
  /// - Labels ativos (dark mode)
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  
  /// ## Text Secondary Dark - Texto Secundário (Modo Escuro)
  /// 
  /// **Onde usar:**
  /// - Subtítulos (dark mode)
  /// - Descrições (dark mode)
  /// - Helper text (dark mode)
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CORES DE BORDA
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// ## Border Light - Borda (Modo Claro)
  /// 
  /// **Onde usar:**
  /// - Borda de cards
  /// - Dividers
  /// - Borda de inputs
  /// - Separadores de lista
  /// 
  /// **Exemplo:**
  /// ```
  /// ┌─────────────────────┐ ← Card border: borderLight
  /// │  Conteúdo do Card   │
  /// ├─────────────────────┤ ← Divider: borderLight
  /// │  Mais conteúdo      │
  /// └─────────────────────┘
  /// ```
  static const Color borderLight = Color(0xFFE5E7EB);
  
  /// ## Border Dark - Borda (Modo Escuro)
  /// 
  /// **Onde usar:**
  /// - Borda de cards (dark mode)
  /// - Dividers (dark mode)
  /// - Borda de inputs (dark mode)
  static const Color borderDark = Color(0xFF374151);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENTES
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// ## Primary Gradient
  /// 
  /// **Onde usar:**
  /// - Headers promocionais
  /// - Backgrounds de destaque
  /// - Botões especiais
  /// - Indicadores de progresso premium
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// ## Secondary Gradient
  /// 
  /// **Onde usar:**
  /// - Badges de status
  /// - Backgrounds de sucesso
  /// - Elementos de conquista
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// ## Accent Gradient
  /// 
  /// **Onde usar:**
  /// - Banners promocionais
  /// - Badges premium
  /// - Elementos de destaque especial
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// ## Dark Gradient (para overlays)
  /// 
  /// **Onde usar:**
  /// - Overlay sobre imagens
  /// - Gradiente de fade em listas
  /// - Sombras de cards especiais
  static const LinearGradient darkGradient = LinearGradient(
    colors: [
      Color(0xFF000000),
      Color(0x00000000),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CORES ESPECIAIS E OVERLAYS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// ## Scrim - Overlay para modais
  /// 
  /// **Onde usar:**
  /// - Background de modais
  /// - Overlay de drawer
  /// - Background de bottom sheets
  /// - Loading overlays
  static final Color scrim = black.withOpacity(0.5);
  
  /// ## Ripple Effect Colors
  /// 
  /// **Onde usar:**
  /// - InkWell splash color
  /// - Button ripple effects
  static final Color rippleLight = primary.withOpacity(0.1);
}
