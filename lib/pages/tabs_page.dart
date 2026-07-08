import 'package:browser_app/models/tab_model.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  final List<BrowserTab> tabs;
  final Function(int) onTabSelected;
  final Function() onNewTab;
  final Function(int) onTabClosed;
  const TabsPage({
    super.key, 
    required this.tabs, 
    required this.onTabSelected,
    required this.onNewTab,
    required this.onTabClosed,
  });

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tabs"),
        actions: [
          IconButton(
            onPressed: () => widget.onNewTab(), 
            icon: Icon(Icons.add)
          )
        ],
      ),
      body: Material(
        color: Theme.of(context).colorScheme.surface,
        child: ListView(
          children: widget.tabs.map((tab) => ListTile(
            trailing: IconButton(
              onPressed: () {
                setState(() {});
                widget.onTabClosed(widget.tabs.indexOf(tab));
              },
              icon: const Icon(Icons.close),
            ),
            title: Text(tab.title),
            onTap: () => widget.onTabSelected(widget.tabs.indexOf(tab)),
          )).toList(),
        ),
      ),
    );
  }
}