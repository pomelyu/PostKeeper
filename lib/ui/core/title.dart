import 'package:flutter/material.dart';
import 'package:postkeeper/ui/style.dart';

class TitleTextBox extends StatelessWidget {
  const TitleTextBox({super.key, required this.title, this.minHeight = 60.0});

  final String title;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(title, style: styleDisplayTitle, textAlign: TextAlign.left),
        ),
    );
  }
}