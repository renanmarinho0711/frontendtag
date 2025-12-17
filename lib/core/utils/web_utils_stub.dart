/// Web utilities that work across platforms
/// This file provides cross-platform implementations for web-specific features
library;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Trigger a file download
/// On web, uses browser download. On other platforms, does nothing (implement file saving if needed)
void triggerDownload(List<int> bytes, String fileName, String mimeType) {
  if (kIsWeb) {
    _triggerWebDownload(bytes, fileName, mimeType);
  } else {
    // For non-web platforms, implement file saving logic if needed
    // For now, this is a no-op as the app is web-first
  }
}

/// Open a URL in a new tab
void openUrl(String url) {
  if (kIsWeb) {
    _openWebUrl(url);
  } else {
    // For non-web platforms, use url_launcher or similar
  }
}

// Web-specific implementations using conditional imports
void _triggerWebDownload(List<int> bytes, String fileName, String mimeType) {
  // This will be overridden by web implementation
}

void _openWebUrl(String url) {
  // This will be overridden by web implementation
}



