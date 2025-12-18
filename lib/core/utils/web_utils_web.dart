// ignore: avoid_web_libraries_in_flutter
// ignore: deprecated_member_use
import 'dart:html' as html;

/// Web utilities - Web implementation
/// This file provides web-specific implementations for browser features

/// Trigger a file download in the browser
void triggerDownload(List<int> bytes, String fileName, String mimeType) {
  final blob = html.Blob([bytes], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  
  final anchor = html.AnchorElement()
    ..href = url
    ..download = fileName
    ..style.display = 'none';
  
  html.document.body?.children.add(anchor);
  anchor.click();
  
  // Cleanup
  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}

/// Open a URL in a new browser tab
void openUrl(String url) {
  html.window.open(url, '_blank');
}

/// Download file from URL
void downloadFromUrl(String url, String fileName) {
  final anchor = html.AnchorElement()
    ..href = url
    ..download = fileName
    ..target = '_blank'
    ..style.display = 'none';
  
  html.document.body?.children.add(anchor);
  anchor.click();
  html.document.body?.children.remove(anchor);
}



