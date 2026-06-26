import 'package:browser_app/components/browser_menu.dart';
import 'package:browser_app/components/url_bar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController urlController = TextEditingController();
  WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1,
        title: UrlBar(
          webViewController: webViewController, 
          urlController: urlController
        ),
        leading: IconButton(onPressed: () {
          urlController.clear();
          webViewController.loadHtmlString('<html><body></body></html>');
        }, icon: Icon(Icons.home)),
        actions: [
          BrowserMenu(controller: webViewController)
        ],
      ),
      body: WebViewWidget(controller: webViewController),
    );
  }
}