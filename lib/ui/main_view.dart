import 'package:flutter/material.dart';
import 'package:postkeeper/l10n/app_localizations.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel();
}

class MainView extends StatelessWidget {
  const MainView({super.key, required this.viewModel});

  final MainViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(l10n.navHome), Text(l10n.textCommingSoon)],
      ),
    );
  }
}
