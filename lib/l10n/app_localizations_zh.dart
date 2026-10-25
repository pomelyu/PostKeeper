// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get navHome => '首頁';

  @override
  String get navKeeper => '收藏';

  @override
  String get navMap => '地圖';

  @override
  String get navSettings => '設定';

  @override
  String get textCommingSoon => '尚未推出';

  @override
  String get settingsLanguage => '語言';

  @override
  String get mainTitle => '我的明信片';

  @override
  String get mainSubtitle => '把收到的風景，好好收藏';

  @override
  String get mainAddPostcard => '新增明信片';

  @override
  String get mainRecentlyReceived => '最近收到';

  @override
  String get mainRecentlySent => '最近寄出';

  @override
  String get mainNoPostcards => '尚無資料';

  @override
  String get postcardTitle => '明信片';
}
