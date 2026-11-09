import 'package:flutter/material.dart';
import 'package:postkeeper/data/country_code.dart';
import 'package:postkeeper/data/repositories/postcard_repository.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/postcard_grid.dart';
import 'package:postkeeper/ui/core/primary_view_layout.dart';
import 'package:postkeeper/ui/style.dart';

import 'map_region.dart';
import 'map_filter.dart';

class MapViewModel extends ChangeNotifier {
  MapViewModel({required this.repository});

  final PostcardRepository repository;
  List<Postcard> _postcards = [];
  String? _countryCode;
  bool _disposed = false;

  String? get countryCode => _countryCode;
  List<String> get countries =>
      (_postcards
          .map(
            (card) =>
                CountryCode.normalizeCountryCode(card.sendFrom.countryCode),
          )
          .where((code) => code.isNotEmpty)
          .toSet()
          .toList()
        ..sort());
  List<Postcard> get postcards => _countryCode == null
      ? _postcards
      : _postcards
            .where(
              (card) =>
                  CountryCode.normalizeCountryCode(card.sendFrom.countryCode) ==
                  _countryCode,
            )
            .toList();

  Future<void> initialize() async {
    final collection = await repository.getAllPostcards();
    if (_disposed) return;
    _postcards = collection.postcards;
    notifyListeners();
  }

  void selectCountry(String? code) {
    if (_countryCode == code) return;
    _countryCode = code;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class MapView extends StatelessWidget {
  const MapView({super.key, required this.viewModel});

  final MapViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final postcards = viewModel.postcards;
        return PrimaryViewLayout(
          title: l10n.navMap,
          children: [
            MapFilter(
              countryCode: viewModel.countryCode,
              countries: viewModel.countries,
              onChanged: viewModel.selectCountry,
            ),
            const SizedBox(height: sectionSpacing),
            Expanded(flex: 5, child: MapRegion(postcards: postcards)),
            const Divider(),
            Expanded(
              flex: 4,
              child: PostcardGrid(
                key: const ValueKey('map-postcard-grid'),
                padding: EdgeInsets.zero,
                showDate: true,
                postcards: postcards,
              ),
            ),
          ],
        );
      },
    );
  }
}
