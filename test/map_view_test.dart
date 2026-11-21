import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:postkeeper/constant.dart';
import 'package:postkeeper/data/repositories/mock.dart';
import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/l10n/app_localizations_en.dart';
import 'package:postkeeper/l10n/app_localizations_zh.dart';
import 'support/test_app.dart';
import 'package:postkeeper/ui/core/geography_names.dart';
import 'package:postkeeper/ui/core/postcard_grid.dart';
import 'package:postkeeper/ui/map_view/map_view.dart';

class _HomePersonRepository extends MockPersonRepository {
  _HomePersonRepository(this.home);
  final Location? home;

  @override
  Future<Person> getMyInfo() async => Person(
    id: myId,
    name: '',
    locations: [?home],
  );
}

void main() {
  test('地圖中心使用家的座標', () async {
    final model = MapViewModel(
      repository: MockPostcardRepository(),
      personRepository: _HomePersonRepository(const Location(
        id: 'home', name: '', countryCode: 'TW',
        latitude: 22.6273, longitude: 120.3014,
      )),
    );
    await model.initialize();
    expect(model.homeCenter, const LatLng(22.6273, 120.3014));
    model.dispose();
  });

  test('家沒有座標或地址時使用預設中心', () async {
    for (final home in <Location?>[
      null,
      const Location(id: 'home', name: '', countryCode: 'TW'),
    ]) {
      final model = MapViewModel(
        repository: MockPostcardRepository(),
        personRepository: _HomePersonRepository(home),
      );
      await model.initialize();
      expect(model.homeCenter, defaultMapCenter);
      model.dispose();
    }
  });

  test('國家名稱依語言顯示並保留未知代碼', () {
    final en = AppLocalizationsEn();
    final zh = AppLocalizationsZh();
    expect(getCountryName(' jp ', zh), '日本');
    expect(getCountryName('JP', en), 'Japan');
    expect(getCountryName('CA', zh), '加拿大');
    expect(getCountryName('PT', en), 'Portugal');
    expect(getCountryName('ZZ', en), 'ZZ');
  });

  test('依寄件國家篩選明信片並可回到全部', () async {
    final model = MapViewModel(repository: MockPostcardRepository());
    await model.initialize();
    expect(model.postcards.length, 9);
    expect(model.countries, ['CA', 'JP', 'PT', 'TW']);
    model.selectCountry('JP');
    expect(model.postcards.length, 3);
    expect(
      model.postcards.every((card) => card.sendFrom.countryCode == 'JP'),
      isTrue,
    );
    model.selectCountry(null);
    expect(model.postcards.length, 9);
    model.dispose();
  });

  testWidgets('國家選取與地圖視野變更後圖釘和清單包含相同明信片', (tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-map')));
    await tester.pumpAndSettle();
    final view = tester.widget<MapView>(find.byKey(const ValueKey('map-view')));

    Future<void> expectSamePostcards({required int count}) async {
      await tester.pumpAndSettle();
      final map = tester.widget<GoogleMap>(
        find.byKey(const ValueKey('postcard-map')),
      );
      final grid = tester.widget<PostcardGrid>(
        find.byKey(const ValueKey('map-postcard-grid')),
      );
      final pinIds = map.markers
          .expand(
            (marker) =>
                (jsonDecode(marker.markerId.value) as List).cast<String>(),
          )
          .toList();
      expect(grid.postcards, hasLength(count));
      expect(pinIds, unorderedEquals(grid.postcards.map((card) => card.id)));
    }

    await expectSamePostcards(count: 9);
    await tester.tap(find.byKey(const ValueKey('map-country-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('map-country-JP')).last);
    await expectSamePostcards(count: 3);

    view.viewModel.startFreeBrowse();
    view.viewModel.updateVisibleBounds(
      LatLngBounds(
        southwest: const LatLng(40, -130),
        northeast: const LatLng(55, -115),
      ),
    );
    await expectSamePostcards(count: 2);
    view.viewModel.updateVisibleBounds(
      LatLngBounds(
        southwest: const LatLng(-10, 10),
        northeast: const LatLng(10, 30),
      ),
    );
    await expectSamePostcards(count: 0);
  });
}
