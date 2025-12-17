# 📋 RELATORIO DE PROBLEMAS DE ENCODING
## TagBean Frontend - Arquivos Dart

**Data da Analise:** 17/12/2025 13:48:39

**Diretorio Analisado:** `D:\tagbean\frontend\lib`

**Total de Arquivos Analisados:** 440

**Arquivos com Problemas:** 207

**Total de Ocorrencias:** 2349

---

## 📊 RESUMO POR TIPO DE PROBLEMA

| Padrao Corrompido | Correcao | Descricao | Ocorrencias |
|-------------------|----------|-----------|-------------|
| `Ã` | `Ñ` | N com til maiusculo | 2349 |
| `Ã£` | `ã` | a com til | 1961 |
| `Ã§` | `ç` | c com cedilha | 421 |
| `Ã‡` | `Ç` | C com cedilha maiusculo | 105 |
| `Ã¡` | `á` | a com acento agudo | 81 |
| `Ã­` | `í` | i com acento agudo | 76 |
| `Ã©` | `é` | e com acento agudo | 46 |
| `Ãª` | `ê` | e com circunflexo | 22 |
| `Ã¢` | `â` | a com circunflexo | 16 |
| `Ãµ` | `õ` | o com til | 15 |
| `Ã³` | `ó` | o com acento agudo | 11 |
| `Ãº` | `ú` | u com acento agudo | 5 |

---

## 📁 RESUMO POR ARQUIVO

| Arquivo | Problemas | Linhas Afetadas |
|---------|-----------|------------------|
| `modules\dashboard\presentation\screens\dashboard_screen.dart` | 126 | 36, 38, 52, 57, 58, 60, 79, 84, 89, 99 ... (+116) |
| `modules\products\presentation\screens\products_dashboard_screen.dart` | 68 | 45, 97, 105, 190, 200, 203, 209, 210, 218, 219 ... (+58) |
| `modules\products\presentation\screens\products_list_screen.dart` | 58 | 41, 45, 49, 120, 169, 171, 221, 222, 237, 288 ... (+48) |
| `modules\products\presentation\screens\product_details_screen.dart` | 41 | 14, 15, 61, 72, 160, 162, 163, 226, 261, 264 ... (+31) |
| `modules\products\presentation\screens\product_add_screen.dart` | 40 | 16, 18, 19, 20, 23, 43, 63, 74, 87, 101 ... (+30) |
| `features\products\presentation\providers\products_state_provider.dart` | 40 | 18, 19, 147, 150, 161, 290, 327, 341, 353, 379 ... (+30) |
| `features\import_export\presentation\screens\batch_operations_screen.dart` | 40 | 26, 30, 33, 34, 35, 36, 40, 46, 47, 48 ... (+30) |
| `features\auth\presentation\widgets\store_switcher.dart` | 36 | 11, 12, 20, 55, 60, 88, 103, 108, 118, 147 ... (+26) |
| `modules\products\presentation\screens\product_qr_screen.dart` | 34 | 18, 20, 100, 105, 114, 119, 157, 167, 208, 215 ... (+24) |
| `design_system\theme\gradients.dart` | 34 | 4, 7, 25, 31, 37, 42, 47, 57, 81, 86 ... (+24) |
| `modules\products\presentation\screens\products_stock_screen.dart` | 33 | 44, 129, 210, 241, 245, 368, 404, 572, 606, 622 ... (+23) |
| `features\sync\data\models\sync_models.dart` | 33 | 3, 4, 6, 8, 11, 24, 42, 45, 58, 88 ... (+23) |
| `features\products\presentation\screens\products_stock_screen.dart` | 33 | 44, 129, 210, 242, 246, 371, 407, 577, 612, 628 ... (+23) |
| `modules\dashboard\presentation\widgets\next_action_card.dart` | 32 | 8, 9, 14, 15, 44, 49, 57, 87, 116, 142 ... (+22) |
| `features\strategies\presentation\screens\strategies_results_screen.dart` | 32 | 28, 35, 39, 73, 78, 106, 112, 258, 455, 469 ... (+22) |
| `features\strategies\presentation\screens\cross_selling\nearby_products_screen.dart` | 32 | 290, 297, 402, 420, 499, 566, 598, 667, 699, 763 ... (+22) |
| `features\pricing\presentation\screens\adjustments_history_screen.dart` | 26 | 112, 197, 211, 287, 316, 474, 1117, 1118, 1119, 1120 ... (+16) |
| `features\pricing\presentation\screens\dynamic_pricing_screen.dart` | 26 | 28, 32, 49, 59, 69, 79, 145, 295, 419, 430 ... (+16) |
| `modules\dashboard\presentation\widgets\alertas_acionaveis_card.dart` | 25 | 9, 11, 16, 41, 42, 47, 72, 88, 97, 111 ... (+15) |
| `modules\products\presentation\screens\product_edit_screen.dart` | 24 | 11, 48, 89, 350, 393, 396, 448, 544, 566, 584 ... (+14) |
| `modules\products\presentation\widgets\barcode_scanner_widget.dart` | 24 | 7, 10, 19, 97, 144, 153, 159, 172, 180, 191 ... (+14) |
| `features\products\presentation\widgets\barcode_scanner_widget.dart` | 24 | 8, 11, 20, 98, 145, 154, 160, 173, 182, 194 ... (+14) |
| `modules\products\presentation\screens\products_import_screen.dart` | 23 | 13, 140, 171, 206, 441, 442, 443, 446, 549, 724 ... (+13) |
| `features\sync\presentation\screens\sync_settings_screen.dart` | 23 | 177, 191, 261, 303, 353, 424, 485, 634, 635, 803 ... (+13) |
| `features\strategies\presentation\screens\calendar\salary_cycle_screen.dart` | 23 | 182, 273, 280, 313, 324, 442, 497, 581, 632, 848 ... (+13) |
| `features\reports\presentation\screens\audit_report_screen.dart` | 23 | 26, 50, 63, 66, 73, 76, 81, 97, 188, 193 ... (+13) |
| `features\tags\presentation\screens\tags_diagnostic_screen.dart` | 22 | 42, 60, 64, 68, 76, 137, 142, 145, 154, 155 ... (+12) |
| `design_system\components\dialogs\dialog_widgets.dart` | 22 | 4, 92, 122, 181, 203, 239, 248, 254, 258, 265 ... (+12) |
| `features\strategies\presentation\screens\cross_selling\offers_trail_screen.dart` | 21 | 289, 497, 564, 596, 760, 795, 909, 910, 920, 930 ... (+11) |
| `modules\dashboard\presentation\widgets\recent_activity_dashboard_card.dart` | 20 | 9, 40, 43, 48, 73, 99, 143, 150, 166, 174 ... (+10) |
| `features\pricing\presentation\screens\pricing_suggestions_screen.dart` | 20 | 31, 100, 109, 166, 171, 212, 236, 266, 491, 512 ... (+10) |
| `features\tags\presentation\screens\tags_operations_screen.dart` | 19 | 23, 96, 139, 188, 205, 311, 333, 343, 362, 363 ... (+9) |
| `features\strategies\presentation\screens\strategy_report_screen.dart` | 19 | 46, 75, 136, 146, 161, 189, 426, 526, 539, 545 ... (+9) |
| `features\strategies\presentation\screens\calendar\holidays_screen.dart` | 19 | 11, 13, 14, 257, 339, 551, 566, 663, 673, 1085 ... (+9) |
| `features\reports\presentation\providers\reports_provider.dart` | 19 | 54, 57, 63, 66, 142, 145, 150, 257, 345, 388 ... (+9) |
| `features\pricing\presentation\screens\margins_screen.dart` | 19 | 76, 128, 133, 143, 145, 179, 187, 208, 210, 212 ... (+9) |
| `features\import_export\presentation\screens\export_products_screen.dart` | 19 | 33, 37, 54, 79, 127, 385, 690, 726, 773, 774 ... (+9) |
| `features\import_export\presentation\screens\import_tags_screen.dart` | 19 | 31, 57, 101, 339, 512, 559, 560, 561, 648, 996 ... (+9) |
| `features\tags\presentation\screens\tags_batch_screen.dart` | 18 | 63, 67, 213, 227, 458, 633, 717, 736, 767, 800 ... (+8) |
| `features\strategies\presentation\screens\performance\auto_clearance_screen.dart` | 18 | 160, 311, 387, 444, 500, 509, 575, 630, 639, 1125 ... (+8) |
| `modules\categories\presentation\screens\categories_stats_screen.dart` | 17 | 27, 30, 38, 44, 134, 225, 388, 465, 635, 1077 ... (+7) |
| `features\strategies\presentation\screens\ai_suggestions_screen.dart` | 17 | 109, 230, 262, 351, 509, 562, 777, 815, 869, 1309 ... (+7) |
| `features\strategies\presentation\screens\environmental\peak_hours_screen.dart` | 17 | 182, 195, 280, 287, 402, 498, 518, 528, 847, 1311 ... (+7) |
| `features\strategies\presentation\screens\environmental\temperature_screen.dart` | 17 | 189, 202, 294, 414, 665, 755, 851, 1277, 1330, 1382 ... (+7) |
| `features\reports\presentation\screens\performance_report_screen.dart` | 17 | 42, 43, 44, 49, 168, 173, 266, 276, 368, 421 ... (+7) |
| `features\import_export\presentation\screens\export_tags_screen.dart` | 17 | 249, 494, 690, 855, 856, 866, 875, 876, 885, 886 ... (+7) |
| `features\categories\presentation\screens\categories_stats_screen.dart` | 17 | 28, 31, 39, 45, 135, 226, 389, 469, 640, 1085 ... (+7) |
| `features\auth\presentation\widgets\store_selector.dart` | 17 | 13, 22, 45, 53, 90, 100, 195, 280, 284, 285 ... (+7) |
| `features\pricing\presentation\screens\ai_suggestions_screen.dart` | 16 | 211, 225, 343, 402, 513, 783, 819, 873, 1273, 1299 ... (+6) |
| `modules\dashboard\presentation\widgets\acoes_frequentes_card.dart` | 15 | 8, 9, 29, 32, 36, 40, 83, 96, 109, 142 ... (+5) |
| `modules\dashboard\presentation\widgets\fluxos_inteligentes_card.dart` | 15 | 9, 32, 57, 103, 120, 128, 134, 143, 149, 150 ... (+5) |
| `features\sync\presentation\screens\sync_log_screen.dart` | 15 | 32, 217, 231, 581, 850, 1153, 1157, 1182, 1401, 1409 ... (+5) |
| `features\strategies\presentation\screens\cross_selling\smart_combo_screen.dart` | 15 | 291, 619, 692, 759, 1168, 1169, 1178, 1571, 1683, 1862 ... (+5) |
| `features\strategies\presentation\screens\performance\dynamic_markdown_screen.dart` | 15 | 168, 306, 370, 431, 440, 494, 565, 636, 973, 1005 ... (+5) |
| `features\import_export\presentation\screens\import_products_screen.dart` | 15 | 28, 49, 115, 383, 695, 731, 774, 775, 776, 841 ... (+5) |
| `modules\dashboard\presentation\widgets\admin_panel_card.dart` | 14 | 9, 10, 11, 12, 39, 96, 147, 192, 201, 235 ... (+4) |
| `features\strategies\presentation\screens\calendar\sports_events_screen.dart` | 14 | 198, 261, 360, 436, 467, 711, 861, 929, 981, 984 ... (+4) |
| `features\auth\presentation\screens\forgot_password_screen.dart` | 14 | 8, 115, 133, 144, 146, 171, 202, 226, 257, 273 ... (+4) |
| `features\tags\presentation\widgets\tags_onboarding_card.dart` | 13 | 7, 9, 11, 13, 16, 17, 167, 175, 176, 178 ... (+3) |
| `features\reports\presentation\screens\sales_report_screen.dart` | 13 | 198, 220, 414, 513, 559, 997, 1008, 1010, 1012, 1031 ... (+3) |
| `features\products\presentation\screens\products_dashboard_screen.dart` | 13 | 646, 656, 660, 666, 673, 677, 681, 693, 768, 868 ... (+3) |
| `modules\categories\presentation\screens\category_edit_screen.dart` | 12 | 54, 310, 371, 432, 449, 464, 986, 1077, 1129, 1142 ... (+2) |
| `features\strategies\presentation\screens\visual\flash_promos_screen.dart` | 12 | 80, 99, 121, 140, 154, 156, 173, 190, 192, 194 ... (+2) |
| `features\strategies\presentation\screens\visual\heatmap_screen.dart` | 12 | 154, 184, 264, 293, 295, 328, 338, 345, 351, 370 ... (+2) |
| `features\categories\presentation\screens\category_edit_screen.dart` | 12 | 54, 307, 368, 428, 445, 460, 979, 1070, 1121, 1134 ... (+2) |
| `design_system\theme\app_theme.dart` | 12 | 30, 34, 43, 81, 161, 170, 195, 204, 211, 222 ... (+2) |
| `app\app.dart` | 11 | 63, 72, 85, 93, 106, 161, 208, 212, 216, 228 ... (+1) |
| `modules\dashboard\presentation\widgets\oportunidades_lucro_card.dart` | 11 | 8, 9, 32, 43, 48, 81, 163, 194, 203, 211 ... (+1) |
| `modules\dashboard\presentation\widgets\status_geral_sistema_card.dart` | 11 | 9, 56, 132, 134, 153, 191, 193, 216, 318, 319 ... (+1) |
| `modules\categories\presentation\screens\categories_menu_screen.dart` | 11 | 36, 343, 366, 395, 596, 597, 604, 605, 612, 835 ... (+1) |
| `features\strategies\presentation\screens\performance\ai_forecast_screen.dart` | 11 | 442, 571, 593, 672, 728, 1021, 1281, 1319, 1421, 1442 ... (+1) |
| `features\reports\presentation\screens\operational_report_screen.dart` | 11 | 28, 52, 163, 168, 303, 325, 540, 663, 1002, 1164 ... (+1) |
| `features\pricing\presentation\screens\margins_review_screen.dart` | 11 | 109, 180, 189, 559, 570, 571, 572, 624, 659, 690 ... (+1) |
| `features\pricing\presentation\screens\percentage_adjustment_screen.dart` | 11 | 126, 209, 240, 705, 724, 725, 750, 1086, 1102, 1108 ... (+1) |
| `features\pricing\presentation\screens\pricing_fixed_screen.dart` | 11 | 201, 283, 331, 370, 371, 529, 554, 574, 671, 686 ... (+1) |
| `features\pricing\presentation\screens\pricing_individual_screen.dart` | 11 | 201, 318, 378, 518, 602, 619, 645, 692, 707, 759 ... (+1) |
| `features\tags\presentation\widgets\tag_minew_sync_card.dart` | 10 | 7, 49, 69, 89, 148, 272, 381, 382, 383, 474 |
| `features\strategies\presentation\screens\strategies_config_screen.dart` | 10 | 48, 63, 89, 93, 101, 105, 120, 256, 274, 547 |
| `features\strategies\presentation\screens\visual\realtime_ranking_screen.dart` | 10 | 80, 98, 120, 138, 152, 154, 187, 189, 276, 282 |
| `features\pricing\presentation\screens\individual_adjustment_screen.dart` | 10 | 144, 179, 270, 444, 475, 606, 635, 707, 753, 795 |
| `features\auth\presentation\screens\login_screen.dart` | 10 | 36, 78, 133, 301, 419, 466, 642, 667, 711, 811 |
| `modules\dashboard\presentation\widgets\compact_sync_card.dart` | 9 | 9, 10, 14, 25, 35, 37, 104, 121, 229 |
| `modules\dashboard\presentation\widgets\onboarding_steps_card.dart` | 9 | 8, 9, 30, 38, 65, 96, 235, 261, 275 |
| `modules\dashboard\presentation\widgets\welcome_section.dart` | 9 | 32, 69, 105, 114, 161, 197, 209, 249, 256 |
| `modules\dashboard\presentation\widgets\navigation\dashboard_mobile_bottom_nav.dart` | 9 | 8, 111, 112, 118, 120, 125, 128, 139, 150 |
| `modules\categories\presentation\screens\categories_admin_screen.dart` | 9 | 26, 52, 110, 169, 1081, 1083, 1099, 1144, 1166 |
| `features\tags\presentation\screens\tag_add_screen.dart` | 9 | 226, 359, 413, 435, 474, 483, 620, 628, 1136 |
| `features\tags\presentation\widgets\tags_sync_footer.dart` | 9 | 6, 14, 51, 85, 125, 205, 207, 216, 217 |
| `features\strategies\presentation\screens\calendar\long_holidays_screen.dart` | 9 | 195, 273, 427, 444, 521, 1167, 1182, 1212, 1273 |
| `features\dashboard\presentation\widgets\welcome_section.dart` | 9 | 32, 69, 105, 114, 161, 197, 209, 249, 256 |
| `features\categories\presentation\screens\categories_admin_screen.dart` | 9 | 27, 53, 111, 170, 1082, 1084, 1100, 1145, 1167 |
| `features\auth\presentation\screens\reset_password_screen.dart` | 9 | 85, 124, 262, 339, 380, 431, 434, 518, 598 |
| `design_system\theme\theme_selector_dialog.dart` | 9 | 8, 12, 106, 158, 459, 470, 476, 482, 491 |
| `modules\products\presentation\widgets\products_onboarding_card.dart` | 8 | 6, 116, 145, 151, 157, 158, 161, 169 |
| `modules\products\presentation\widgets\recent_products_card.dart` | 8 | 77, 98, 133, 135, 205, 352, 354, 356 |
| `modules\products\presentation\widgets\details\product_info_card.dart` | 8 | 8, 47, 57, 68, 92, 95, 127, 146 |
| `modules\products\presentation\widgets\qr\qr_scan_area.dart` | 8 | 5, 6, 8, 9, 21, 69, 128, 133 |
| `modules\dashboard\presentation\widgets\atalhos_rapidos_card.dart` | 8 | 7, 8, 31, 62, 234, 235, 237, 240 |
| `modules\categories\presentation\screens\category_add_screen.dart` | 8 | 79, 488, 557, 684, 701, 716, 843, 878 |
| `modules\categories\presentation\screens\category_products_screen.dart` | 8 | 77, 85, 119, 126, 142, 240, 1281, 1459 |
| `features\products\presentation\widgets\products_onboarding_card.dart` | 8 | 6, 116, 145, 151, 157, 158, 161, 169 |
| `features\products\presentation\widgets\recent_products_card.dart` | 8 | 77, 98, 133, 135, 205, 352, 354, 356 |
| `features\products\presentation\widgets\details\product_info_card.dart` | 8 | 8, 47, 57, 68, 92, 95, 127, 146 |
| `features\products\presentation\widgets\qr\qr_scan_area.dart` | 8 | 5, 6, 8, 9, 21, 69, 128, 133 |
| `features\pricing\presentation\screens\pricing_percentage_screen.dart` | 8 | 199, 281, 331, 370, 371, 529, 570, 693 |
| `features\categories\presentation\screens\category_add_screen.dart` | 8 | 83, 492, 561, 688, 705, 720, 848, 883 |
| `features\categories\presentation\screens\category_products_screen.dart` | 8 | 78, 86, 120, 127, 143, 241, 1282, 1460 |
| `design_system\theme\dynamic_gradients.dart` | 8 | 6, 8, 9, 72, 82, 102, 105, 115 |
| `modules\dashboard\presentation\widgets\estrategias_ativas_card.dart` | 7 | 9, 10, 31, 44, 110, 138, 167 |
| `modules\dashboard\presentation\widgets\recent_activity_card.dart` | 7 | 73, 76, 99, 110, 111, 113, 203 |
| `modules\dashboard\presentation\widgets\scanner_central_card.dart` | 7 | 7, 43, 66, 111, 119, 136, 172 |
| `modules\dashboard\presentation\widgets\navigation\dashboard_navigation_rail.dart` | 7 | 8, 35, 40, 45, 55, 60, 65 |
| `features\settings\presentation\screens\api_test_screen.dart` | 7 | 345, 543, 1034, 1050, 1136, 1213, 1226 |
| `modules\products\presentation\widgets\qr\binding_confirmation_card.dart` | 6 | 6, 47, 53, 90, 199, 201 |
| `modules\dashboard\presentation\widgets\navigation\dashboard_app_bar.dart` | 6 | 13, 85, 180, 282, 330, 502 |
| `features\strategies\presentation\screens\visual\smart_route_screen.dart` | 6 | 99, 154, 196, 198, 251, 257 |
| `features\products\presentation\widgets\qr\binding_confirmation_card.dart` | 6 | 6, 47, 53, 90, 204, 206 |
| `features\pricing\presentation\screens\fixed_value_screen.dart` | 6 | 28, 262, 435, 547, 652, 696 |
| `modules\products\presentation\widgets\product_tags_widget.dart` | 5 | 161, 171, 186, 344, 346 |
| `modules\products\presentation\widgets\details\price_history_card.dart` | 5 | 6, 23, 128, 158, 321 |
| `modules\products\presentation\widgets\details\product_tag_card.dart` | 5 | 7, 120, 155, 158, 273 |
| `modules\dashboard\presentation\widgets\compact_metrics_grid.dart` | 5 | 12, 23, 51, 70, 109 |
| `modules\dashboard\presentation\widgets\resumo_do_dia_card.dart` | 5 | 8, 9, 34, 39, 123 |
| `modules\categories\presentation\screens\categories_list_screen.dart` | 5 | 47, 642, 665, 670, 684 |
| `features\tags\presentation\widgets\recent_tags_card.dart` | 5 | 14, 160, 320, 321, 322 |
| `features\tags\presentation\widgets\tags_health_card.dart` | 5 | 6, 25, 69, 84, 89 |
| `features\products\presentation\widgets\product_tags_widget.dart` | 5 | 161, 171, 186, 344, 346 |
| `features\products\presentation\widgets\details\product_tag_card.dart` | 5 | 7, 120, 155, 158, 273 |
| `modules\products\presentation\widgets\details\quick_actions_section.dart` | 4 | 6, 71, 92, 130 |
| `modules\products\presentation\widgets\qr\product_binding_card.dart` | 4 | 55, 59, 117, 136 |
| `features\tags\presentation\widgets\tags_quick_actions_card.dart` | 4 | 6, 25, 65, 76 |
| `features\strategies\presentation\screens\performance\auto_audit_screen.dart` | 4 | 1064, 1107, 1132, 1135 |
| `features\products\presentation\widgets\details\quick_actions_section.dart` | 4 | 6, 71, 92, 130 |
| `features\products\presentation\widgets\qr\product_binding_card.dart` | 4 | 55, 59, 117, 136 |
| `features\dashboard\presentation\screens\dashboard_screen.dart` | 4 | 1258, 1260, 1298, 1312 |
| `design_system\theme\brand_colors.dart` | 4 | 8, 54, 69, 91 |
| `design_system\theme\theme_colors.dart` | 4 | 176, 203, 743, 783 |
| `design_system\theme\temas\BOA theme_colors_t10_indigo_night.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\BOA_theme_colors_t12_sky_blue.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\BOM_theme_colors_t14_forest_green.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors.dart` | 4 | 164, 191, 723, 763 |
| `design_system\theme\temas\theme_colors_t01_emerald_power.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_t02_royal_blue.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_t03_crimson_fire.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_t04_purple_reign.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_t05_sunset_orange.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_t06_ocean_teal.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_t07_lime_fresh.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_t08_pink_passion.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_t09_amber_gold.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_t11_rose_red.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_t12_sky_blue.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_t13_violet_dream.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_t15_fuchsia_pop.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_v01_dark_mode.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_v02_light_pastel.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_v03_christmas.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_v04_halloween.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_v05_easter.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_v06_valentine.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_v07_summer_beach.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_v08_autumn_forest.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_v09_corporate_blue.dart` | 4 | 165, 192, 724, 764 |
| `design_system\theme\temas\theme_colors_v10_energetic_sport.dart` | 4 | 165, 192, 724, 764 |
| `design_system\components\cards\card_widgets.dart` | 4 | 5, 67, 150, 244 |
| `main.dart` | 3 | 15, 21, 29 |
| `app\app_providers.dart` | 3 | 8, 23, 36 |
| `modules\products\presentation\widgets\products_sync_footer.dart` | 3 | 112, 114, 116 |
| `modules\products\presentation\widgets\list\products_skeleton.dart` | 3 | 26, 40, 72 |
| `modules\products\presentation\widgets\list\product_card.dart` | 3 | 67, 260, 281 |
| `modules\products\presentation\widgets\qr\products_empty_state.dart` | 3 | 92, 101, 102 |
| `modules\dashboard\presentation\widgets\quick_actions_card.dart` | 3 | 59, 111, 112 |
| `modules\dashboard\presentation\widgets\sugestoes_ia_card.dart` | 3 | 18, 91, 189 |
| `modules\dashboard\presentation\widgets\navigation\dashboard_mobile_drawer.dart` | 3 | 6, 8, 89 |
| `features\tags\presentation\widgets\tags_alerts_card.dart` | 3 | 6, 9, 32 |
| `features\products\presentation\widgets\products_sync_footer.dart` | 3 | 112, 114, 116 |
| `features\products\presentation\widgets\list\products_skeleton.dart` | 3 | 26, 40, 72 |
| `features\products\presentation\widgets\list\product_card.dart` | 3 | 67, 260, 281 |
| `features\products\presentation\widgets\qr\products_empty_state.dart` | 3 | 92, 101, 102 |
| `features\pricing\data\repositories\pricing_repository.dart` | 3 | 26, 249, 296 |
| `features\import_export\data\repositories\import_export_repository.dart` | 3 | 43, 90, 142 |
| `modules\products\presentation\widgets\products_alerts_card.dart` | 2 | 119, 127 |
| `modules\products\presentation\widgets\products_quick_actions_card.dart` | 2 | 62, 73 |
| `modules\products\presentation\widgets\list\products_header.dart` | 2 | 5, 105 |
| `modules\products\presentation\widgets\list\product_filters.dart` | 2 | 34, 115 |
| `modules\dashboard\presentation\widgets\compact_alerts_card.dart` | 2 | 15, 108 |
| `modules\dashboard\presentation\widgets\estrategias_lucro_card.dart` | 2 | 73, 93 |
| `features\tags\presentation\screens\tags_list_screen.dart` | 2 | 779, 825 |
| `features\settings\presentation\screens\full_api_test_screen.dart` | 2 | 630, 635 |
| `features\products\presentation\widgets\products_alerts_card.dart` | 2 | 119, 127 |
| `features\products\presentation\widgets\products_quick_actions_card.dart` | 2 | 62, 73 |
| `features\products\presentation\widgets\list\product_filters.dart` | 2 | 34, 115 |
| `features\dashboard\presentation\widgets\alertas_acionaveis_card.dart` | 2 | 123, 205 |
| `design_system\theme\module_gradients.dart` | 2 | 4, 7 |
| `design_system\components\common\common_widgets.dart` | 2 | 102, 254 |
| `modules\products\presentation\widgets\products_catalog_summary.dart` | 1 | 59 |
| `modules\products\data\datasources\products_datasource.dart` | 1 | 13 |
| `modules\categories\presentation\providers\categories_provider.dart` | 1 | 102 |
| `features\tags\presentation\widgets\tags_status_summary.dart` | 1 | 6 |
| `features\sync\data\repositories\sync_repository.dart` | 1 | 249 |
| `features\products\presentation\screens\product_edit_screen.dart` | 1 | 393 |
| `features\products\presentation\widgets\products_catalog_summary.dart` | 1 | 59 |
| `features\products\data\datasources\products_datasource.dart` | 1 | 13 |
| `features\categories\presentation\providers\categories_provider.dart` | 1 | 102 |
| `core\constants\api_constants.dart` | 1 | 32 |
| `core\utils\responsive_cache.dart` | 1 | 4 |
| `core\utils\responsive_helper.dart` | 1 | 15 |

---

## 📝 DETALHAMENTO COMPLETO

### 📄 `modules\dashboard\presentation\screens\dashboard_screen.dart`

#### Linha 36

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
// Card de administrAÃ§Ã£o (PlatformAdmin / ClientAdmin)
```

#### Linha 38

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
// Widgets de navegAÃ§Ã£o extraÃ£dos
```

#### Linha 52

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  int _rebuildCounter = 0; // Contador para forÃ£ar rebuild ao clicar no mesmo menu
```

#### Linha 57

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // ValueKey dinÃ£mica usada em _getSelectedScreen() com _rebuildCounter
```

#### Linha 58

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // permite resetar mÃ£dulo ao clicar no mesmo menu
```

#### Linha 60

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // OTIMIZAÃ£Ã£O: Lista static const para evitar recriAÃ§Ã£o a cada rebuild
```

#### Linha 79 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'title': 'EstratÃ£gias',
```

#### Linha 84 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'title': 'SincronizAÃ§Ã£o',
```

#### Linha 89 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'title': 'PrecificAÃ§Ã£o',
```

#### Linha 99 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'title': 'ImportAÃ§Ã£o',
```

#### Linha 104 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'title': 'RelatÃ£rios',
```

#### Linha 109 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'title': 'ConfiguraÃ£Ã£es',
```

#### Linha 114

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Getter dinÃ£mico para dados de EstratÃ©gias baseado no provider
```

#### Linha 122

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Calcula ganhos das EstratÃ©gias
```

#### Linha 127

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Cores para cada estratÃ£gia
```

#### Linha 158 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        case 'produtos sem preÃ£o':
```

#### Linha 207

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Carrega os dados do dashboard apÃ£s o primeiro frame
```

#### Linha 229

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // OTIMIZAÃ£Ã£O: Reduzir cÃ£lculos e chamadas MediaQuery
```

#### Linha 238

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      final screenWidth = MediaQuery.sizeOf(context).width; // OTIMIZAÃ£Ã£O: sizeOf ã mais rÃ£pido
```

#### Linha 243

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Detectar se clicou nos extremos (primeiros 3 ou Ã£ltimos 3)
```

#### Linha 250

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // Clicou nos primeiros 3 ? rolar para o inÃ£cio (mostrando atÃ£ 3 menus)
```

#### Linha 253

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // Clicou nos Ã£ltimos 3 ? rolar para o final (mostrando atÃ£ 3 menus)
```

#### Linha 256

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // Clicou no meio ? centralizar o item ou rolar para deixar visÃ­vel
```

#### Linha 263

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // Item ã esquerda ? rolar para trÃ£s 3 menus
```

#### Linha 270

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          return; // JÃ£ estÃ£ visÃ­vel, nÃ£o rolar
```

#### Linha 282

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Keys para forÃ£ar rebuild quando clicar no mesmo menu
```

#### Linha 314

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // OTIMIZAÃ£Ã£O REMOVIDA: NÃ£o recriar GlobalKeys (causava rebuilds completos das telas)
```

#### Linha 315

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // GlobalKeys agora sÃ£o final e persistem durante toda vida Ã£til do widget
```

#### Linha 322

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Drawer para mobile - usando widget extraÃ£do
```

#### Linha 344

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // AppBar usando widget extraÃ£do
```

#### Linha 355

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    // Navigation rail apenas para tablet e desktop - usando widget extraÃ£do
```

#### Linha 376

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Bottom navigation para mobile - usando widget extraÃ£do
```

#### Linha 386

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Callbacks para os widgets de navegAÃ§Ã£o
```

#### Linha 389

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Clicou no mesmo menu - forÃ£a rebuild para voltar ao dashboard do mÃ£dulo
```

#### Linha 394

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Reinicia animAÃ§Ã£o de fade
```

#### Linha 404

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãµ` → `õ` (o com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Navega para tela de NotificaÃ§Ãµes (index 9 = Settings > NotificaÃ£Ã£es)
```

#### Linha 407 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        content: const Text('NotificaÃ£Ã£es em breve'),
```

#### Linha 415

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Mostra diÃ£logo de confirmAÃ§Ã£o de logout
```

#### Linha 445

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Navega para tela de perfil/configuraÃ£Ã£es
```

#### Linha 446

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    _onItemSelected(9); // Index 9 = ConfiguraÃ£Ã£es
```

#### Linha 450

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Mostra diÃ£logo de ajuda
```

#### Linha 465 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            Text('TagBean - Sistema de GestÃ£o de Etiquetas EletrÃ£nicas'),
```

#### Linha 467 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            Text('VersÃ£o: 1.0.0'),
```

#### Linha 484

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // MÃ£TODOS DE NAVEGAÃ£Ã£O REMOVIDOS - Agora usamos widgets extraÃ£dos:
```

#### Linha 490

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // MÃ©todos removidos: _buildMobileDrawer, _buildMobileBottomNav, _buildModernAppBar,
```

#### Linha 530

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    // Fazer scroll apenas se necessÃ£rio
```

#### Linha 687 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Sistema de GestÃ£o',
```

#### Linha 1241

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ObtÃ£m dados do UsuÃ¡rio logado
```

#### Linha 1243 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    final userName = user?.username ?? 'UsuÃ£rio';
```

#### Linha 1250

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // 1?? HEADER CONTEXTUAL (WelcomeSection jÃ£ integra sync)
```

#### Linha 1254

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // ?? SELETOR DE LOJA (apenas se UsuÃ¡rio tem mÃ£ltiplas lojas)
```

#### Linha 1265

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            onGerenciarClientes: () => _navigateTo(9), // ConfiguraÃ£Ã£es (com placeholder de clientes)
```

#### Linha 1266

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            onGerenciarLojas: () => _navigateTo(9), // ConfiguraÃ£Ã£es (com placeholder de lojas)
```

#### Linha 1267

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            onGerenciarUsuarios: () => _navigateTo(9), // ConfiguraÃ£Ã£es ? UsuÃ£rios
```

#### Linha 1268

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            onVerConfiguracoes: () => _navigateTo(9), // ConfiguraÃ£Ã£es
```

#### Linha 1272

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // ?? PRIMEIROS PASSOS (para UsuÃ¡rios novos - substitui atalhos de teclado)
```

#### Linha 1274

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            onImportProducts: () => _navigateTo(7), // ImportAÃ§Ã£o
```

#### Linha 1277

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            onActivateStrategy: () => _navigateTo(3), // EstratÃ£gias
```

#### Linha 1278

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            onConfigureStore: () => _navigateTo(9), // ConfiguraÃ£Ã£es
```

#### Linha 1282

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // ?? PRÃ£XIMA AÃ£Ã£O RECOMENDADA (IA sugere o que fazer)
```

#### Linha 1299

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            onCorrigirProdutos: () => _navigateTo(5), // PrecificAÃ§Ã£o
```

#### Linha 1304

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // 2?? ALERTAS ACIONÃ£VEIS (sÃ£ aparece se houver alertas)
```

#### Linha 1309

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            onVerProdutosSemPreco: () => _navigateTo(5), // PrecificAÃ§Ã£o
```

#### Linha 1314

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // ?? BLOCO 4: FLUXOS INTELIGENTES (se houver pendÃ£ncias)
```

#### Linha 1318

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            onVerErros: () => _navigateTo(7), // ImportAÃ§Ã£o
```

#### Linha 1329

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // ?? ATIVIDADE RECENTE (histÃ£rico do que aconteceu)
```

#### Linha 1332

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            onViewAll: () => _navigateTo(8), // RelatÃ£rios
```

#### Linha 1339

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Layout para dispositivos mÃ£veis - tudo empilhado verticalmente
```

#### Linha 1346

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          onVerDashboardCompleto: () => _navigateTo(8), // RelatÃ£rios
```

#### Linha 1352

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // 4?? AÃ£Ã£ES FREQUENTES
```

#### Linha 1363

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          onRevisarSugestoes: () => _navigateTo(3), // EstratÃ£gias
```

#### Linha 1368

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // 6?? ESTRATÃ£GIAS ATIVAS
```

#### Linha 1381

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // Primeira linha: Resumo + AÃ£Ã£es (altura uniforme)
```

#### Linha 1397

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // 4?? AÃ£Ã£ES FREQUENTES
```

#### Linha 1419

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // 6?? ESTRATÃ£GIAS ATIVAS - largura total
```

#### Linha 1427

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Dialog para aplicar sugestÃ£es automaticamente
```

#### Linha 1442 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: const Text('Aplicar SugestÃ£es da IA'),
```

#### Linha 1444 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Deseja aplicar automaticamente todas as sugestÃ£es de ajuste de preÃ£o?\n\n'
```

#### Linha 1445 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Esta AÃ§Ã£o irÃ£ atualizar os preÃ£os de todos os produtos recomendados.',
```

#### Linha 1456

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // TODO: Implementar aplicAÃ§Ã£o de sugestÃ£es
```

#### Linha 1463 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      Expanded(child: Text('SugestÃ£es aplicadas com sucesso!')),
```

#### Linha 1601 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Tudo funcionando perfeitamente.  Sistema sincronizado hÃ£ 3 horas.',
```

#### Linha 1627 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      {'label': 'SincronizaÃ£Ã£es', 'valor': '42', 'icon': Icons.sync_rounded, 'cor': ThemeColors.of(context).blueCyan, 'mudanca': '+3', 'tipo': 'aumento'},
```

#### Linha 1793

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // OTIMIZAÃ£Ã£O: RepaintBoundary para isolar repaints
```

#### Linha 1801

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // OTIMIZAÃ£Ã£O: Reduzir blur de sombra para melhor performance
```

#### Linha 2051 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'EstratÃ£gias Ativas',
```

#### Linha 2156 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'Lucro com EstratÃ£gias',
```

#### Linha 2181 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        '${_estrategiasData['ativas']} EstratÃ©gias ativas',
```

#### Linha 2413

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ObtÃ£m contagem de produtos afetados pelas EstratÃ©gias ativas
```

#### Linha 2501 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'SugestÃ£es Inteligentes',
```

#### Linha 2607 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      '24 promoÃ£Ã£es',
```

#### Linha 2767 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'Performance por EstratÃ£gia',
```

#### Linha 3085 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Ã£ltima SincronizAÃ§Ã£o',
```

#### Linha 3106 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Status: ConcluÃ£da com sucesso',
```

#### Linha 3272 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      '23/11/2025 Ã£s 14:32',
```

#### Linha 3452 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'Requer atenÃ£Ã£o imediata',
```

#### Linha 3612 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'AÃ£Ã£es RÃ£pidas',
```

#### Linha 3762

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // NOTA: MÃ£todo _buildRecentActivityCard() removido
```

#### Linha 3763

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // O dashboard usa o widget RecentActivityCard que ã dinÃ£mico
```

#### Linha 3863 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                              'Requer atenÃ£Ã£o imediata',
```

#### Linha 3926

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// ForÃ£a sincronizAÃ§Ã£o imediata
```

#### Linha 3949

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // TODO: Implementar chamada real de sincronizAÃ§Ã£o
```

#### Linha 3964 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            _buildStatusRow(context, 'ConexÃ£o', 'Conectado', ThemeColors.of(context).greenMain),
```

#### Linha 3966 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            _buildStatusRow(context, 'Ã£ltima sincronizAÃ§Ã£o', 'HÃ£ 5 minutos', ThemeColors.of(context).blueMain),
```

#### Linha 3968 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            _buildStatusRow(context, 'PendÃ£ncias', '0 itens', ThemeColors.of(context).textSecondary),
```

#### Linha 4017 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Aqui vocÃ£ pode ver todos os fluxos inteligentes que precisam de sua atenÃ£Ã£o.',
```

#### Linha 4030

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Abre busca rÃ£pida
```

#### Linha 4267

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // FunÃ£Ã£es auxiliares para determinar cores dos cards de alerta baseado na cor do alerta
```

#### Linha 4279

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Fallback para cor genÃ£rica
```

#### Linha 4294

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Fallback para cor genÃ£rica
```

#### Linha 4304 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (tipo.contains('sem preÃ£o') || tipo.contains('sem_preco')) {
```

#### Linha 4305

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Navegar para produtos sem preÃ£o
```

#### Linha 4320 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              const Text('Filtro aplicado: Produtos sem preÃ£o'),
```

#### Linha 4333

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Navegar para precificAÃ§Ã£o
```

#### Linha 4334

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      setState(() => _selectedIndex = 5); // PrecificAÃ§Ã£o
```

#### Linha 4336

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Navegar para relatÃ£rios
```

#### Linha 4337

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      setState(() => _selectedIndex = 8); // RelatÃ£rios
```

#### Linha 4361

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Depois de um breve delay, mostra feedback para UsuÃ¡rio
```

#### Linha 4377 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                child: Text('Use o botÃ£o "+" para adicionar um novo produto'),
```

#### Linha 4449 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'NotificaÃ£Ã£es',
```

#### Linha 4476

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Usa alertas dinÃ£micos do provider
```

#### Linha 4648 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Confirmar SaÃ£da',
```

#### Linha 4729

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// SearchDelegate para busca rÃ£pida no TagBean
```

#### Linha 4802 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Digite um nome, cÃ£digo ou MAC',
```

#### Linha 4817 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      {'tipo': 'produto', 'nome': 'Arroz Tio JoÃ£o 5kg', 'codigo': '7891000123456', 'preco': 'R\$ 29,90'},
```

#### Linha 4873 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            isProduto ? r['codigo'] ?? '' : r['produto'] ?? 'Sem vÃ£nculo',
```

---

### 📄 `modules\products\presentation\screens\products_dashboard_screen.dart`

#### Linha 45

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Acesso rÃ£pido aos providers
```

#### Linha 97

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Carrega preferÃ£ncia do onboarding
```

#### Linha 105

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Salva preferÃ£ncia do onboarding
```

#### Linha 190

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // EstatÃ£sticas do provider ou valores default
```

#### Linha 200

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Verifica condiÃ£Ã£es para onboarding contextual
```

#### Linha 203

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (_totalProdutos == 0) return true; // CatÃ£logo vazio
```

#### Linha 209 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (_totalProdutos == 0) return 'Comece seu catÃ£logo adicionando produtos!';
```

#### Linha 210 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (_semTag > 0) return 'vocÃª tem $_semTag produtos sem tag vinculada';
```

#### Linha 218 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (diff.inMinutes < 60) return 'hÃ£ ${diff.inMinutes} min';
```

#### Linha 219 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (diff.inHours < 24) return 'hÃ£ ${diff.inHours}hÃ£';
```

#### Linha 220 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    return 'hÃ£ ${diff.inDays}d';
```

#### Linha 223

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// HEADER - Com sync status, voltar, sincronizar e configuraÃ£Ã£es
```

#### Linha 249

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Ã­cone e TÃ£tulo
```

#### Linha 280 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'GestÃ£o de catÃ£logo',
```

#### Linha 291

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Status de SincronizAÃ§Ã£o
```

#### Linha 323

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o Sincronizar
```

#### Linha 340

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o ConfiguraÃ£Ã£es
```

#### Linha 348 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            tooltip: 'ConfiguraÃ£Ã£es',
```

#### Linha 376 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'ConfiguraÃ£Ã£es de Produtos',
```

#### Linha 391 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              subtitle: Text('Exibir dicas e sugestÃ£es'),
```

#### Linha 405 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              title: Text('SincronizAÃ§Ã£o automÃ£tica'),
```

#### Linha 431

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se catÃ£logo vazio, mostrar FAB para adicionar primeiro produto
```

#### Linha 433

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Se oculto, mostrar apenas botÃ£o pequeno para reexibir
```

#### Linha 442

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // FAB extendido com botÃ£o de fechar
```

#### Linha 477

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Normal: FAB com menu de aÃ£Ã£es RÃ¡pidas
```

#### Linha 508 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'AÃ£Ã£es RÃ£pidas',
```

#### Linha 622

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // SEÇÃO 1: Header
```

#### Linha 632

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // SEÇÃO 2: Busca Global
```

#### Linha 636

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // SEÇÃO 3: Onboarding Contextual (condicional)
```

#### Linha 642

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // SEÇÃO 4: Resumo do CatÃ£logo (5 cards clicÃ£veis)
```

#### Linha 649

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // SEÇÃO 5: AÃ£Ã£es RÃ£pidas + Produtos em Destaque (2 colunas)
```

#### Linha 653

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // SEÇÃO 6: Categorias
```

#### Linha 657

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // SEÇÃO 7: Mapa do MÃ£dulo (todos os menus disponÃ­veis)
```

#### Linha 669

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// SEÇÃO 2: Busca Global com Scanner
```

#### Linha 699 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  hintText: 'Buscar produto, cÃ£digo, categoria...',
```

#### Linha 722

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o Scanner
```

#### Linha 744

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// SEÇÃO 3: Onboarding Contextual
```

#### Linha 780 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'PrÃ£ximo Passo',
```

#### Linha 844

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// SEÇÃO 4: Resumo do CatÃ£logo - 5 Cards ClicÃ£veis
```

#### Linha 866 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Resumo do CatÃ£logo',
```

#### Linha 1070

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// VersÃ£o expandida para Row (desktop)
```

#### Linha 1162 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Carregando estatÃ£sticas...',
```

#### Linha 1171

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// SEÇÃO 5: AÃ£Ã£es RÃ£pidas + Produtos em Destaque (2 colunas)
```

#### Linha 1232 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'subtitle': 'Entradas e saÃ­das',
```

#### Linha 1261 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'AÃ£Ã£es RÃ£pidas',
```

#### Linha 1381

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // TÃ£tulo
```

#### Linha 1401

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // SeÃ£Ã£o: Atualizados Recentemente
```

#### Linha 1492

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o Ver HistÃ£rico
```

#### Linha 1497 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              label: Text('Ver HistÃ£rico Completo', style: TextStyle(fontSize: 11)),
```

#### Linha 1509

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// SEÇÃO 6: Categorias com Chips e botÃ£o + Nova
```

#### Linha 1577 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'As categorias aparecerÃ£o aqui quando vocÃ£ adicionar produtos',
```

#### Linha 1658

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// SEÇÃO 7: Mapa do MÃ£dulo - Todos os menus disponÃ­veis em cards pequenos
```

#### Linha 1663

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Lista de todos os menus/telas disponÃ­veis no mÃ£dulo
```

#### Linha 1667 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        subtitulo: 'VisÃ£o geral',
```

#### Linha 1674 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        subtitulo: 'CatÃ£logo completo',
```

#### Linha 1702 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        subtitulo: 'GestÃ£o de inventÃ£rio',
```

#### Linha 1709 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        subtitulo: 'OrganizAÃ§Ã£o',
```

#### Linha 1713

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Scroll para seÃ£Ã£o de categorias ou modal
```

#### Linha 1720 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        titulo: 'RelatÃ£rios',
```

#### Linha 1721 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        subtitulo: 'AnÃ¡lises',
```

#### Linha 1727 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              content: Text('RelatÃ£rios em desenvolvimento'),
```

#### Linha 1746

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // TÃ£tulo da seÃ£Ã£o
```

#### Linha 1767 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Mapa do MÃ£dulo',
```

#### Linha 1775 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Acesso rÃ£pido a todas as funcionalidades',
```

#### Linha 1792

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Calcular tamanho do card baseado na largura disponÃ£vel
```

#### Linha 1798

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              final cardHeight = cardWidth * 0.85; // ProporÃ£Ã£o mais quadrada
```

#### Linha 1888

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // MÃ£todo antigo mantido para compatibilidade
```

#### Linha 1950

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Classe auxiliar para itens do mapa do mÃ£dulo
```

---

### 📄 `modules\products\presentation\screens\products_list_screen.dart`

#### Linha 41

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Estado de seleÃ£Ã£o mÃ£ltipla
```

#### Linha 45

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Estado de ordenAÃ§Ã£o e loading
```

#### Linha 49

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Acesso rÃ£pido ao state do provider
```

#### Linha 120

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // MÃ©todos de seleÃ£Ã£o mÃ£ltipla
```

#### Linha 169

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // AÃ£Ã£es em lote
```

#### Linha 171

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Navega para tela de associAÃ§Ã£o QR com contexto de batch
```

#### Linha 221 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    ? 'PREÃ‡O atualizado para ${productIds.length} produtos'
```

#### Linha 222 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    : 'Erro ao atualizar preÃ£os',
```

#### Linha 237

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Extrai categorias Ã£nicas dos produtos carregados
```

#### Linha 288 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Tem certeza que deseja excluir ${_selectedProducts.length} produtos?\n\nEsta AÃ§Ã£o nÃ£o pode ser desfeita.',
```

#### Linha 309 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        ? '$deletedCount produtos excluÃ£dos'
```

#### Linha 328

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Scroll para carregar mais (paginaÃ§Ã£o infinita)
```

#### Linha 373

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // MantÃ£m ordem original (mais recentes primeiro)
```

#### Linha 379

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // EstatÃ£sticas do provider
```

#### Linha 395

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se tem callback onBack, significa que estÃ£ dentro do dashboard
```

#### Linha 407

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // Header com modo seleÃ£Ã£o
```

#### Linha 447

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // Barra de aÃ£Ã£es em lote
```

#### Linha 460

**Padroes encontrados:**
- `Ã³` → `ó` (o com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Modo standalone com Navigator prÃ³prio
```

#### Linha 603 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'GestÃ£o de catÃ£logo e precificAÃ§Ã£o',
```

#### Linha 709 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Sobre este MÃ£dulo',
```

#### Linha 719 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Gerencie seu catÃ£logo completo de produtos com controle de preÃ£os, estoque, categorias e associAÃ§Ã£o automÃ£tica com etiquetas eletrÃ£nicas.',
```

#### Linha 778 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              hintText: 'Buscar por nome ou cÃ£digo...',
```

#### Linha 854 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  items: ['Todas', 'Bebidas', 'Mercearia', 'PerecÃ£veis', 'Limpeza', 'Higiene']
```

#### Linha 996

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Indicador de loading na paginaÃ§Ã£o
```

#### Linha 1079

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // Checkbox 24x24 quando em modo de seleÃ£Ã£o
```

#### Linha 1180

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        // Categoria • CÃ£digo
```

#### Linha 1247

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      // PREÃ‡O ou Alert
```

#### Linha 1249

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        // Alerta visual para produto sem preÃ£o
```

#### Linha 1270 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                                'Sem preÃ£o',
```

#### Linha 1324

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      // Status de sincronizAÃ§Ã£o Minew
```

#### Linha 1440

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// ConstrÃ£i badge de status de sincronizAÃ§Ã£o Minew
```

#### Linha 1511 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        content: Text('Deseja remover a vinculAÃ§Ã£o da tag "${produto.tag}" do produto "${produto.nome}"?'),
```

#### Linha 1521

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // ImplementAÃ§Ã£o da desvinculAÃ§Ã£o via provider
```

#### Linha 1553

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Cria cÃ£pia do produto com novo ID
```

#### Linha 1555 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      id: '', // SerÃ£ gerado pelo backend
```

#### Linha 1557 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      nome: 'CÃ£pia de ${produto.nome}',
```

#### Linha 1567

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Navega para EdiÃ§Ã£o para o UsuÃ¡rio ajustar antes de salvar
```

#### Linha 1689

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // Ã­cone grande
```

#### Linha 1712

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // TÃ£tulo
```

#### Linha 1724

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // DescriÃ£Ã£o
```

#### Linha 1727 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  ? 'Importe uma planilha ou adicione produtos manualmente\npara comeÃ§ar a usar o sistema ESL.'
```

#### Linha 1728 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  : 'NÃ£o encontramos produtos com "${state.searchQuery}".\nDeseja criar um novo produto?',
```

#### Linha 1738

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // BotÃ£es de AÃ§Ã£o
```

#### Linha 1740

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // BotÃ£o principal - Importar
```

#### Linha 1745

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    // Navegar para importAÃ§Ã£o
```

#### Linha 1772

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // BotÃ£o secundÃ£rio - Adicionar manualmente
```

#### Linha 1802

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // BotÃ£es para resultado de busca vazio
```

#### Linha 1921 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: Text('Confirmar ExclusÃ£o', style: TextStyle(fontSize: AppTextStyles.fontSizeXlAlt.get(isMobile, isTablet))),
```

#### Linha 1923 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Deseja realmente excluir "${produto.nome}"?\n\nEsta AÃ§Ã£o nÃ£o pode ser desfeita.',
```

#### Linha 1955 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                              Text('Produto ExcluÃ£do!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet))),
```

#### Linha 2008 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            tooltip: 'Cancelar seleÃ£Ã£o',
```

#### Linha 2034

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o selecionar todos
```

#### Linha 2097

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // Editar PREÃ‡Os
```

#### Linha 2099 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              label: 'PREÃ‡Os',
```

#### Linha 2171

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
// Dialog para EdiÃ§Ã£o de preÃ£o em lote
```

#### Linha 2198 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      title: const Text('Editar PREÃ‡Os em Lote'),
```

#### Linha 2224 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              labelText: _priceMode == 'fixed' ? 'Novo PREÃ‡O (R\$)' : 'Porcentagem (%)',
```

#### Linha 2255

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
// Dialog para alterAÃ§Ã£o de categoria em lote
```

---

### 📄 `modules\products\presentation\screens\product_details_screen.dart`

#### Linha 14

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// ImplementAÃ§Ã£o conforme PROMOT PRODUTOS.txt
```

#### Linha 15

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Hero section, Quick actions, Tabs (InformaÃ£Ã£es, Estoque, HistÃ£rico, EstratÃ£gias)
```

#### Linha 61

**Padroes encontrados:**
- `Ãµ` → `õ` (o com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Header com BotÃµes Voltar, Editar e Menu
```

#### Linha 72

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // BotÃ£o Editar
```

#### Linha 160 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  Tab(text: 'InformaÃ£Ã£es'),
```

#### Linha 162 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  Tab(text: 'HistÃ£rico'),
```

#### Linha 163 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  Tab(text: 'EstratÃ£gias'),
```

#### Linha 226

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // InformaÃ£Ã£es Principais
```

#### Linha 261

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // PREÃ‡O e Tag Status
```

#### Linha 264

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    // PREÃ‡O
```

#### Linha 404 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              label: 'Alterar\nPREÃ‡O',
```

#### Linha 499

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // ========== TAB 1: INFORMAÃ£Ã£ES ==========
```

#### Linha 508 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildInfoItem(context, 'CÃ£digo de Barras', _product.codigo, Icons.qr_code_rounded),
```

#### Linha 513 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildInfoItem(context, 'DimensÃ£es', '15x15x30 cm', Icons.square_foot_rounded),
```

#### Linha 523 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildInfoItem(context, 'Ã£ltima AtualizAÃ§Ã£o', DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()), Icons.update_rounded),
```

#### Linha 529 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildInfoCard(context, title: 'DescriÃ£Ã£o',
```

#### Linha 532 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                _product.descricao ?? 'Sem descriÃ£Ã£o disponÃ£vel.',
```

#### Linha 662 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      label: Text('SaÃ£da'),
```

#### Linha 675

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Estoque MÃ£nimo
```

#### Linha 692 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'Estoque MÃ£nimo',
```

#### Linha 718

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // grÃ¡fico de MovimentaÃ£Ã£es (placeholder)
```

#### Linha 731 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'MovimentaÃ£Ã£es (Ã£ltimos 30 dias)',
```

#### Linha 740 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'grÃ¡fico de movimentaÃ£Ã£es\n(a ser implementado)',
```

#### Linha 754

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // ========== TAB 3: HISTÃ£RICO ==========
```

#### Linha 764 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'HistÃ£rico de AlteraÃ£Ã£es',
```

#### Linha 785 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Nenhuma alterAÃ§Ã£o registrada',
```

#### Linha 830 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                              'AlterAÃ§Ã£o de PREÃ‡O',
```

#### Linha 875

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // ========== TAB 4: ESTRATÃ£GIAS ==========
```

#### Linha 883 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'EstratÃ£gias Ativas',
```

#### Linha 903 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Nenhuma estratÃ£gia ativa',
```

#### Linha 913 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    label: Text('Criar EstratÃ£gia'),
```

#### Linha 951 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        content: Text('Deseja remover a vinculAÃ§Ã£o da tag "${_product.tag}" deste produto?'),
```

#### Linha 977 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: Text('Alterar PREÃ‡O'),
```

#### Linha 982 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            labelText: 'Novo PREÃ‡O',
```

#### Linha 996 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                SnackBar(content: Text('PREÃ‡O atualizado com sucesso')),
```

#### Linha 1011 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: Text(isEntrada ? 'Entrada de Estoque' : 'SaÃ£da de Estoque'),
```

#### Linha 1043 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: Text('RelatÃ£rio de Vendas'),
```

#### Linha 1044 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        content: Text('Funcionalidade em desenvolvimento.\n\nEm breve vocÃ£ poderÃ£ visualizar o histÃ£rico de vendas deste produto.'),
```

#### Linha 1060 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: Text('Confirmar ExclusÃ£o'),
```

#### Linha 1061 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        content: Text('Deseja realmente excluir "${_product.nome}"?\n\nEsta AÃ§Ã£o nÃ£o pode ser desfeita.'),
```

#### Linha 1073 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  content: Text('Produto excluÃ£do com sucesso'),
```

---

### 📄 `modules\products\presentation\screens\product_add_screen.dart`

#### Linha 16

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Tela de adiÃ£Ã£o de novo produto com Wizard de 3 passos
```

#### Linha 18

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// - Passo 1: InformaÃ£Ã£es BÃ£sicas (CÃ£digo, Nome, Categoria, DescriÃ£Ã£o)
```

#### Linha 19

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// - Passo 2: PREÃ‡O (PREÃ‡O de venda, PREÃ‡O por kg, Custo)
```

#### Linha 20

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// - Passo 3: Confirmar (Resumo + opÃ£Ã£o de vincular tag)
```

#### Linha 23

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  final ProductModel? initialProduct; // Para duplicaÃ§Ã£o de produtos
```

#### Linha 43

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Focus nodes para navegAÃ§Ã£o
```

#### Linha 63

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // ValidAÃ§Ã£o em tempo real
```

#### Linha 74 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  List<String> get _categoriasFallback => ['Bebidas', 'Mercearia', 'PerecÃ£veis', 'Limpeza', 'Higiene'];
```

#### Linha 87

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Inicializa com dados do produto inicial (duplicaÃ§Ã£o)
```

#### Linha 101

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Listeners para detectar alteraÃ£Ã£es
```

#### Linha 109

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Focus AutomÃ¡tico no primeiro campo e carrega categorias apÃ£s build
```

#### Linha 131

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Se a categoria atual nÃ£o existir nas carregadas, define a primeira
```

#### Linha 139

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Fallback silencioso - usa categorias padrÃ£o do CategoryThemes
```

#### Linha 148

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// ConstrÃ£i os chips de categoria usando dados do backend ou fallback
```

#### Linha 258 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã³` → `ó` (o com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        _showValidationError('Complete todos os campos obrigatÃ³rios do Passo 1');
```

#### Linha 262 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        _showValidationError('Informe um preÃ£o vÃ¡lido maior que zero');
```

#### Linha 531 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    final steps = ['InformaÃ£Ã£es', 'PREÃ‡O', 'Confirmar'];
```

#### Linha 667 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                              'Escanear CÃ£digo de Barras',
```

#### Linha 671 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                              'Toque para abrir a cÃ£mera ou digite manualmente',
```

#### Linha 692 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    label: 'CÃ£digo de Barras *',
```

#### Linha 693 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    hint: 'MÃ£nimo 8 dÃ­gitos',
```

#### Linha 733 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'InformaÃ£Ã£es do Produto',
```

#### Linha 757 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    hint: 'MÃ£nimo 3 caracteres',
```

#### Linha 787 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    label: 'DescriÃ£Ã£o (opcional)',
```

#### Linha 788 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    hint: 'DescriÃ£Ã£o detalhada do produto',
```

#### Linha 837 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'PREÃ‡O de Venda',
```

#### Linha 860 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  label: 'PREÃ‡O de Venda (R\$) *',
```

#### Linha 870 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Este ã o preÃ£o que serÃ¡ exibido na etiqueta ESL',
```

#### Linha 911 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                            'PREÃ‡Os Adicionais',
```

#### Linha 932 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        label: 'PREÃ‡O por Kg (R\$)',
```

#### Linha 1120 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                _buildResumoItem(context, 'CÃ£digo de Barras', _codigoController.text, Icons.qr_code_rounded),
```

#### Linha 1123 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                _buildResumoItem(context, 'PREÃ‡O', 'R\$ ${preco.toStringAsFixed(2)}', Icons.attach_money_rounded),
```

#### Linha 1125 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  _buildResumoItem(context, 'PREÃ‡O/Kg', 'R\$ ${precoKg.toStringAsFixed(2)}', Icons.monitor_weight_rounded),
```

#### Linha 1127 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  _buildResumoItem(context, 'DescriÃ£Ã£o', _descricaoController.text, Icons.description_rounded),
```

#### Linha 1155 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Vincular etiqueta ESL apÃ£s criar',
```

#### Linha 1161 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Abrir tela de vinculAÃ§Ã£o de tags automaticamente',
```

#### Linha 1201 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Revise os dados antes de salvar. vocÃª poderÃ£ editar o produto posteriormente.',
```

#### Linha 1316 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    label: const Text('PrÃ£ximo'),
```

#### Linha 1447 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'vocÃª tem dados nÃ£o salvos. Deseja descartar todas as alteraÃ£Ã£es?',
```

#### Linha 1475 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              child: Text('Scanner de cÃ£digo de barras em desenvolvimento. Digite o cÃ£digo manualmente.'),
```

---

### 📄 `features\products\presentation\providers\products_state_provider.dart`

#### Linha 18

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
// Nota: PriceHistoryItem e PriceHistoryModel sÃ£o definidos em product_models.dart
```

#### Linha 19

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
// O import jÃ£ traz essas definiÃ£Ã£es, entÃ£o nÃ£o precisamos redefinir aqui
```

#### Linha 147

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // RepositÃ£rio nÃ£o disponÃ£vel - mostrar erro
```

#### Linha 150 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          error: 'RepositÃ£rio de produtos nÃ£o configurado',
```

#### Linha 161

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Carrega mais produtos (paginaÃ§Ã£o)
```

#### Linha 290

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Exclui mÃ£ltiplos produtos em lote
```

#### Linha 327

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Atualiza preÃ£os em lote
```

#### Linha 341 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          state = state.copyWith(error: 'StoreId ã obrigatÃ£rio para operaÃ£Ã£es em lote');
```

#### Linha 353

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Recarrega produtos para ter os preÃ£os atualizados
```

#### Linha 379 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      state = state.copyWith(error: 'Erro ao atualizar preÃ£os: $e');
```

#### Linha 396 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          state = state.copyWith(error: 'StoreId ã obrigatÃ£rio para operaÃ£Ã£es em lote');
```

#### Linha 440 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          state = state.copyWith(error: 'StoreId ã obrigatÃ£rio para operaÃ£Ã£es em lote');
```

#### Linha 614

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Carrega estatÃ£sticas do backend
```

#### Linha 646

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Carregar estatÃ£sticas por categoria se disponÃ£vel
```

#### Linha 673

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Fallback: valores zerados se nÃ£o houver repositÃ£rio ou resposta
```

#### Linha 705 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (lower.contains('perecÃ£') || lower.contains('pereci')) return CategoryThemes.pereciveis.icon;
```

#### Linha 719 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (lower.contains('perecÃ£') || lower.contains('pereci')) return CategoryThemes.pereciveis.color;
```

#### Linha 734

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Atualiza estatÃ£sticas baseado na lista de produtos
```

#### Linha 767

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
// O fromJson agora suporta tanto campos em portuguÃ£s quanto em inglÃ¡s
```

#### Linha 835

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Buscar histÃ£rico de preÃ£os do backend
```

#### Linha 845

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // Se falhar ao buscar histÃ£rico, continua sem ele
```

#### Linha 846 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            debugPrint('Erro ao buscar histÃ£rico de preÃ£os: $e');
```

#### Linha 849

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Buscar estatÃ£sticas de vendas do backend
```

#### Linha 857

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // Se falhar ao buscar estatÃ£sticas, continua sem elas
```

#### Linha 858 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            debugPrint('Erro ao buscar estatÃ£sticas: $e');
```

#### Linha 876 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        error: 'Produto nÃ£o encontrado',
```

#### Linha 943 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (emAlerta || estoqueAtual <= estoqueMinimo) return 'CrÃ£tico';
```

#### Linha 1121

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Fallback: lista vazia se nÃ£o houver repositÃ£rio ou resposta
```

#### Linha 1358

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // ValidaÃ£Ã£es
```

#### Linha 1360 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          erros.add('CÃ£digo curto (mÃ£n 8)');
```

#### Linha 1363 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          erros.add('Nome obrigatÃ£rio');
```

#### Linha 1366 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          erros.add('PREÃ‡O invÃ¡lido');
```

#### Linha 1395

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Executa importAÃ§Ã£o
```

#### Linha 1451

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // RepositÃ£rio nÃ£o disponÃ£vel
```

#### Linha 1457 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              erro: 'RepositÃ£rio nÃ£o configurado',
```

#### Linha 1620

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // RepositÃ£rio nÃ£o disponÃ£vel
```

#### Linha 1623 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          error: 'RepositÃ£rio de tags nÃ£o configurado ou dados incompletos',
```

#### Linha 1757

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Provider de estatÃ£sticas de produtos (Riverpod StateNotifier) - CONECTADO ã API
```

#### Linha 1775

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Provider de importAÃ§Ã£o de produtos
```

#### Linha 1781

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Provider de vinculAÃ§Ã£o Tag/QR - CONECTADO ã API
```

---

### 📄 `features\import_export\presentation\screens\batch_operations_screen.dart`

#### Linha 26

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // OperaÃ£Ã£es via provider (com fallback para lista estÃ£tica enquanto carrega)
```

#### Linha 30

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // OperaÃ£Ã£es estÃ£ticas disponÃ­veis
```

#### Linha 33 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'titulo': 'Atualizar PREÃ‡Os em Lote',
```

#### Linha 34 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'subtitulo': 'Upload planilha: CÃ£digo | Novo PREÃ‡O',
```

#### Linha 35 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'descricao': 'Altere mÃ£ltiplos preÃ£os simultaneamente via Excel/CSV',
```

#### Linha 36 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'descricaoDetalhada': 'Permite atualizar preÃ£os de centenas de produtos de uma sÃ£ vez. Ideal para reajustes gerais ou promoÃ£Ã£es em massa.',
```

#### Linha 40 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'colunas': ['CÃ£digo de Barras', 'Novo PREÃ‡O', 'PREÃ‡O/Kg (opcional)'],
```

#### Linha 46 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã³` → `ó` (o com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'subtitulo': 'Upload lista de cÃ³digos de barras',
```

#### Linha 47 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'descricao': 'Remova mÃ£ltiplos produtos do sistema de uma sÃ£ vez',
```

#### Linha 48 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'descricaoDetalhada': 'ExclusÃ£o massiva de produtos. Ã£til para limpeza de cadastros antigos ou produtos descontinuados.',
```

#### Linha 52 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'colunas': ['CÃ£digo de Barras'],
```

#### Linha 58 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'subtitulo': 'Upload: ID Tag | CÃ£digo Produto',
```

#### Linha 60 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'descricaoDetalhada': 'AssociAÃ§Ã£o rÃ£pida entre etiquetas eletrÃ£nicas e produtos. Perfeito para instalAÃ§Ã£o inicial ou reorganizaÃ§Ã£o.',
```

#### Linha 64 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'colunas': ['ID da Tag', 'CÃ£digo de Barras do Produto'],
```

#### Linha 71 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'descricao': 'Mude categorias de mÃ£ltiplos produtos',
```

#### Linha 72 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'descricaoDetalhada': 'Reorganize o catÃ£logo alterando categorias de vÃ£rios produtos simultaneamente.',
```

#### Linha 76 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'colunas': ['CÃ£digo de Barras', 'Nova Categoria'],
```

#### Linha 82 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'subtitulo': 'Remover vÃ£nculos tag-produto',
```

#### Linha 83 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'descricao': 'Desvincula mÃ£ltiplas tags dos produtos',
```

#### Linha 84 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'descricaoDetalhada': 'Remove a associAÃ§Ã£o entre tags e produtos. Ã£til para manutenÃ£Ã£o ou reorganizaÃ§Ã£o do sistema.',
```

#### Linha 94 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'subtitulo': 'Ajustar quantidades disponÃ­veis',
```

#### Linha 95 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'descricao': 'Atualize estoque de mÃ£ltiplos produtos',
```

#### Linha 96 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'descricaoDetalhada': 'Sincronize estoque massivamente apÃ£s inventÃ£rios ou recebimentos grandes.',
```

#### Linha 100 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'colunas': ['CÃ£digo de Barras', 'Quantidade'],
```

#### Linha 129

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Carregar operaÃ£Ã£es disponÃ­veis
```

#### Linha 168 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'OperaÃ£Ã£es DisponÃ£veis',
```

#### Linha 185 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'Escolha a operAÃ§Ã£o que deseja executar',
```

#### Linha 311 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'OperaÃ£Ã£es em Lote',
```

#### Linha 333 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'AÃ£Ã£es Massivas no Sistema',
```

#### Linha 384 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'AvanÃ£ado',
```

#### Linha 453 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'atenÃ§Ã£o - OperaÃ£Ã£es IrreversÃ£veis',
```

#### Linha 476 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'As operaÃ£Ã£es em lote sÃ£o permanentes. Revise os dados antes de executar.',
```

#### Linha 664 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                                'Template disponÃ£vel',
```

#### Linha 1173 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            const Text('Confirmar OperAÃ§Ã£o'),
```

#### Linha 1180 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            const Text('vocÃª estÃ£ prestes a executar:'),
```

#### Linha 1207 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Esta operAÃ§Ã£o ã irreversÃ£vel! ',
```

#### Linha 1249 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'Processando operAÃ§Ã£o...',
```

#### Linha 1266

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Executar operAÃ§Ã£o em lote via provider
```

#### Linha 1285 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                              'OperAÃ§Ã£o ConcluÃ­da: ${result.successCount} de ${result.totalRecords} registros',
```

#### Linha 1300 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      content: Text(_state.errorMessage ?? 'Erro ao executar operAÃ§Ã£o'),
```

---

### 📄 `features\auth\presentation\widgets\store_switcher.dart`

#### Linha 11

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Widget de seleÃ£Ã£o de loja com dropdown e botÃ£o de confirmAÃ§Ã£o
```

#### Linha 12

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Exibe a loja atual e permite trocar para outra loja disponÃ£vel
```

#### Linha 20

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Se deve mostrar o botÃ£o de confirmAÃ§Ã£o
```

#### Linha 55

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se nÃ£o tem mÃ£ltiplas lojas, nÃ£o mostrar o seletor
```

#### Linha 60

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Atualizar seleÃ£Ã£o se o contexto mudou externamente
```

#### Linha 88

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Ã­cone da loja
```

#### Linha 103

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Dropdown de seleÃ£Ã£o
```

#### Linha 108

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o de confirmAÃ§Ã£o
```

#### Linha 118

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Exibe apenas o nome da loja quando hÃ£ apenas uma
```

#### Linha 147

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// ConstrÃ£i o dropdown de seleÃ£Ã£o
```

#### Linha 202

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // Se nÃ£o tem botÃ£o de confirmAÃ§Ã£o, trocar imediatamente
```

#### Linha 211

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// ConstrÃ£i o botÃ£o de confirmAÃ§Ã£o
```

#### Linha 247

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Verifica se a seleÃ£Ã£o foi alterada
```

#### Linha 297

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Reverter seleÃ£Ã£o
```

#### Linha 312

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// VersÃ£o com dropdown hierÃ£rquico expansÃ£vel
```

#### Linha 313 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Mostra: Cliente > Lojas com opÃ£Ã£o "Todas as lojas" para admins
```

#### Linha 330

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  bool _isExpanded = false; // Controla se a lista estÃ£ expandida
```

#### Linha 351

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Sempre mostrar o card para UsuÃ¡rios com acesso a lojas
```

#### Linha 354 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Verifica se estÃ£ em modo "Todas as lojas"
```

#### Linha 370

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Header clicÃ£vel (sempre visÃ­vel)
```

#### Linha 380

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // Ã­cone principal
```

#### Linha 447

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // Seta de expansÃ£o (se tem mÃ£ltiplas opÃ£Ã£es)
```

#### Linha 470

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Lista expandÃ£vel de lojas
```

#### Linha 484

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      constraints: const BoxConstraints(maxHeight: 400), // Limita altura mÃ£xima
```

#### Linha 500 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // OpÃ£Ã£o "Todas as lojas" (apenas para admins)
```

#### Linha 530

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // BotÃ£o de confirmAÃ§Ã£o
```

#### Linha 583 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// OpÃ£Ã£o "Todas as lojas" para administradores
```

#### Linha 702

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // NÃ£mero da loja na hierarquia
```

#### Linha 725

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Ã­cone da loja
```

#### Linha 782

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Indicador de seleÃ£Ã£o
```

#### Linha 828 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      message: 'vocÃª estÃ£ trocando de "$oldStoreName" para "$selectedStoreName".\n\n'
```

#### Linha 829 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Os seguintes dados serÃ¡o recarregados:\n'
```

#### Linha 832 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'ã PREÃ‡Os e EstratÃ©gias\n'
```

#### Linha 834 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Nenhum dado serÃ¡ perdido.',
```

#### Linha 840

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se nÃ£o confirmou, restaurar seleÃ£Ã£o anterior e sair
```

#### Linha 848

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Prosseguir com a mudanÃ£a
```

---

### 📄 `modules\products\presentation\screens\product_qr_screen.dart`

#### Linha 18

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// - Tab 1: Escanear (cÃ£mera para leitura de QR/NFC)
```

#### Linha 20

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// - Tab 3: Vinculados (produtos com tag jÃ£ associada)
```

#### Linha 100

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Abre a cÃ£mera para escanear cÃ£digo de tag ESL
```

#### Linha 105 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      subtitle: 'Aponte a cÃ£mera para o QR Code da etiqueta',
```

#### Linha 114

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Abre a cÃ£mera para escanear cÃ£digo de barras do produto
```

#### Linha 119 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      subtitle: 'Aponte a cÃ£mera para o cÃ£digo de barras do produto',
```

#### Linha 157 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            Text(isTag ? 'Inserir Tag' : 'Inserir CÃ£digo'),
```

#### Linha 167 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                hintText: isTag ? 'MAC da tag (ex: AA:BB:CC:DD:EE:FF)' : 'CÃ£digo de barras (EAN)',
```

#### Linha 208

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Busca produto pelo cÃ£digo na loja local primeiro
```

#### Linha 215 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          nome: 'Produto nÃ£o encontrado',
```

#### Linha 225

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // Produto nÃ£o encontrado localmente - busca no catÃ£logo global
```

#### Linha 231

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Busca produto no catÃ£logo global de produtos pelo cÃ£digo de barras
```

#### Linha 234 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    _showLoading('Buscando produto no catÃ£logo global...');
```

#### Linha 246

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // Produto encontrado no catÃ£logo global - oferece importar
```

#### Linha 249

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // NÃ£o encontrado nem no catÃ£logo global
```

#### Linha 254

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Erro na busca ou produto nÃ£o encontrado
```

#### Linha 312

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Imagem do produto (se disponÃ£vel)
```

#### Linha 343

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // CÃ£digo
```

#### Linha 378

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Campo de preÃ£o
```

#### Linha 379 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              const Text('Defina o preÃ£o para sua loja:', style: TextStyle(fontWeight: FontWeight.w500)),
```

#### Linha 405 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'Este produto serÃ¡ adicionado ao seu catÃ£logo local.',
```

#### Linha 440

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // ObtÃ£m storeId do contexto atual via provider
```

#### Linha 501 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: const Text('Produto nÃ£o encontrado'),
```

#### Linha 506 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'O cÃ£digo "$codigo" nÃ£o foi encontrado na sua loja nem no catÃ£logo global.',
```

#### Linha 517 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Deseja cadastrar um novo produto com este cÃ£digo?',
```

#### Linha 532

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Navega para tela de cadastro com cÃ£digo prÃ£-preenchido
```

#### Linha 579 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                const Text('VinculAÃ§Ã£o realizada com sucesso!'),
```

#### Linha 588

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Aguarda animAÃ§Ã£o e reseta
```

#### Linha 609 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Deseja desvincular a tag do produto "${produto.nome}"?\n\nA tag ficarÃ£ disponÃ£vel para vincular a outro produto.',
```

#### Linha 747 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Associar etiquetas eletrÃ£nicas',
```

#### Linha 867

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // ConteÃ£do baseado no passo atual
```

#### Linha 947 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          label: 'Posicione a tag na Ã£rea de leitura',
```

#### Linha 963 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          subtitle: 'Escaneie o cÃ£digo de barras do produto',
```

#### Linha 975 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          label: 'Posicione o cÃ£digo de barras',
```

---

### 📄 `design_system\theme\gradients.dart`

#### Linha 4

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Gradientes padronizados da aplicAÃ§Ã£o
```

#### Linha 7

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Evita duplicaÃ§Ã£o de cores hardcoded.
```

#### Linha 25

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente roxo escuro (para relatÃ£rios e cards escuros)
```

#### Linha 31

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente de sugestÃ£es de IA (laranja/rosa)
```

#### Linha 37

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente de EstratÃ©gias (laranja)
```

#### Linha 42

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente azul claro (sincronizAÃ§Ã£o)
```

#### Linha 47

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente rosa/amarelo (importAÃ§Ã£o)
```

#### Linha 57

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente cinza escuro (histÃ£rico/neutro)
```

#### Linha 81

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente azul claro para sincronizAÃ§Ã£o
```

#### Linha 86

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // ========== CORES ESTRATÃ£GICAS ==========
```

#### Linha 88

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Cores para badges e elementos de estratÃ£gia
```

#### Linha 114

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // ========== CORES PURAS PARA REFERÃ£NCIA ==========
```

#### Linha 122

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // ========== GRADIENTES DINÃ£MICOS ==========
```

#### Linha 134

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Cria um gradiente para items de estratÃ£gia
```

#### Linha 146

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Cria um gradiente dinÃ£mico a partir de uma cor
```

#### Linha 166

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // ========== GRADIENTES ESPECÃ£FICOS DO DASHBOARD ==========
```

#### Linha 229

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // ========== GRADIENTES DE CATEGORIAS/MÃ£DULOS (TOP 10) ==========
```

#### Linha 231

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente roxo principal (dashboard, mÃ£dulos principais) - 53x
```

#### Linha 245

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente roxo MÃ©dio (categorias) - 16x
```

#### Linha 253

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente rosa-amarelo (importAÃ§Ã£o, destaque) - 13x
```

#### Linha 268

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente azul cyan (sincronizAÃ§Ã£o, info) - 11x
```

#### Linha 275

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente azul MÃ©dio (info, links) - 11x
```

#### Linha 283

**Padroes encontrados:**
- `Ãµ` → `õ` (o com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente laranja (warning, NotificaÃ§Ãµes) - 11x
```

#### Linha 306

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente pastel mint/pink (tags, etiquetas) - encontrado em mÃ£ltiplos mÃ£dulos
```

#### Linha 314

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // ========== GRADIENTES POR MÃ£DULO (HEADERS) ==========
```

#### Linha 316

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente do mÃ£dulo Produtos (verde teal)
```

#### Linha 323

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente do mÃ£dulo Etiquetas/Tags (rosa/vermelho)
```

#### Linha 330

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente do mÃ£dulo EstratÃ£gias (laranja)
```

#### Linha 337

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente do mÃ£dulo SincronizAÃ§Ã£o (azul cyan)
```

#### Linha 344

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente do mÃ£dulo PrecificAÃ§Ã£o (rosa/amarelo)
```

#### Linha 351

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente do mÃ£dulo Categorias (cyan/roxo)
```

#### Linha 358

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente do mÃ£dulo ImportAÃ§Ã£o/ExportAÃ§Ã£o (pastel)
```

#### Linha 365

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente do mÃ£dulo RelatÃ£rios (laranja/rosa)
```

#### Linha 372

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente do mÃ£dulo ConfiguraÃ£Ã£es (cinza/preto)
```

---

### 📄 `modules\products\presentation\screens\products_stock_screen.dart`

#### Linha 44 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      if (_filterStatus == 'CrÃ£tico') return item.statusEstoque == 'CrÃ£tico' || item.statusEstoque == 'Esgotado';
```

#### Linha 129 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        label: const Text('Nova MovimentAÃ§Ã£o'),
```

#### Linha 210

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o de atualizar
```

#### Linha 241 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            child: _buildStatItem(context, 'CrÃ£ticos',
```

#### Linha 245 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              () => setState(() => _filterStatus = 'CrÃ£tico'),
```

#### Linha 368 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  children: ['Todos', 'CrÃ£tico', 'Baixo', 'Normal'].map((status) {
```

#### Linha 404 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      case 'CrÃ£tico':
```

#### Linha 572 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          child: _buildStockInfo(context, 'MÃ£nimo',
```

#### Linha 606 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                                : 'Sem movimentaÃ£Ã£es',
```

#### Linha 622 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                            tooltip: 'Registrar SaÃ£da',
```

#### Linha 741 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                tipo == 'entrada' ? 'Entrada de Estoque' : 'SaÃ£da de Estoque',
```

#### Linha 804 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  hintText: 'Descreva o motivo da movimentAÃ§Ã£o',
```

#### Linha 872 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        ? (tipo == 'entrada' ? 'Entrada Registrada!' : 'SaÃ£da Registrada!')
```

#### Linha 873 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        : 'Erro ao registrar movimentAÃ§Ã£o',
```

#### Linha 942 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildDetalheRow(context, 'Estoque MÃ£nimo', '${item.estoqueMinimo} un'),
```

#### Linha 943 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildDetalheRow(context, 'Estoque MÃ£ximo', '${item.estoqueMaximo} un'),
```

#### Linha 945 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildDetalheRow(context, 'Última AtualizAÃ§Ã£o', _formatarData(item.ultimaAtualizacao)),
```

#### Linha 947 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildDetalheRow(context, 'Valor UnitÃ£rio', _formatarMoeda(item.valorUnitario)),
```

#### Linha 975 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            label: const Text('SaÃ£da'),
```

#### Linha 1023 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      case 'crÃ£tico':
```

#### Linha 1037 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    String motivoSelecionado = 'ReposiÃ£Ã£o';
```

#### Linha 1058 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              const Text('MovimentAÃ§Ã£o em Massa'),
```

#### Linha 1067 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Selecione o tipo de movimentAÃ§Ã£o:',
```

#### Linha 1088 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        title: const Text('SaÃ£da', style: TextStyle(fontSize: 14)),
```

#### Linha 1089 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        value: 'saÃ£da',
```

#### Linha 1109 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'ReposiÃ£Ã£o',
```

#### Linha 1110 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Ajuste de inventÃ£rio',
```

#### Linha 1111 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'DevoluÃ£Ã£o',
```

#### Linha 1113 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'TransferÃ£ncia',
```

#### Linha 1149 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'A movimentAÃ§Ã£o serÃ¡ aplicada a todos os ${_stockItems.length} produtos listados.',
```

#### Linha 1173 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      content: Text('Informe uma quantidade vÃ£lida'),
```

#### Linha 1182

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // Executar movimentAÃ§Ã£o em massa via API
```

#### Linha 1210 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      content: Text('${tipoSelecionado == 'entrada' ? 'Entrada' : 'SaÃ£da'} de $quantidade unidades registrada para ${_stockItems.length} produtos'),
```

---

### 📄 `features\sync\data\models\sync_models.dart`

#### Linha 3

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Modelos para o mÃ£dulo de SincronizAÃ§Ã£o
```

#### Linha 4

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Gerencia estado e histÃ£rico de sincronizaÃ£Ã£es
```

#### Linha 6

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Tipo de sincronizAÃ§Ã£o
```

#### Linha 8

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  full,       // SincronizAÃ§Ã£o completa (produtos + tags)
```

#### Linha 11

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  prices,     // Apenas preÃ£os
```

#### Linha 24 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        return 'PREÃ‡Os';
```

#### Linha 42

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Status de uma sincronizAÃ§Ã£o
```

#### Linha 45

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  running,    // Em execuÃ§Ã£o
```

#### Linha 58 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        return 'Em execuÃ§Ã£o';
```

#### Linha 88

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Ã­cone associado ao status para uso na UI
```

#### Linha 113

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Registro de histÃ£rico de sincronizAÃ§Ã£o
```

#### Linha 126

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  final String? executedBy;       // UsuÃ£rio que executou
```

#### Linha 127

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  final String? details;          // Detalhes da sincronizAÃ§Ã£o
```

#### Linha 147

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Cor baseada no status (getter de conveniÃ£ncia)
```

#### Linha 150

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Ã­cone baseado no status (getter de conveniÃ£ncia)
```

#### Linha 153

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// DurAÃ§Ã£o formatada
```

#### Linha 269

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Mapear labels em portuguÃ£s para status
```

#### Linha 283 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        case 'em execuÃ§Ã£o':
```

#### Linha 296

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Resultado de uma operAÃ§Ã£o de sincronizAÃ§Ã£o
```

#### Linha 367

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// ConfiguraÃ£Ã£es de sincronizAÃ§Ã£o
```

#### Linha 429

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
// MODELOS DE SINCRONIZAÃ£Ã£O MINEW
```

#### Linha 433

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Resultado de sincronizAÃ§Ã£o com Minew Cloud
```

#### Linha 454

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// SincronizAÃ§Ã£o bem sucedida (sem erros)
```

#### Linha 457

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// SincronizAÃ§Ã£o parcial (com alguns erros)
```

#### Linha 518

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Resultado de vinculAÃ§Ã£o tag-produto
```

#### Linha 551

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Status detalhado de sincronizAÃ§Ã£o
```

#### Linha 552

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Para exibiÃ§Ã£o de status em tempo real na UI
```

#### Linha 572

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Verifica se estÃ£ em processo de sincronizAÃ§Ã£o
```

#### Linha 575

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Verifica se estÃ£ sincronizado
```

#### Linha 581

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Verifica se estÃ£ pendente
```

#### Linha 599

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Request para sincronizAÃ§Ã£o em lote de tags
```

#### Linha 617

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Request para sincronizAÃ§Ã£o em lote de produtos
```

#### Linha 674

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Resultado de importAÃ§Ã£o de tags
```

---

### 📄 `features\products\presentation\screens\products_stock_screen.dart`

#### Linha 44 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      if (_filterStatus == 'CrÃ£tico') return item.statusEstoque == 'CrÃ£tico' || item.statusEstoque == 'Esgotado';
```

#### Linha 129 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        label: const Text('Nova MovimentAÃ§Ã£o'),
```

#### Linha 210

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o de atualizar
```

#### Linha 242 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'CrÃ£ticos',
```

#### Linha 246 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              () => setState(() => _filterStatus = 'CrÃ£tico'),
```

#### Linha 371 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  children: ['Todos', 'CrÃ£tico', 'Baixo', 'Normal'].map((status) {
```

#### Linha 407 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      case 'CrÃ£tico':
```

#### Linha 577 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                            'MÃ£nimo',
```

#### Linha 612 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                                : 'Sem movimentaÃ£Ã£es',
```

#### Linha 628 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                            tooltip: 'Registrar SaÃ£da',
```

#### Linha 747 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                tipo == 'entrada' ? 'Entrada de Estoque' : 'SaÃ£da de Estoque',
```

#### Linha 810 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  hintText: 'Descreva o motivo da movimentAÃ§Ã£o',
```

#### Linha 878 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        ? (tipo == 'entrada' ? 'Entrada Registrada!' : 'SaÃ£da Registrada!')
```

#### Linha 879 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        : 'Erro ao registrar movimentAÃ§Ã£o',
```

#### Linha 948 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildDetalheRow('Estoque MÃ£nimo', '${item.estoqueMinimo} un'),
```

#### Linha 949 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildDetalheRow('Estoque MÃ£ximo', '${item.estoqueMaximo} un'),
```

#### Linha 951 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildDetalheRow('Última AtualizAÃ§Ã£o', _formatarData(item.ultimaAtualizacao)),
```

#### Linha 953 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildDetalheRow('Valor UnitÃ£rio', _formatarMoeda(item.valorUnitario)),
```

#### Linha 981 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            label: const Text('SaÃ£da'),
```

#### Linha 1029 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      case 'crÃ£tico':
```

#### Linha 1043 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    String motivoSelecionado = 'ReposiÃ£Ã£o';
```

#### Linha 1064 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              const Text('MovimentAÃ§Ã£o em Massa'),
```

#### Linha 1073 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Selecione o tipo de movimentAÃ§Ã£o:',
```

#### Linha 1094 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        title: const Text('SaÃ£da', style: TextStyle(fontSize: 14)),
```

#### Linha 1095 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        value: 'saÃ£da',
```

#### Linha 1115 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'ReposiÃ£Ã£o',
```

#### Linha 1116 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Ajuste de inventÃ£rio',
```

#### Linha 1117 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'DevoluÃ£Ã£o',
```

#### Linha 1119 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'TransferÃ£ncia',
```

#### Linha 1155 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'A movimentAÃ§Ã£o serÃ¡ aplicada a todos os ${_stockItems.length} produtos listados.',
```

#### Linha 1179 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      content: Text('Informe uma quantidade vÃ£lida'),
```

#### Linha 1188

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // Executar movimentAÃ§Ã£o em massa via API
```

#### Linha 1216 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      content: Text('${tipoSelecionado == 'entrada' ? 'Entrada' : 'SaÃ£da'} de $quantidade unidades registrada para ${_stockItems.length} produtos'),
```

---

### 📄 `modules\dashboard\presentation\widgets\next_action_card.dart`

#### Linha 8

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã³` → `ó` (o com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de PrÃ³xima AÃ£Ã£o Sugerida - IA sugere o prÃ£ximo passo baseado no estado do sistema
```

#### Linha 9

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// LÃ£gica de prioridade:
```

#### Linha 14 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// 5. Produtos sem preÃ£o ? "Defina preÃ£os"
```

#### Linha 15 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// 6. Nenhuma estratÃ£gia ? "Ative EstratÃ©gias de precificAÃ§Ã£o"
```

#### Linha 44 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se estÃ£ carregando, tem erro ou foi "dismiss", nÃ£o mostrar
```

#### Linha 49

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Verifica se foi dismissed (reseta apÃ£s 1 hora)
```

#### Linha 57

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se nÃ£o houver suGestÃ£o, nÃ£o mostrar o card
```

#### Linha 87

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // CabeÃ£alho
```

#### Linha 116 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                              'PRÃ£XIMO PASSO RECOMENDADO',
```

#### Linha 142

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // DescriÃ£Ã£o
```

#### Linha 153

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // BotÃ£es de AÃ§Ã£o
```

#### Linha 196 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                                  'Lembraremos vocÃ£ mais tarde',
```

#### Linha 237 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'description': 'vocÃª ainda nÃ£o tem produtos cadastrados. '
```

#### Linha 238 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Importe do ERP ou cadastre manualmente para comeÃ§ar a usar o sistema.',
```

#### Linha 251 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'description': 'Nenhuma etiqueta eletrÃ£nica foi cadastrada ainda. '
```

#### Linha 252 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Adicione as tags ESL para exibir preÃ£os automaticamente nas prateleiras.',
```

#### Linha 270 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'description': 'vocÃª tem $productsWithoutTag produtos sem tag vinculada. '
```

#### Linha 271 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Vincule tags ESL para exibir preÃ£os automaticamente.',
```

#### Linha 280

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // 4. Tags offline (tags nÃ£o vinculadas podem indicar offline)
```

#### Linha 285 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'description': '$offlineCount tags estÃ£o sem ComunicaÃ§Ã£o. '
```

#### Linha 286 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Isso pode indicar problema de bateria ou distÃ£ncia do gateway.',
```

#### Linha 295

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // 5. Produtos sem preÃ£o
```

#### Linha 299 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'title': 'Defina preÃ£os dos produtos',
```

#### Linha 300 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'description': 'vocÃª tem $productsWithoutPrice produtos sem preÃ£o definido. '
```

#### Linha 301 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Produtos sem preÃ£o nÃ£o serÃ¡o exibidos nas etiquetas.',
```

#### Linha 304 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'buttonText': 'Definir PREÃ‡Os',
```

#### Linha 310

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // 6. Nenhuma estratÃ£gia ativa
```

#### Linha 313 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'title': 'Ative EstratÃ©gias de lucro',
```

#### Linha 314 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'description': 'Nenhuma estratÃ£gia de precificAÃ§Ã£o estÃ£ ativa. '
```

#### Linha 315 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Ative EstratÃ©gias para otimizar seus preÃ£os automaticamente.',
```

#### Linha 318 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'buttonText': 'Ativar EstratÃ£gia',
```

#### Linha 324

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Tudo OK - nÃ£o mostrar o card
```

---

### 📄 `features\strategies\presentation\screens\strategies_results_screen.dart`

#### Linha 28

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// ObtÃ£m estatÃ£sticas do perÃ£odo do backend
```

#### Linha 35

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Dados do perÃ£odo formatados para a UI
```

#### Linha 39

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Valores padrÃ£o enquanto carrega
```

#### Linha 73

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Calcula variAÃ§Ã£o do perÃ£odo anterior (estimativa baseada nos dados atuais)
```

#### Linha 78

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // A variAÃ§Ã£o anterior ã estimada como 70% da variAÃ§Ã£o atual
```

#### Linha 106

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// HistÃ£rico de execuÃ£Ã£es do backend
```

#### Linha 112

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Dados de vendas diÃ£rias para o grÃ£fico
```

#### Linha 258 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Resultados da EstratÃ£gia',
```

#### Linha 455 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: isMobile ? 'Geral' : 'VisÃ£o Geral',
```

#### Linha 469 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: 'HistÃ£rico',
```

#### Linha 535 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Nenhuma execuÃ§Ã£o registrada',
```

#### Linha 617 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'AnÃ£lise de Impacto',
```

#### Linha 767 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Ticket MÃ£dio',
```

#### Linha 788 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'ConversÃ£o',
```

#### Linha 966 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'EvoluÃ£Ã£o de Vendas',
```

#### Linha 989 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Ã£ltimos 7 dias',
```

#### Linha 1131 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'ComparAÃ§Ã£o com PerÃ£odo Anterior',
```

#### Linha 1156 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildComparisonRow('Ticket MÃ£dio', _calcularVariacaoAnterior('ticket'), _dadosAtuais['variacaoTicket'], true),
```

#### Linha 1160 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildComparisonRow('ConversÃ£o', _calcularVariacaoAnterior('conversao'), _dadosAtuais['variacaoConversao'], true),
```

#### Linha 1657 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildCategoryBar('PerecÃ£veis', 0.22, ThemeColors.of(context).orangeMain),
```

#### Linha 1911

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Formata a data para exibiÃ§Ã£o
```

#### Linha 1938 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Exportando relatÃ£rio em CSV...',
```

#### Linha 1958

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Gerar CSV real com dados do relatÃ£rio
```

#### Linha 1961 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    csvContent.writeln('RelatÃ£rio de EstratÃ£gia - ${widget.estrategia.name}');
```

#### Linha 1962 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    csvContent.writeln('Data de ExportAÃ§Ã£o,${DateTime.now().toIso8601String()}');
```

#### Linha 1963 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    csvContent.writeln('PerÃ£odo,${_periodoSelecionado}');
```

#### Linha 1965 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    csvContent.writeln('MÃ£trica,Valor');
```

#### Linha 1967 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    csvContent.writeln('VariAÃ§Ã£o Vendas,${dados['variacaoVendas']}');
```

#### Linha 1969 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    csvContent.writeln('Ticket MÃ£dio,${dados['ticketMedio']}');
```

#### Linha 1970 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    csvContent.writeln('Taxa de ConversÃ£o,${dados['conversao']}');
```

#### Linha 1973 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    csvContent.writeln('ExecuÃ£Ã£es,${dados['execucoes']}');
```

#### Linha 1994 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'RelatÃ£rio exportado com sucesso!',
```

---

### 📄 `features\strategies\presentation\screens\cross_selling\nearby_products_screen.dart`

#### Linha 290 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: 'ConfigurAÃ§Ã£o',
```

#### Linha 297 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: 'SugestÃ£es',
```

#### Linha 402 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'NavegAÃ§Ã£o Inteligente',
```

#### Linha 420 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  '$sugestoesAtivas sugestÃ£es ativas',
```

#### Linha 499 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Setas aparecem nas ESLs indicando produtos relacionados prÃ£ximos, aumentando cross-selling',
```

#### Linha 566 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ParÃ£metros de SuGestÃ£o',
```

#### Linha 598 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'DistÃ£ncia MÃ£xima',
```

#### Linha 667 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Produtos sugeridos devem estar no mximo a esta distÃ£ncia',
```

#### Linha 699 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ConfianÃ£a MÃ­nima da IA',
```

#### Linha 763 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Tempo de RotAÃ§Ã£o',
```

#### Linha 887 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ClÃ¡ssica',
```

#### Linha 1013 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'AnimAÃ§Ã£o pulsante para chamar atenÃ£Ã£o',
```

#### Linha 1022 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'RotAÃ§Ã£o AutomÃ£tica',
```

#### Linha 1023 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Alterna entre mÃ£ltiplas sugestÃ£es',
```

#### Linha 1032 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Notificar SugestÃ£es',
```

#### Linha 1033 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Alertas quando novas sugestÃ£es forem criadas',
```

#### Linha 1348 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'DistÃ£ncia',
```

#### Linha 1405 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'ConversÃ£o',
```

#### Linha 1504 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Gerar SugestÃ£es com IA',
```

#### Linha 1520 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              Text('A IA analisarÃ£:', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13), fontWeight: FontWeight.w600)),
```

#### Linha 1522 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              Text('ã HistÃ£rico de compras combinadas', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12), height: 1.5)),
```

#### Linha 1524 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              Text('ã Proximidade fÃ£sica dos produtos', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12), height: 1.5)),
```

#### Linha 1526 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              Text('ã PadrÃ£es de navegAÃ§Ã£o dos clientes', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12), height: 1.5)),
```

#### Linha 1528 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              Text('ã Taxa de conversÃ£o de sugestÃ£es', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12), height: 1.5)),
```

#### Linha 1540

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Chama o mÃ£todo do provider para gerar sugestÃ£es via IA
```

#### Linha 1551 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        Text('SugestÃ£es geradas com sucesso!', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
```

#### Linha 1588 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              Text('ã Setas animadas aparecem nas etiquetas eletrÃ£nicas', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12), height: 1.5)),
```

#### Linha 1590 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              Text('ã Aumenta ticket MÃ©dio em 15-25%', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12), height: 1.5)),
```

#### Linha 1592 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              Text('ã Cross-selling sem esforÃ£o manual', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12), height: 1.5)),
```

#### Linha 1594 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              Text('ã RotAÃ§Ã£o automÃ£tica entre mÃ£ltiplas sugestÃ£es', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12), height: 1.5)),
```

#### Linha 1606

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Salva as configuraÃ£Ã£es no backend
```

#### Linha 1643 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      Text('ConfiguraÃ£Ã£es Salvas!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
```

---

### 📄 `features\pricing\presentation\screens\adjustments_history_screen.dart`

#### Linha 112 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Carregando histÃ£rico...',
```

#### Linha 197 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'HistÃ£rico de Ajustes',
```

#### Linha 211 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Todas as alteraÃ£Ã£es de preÃ£o',
```

#### Linha 287 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Resumo do PerÃ£odo',
```

#### Linha 316 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    Icons.arrow_downward_rounded, '$reducoes', 'ReduÃ£Ã£es'),
```

#### Linha 474 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildFiltroChip('AutomÃ£tico', 'automatico', Icons.auto_mode_rounded),
```

#### Linha 1117 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (diff.inHours < 1) return '${diff.inMinutes} min atrÃ£s';
```

#### Linha 1118 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (diff.inHours < 24) return '${diff.inHours}hÃ£ atrÃ£s';
```

#### Linha 1119 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (diff.inDays == 1) return '1 dia atrÃ£s';
```

#### Linha 1120 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (diff.inDays < 7) return '${diff.inDays} dias atrÃ£s';
```

#### Linha 1121 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    return '${(diff.inDays / 7).floor()} sem atrÃ£s';
```

#### Linha 1161 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Filtrar por PerÃ£odo',
```

#### Linha 1181 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ãº` → `ú` (u com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                _buildPeriodoChip('Ãºltimas 24h', '24h'),
```

#### Linha 1182 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                _buildPeriodoChip('Ã£ltimos 7 dias', '7dias'),
```

#### Linha 1183 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                _buildPeriodoChip('Ã£ltimos 30 dias', '30dias'),
```

#### Linha 1266 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'PREÃ‡O Anterior', 'R\$ ${item.precoAntigo.toStringAsFixed(2)}'),
```

#### Linha 1268 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'PREÃ‡O Novo', 'R\$ ${item.precoNovo.toStringAsFixed(2)}'),
```

#### Linha 1269 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            _buildDetalheItem('VariAÃ§Ã£o', '${item.variacao.toStringAsFixed(1)}%'),
```

#### Linha 1270 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            _buildDetalheItem('MotivAÃ§Ã£o', item.motivacao),
```

#### Linha 1271 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            _buildDetalheItem('UsuÃ£rio', item.usuario),
```

#### Linha 1359 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Deseja reverter o ajuste de preÃ£o de "${item.produtoNome}"?\n\n'
```

#### Linha 1360 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'O preÃ£o voltarÃ£ de R\$ ${item.precoNovo.toStringAsFixed(2)} para R\$ ${item.precoAntigo.toStringAsFixed(2)}.',
```

#### Linha 1408 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            const Text('Exportar HistÃ£rico'),
```

#### Linha 1411 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        content: const Text('Escolha o formato para exportAÃ§Ã£o:'),
```

#### Linha 1421 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Exportando relatÃ£rio em PDF...',
```

#### Linha 1440 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Exportando relatÃ£rio em Excel...',
```

---

### 📄 `features\pricing\presentation\screens\dynamic_pricing_screen.dart`

#### Linha 28

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// HistÃ£rico de ajustes conectado ao provider
```

#### Linha 32

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Calcula ajustes por tipo usando o histÃ£rico do backend
```

#### Linha 49 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'descricao': 'Ajusta preÃ£os baseado na concorrÃªncia',
```

#### Linha 59 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'descricao': 'PREÃ‡Os aumentam com alta procura',
```

#### Linha 69 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'descricao': 'Reduz preÃ£os para produtos parados',
```

#### Linha 79 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'descricao': 'Considera Ã©pocas e eventos',
```

#### Linha 145 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                            'Regras de PrecificAÃ§Ã£o',
```

#### Linha 295 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Sistema AutomÃ£tico',
```

#### Linha 419 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'ConfiguraÃ£Ã£es Gerais',
```

#### Linha 430

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Margem MÃ­nima
```

#### Linha 432 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Margem MÃ­nima',
```

#### Linha 437

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Margem MÃ£xima
```

#### Linha 439 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Margem MÃ£xima',
```

#### Linha 494

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // OpÃ£Ã£es
```

#### Linha 496 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Respeitar Margem MÃ­nima',
```

#### Linha 504 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'NotificaÃ£Ã£es',
```

#### Linha 783 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (_sensibilidade <= 50) return 'EquilÃ­brio entre cautela e agilidade';
```

#### Linha 784 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (_sensibilidade <= 75) return 'Ajustes rÃ£pidos e significativos';
```

#### Linha 785 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    return 'MudanÃ£as RÃ¡pidas e grandes variaÃ£Ã£es';
```

#### Linha 821 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'HistÃ£rico de Ajustes',
```

#### Linha 843 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                            'Nenhum ajuste de preÃ£o registrado',
```

#### Linha 951 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Formata a data como tempo relativo (ex: "2 horas atrÃ£s")
```

#### Linha 959 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return '${difference.inMinutes} min atrÃ£s';
```

#### Linha 961 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrÃ£s';
```

#### Linha 963 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrÃ£s';
```

#### Linha 989 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                Text('ConfiguraÃ£Ã£es salvas com sucesso'),
```

---

### 📄 `modules\dashboard\presentation\widgets\alertas_acionaveis_card.dart`

#### Linha 9

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// EnumerAÃ§Ã£o para severidade de alertas
```

#### Linha 11

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  critico, // Vermelho - AÃ£Ã£o imediata
```

#### Linha 16

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Modelo de alerta acionÃ£vel
```

#### Linha 41

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de alertas acionÃ£veis com hierarquia de cores e aÃ£Ã£es diretas
```

#### Linha 42

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// SÃ£ aparece se houver alertas - Mostra no mÃ£ximo 3 alertas crÃ£ticos primeiro
```

#### Linha 47

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Callbacks para aÃ£Ã£es de navegAÃ§Ã£o
```

#### Linha 72

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Converte os alertas do provider para o novo formato acionÃ£vel
```

#### Linha 88 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      } else if (alertType.contains('price') || alertType.contains('preco') || alertType.contains('preÃ£o')) {
```

#### Linha 97

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Tags Offline - CRÃ£TICO
```

#### Linha 111

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Erros de Sync - CRÃ£TICO
```

#### Linha 116 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        titulo: '$errosSync erros de sincronizAÃ§Ã£o',
```

#### Linha 123

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Produtos sem preÃ£o - ATENÃ£Ã£O
```

#### Linha 128 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        titulo: '$produtosSemPreco produtos sem preÃ£o',
```

#### Linha 161

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Ordena por severidade (crÃ£tico primeiro)
```

#### Linha 203 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        return 'CRÃ£TICO';
```

#### Linha 205 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        return 'ATENÃ£Ã£O';
```

#### Linha 216

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ObtÃ£m alertas do provider ou usa customizados
```

#### Linha 223

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se nÃ£o hÃ£ alertas, nÃ£o mostra o card
```

#### Linha 228

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Mostra no mÃ£ximo 3 alertas (ou todos se expandido)
```

#### Linha 275 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'Alertas AcionÃ£veis',
```

#### Linha 288 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        '${alertasAtivos.length} ${alertasAtivos.length == 1 ? 'item requer' : 'itens requerem'} atenÃ£Ã£o',
```

#### Linha 304 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o "Ver todos" se houver mais alertas
```

#### Linha 399

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // TÃ£tulo do alerta
```

#### Linha 413

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£es de AÃ§Ã£o em container flexÃ£vel
```

#### Linha 459

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // BotÃ£o ignorar
```

---

### 📄 `modules\products\presentation\screens\product_edit_screen.dart`

#### Linha 11

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Tela de EdiÃ§Ã£o de produto
```

#### Linha 48

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // ValidAÃ§Ã£o
```

#### Linha 89

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ValidAÃ§Ã£o inicial
```

#### Linha 350 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          : 'Este produto nÃ£o possui tag associada',
```

#### Linha 393 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  _buildTagInfo(context, 'Última SincronizAÃ§Ã£o',
```

#### Linha 396 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      : 'NÃ£o disponÃ£vel'),
```

#### Linha 448 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          Text('Abrindo associAÃ§Ã£o de tag...'),
```

#### Linha 544 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'InformaÃ£Ã£es BÃ£sicas',
```

#### Linha 566 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            label: 'CÃ£digo de Barras',
```

#### Linha 584 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            label: 'DescriÃ£Ã£o (opcional)',
```

#### Linha 696 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'PrecificAÃ§Ã£o',
```

#### Linha 721 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  label: 'PREÃ‡O (R\$)',
```

#### Linha 732 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  label: 'PREÃ‡O/Kg (opcional)',
```

#### Linha 802 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            items: ['Bebidas', 'Mercearia', 'PerecÃ£veis', 'Limpeza', 'Higiene']
```

#### Linha 920 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'HistÃ£rico de PREÃ‡Os',
```

#### Linha 926 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  '${_historicoPrecos.length} alteraÃ£Ã£es',
```

#### Linha 948 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Nenhum histÃ£rico disponÃ£vel',
```

#### Linha 987 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        : 'Ver HistÃ£rico Completo (${_historicoPrecos.length})',
```

#### Linha 1133 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'Salvar AlteraÃ£Ã£es',
```

#### Linha 1154 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      title: const Text('Descartar alteraÃ£Ã£es?'),
```

#### Linha 1156 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'vocÃª tem alteraÃ£Ã£es nÃ£o salvas. Deseja descartar todas as alteraÃ£Ã£es?',
```

#### Linha 1196

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      await Future.delayed(const Duration(seconds: 1)); // SimulAÃ§Ã£o
```

#### Linha 1264 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'O produto ficarÃ£ sem uma tag associada e nÃ£o serÃ¡ atualizado automaticamente.',
```

#### Linha 1275

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // TODO: Implementar desassociAÃ§Ã£o via provider
```

---

### 📄 `modules\products\presentation\widgets\barcode_scanner_widget.dart`

#### Linha 7

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Widget de Scanner de CÃ£digo de Barras usando a cÃ£mera do dispositivo
```

#### Linha 10

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// - CÃ£digos de barras (EAN-8, EAN-13, UPC-A, UPC-E)
```

#### Linha 19 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
///     print('CÃ£digo detectado: $barcode');
```

#### Linha 97

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãµ` → `õ` (o com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (_hasDetected) return; // Evita mÃ£ltiplas detecÃ§Ãµes
```

#### Linha 144

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // CÃ£mera
```

#### Linha 153

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Overlay com Ã£rea de scan
```

#### Linha 159

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Indicador de cÃ£digo detectado
```

#### Linha 172

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // BotÃ£o fechar
```

#### Linha 180

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // BotÃ£o flash
```

#### Linha 191

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // BotÃ£o trocar cÃ£mera
```

#### Linha 194 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              tooltip: 'Trocar cÃ£mera',
```

#### Linha 241

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // Ã£rea de scan com animAÃ§Ã£o
```

#### Linha 280

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // TÃ£tulo
```

#### Linha 282 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _hasDetected ? 'CÃ£digo Detectado!' : widget.title,
```

#### Linha 290

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // SubtÃ£tulo
```

#### Linha 367

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // boxShadow removido pois AppShadows nÃ£o ã const
```

#### Linha 379 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'CÃ£digo lido com sucesso!',
```

#### Linha 394 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        message = 'PermissÃ£o de cÃ£mera negada.\nAcesse as configuraÃ£Ã£es para permitir.';
```

#### Linha 400 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        message = 'Erro ao inicializar cÃ£mera.\nTente novamente.';
```

#### Linha 404 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        message = 'Erro ao acessar cÃ£mera:\n${error.errorDetails?.message ?? "Desconhecido"}';
```

#### Linha 444

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Painter para o overlay com Ã£rea de scan recortada
```

#### Linha 560

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Abre o scanner em tela cheia e retorna o cÃ£digo detectado
```

#### Linha 563 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    String title = 'Escanear CÃ£digo',
```

#### Linha 564 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    String subtitle = 'Posicione o cÃ£digo de barras dentro da Ã£rea',
```

---

### 📄 `features\products\presentation\widgets\barcode_scanner_widget.dart`

#### Linha 8

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Widget de Scanner de CÃ£digo de Barras usando a cÃ£mera do dispositivo
```

#### Linha 11

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// - CÃ£digos de barras (EAN-8, EAN-13, UPC-A, UPC-E)
```

#### Linha 20 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
///     print('CÃ£digo detectado: $barcode');
```

#### Linha 98

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãµ` → `õ` (o com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (_hasDetected) return; // Evita mÃ£ltiplas detecÃ§Ãµes
```

#### Linha 145

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // CÃ£mera
```

#### Linha 154

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Overlay com Ã£rea de scan
```

#### Linha 160

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Indicador de cÃ£digo detectado
```

#### Linha 173

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // BotÃ£o fechar
```

#### Linha 182

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // BotÃ£o flash
```

#### Linha 194

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // BotÃ£o trocar cÃ£mera
```

#### Linha 198 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              tooltip: 'Trocar cÃ£mera',
```

#### Linha 245

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // Ã£rea de scan com animAÃ§Ã£o
```

#### Linha 284

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // TÃ£tulo
```

#### Linha 286 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _hasDetected ? 'CÃ£digo Detectado!' : widget.title,
```

#### Linha 294

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // SubtÃ£tulo
```

#### Linha 371

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // boxShadow removido pois AppShadows nÃ£o ã const
```

#### Linha 383 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'CÃ£digo lido com sucesso!',
```

#### Linha 398 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        message = 'PermissÃ£o de cÃ£mera negada.\nAcesse as configuraÃ£Ã£es para permitir.';
```

#### Linha 404 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        message = 'Erro ao inicializar cÃ£mera.\nTente novamente.';
```

#### Linha 408 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        message = 'Erro ao acessar cÃ£mera:\n${error.errorDetails?.message ?? "Desconhecido"}';
```

#### Linha 448

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Painter para o overlay com Ã£rea de scan recortada
```

#### Linha 564

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Abre o scanner em tela cheia e retorna o cÃ£digo detectado
```

#### Linha 567 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    String title = 'Escanear CÃ£digo',
```

#### Linha 568 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    String subtitle = 'Posicione o cÃ£digo de barras dentro da Ã£rea',
```

---

### 📄 `modules\products\presentation\screens\products_import_screen.dart`

#### Linha 13

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Tela de importAÃ§Ã£o em massa de produtos
```

#### Linha 140 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ImportAÃ§Ã£o em Massa',
```

#### Linha 171 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        return 'ImportAÃ§Ã£o ConcluÃ­da';
```

#### Linha 206 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildStepIndicator(context, 4, 'ConcluÃ£do', _step >= 4),
```

#### Linha 441 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildInfoItem(context, 'codigo', 'CÃ£digo de barras (mÃ£nimo 8 dÃ­gitos)'),
```

#### Linha 442 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildInfoItem(context, 'nome', 'Nome do produto (obrigatÃ£rio)'),
```

#### Linha 443 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildInfoItem(context, 'preco', 'PREÃ‡O unitÃ£rio (formato: 9.99)'),
```

#### Linha 446 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildInfoItem(context, 'descricao', 'DescriÃ£Ã£o do produto (opcional)'),
```

#### Linha 549 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              child: _buildStatCard(context, 'VÃ£lidos',
```

#### Linha 724 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildFieldChip(context, 'CÃ£digo', item.codigo),
```

#### Linha 725 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildFieldChip(context, 'PREÃ‡O', 'R\$ ${item.preco}'),
```

#### Linha 871 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'ImportAÃ§Ã£o ConcluÃ£da!',
```

#### Linha 929 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                label: const Text('Baixar RelatÃ£rio'),
```

#### Linha 972

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          // Navega para a tela de vinculAÃ§Ã£o em lote
```

#### Linha 1059 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        _showErrorSnackBar('NÃ£o foi possÃ£vel ler o arquivo');
```

#### Linha 1069

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // Para Excel, por enquanto sÃ£ suportamos CSV
```

#### Linha 1070 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        _showErrorSnackBar('Por enquanto, apenas arquivos CSV sÃ£o suportados');
```

#### Linha 1075 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        _showErrorSnackBar('O arquivo nÃ£o contÃ£m dados vÃ¡lidos');
```

#### Linha 1079

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Processa dados atravÃ©s do provider
```

#### Linha 1099

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Primeira linha sÃ£o os headers
```

#### Linha 1158

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ObtÃ£m storeId do contexto
```

#### Linha 1162

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Executa importAÃ§Ã£o via provider
```

#### Linha 1175 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            const Text('Baixando relatÃ£rio de importAÃ§Ã£o...'),
```

---

### 📄 `features\sync\presentation\screens\sync_settings_screen.dart`

#### Linha 177 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ConfiguraÃ£Ã£es',
```

#### Linha 191 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ParÃ£metros de sincronizAÃ§Ã£o',
```

#### Linha 261 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Intervalo de SincronizAÃ§Ã£o',
```

#### Linha 303 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              helperText: 'Tempo entre sincronizaÃ£Ã£es automÃ£ticas',
```

#### Linha 353 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Intervalo mÃ£nimo recomendado: 5 minutos',
```

#### Linha 424 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Modo de OperAÃ§Ã£o',
```

#### Linha 485 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        ? 'Modo Passivo: Apenas lÃ¡ dados do ERP'
```

#### Linha 634 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'PREÃ‡Os',
```

#### Linha 635 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Sincronizar preÃ£os dos produtos',
```

#### Linha 803 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'NotificaÃ£Ã£es',
```

#### Linha 862 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Notificar sincronizaÃ£Ã£es bem-sucedidas',
```

#### Linha 874 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Receba confirmAÃ§Ã£o de sucesso',
```

#### Linha 932 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Testar ConexÃ£o',
```

#### Linha 950 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Verifique se a conexÃ£o com o ERP estÃ£ funcionando corretamente antes de salvar.',
```

#### Linha 982 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                _testando ? 'Testando...' : 'Testar ConexÃ£o',
```

#### Linha 1059 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Salvar ConfiguraÃ£Ã£es',
```

#### Linha 1136 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Salvar ConfiguraÃ£Ã£es',
```

#### Linha 1177

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Testar conexÃ£o real com a API
```

#### Linha 1206 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            success ? 'ConexÃ£o Estabelecida!' : 'Falha na ConexÃ£o',
```

#### Linha 1220 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                result?.message ?? (success ? 'A conexÃ£o estÃ£ funcionando corretamente.' : 'NÃ£o foi possÃ£vel estabelecer conexÃ£o.'),
```

#### Linha 1235 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '${success ? "?" : "?"} Ping: ${result?.pingMs ?? 0}ms\n${result?.authStatus == "OK" ? "?" : "?"} AutenticAÃ§Ã£o: ${result?.authStatus ?? "N/A"}\n${result?.permissionsStatus == "OK" ? "?" : "?"} PermissÃ£es: ${result?.permissionsStatus ?? "N/A"}',
```

#### Linha 1280

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Atualiza configuraÃ£Ã£es no provider
```

#### Linha 1307 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'ConfiguraÃ£Ã£es salvas com sucesso!',
```

---

### 📄 `features\strategies\presentation\screens\calendar\salary_cycle_screen.dart`

#### Linha 182 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Ciclo de SalÃ¡rio',
```

#### Linha 273 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: 'ConfigurAÃ§Ã£o',
```

#### Linha 280 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: 'HistÃ£rico',
```

#### Linha 313 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'InÃ£cio do MÃ£s (PÃ£s-Pagamento)',
```

#### Linha 324 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Fim do MÃ£s (PrÃ£-Pagamento)',
```

#### Linha 442 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  state.isStrategyActive ? 'Ajustes AutomÃ¡ticos ativos' : 'Ajustes desativados',
```

#### Linha 497 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Sistema ajusta preÃ£os automaticamente baseado no ciclo de pagamento mensal dos consumidores',
```

#### Linha 581 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Aplicar ajuste tambÃ£m no dia 15',
```

#### Linha 632 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Ajuste aplicado tambÃ£m no dia ${state.diaQuinzena} de cada mÃ£s',
```

#### Linha 848 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'DurAÃ§Ã£o dos Ajustes',
```

#### Linha 898 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'InÃ£cio do MÃ£s: Dias 1-${state.diasPagamento}',
```

#### Linha 914 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Fim do MÃ£s: Dias ${30 - state.diasPagamento}-30',
```

#### Linha 978 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'VisualizAÃ§Ã£o do Ciclo',
```

#### Linha 1043 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildLegenda(ThemeColors.of(context).greenMain, 'InÃ£cio (+${state.ajusteInicio.toStringAsFixed(0)}%)'),
```

#### Linha 1285 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Ciclo de SalÃ¡rio',
```

#### Linha 1301 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Ajusta preÃ£os automaticamente baseado no ciclo de pagamento:',
```

#### Linha 1316 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Aumenta preÃ£os no inÃ£cio do mÃ£s (pÃ£s-pagamento)',
```

#### Linha 1331 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Reduz preÃ£os no fim do mÃ£s (prÃ£-pagamento)',
```

#### Linha 1346 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Monitora tambÃ£m o dia 15 (quinzena)',
```

#### Linha 1361 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Maximiza vendas em perÃ£odos de alto poder de compra',
```

#### Linha 1398

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Salva as configuraÃ£Ã£es via provider
```

#### Linha 1422 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    success ? 'ConfiguraÃ£Ã£es Salvas!' : 'Erro ao Salvar',
```

#### Linha 1434 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    success ? 'Ciclo de salÃ¡rio configurado' : 'Tente novamente',
```

---

### 📄 `features\reports\presentation\screens\audit_report_screen.dart`

#### Linha 26

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // OTIMIZAÃ£Ã£O: Cache de logs filtrados
```

#### Linha 50 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'categoria': report.hasProblems ? 'CrÃ£tica' : 'Normal',
```

#### Linha 63 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (type.toLowerCase().contains('preÃ£o')) return Icons.attach_money_rounded;
```

#### Linha 66 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (type.toLowerCase().contains('estratÃ£g')) return Icons.auto_awesome_rounded;
```

#### Linha 73 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (type.toLowerCase().contains('preÃ£o')) return ThemeColors.of(context).success;
```

#### Linha 76 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (type.toLowerCase().contains('estratÃ£g')) return ThemeColors.of(context).cyanMain;
```

#### Linha 81

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // OTIMIZAÃ£Ã£O: Getter com cache
```

#### Linha 97 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      final importanteMatch = !_apenasImportantes || log['categoria'] == 'CrÃ£tica';
```

#### Linha 188 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Nenhum registro de auditoria disponÃ£vel',
```

#### Linha 193 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Os registros aparecerÃ£o conforme as aÃ£Ã£es forem realizadas',
```

#### Linha 289 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'RelatÃ£rios de Auditoria',
```

#### Linha 299 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'HistÃ£rico e Rastreabilidade',
```

#### Linha 399 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Auditoria Completa ã Ã£ltimos 30 dias',
```

#### Linha 444 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  child: _buildStatItem('847', 'UsuÃ£rio', Icons.person_rounded),
```

#### Linha 452 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  child: _buildStatItem('67', 'CrÃ£ticos', Icons.error_rounded),
```

#### Linha 516 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Filtros AvanÃ£ados',
```

#### Linha 532 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'CrÃ£ticos',
```

#### Linha 557 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  items: ['Todos', 'AlterAÃ§Ã£o de PREÃ‡O', 'Login', 'ImportAÃ§Ã£o', 'Backup', 'ExclusÃ£o de Produto']
```

#### Linha 571 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    labelText: 'UsuÃ£rio',
```

#### Linha 735 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'Detalhes da OperAÃ§Ã£o',
```

#### Linha 890 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Todos os logs sÃ£o criptografados e armazenados\npor 90 dias para garantir compliance e seguranÃ£a',
```

#### Linha 942 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      case 'CrÃ£tica':
```

#### Linha 944 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      case 'SeguranÃ£a':
```

---

### 📄 `features\tags\presentation\screens\tags_diagnostic_screen.dart`

#### Linha 42

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Calcular estatÃ£sticas de problemas baseadas nas tags reais
```

#### Linha 60 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'tipo': 'Sem ComunicAÃ§Ã£o',
```

#### Linha 64 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'descricao': 'Offline hÃ£ mais de 2h',
```

#### Linha 68 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'tipo': 'NÃ£o Vinculadas',
```

#### Linha 76 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'tipo': 'Bateria CrÃ£tica',
```

#### Linha 137 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      problemas.add('Bateria CrÃ£tica (${tag.batteryLevel}%)');
```

#### Linha 142 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      problemas.add('Sem ComunicAÃ§Ã£o');
```

#### Linha 145 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      problemas.add('NÃ£o Vinculada');
```

#### Linha 154 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (diff.inMinutes < 60) return '${diff.inMinutes}min atrÃ£s';
```

#### Linha 155 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (diff.inHours < 24) return '${diff.inHours}hÃ£ atrÃ£s';
```

#### Linha 156 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    return '${diff.inDays}d atrÃ£s';
```

#### Linha 283 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'Tags CrÃ£ticas',
```

#### Linha 389 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Todas as tags estÃ£o funcionando normalmente.',
```

#### Linha 430

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o de voltar
```

#### Linha 479 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã³` → `ó` (o com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'diagnÃ³stico de Tags',
```

#### Linha 569 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildResumoItem('SaÃ£de', '$percentOk%', Icons.favorite_rounded),
```

#### Linha 620 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      {'id': 'unbound', 'label': 'NÃ£o Vinculadas'},
```

#### Linha 621 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      {'id': 'critica', 'label': 'CrÃ£ticos'},
```

#### Linha 780

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Ã­cone de bateria
```

#### Linha 796

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // InformaÃ£Ã£es
```

#### Linha 874

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Ã£ltima atualizAÃ§Ã£o
```

#### Linha 966 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã³` → `ó` (o com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              const Expanded(child: Text('diagnÃ³stico atualizado!')),
```

---

### 📄 `design_system\components\dialogs\dialog_widgets.dart`

#### Linha 4

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Widget reutilizÃ£vel para diÃ£logos de confirmAÃ§Ã£o
```

#### Linha 92

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// MÃ£todo estÃ¡tico para mostrar o diÃ£logo
```

#### Linha 122

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Widget reutilizÃ£vel para diÃ£logos de alerta/informAÃ§Ã£o
```

#### Linha 181

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// MÃ£todo estÃ¡tico para mostrar o diÃ£logo
```

#### Linha 203

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Widget reutilizÃ£vel para diÃ£logos de loading
```

#### Linha 239

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// MÃ£todo estÃ¡tico para mostrar o diÃ£logo
```

#### Linha 248

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// MÃ£todo estÃ¡tico para ocultar o diÃ£logo
```

#### Linha 254

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Helper para diÃ£logos comuns
```

#### Linha 258

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// DiÃ£logo de confirmAÃ§Ã£o de exclusÃ£o
```

#### Linha 265 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      title: 'Confirmar ExclusÃ£o',
```

#### Linha 267 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          ? 'Tem certeza que deseja excluir "$itemName"? Esta AÃ§Ã£o nÃ£o pode ser desfeita.'
```

#### Linha 276

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// DiÃ£logo de confirmAÃ§Ã£o de cancelamento
```

#### Linha 283 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      cancelText: 'NÃ£o',
```

#### Linha 288

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// DiÃ£logo de alteraÃ£Ã£es nÃ£o salvas
```

#### Linha 292 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      title: 'AlteraÃ£Ã£es nÃ£o salvas',
```

#### Linha 293 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      message: 'vocÃª tem alteraÃ£Ã£es nÃ£o salvas. Deseja descartÃ£-las?',
```

#### Linha 301

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// DiÃ£logo de sucesso
```

#### Linha 316

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// DiÃ£logo de erro
```

#### Linha 331

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// DiÃ£logo de aviso
```

#### Linha 339 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      title: title ?? 'atenÃ§Ã£o',
```

#### Linha 346

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// DiÃ£logo de informAÃ§Ã£o
```

#### Linha 354 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      title: title ?? 'InformAÃ§Ã£o',
```

---

### 📄 `features\strategies\presentation\screens\cross_selling\offers_trail_screen.dart`

#### Linha 289 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: 'ConfigurAÃ§Ã£o',
```

#### Linha 497 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ESLs criam caminhos visuais conectando produtos complementares atravÃ©s dos corredores',
```

#### Linha 564 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ConfiguraÃ£Ã£es das Trilhas',
```

#### Linha 596 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Intervalo de AtualizAÃ§Ã£o',
```

#### Linha 760 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Estilo de VisualizAÃ§Ã£o',
```

#### Linha 795 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'NÃ£meros',
```

#### Linha 909 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Destacar InÃ£cio',
```

#### Linha 910 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Produto inicial da trilha com animAÃ§Ã£o especial',
```

#### Linha 920 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Produto final da trilha com animAÃ§Ã£o especial',
```

#### Linha 930 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Avisar cliente sobre trilha disponÃ£vel',
```

#### Linha 1200 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'SequÃ£ncia:',
```

#### Linha 1409 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'ConversÃ£o',
```

#### Linha 1464 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'Ticket MÃ£dio',
```

#### Linha 1556 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'A IA criarÃ£ uma nova trilha de ofertas conectando produtos estratÃ£gicos com base em dados de vendas e comportamento dos clientes.',
```

#### Linha 1586

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Chama o mÃ£todo do provider para criar trilha via IA
```

#### Linha 1702

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Salva as alteraÃ£Ã£es
```

#### Linha 1767 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? ESLs formam SequÃªncias visuais conectadas',
```

#### Linha 1815 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Cria experiÃ£ncia gamificada de compra',
```

#### Linha 1831 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? RotAÃ§Ã£o automÃ£tica entre mÃ£ltiplas trilhas',
```

#### Linha 1870

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Salva as configuraÃ£Ã£es no backend
```

#### Linha 1907 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      Text('ConfiguraÃ£Ã£es Salvas!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
```

---

### 📄 `modules\dashboard\presentation\widgets\recent_activity_dashboard_card.dart`

#### Linha 9

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de Atividade Recente - Mostra histÃ£rico de aÃ£Ã£es no sistema
```

#### Linha 40

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Converte relatÃ£rios de auditoria em atividades
```

#### Linha 43

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se estÃ£ carregando, mostra skeleton
```

#### Linha 48

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se nÃ£o houver atividades, mostra estado vazio
```

#### Linha 73

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // CabeÃ£alho
```

#### Linha 99

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // BotÃ£o de refresh
```

#### Linha 143

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Lista de atividades (mÃ£ximo 4)
```

#### Linha 150

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Converte dados de auditoria em formato de atividades para exibiÃ§Ã£o
```

#### Linha 166

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Formata data em tempo relativo (hÃ£ X minutos, hÃ£ X horas)
```

#### Linha 174 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'hÃ£ ${difference.inMinutes} min';
```

#### Linha 176 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'hÃ£ ${difference.inHours}hÃ£';
```

#### Linha 178 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'hÃ£ ${difference.inDays}d';
```

#### Linha 184

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Retorna Ã­cone baseado no tipo de atividade
```

#### Linha 196 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    } else if (tipoLower.contains('preÃ£o') || tipoLower.contains('price') || tipoLower.contains('precifica')) {
```

#### Linha 198 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    } else if (tipoLower.contains('estratÃ£gia') || tipoLower.contains('strategy')) {
```

#### Linha 202 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    } else if (tipoLower.contains('login') || tipoLower.contains('auth') || tipoLower.contains('UsuÃ¡rio')) {
```

#### Linha 229 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    } else if (tipoLower.contains('preÃ£o') || tipoLower.contains('price')) {
```

#### Linha 253

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Ã­cone
```

#### Linha 267

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // DescriÃ£Ã£o
```

#### Linha 405 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'As aÃ£Ã£es do sistema aparecerÃ£o aqui',
```

---

### 📄 `features\pricing\presentation\screens\pricing_suggestions_screen.dart`

#### Linha 31 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  int get _promocoes => _sugestoes.where((s) => s.tipo == 'PromoÃ£Ã£o').length;
```

#### Linha 100 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Nenhuma suGestÃ£o disponÃ£vel',
```

#### Linha 109 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'As sugestÃ£es de IA aparecerÃ£o aqui',
```

#### Linha 166 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'SugestÃ£es Inteligentes',
```

#### Linha 171 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'AnÃ£lise automÃ£tica de preÃ£os',
```

#### Linha 212 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'EstratÃ£gia de SugestÃ£es AutomÃ£ticas',
```

#### Linha 236 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                            Text(value ? 'EstratÃ£gia ativada' : 'EstratÃ£gia desativada'),
```

#### Linha 266 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'PromoÃ£Ã£es',
```

#### Linha 491 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'VariAÃ§Ã£o: ${sugestao.variacao > 0 ? '+' : ''}${sugestao.variacao.toStringAsFixed(1)}%',
```

#### Linha 512 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      child: const Text('AnÃ£lise', style: TextStyle(fontSize: 13)),
```

#### Linha 560 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: const Text('AnÃ£lise Detalhada'),
```

#### Linha 576 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildAnaliseItem('HistÃ£rico de vendas: 30 dias'),
```

#### Linha 578 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildAnaliseItem('Elasticidade de preÃ£o: Calculada'),
```

#### Linha 579 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildAnaliseItem('ComparAÃ§Ã£o com concorrÃªncia'),
```

#### Linha 627 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: const Text('Confirmar SuGestÃ£o'),
```

#### Linha 632 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Aplicar suGestÃ£o para ${sugestao.produto}?',
```

#### Linha 647 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      const Text('PREÃ‡O atual:'),
```

#### Linha 654 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      const Text('Novo preÃ£o:'),
```

#### Linha 684 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      Text('SuGestÃ£o aplicada: ${sugestao.produto}'),
```

#### Linha 716 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            Text('SuGestÃ£o rejeitada: ${sugestao.produto}'),
```

---

### 📄 `features\tags\presentation\screens\tags_operations_screen.dart`

#### Linha 23

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// ObtÃ£m a lista de categorias do backend via provider
```

#### Linha 96 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Executar OperAÃ§Ã£o',
```

#### Linha 139

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o de voltar
```

#### Linha 188 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'OperaÃ£Ã£es em Lote',
```

#### Linha 205 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Gerenciar MÃ£ltiplas Tags',
```

#### Linha 311 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Selecione a OperAÃ§Ã£o',
```

#### Linha 333 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãµ` → `õ` (o com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Sincronizar preÃ£os e InformaÃ§Ãµes',
```

#### Linha 343 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Restaurar configuraÃ£Ã£es padrÃ£o',
```

#### Linha 362 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Testar ConexÃ£o',
```

#### Linha 363 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Verificar ComunicaÃ§Ã£o WiFi',
```

#### Linha 548 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Aplicar OperAÃ§Ã£o Em',
```

#### Linha 579 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Selecionar categorias especÃ­ficas',
```

#### Linha 900 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Resumo da OperAÃ§Ã£o',
```

#### Linha 932 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                _buildResumoItem('OperAÃ§Ã£o', _getOperacaoTexto(), Icons.settings_rounded),
```

#### Linha 992 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        return 'Testar ConexÃ£o';
```

#### Linha 1029 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            Text('Confirmar OperAÃ§Ã£o', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17))),
```

#### Linha 1045 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  Text('Esta operAÃ§Ã£o ã irreversÃ£vel! ', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11), fontWeight: FontWeight.bold, color: ThemeColors.of(context).primaryDark)),
```

#### Linha 1047 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  Text('Certifique-se de ter selecionado as opÃ£Ã£es corretas. ', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10))),
```

#### Linha 1059 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [SizedBox(width: ResponsiveHelper.getResponsiveWidth(context, mobile: 18, tablet: 19, desktop: 20), height: ResponsiveHelper.getResponsiveHeight(context, mobile: 18, tablet: 19, desktop: 20), child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface))), SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)), Expanded(child: Text('OperAÃ§Ã£o em andamento... ', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))))]), backgroundColor: ThemeColors.of(context).primaryDark, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))), duration: const Duration(seconds: 3)));
```

---

### 📄 `features\strategies\presentation\screens\strategy_report_screen.dart`

#### Linha 46 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: const Text('RelatÃ£rio de EstratÃ£gias'),
```

#### Linha 75 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Desempenho por EstratÃ£gia',
```

#### Linha 136 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'VisÃ£o Geral',
```

#### Linha 146 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Ã£ltimos 30 dias',
```

#### Linha 161 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'EstratÃ£gias Ativas',
```

#### Linha 189 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ROI MÃ£dio',
```

#### Linha 426 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      case 'MÃ£dio':
```

#### Linha 526 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              '? Nenhuma estratÃ£gia ativa para anÃ£lise',
```

#### Linha 539

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gera insights dinÃ£micos baseados nas EstratÃ©gias do provider
```

#### Linha 545

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Encontrar estratÃ£gia com melhor ROI
```

#### Linha 564

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Encontrar estratÃ£gia que afeta mais produtos
```

#### Linha 575

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // SuGestÃ£o para EstratÃ©gias inativas
```

#### Linha 580 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'texto': '? SuGestÃ£o: Ativar estratÃ£gia de ${sugestao.name} para aumentar vendas',
```

#### Linha 594 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'texto': '? EstratÃ£gias ativas geraram R\$ ${economiaTotal.toStringAsFixed(2)} de economia',
```

#### Linha 712 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'EvoluÃ£Ã£o de Vendas',
```

#### Linha 789 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            Text('Exportando relatÃ£rio em PDF...'),
```

#### Linha 806 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            Text('Exportando relatÃ£rio em Excel...'),
```

#### Linha 816

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// ConstrÃ£i Ã£rea do grÃ£fico com dados do backend
```

#### Linha 862 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Sem dados de vendas disponÃ­veis',
```

---

### 📄 `features\strategies\presentation\screens\calendar\holidays_screen.dart`

#### Linha 11

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Tela de configurAÃ§Ã£o de Datas Comemorativas
```

#### Linha 13

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Esta tela permite ao UsuÃ¡rio configurar eventos sazonais para ajustes
```

#### Linha 14

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// AutomÃ¡ticos de preÃ£o durante feriados e datas comemorativas.
```

#### Linha 257 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'EstratÃ£gia de CalendÃ£rio',
```

#### Linha 339 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: 'CalendÃ£rio',
```

#### Linha 551 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Reverter ApÃ£s Evento',
```

#### Linha 566 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Voltar preÃ£os ao normal apÃ£s a data',
```

#### Linha 663 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Ajuste de PREÃ‡O',
```

#### Linha 673 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Dias de AntecedÃ£ncia',
```

#### Linha 1085 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Ajuste de PREÃ‡O',
```

#### Linha 1183 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Dias de AntecedÃ£ncia',
```

#### Linha 1197 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Com quantos dias de antecedÃ£ncia aplicar ajuste?',
```

#### Linha 1274

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se nÃ£o houver categorias, usa lista padrÃ£o para UX
```

#### Linha 1277 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        : ['Bebidas', 'Mercearia', 'PerecÃ£veis', 'Limpeza', 'Chocolates', 'Panetones', 'Presentes', 'Todos'];
```

#### Linha 1404 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Configure eventos sazonais para ajustes AutomÃ¡ticos:',
```

#### Linha 1422 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildInfoItem('? Aplica ajustes com antecedÃ£ncia configurÃ£vel'),
```

#### Linha 1426 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildInfoItem('? Reverte preÃ£os automaticamente apÃ£s o evento'),
```

#### Linha 1430 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildInfoItem('? Maximiza vendas em perÃ£odos de alta demanda'),
```

#### Linha 1493 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    success ? 'ConfiguraÃ£Ã£es Salvas!' : 'Erro ao Salvar',
```

---

### 📄 `features\reports\presentation\providers\reports_provider.dart`

#### Linha 54

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Ticket MÃ©dio
```

#### Linha 57

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Ticket MÃ©dio formatado
```

#### Linha 63

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Crescimento MÃ©dio
```

#### Linha 66

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Pega o crescimento do primeiro relatÃ£rio ou calcula mÃ£dia
```

#### Linha 142

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // ERRO: API retornou falha - NÃ£O usar mock silenciosamente
```

#### Linha 145 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          error: response.message ?? 'Erro ao carregar relatÃ£rios da API',
```

#### Linha 150

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // ERRO: ExceÃ£Ã£o na chamada - mostrar erro ao UsuÃ¡rio
```

#### Linha 257 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          error: response.message ?? 'Erro ao carregar relatÃ£rio de auditoria',
```

#### Linha 345 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          error: response.message ?? 'Erro ao carregar relatÃ£rio operacional',
```

#### Linha 388

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Potencial de ganho mensal (soma das variaÃ£Ã£es positivas * 1000)
```

#### Linha 399 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'R\$ ${(potencial / 1000).toStringAsFixed(2).replaceAll('.', ',')}K/mÃ£s';
```

#### Linha 401 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    return 'R\$ ${potencial.toStringAsFixed(0)}/mÃ£s';
```

#### Linha 404

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// AÃ£Ã£es urgentes (reports com variAÃ§Ã£o negativa)
```

#### Linha 410

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Crescimento previsto (mÃ£dia das variaÃ£Ã£es positivas)
```

#### Linha 478 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          error: response.message ?? 'Erro ao carregar relatÃ£rio de performance',
```

#### Linha 506

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Provider de relatÃ£rios de vendas
```

#### Linha 514

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Provider de relatÃ£rios de auditoria
```

#### Linha 522

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Provider de relatÃ£rios operacionais
```

#### Linha 530

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Provider de relatÃ£rios de performance
```

---

### 📄 `features\pricing\presentation\screens\margins_screen.dart`

#### Linha 76 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        label: const Text('Ajuste AutomÃ£tico'),
```

#### Linha 128 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'RevisÃ£o de Margens',
```

#### Linha 133 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'AnÃ£lise de lucratividade',
```

#### Linha 143

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // TODO: Implementar configurAÃ§Ã£o de parÃ£metros
```

#### Linha 145 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                const SnackBar(content: Text('ConfiguraÃ£Ã£es em desenvolvimento')),
```

#### Linha 179 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'atenÃ§Ã£o NecessÃ£ria',
```

#### Linha 187 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  '$_criticos produto(s) com margem crÃ£tica e $_baixos com margem baixa',
```

#### Linha 208 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            _buildFilterChip('CrÃ£tico', 'critico', Icons.error_rounded, ThemeColors.of(context).error),
```

#### Linha 210 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            _buildFilterChip('atenÃ§Ã£o', 'atencao', Icons.warning_rounded, ThemeColors.of(context).orangeMaterial),
```

#### Linha 212 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            _buildFilterChip('SaudÃ£vel', 'saudavel', Icons.check_circle_rounded, ThemeColors.of(context).success),
```

#### Linha 379 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                            const Text('PREÃ‡O:', style: TextStyle(fontSize: 12)),
```

#### Linha 477 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: const Text('PREÃ‡O Sugerido'),
```

#### Linha 606 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: const Text('ParÃ£metros de Margem'),
```

#### Linha 613 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  const Expanded(child: Text('Margem MÃ­nima:')),
```

#### Linha 648

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // ForÃ£a rebuild para aplicar novos valores de margem
```

#### Linha 651

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Feedback visual para o UsuÃ¡rio
```

#### Linha 658 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      Text('ParÃ£metros atualizados: MÃ­nima ${_margemMinima.round()}%, Ideal ${_margemIdeal.round()}%'),
```

#### Linha 684 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: const Text('Ajuste AutomÃ£tico'),
```

#### Linha 686 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Aplicar margem ideal (${_margemIdeal.round()}%) em $_criticos produto(s) crÃ£tico(s) e $_baixos com margem baixa?',
```

---

### 📄 `features\import_export\presentation\screens\export_products_screen.dart`

#### Linha 33

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Getters para resultado de exportAÃ§Ã£o
```

#### Linha 37

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  int get _ignorados => 0; // ExportAÃ§Ã£o nÃ£o tem ignorados
```

#### Linha 54

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // HistÃ£rico de exportaÃ£Ã£es via provider
```

#### Linha 79

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Carregar histÃ£rico
```

#### Linha 127 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'ImportaÃ£Ã£es Recentes',
```

#### Linha 385 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildStepIndicator(2, 'ConcluÃ£do', Icons.check_circle_rounded, _currentStep >= 2),
```

#### Linha 690 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'ETAPA 1 - PREPARAÃ£Ã£O',
```

#### Linha 726 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Template com as colunas necessÃ£rias para importAÃ§Ã£o',
```

#### Linha 773 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  _buildColumnItem('CÃ£digo de Barras', 'obrigatÃ£rio'),
```

#### Linha 774 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  _buildColumnItem('Nome do Produto', 'obrigatÃ£rio'),
```

#### Linha 775 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  _buildColumnItem('PREÃ‡O', 'obrigatÃ£rio'),
```

#### Linha 864 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    final isObrigatorio = status == 'obrigatÃ£rio';
```

#### Linha 1181 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'MÃ£ximo: 10 MB',
```

#### Linha 1255 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildTipItem('CÃ£digos de barras devem ser Ã£nicos'),
```

#### Linha 1256 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildTipItem('PREÃ‡Os devem usar ponto como separador decimal'),
```

#### Linha 1257 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildTipItem('Produtos duplicados serÃ¡o ignorados'),
```

#### Linha 1258 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildTipItem('MÃ£ximo de 1.000 produtos por arquivo'),
```

#### Linha 1510

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Iniciar exportAÃ§Ã£o via provider (chama API real)
```

#### Linha 1520 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      _showErrorSnackBar('Erro na exportAÃ§Ã£o: $e');
```

---

### 📄 `features\import_export\presentation\screens\import_tags_screen.dart`

#### Linha 31

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // HistÃ£rico de importaÃ£Ã£es via provider
```

#### Linha 57

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Carregar histÃ£rico
```

#### Linha 101 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'ImportaÃ£Ã£es Recentes',
```

#### Linha 339 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildStepIndicator(2, 'ConcluÃ£do', Icons.check_circle_rounded, _currentStep >= 2),
```

#### Linha 512 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Template padronizado com as colunas necessÃ£rias',
```

#### Linha 559 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  _buildColumnItem('ID da Tag', 'obrigatÃ£rio', 'Ex: TAG-001, TAG-002'),
```

#### Linha 560 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  _buildColumnItem('LocalizAÃ§Ã£o', 'opcional', 'Corredor e prateleira'),
```

#### Linha 561 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  _buildColumnItem('ObservaÃ£Ã£es', 'opcional', 'Notas adicionais'),
```

#### Linha 648 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    final isObrigatorio = status == 'obrigatÃ£rio';
```

#### Linha 996 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'MÃ£ximo: 500 tags por arquivo',
```

#### Linha 1052 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Dicas de ImportAÃ§Ã£o',
```

#### Linha 1070 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildTipItem('?', 'IDs devem ser Ã£nicos (ex: TAG-001)'),
```

#### Linha 1071 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildTipItem('?', 'LocalizAÃ§Ã£o ã opcional mas recomendada'),
```

#### Linha 1072 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildTipItem('?', 'Tags duplicadas serÃ¡o ignoradas'),
```

#### Linha 1073 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildTipItem('?', 'MÃ£ximo de 500 tags por arquivo'),
```

#### Linha 1621 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Ajuda - ImportAÃ§Ã£o',
```

#### Linha 1680 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '3.   FaÃ£a o upload do arquivo',
```

#### Linha 1735 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'ã Devem ser Ã£nicos',
```

#### Linha 1747 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'ã MÃ£ximo 20 caracteres',
```

---

### 📄 `features\tags\presentation\screens\tags_batch_screen.dart`

#### Linha 63

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Obter tags disponÃ­veis do provider
```

#### Linha 67 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    } else if (_categoriaFiltro == 'DisponÃ£veis') {
```

#### Linha 213 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'OperaÃ£Ã£es em Lote',
```

#### Linha 227 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Gerenciar mÃ£ltiplas tags',
```

#### Linha 458 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Desassociar MÃ£ltiplas Tags',
```

#### Linha 633 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'Executar DesassociAÃ§Ã£o',
```

#### Linha 717 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Excluir MÃ£ltiplas Tags',
```

#### Linha 736 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Escolha o mÃ£todo de seleÃ£Ã£o:',
```

#### Linha 767 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'SeleÃ£Ã£o Manual',
```

#### Linha 800 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'ATENÃ£Ã£O: Esta operAÃ§Ã£o nÃ£o pode ser desfeita!',
```

#### Linha 989 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Filtros para seleÃ£Ã£o:',
```

#### Linha 1029 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                items: ['Todas', 'Associadas', 'DisponÃ£veis', 'Offline']
```

#### Linha 1131 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'Resumo da SincronizAÃ§Ã£o',
```

#### Linha 1187 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      label: Text(_processando ? 'Sincronizando...' : 'Executar SincronizAÃ§Ã£o', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
```

#### Linha 1223 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: Text('Confirmar DesassociAÃ§Ã£o', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17))),
```

#### Linha 1250

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // Executar desassociAÃ§Ã£o em lote via notifier
```

#### Linha 1333

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Executar sincronizAÃ§Ã£o real via provider
```

#### Linha 1349 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'SincronizAÃ§Ã£o ConcluÃ­da! ${result.successCount} de ${result.totalProcessed} tags.',
```

---

### 📄 `features\strategies\presentation\screens\performance\auto_clearance_screen.dart`

#### Linha 160 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'LiquidAÃ§Ã£o AutomÃ£tica',
```

#### Linha 311 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      '${state.products.length} Produtos em LiquidAÃ§Ã£o',
```

#### Linha 387 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'LiquidAÃ§Ã£o Progressiva',
```

#### Linha 444 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Produtos sem vendas sÃ£o automaticamente identificados e entram em liquidAÃ§Ã£o progressiva em 4 fases',
```

#### Linha 500 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Margem MÃ­nima Permitida',
```

#### Linha 509 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Desconto nÃ£o ultrapassa este limite',
```

#### Linha 575 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Produtos nÃ£o terÃ£o desconto que resulte em margem abaixo deste valor',
```

#### Linha 630 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Notificar Produtos em LiquidAÃ§Ã£o',
```

#### Linha 639 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Receber alertas quando produtos entrarem em liquidAÃ§Ã£o',
```

#### Linha 1125 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'PREÃ‡O Original',
```

#### Linha 1157 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'PREÃ‡O com Desconto',
```

#### Linha 1263

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Cria uma cÃ£pia local das categorias selecionadas para o diÃ£logo
```

#### Linha 1367 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'A liquidAÃ§Ã£o automÃ£tica identifica produtos parados e aplica descontos progressivos em 4 fases:',
```

#### Linha 1387 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Respeita a margem mÃ£nima configurada',
```

#### Linha 1394 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Tags ESL sÃ£o atualizadas automaticamente',
```

#### Linha 1426

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Salva as configuraÃ£Ã£es via provider
```

#### Linha 1446 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'ConfiguraÃ£Ã£es Salvas!',
```

#### Linha 1454 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'LiquidAÃ§Ã£o automÃ£tica ativa e configurada',
```

---

### 📄 `modules\categories\presentation\screens\categories_stats_screen.dart`

#### Linha 27

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Inicializa o provider de estatÃ£sticas
```

#### Linha 30

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // TambÃ£m carregar categorias se ainda nÃ£o carregadas
```

#### Linha 38

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Converte CategoryModel para Map<String, dynamic> para compatibilidade com estatÃ£sticas
```

#### Linha 44

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Buscar stats especÃ­ficas dessa categoria
```

#### Linha 134 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'EstatÃ£sticas',
```

#### Linha 225 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Visualize estatÃ£sticas detalhadas e tendÃ£ncias das categorias',
```

#### Linha 388 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: 'TendÃ£ncias',
```

#### Linha 465 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      _buildSummaryCard(context, 'Ticket MÃ£dio',
```

#### Linha 635 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'DistribuiÃ£Ã£o por Categoria',
```

#### Linha 1077 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        child: _buildMetricBox(context, 'Ticket MÃ£dio',
```

#### Linha 1450

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gera insights dinÃ£micos baseados nos dados das categorias
```

#### Linha 1457

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Ordena por faturamento para encontrar lÃ¡der
```

#### Linha 1515

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se nÃ£o hÃ£ insights, mostra mensagem padrÃ£o
```

#### Linha 1617 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: const Text('Exportar RelatÃ£rio'),
```

#### Linha 1621 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            const Text('Selecione o formato do relatÃ£rio:'),
```

#### Linha 1626 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              subtitle: const Text('RelatÃ£rio completo em PDF'),
```

#### Linha 1631 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    content: Text('Gerando relatÃ£rio PDF...'),
```

---

### 📄 `features\strategies\presentation\screens\ai_suggestions_screen.dart`

#### Linha 109 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'SugestÃ£es da IA',
```

#### Linha 230 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Filtrar SugestÃ£es',
```

#### Linha 262 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              title: const Text('ReduÃ£Ã£es'),
```

#### Linha 351 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'AnÃ£lise Inteligente',
```

#### Linha 509 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'ReduÃ£Ã£es',
```

#### Linha 562 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            _buildFilterChip('ReduÃ£Ã£es', 'reducao', Icons.trending_down_rounded),
```

#### Linha 777 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                              'ConfianÃ£a: ${sugestao['confianca']}%',
```

#### Linha 815 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                              'PREÃ‡O Atual',
```

#### Linha 869 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                              'PREÃ‡O Sugerido',
```

#### Linha 1309 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Nenhuma suGestÃ£o nesta categoria',
```

#### Linha 1363 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'SugestÃ£es atualizadas pela IA',
```

#### Linha 1400 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Aplicar SuGestÃ£o',
```

#### Linha 1412 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Alterar preÃ£o de "${sugestao['produto']}" para R\$ ${sugestao['preco_sugerido'].toStringAsFixed(2)}?',
```

#### Linha 1460 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'PREÃ‡O aplicado com sucesso',
```

#### Linha 1528 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'SuGestÃ£o rejeitada',
```

#### Linha 1580 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Aplicar ${_sugestoes.length} sugestÃ£es da IA automaticamente?',
```

#### Linha 1629 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        '$total sugestÃ£es aplicadas',
```

---

### 📄 `features\strategies\presentation\screens\environmental\peak_hours_screen.dart`

#### Linha 182 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'HorÃ£rio de Pico',
```

#### Linha 195 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'OtimizAÃ§Ã£o por Fluxo',
```

#### Linha 280 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: 'HorÃ¡rios',
```

#### Linha 287 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: 'HistÃ£rico',
```

#### Linha 402 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'OtimizAÃ§Ã£o por Fluxo',
```

#### Linha 498 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'OpÃ£Ã£es Gerais',
```

#### Linha 518 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Ajustes tambÃ£m nos sÃ£bados e domingos',
```

#### Linha 528 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Receber alertas quando preÃ£os forem alterados',
```

#### Linha 847 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          '${index}hÃ£',
```

#### Linha 1311 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'HorÃ£rio de Pico',
```

#### Linha 1327 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Sistema inteligente que otimiza preÃ£os baseado no fluxo de clientes:',
```

#### Linha 1342 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Analisa padrÃ£es de trÃ£fego em diferentes horÃ£rios',
```

#### Linha 1357 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Aumenta preÃ£os em horÃ£rios de pico (almoÃ£o, jantar)',
```

#### Linha 1372 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Reduz preÃ£os em horÃ£rios de baixo movimento',
```

#### Linha 1402 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Ajustes AutomÃ¡ticos a cada mudanÃ£a de perÃ£odo',
```

#### Linha 1462 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'ConfiguraÃ£Ã£es Salvas!',
```

#### Linha 1474 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'HorÃ£rio de Pico ativo e configurado',
```

---

### 📄 `features\strategies\presentation\screens\environmental\temperature_screen.dart`

#### Linha 189 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'PrecificAÃ§Ã£o por Temperatura',
```

#### Linha 202 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'IntegrAÃ§Ã£o com Clima',
```

#### Linha 294 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: 'HistÃ£rico',
```

#### Linha 414 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'IntegrAÃ§Ã£o com Clima',
```

#### Linha 665 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ConfigurAÃ§Ã£o API',
```

#### Linha 755 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              hintText: 'Ex: SÃ£o Paulo',
```

#### Linha 851 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'FrequÃ£ncia de AtualizAÃ§Ã£o',
```

#### Linha 1277 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Testando ConexÃ£o',
```

#### Linha 1330 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'ConexÃ£o Bem-Sucedida!',
```

#### Linha 1382 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'PrecificAÃ§Ã£o por Temperatura',
```

#### Linha 1398 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Sistema inteligente que ajusta preÃ£os baseado na temperatura:',
```

#### Linha 1413 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? IntegrAÃ§Ã£o com API OpenWeather em tempo real',
```

#### Linha 1428 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Aumenta preÃ£os de bebidas geladas em dias quentes',
```

#### Linha 1443 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Reduz preÃ£os de sorvetes em dias frios',
```

#### Linha 1458 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Aumenta preÃ£os de bebidas quentes no frio',
```

#### Linha 1473 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? AtualizaÃ£Ã£es automÃ£ticas a cada 30 minutos',
```

#### Linha 1525 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'ConfiguraÃ£Ã£es salvas com sucesso',
```

---

### 📄 `features\reports\presentation\screens\performance_report_screen.dart`

#### Linha 42 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'detalhes': 'ã Valor atual: ${report.valorAtual.toStringAsFixed(2)} ${report.unidade}\nÃ£ Meta: ${report.meta.toStringAsFixed(2)} ${report.unidade}\nÃ£ VariAÃ§Ã£o: ${report.variacao >= 0 ? '+' : ''}${report.variacao.toStringAsFixed(1)}%',
```

#### Linha 43 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'acao': report.metaAtingida ? 'Meta atingida' : 'Ajustar estratÃ£gia',
```

#### Linha 44 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'impacto': 'VariAÃ§Ã£o: ${report.variacao >= 0 ? '+' : ''}${report.variacao.toStringAsFixed(1)}%',
```

#### Linha 49 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'prazo': report.metaAtingida ? 'ConcluÃ£do' : '7-15 dias',
```

#### Linha 168 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Nenhum dado de performance disponÃ£vel',
```

#### Linha 173 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Execute EstratÃ©gias para gerar MÃ©tricas',
```

#### Linha 266 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'AnÃ£lise de Performance',
```

#### Linha 276 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Insights e RecomendaÃ£Ã£es IA',
```

#### Linha 368 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Powered by IA ã AnÃ£lise de 30 dias',
```

#### Linha 421 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  child: _buildMiniMetricIA('24', 'MÃ£dia', Icons.remove_rounded, ThemeColors.of(context).yellowGold),
```

#### Linha 757 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'AnÃ£lise de Performance',
```

#### Linha 810 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                                'RecomendAÃ§Ã£o IA',
```

#### Linha 957 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                _buildSummaryRow(Icons.warning_rounded, '${_performanceState.acoesUrgentes} aÃ£Ã£es urgentes necessÃ£rias', ThemeColors.of(context).error),
```

#### Linha 961 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                _buildSummaryRow(Icons.timeline_rounded, 'PrevisÃ£o: ${_performanceState.crescimentoPrevistoFormatted}', ThemeColors.of(context).primary),
```

#### Linha 1002

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Mostra lista detalhada do relatÃ£rio
```

#### Linha 1110

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Aplica AÃ§Ã£o do relatÃ£rio
```

#### Linha 1126 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              child: Text('Aplicando ${relatorio['titulo'] ?? 'relatÃ£rio'}...'),
```

---

### 📄 `features\import_export\presentation\screens\export_tags_screen.dart`

#### Linha 249 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'RelatÃ£rio Completo de ESLs',
```

#### Linha 494 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Formato de ExportAÃ§Ã£o',
```

#### Linha 690 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildFilterChip('disponiveis', 'DisponÃ£veis (121)', Icons.check_circle_rounded),
```

#### Linha 855 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'LocalizAÃ§Ã£o FÃ£sica',
```

#### Linha 856 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Corredor, prateleira e posiÃ£Ã£o',
```

#### Linha 866 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Nome, cÃ£digo e preÃ£o do produto',
```

#### Linha 875 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'MÃ£tricas de Performance',
```

#### Linha 876 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Bateria, sinal, uptime e atualizaÃ£Ã£es',
```

#### Linha 885 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'HistÃ£rico de Atividades',
```

#### Linha 886 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Ã£ltima atualizAÃ§Ã£o e eventos',
```

#### Linha 1069 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                _buildColumnChip('CÃ£digo'),
```

#### Linha 1070 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                _buildColumnChip('PREÃ‡O'),
```

#### Linha 1076 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                _buildColumnChip('LatÃ£ncia'),
```

#### Linha 1079 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                _buildColumnChip('Ã£ltima AtualizAÃ§Ã£o'),
```

#### Linha 1165 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Resumo da ExportAÃ§Ã£o',
```

#### Linha 1301

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Executar exportAÃ§Ã£o real via provider
```

#### Linha 1322 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        ? 'ExportAÃ§Ã£o ConcluÃ­da: ${_state.result!.recordCount} tags'
```

---

### 📄 `features\categories\presentation\screens\categories_stats_screen.dart`

#### Linha 28

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Inicializa o provider de estatÃ£sticas
```

#### Linha 31

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // TambÃ£m carregar categorias se ainda nÃ£o carregadas
```

#### Linha 39

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Converte CategoryModel para Map<String, dynamic> para compatibilidade com estatÃ£sticas
```

#### Linha 45

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Buscar stats especÃ­ficas dessa categoria
```

#### Linha 135 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'EstatÃ£sticas',
```

#### Linha 226 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Visualize estatÃ£sticas detalhadas e tendÃ£ncias das categorias',
```

#### Linha 389 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: 'TendÃ£ncias',
```

#### Linha 469 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'Ticket MÃ£dio',
```

#### Linha 640 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'DistribuiÃ£Ã£o por Categoria',
```

#### Linha 1085 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'Ticket MÃ£dio',
```

#### Linha 1459

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gera insights dinÃ£micos baseados nos dados das categorias
```

#### Linha 1466

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Ordena por faturamento para encontrar lÃ¡der
```

#### Linha 1524

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se nÃ£o hÃ£ insights, mostra mensagem padrÃ£o
```

#### Linha 1627 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: const Text('Exportar RelatÃ£rio'),
```

#### Linha 1631 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            const Text('Selecione o formato do relatÃ£rio:'),
```

#### Linha 1636 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              subtitle: const Text('RelatÃ£rio completo em PDF'),
```

#### Linha 1641 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    content: Text('Gerando relatÃ£rio PDF...'),
```

---

### 📄 `features\auth\presentation\widgets\store_selector.dart`

#### Linha 13

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Widget de seleÃ£Ã£o de loja/contexto de trabalho
```

#### Linha 22

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Se estÃ£ em modo compacto (apenas Ã­cone + nome)
```

#### Linha 45

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se nÃ£o pode trocar de loja, mostrar apenas texto
```

#### Linha 53

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// ConstrÃ£i a versÃ£o somente leitura (quando nÃ£o pode trocar)
```

#### Linha 90

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// ConstrÃ£i o ComboBox de seleÃ£Ã£o de loja
```

#### Linha 100 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Adicionar opÃ£Ã£o "Todas as lojas" no inÃ£cio se permitido
```

#### Linha 195

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Ã­cone da loja
```

#### Linha 280

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Mostrar popup de confirmAÃ§Ã£o usando ConfirmationDialog
```

#### Linha 284 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      message: 'vocÃª estÃ£ trocando de "$oldStoreName" para "$newStoreName".\n\n'
```

#### Linha 285 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Os seguintes dados serÃ¡o recarregados:\n'
```

#### Linha 288 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'ã PREÃ‡Os e EstratÃ©gias\n'
```

#### Linha 290 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Nenhum dado serÃ¡ perdido.',
```

#### Linha 341

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Retorna o Ã­cone baseado no escopo
```

#### Linha 354

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Widget indicador de contexto atual (versÃ£o simplificada)
```

#### Linha 425

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Dialog para seleÃ£Ã£o de loja (alternativa ao dropdown)
```

#### Linha 432

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Mostra o dialog de seleÃ£Ã£o de loja
```

#### Linha 472 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // OpÃ£Ã£o "Todas as lojas"
```

---

### 📄 `features\pricing\presentation\screens\ai_suggestions_screen.dart`

#### Linha 211 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'SugestÃ£es da IA',
```

#### Linha 225 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'InteligÃ£ncia artificial',
```

#### Linha 343 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'AnÃ£lise Inteligente',
```

#### Linha 402 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ReduÃ£Ã£es',
```

#### Linha 513 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            _buildFilterChip('ReduÃ£Ã£es', 'reducao', Icons.trending_down_rounded),
```

#### Linha 783 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'ConfianÃ£a: ${sugestao.confianca}%',
```

#### Linha 819 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'PREÃ‡O Atual',
```

#### Linha 873 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'PREÃ‡O Sugerido',
```

#### Linha 1273 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Nenhuma suGestÃ£o nesta categoria',
```

#### Linha 1299 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'SugestÃ£es atualizadas pela IA',
```

#### Linha 1319 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Aplicar SuGestÃ£o',
```

#### Linha 1331 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Alterar preÃ£o de "${sugestao.produtoNome}" para R\$ ${sugestao.precoSugerido.toStringAsFixed(2)}?',
```

#### Linha 1364 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'PREÃ‡O aplicado com sucesso',
```

#### Linha 1397 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'SuGestÃ£o rejeitada',
```

#### Linha 1433 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Aplicar $total sugestÃ£es da IA automaticamente?',
```

#### Linha 1464 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '$total sugestÃ£es aplicadas',
```

---

### 📄 `modules\dashboard\presentation\widgets\acoes_frequentes_card.dart`

#### Linha 8

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de aÃ£Ã£es frequentes baseado no uso real
```

#### Linha 9

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Substitui QuickActionsCard com aÃ£Ã£es mais relevantes
```

#### Linha 29

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ObtÃ£m dados para badges dinÃ£micos
```

#### Linha 32

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Produtos sem tag = total - vinculados (boundTagsCount representa quantas tags estÃ£o vinculadas)
```

#### Linha 36

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Produtos sem preÃ£o - busca nos alertas pelo type string
```

#### Linha 40 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      a.type.toLowerCase().contains('preÃ£o'))
```

#### Linha 83 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'AÃ£Ã£es Frequentes',
```

#### Linha 96 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'O que vocÃ£ mais faz',
```

#### Linha 109

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // AÃ£Ã£es em Grid (2x2) para mobile ou lista vertical para desktop
```

#### Linha 142 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  label: 'PREÃ‡Os',
```

#### Linha 170 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  label: 'RelatÃ£rio',
```

#### Linha 189 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          subtitle: 'AÃ£Ã£o mais frequente',
```

#### Linha 200 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          label: 'Atualizar PREÃ‡Os',
```

#### Linha 201 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          subtitle: 'EdiÃ£Ã£o em lote',
```

#### Linha 223 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          label: 'Ver RelatÃ£rio do Dia',
```

---

### 📄 `modules\dashboard\presentation\widgets\fluxos_inteligentes_card.dart`

#### Linha 9

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Detecta situaÃ£Ã£es e sugere prÃ£ximos passos automaticamente
```

#### Linha 32

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se nÃ£o hÃ£ fluxos, nÃ£o mostrar o card
```

#### Linha 57

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // TÃ£tulo
```

#### Linha 103

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Lista de fluxos (mÃ£ximo 3)
```

#### Linha 120 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        descricao: 'Vincule tags para exibir preÃ£os nos displays',
```

#### Linha 128

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Verificar tags nÃ£o vinculadas
```

#### Linha 134 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        titulo: '$tagsNaoVinculadas ${tagsNaoVinculadas == 1 ? "tag nÃ£o vinculada" : "tags nÃ£o vinculadas"}',
```

#### Linha 143

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Verificar importaÃ£Ã£es com erro
```

#### Linha 149 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        titulo: 'ImportAÃ§Ã£o com $importacoesComErro ${importacoesComErro == 1 ? "erro" : "erros"}',
```

#### Linha 150 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        descricao: 'Alguns produtos nÃ£o foram importados corretamente',
```

#### Linha 158

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Verificar produtos sem preÃ£o
```

#### Linha 164 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        titulo: '$produtosSemPreco ${produtosSemPreco == 1 ? "produto" : "produtos"} sem preÃ£o definido',
```

#### Linha 165 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        descricao: 'Defina preÃ£os para exibir nos displays',
```

#### Linha 167 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _FluxoAcao('Definir PREÃ‡Os', null, principal: true),
```

#### Linha 222

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // AÃ£Ã£es
```

---

### 📄 `features\sync\presentation\screens\sync_log_screen.dart`

#### Linha 32

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // ObtÃ£m logs do provider
```

#### Linha 217 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Log de SincronizAÃ§Ã£o',
```

#### Linha 231 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'HistÃ£rico detalhado',
```

#### Linha 581 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  items: ['Todos', 'Completa', 'PREÃ‡Os', 'Produtos Novos', 'Tags']
```

#### Linha 850 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      log.details ?? 'Nenhum detalhe disponÃ£vel.',
```

#### Linha 1153 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildInfoRow('UsuÃ£rio:', log.executedBy ?? 'Sistema'),
```

#### Linha 1157 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildInfoRow('DurAÃ§Ã£o:', log.durationFormatted),
```

#### Linha 1182 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                log.details ?? 'Nenhum detalhe disponÃ£vel.',
```

#### Linha 1401

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Gerar dados do log para exportAÃ§Ã£o
```

#### Linha 1409 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          content: Text('Nenhum log disponÃ£vel para exportar'),
```

#### Linha 1416

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Converter histÃ£rico para texto
```

#### Linha 1418 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    buffer.writeln('=== LOG DE SINCRONIZAÃ£Ã£O TAGBEAN ===');
```

#### Linha 1424 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      buffer.writeln('--- SincronizAÃ§Ã£o ${entry.id} ---');
```

#### Linha 1428 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      buffer.writeln('ConcluÃ£do: ${entry.completedAt}');
```

#### Linha 1432 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      buffer.writeln('DurAÃ§Ã£o: ${entry.duration?.inSeconds ?? 0}s');
```

---

### 📄 `features\strategies\presentation\screens\cross_selling\smart_combo_screen.dart`

#### Linha 291 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: 'ConfigurAÃ§Ã£o',
```

#### Linha 619 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'ConversÃ£o',
```

#### Linha 692 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'SugestÃ£es automÃ£ticas aparecem nas ESLs e integram com PDV no checkout',
```

#### Linha 759 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ParÃ£metros de Combos',
```

#### Linha 1168 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'SuGestÃ£o Automtica',
```

#### Linha 1169 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'IA sugere combos baseado em histÃ£rico de compras',
```

#### Linha 1178 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'IntegrAÃ§Ã£o com PDV',
```

#### Linha 1571 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'PREÃ‡O Combo',
```

#### Linha 1683 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'ConversÃ£o',
```

#### Linha 1862 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Taxa de conversÃ£o histrica',
```

#### Linha 1896

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Chama o mÃ£todo do provider para gerar combos via IA
```

#### Linha 2012 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              Text('? IntegrAÃ§Ã£o com PDV no checkout', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12), height: 1.5)),
```

#### Linha 2016 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              Text('? SugestÃ£es aparecem nas ESLs automaticamente', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12), height: 1.5)),
```

#### Linha 2033

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Salva as configuraÃ£Ã£es no backend
```

#### Linha 2073 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      Text('ConfiguraÃ£Ã£es Salvas!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
```

---

### 📄 `features\strategies\presentation\screens\performance\dynamic_markdown_screen.dart`

#### Linha 168 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ReduÃ£Ã£o por Validade',
```

#### Linha 306 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  '${state.products.length} produtos com desconto AutomÃ¡tico ativo',
```

#### Linha 370 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ReduÃ£Ã£o AutomÃ£tica',
```

#### Linha 431 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ReduÃ£Ã£o Progressiva Inteligente',
```

#### Linha 440 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'PREÃ‡Os sÃ£o ajustados automaticamente conforme a data de validade se aproxima, maximizando vendas e reduzindo perdas',
```

#### Linha 494 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Aplicar Apenas em PerecÃ£veis',
```

#### Linha 565 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Notificar Ajustes de PREÃ‡O',
```

#### Linha 636 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Categorias PerecÃ£veis',
```

#### Linha 973 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'PREÃ‡O Original',
```

#### Linha 1005 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'PREÃ‡O com Desconto',
```

#### Linha 1087 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Sistema inteligente de reduÃ£Ã£o de preÃ£os baseado em validade:',
```

#### Linha 1096 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Detecta automaticamente produtos prÃ£ximos ao vencimento',
```

#### Linha 1114 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Tags ESL sÃ£o atualizadas em tempo real',
```

#### Linha 1120 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? ReduÃ£Ã£o de 60-80% em perdas por vencimento',
```

#### Linha 1172 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'ConfiguraÃ£Ã£es Salvas!',
```

---

### 📄 `features\import_export\presentation\screens\import_products_screen.dart`

#### Linha 28

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Getters para compatibilidade com cÃ£digo existente
```

#### Linha 49

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // HistÃ£rico de importaÃ£Ã£es via provider
```

#### Linha 115 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'ImportaÃ£Ã£es Recentes',
```

#### Linha 383 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildStepIndicator(2, 'ConcluÃ£do', Icons.check_circle_rounded, _currentStep >= 2),
```

#### Linha 695 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'ETAPA 1 - PREPARAÃ£Ã£O',
```

#### Linha 731 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Template com as colunas necessÃ£rias para importAÃ§Ã£o',
```

#### Linha 774 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  _buildColumnItem('CÃ£digo de Barras', 'obrigatÃ£rio'),
```

#### Linha 775 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  _buildColumnItem('Nome do Produto', 'obrigatÃ£rio'),
```

#### Linha 776 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  _buildColumnItem('PREÃ‡O', 'obrigatÃ£rio'),
```

#### Linha 841 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    final isObrigatorio = status == 'obrigatÃ£rio';
```

#### Linha 1169 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'MÃ£ximo: 10 MB',
```

#### Linha 1248 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildTipItem('CÃ£digos de barras devem ser Ã£nicos'),
```

#### Linha 1249 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildTipItem('PREÃ‡Os devem usar ponto como separador decimal'),
```

#### Linha 1250 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildTipItem('Produtos duplicados serÃ¡o ignorados'),
```

#### Linha 1251 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildTipItem('MÃ£ximo de 1.000 produtos por arquivo'),
```

---

### 📄 `modules\dashboard\presentation\widgets\admin_panel_card.dart`

#### Linha 9

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Mostra opÃ£Ã£es de GestÃ£o baseadas na role do UsuÃ¡rio:
```

#### Linha 10

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// - PlatformAdmin: Gerenciar Clientes, Todas as Lojas, Todos os UsuÃ£rios
```

#### Linha 11

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// - ClientAdmin: Gerenciar Lojas, Gerenciar UsuÃ£rios
```

#### Linha 12

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// - StoreManager: Gerenciar UsuÃ£rios da Loja
```

#### Linha 39

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Operador nÃ£o vÃ£ este card
```

#### Linha 96 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                                : 'GestÃ£o da Loja',
```

#### Linha 147

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // AÃ£Ã£es administrativas
```

#### Linha 192 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                label: 'UsuÃ£rios',
```

#### Linha 201 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                label: 'ConfiguraÃ£Ã£es',
```

#### Linha 235 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          subtitle: isPlatformAdmin ? 'VisÃ£o global' : 'Lojas da empresa',
```

#### Linha 247 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          label: 'Gerenciar UsuÃ£rios',
```

#### Linha 248 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          subtitle: 'Acessos e permissÃ£es',
```

#### Linha 260 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          label: 'ConfiguraÃ£Ã£es',
```

#### Linha 261 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          subtitle: 'Sistema e integraÃ£Ã£es',
```

---

### 📄 `features\strategies\presentation\screens\calendar\sports_events_screen.dart`

#### Linha 198 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'DetecÃ£Ã£o de Jogos',
```

#### Linha 261 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã³` → `ó` (o com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: 'PrÃ³ximos Jogos',
```

#### Linha 360 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'DetecÃ£Ã£o AutomÃ£tica',
```

#### Linha 436 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ConfiguraÃ£Ã£es Gerais',
```

#### Linha 467 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Horas de AntecedÃ£ncia',
```

#### Linha 711 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Ajuste de PREÃ‡O',
```

#### Linha 861 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                Expanded(child: _buildJogoInfo(Icons.access_time_rounded, 'HorÃ£rio', game.time)),
```

#### Linha 929 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Ajuste de PREÃ‡O',
```

#### Linha 981

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se nÃ£o houver categorias, usa lista padrÃ£o para UX
```

#### Linha 984 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        : ['Bebidas', 'Snacks', 'CarvÃ£o', 'Carnes', 'Petiscos', 'Cervejas'];
```

#### Linha 1049 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Em breve vocÃ£ poderÃ£ adicionar novos times para monitoramento personalizado.',
```

#### Linha 1088 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              Text('? IntegrAÃ§Ã£o com calendÃ£rios esportivos', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12), height: 1.5)),
```

#### Linha 1090 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              Text('? Aumenta preÃ£os automaticamente em dias de jogos', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12), height: 1.5)),
```

#### Linha 1126 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    Text('ConfiguraÃ£Ã£es Salvas!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13))),
```

---

### 📄 `features\auth\presentation\screens\forgot_password_screen.dart`

#### Linha 8

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Tela de recuperAÃ§Ã£o de senha
```

#### Linha 115

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Ã­cone
```

#### Linha 133

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // TÃ£tulo
```

#### Linha 144

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // DescriÃ£Ã£o
```

#### Linha 146 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Digite seu email para receber as instruÃ£Ã£es de recuperAÃ§Ã£o de senha.',
```

#### Linha 171 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                return 'Por favor, digite um email vÃ¡lido';
```

#### Linha 202

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o de enviar
```

#### Linha 226 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Enviar instruÃ£Ã£es',
```

#### Linha 257

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // Ã­cone de sucesso
```

#### Linha 273

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // TÃ£tulo
```

#### Linha 283

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // DescriÃ£Ã£o
```

#### Linha 285 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Enviamos as instruÃ£Ã£es de recuperAÃ§Ã£o para:\n${_emailController.text}',
```

#### Linha 304

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // BotÃ£o voltar para login
```

#### Linha 334 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          child: const Text('NÃ£o recebeu? Enviar novamente'),
```

---

### 📄 `features\tags\presentation\widgets\tags_onboarding_card.dart`

#### Linha 7

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Estados possÃ£veis do onboarding - compatÃ­vel com tags_dashboard_screen.dart
```

#### Linha 9

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  none,             // Tudo OK - nÃ£o mostrar
```

#### Linha 11

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  manyUnbound,      // >30% sem vÃ£nculo
```

#### Linha 13

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  lowBattery,       // Muitas com bateria baixa (extensÃ£o do dashboard)
```

#### Linha 16

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de onboarding contextual para o mÃ£dulo Tags
```

#### Linha 17

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Exibe mensagens e aÃ£Ã£es baseadas no estado atual das tags
```

#### Linha 167 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          subtitle: 'Importe suas primeiras etiquetas ESL para comeÃ§ar',
```

#### Linha 175 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          title: 'Tags sem ComunicaÃ§Ã£o',
```

#### Linha 176 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          subtitle: 'Algumas etiquetas estÃ£o offline hÃ£ mais de 2 horas',
```

#### Linha 178 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã³` → `ó` (o com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          secondaryActionLabel: 'diagnÃ³stico',
```

#### Linha 185 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          subtitle: 'Algumas etiquetas precisam de atenÃ£Ã£o',
```

#### Linha 186 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          primaryActionLabel: 'Ver CrÃ£ticas',
```

#### Linha 194 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          subtitle: 'Vincule suas tags aos produtos para exibir preÃ£os',
```

---

### 📄 `features\reports\presentation\screens\sales_report_screen.dart`

#### Linha 198 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'RelatÃ£rios de Vendas',
```

#### Linha 220 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'AnÃ£lise de Performance Comercial',
```

#### Linha 414 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                _buildMiniStat(_salesState.ticketMedioFormatted, 'Ticket MÃ£dio', Icons.receipt_long_rounded),
```

#### Linha 513 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'PerÃ£odo:',
```

#### Linha 559 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              Expanded(child: _buildViewButton('grafico', 'grÃ¡fico', Icons.bar_chart_rounded)),
```

#### Linha 997 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Comparativo de PerÃ­odos',
```

#### Linha 1008 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildChartBar('MÃ£s Atual', 103500, 103500, ThemeColors.of(context).success),
```

#### Linha 1010 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildChartBar('MÃ£s Anterior', 90000, 103500, ThemeColors.of(context).primary),
```

#### Linha 1012 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildChartBar('HÃ£ 2 Meses', 85000, 103500, ThemeColors.of(context).greenLightMaterial),
```

#### Linha 1031 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Crescimento consistente de 15% ao mÃ£s',
```

#### Linha 1099

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Exporta relatÃ£rio em formato selecionado
```

#### Linha 1129 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      const Text('Exportar RelatÃ£rio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
```

#### Linha 1194

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Ver detalhes do relatÃ£rio
```

---

### 📄 `features\products\presentation\screens\products_dashboard_screen.dart`

#### Linha 646

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // SEÃ£Ã£O 1: Header
```

#### Linha 656

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // SEÃ£Ã£O 2: Busca Global
```

#### Linha 660

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // SEÃ£Ã£O 3: Onboarding Contextual (condicional)
```

#### Linha 666

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // SEÃ£Ã£O 4: Resumo do Catlogo (5 cards clicveis)
```

#### Linha 673

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // SEÃ£Ã£O 5: Aes Rpidas + Produtos em Destaque (2 colunas)
```

#### Linha 677

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // SEÃ£Ã£O 6: Categorias
```

#### Linha 681

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // SEÃ£Ã£O 7: Mapa do Mdulo (todos os menus disponveis)
```

#### Linha 693

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// SEÃ£Ã£O 2: Busca Global com Scanner
```

#### Linha 768

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// SEÃ£Ã£O 3: Onboarding Contextual
```

#### Linha 868

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// SEÃ£Ã£O 4: Resumo do Catlogo - 5 Cards Clicveis
```

#### Linha 1205

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// SEÃ£Ã£O 5: Aes Rpidas + Produtos em Destaque (2 colunas)
```

#### Linha 1543

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// SEÃ£Ã£O 6: Categorias com Chips e boto + Nova
```

#### Linha 1692

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// SEÃ£Ã£O 7: Mapa do Mdulo - Todos os menus disponveis em cards pequenos
```

---

### 📄 `modules\categories\presentation\screens\category_edit_screen.dart`

#### Linha 54

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Mapeamento de Ã­cones para strings
```

#### Linha 310 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'InformaÃ£Ã£es BÃ£sicas',
```

#### Linha 371 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              labelText: 'DescriÃ£Ã£o',
```

#### Linha 432 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'PersonalizAÃ§Ã£o Visual',
```

#### Linha 449 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Escolha um Ã­cone e uma cor para identificar sua categoria',
```

#### Linha 464 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Ã­cone',
```

#### Linha 986 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Salvar AlteraÃ£Ã£es',
```

#### Linha 1077 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Salvar AlteraÃ£Ã£es',
```

#### Linha 1129 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Descartar AlteraÃ£Ã£es?',
```

#### Linha 1142 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'vocÃª fez alteraÃ£Ã£es que nÃ£o foram salvas.\n\n'
```

#### Linha 1215 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'O nome da categoria ã obrigatÃ£rio',
```

#### Linha 1259

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      Navigator.pop(context, true); // Retorna true para indicar que houve atualizAÃ§Ã£o
```

---

### 📄 `features\strategies\presentation\screens\visual\flash_promos_screen.dart`

#### Linha 80 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Flash Promos', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.5)), Text('Ofertas relÃ¢mpago nas ESLs', style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textSecondary))])),
```

#### Linha 99 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        tabs: const [Tab(icon: Icon(Icons.settings_rounded, size: 18), text: 'ConfigurAÃ§Ã£o'), Tab(icon: Icon(Icons.flash_on_rounded, size: 18), text: 'PromoÃ£Ã£es')],
```

#### Linha 121 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: ThemeColors.of(context).error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: ThemeColors.of(context).error, width: 2)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.flash_on_rounded, size: 20, color: ThemeColors.of(context).error), const SizedBox(width: 8), Text('${state.promocoes.where((p) => p.ativa).length} promoÃ£Ã£es ativas', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ThemeColors.of(context).error))])),
```

#### Linha 140 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Flash Promos', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: ThemeColors.of(context).surface, letterSpacing: -0.8)), const SizedBox(height: 6), Text(state.isStrategyActive ? 'PromoÃ£Ã£es relÃ¢mpago ativas' : 'Sistema inativo', style: TextStyle(fontSize: 13, color: ThemeColors.of(context).surfaceOverlay70))])),
```

#### Linha 154 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: ThemeColors.of(context).blueMain.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.timer_rounded, color: ThemeColors.of(context).blueMain, size: 22)), const SizedBox(width: 14), const Expanded(child: Text('DurAÃ§Ã£o das PromoÃ£Ã£es', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.5)))]),
```

#### Linha 156 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          Row(children: [Icon(Icons.hourglass_top_rounded, size: 24, color: ThemeColors.of(context).blueMain), const SizedBox(width: 12), const Expanded(child: Text('DurAÃ§Ã£o PadrÃ£o', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))), Container(padding: EdgeInsets.symmetric(horizontal: AppSizes.mediumPadding.get(isMobile, isTablet), vertical: 6), decoration: BoxDecoration(color: ThemeColors.of(context).blueMain.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text('${state.duracaoMinutos} min', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ThemeColors.of(context).blueMain)))]),
```

#### Linha 173 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: ThemeColors.of(context).orangeDark.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.schedule_rounded, color: ThemeColors.of(context).orangeDark, size: 22)), const SizedBox(width: 14), const Expanded(child: Text('HorÃ¡rios AutomÃ£ticos', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.5)))]),
```

#### Linha 190 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        _buildSwitchOption('Notificar Clientes', 'Enviar push notification aos clientes prÃ£ximos', Icons.notifications_active_rounded, state.notificarClientes, (value) => ref.read(flashPromosProvider.notifier).setNotificarClientes(value)),
```

#### Linha 192 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        _buildSwitchOption('Contagem Regressiva', 'Exibir timer na ESL durante promoÃ£Ã£o', Icons.timer_rounded, state.contagemRegressiva, (value) => ref.read(flashPromosProvider.notifier).setContagemRegressiva(value)),
```

#### Linha 194 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        _buildSwitchOption('AnimAÃ§Ã£o Piscante', 'LED piscante para chamar atenÃ£Ã£o', Icons.lightbulb_rounded, state.animacaoPiscante, (value) => ref.read(flashPromosProvider.notifier).setAnimacaoPiscante(value)),
```

#### Linha 243 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    showDialog(context: context, builder: (context) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).error, size: 56), title: const Text('Flash Promos'), content: const SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Crie promoÃ£Ã£es relÃ¢mpago com urgÃªncia:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), SizedBox(height: 16), Text(' Ofertas por tempo limitado', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Contagem regressiva nas ESLs', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' LED piscante para urgÃªncia', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' NotificAÃ§Ã£o push para clientes', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Aumenta conversÃ£o em 30-50%', style: TextStyle(fontSize: 13, height: 1.5))])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendi'))]));
```

#### Linha 249 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface), const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('ConfiguraÃ£Ã£es Salvas!', style: TextStyle(fontWeight: FontWeight.bold)), Text('Flash promos configuradas', style: TextStyle(fontSize: 12))]))]), backgroundColor: ThemeColors.of(context).error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
```

---

### 📄 `features\strategies\presentation\screens\visual\heatmap_screen.dart`

#### Linha 154 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                Text('atenÃ§Ã£o Visual Inteligente', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11), overflow: TextOverflow.ellipsis, color: ThemeColors.of(context).textSecondary)),
```

#### Linha 184 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          Tab(icon: Icon(Icons.settings_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)), text: 'ConfigurAÃ§Ã£o'),
```

#### Linha 264 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                Text('atenÃ§Ã£o Direcionada', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 17, mobileFontSize: 15, tabletFontSize: 16), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold, color: ThemeColors.of(context).surface, letterSpacing: -0.8)),
```

#### Linha 293 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                Text('IntegrAÃ§Ã£o com CÃ£meras', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold)),
```

#### Linha 295 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                Text('Sistema detecta trÃ£fego em tempo real via anÃ£lise de vÃ­deo com IA', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11), overflow: TextOverflow.ellipsis, height: 1.5)),
```

#### Linha 328 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            Expanded(child: Text('ParÃ£metros de AtivAÃ§Ã£o', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold, letterSpacing: -0.5))),
```

#### Linha 338 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          Container(padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)), decoration: BoxDecoration(color: ThemeColors.of(context).infoPastel, borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet))), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.info_rounded, size: AppSizes.iconTiny.get(isMobile, isTablet), color: ThemeColors.of(context).infoDark), SizedBox(width: AppSizes.paddingXs.get(isMobile, isTablet)), Expanded(child: Text('ESLs piscam quando trÃ£fego estÃ£ abaixo deste percentual', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10, tabletFontSize: 10), overflow: TextOverflow.ellipsis, color: ThemeColors.of(context).infoDark)))])),
```

#### Linha 345 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            Container(padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingBase.get(isMobile, isTablet), vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet)), decoration: BoxDecoration(color: ThemeColors.of(context).orangeMain.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))), child: DropdownButton<String>(value: state.intensidadePiscar, underline: const SizedBox(), items: ['Baixa', 'MÃ£dia', 'Alta', 'Muito Alta'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13), overflow: TextOverflow.ellipsis)))).toList(), onChanged: (value) => ref.read(heatmapProvider.notifier).setIntensidadePiscar(value!), style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13), fontWeight: FontWeight.bold, color: ThemeColors.of(context).orangeMain))),
```

#### Linha 351 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            Expanded(child: Text('AtualizAÃ§Ã£o do Mapa', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14, tabletFontSize: 14), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600))),
```

#### Linha 370 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        _buildSwitchOption('IntegrAÃ§Ã£o com CÃ£meras', 'Usar anÃ£lise de vÃ­deo para detecÃ£Ã£o', Icons.videocam_rounded, state.integracaoCameras, (value) => ref.read(heatmapProvider.notifier).setIntegracaoCameras(value)),
```

#### Linha 421 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    showDialog(context: context, builder: (context) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).error, size: 56), title: const Text('Mapa de Calor'), content: const SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Direciona atenÃ£Ã£o para zonas frias da loja:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), SizedBox(height: 16), Text(' ESLs piscam em Ã¡reas pouco visitadas', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' IntegrAÃ§Ã£o com cÃ£meras para detecÃ£Ã£o', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Ajuste AutomÃ¡tico de preÃ£os', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Aumento de trÃ£fego em zonas frias', style: TextStyle(fontSize: 13, height: 1.5))])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendi'))]));
```

#### Linha 427 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('ConfiguraÃ£Ã£es Salvas!', style: TextStyle(fontWeight: FontWeight.bold)), Text('Mapa de calor configurado', style: TextStyle(fontSize: 12))]))]), backgroundColor: ThemeColors.of(context).error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
```

---

### 📄 `features\categories\presentation\screens\category_edit_screen.dart`

#### Linha 54

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Mapeamento de Ã­cones para strings
```

#### Linha 307 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'InformaÃ£Ã£es BÃ£sicas',
```

#### Linha 368 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              labelText: 'DescriÃ£Ã£o',
```

#### Linha 428 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'PersonalizAÃ§Ã£o Visual',
```

#### Linha 445 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Escolha um Ã­cone e uma cor para identificar sua categoria',
```

#### Linha 460 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Ã­cone',
```

#### Linha 979 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Salvar AlteraÃ£Ã£es',
```

#### Linha 1070 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Salvar AlteraÃ£Ã£es',
```

#### Linha 1121 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Descartar AlteraÃ£Ã£es?',
```

#### Linha 1134 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'vocÃª fez alteraÃ£Ã£es que nÃ£o foram salvas.\n\n'
```

#### Linha 1206 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'O nome da categoria ã obrigatÃ£rio',
```

#### Linha 1250

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      Navigator.pop(context, true); // Retorna true para indicar que houve atualizAÃ§Ã£o
```

---

### 📄 `design_system\theme\app_theme.dart`

#### Linha 30

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Tema principal da aplicAÃ§Ã£o TagBean
```

#### Linha 34

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gera um tema baseado em cores primÃ£ria e secundÃ£ria
```

#### Linha 43

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Cores dinÃ¢micas
```

#### Linha 81

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // BotÃ£es com cores dinÃ¢micas
```

#### Linha 161

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Bottom Navigation com cores dinÃ¢micas
```

#### Linha 170

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Navigation Rail com cores dinÃ¢micas
```

#### Linha 195

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Chip com cores dinÃ¢micas
```

#### Linha 204

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Floating Action Button com cores dinÃ¢micas
```

#### Linha 211

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Checkbox com cores dinÃ¢micas
```

#### Linha 222

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Switch com cores dinÃ¢micas
```

#### Linha 238

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Radio com cores dinÃ¢micas
```

#### Linha 270

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Tema claro (usa cores padrÃ£o)
```

---

### 📄 `app\app.dart`

#### Linha 63

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Widget principal da aplicAÃ§Ã£o TagBean
```

#### Linha 72

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Observa o tema atual para aplicar cores dinÃ¢micas
```

#### Linha 85

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // Tema dinÃ£mico baseado na seleÃ£Ã£o do UsuÃ¡rio
```

#### Linha 93

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // NavegAÃ§Ã£o
```

#### Linha 106

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Mapa de rotas estÃ£ticas
```

#### Linha 161

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gerador de rotas dinÃ¢micas (com parÃ£metros)
```

#### Linha 208

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se nÃ£o encontrou, retorna null para usar onUnknownRoute
```

#### Linha 212

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Rota para pÃ£ginas nÃ£o encontradas
```

#### Linha 216 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        appBar: AppBar(title: const Text('PÃ£gina nÃ£o encontrada')),
```

#### Linha 228 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Rota "${settings.name}" nÃ£o encontrada',
```

#### Linha 237 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                child: const Text('Voltar ao inÃ£cio'),
```

---

### 📄 `modules\dashboard\presentation\widgets\oportunidades_lucro_card.dart`

#### Linha 8

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de Oportunidades de Lucro (SugestÃ£es IA reestruturado)
```

#### Linha 9

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Mostra oportunidades de ajuste de preÃ£o identificadas pela IA
```

#### Linha 32

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ObtÃ£m dados de sugestÃ£es da IA
```

#### Linha 43

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Calcula ganho potencial somando as variaÃ£Ã£es positivas
```

#### Linha 48

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se nÃ£o hÃ£ sugestÃ£es, mostra versÃ£o compacta
```

#### Linha 81

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // Header com Ã­cone de IA
```

#### Linha 163

**Padroes encontrados:**
- `Ãº` → `ú` (u com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // 3 NÃºmeros chave
```

#### Linha 194 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    label: 'potencial/mÃ£s',
```

#### Linha 203

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // BotÃ£es de AÃ§Ã£o
```

#### Linha 211 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Revisar SugestÃ£es',
```

#### Linha 291 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Nenhuma suGestÃ£o disponÃ£vel no momento',
```

---

### 📄 `modules\dashboard\presentation\widgets\status_geral_sistema_card.dart`

#### Linha 9

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Mostra o estado geral do sistema em um Ã£nico olhar
```

#### Linha 56

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // TÃ£tulo
```

#### Linha 132 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          title: 'SincronizAÃ§Ã£o',
```

#### Linha 134 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          actionLabel: 'ForÃ£ar',
```

#### Linha 153 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          subtitle: produtosSemPreco > 0 ? '$produtosSemPreco sem preÃ£o' : 'Todos OK',
```

#### Linha 191 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              title: 'SincronizAÃ§Ã£o',
```

#### Linha 193 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              actionLabel: 'ForÃ£ar',
```

#### Linha 216 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            subtitle: produtosSemPreco > 0 ? '$produtosSemPreco sem preÃ£o' : 'Todos com preÃ£o',
```

#### Linha 318 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (difference.inMinutes < 60) return 'HÃ£ ${difference.inMinutes} min';
```

#### Linha 319 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (difference.inHours < 24) return 'HÃ£ ${difference.inHours}hÃ£';
```

#### Linha 320 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    return 'HÃ£ ${difference.inDays}d';
```

---

### 📄 `modules\categories\presentation\screens\categories_menu_screen.dart`

#### Linha 36

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Responsividade disponÃ£vel via ResponsiveHelper se necessÃ£rio
```

#### Linha 343 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Sobre este MÃ£dulo',
```

#### Linha 366 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Organize produtos em categorias para facilitar a GestÃ£o e navegAÃ§Ã£o do seu catÃ£logo.',
```

#### Linha 395 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      {'label': 'PerecÃ£veis', 'valor': '189', 'icon': Icons.dining_rounded, 'cor': colors.greenMaterial, 'mudanca': '+7', 'tipo': 'aumento'},
```

#### Linha 596 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'titulo': 'AdministrAÃ§Ã£o Completa',
```

#### Linha 597 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'subtitulo': 'Controle total e avanÃ£ado',
```

#### Linha 604 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'titulo': 'EstatÃ£sticas',
```

#### Linha 605 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'subtitulo': 'AnÃ¡lises e relatÃ£rios',
```

#### Linha 612 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'subtitulo': 'GestÃ£o em lote',
```

#### Linha 835

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // Implementar importAÃ§Ã£o
```

#### Linha 852

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // Implementar exportAÃ§Ã£o
```

---

### 📄 `features\strategies\presentation\screens\performance\ai_forecast_screen.dart`

#### Linha 442 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'ltima atualizAÃ§Ã£o: 22/11/2025 s 03:15',
```

#### Linha 571 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'ParÃ£metros do Modelo',
```

#### Linha 593 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Perodo HistÃ£rico de Anlise',
```

#### Linha 672 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Nvel de ConfianÃ£a Mnimo',
```

#### Linha 728 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Previses abaixo deste nvel nÃ£o sero exibidas',
```

#### Linha 1021 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'DistribuiÃ£Ã£o Visual',
```

#### Linha 1281 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      case 'HistÃ£rico de Vendas':
```

#### Linha 1319 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Analisando ${ref.read(aiForecastProvider).historicalPeriod} dias de histÃ£rico...',
```

#### Linha 1421 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Analisa histÃ£rico de vendas e padres de comportamento',
```

#### Linha 1442 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Sugere ajustes de preÃ£o e estoque proativamente',
```

#### Linha 1489 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'ConfiguraÃ£Ã£es do motor de IA salvas com sucesso',
```

---

### 📄 `features\reports\presentation\screens\operational_report_screen.dart`

#### Linha 28

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// ObtÃ£m o storeId do UsuÃ¡rio logado
```

#### Linha 52 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'detalhes': 'ã ${report.titulo}\nÃ£ PerÃ£odo: ${report.periodo}\nÃ£ Meta: ${report.percentualMeta.toStringAsFixed(1)}%',
```

#### Linha 163 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Nenhum dado operacional disponÃ£vel',
```

#### Linha 168 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Os dados operacionais serÃ¡o exibidos quando houver atividade',
```

#### Linha 303 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'RelatÃ£rios Operacionais',
```

#### Linha 325 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Monitoramento de Tags e SincronizAÃ§Ã£o',
```

#### Linha 540

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // EstatÃ£sticas de tags do backend
```

#### Linha 663 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'PerÃ£odo:',
```

#### Linha 1002 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'AnÃ£lise Detalhada',
```

#### Linha 1164 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        badgeText = 'MÃ£DIA';
```

#### Linha 1230 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã³` → `ó` (o com acento agudo)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'PrÃ³xima atualizAÃ§Ã£o em 30 segundos',
```

---

### 📄 `features\pricing\presentation\screens\margins_review_screen.dart`

#### Linha 109 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            const Text('Exportando relatÃ£rio...'),
```

#### Linha 180 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'RevisÃ£o de Margens',
```

#### Linha 189 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'AnÃ£lise de rentabilidade',
```

#### Linha 559 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Dicas de AnÃ£lise de Margens',
```

#### Linha 570 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildDicaItem('Margens negativas indicam prejuÃ£zo - ajuste urgente'),
```

#### Linha 571 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildDicaItem('Margens baixas (<10%) podem nÃ£o cobrir despesas'),
```

#### Linha 572 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildDicaItem('Margens altas podem ser oportunidade para promoÃ£Ã£es'),
```

#### Linha 624 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Ajustar PREÃ‡O',
```

#### Linha 659 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    Text('SituAÃ§Ã£o Atual:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5))),
```

#### Linha 690 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  labelText: 'Novo PREÃ‡O de Venda',
```

#### Linha 726 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        Expanded(child: Text('PREÃ‡O de ${item.nome} atualizado!')),
```

---

### 📄 `features\pricing\presentation\screens\percentage_adjustment_screen.dart`

#### Linha 126 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'PrÃ£-visualizAÃ§Ã£o',
```

#### Linha 209 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'AlterAÃ§Ã£o massiva de preÃ£os',
```

#### Linha 240 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'AÃ£Ã£es RÃ£pidas',
```

#### Linha 705 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'ConfiguraÃ£Ã£es AvanÃ£adas',
```

#### Linha 724 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Respeitar Margem MÃ­nima',
```

#### Linha 725 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'NÃ£o reduzir abaixo de ${_config.margemMinimaSeguranca}%',
```

#### Linha 750 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Sincronizar automaticamente apÃ£s aplicar',
```

#### Linha 1086 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            const Text('vocÃª estÃ£ prestes a aplicar:'),
```

#### Linha 1102 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    '${isAumento ? 'Aumento' : 'ReduÃ£Ã£o'} de ${_config.valor}%',
```

#### Linha 1108 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  if (_config.notificarTags) const Text('ã Tags ESL serÃ¡o notificadas'),
```

#### Linha 1114 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Esta operAÃ§Ã£o nÃ£o pode ser desfeita.',
```

---

### 📄 `features\pricing\presentation\screens\pricing_fixed_screen.dart`

#### Linha 201 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Alterar preÃ£os em R\$',
```

#### Linha 283 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'ConfigurAÃ§Ã£o do Ajuste',
```

#### Linha 331 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ReduÃ£Ã£o',
```

#### Linha 370 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  ? 'Valor que serÃ¡ adicionado a cada produto'
```

#### Linha 371 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  : 'Valor que serÃ¡ subtraÃ£do de cada produto',
```

#### Linha 529 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'SeleÃ£Ã£o de Produtos',
```

#### Linha 554 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildSelecaoOption('Por faixa de preÃ£o', 2, Icons.price_change_rounded),
```

#### Linha 574 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              label: Text(_calculando ? 'Calculando...' : 'Calcular PrÃ£via'),
```

#### Linha 671 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              labelText: 'PREÃ‡O mÃ£nimo',
```

#### Linha 686 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              labelText: 'PREÃ‡O mÃ£ximo',
```

#### Linha 733 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'PrÃ£via do Ajuste',
```

---

### 📄 `features\pricing\presentation\screens\pricing_individual_screen.dart`

#### Linha 201 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Alterar produto especÃ£fico',
```

#### Linha 318 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    labelText: 'Nome ou CÃ£digo de Barras',
```

#### Linha 378 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                            const Text('Escaneando cÃ£digo de barras...'),
```

#### Linha 518 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'PREÃ‡O Atual',
```

#### Linha 602 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Novo PREÃ‡O',
```

#### Linha 619 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              labelText: 'Novo PREÃ‡O',
```

#### Linha 645 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              label: const Text('Aplicar Novo PREÃ‡O'),
```

#### Linha 692 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'HistÃ£rico de PREÃ‡Os',
```

#### Linha 707 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Nenhum histÃ£rico disponÃ£vel',
```

#### Linha 759 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                item.reason ?? 'AlterAÃ§Ã£o de preÃ£o',
```

#### Linha 794 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              Text('PREÃ‡O de ${_produtoSelecionado!.nome} atualizado!'),
```

---

### 📄 `features\tags\presentation\widgets\tag_minew_sync_card.dart`

#### Linha 7

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// EstatÃ£sticas de sincronizAÃ§Ã£o Minew das tags
```

#### Linha 49

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Contagem por status de sincronizAÃ§Ã£o
```

#### Linha 69

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Encontrar Ã£ltima sincronizAÃ§Ã£o
```

#### Linha 89

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card para exibir status de sincronizAÃ§Ã£o Minew das tags
```

#### Linha 148 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'SincronizAÃ§Ã£o Minew',
```

#### Linha 272 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Progresso de SincronizAÃ§Ã£o',
```

#### Linha 381 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (diff.inMinutes < 60) return 'hÃ£ ${diff.inMinutes} min';
```

#### Linha 382 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (diff.inHours < 24) return 'hÃ£ ${diff.inHours}hÃ£';
```

#### Linha 383 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (diff.inDays < 7) return 'hÃ£ ${diff.inDays} dias';
```

#### Linha 474

**Padroes encontrados:**
- `Ãµ` → `õ` (o com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Widget para exibir InformaÃ§Ãµes de temperatura da tag
```

---

### 📄 `features\strategies\presentation\screens\strategies_config_screen.dart`

#### Linha 48

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Cache de EstratÃ©gias filtradas
```

#### Linha 63

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Inicializa o provider se ainda nÃ£o foi inicializado
```

#### Linha 89 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      case 'PrecificAÃ§Ã£o por Temperatura':
```

#### Linha 93 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      case 'LiquidAÃ§Ã£o Automtica':
```

#### Linha 101 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      case 'Mapa de Calor de PromoÃ£Ã£es':
```

#### Linha 105 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      case 'PromoÃ£Ã£es Relmpago':
```

#### Linha 120

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // OTIMIZAÃ£Ã£O: Getter com cache
```

#### Linha 256 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'EstratÃ£gias AutomÃ£ticas',
```

#### Linha 274 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Inteligncia Artificial para PrecificAÃ§Ã£o',
```

#### Linha 547 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                hintText: 'Buscar EstratÃ©gias...',
```

---

### 📄 `features\strategies\presentation\screens\visual\realtime_ranking_screen.dart`

#### Linha 80 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Ranking Tempo Real', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.5)), Text('GamificaÃ§Ã£o nas ESLs', style: TextStyle(fontSize: 12, color: ThemeColors.of(context).textSecondary))])),
```

#### Linha 98 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        tabs: const [Tab(icon: Icon(Icons.settings_rounded, size: 18), text: 'ConfigurAÃ§Ã£o'), Tab(icon: Icon(Icons.emoji_events_rounded, size: 18), text: 'Top 5')],
```

#### Linha 120 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: ThemeColors.of(context).greenMain.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: ThemeColors.of(context).greenMain, width: 2)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.circle, size: 10, color: ThemeColors.of(context).successIcon), const SizedBox(width: 8), Text('Atualizado hÃ£ 2 min', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ThemeColors.of(context).successIcon))])),
```

#### Linha 138 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Efeito Manada', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: ThemeColors.of(context).surface, letterSpacing: -0.8)), const SizedBox(height: 6), Text(state.isStrategyActive ? 'PosiÃ£Ã£es exibidas nas ESLs' : 'Sistema inativo', style: TextStyle(fontSize: 13, color: ThemeColors.of(context).surfaceOverlay70))])),
```

#### Linha 152 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: ThemeColors.of(context).blueMain.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.tune_rounded, color: ThemeColors.of(context).blueMain, size: 22)), const SizedBox(width: 14), const Expanded(child: Text('ParÃ£metros de ExibiÃ£Ã£o', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.5)))]),
```

#### Linha 154 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          Row(children: [Icon(Icons.refresh_rounded, size: 24, color: ThemeColors.of(context).blueMain), const SizedBox(width: 12), const Expanded(child: Text('Intervalo de AtualizAÃ§Ã£o', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))), Container(padding: EdgeInsets.symmetric(horizontal: AppSizes.mediumPadding.get(isMobile, isTablet), vertical: 6), decoration: BoxDecoration(color: ThemeColors.of(context).blueMain.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text('${state.intervaloAtualizacao} min', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ThemeColors.of(context).blueMain)))]),
```

#### Linha 187 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        _buildSwitchOption('Exibir PosiÃ£Ã£o', 'Mostrar medalha de posiÃ£Ã£o nas ESLs', Icons.emoji_events_rounded, state.exibirPosicao, (value) => ref.read(realtimeRankingProvider.notifier).setExibirPosicao(value)),
```

#### Linha 189 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        _buildSwitchOption('AnimAÃ§Ã£o de Subida', 'Efeito visual quando produto sobe no ranking', Icons.trending_up_rounded, state.animacaoSubida, (value) => ref.read(realtimeRankingProvider.notifier).setAnimacaoSubida(value)),
```

#### Linha 276 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    showDialog(context: context, builder: (context) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).warning, size: 56), title: const Text('Ranking Tempo Real'), content: const SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Exibe posiÃ£Ã£o de vendas nas etiquetas eletrÃ£nicas:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), SizedBox(height: 16), Text(' Ranking atualizado automaticamente', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' GamificAÃ§Ã£o aumenta o engajamento', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Clientes veem produtos mais vendidos', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Efeito manada impulsiona vendas', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Aumenta conversÃ£o em 15-25%', style: TextStyle(fontSize: 13, height: 1.5))])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendi'))]));
```

#### Linha 282 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('ConfiguraÃ£Ã£es Salvas!', style: TextStyle(fontWeight: FontWeight.bold)), Text('Ranking tempo real configurado', style: TextStyle(fontSize: 12))]))]), backgroundColor: ThemeColors.of(context).warning, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
```

---

### 📄 `features\pricing\presentation\screens\individual_adjustment_screen.dart`

#### Linha 144 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'EdiÃ£Ã£o produto a produto',
```

#### Linha 179 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          hintText: 'Buscar produto por nome ou cÃ£digo...',
```

#### Linha 270 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'PREÃ‡O',
```

#### Linha 444 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                              'PREÃ‡O Atual',
```

#### Linha 475 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'Editar PREÃ‡O',
```

#### Linha 606 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Editar PREÃ‡O',
```

#### Linha 635 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                labelText: 'Novo PREÃ‡O',
```

#### Linha 707 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Ajuste RÃ£pido:',
```

#### Linha 753 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          const Text('PREÃ‡O atualizado com sucesso'),
```

#### Linha 795 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  Text('PREÃ‡O ajustado $label'),
```

---

### 📄 `features\auth\presentation\screens\login_screen.dart`

#### Linha 36

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // PrÃ£-preencher credenciais para desenvolvimento
```

#### Linha 78

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // AutenticAÃ§Ã£o via Backend
```

#### Linha 133

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Navega para o Dashboard com animAÃ§Ã£o
```

#### Linha 301 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'PREÃ£O INTELIGENTE',
```

#### Linha 419 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'UsuÃ£rio',
```

#### Linha 466 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              return 'Por favor, insira seu UsuÃ¡rio';
```

#### Linha 642 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Etiquetas EletrÃ£nicas Inteligentes',
```

#### Linha 667

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // BOTÃO DEBUG - MOSTRA TODAS AS CORES DA TELA DE LOGIN
```

#### Linha 711 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    debugPrint('║ BOTÃO ENTRAR:                                                    ║');
```

#### Linha 811

**Padroes encontrados:**
- `Ã³` → `ó` (o com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Ponto central sÃ³lido
```

---

### 📄 `modules\dashboard\presentation\widgets\compact_sync_card.dart`

#### Linha 9

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card compacto de status de sincronizAÃ§Ã£o
```

#### Linha 10

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Exibe estatÃ£sticas de produtos e tags sincronizados
```

#### Linha 14

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãº` → `ú` (u com acento agudo)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Formata NÃºmero para exibiÃ§Ã£o (ex: 1234 -> 1.234)
```

#### Linha 25

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Formata a data da Ã£ltima sincronizAÃ§Ã£o
```

#### Linha 35 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'HÃ£ ${difference.inMinutes} min';
```

#### Linha 37 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'HÃ£ ${difference.inHours}hÃ£';
```

#### Linha 104 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'Ã£ltima SincronizAÃ§Ã£o',
```

#### Linha 121 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'Status: ConcluÃ£da com sucesso',
```

#### Linha 229 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'VÃ£nculo',
```

---

### 📄 `modules\dashboard\presentation\widgets\onboarding_steps_card.dart`

#### Linha 8

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de Primeiros Passos - Guia UsuÃ¡rios novos pelo sistema
```

#### Linha 9 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Substitui o card de "Atalhos RÃ£pidos" que tinha conflitos com o navegador
```

#### Linha 30

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se estÃ£ carregando ou tem erro, nÃ£o mostrar
```

#### Linha 38

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se todos os passos estiverem concluÃ£dos, nÃ£o mostrar o card
```

#### Linha 65

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // CabeÃ£alho
```

#### Linha 96 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          '$completed de $total concluÃ£dos',
```

#### Linha 235

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Ã­cone de status
```

#### Linha 261

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // TÃ£tulo
```

#### Linha 275

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // BotÃ£o de AÃ§Ã£o para prÃ£ximo passo
```

---

### 📄 `modules\dashboard\presentation\widgets\welcome_section.dart`

#### Linha 32

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ObtÃ£m dados dinÃ£micos do dashboard
```

#### Linha 69

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // PadrÃ£o decorativo de fundo
```

#### Linha 105

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // ConteÃ£do principal
```

#### Linha 114

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // SeÃ£Ã£o de boas-vindas
```

#### Linha 161

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      // Nome do UsuÃ¡rio com saudAÃ§Ã£o
```

#### Linha 197

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      // InformAÃ§Ã£o de EstratÃ©gias ativas
```

#### Linha 209 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                              '$activeStrategies EstratÃ©gias ativas',
```

#### Linha 249

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // InformaÃ£Ã£es de MÃ©tricas (dinÃ¢micas do backend)
```

#### Linha 256

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      // Formata valores monetÃ£rios
```

---

### 📄 `modules\dashboard\presentation\widgets\navigation\dashboard_mobile_bottom_nav.dart`

#### Linha 8

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// ExtraÃ£do de dashboard_screen.dart para modularizAÃ§Ã£o
```

#### Linha 111

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Auto-scroll para o item selecionado com navegAÃ§Ã£o inteligente
```

#### Linha 112

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Quando clicar no Ã£ltimo visÃ­vel ã direita/esquerda, avanÃ£a 3 itens
```

#### Linha 118

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãº` → `ú` (u com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    const visibleItems = 4; // NÃºmero aproximado de itens visÃ£veis
```

#### Linha 120

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Verificar se clicou em um dos Ã£ltimos visÃ£veis ã direita
```

#### Linha 125

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Calcular posiÃ£Ã£o do item
```

#### Linha 128

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se clicar em um item nÃ£o totalmente visÃ­vel ã direita, avanÃ£ar 3 itens
```

#### Linha 139

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Se clicar em um item nÃ£o totalmente visÃ­vel ã esquerda, retroceder 3 itens
```

#### Linha 150

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Caso contrÃ£rio, centralizar o item selecionado
```

---

### 📄 `modules\categories\presentation\screens\categories_admin_screen.dart`

#### Linha 26

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Cache para otimizAÃ§Ã£o
```

#### Linha 52

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Contar subcategorias: categorias que tÃ£m esta como parentId
```

#### Linha 110

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // OTIMIZAÃ£Ã£O: Getter com cache - sÃ£ recalcula se filtros mudaram
```

#### Linha 169 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'AdministrAÃ§Ã£o Completa',
```

#### Linha 1081 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: const Text('Confirmar ExclusÃ£o'),
```

#### Linha 1083 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Deseja realmente excluir "${categoria['nome']}"?\n\nEsta AÃ§Ã£o nÃ£o pode ser desfeita.',
```

#### Linha 1099 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    content: Text('${categoria['nome']} excluÃ£da'),
```

#### Linha 1144 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Deseja realmente excluir ${_selectedItems.length} categorias?\n\nEsta AÃ§Ã£o nÃ£o pode ser desfeita.',
```

#### Linha 1166 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  content: Text('$deleted categorias excluÃ£das'),
```

---

### 📄 `features\tags\presentation\screens\tag_add_screen.dart`

#### Linha 226 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'MÃ£ltiplas tags',
```

#### Linha 359 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'InformaÃ£Ã£es da Tag',
```

#### Linha 413 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  return 'Campo obrigatÃ£rio';
```

#### Linha 435 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                labelText: 'LocalizAÃ§Ã£o FÃ£sica (opcional)',
```

#### Linha 474 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                labelText: 'ObservaÃ£Ã£es (opcional)',
```

#### Linha 483 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                hintText: 'InformaÃ£Ã£es adicionais',
```

#### Linha 620 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    _buildStep('1', 'FaÃ£a o download do template Excel'),
```

#### Linha 628 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    _buildStep('3', 'FaÃ£a o upload do arquivo preenchido'),
```

#### Linha 1136

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        type: 0, // Tipo padrÃ£o
```

---

### 📄 `features\tags\presentation\widgets\tags_sync_footer.dart`

#### Linha 6

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Status de sincronizAÃ§Ã£o das tags
```

#### Linha 14

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Footer de sincronizAÃ§Ã£o das tags
```

#### Linha 51

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Ã­cone de status
```

#### Linha 85 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Última sincronizAÃ§Ã£o: ${_formatLastSync(lastSync!)}',
```

#### Linha 125

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o de sincronizar
```

#### Linha 205 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        return 'Erro na sincronizAÃ§Ã£o';
```

#### Linha 207 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        return 'Sem conexÃ£o';
```

#### Linha 216 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (difference.inMinutes < 60) return 'hÃ£ ${difference.inMinutes} min';
```

#### Linha 217 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (difference.inHours < 24) return 'hÃ£ ${difference.inHours}hÃ£';
```

---

### 📄 `features\strategies\presentation\screens\calendar\long_holidays_screen.dart`

#### Linha 195 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'DetecÃ£Ã£o de Pontes',
```

#### Linha 273 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            text: 'ConfigurAÃ§Ã£o',
```

#### Linha 427 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Pontes e FeriadÃ£es',
```

#### Linha 444 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  holidaysState.isStrategyActive ? 'DetecÃ£Ã£o ativa' : 'DetecÃ£Ã£o inativa',
```

#### Linha 521 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'DetecÃ£Ã£o AutomÃ£tica',
```

#### Linha 1167 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Identifica quando hÃ£ ponte ou feriadÃ£o',
```

#### Linha 1182 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Aumenta preÃ£os de produtos de lazer e viagem',
```

#### Linha 1212 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                '? Maximiza vendas em perÃ£odos de turismo',
```

#### Linha 1273 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    success ? 'ConfiguraÃ£Ã£es Salvas!' : 'Erro ao salvar',
```

---

### 📄 `features\dashboard\presentation\widgets\welcome_section.dart`

#### Linha 32

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ObtÃ£m dados dinÃ£micos do dashboard
```

#### Linha 69

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // PadrÃ£o decorativo de fundo
```

#### Linha 105

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // ConteÃ£do principal
```

#### Linha 114

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // SeÃ£Ã£o de boas-vindas
```

#### Linha 161

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      // Nome do UsuÃ¡rio com saudAÃ§Ã£o
```

#### Linha 197

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      // InformAÃ§Ã£o de EstratÃ©gias ativas
```

#### Linha 209 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                              '$activeStrategies EstratÃ©gias ativas',
```

#### Linha 249

**Padroes encontrados:**
- `Ã¢` → `â` (a com circunflexo)
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // InformaÃ£Ã£es de MÃ©tricas (dinÃ¢micas do backend)
```

#### Linha 256

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      // Formata valores monetÃ£rios
```

---

### 📄 `features\categories\presentation\screens\categories_admin_screen.dart`

#### Linha 27

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Cache para otimizAÃ§Ã£o
```

#### Linha 53

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      // Contar subcategorias: categorias que tÃ£m esta como parentId
```

#### Linha 111

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // OTIMIZAÃ£Ã£O: Getter com cache - sÃ£ recalcula se filtros mudaram
```

#### Linha 170 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'AdministrAÃ§Ã£o Completa',
```

#### Linha 1082 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        title: const Text('Confirmar ExclusÃ£o'),
```

#### Linha 1084 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Deseja realmente excluir "${categoria['nome']}"?\n\nEsta AÃ§Ã£o nÃ£o pode ser desfeita.',
```

#### Linha 1100 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    content: Text('${categoria['nome']} excluÃ£da'),
```

#### Linha 1145 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Deseja realmente excluir ${_selectedItems.length} categorias?\n\nEsta AÃ§Ã£o nÃ£o pode ser desfeita.',
```

#### Linha 1167 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  content: Text('$deleted categorias excluÃ£das'),
```

---

### 📄 `features\auth\presentation\screens\reset_password_screen.dart`

#### Linha 85

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Chama API real de redefiniÃ£Ã£o de senha
```

#### Linha 124 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        _errorMessage = ref.read(authProvider).errorMessage ?? 'Token invÃ¡lido ou expirado';
```

#### Linha 262 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'Digite o cÃ£digo recebido e sua nova senha.',
```

#### Linha 339 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Sua senha foi alterada com sucesso. vocÃª pode fazer login com sua nova senha.',
```

#### Linha 380 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'CÃ£digo de VerificAÃ§Ã£o',
```

#### Linha 431 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              return 'Por favor, insira o cÃ£digo';
```

#### Linha 434 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              return 'O cÃ£digo deve ter 6 dÃ­gitos';
```

#### Linha 518 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              return 'A senha deve ter no mÃ£nimo 6 caracteres';
```

#### Linha 598 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              return 'As senhas nÃ£o coincidem';
```

---

### 📄 `design_system\theme\theme_selector_dialog.dart`

#### Linha 8

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// DiÃ£logo para seleÃ£Ã£o de temas do sistema
```

#### Linha 12

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Mostra o diÃ£logo de seleÃ£Ã£o de temas
```

#### Linha 106

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // BotÃ£es de AÃ§Ã£o
```

#### Linha 158 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  '${availableThemes.length} temas disponÃ­veis',
```

#### Linha 459

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Usa cores do tema selecionado para o botÃ£o
```

#### Linha 470

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // BotÃ£o resetar para padrÃ£o
```

#### Linha 476 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          label: Text(isMobile ? 'Resetar' : 'Resetar para PadrÃ£o'),
```

#### Linha 482

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // BotÃ£o cancelar
```

#### Linha 491

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // BotÃ£o aplicar
```

---

### 📄 `modules\products\presentation\widgets\products_onboarding_card.dart`

#### Linha 6

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Estado de onboarding especÃ£fico para produtos
```

#### Linha 116 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  tooltip: 'NÃ£o mostrar novamente',
```

#### Linha 145 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          title: 'Comece seu catÃ£logo!',
```

#### Linha 151 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            _ActionConfig('Escanear CÃ£digo', Icons.qr_code_scanner_rounded, onEscanear, false),
```

#### Linha 157 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          title: 'Produtos sem preÃ£o definido',
```

#### Linha 158 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          subtitle: 'vocÃª tem $produtosSemPreco produtos sem preÃ£o. Configure preÃ£os para exibir nas etiquetas.',
```

#### Linha 161 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            _ActionConfig('Definir PREÃ‡Os Agora', Icons.attach_money_rounded, onDefinirPrecos, true),
```

#### Linha 169 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          subtitle: '$produtosSemTag produtos aguardando vinculAÃ§Ã£o. Vincule tags ESL para atualizAÃ§Ã£o automÃ£tica.',
```

---

### 📄 `modules\products\presentation\widgets\recent_products_card.dart`

#### Linha 77 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                            'Últimas atualizaÃ£Ã£es',
```

#### Linha 98 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                            isMobile ? 'Ver tudo' : 'Ver histÃ£rico completo',
```

#### Linha 133

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// ConstrÃ£i um item de produto conforme o prompt:
```

#### Linha 135

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  ///    R$ 12,90 • Bebidas • hÃ£ 5 min
```

#### Linha 205

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      // R$ 12,90 • Bebidas • hÃ£ 5 min
```

#### Linha 352 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'HÃ£ ${difference.inMinutes} min';
```

#### Linha 354 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'HÃ£ ${difference.inHours}hÃ£';
```

#### Linha 356 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'HÃ£ ${difference.inDays} dias';
```

---

### 📄 `modules\products\presentation\widgets\details\product_info_card.dart`

#### Linha 8

**Padroes encontrados:**
- `Ãµ` → `õ` (o com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de InformaÃ§Ãµes gerais do produto
```

#### Linha 47 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'CÃ£digo de Barras',
```

#### Linha 57 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'PREÃ‡O UnitÃ£rio',
```

#### Linha 68 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'PREÃ‡O por Kg',
```

#### Linha 92 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Última AtualizAÃ§Ã£o',
```

#### Linha 95 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                : (product.ultimaAtualizacao ?? 'NÃ£o disponÃ£vel'),
```

#### Linha 127 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'InformaÃ£Ã£es Gerais',
```

#### Linha 146 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ãµ` → `õ` (o com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            tooltip: 'Editar InformaÃ§Ãµes',
```

---

### 📄 `modules\products\presentation\widgets\qr\qr_scan_area.dart`

#### Linha 5

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Widget de Ã£rea de escaneamento QR/NFC
```

#### Linha 6

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Ã£rea visual onde o UsuÃ¡rio deve posicionar o cÃ£digo
```

#### Linha 8

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Para usar scanner real de cÃ£mera, use [onOpenCamera] callback
```

#### Linha 9

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// que abrirÃ£ o BarcodeScannerWidget em tela cheia
```

#### Linha 21

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Callback para abrir cÃ£mera real de escaneamento
```

#### Linha 69

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Ã­cone animado
```

#### Linha 128

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o para abrir cÃ£mera real
```

#### Linha 133 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              label: const Text('Abrir CÃ£mera'),
```

---

### 📄 `modules\dashboard\presentation\widgets\atalhos_rapidos_card.dart`

#### Linha 7

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// BLOCO 6: Atalhos de Teclado / GestÃ£os
```

#### Linha 8

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Acelera operaÃ£Ã£es para UsuÃ¡rios frequentes
```

#### Linha 31

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Em mobile, nÃ£o mostra atalhos de teclado
```

#### Linha 62 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'ATALHOS RÃ£PIDOS',
```

#### Linha 234 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildShortcutCategory('NavegAÃ§Ã£o', [
```

#### Linha 235 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                ('Ctrl+1-9', 'Ir para seÃ£Ã£o'),
```

#### Linha 237 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                ('Esc', 'Fechar diÃ£logo'),
```

#### Linha 240 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              _buildShortcutCategory('AÃ£Ã£es RÃ£pidas', [
```

---

### 📄 `modules\categories\presentation\screens\category_add_screen.dart`

#### Linha 79

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Carregar categorias sugeridas do backend apÃ£s o build
```

#### Linha 488 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'InformaÃ£Ã£es BÃ£sicas',
```

#### Linha 557 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              labelText: 'DescriÃ£Ã£o (opcional)',
```

#### Linha 684 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'PersonalizAÃ§Ã£o Visual',
```

#### Linha 701 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Escolha um Ã­cone e uma cor para identificar sua categoria',
```

#### Linha 716 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Ã­cone',
```

#### Linha 843 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        ? 'DescriÃ£Ã£o da categoria'
```

#### Linha 878 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'PrÃ£via',
```

---

### 📄 `modules\categories\presentation\screens\category_products_screen.dart`

#### Linha 77 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'nome': 'GuaranÃ£ Antarctica 2L',
```

#### Linha 85 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'nome': 'Ã£gua Mineral Crystal 500ml',
```

#### Linha 119 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'nome': 'FeijÃ£o Preto 1kg',
```

#### Linha 126 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    'PerecÃ£veis': [],
```

#### Linha 142

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // OTIMIZAÃ£Ã£O: Getter com cache - sÃ£ recalcula se categoria ou busca mudaram
```

#### Linha 240 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      {'label': 'PerecÃ£veis', 'valor': '189', 'icon': Icons.restaurant_rounded, 'cor': ThemeColors.of(context).greenMaterial, 'mudanca': '+7', 'tipo': 'aumento'},
```

#### Linha 1281 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        tooltip: 'Editar PREÃ‡O',
```

#### Linha 1459 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Desvincular ${_selectedProducts. length} produto(s) desta categoria?\n\nOs produtos nÃ£o serÃ¡o excluÃ£dos, apenas desvinculados.',
```

---

### 📄 `features\products\presentation\widgets\products_onboarding_card.dart`

#### Linha 6

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Estado de onboarding especÃ£fico para produtos
```

#### Linha 116 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  tooltip: 'NÃ£o mostrar novamente',
```

#### Linha 145 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          title: 'Comece seu catÃ£logo!',
```

#### Linha 151 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            _ActionConfig('Escanear CÃ£digo', Icons.qr_code_scanner_rounded, onEscanear, false),
```

#### Linha 157 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          title: 'Produtos sem preÃ£o definido',
```

#### Linha 158 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          subtitle: 'vocÃª tem $produtosSemPreco produtos sem preÃ£o. Configure preÃ£os para exibir nas etiquetas.',
```

#### Linha 161 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            _ActionConfig('Definir PREÃ‡Os Agora', Icons.attach_money_rounded, onDefinirPrecos, true),
```

#### Linha 169 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          subtitle: '$produtosSemTag produtos aguardando vinculAÃ§Ã£o. Vincule tags ESL para atualizAÃ§Ã£o automÃ£tica.',
```

---

### 📄 `features\products\presentation\widgets\recent_products_card.dart`

#### Linha 77 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                            'Últimas atualizaÃ£Ã£es',
```

#### Linha 98 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                            isMobile ? 'Ver tudo' : 'Ver histÃ£rico completo',
```

#### Linha 133

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// ConstrÃ£i um item de produto conforme o prompt:
```

#### Linha 135

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  ///    R$ 12,90 • Bebidas • hÃ£ 5 min
```

#### Linha 205

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      // R$ 12,90 • Bebidas • hÃ£ 5 min
```

#### Linha 352 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'HÃ£ ${difference.inMinutes} min';
```

#### Linha 354 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'HÃ£ ${difference.inHours}hÃ£';
```

#### Linha 356 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'HÃ£ ${difference.inDays} dias';
```

---

### 📄 `features\products\presentation\widgets\details\product_info_card.dart`

#### Linha 8

**Padroes encontrados:**
- `Ãµ` → `õ` (o com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de InformaÃ§Ãµes gerais do produto
```

#### Linha 47 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'CÃ£digo de Barras',
```

#### Linha 57 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'PREÃ‡O UnitÃ£rio',
```

#### Linha 68 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'PREÃ‡O por Kg',
```

#### Linha 92 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Última AtualizAÃ§Ã£o',
```

#### Linha 95 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                : (product.ultimaAtualizacao ?? 'NÃ£o disponÃ£vel'),
```

#### Linha 127 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'InformaÃ£Ã£es Gerais',
```

#### Linha 146 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ãµ` → `õ` (o com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            tooltip: 'Editar InformaÃ§Ãµes',
```

---

### 📄 `features\products\presentation\widgets\qr\qr_scan_area.dart`

#### Linha 5

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Widget de Ã£rea de escaneamento QR/NFC
```

#### Linha 6

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Ã£rea visual onde o UsuÃ¡rio deve posicionar o cÃ£digo
```

#### Linha 8

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Para usar scanner real de cÃ£mera, use [onOpenCamera] callback
```

#### Linha 9

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// que abrirÃ£ o BarcodeScannerWidget em tela cheia
```

#### Linha 21

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Callback para abrir cÃ£mera real de escaneamento
```

#### Linha 69

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Ã­cone animado
```

#### Linha 128

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o para abrir cÃ£mera real
```

#### Linha 133 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              label: Text('Abrir CÃ£mera'),
```

---

### 📄 `features\pricing\presentation\screens\pricing_percentage_screen.dart`

#### Linha 199 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Alterar preÃ£os em %',
```

#### Linha 281 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'ConfigurAÃ§Ã£o do Ajuste',
```

#### Linha 331 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ReduÃ£Ã£o',
```

#### Linha 370 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  ? 'Valor que serÃ¡ acrescido aos preÃ£os'
```

#### Linha 371 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  : 'Valor que serÃ¡ descontado dos preÃ£os',
```

#### Linha 529 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'SeleÃ£Ã£o de Produtos',
```

#### Linha 570 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              label: Text(_calculando ? 'Calculando...' : 'Calcular PrÃ£via'),
```

#### Linha 693 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'PrÃ£via do Ajuste',
```

---

### 📄 `features\categories\presentation\screens\category_add_screen.dart`

#### Linha 83

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Carregar categorias sugeridas do backend apÃ£s o build
```

#### Linha 492 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'InformaÃ£Ã£es BÃ£sicas',
```

#### Linha 561 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              labelText: 'DescriÃ£Ã£o (opcional)',
```

#### Linha 688 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'PersonalizAÃ§Ã£o Visual',
```

#### Linha 705 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Escolha um Ã­cone e uma cor para identificar sua categoria',
```

#### Linha 720 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Ã­cone',
```

#### Linha 848 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        ? 'DescriÃ£Ã£o da categoria'
```

#### Linha 883 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'PrÃ£via',
```

---

### 📄 `features\categories\presentation\screens\category_products_screen.dart`

#### Linha 78 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'nome': 'GuaranÃ£ Antarctica 2L',
```

#### Linha 86 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'nome': 'Ã£gua Mineral Crystal 500ml',
```

#### Linha 120 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'nome': 'FeijÃ£o Preto 1kg',
```

#### Linha 127 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    'PerecÃ£veis': [],
```

#### Linha 143

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // OTIMIZAÃ£Ã£O: Getter com cache - sÃ£ recalcula se categoria ou busca mudaram
```

#### Linha 241 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      {'label': 'PerecÃ£veis', 'valor': '189', 'icon': Icons.restaurant_rounded, 'cor': ThemeColors.of(context).success, 'mudanca': '+7', 'tipo': 'aumento'},
```

#### Linha 1282 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        tooltip: 'Editar PREÃ‡O',
```

#### Linha 1460 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Desvincular ${_selectedProducts. length} produto(s) desta categoria?\n\nOs produtos nÃ£o serÃ¡o excluÃ£dos, apenas desvinculados.',
```

---

### 📄 `design_system\theme\dynamic_gradients.dart`

#### Linha 6

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Gradientes dinÃ£micos que respondem ao tema atual
```

#### Linha 8

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Esta classe substitui AppGradients para suporte a temas dinÃ£micos.
```

#### Linha 9

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Todos os gradientes agora respondem Ã£s mudanÃ§as de tema em tempo real.
```

#### Linha 72

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente de detalhes de estratÃ£gia baseado no tema atual
```

#### Linha 82

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente azul de sincronizAÃ§Ã£o baseado no tema atual
```

#### Linha 102

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Gradientes de mÃ£dulos dinÃ£micos
```

#### Linha 105

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente do mÃ£dulo de produtos baseado no tema atual
```

#### Linha 115

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Gradiente do mÃ£dulo de precificAÃ§Ã£o baseado no tema atual
```

---

### 📄 `modules\dashboard\presentation\widgets\estrategias_ativas_card.dart`

#### Linha 9

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card compacto de EstratÃ©gias ativas
```

#### Linha 10

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Mostra visÃ£o consolidada das EstratÃ©gias em funcionamento
```

#### Linha 31

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ObtÃ£m dados de EstratÃ©gias
```

#### Linha 44

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Cores para cada estratÃ£gia
```

#### Linha 110 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          '$totalAtivas EstratÃ©gias ativas',
```

#### Linha 138 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        '+${_formatCurrency(impactoMensal)}/mÃ£s',
```

#### Linha 167

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Mini cards de EstratÃ©gias
```

---

### 📄 `modules\dashboard\presentation\widgets\recent_activity_card.dart`

#### Linha 73 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (lower.contains('preÃ£o') || lower.contains('price')) {
```

#### Linha 76 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (lower.contains('UsuÃ¡rio') || lower.contains('user') || lower.contains('login')) {
```

#### Linha 99 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (lower.contains('preÃ£o') || lower.contains('price')) {
```

#### Linha 110 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (diff.inMinutes < 60) return 'HÃ£ ${diff.inMinutes} min';
```

#### Linha 111 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (diff.inHours < 24) return 'HÃ£ ${diff.inHours}hÃ£';
```

#### Linha 113 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (diff.inDays < 7) return 'HÃ£ ${diff.inDays} dias';
```

#### Linha 203 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'NÃ£o foi possÃ£vel carregar atividades',
```

---

### 📄 `modules\dashboard\presentation\widgets\scanner_central_card.dart`

#### Linha 7

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãµ` → `õ` (o com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Acesso rÃ£pido Ã£s FunÃ§Ãµes de scanner que sÃ£o o core do sistema
```

#### Linha 43

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // TÃ£tulo
```

#### Linha 66

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o principal de scanner
```

#### Linha 111 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'O que vocÃ£ quer escanear?',
```

#### Linha 119

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // OpÃ£Ã£es de scanner
```

#### Linha 136 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  label: 'CÃ£digo de Barras',
```

#### Linha 172 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ãª` → `ê` (e com circunflexo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'Dica: vocÃª pode escanear diretamente e o sistema detecta automaticamente o tipo',
```

---

### 📄 `modules\dashboard\presentation\widgets\navigation\dashboard_navigation_rail.dart`

#### Linha 8

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// ExtraÃ£do de dashboard_screen.dart para modularizAÃ§Ã£o
```

#### Linha 35 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'title': 'EstratÃ£gias',
```

#### Linha 40 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'title': 'SincronizAÃ§Ã£o',
```

#### Linha 45 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'title': 'PrecificAÃ§Ã£o',
```

#### Linha 55 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'title': 'ImportAÃ§Ã£o',
```

#### Linha 60 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'title': 'RelatÃ£rios',
```

#### Linha 65 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'title': 'ConfiguraÃ£Ã£es',
```

---

### 📄 `features\settings\presentation\screens\api_test_screen.dart`

#### Linha 345

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 1. TESTES DE AUTENTICAÇÃO
```

#### Linha 543

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 2. TESTES DE PERMISSÃO POR PERFIL
```

#### Linha 1034

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 4. TESTES DE ERRO E VALIDAÇÃO
```

#### Linha 1050

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ---- ERROS DE VALIDAÇÃO ----
```

#### Linha 1136

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ---- ERROS DE RECURSO NÃO ENCONTRADO ----
```

#### Linha 1213

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ---- ERROS DE MÉTODO NÃO PERMITIDO ----
```

#### Linha 1226

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ---- TESTES DE LIMITE/PAGINAÇÃO ----
```

---

### 📄 `modules\products\presentation\widgets\qr\binding_confirmation_card.dart`

#### Linha 6

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de confirmAÃ§Ã£o de vinculAÃ§Ã£o tag-produto
```

#### Linha 47

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // ConexÃ£o visual
```

#### Linha 53

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£es
```

#### Linha 90 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Confirmar VinculAÃ§Ã£o',
```

#### Linha 199 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildDetailRow(context, 'CÃ£digo', produto!.codigo),
```

#### Linha 201 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildDetailRow(context, 'PREÃ‡O', 'R\$ ${produto!.preco.toStringAsFixed(2)}'),
```

---

### 📄 `modules\dashboard\presentation\widgets\navigation\dashboard_app_bar.dart`

#### Linha 13

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// ExtraÃ£do de dashboard_screen.dart para modularizAÃ§Ã£o
```

#### Linha 85

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // Seletor de Loja - usa Expanded para ocupar espaÃ£o disponÃ£vel
```

#### Linha 180 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Sistema de GestÃ£o',
```

#### Linha 282

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãµ` → `õ` (o com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// BotÃ£o de NotificaÃ§Ãµes da AppBar
```

#### Linha 330

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Menu de UsuÃ¡rio da AppBar
```

#### Linha 502

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// BotÃ£o de seleÃ£Ã£o de tema na AppBar
```

---

### 📄 `features\strategies\presentation\screens\visual\smart_route_screen.dart`

#### Linha 99 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        tabs: const [Tab(icon: Icon(Icons.settings_rounded, size: 18), text: 'ConfigurAÃ§Ã£o'), Tab(icon: Icon(Icons.route_rounded, size: 18), text: 'Rotas Ativas')],
```

#### Linha 154 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: ThemeColors.of(context).blueMain.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.lightbulb_rounded, color: ThemeColors.of(context).blueMain, size: 22)), const SizedBox(width: 14), const Expanded(child: Text('ParÃ£metros de LED', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.5)))]),
```

#### Linha 196 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        _buildSwitchOption('ConfirmAÃ§Ã£o por Scan', 'Exigir scan para confirmar coleta', Icons.qr_code_scanner_rounded, state.confirmacaoScan, (value) => ref.read(smartRouteProvider.notifier).setConfirmacaoScan(value)),
```

#### Linha 198 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        _buildSwitchOption('Som de ConfirmAÃ§Ã£o', 'Emitir beep ao confirmar item', Icons.volume_up_rounded, state.somConfirmacao, (value) => ref.read(smartRouteProvider.notifier).setSomConfirmacao(value)),
```

#### Linha 251 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    showDialog(context: context, builder: (context) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), icon: Icon(Icons.route_rounded, color: ThemeColors.of(context).blueCyan, size: 56), title: const Text('Smart Route'), content: const SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Guia LED inteligente para picking:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), SizedBox(height: 16), Text(' LED guia o operador at o produto', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Rota otimizada para menor tempo', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' ConfirmAÃ§Ã£o por scan ou toque', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Reduz erros de picking em 95%', style: TextStyle(fontSize: 13, height: 1.5)), SizedBox(height: 8), Text(' Aumenta produtividade em 40%', style: TextStyle(fontSize: 13, height: 1.5))])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendi'))]));
```

#### Linha 257 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface), const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('ConfiguraÃ£Ã£es Salvas!', style: TextStyle(fontWeight: FontWeight.bold)), Text('Smart Route configurado', style: TextStyle(fontSize: 12))]))]), backgroundColor: ThemeColors.of(context).success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
```

---

### 📄 `features\products\presentation\widgets\qr\binding_confirmation_card.dart`

#### Linha 6

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de confirmAÃ§Ã£o de vinculAÃ§Ã£o tag-produto
```

#### Linha 47

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // ConexÃ£o visual
```

#### Linha 53

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£es
```

#### Linha 90 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'Confirmar VinculAÃ§Ã£o',
```

#### Linha 204 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildDetailRow(context, 'CÃ£digo', produto!.codigo),
```

#### Linha 206 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          _buildDetailRow(context, 'PREÃ‡O', 'R\$ ${produto!.preco.toStringAsFixed(2)}'),
```

---

### 📄 `features\pricing\presentation\screens\fixed_value_screen.dart`

#### Linha 28 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    'LaticÃ£nios',
```

#### Linha 262 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'ReduÃ£Ã£o',
```

#### Linha 435 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Categorias especÃ­ficas',
```

#### Linha 547 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'PrÃ£via do Ajuste',
```

#### Linha 652 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Digite um valor vÃ¡lido',
```

#### Linha 696 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Deseja aplicar ${isAumento ? 'aumento' : 'reduÃ£Ã£o'} de R\$ ${_config.valor.toStringAsFixed(2)} '
```

---

### 📄 `modules\products\presentation\widgets\product_tags_widget.dart`

#### Linha 161

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o de sincronizar todos
```

#### Linha 171 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  label: const Text('Sincronizar PREÃ‡O em Todas as Tags'),
```

#### Linha 186 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        content: Text('Deseja remover a vinculAÃ§Ã£o com a tag ${tag.tagMacAddress}?'),
```

#### Linha 344 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        return 'Erro na sincronizAÃ§Ã£o';
```

#### Linha 346 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        return 'Aguardando sincronizAÃ§Ã£o';
```

---

### 📄 `modules\products\presentation\widgets\details\price_history_card.dart`

#### Linha 6

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Modelo para item do histÃ£rico de preÃ£os
```

#### Linha 23

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de histÃ£rico de preÃ£os do produto
```

#### Linha 128 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'HistÃ£rico de PREÃ‡Os',
```

#### Linha 158 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Nenhum histÃ£rico disponÃ£vel',
```

#### Linha 321 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              : 'Ver HistÃ£rico Completo (${historico.length})',
```

---

### 📄 `modules\products\presentation\widgets\details\product_tag_card.dart`

#### Linha 7

**Padroes encontrados:**
- `Ãµ` → `õ` (o com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card exibindo InformaÃ§Ãµes de tag vinculada ao produto
```

#### Linha 120 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    : 'Este produto nÃ£o possui tag associada',
```

#### Linha 155 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Última SincronizAÃ§Ã£o',
```

#### Linha 158 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                : (product.ultimaAtualizacao ?? 'NÃ£o disponÃ£vel'),
```

#### Linha 273 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    Text('Abrindo associAÃ§Ã£o de tag...'),
```

---

### 📄 `modules\dashboard\presentation\widgets\compact_metrics_grid.dart`

#### Linha 12

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ãº` → `ú` (u com acento agudo)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Formata NÃºmero para exibiÃ§Ã£o (ex: 1234 -> 1.234)
```

#### Linha 23

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// ConstrÃ£i a lista de estatÃ£sticas a partir dos dados reais
```

#### Linha 51 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        'label': 'Tags DisponÃ£veis',
```

#### Linha 70

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Construir estatÃ£sticas a partir dos dados reais
```

#### Linha 109

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Grid de MÃ©tricas
```

---

### 📄 `modules\dashboard\presentation\widgets\resumo_do_dia_card.dart`

#### Linha 8

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de Resumo do Dia com MÃ©tricas de negÃ£cio
```

#### Linha 9

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Substitui CompactMetricsGrid com MÃ©tricas mais relevantes
```

#### Linha 34

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ObtÃ£m dados do dashboard
```

#### Linha 39

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // MÃ£tricas do dia
```

#### Linha 123

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // Grid de MÃ©tricas 2x2
```

---

### 📄 `modules\categories\presentation\screens\categories_list_screen.dart`

#### Linha 47

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // NOTA: MÃ©todos removidos: _getIconData, _buildSearchBar, _buildSortButton (cÃ£digo morto)
```

#### Linha 642 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'NÃ£o ã possÃ£vel excluir',
```

#### Linha 665 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Confirmar ExclusÃ£o',
```

#### Linha 670 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Esta AÃ§Ã£o nÃ£o pode ser desfeita.',
```

#### Linha 684 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    content: Text('Categoria "${categoria.nome}" excluÃ£da'),
```

---

### 📄 `features\tags\presentation\widgets\recent_tags_card.dart`

#### Linha 14

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Tag recente para exibiÃ§Ã£o
```

#### Linha 160

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              // Ã­cone NFC
```

#### Linha 320 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (difference.inMinutes < 60) return '${difference.inMinutes}min atrÃ£s';
```

#### Linha 321 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (difference.inHours < 24) return '${difference.inHours}hÃ£ atrÃ£s';
```

#### Linha 322 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    if (difference.inDays < 7) return '${difference.inDays}d atrÃ£s';
```

---

### 📄 `features\tags\presentation\widgets\tags_health_card.dart`

#### Linha 6

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// MÃ£tricas de saÃ£de das tags
```

#### Linha 25

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de saÃ£de das tags (bateria e sinal)
```

#### Linha 69 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'SaÃ£de das Tags',
```

#### Linha 84 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            label: 'Bateria MÃ£dia',
```

#### Linha 89 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                ? '${metrics.criticalBatteryCount} crÃ£ticas (<5%)'
```

---

### 📄 `features\products\presentation\widgets\product_tags_widget.dart`

#### Linha 161

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // BotÃ£o de sincronizar todos
```

#### Linha 171 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  label: const Text('Sincronizar PREÃ‡O em Todas as Tags'),
```

#### Linha 186 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        content: Text('Deseja remover a vinculAÃ§Ã£o com a tag ${tag.tagMacAddress}?'),
```

#### Linha 344 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        return 'Erro na sincronizAÃ§Ã£o';
```

#### Linha 346 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        return 'Aguardando sincronizAÃ§Ã£o';
```

---

### 📄 `features\products\presentation\widgets\details\product_tag_card.dart`

#### Linha 7

**Padroes encontrados:**
- `Ãµ` → `õ` (o com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card exibindo InformaÃ§Ãµes de tag vinculada ao produto
```

#### Linha 120 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    : 'Este produto nÃ£o possui tag associada',
```

#### Linha 155 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'Última SincronizAÃ§Ã£o',
```

#### Linha 158 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                : (product.ultimaAtualizacao ?? 'NÃ£o disponÃ£vel'),
```

#### Linha 273 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    Text('Abrindo associAÃ§Ã£o de tag...'),
```

---

### 📄 `modules\products\presentation\widgets\details\quick_actions_section.dart`

#### Linha 6

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// SeÃ£Ã£o de aÃ£Ã£es RÃ¡pidas para a tela de detalhes do produto
```

#### Linha 71 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'AÃ£Ã£es RÃ£pidas',
```

#### Linha 92 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            label: 'Alterar\nPREÃ‡O',
```

#### Linha 130

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// BotÃ£o de AÃ§Ã£o rÃ£pida individual
```

---

### 📄 `modules\products\presentation\widgets\qr\product_binding_card.dart`

#### Linha 55

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // InformaÃ£Ã£es
```

#### Linha 59

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // AÃ£Ã£es
```

#### Linha 117

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // CÃ£digo
```

#### Linha 136

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // PREÃ‡O ou Tag
```

---

### 📄 `features\tags\presentation\widgets\tags_quick_actions_card.dart`

#### Linha 6

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// AÃ£Ã£o rÃ£pida para tags
```

#### Linha 25

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de aÃ£Ã£es RÃ¡pidas para tags
```

#### Linha 65 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'AÃ£Ã£es RÃ£pidas',
```

#### Linha 76

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Grid de aÃ£Ã£es
```

---

### 📄 `features\strategies\presentation\screens\performance\auto_audit_screen.dart`

#### Linha 1064 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
              'Analisando ${state.totalVerificacoesAtivas} verificaÃ£Ã£es...',
```

#### Linha 1107 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    hasError ? 'Erro na Auditoria' : 'Auditoria ConcluÃ£da!',
```

#### Linha 1132 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          label: 'Ver RelatÃ£rio',
```

#### Linha 1135

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            // Navegar para relatÃ£rio de auditoria
```

---

### 📄 `features\products\presentation\widgets\details\quick_actions_section.dart`

#### Linha 6

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// SeÃ£Ã£o de aÃ£Ã£es RÃ¡pidas para a tela de detalhes do produto
```

#### Linha 71 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          'AÃ£Ã£es RÃ£pidas',
```

#### Linha 92 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            label: 'Alterar\nPREÃ‡O',
```

#### Linha 130

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// BotÃ£o de AÃ§Ã£o rÃ£pida individual
```

---

### 📄 `features\products\presentation\widgets\qr\product_binding_card.dart`

#### Linha 55

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // InformaÃ£Ã£es
```

#### Linha 59

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // AÃ£Ã£es
```

#### Linha 117

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // CÃ£digo
```

#### Linha 136

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // PREÃ‡O ou Tag
```

---

### 📄 `features\dashboard\presentation\screens\dashboard_screen.dart`

#### Linha 1258

**Padroes encontrados:**
- `Ã¡` → `á` (a com acento agudo)
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ObtÃ£m dados do UsuÃ¡rio logado
```

#### Linha 1260 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    final userName = user?.username ?? 'UsuÃ£rio';
```

#### Linha 1298

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã³` → `ó` (o com acento agudo)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // PrÃ³xima AÃ§Ã£o recomendada
```

#### Linha 1312

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // CÃ£digo original preservado para referÃ£ncia
```

---

### 📄 `design_system\theme\brand_colors.dart`

#### Linha 8

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Cores primÃ£rias da marca (extraÃ£das da logo)
```

#### Linha 54

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  static const Color mediumBackground = Color(0xFF2D4A42); // Verde MÃ©dio
```

#### Linha 69

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Cores de superfÃ£cie
```

#### Linha 91

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // MÃ£todo auxiliar para obter cor com opacidade
```

---

### 📄 `design_system\theme\theme_colors.dart`

#### Linha 176

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 203

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 743

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 783

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\BOA theme_colors_t10_indigo_night.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\BOA_theme_colors_t12_sky_blue.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\BOM_theme_colors_t14_forest_green.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors.dart`

#### Linha 164

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 191

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 723

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 763

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_t01_emerald_power.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_t02_royal_blue.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_t03_crimson_fire.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_t04_purple_reign.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_t05_sunset_orange.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_t06_ocean_teal.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_t07_lime_fresh.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_t08_pink_passion.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_t09_amber_gold.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_t11_rose_red.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_t12_sky_blue.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_t13_violet_dream.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_t15_fuchsia_pop.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_v01_dark_mode.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_v02_light_pastel.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_v03_christmas.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_v04_halloween.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_v05_easter.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_v06_valentine.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_v07_summer_beach.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_v08_autumn_forest.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_v09_corporate_blue.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\theme\temas\theme_colors_v10_energetic_sport.dart`

#### Linha 165

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // --- INFORMAÇÃO ---
```

#### Linha 192

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 6. DASHBOARD E NAVEGAÇÃO - CORES DINÂMICAS E LEVES
```

#### Linha 724

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRÓXIMO PASSO - INDICAÇÃO CLARA
```

#### Linha 764

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // 16. PRECIFICAÇÃO E SINCRONIZAÇÃO - CORES FUNCIONAIS
```

---

### 📄 `design_system\components\cards\card_widgets.dart`

#### Linha 5

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card com gradiente padrÃ£o reutilizÃ£vel
```

#### Linha 67

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de estatÃ£stica reutilizÃ£vel
```

#### Linha 150

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de menu reutilizÃ£vel
```

#### Linha 244

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de informAÃ§Ã£o reutilizÃ£vel
```

---

### 📄 `main.dart`

#### Linha 15

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // Inicializar LocalizaÃ§Ã£o para datas em portuguÃ£s
```

#### Linha 21

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // ConfiguraÃ£Ã£es de sistema - permite todas as orientaÃ£Ã£es
```

#### Linha 29

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // ConfiguraÃ£Ã£es de UI do sistema
```

---

### 📄 `app\app_providers.dart`

#### Linha 8

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
// PROVIDERS GLOBAIS DA APLICAÇÃO
```

#### Linha 23

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
// ESTADO GLOBAL DA APLICAÇÃO
```

#### Linha 36

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
// PROVIDERS DE INICIALIZAÇÃO
```

---

### 📄 `modules\products\presentation\widgets\products_sync_footer.dart`

#### Linha 112 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'Última sincronizAÃ§Ã£o: hÃ£ ${difference.inMinutes} min';
```

#### Linha 114 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'Última sincronizAÃ§Ã£o: hÃ£ ${difference.inHours}hÃ£';
```

#### Linha 116 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'Última sincronizAÃ§Ã£o: ${lastSync!.day}/${lastSync!.month} às ${lastSync!.hour}:${lastSync!.minute.toString().padLeft(2, '0')}';
```

---

### 📄 `modules\products\presentation\widgets\list\products_skeleton.dart`

#### Linha 26

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Ã­cone skeleton
```

#### Linha 40

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // TÃ£tulo skeleton
```

#### Linha 72

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // PREÃ‡O skeleton
```

---

### 📄 `modules\products\presentation\widgets\list\product_card.dart`

#### Linha 67

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // Checkbox para modo de seleÃ£Ã£o
```

#### Linha 260

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Alerta visual para produto sem preÃ£o
```

#### Linha 281 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Sem preÃ£o',
```

---

### 📄 `modules\products\presentation\widgets\qr\products_empty_state.dart`

#### Linha 92 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      subtitle: 'Todos os produtos jÃ£ possuem tags vinculadas.',
```

#### Linha 101 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      title: 'Nenhuma vinculAÃ§Ã£o',
```

#### Linha 102 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      subtitle: 'Ainda nÃ£o hÃ£ produtos vinculados a tags. Escaneie para comeÃ§ar.',
```

---

### 📄 `modules\dashboard\presentation\widgets\quick_actions_card.dart`

#### Linha 59 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                    'AÃ£Ã£es RÃ£pidas',
```

#### Linha 111 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  label: 'RelatÃ£rios',
```

#### Linha 112 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  subtitle: 'Visualizar anÃ£lises e MÃ©tricas',
```

---

### 📄 `modules\dashboard\presentation\widgets\sugestoes_ia_card.dart`

#### Linha 18

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // ObtÃ£m contagem de EstratÃ©gias ativas do provider
```

#### Linha 91 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'SugestÃ£es Inteligentes',
```

#### Linha 189 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      '24 promoÃ£Ã£es',
```

---

### 📄 `modules\dashboard\presentation\widgets\navigation\dashboard_mobile_drawer.dart`

#### Linha 6

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Drawer mobile para navegAÃ§Ã£o do Dashboard
```

#### Linha 8

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// ExtraÃ£do de dashboard_screen.dart para modularizAÃ§Ã£o
```

#### Linha 89 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Sistema de GestÃ£o',
```

---

### 📄 `features\tags\presentation\widgets\tags_alerts_card.dart`

#### Linha 6

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Prioridade do alerta - compatÃ­vel com tags_dashboard_screen.dart
```

#### Linha 9

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Modelo de alerta de tags - compatÃ­vel com tags_dashboard_screen.dart
```

#### Linha 32

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Card de alertas acionÃ£veis para o mÃ£dulo Tags
```

---

### 📄 `features\products\presentation\widgets\products_sync_footer.dart`

#### Linha 112 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'Última sincronizAÃ§Ã£o: hÃ£ ${difference.inMinutes} min';
```

#### Linha 114 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'Última sincronizAÃ§Ã£o: hÃ£ ${difference.inHours}hÃ£';
```

#### Linha 116 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      return 'Última sincronizAÃ§Ã£o: ${lastSync!.day}/${lastSync!.month} às ${lastSync!.hour}:${lastSync!.minute.toString().padLeft(2, '0')}';
```

---

### 📄 `features\products\presentation\widgets\list\products_skeleton.dart`

#### Linha 26

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Ã­cone skeleton
```

#### Linha 40

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                // TÃ£tulo skeleton
```

#### Linha 72

**Padroes encontrados:**
- `Ã‡` → `Ç` (C com cedilha maiusculo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // PREÃ‡O skeleton
```

---

### 📄 `features\products\presentation\widgets\list\product_card.dart`

#### Linha 67

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  // Checkbox para modo de seleÃ£Ã£o
```

#### Linha 260

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
          // Alerta visual para produto sem preÃ£o
```

#### Linha 281 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  'Sem preÃ£o',
```

---

### 📄 `features\products\presentation\widgets\qr\products_empty_state.dart`

#### Linha 92 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      subtitle: 'Todos os produtos jÃ£ possuem tags vinculadas.',
```

#### Linha 101 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      title: 'Nenhuma vinculAÃ§Ã£o',
```

#### Linha 102 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      subtitle: 'Ainda nÃ£o hÃ£ produtos vinculados a tags. Escaneie para comeÃ§ar.',
```

---

### 📄 `features\pricing\data\repositories\pricing_repository.dart`

#### Linha 26

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // SIMULAÇÃO E AJUSTES
```

#### Linha 249

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // OTIMIZAÇÃO
```

#### Linha 296

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PRECIFICAÇÃO DINÂMICA
```

---

### 📄 `features\import_export\data\repositories\import_export_repository.dart`

#### Linha 43

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // PREVIEW E VALIDAÇÃO
```

#### Linha 90

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // IMPORTAÇÃO
```

#### Linha 142

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // EXPORTAÇÃO
```

---

### 📄 `modules\products\presentation\widgets\products_alerts_card.dart`

#### Linha 119 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'AÃ£Ã£es Pendentes',
```

#### Linha 127 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          '${widget.alerts.length} ${widget.alerts.length == 1 ? 'item requer' : 'itens requerem'} atenÃ£Ã£o',
```

---

### 📄 `modules\products\presentation\widgets\products_quick_actions_card.dart`

#### Linha 62 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'AÃ£Ã£es RÃ£pidas',
```

#### Linha 73 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'O que vocÃ£ mais faz',
```

---

### 📄 `modules\products\presentation\widgets\list\products_header.dart`

#### Linha 5

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Header da lista de produtos com gradiente e estatÃ£sticas
```

#### Linha 105 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã§` → `ç` (c com cedilha)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
            'GestÃ£o de catÃ£logo e precificAÃ§Ã£o',
```

---

### 📄 `modules\products\presentation\widgets\list\product_filters.dart`

#### Linha 34 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'PerecÃ£veis',
```

#### Linha 115 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        hintText: 'Buscar por nome ou cÃ£digo...',
```

---

### 📄 `modules\dashboard\presentation\widgets\compact_alerts_card.dart`

#### Linha 15

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  /// Se nÃ£o fornecida, usa dados do DashboardProvider
```

#### Linha 108 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'Requer atenÃ£Ã£o imediata',
```

---

### 📄 `modules\dashboard\presentation\widgets\estrategias_lucro_card.dart`

#### Linha 73 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        'Lucro com EstratÃ£gias',
```

#### Linha 93 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã©` → `é` (e com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        '${estrategiasData['ativas']} EstratÃ©gias ativas',
```

---

### 📄 `features\tags\presentation\screens\tags_list_screen.dart`

#### Linha 779

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                        // Bateria, Sinal, Online e Ã£ltima sincronizao
```

#### Linha 825 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                                '${tag.temperature}Ã£C',
```

---

### 📄 `features\settings\presentation\screens\full_api_test_screen.dart`

#### Linha 630

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // FASE 2: AUTENTICAÇÃO
```

#### Linha 635 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    _addHeader('🔐 FASE 2: AUTENTICAÇÃO - Testes de login e segurança');
```

---

### 📄 `features\products\presentation\widgets\products_alerts_card.dart`

#### Linha 119 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          'AÃ£Ã£es Pendentes',
```

#### Linha 127 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                          '${widget.alerts.length} ${widget.alerts.length == 1 ? 'item requer' : 'itens requerem'} atenÃ£Ã£o',
```

---

### 📄 `features\products\presentation\widgets\products_quick_actions_card.dart`

#### Linha 62 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'AÃ£Ã£es RÃ£pidas',
```

#### Linha 73 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                      'O que vocÃ£ mais faz',
```

---

### 📄 `features\products\presentation\widgets\list\product_filters.dart`

#### Linha 34 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
      'PerecÃ£veis',
```

#### Linha 115 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        hintText: 'Buscar por nome ou cÃ£digo...',
```

---

### 📄 `features\dashboard\presentation\widgets\alertas_acionaveis_card.dart`

#### Linha 123

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
    // Produtos sem preço - ATENÇÃO
```

#### Linha 205 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        return 'ATENÇÃO';
```

---

### 📄 `design_system\theme\module_gradients.dart`

#### Linha 4

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Gradientes especÃ£ficos dos mÃ£dulos
```

#### Linha 7

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// visualmente cada mÃ£dulo do sistema. Substitui valores hardcoded
```

---

### 📄 `design_system\components\common\common_widgets.dart`

#### Linha 102

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Badge customizÃ£vel
```

#### Linha 254

**Padroes encontrados:**
- `Ã­` → `í` (i com acento agudo)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Chip com Ã­cone
```

---

### 📄 `modules\products\presentation\widgets\products_catalog_summary.dart`

#### Linha 59 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'VisÃ£o Geral',
```

---

### 📄 `modules\products\data\datasources\products_datasource.dart`

#### Linha 13

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// ATENÇÃO: Esta classe será removida em versões futuras.
```

---

### 📄 `modules\categories\presentation\providers\categories_provider.dart`

#### Linha 102

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // ERRO: API retornou falha - NÃO usar mock silenciosamente
```

---

### 📄 `features\tags\presentation\widgets\tags_status_summary.dart`

#### Linha 6

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// Item de estatÃ£stica para o resumo
```

---

### 📄 `features\sync\data\repositories\sync_repository.dart`

#### Linha 249

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // NOVOS MÉTODOS - SINCRONIZAÇÃO MINEW CLOUD
```

---

### 📄 `features\products\presentation\screens\product_edit_screen.dart`

#### Linha 393 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                  _buildTagInfo('Ã£ltima Sincronizao',
```

---

### 📄 `features\products\presentation\widgets\products_catalog_summary.dart`

#### Linha 59 🖥️ (Texto de UI)

**Padroes encontrados:**
- `Ã£` → `ã` (a com til)
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
                'VisÃ£o Geral',
```

---

### 📄 `features\products\data\datasources\products_datasource.dart`

#### Linha 13

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// ATENÇÃO: Esta classe será removida em versões futuras.
```

---

### 📄 `features\categories\presentation\providers\categories_provider.dart`

#### Linha 102

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
        // ERRO: API retornou falha - NÃO usar mock silenciosamente
```

---

### 📄 `core\constants\api_constants.dart`

#### Linha 32

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // === AUTENTICAÇÃO (AuthController) ===
```

---

### 📄 `core\utils\responsive_cache.dart`

#### Linha 4

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
/// OTIMIZAÇÃO: Cache de valores responsivos para evitar múltiplas chamadas MediaQuery
```

---

### 📄 `core\utils\responsive_helper.dart`

#### Linha 15

**Padroes encontrados:**
- `Ã` → `Ñ` (N com til maiusculo)

**Codigo da linha:**
```dart
  // OTIMIZAÇÃO: Cache de valores do MediaQuery
```

---

## 🛠️ COMO CORRIGIR

### Opcao 1: Correcao Manual

Para cada arquivo listado:
1. Abra o arquivo no VS Code
2. Use `Ctrl+H` para substituir
3. Substitua cada padrao corrompido pelo caractere correto
4. Salve o arquivo com encoding UTF-8

### Tabela de Substituicao Rapida

| Encontrar | Substituir por |
|-----------|----------------|
| `Ã¡` | `á` |
| `Ã£` | `ã` |
| `Ã¢` | `â` |
| `Ã©` | `é` |
| `Ãª` | `ê` |
| `Ã­` | `í` |
| `Ã³` | `ó` |
| `Ãµ` | `õ` |
| `Ãº` | `ú` |
| `Ã§` | `ç` |
| `Ã` | `Á` |
| `Ã‡` | `Ç` |

### Opcao 2: Script de Correcao Automatica

Execute `fix_encoding_issues.py` para corrigir automaticamente todos os arquivos.

---

*Relatorio gerado automaticamente por `find_encoding_issues.py`*
