# Relatório de Erros de Migração de Cores

**Data:** 17 de dezembro de 2025

## Resumo

Foram identificados **3 categorias de erros** durante a compilação:

---

## CATEGORIA 1: Propriedades Ausentes em ThemeColorsData

### Propriedades que precisam ser adicionadas ao `ThemeColorsData`:

| Propriedade | Arquivo(s) Afetado(s) | Linhas |
|-------------|----------------------|--------|
| `infoModuleBackground` | export_tags_screen.dart | 1137 |
| `infoModuleBackgroundAlt` | export_tags_screen.dart | 1137 |
| `redDark` | batch_operations_screen.dart | 50 |
| `cyanDark` | batch_operations_screen.dart | 98 |
| `urgentDark` | batch_operations_screen.dart, strategies_repository.dart | 283, 494 |
| `orangeAmber` | batch_operations_screen.dart | 415, 421, 433, 440 |
| `warningPastel` | batch_operations_screen.dart | 415 |
| `statusActive` | action_feedback.dart | 25, 355 |
| `statusBlocked` | action_feedback.dart | 46 |
| `statusPending` | action_feedback.dart | 67 |
| `statusInactive` | action_feedback.dart | 117 |
| `roleManager` | action_feedback.dart | 87 |
| `roleAdmin` | action_feedback.dart | 105 |

---

## CATEGORIA 2: Erros de Contexto (variável `colors` ou `context` não definida)

### Arquivos com erro de escopo:

| Arquivo | Problema | Linhas |
|---------|----------|--------|
| `dialog_widgets.dart` | `colors` não definido no widget | 40, 60, 72, 82, 83 |
| `recent_tags_card.dart` | `context` não definido fora do método build | 125, 133 |

---

## CATEGORIA 3: Erros de Constante (uso de ThemeColors.of em contexto const)

### Arquivos com erro "Not a constant expression":

| Arquivo | Linha | Código Problemático |
|---------|-------|---------------------|
| `export_tags_screen.dart` | 1285 | `AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface)` |
| `qr_scan_area.dart` | 192 | `AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface)` |
| `qr_scan_area.dart` | 199 | `color: ThemeColors.of(context).surface` em contexto const |
| `product_binding_card.dart` | 204 | `color: ThemeColors.of(context).brandPrimaryGreen` em contexto const |

---

## Plano de Correção

### Prioridade 1: Adicionar propriedades faltantes ao ThemeColorsData
- [ ] Adicionar todas as propriedades listadas na Categoria 1

### Prioridade 2: Corrigir erros de escopo
- [ ] `dialog_widgets.dart` - definir `colors = ThemeColors.of(context)` dentro do build
- [ ] `recent_tags_card.dart` - usar `context` dentro do método build correto

### Prioridade 3: Remover uso de ThemeColors.of em contextos const
- [ ] Substituir por valores não-const ou usar AppThemeColors para constantes

---

## Arquivos a Corrigir (por ordem de prioridade)

1. `lib/design_system/theme/theme_colors_dynamic.dart` - Adicionar propriedades
2. `lib/design_system/components/dialogs/dialog_widgets.dart` - Corrigir escopo
3. `lib/features/tags/presentation/widgets/recent_tags_card.dart` - Corrigir escopo
4. `lib/features/import_export/presentation/screens/export_tags_screen.dart` - Propriedades + const
5. `lib/features/import_export/presentation/screens/batch_operations_screen.dart` - Propriedades
6. `lib/shared/widgets/feedback/action_feedback.dart` - Propriedades
7. `lib/features/products/presentation/widgets/qr/qr_scan_area.dart` - Remover const
8. `lib/features/products/presentation/widgets/qr/product_binding_card.dart` - Remover const
9. `lib/features/strategies/data/repositories/strategies_repository.dart` - Propriedade urgentDark
