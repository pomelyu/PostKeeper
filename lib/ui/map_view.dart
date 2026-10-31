import 'package:flutter/material.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/primary_view_layout.dart';

class MapViewModel extends ChangeNotifier {
  MapViewModel();
}

class MapView extends StatelessWidget {
  const MapView({super.key, required this.viewModel});

  final MapViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PrimaryViewLayout(
      title: l10n.navMap,
      children: [Text(l10n.textCommingSoon)],
    );
  }
}
