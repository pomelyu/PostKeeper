# 國家代碼與地理分區

`Location.countryCode` 使用 ISO 3166-1 alpha-2 國家或地區代碼，例如 `TW`、`JP`。`CountryCode` 使用程式內的靜態對照表查詢分區。

```dart
import 'package:postkeeper/data/country_code.dart';

final code = CountryCode.normalizeCountryCode(' jp '); // 'JP'
final info = CountryCode.getRegionInfo(code);
// info.regionCode: '142'（亞洲）
// info.subregionCode: '030'（東亞）

CountryCode.getRegion('TW');                  // '142'
CountryCode.getSubregion('CA');              // '021'（北美地區）
CountryCode.getRegion('AQ');                  // '000'

final l10n = AppLocalizations.of(context);
CountryCode.getRegionName('142', l10n);       // '亞洲' 或 'Asia'
CountryCode.getSubregionName('030', l10n);    // '東亞' 或 'Eastern Asia'
CountryCode.getRegionName('000', l10n);       // '未知' 或 'Unknown'
```

名稱查詢使用目前的 `AppLocalizations`，隨 app 語言切換；未知或不屬於該層級的代碼顯示「未知」或 `Unknown`。

國家代碼查詢會自動去除前後空白並轉為大寫。找不到時區域與亞區代碼均回傳 `000`，代表未找到，並非 M49 分區代碼。正規化和查詢結果均不能用來驗證代碼是否有效。

`regionCode` 是聯合國 M49 宏觀地理區域代碼；`subregionCode` 是最細的地理分區代碼：有 intermediate region 時使用其代碼，否則使用 sub-region 代碼。兩者均以三位字串表示，以保留前導零。

對照表包含 [聯合國 M49 資料](https://unstats.un.org/unsd/methodology/m49/overview/)中有 alpha-2 代碼及分區的 247 個國家或地區（查閱於 2026-10-29）。`TW` → 亞洲／東亞是應用程式補充項目；`AQ` 尚未收錄。
