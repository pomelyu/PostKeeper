import 'package:flutter/material.dart';
import 'package:postkeeper/l10n/app_localizations.dart';

class KeeperViewModel extends ChangeNotifier {
  KeeperViewModel();
}

class KeeperView extends StatelessWidget {
  const KeeperView({super.key, required this.viewModel});

  final KeeperViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(l10n.navKeeper), Text(l10n.textCommingSoon)],
      ),
    );
  }
}
