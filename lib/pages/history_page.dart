import 'package:browser_app/services/history_service.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> _history = [];
  HistoryService historyService = HistoryService();
  bool _isHistoryEnabled = false;
  void getHistory() {
    historyService.getHistory().then((value) {
      setState(() => _history = value);
    });
  } 
  @override
  void initState() {
    super.initState();
    historyService.isHistoryEnabled().then((value) {
      setState(() => _isHistoryEnabled = value);
    });
    getHistory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red,),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Are you sure you want to delete all history?"),
                    content: const Text("This will permanently delete your browsing history."),
                    actions: [
                      TextButton(
                        onPressed: () {Navigator.pop(context);},
                        child: const Text("Cancel")
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await historyService.clearHistory();
                          getHistory();
                        }, 
                        child: const Text("Delete")
                      ),
                    ],
                  );
                }
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('History'),
            activeThumbColor: Colors.green[600],
            value: _isHistoryEnabled,
            onChanged: (value) async {
              setState(() => _isHistoryEnabled = value);
              await historyService.setHistoryEnabled(value);
              if (!value) {
                await historyService.clearHistory();
                getHistory();
              }
            },
          ),
          if (_isHistoryEnabled)
            ..._history.map((url) => ListTile(
              title: Text(
                url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Delete this history item?"),
                        content: const Text(
                          "This history entry will be permanently deleted.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await historyService.removeFromHistory(url);
                              getHistory();
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            )).toList(),
        ],
      ),
    );
  }
}