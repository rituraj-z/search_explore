import 'package:flutter/material.dart';
import 'package:search_explore/search_bar.dart';
import 'package:search_explore/title_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:search_explore/search_engine_enum.dart'; // Import the new enum file

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Use the imported SearchEngine enum
  SearchEngine _selectedEngine = SearchEngine.google;

  static const Map<SearchEngine, String> _searchEngineUrls = {
    SearchEngine.google: 'https://www.google.com/search?q=',
    SearchEngine.youtube: 'https://www.youtube.com/results?search_query=',
    SearchEngine.duckduckgo: 'https://duckduckgo.com/?q=',
    SearchEngine.wikipedia: 'https://en.wikipedia.org/wiki/Special:Search?search=',
  };

  void _performSearchFromAppBar(String query) async {
    if (query.isNotEmpty) {
      final baseUrl = _searchEngineUrls[_selectedEngine];
      if (baseUrl == null) {
        debugPrint('Error: No URL found for selected search engine.');
        return;
      }
      final url = '$baseUrl${Uri.encodeComponent(query)}';

      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const TitleBar(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<SearchEngine>( // Use SearchEngine here
              value: _selectedEngine,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
              underline: const SizedBox(),
              onChanged: (SearchEngine? newValue) { // Use SearchEngine here
                setState(() {
                  _selectedEngine = newValue!;
                });
              },
              items: const <DropdownMenuItem<SearchEngine>>[ // Use SearchEngine here
                DropdownMenuItem(
                  value: SearchEngine.google,
                  child: Text('Google', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: SearchEngine.youtube,
                  child: Text('YouTube', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: SearchEngine.duckduckgo,
                  child: Text('DuckDuckGo', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: SearchEngine.wikipedia,
                  child: Text('Wikipedia', style: TextStyle(color: Colors.white)),
                ),
              ],
              dropdownColor: const Color.fromARGB(255, 1, 2, 32),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Searchbar(
              selectedEngine: _selectedEngine,
              onSearch: _performSearchFromAppBar,
            ),
          ),
        ],
      ),
    );
  }
}