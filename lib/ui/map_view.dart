import 'package:flutter/material.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/title.dart';

class MapViewModel extends ChangeNotifier {
  MapViewModel();
}

class MapView extends StatelessWidget {
  const MapView({super.key, required this.viewModel});

  final MapViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TitleTextBox(title: l10n.navMap),
          Text(l10n.textCommingSoon),
        ],
      ),
    );
  }
}
