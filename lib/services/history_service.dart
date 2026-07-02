import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  // add history
  Future<void> addToHistory(String url) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('history') ?? [];
    
    // keep only the q parameter for DuckDuckGo
    String cleanUrl = url;
    if (url.contains('duckduckgo.com/?q=')) {
      final q = Uri.parse(url).queryParameters['q'] ?? '';
      cleanUrl = 'https://duckduckgo.com/?q=$q';
    }
    
    if (history.isNotEmpty && history.first == cleanUrl) return;
    history.insert(0, cleanUrl);
    if (history.length > 100) {
      history = history.sublist(0, 100);
    }
    await prefs.setStringList('history', history);
  }
    
  // get history
  Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('history') ?? [];
  }

  // clear history
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('history');
  }

  // history enabled?
  Future<bool> isHistoryEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('historyEnabled') ?? false;
  }

  // set history enabled
  Future<void> setHistoryEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('historyEnabled', value);
  }

  // remove single history item
  Future<void> removeFromHistory(String url) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('history') ?? [];
    history.remove(url);
    await prefs.setStringList('history', history);
  }
}