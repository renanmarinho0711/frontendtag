// Web utilities - Cross-platform entry point
/// Uses conditional imports to provide the right implementation for each platform
/// 
/// Usage:
/// ```dart
/// import 'package:tagbean/core/utils/web_utils.dart';
/// 
/// // Download a file
/// triggerDownload(bytes, 'filename.txt', 'text/plain');
/// 
/// // Open URL in new tab
/// openUrl('https://example.com');
/// ```

export 'web_utils_stub.dart' if (dart.library.html) 'web_utils_web.dart';



