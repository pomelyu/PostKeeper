import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/main.dart';

void main() {
  testWidgets('語言切換保留目前路由並套用到其他頁面', (tester) async {
    await tester.pumpWidget(const PostKeeperApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-setting')));
    await tester.pumpAndSettle();

    for (final language in ['en', 'zh']) {
      await tester.tap(
        find.byKey(const ValueKey('settings-language-dropdown')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('language-$language')).last);
      await tester.pumpAndSettle();
      final setting = tester.element(
        find.byKey(const ValueKey('setting-view')),
      );
      expect(Localizations.localeOf(setting).languageCode, language);
      expect(AppLocalizations.of(setting).localeName, language);

      await tester.tap(find.byKey(const ValueKey('nav-main')));
      await tester.pumpAndSettle();
      expect(
        Localizations.localeOf(
          tester.element(find.byKey(const ValueKey('main-view'))),
        ).languageCode,
        language,
      );
      await tester.tap(find.byKey(const ValueKey('nav-setting')));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('底部導覽列可以切換頁面', (tester) async {
    await tester.pumpWidget(const PostKeeperApp());
    await tester.pumpAndSettle();

    // 初始頁面
    expect(find.byKey(const ValueKey('main-view')), findsOneWidget);

    // 切換到收藏
    await tester.tap(find.byKey(const ValueKey('nav-keeper')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('keeper-view')), findsOneWidget);

    // 切換到地圖
    await tester.tap(find.byKey(const ValueKey('nav-map')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('map-view')), findsOneWidget);

    // 切換到設定
    await tester.tap(find.byKey(const ValueKey('nav-setting')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('setting-view')), findsOneWidget);

    // 切回首頁
    await tester.tap(find.byKey(const ValueKey('nav-main')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('main-view')), findsOneWidget);
  });
}
