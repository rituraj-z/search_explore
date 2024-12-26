import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 20),
      child: Text(
        'Explore',
        style: TextStyle(shadows: [
          Shadow(
            color: Colors.white.withAlpha(80),
            blurRadius: 20,
          ),
        ], fontSize: 27, fontWeight: FontWeight.w700, letterSpacing: 2),
      ),
    );
  }
}
