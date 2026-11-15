import 'package:flutter/material.dart';
import 'package:postkeeper/ui/style.dart';

final sectionSpace = SizedBox(height: sectionSpacing);

class PrimaryViewLayout extends StatelessWidget {
  const PrimaryViewLayout({
    super.key,
    required this.title,
    required this.children,
  });
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: pagePaddingHorizontal),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryViewTitle(title: title),
        sectionSpace,
        ...children,
      ],
    ),
  );
}

class PrimaryViewTitle extends StatelessWidget {
  const PrimaryViewTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) =>
      Text(title, style: styleDisplayTitle, textAlign: TextAlign.left);
}
