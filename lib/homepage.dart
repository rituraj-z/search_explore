import 'package:flutter/material.dart';
import 'package:search_explore/search_bar.dart';
import 'title_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const TitleBar(),
      ),
      body: const Column(
        children: [
          Searchbar(),
        ],
      ),
    );
  }
}
