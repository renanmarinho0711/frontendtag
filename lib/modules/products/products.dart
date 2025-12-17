/// TagBean Products Feature
library products;

// Data Layer
export 'data/datasources/products_datasource.dart';
export 'data/models/product_model.dart';
export 'data/models/product_models.dart';
export 'data/models/product_tag_model.dart';
export 'data/repositories/products_repository.dart';
export 'data/repositories/global_products_repository.dart';
export 'data/services/product_tag_service.dart';

// Presentation - Providers
export 'presentation/providers/products_provider.dart';
// Escondendo tipos duplicados que já existem em product_models.dart
export 'presentation/providers/products_state_provider.dart' 
    hide StockItemModel, PriceHistoryItem, ProductStatisticsModel, ProductCategoryStatsModel, PriceHistoryModel;
export 'presentation/providers/product_tag_provider.dart';

// Presentation - Screens
export 'presentation/screens/products_dashboard_screen.dart';
export 'presentation/screens/products_import_screen.dart';
export 'presentation/screens/products_list_screen.dart';
export 'presentation/screens/products_stock_screen.dart';
export 'presentation/screens/product_add_screen.dart';
export 'presentation/screens/product_details_screen.dart';
export 'presentation/screens/product_edit_screen.dart';
export 'presentation/screens/product_qr_screen.dart';

// Presentation - Widgets
export 'presentation/widgets/qr/qr_widgets.dart';
export 'presentation/widgets/list/list_widgets.dart';
export 'presentation/widgets/details/details_widgets.dart';
export 'presentation/widgets/products_alerts_card.dart';
export 'presentation/widgets/products_catalog_summary.dart';
export 'presentation/widgets/products_onboarding_card.dart';
export 'presentation/widgets/products_quick_actions_card.dart';
export 'presentation/widgets/products_sync_footer.dart';
export 'presentation/widgets/product_tags_widget.dart';
export 'presentation/widgets/recent_products_card.dart';



