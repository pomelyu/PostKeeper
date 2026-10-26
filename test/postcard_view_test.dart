import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postkeeper/main.dart';
import 'package:postkeeper/ui/core/postcard_frame.dart';
import 'package:postkeeper/ui/main_view/postcard_tab.dart';
import 'package:postkeeper/ui/postcard_edit_view/postcard_edit_view.dart';
import 'package:postkeeper/ui/postcard_view.dart';

void main() {
  testWidgets('點選編輯明信片後返回原明信片詳情', (tester) async {
    await tester.pumpWidget(const PostKeeperApp());
    await tester.pumpAndSettle();
    final cardFinder = find.byKey(const ValueKey('main-received-content'));
    final receivedPostcard = tester
        .widget<PostcardSummary>(cardFinder)
        .postcard;
    await tester.runAsync(
      () => precacheImage(
        AssetImage(receivedPostcard!.frontImagePath),
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
    final postcard = tester
        .widget<PostcardView>(detailFinder)
        .viewModel
        .postcard;

    await tester.tap(find.byKey(const ValueKey('postcard-edit-button')));
    await tester.pumpAndSettle();

    final editFinder = find.byKey(const ValueKey('postcard-edit-view'));
    expect(editFinder, findsOneWidget);
    expect(
      tester.widget<PostcardEditView>(editFinder).viewModel.postcard,
      same(postcard),
    );

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(editFinder, findsNothing);
    expect(detailFinder, findsOneWidget);
    expect(
      tester.widget<PostcardView>(detailFinder).viewModel.postcard,
      same(postcard),
    );
  });
}
