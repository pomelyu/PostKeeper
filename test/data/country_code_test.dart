import 'package:flutter_test/flutter_test.dart';
import 'package:postkeeper/l10n/app_localizations_en.dart';
import 'package:postkeeper/l10n/app_localizations_zh.dart';
import 'package:postkeeper/data/country_code.dart';

void main() {
  test('查詢時正規化國家代碼並保留 M49 代碼的前導零', () {
    expect(CountryCode.normalizeCountryCode(' jp '), 'JP');
    expect(CountryCode.normalizeCountryCode('  '), '');
    final japan = CountryCode.getRegionInfo(' jp ');
    expect(japan.regionCode, '142');
    expect(japan.subregionCode, '030');
    expect(CountryCode.getRegion('JP'), '142');
    expect(CountryCode.getSubregion('CA'), '021');
    expect(CountryCode.getSubregion('KE'), '014');
    expect(CountryCode.getSubregion('BR'), '005');
    expect(CountryCode.getSubregion('PT'), '039');
    expect(CountryCode.getSubregion('AU'), '053');
    expect(CountryCode.getRegion('AQ'), '000');
    expect(CountryCode.getRegion('TW'), '142');
    expect(CountryCode.getSubregion('tw'), '030');
  });

  test(
    '地區名稱隨語言切換並處理未知代碼',
    () {
      final en = AppLocalizationsEn();
      final zh = AppLocalizationsZh();
      expect(CountryCode.getRegionName('142', zh), '亞洲');
      expect(CountryCode.getRegionName('142', en), 'Asia');
      expect(CountryCode.getSubregionName('030', zh), '東亞');
      expect(CountryCode.getSubregionName('030', en), 'Eastern Asia');
      for (final l10n in [en, zh]) {
        for (final code in ['000', '999']) {
          expect(CountryCode.getRegionName(code, l10n), l10n.geoUnknown);
          expect(CountryCode.getSubregionName(code, l10n), l10n.geoUnknown);
        }
        expect(CountryCode.getRegionName('030', l10n), l10n.geoUnknown);
        expect(CountryCode.getSubregionName('142', l10n), l10n.geoUnknown);
      }
      for (final code in ['002', '019', '142', '150', '009']) {
        expect(CountryCode.getRegionName(code, en), isNot('Unknown'));
        expect(CountryCode.getRegionName(code, zh), isNot('未知'));
      }
      for (final code in ['014', '017', '015', '018', '011']) {
        expect(CountryCode.getSubregionName(code, en), isNot('Unknown'));
        expect(CountryCode.getSubregionName(code, zh), isNot('未知'));
      }
    },
  );

  test('查無國家代碼時回傳未知的地區與亞區代碼', () {
    final missing = CountryCode.getRegionInfo('AQ');
    expect(missing.regionCode, '000');
    expect(missing.subregionCode, '000');
    expect(CountryCode.getRegion('invalid'), '000');
    expect(CountryCode.getSubregion(''), '000');
  });
}
