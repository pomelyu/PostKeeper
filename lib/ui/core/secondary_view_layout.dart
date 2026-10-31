import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/ui/style.dart';


class SecondaryViewLayout extends StatelessWidget {
  const SecondaryViewLayout({
    super.key,
    required this.title,
    required this.child,
    this.titleActions,
  });  

  final String title;
  final List<Widget>? titleActions;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SecondaryViewTitle(title: title),
        leading: BackButton(onPressed: () => context.pop()),
        actions: titleActions,
      ),
      body: SafeArea(
        child: child,
      )
    );
  }

}

class SecondaryViewTitle extends StatelessWidget {
  const SecondaryViewTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: styleSectionTitle, textAlign: TextAlign.left);
  }
}
