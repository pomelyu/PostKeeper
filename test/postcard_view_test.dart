import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postkeeper/main.dart';
import 'package:postkeeper/ui/core/postcard_frame.dart';
import 'package:postkeeper/ui/main_view/postcard_tab.dart';
import 'package:postkeeper/ui/postcard_edit_view/postcard_edit_view.dart';
import 'package:postkeeper/ui/postcard_view/postcard_view.dart';

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

    await tester.tap(find.byKey(const ValueKey('postcard-back-tab')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('postcard-back-image')), findsOneWidget);
    expect(tester.widget<PostcardView>(detailFinder).viewModel.showBack, isTrue);
    await tester.tap(find.byKey(const ValueKey('postcard-front-tab')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('postcard-front-image')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('postcard-image-preview')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('postcard-preview')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('postcard-preview-close')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('postcard-preview')), findsNothing);
    expect(detailFinder, findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('postcard-edit-button')));
    await tester.pumpAndSettle();

    final editFinder = find.byKey(const ValueKey('postcard-edit-view'));
    expect(editFinder, findsOneWidget);
    expect(
      tester.widget<PostcardEditView>(editFinder).viewModel.postcard,
      same(postcard),
    );

    await tester.tap(find.byKey(const ValueKey('postcard-edit-action')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('postcard-edit-details')), findsOneWidget);
    final editModel = tester.widget<PostcardEditView>(editFinder).viewModel;
    expect(tester.widget<TextButton>(find.byKey(const ValueKey('postcard-edit-action'))).onPressed, isNull);
    await tester.enterText(find.byKey(const ValueKey('postcard-edit-title')), 'Draft title');
    await tester.enterText(find.byKey(const ValueKey('postcard-edit-sender')), 'Draft person');
    await tester.pumpAndSettle();
    expect(editModel.titleController.text, 'Draft title');
    expect(editModel.senderController.text, 'Draft person');
    expect(editModel.sender, isNull);
    expect(postcard.title, isNot('Draft title'));
    final people = await editModel.people;
    final person = people.firstWhere((person) => person.locations.isNotEmpty);
    await tester.tap(find.byKey(const ValueKey('postcard-edit-sender-menu')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ValueKey('person-option-sender-${person.id}')));
    await tester.pumpAndSettle();
    expect(editModel.sender, same(person));
    expect(editModel.senderController.text, person.name);
    await tester.tap(find.byKey(const ValueKey('postcard-edit-send-from-menu')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ValueKey('location-option-send-from-${person.locations.first.id}')));
    await tester.pumpAndSettle();
    expect(editModel.sendFrom, same(person.locations.first));
    await tester.tap(find.byKey(const ValueKey('postcard-edit-sent-date-calendar')));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    final date = DateTime(2026, 1, 2);
    tester.widget<CalendarDatePicker>(find.byType(CalendarDatePicker)).onDateChanged(date);
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: find.byType(DatePickerDialog), matching: find.byType(TextButton)).last);
    await tester.pumpAndSettle();
    expect(editModel.sentAt, date);
    await tester.tap(find.byKey(const ValueKey('postcard-edit-step-1')));
    await tester.pumpAndSettle();
    expect(editModel.currentStep, 0);
    expect(find.byKey(const ValueKey('postcard-edit-details')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('postcard-edit-step-2')));
    await tester.pumpAndSettle();
    expect(editModel.currentStep, 1);
    expect(editModel.titleController.text, 'Draft title');
    expect(editModel.sender, same(person));
    expect(editModel.sentAt, date);


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
