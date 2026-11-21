import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:postkeeper/constant.dart';
import 'package:postkeeper/data/country_code.dart';
import 'package:postkeeper/data/repositories/person_repository.dart';
import 'package:postkeeper/data/repositories/postcard_repository.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/layout.dart';
import 'package:postkeeper/ui/core/postcard_grid.dart';
import 'package:postkeeper/ui/core/primary_view_layout.dart';

import 'map_filter.dart';
import 'map_region.dart';

class MapViewModel extends ChangeNotifier {
  MapViewModel({required this.repository, this.personRepository});

  final PostcardRepository repository;
  final PersonRepository? personRepository;
  LatLng _homeCenter = defaultMapCenter;
  LatLng get homeCenter => _homeCenter;
  List<Postcard> _postcards = [];
  String? _countryCode;
  bool _disposed = false;

  LatLngBounds? _visibleBounds;
  bool _freeBrowse = false;
  int _cameraRequest = 0;

  String? get countryCode => _countryCode;
  bool get freeBrowse => _freeBrowse;
  int get cameraRequest => _cameraRequest;
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

  List<Postcard> get focusPostcards => _countryCode == null
      ? _postcards
      : _postcards
            .where(
              (card) =>
                  CountryCode.normalizeCountryCode(card.sendFrom.countryCode) ==
                  _countryCode,
            )
            .toList();

  List<Postcard> get postcards => focusPostcards
      .where(
        (card) =>
            _visibleBounds?.contains(
              LatLng(card.sendFrom.latitude!, card.sendFrom.longitude!),
            ) ??
            true,
      )
      .toList();

  static bool _hasCoordinates(Postcard card) {
    final location = card.sendFrom;
    return location.latitude != null &&
        location.longitude != null &&
        location.latitude!.isFinite &&
        location.longitude!.isFinite &&
        location.latitude!.abs() <= 90 &&
        location.longitude!.abs() <= 180;
  }

  Future<void> initialize() async {
    final collection = await repository.getAllPostcards();
    final person = await personRepository?.getMyInfo();
    final home = person == null || person.locations.isEmpty
        ? null
        : person.locations.first;
    final latitude = home?.latitude;
    final longitude = home?.longitude;
    if (latitude != null && longitude != null &&
        latitude.isFinite && longitude.isFinite &&
        latitude.abs() <= 90 && longitude.abs() <= 180) {
      _homeCenter = LatLng(latitude, longitude);
    }
    if (_disposed) return;
    _postcards = collection.postcards.where(_hasCoordinates).toList();
    _cameraRequest++;
    notifyListeners();
  }

  void selectCountry(String? code) {
    _countryCode = code;
    _freeBrowse = false;
    _visibleBounds = null;
    _cameraRequest++;
    notifyListeners();
  }

  void startFreeBrowse() {
    if (_disposed || _freeBrowse) return;
    _countryCode = null;
    _freeBrowse = true;
    notifyListeners();
  }

  void updateVisibleBounds(LatLngBounds bounds) {
    if (_disposed) return;
    _visibleBounds = bounds;
    notifyListeners();
  }

  /// Smallest longitude arc, including places on opposite sides of the date line.
  static LatLngBounds boundsFor(Iterable<LatLng> points) {
    final values = points.toList();
    final longitudes =
        values.map((point) => (point.longitude + 360) % 360).toList()..sort();
    var gap = -1.0;
    var start = 0;
    for (var i = 0; i < longitudes.length; i++) {
      final next = i + 1 < longitudes.length
          ? longitudes[i + 1]
          : longitudes.first + 360;
      if (next - longitudes[i] > gap) {
        gap = next - longitudes[i];
        start = (i + 1) % longitudes.length;
      }
    }
    double longitude(double value) => value > 180 ? value - 360 : value;
    return LatLngBounds(
      southwest: LatLng(
        values.map((p) => p.latitude).reduce(math.min),
        longitude(longitudes[start]),
      ),
      northeast: LatLng(
        values.map((p) => p.latitude).reduce(math.max),
        longitude(
          longitudes[(start + longitudes.length - 1) % longitudes.length],
        ),
      ),
    );
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
              freeBrowse: viewModel.freeBrowse,
              countries: viewModel.countries,
              onChanged: viewModel.selectCountry,
            ),
            sectionVerticalSpace,
            Expanded(flex: 5, child: MapRegion(viewModel: viewModel)),
            sectionVerticalDivider,
            Expanded(
              flex: 4,
              child: PostcardGrid(
                key: const ValueKey('map-postcard-grid'),
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
