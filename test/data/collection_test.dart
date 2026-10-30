import 'package:flutter_test/flutter_test.dart';
import 'package:postkeeper/constant.dart';
import 'package:postkeeper/domain/models/collection.dart';
import 'package:postkeeper/enums.dart';
import 'package:postkeeper/l10n/app_localizations_en.dart';
import 'package:postkeeper/l10n/app_localizations_zh.dart';
import 'package:postkeeper/ui/core/utils.dart';

void main() {
  test('收藏夾名稱依類型與語言顯示且不修改資料', () {
    final en = AppLocalizationsEn();
    final zh = AppLocalizationsZh();
    final region = Collection(id: '142', name: '142', type: CollectionType.region, postcards: []);
    final year = Collection(id: '000', name: '000', type: CollectionType.year, postcards: []);
    final custom = Collection(id: favoriteCollectionId, name: 'My album', type: CollectionType.custom, postcards: []);
    final system = Collection(id: favoriteCollectionId, name: 'Favorite', type: CollectionType.system, postcards: []);

    expect(decodeCollectionName(region, en), en.geoAsia);
    expect(decodeCollectionName(region, zh), zh.geoAsia);
    expect(decodeCollectionName(year, en), en.geoUnknown);
    expect(decodeCollectionName(year, zh), zh.geoUnknown);
    expect(decodeCollectionName(custom, zh), custom.name);
    expect(decodeCollectionName(system, zh), zh.keeperFavorite);
  });
}
