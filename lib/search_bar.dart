import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Searchbar extends StatefulWidget {
  const Searchbar({
    super.key,
  });

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  final _txtcontroller = TextEditingController();
  void search() async {
    final query = _txtcontroller.text;
    if (query.isNotEmpty) {
      final url = 'https://www.google.com/search?q=$query';
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
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
            ]),
        child: TextField(
          controller: _txtcontroller,
          onSubmitted: (value) {
            search();
          },
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Search.....',
              hintStyle: TextStyle(letterSpacing: 2, fontSize: 15)),
        ),
      ),
    );
  }
}
