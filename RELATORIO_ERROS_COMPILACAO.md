# Relatório de Erros de Compilação - Migração de Cores Dinâmicas

**Data:** 17 de dezembro de 2025  
**Total de Erros:** ~50 erros identificados

---

## CATEGORIA 1: Propriedades Faltantes no ThemeColorsData

### 1.1 Roles Faltantes
| Propriedade | Arquivo | Linha |
|-------------|---------|-------|
| `roleSuperAdmin` | user_model.dart | 66 |
| `roleOperator` | user_model.dart | 72, 183 |
| `roleViewer` | user_model.dart | 74, 185 |

### 1.2 Cores Faltantes
| Propriedade | Arquivo | Linha |
|-------------|---------|-------|
| `orangeDeep` | export_tags_screen.dart | 53 |

---

## CATEGORIA 2: Erros de Escopo - `context` não definido

### 2.1 Variáveis de classe usando `ThemeColors.of(context)` fora do build
| Arquivo | Linhas |
|---------|--------|
| `import_products_screen.dart` | 38, 44 |
| `export_products_screen.dart` | 43, 49 |
| `export_tags_screen.dart` | 39, 46, 53 |

### 2.2 Propriedade `context` usada fora de método build
| Arquivo | Linhas | Classe |
|---------|--------|--------|
| `recent_tags_card.dart` | 125, 133 | RecentTagsCard |

---

## CATEGORIA 3: Erros de Escopo - `colors` não definido

### 3.1 Variável `colors` usada sem declaração
| Arquivo | Linhas | Classe |
|---------|--------|--------|
| `dialog_widgets.dart` | 40, 40, 60, 72, 82, 82, 83 | ConfirmDialog |

---

## CATEGORIA 4: Erros de Const Expression

### 4.1 `ThemeColors.of(context)` em contexto const
Erros onde `ThemeColors.of(context)` é usado dentro de `const` que não permite chamadas de método.

| Arquivo | Linha | Código Problemático |
|---------|-------|---------------------|
| `backup_screen.dart` | 889 | `const TextStyle(color: ThemeColors.of(context).textSecondary)` |
| `backup_screen.dart` | 936 | `const ... backgroundColor: ThemeColors.of(context).orangeMain` |
| `backup_screen.dart` | 947 | `const ... backgroundColor: ThemeColors.of(context).orangeMain` |
| `import_products_screen.dart` | 1081 | `AlwaysStoppedAnimation<Color>(ThemeColors.of(context).blueCyan)` |
| `import_products_screen.dart` | 1107 | `const AlwaysStoppedAnimation<Color>(ThemeColors.of(context).blueCyan)` |
| `import_tags_screen.dart` | 909 | `const AlwaysStoppedAnimation<Color>(ThemeColors.of(context).greenGradient)` |
| `export_products_screen.dart` | 1090 | `const AlwaysStoppedAnimation<Color>(ThemeColors.of(context).blueCyan)` |
| `export_products_screen.dart` | 1125 | `const AlwaysStoppedAnimation<Color>(ThemeColors.of(context).blueCyan)` |
| `export_tags_screen.dart` | 1285 | `AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface)` |
| `qr_scan_area.dart` | 192 | `AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface)` |
| `qr_scan_area.dart` | 199 | `const ... color: ThemeColors.of(context).surface` |
| `product_binding_card.dart` | 204 | `const ... color: ThemeColors.of(context).brandPrimaryGreen` |

---

## PLANO DE CORREÇÃO

### Prioridade 1: Adicionar propriedades faltantes ao ThemeColorsData
- [ ] `roleSuperAdmin` 
- [ ] `roleOperator`
- [ ] `roleViewer`
- [ ] `orangeDeep`

### Prioridade 2: Corrigir erros de escopo (context fora de build)
Arquivos que usam `ThemeColors.of(context)` em variáveis de classe:
- [ ] `import_products_screen.dart` - Mover variáveis para dentro do build ou usar getter
- [ ] `export_products_screen.dart` - Mover variáveis para dentro do build ou usar getter
- [ ] `export_tags_screen.dart` - Mover variáveis para dentro do build ou usar getter

### Prioridade 3: Corrigir erros de escopo (colors não definido)
- [ ] `dialog_widgets.dart` - Adicionar `final colors = ThemeColors.of(context);` no início do build

### Prioridade 4: Corrigir erros de escopo (context em classe)
- [ ] `recent_tags_card.dart` - Mover código para dentro do método build

### Prioridade 5: Remover `const` onde ThemeColors.of é usado
- [ ] `backup_screen.dart` - Remover const das linhas 889, 936, 947
- [ ] `import_products_screen.dart` - Remover const das linhas 1081, 1107
- [ ] `import_tags_screen.dart` - Remover const da linha 909
- [ ] `export_products_screen.dart` - Remover const das linhas 1090, 1125
- [ ] `export_tags_screen.dart` - Remover const da linha 1285
- [ ] `qr_scan_area.dart` - Remover const das linhas 192, 199
- [ ] `product_binding_card.dart` - Remover const da linha 204

---

## ARQUIVOS AFETADOS (LISTA COMPLETA)

1. `lib/features/settings/data/models/user_model.dart`
2. `lib/features/settings/presentation/screens/backup_screen.dart`
3. `lib/features/import_export/presentation/screens/import_products_screen.dart`
4. `lib/features/import_export/presentation/screens/import_tags_screen.dart`
5. `lib/features/import_export/presentation/screens/export_products_screen.dart`
6. `lib/features/import_export/presentation/screens/export_tags_screen.dart`
7. `lib/design_system/components/dialogs/dialog_widgets.dart`
8. `lib/features/tags/presentation/widgets/recent_tags_card.dart`
9. `lib/features/products/presentation/widgets/qr/qr_scan_area.dart`
10. `lib/features/products/presentation/widgets/qr/product_binding_card.dart`

---

## RESUMO

| Categoria | Quantidade | Status |
|-----------|------------|--------|
| Propriedades Faltantes | 4 | ⏳ Pendente |
| Erros context fora de build | 7 | ⏳ Pendente |
| Erros colors não definido | 7 | ⏳ Pendente |
| Erros const expression | 12+ | ⏳ Pendente |
| **TOTAL** | **~30 correções** | ⏳ |
