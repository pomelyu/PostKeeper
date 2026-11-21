import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postkeeper/data/repositories/sqlite_person_repository.dart';
import 'package:postkeeper/data/repositories/sqlite_postcard_repository.dart';
import 'package:postkeeper/data/services/database/postkeeper_database.dart';
import 'package:postkeeper/main.dart';
import 'package:postkeeper/ui/core/postcard_frame.dart';
import 'package:postkeeper/ui/main_view/postcard_tab.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('正式空白 SQLite 首頁可切換分頁、開啟空收藏夾與新增頁面', (tester) async {
    sqfliteFfiInit();
    final store = await tester.runAsync(
      () => PostKeeperDatabase.open(
        path: inMemoryDatabasePath,
        factory: databaseFactoryFfiNoIsolate,
      ),
    );
    addTearDown(store!.close);
    await tester.pumpWidget(
      PostKeeperApp(
        postcardRepository: SqlitePostcardRepository(
          database: store.connection,
          imageRoot: '/unused',
        ),
        personRepository: SqlitePersonRepository(database: store.connection),
        locationRepository: TestLocationRepository(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('main-view')), findsOneWidget);
    expect(
      tester
          .widget<PostcardSummary>(
            find.byKey(const ValueKey('main-received-content')),
          )
          .postcard,
      isNull,
    );
    expect(
      tester
          .widget<PostcardFrame>(
            find.descendant(
              of: find.byKey(const ValueKey('main-received-content')),
              matching: find.byType(PostcardFrame),
            ),
          )
          .postcard,
      isNull,
    );

    await tester.tap(find.byKey(const ValueKey('main-received-content')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('postcard-view')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('main-sent-tab')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<PostcardSummary>(
            find.byKey(const ValueKey('main-sent-content')),
          )
          .postcard,
      isNull,
    );
    expect(
      tester
          .widget<PostcardFrame>(
            find.descendant(
              of: find.byKey(const ValueKey('main-sent-content')),
              matching: find.byType(PostcardFrame),
            ),
          )
          .postcard,
      isNull,
    );

    final pinned = find.byKey(const ValueKey('main-pinned-section'));
    await tester.tap(
      find.descendant(of: pinned, matching: find.byType(InkWell)).first,
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('collection-view')), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('main-quick-add-section')),
        matching: find.byType(TextButton),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('postcard-edit-view')), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('main-view')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
