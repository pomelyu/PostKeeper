import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postkeeper/main.dart';

void main() {
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
