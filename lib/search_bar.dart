import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:search_explore/search_engine_enum.dart'; // Import the new enum file

class Searchbar extends StatefulWidget {
  final SearchEngine selectedEngine; // Use the imported SearchEngine
  final Function(String query) onSearch;

  const Searchbar({
    super.key,
    required this.selectedEngine,
    required this.onSearch,
  });

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  final _txtcontroller = TextEditingController();
  List<String> _suggestions = [];
  bool _isLoadingSuggestions = false;

  @override
  void initState() {
    super.initState();
    _txtcontroller.addListener(_onSearchQueryChanged);
  }

  @override
  void dispose() {
    _txtcontroller.removeListener(_onSearchQueryChanged);
    _txtcontroller.dispose();
    super.dispose();
  }

  void _onSearchQueryChanged() {
    final query = _txtcontroller.text;
    if (query.isNotEmpty) {
      _fetchSuggestions(query);
    } else {
      setState(() {
        _suggestions = [];
      });
    }
  }

  Future<void> _fetchSuggestions(String query) async {
    setState(() {
      _isLoadingSuggestions = true;
    });

    String suggestionUrl = 'http://suggestqueries.google.com/complete/search?client=firefox&q=$query';

    try {
      final response = await http.get(Uri.parse(suggestionUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.length > 1 && data[1] is List) {
          setState(() {
            _suggestions = List<String>.from(data[1]);
          });
        }
      } else {
        debugPrint('Failed to load suggestions: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching suggestions: $e');
    } finally {
      setState(() {
        _isLoadingSuggestions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white.withAlpha(40),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 100,
                  spreadRadius: 10,
                  color: Color.fromARGB(255, 0, 0, 132),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _txtcontroller,
                    onSubmitted: (value) {
                      widget.onSearch(value);
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search.....',
                      hintStyle: TextStyle(letterSpacing: 2, fontSize: 15),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white70),
                  onPressed: () => widget.onSearch(_txtcontroller.text),
                ),
              ],
            ),
          ),
        ),
        if (_suggestions.isNotEmpty && !_isLoadingSuggestions && _txtcontroller.text.isNotEmpty)
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_suggestions[index], style: const TextStyle(color: Colors.white70)),
                  onTap: () {
                    _txtcontroller.text = _suggestions[index];
                    widget.onSearch(_suggestions[index]);
                    setState(() {
                      _suggestions = [];
                    });
                  },
                );
              },
            ),
          ),
        if (_isLoadingSuggestions)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
            ),
          ),
      ],
    );
  }
}