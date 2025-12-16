// TagBean Tags Feature
/// 
/// Feature de gerenciamento de etiquetas eletrônicas (ESL).
/// 
/// Uso:
/// ```dart
/// import 'package:tagbean/features/tags/tags.dart';
/// ```

library tags;

// Data Layer
export 'data/models/tag_model.dart';
export 'data/repositories/tags_repository.dart';

// Presentation - Providers
export 'presentation/providers/tags_provider.dart';

// Presentation - Screens
export 'presentation/screens/tags_dashboard_screen.dart';
export 'presentation/screens/tags_batch_screen.dart';
export 'presentation/screens/tags_diagnostic_screen.dart';
export 'presentation/screens/tags_import_screen.dart';
export 'presentation/screens/tags_list_screen.dart';
export 'presentation/screens/tags_menu_screen.dart';
export 'presentation/screens/tags_operations_screen.dart';
export 'presentation/screens/tags_store_map_screen.dart';
export 'presentation/screens/tag_add_screen.dart';
export 'presentation/screens/tag_edit_screen.dart';



