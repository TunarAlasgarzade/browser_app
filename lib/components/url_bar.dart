import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UrlBar extends StatelessWidget {
  final WebViewController webViewController;
  final TextEditingController urlController;
  const UrlBar({
    super.key, 
    required this.webViewController, 
    required this.urlController
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.grey.shade800,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            hintText: 'Search',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.black, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.black, width: 1.2),
            ),
        ),
        controller: urlController,
        onSubmitted: (value) {
          String trimmed = value.trim();
          bool isUrl = trimmed.startsWith('https://') || 
            trimmed.startsWith('http://') ||
            (!trimmed.contains(' ') && trimmed.contains('.') && !trimmed.endsWith('.'));
          
          String finalUrl;
          if (isUrl) {
            finalUrl = trimmed.startsWith('http') ? trimmed : 'https://$trimmed';
          } else {
            finalUrl = 'https://duckduckgo.com/?q=$trimmed';
          }
          webViewController.loadRequest(Uri.parse(finalUrl));
        },
    );
  }
}