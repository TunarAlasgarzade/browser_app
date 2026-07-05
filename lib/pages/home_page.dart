import 'package:browser_app/components/browser_menu.dart';
import 'package:browser_app/components/url_bar.dart';
import 'package:browser_app/models/tab_model.dart';
import 'package:browser_app/pages/tabs_page.dart';
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
  int _activeTabIndex = 0;
  List<BrowserTab> _tabs = [];
  final TextEditingController urlController = TextEditingController();
  Future<void> _loadSettings() async {
    _isHistoryEnabled = await historyService.isHistoryEnabled();
  }

  Future<void> _initialize() async {
    await _loadSettings();
    final firstTab = BrowserTab(
      id: '1',
      url: '',
      title: 'New Tab',
    );
    _tabs.add(firstTab);
    _tabs[_activeTabIndex]
    .controller
    .setNavigationDelegate(
      _createNavigationDelegate(firstTab),
    );
    if (widget.initialUrl != null) {
      _tabs[_activeTabIndex].controller.loadRequest(Uri.parse(widget.initialUrl!));
    } else {
      _tabs[_activeTabIndex].controller.loadHtmlString('<html><body></body></html>');
    }
  }

  void _addNewTab() {
    final newTab = BrowserTab(
      id: _tabs.length.toString(),
      url: '',
      title: 'New Tab',
    );
    setState(() {
      _tabs.add(newTab);
      _activeTabIndex = _tabs.length - 1;
    });
      _tabs[_activeTabIndex]
      .controller
      .setNavigationDelegate(
        _createNavigationDelegate(newTab),
      );
    _tabs[_activeTabIndex].controller.loadHtmlString('<html><body></body></html>');
    urlController.clear();
    _currentUrl = '';
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  NavigationDelegate _createNavigationDelegate(BrowserTab tab) {
    return NavigationDelegate(
      onPageStarted: (url) {
        if (tab != _tabs[_activeTabIndex]) return;
        setState(() {
          isLoading = true;
          loadingProgress = 0;
        });
      },
      onProgress: (progress) {
        if (tab != _tabs[_activeTabIndex]) return;
        setState(() => loadingProgress = progress);
      },
      onPageFinished: (url) async {
        if (tab != _tabs[_activeTabIndex]) return;
        setState(() => isLoading = false);
        _isHistoryEnabled = await historyService.isHistoryEnabled();
        if (_isHistoryEnabled && url != 'about:blank') {
          historyService.addToHistory(url);
        }
        final result = await tab.controller
            .runJavaScriptReturningResult('document.title');
        final title = result.toString().replaceAll('"', '');
        if (title.isNotEmpty) {
          setState(() {
            tab.title = title;
          });
        }
      },
      onUrlChange: (change) {
        if (tab != _tabs[_activeTabIndex]) return;
        _currentUrl = change.url ?? '';
        if (_currentUrl == 'about:blank') {
          urlController.clear();
          _currentUrl = '';
          setState(() {
            tab.title = 'New Tab';
          });
        } else if (_currentUrl.contains('duckduckgo.com/?q=')) {
          final query = Uri.parse(_currentUrl).queryParameters['q'] ?? '';
          urlController.text = query;
          setState(() {
            tab.title = query.isEmpty ? 'New Tab' : query;
          });
        } else {
          urlController.text = _currentUrl
              .replaceFirst('https://', '')
              .replaceFirst('http://', '');
          final host = Uri.parse(_currentUrl).host.replaceFirst('www.', '');
          setState(() {
            tab.title = host.isEmpty ? 'New Tab' : host;
          });
        }
      }
    );
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tabs.isEmpty) return const Scaffold();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (await _tabs[_activeTabIndex].controller.canGoBack()) {
          _tabs[_activeTabIndex].controller.goBack();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 1,
          title: UrlBar(
            webViewController: _tabs[_activeTabIndex].controller,
            urlController: urlController,
            currentUrl: _currentUrl
          ),
          leading: IconButton(onPressed: () {
            urlController.clear();
            _tabs[_activeTabIndex].controller.loadHtmlString('<html><body></body></html>');
          }, icon: Icon(Icons.home)),
          actions: [
            IconButton(
              icon: Text(
                '${_tabs.length}', 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 16
                ),
              ),
              onPressed: () => Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => TabsPage(
                    tabs: _tabs, 
                    onTabSelected: (index) {
                      setState(() => _activeTabIndex = index);
                      Navigator.pop(context);
                    },
                    onNewTab: () {
                      _addNewTab();
                      Navigator.pop(context);
                    },
                    onTabClosed: (index) {
                      setState(() {
                        _tabs.removeAt(index);
                        if (_tabs.isEmpty) {
                          _addNewTab();
                        } else if (_activeTabIndex >= _tabs.length) {
                          _activeTabIndex = _tabs.length - 1;
                        }
                      });
                    },
                  ),
                )
              ),
            ),
            BrowserMenu(
              controller: _tabs[_activeTabIndex].controller,
              currentUrl: _currentUrl,
            )
          ],
        ),
        body: Stack(
            children: [
              WebViewWidget(controller: _tabs[_activeTabIndex].controller),
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