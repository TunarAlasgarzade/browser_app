import 'package:browser_app/components/browser_menu.dart';
import 'package:browser_app/components/url_bar.dart';
import 'package:browser_app/services/history_service.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  final String? initialUrl;
  const HomePage({super.key, this.initialUrl});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HistoryService historyService = HistoryService();
  bool _isHistoryEnabled = false; 
  int loadingProgress = 0;
  bool isLoading = false;
  String _currentUrl = '';
  final TextEditingController urlController = TextEditingController();
  final WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);
  Future<void> _loadSettings() async {
    _isHistoryEnabled = await historyService.isHistoryEnabled();
  }

  Future<void> _initialize() async {
    await _loadSettings();
    webViewController.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            isLoading = true;
            loadingProgress = 0;
          });
        },
        onProgress: (progress) {
          setState(() => loadingProgress = progress);
        },
        onPageFinished: (url) async {
          setState(() => isLoading = false);
          _isHistoryEnabled = await historyService.isHistoryEnabled();
          if (_isHistoryEnabled && url != 'about:blank') {
            historyService.addToHistory(url);
          }
        },
        onUrlChange: (change) {
          _currentUrl = change.url ?? '';
          if (_currentUrl == 'about:blank') {
            urlController.clear();
            _currentUrl = '';
          } else if (_currentUrl.contains('duckduckgo.com/?q=')) {
            final query = Uri.parse(_currentUrl).queryParameters['q'] ?? '';
            urlController.text = query;
          } else {
            urlController.text = _currentUrl
                .replaceFirst('https://', '')
                .replaceFirst('http://', '');
          }
        },
      ),
    );
    if (widget.initialUrl != null) {
      webViewController.loadRequest(Uri.parse(widget.initialUrl!));
    } else {
      webViewController.loadHtmlString('<html><body></body></html>');
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (await webViewController.canGoBack()) {
          webViewController.goBack();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 1,
          title: UrlBar(
            webViewController: webViewController, 
            urlController: urlController,
            currentUrl: _currentUrl
          ),
          leading: IconButton(onPressed: () {
            urlController.clear();
            webViewController.loadHtmlString('<html><body></body></html>');
          }, icon: Icon(Icons.home)),
          actions: [
            BrowserMenu(
              controller: webViewController,
              currentUrl: _currentUrl,
            )
          ],
        ),
        body: Stack(
            children: [
              WebViewWidget(controller: webViewController),
              if (isLoading)
                LinearProgressIndicator(
                  value: loadingProgress / 100,
                  color: Colors.green,
                  backgroundColor: Colors.green[100],
                ),
            ],
        ),
      ),
    );
  }
}