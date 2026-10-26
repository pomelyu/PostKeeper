import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/main.dart';
import 'package:postkeeper/ui/core/postcard_frame.dart';
import 'package:postkeeper/ui/main_view/postcard_tab.dart';
import 'package:postkeeper/ui/postcard_edit_view/postcard_edit_view.dart';
import 'package:postkeeper/ui/postcard_view.dart';

void main() {
  testWidgets('點選新增明信片後返回首頁', (tester) async {
    await tester.pumpWidget(const PostKeeperApp());
    await tester.pumpAndSettle();

    final addButton = find.descendant(
      of: find.byKey(const ValueKey('main-quick-add-section')),
      matching: find.byType(TextButton),
    );
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    final editFinder = find.byKey(const ValueKey('postcard-edit-view'));
    expect(editFinder, findsOneWidget);
    expect(
      tester.widget<PostcardEditView>(editFinder).viewModel.postcard,
      isNull,
    );

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('main-view')), findsOneWidget);
    expect(editFinder, findsNothing);
  });


  for (final section in ['received', 'sent']) {
    final sectionName = section == 'received' ? '最近收到' : '最近寄出';
    testWidgets('點選首頁$sectionName明信片開啟對應詳情並可返回', (tester) async {
      await tester.pumpWidget(const PostKeeperApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ValueKey('main-$section-tab')));
      await tester.pumpAndSettle();

      final cardFinder = find.byKey(ValueKey('main-$section-content'));
      final postcard = tester.widget<PostcardSummary>(cardFinder).postcard;
      await tester.runAsync(
        () => precacheImage(
          AssetImage(postcard!.frontImagePath),
          tester.element(cardFinder),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(of: cardFinder, matching: find.byType(PostcardFrame)),
      );
      await tester.pumpAndSettle();

      final detailFinder = find.byKey(const ValueKey('postcard-view'));
      expect(detailFinder, findsOneWidget);
      expect(
        tester.widget<PostcardView>(detailFinder).viewModel.postcard,
        same(postcard),
      );

      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('main-view')), findsOneWidget);
      expect(detailFinder, findsNothing);
      expect(cardFinder.hitTestable(), findsOneWidget);
    });
  }

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
    expect(
      find.byKey(const ValueKey('main-view')),
      findsOneWidget,
    );

    // 切換到收藏
    await tester.tap(find.byKey(const ValueKey('nav-keeper')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('keeper-view')),
      findsOneWidget,
    );

    // 切換到地圖
    await tester.tap(find.byKey(const ValueKey('nav-map')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('map-view')),
      findsOneWidget,
    );

    // 切換到設定
    await tester.tap(find.byKey(const ValueKey('nav-setting')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('setting-view')),
      findsOneWidget,
    );

    // 切回首頁
    await tester.tap(find.byKey(const ValueKey('nav-main')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('main-view')),
      findsOneWidget,
    );
  });
}
