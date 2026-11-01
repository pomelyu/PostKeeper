import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postkeeper/data/repositories/mock.dart';
import 'package:postkeeper/main.dart';
import 'package:postkeeper/l10n/app_localizations_en.dart';
import 'package:postkeeper/l10n/app_localizations_zh.dart';
import 'package:postkeeper/ui/core/geography_names.dart';
import 'package:postkeeper/ui/core/postcard_grid.dart';
import 'package:postkeeper/ui/map_view.dart';

void main() {
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
    expect(model.postcards.length, 5);
    expect(model.countries, ['CA', 'JP', 'PT']);
    model.selectCountry('JP');
    expect(model.postcards.length, 2);
    expect(
      model.postcards.every((card) => card.sendFrom.countryCode == 'JP'),
      isTrue,
    );
    model.selectCountry(null);
    expect(model.postcards.length, 5);
    model.dispose();
  });

  testWidgets('選擇國家後地圖佔位區與明信片清單同步篩選', (tester) async {
    await tester.pumpWidget(const PostKeeperApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-map')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('map-country-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('map-country-JP')).last);
    await tester.pumpAndSettle();
    final map = tester.widget<MapView>(find.byKey(const ValueKey('map-view')));
    final grid = tester.widget<PostcardGrid>(
      find.byKey(const ValueKey('map-postcard-grid')),
    );
    final placeholder = tester.widget<ListView>(
      find.byKey(const ValueKey('map-placeholder')),
    );
    expect(map.viewModel.countryCode, 'JP');
    expect(grid.postcards.length, 2);
    expect(
      placeholder.childrenDelegate.estimatedChildCount,
      grid.postcards.length,
    );
    expect(
      grid.postcards.every((card) => card.sendFrom.countryCode == 'JP'),
      isTrue,
    );
  });
}
