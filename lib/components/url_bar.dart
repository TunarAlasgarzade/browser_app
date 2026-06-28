import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UrlBar extends StatelessWidget {
  final WebViewController webViewController;
  final TextEditingController urlController;
  final String currentUrl;
  const UrlBar({
    super.key, 
    required this.webViewController, 
    required this.urlController,
    required this.currentUrl,
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
        onTap: () {
          urlController.text = currentUrl;
          urlController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: currentUrl.length,
          );
        },
        controller: urlController,
        onSubmitted: (value) {
          String trimmed = value.trim();
          if (trimmed.isEmpty) return;
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