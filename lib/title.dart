import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key});

  final double size = 30;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Event Manager",
      style: TextStyle(fontSize: size, fontWeight: FontWeight.w800,
      shadows: [
        Shadow(
          offset: Offset(size / 5, size / 5),
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          blurRadius: size / 2,
        ),
      ]),
    );
  }
}
