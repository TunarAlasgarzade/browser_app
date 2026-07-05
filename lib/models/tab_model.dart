import 'package:webview_flutter/webview_flutter.dart';

class BrowserTab {
  String id;
  String url;
  String title;
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  BrowserTab({
    required this.id, 
    required this.url, 
    required this.title,
  });
}