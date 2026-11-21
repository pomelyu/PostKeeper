import 'package:flutter/material.dart';
import 'package:postkeeper/ui/core/layout.dart';
import 'package:postkeeper/ui/style.dart';



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
        sectionVerticalSpace,
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
      Text(title, style: titleTextStyle, textAlign: TextAlign.left);
}
