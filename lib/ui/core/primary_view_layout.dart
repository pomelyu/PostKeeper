import 'package:flutter/material.dart';
import 'package:postkeeper/ui/style.dart';

class PrimaryViewLayout extends StatelessWidget{
  const PrimaryViewLayout({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryViewTitle(title: title),
        ...children,
      ],
    );
  }
}

class PrimaryViewTitle extends StatelessWidget {
  const PrimaryViewTitle({super.key, required this.title, this.minHeight = 60.0});

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
