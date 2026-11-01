import 'package:flutter/material.dart';
import 'package:postkeeper/data/country_code.dart';
import 'package:postkeeper/data/repositories/postcard_repository.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/geography_names.dart';
import 'package:postkeeper/ui/core/postcard_grid.dart';
import 'package:postkeeper/ui/core/primary_view_layout.dart';

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
            Expanded(
              child: ListView.builder(
                key: const ValueKey('map-placeholder'),
                itemCount: postcards.length,
                itemBuilder: (context, index) {
                  final card = postcards[index];
                  return Text(
                    '${card.title ?? '${card.sender.name} → ${card.recipient.name}'}: ${card.sendFrom.name}, ${card.sendTo.name}',
                  );
                },
              ),
            ),
            const Divider(),
            DropdownButton<String>(
              key: const ValueKey('map-country-dropdown'),
              value: viewModel.countryCode,
              isExpanded: true,
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(l10n.mapAllCountries),
                ),
                for (final code in viewModel.countries)
                  DropdownMenuItem(
                    value: code,
                    child: Text(
                      getCountryName(code, l10n),
                      key: ValueKey('map-country-$code'),
                    ),
                  ),
              ],
              onChanged: viewModel.selectCountry,
            ),
            Expanded(
              child: PostcardGrid(
                key: const ValueKey('map-postcard-grid'),
                postcards: postcards,
              ),
            ),
          ],
        );
      },
    );
  }
}
