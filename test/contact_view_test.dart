import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/constant.dart';
import 'package:postkeeper/data/repositories/mock.dart';
import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/ui/contact_list_view/contact_list_view.dart';
import 'package:postkeeper/ui/contact_view/contact_view.dart';

import 'support/test_app.dart';

class _FailingPersonRepository extends MockPersonRepository {
  @override
  Future<void> updateName(String id, String name) async =>
      throw StateError('Save failed');
}

void main() {
  test(
    '聯絡人列表排除本人，個人資訊使用本人資料',
    () async {
      final repository = MockPersonRepository();
      final all = await repository.getAllUsers();
      final contacts = await ContactListViewModel(repository: repository)
          .contacts;
      expect(
        contacts.map((person) => person.id),
        all.where((person) => person.id != myId).map((person) => person.id),
      );
      expect(contacts.any((person) => person.id == myId), isFalse);
      final mine = ContactViewModel(repository: repository);
      expect((await mine.contact).id, myId);
      final friend = contacts.first;
      expect(
        await ContactViewModel(repository: repository, person: friend).contact,
        same(friend),
      );
    },
  );

  test('聯絡人儲存失敗時保留原資料與輸入，並允許重試', () async {
    final model = ContactViewModel(repository: _FailingPersonRepository());
    addTearDown(model.dispose);
    final original = await model.contact;
    model.editName();
    model.nameController.text = 'Changed';
    expect(await model.saveName(), isFalse);
    expect(model.editingName, isTrue);
    expect(model.nameController.text, 'Changed');
    expect(model.saving, isFalse);
    expect(await model.contact, same(original));
    expect(await model.rename('   '), isFalse);
  });

  testWidgets('新增聯絡人進入詳情並可在列表刪除', (tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-user')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('user-contacts')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('contact-add-button')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextButton>(find.byKey(const ValueKey('contact-new-confirm')))
          .onPressed,
      isNull,
    );
    await tester.enterText(
      find.byKey(const ValueKey('contact-new-name')),
      'New contact',
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('contact-new-confirm')));
    await tester.pumpAndSettle();
    expect(find.byType(ContactView), findsOneWidget);
    final person = await tester
        .widget<ContactView>(find.byType(ContactView))
        .viewModel
        .contact;
    expect(person.name, 'New contact');
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    final delete = find.byKey(ValueKey('contact-delete-${person.id}'));
    await tester.ensureVisible(delete);
    await tester.tap(delete);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('contact-delete-cancel')));
    await tester.pumpAndSettle();
    expect(delete, findsOneWidget);
    await tester.tap(delete);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('contact-delete-confirm')));
    await tester.pumpAndSettle();
    expect(delete, findsNothing);
  });

  testWidgets(
    '聯絡人名稱需儲存才更新，地址選取與刪除需確認',
    (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('nav-user')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('user-personal-info')));
      await tester.pumpAndSettle();
      final model = tester
          .widget<ContactView>(find.byType(ContactView))
          .viewModel;
      expect(
        tester
            .widget<TextField>(
              find.descendant(
                of: find.byKey(const ValueKey('contact-name-input')),
                matching: find.byType(TextField),
              ),
            )
            .readOnly,
        isTrue,
      );
      await tester.tap(find.byKey(const ValueKey('contact-edit-button')));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextField>(
              find.descendant(
                of: find.byKey(const ValueKey('contact-name-input')),
                matching: find.byType(TextField),
              ),
            )
            .readOnly,
        isFalse,
      );
      await tester.enterText(
        find.byKey(const ValueKey('contact-name-input')),
        '  ',
      );
      await tester.pump();
      expect(
        tester
            .widget<IconButton>(find.byKey(const ValueKey('contact-name-save')))
            .onPressed,
        isNull,
      );
      await tester.enterText(
        find.byKey(const ValueKey('contact-name-input')),
        '  Updated  ',
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('contact-name-save')));
      await tester.pumpAndSettle();
      expect((await model.contact).name, 'Updated');
      expect(
        tester
            .widget<TextField>(
              find.descendant(
                of: find.byKey(const ValueKey('contact-name-input')),
                matching: find.byType(TextField),
              ),
            )
            .readOnly,
        isTrue,
      );
      expect(find.byKey(const ValueKey('contact-edit-button')), findsOneWidget);

      final router = GoRouter.of(tester.element(find.byType(ContactView)));
      final count = (await model.contact).locations.length;
      await tester.tap(find.byKey(const ValueKey('contact-add-address')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('location-picker-view')),
        findsOneWidget,
      );
      router.pop();
      await tester.pumpAndSettle();
      expect((await model.contact).locations, hasLength(count));
      await tester.tap(find.byKey(const ValueKey('contact-add-address')));
      await tester.pumpAndSettle();
      router.pop(const Location(id: 'added', name: 'Added', countryCode: 'TW'));
      await tester.pumpAndSettle();
      expect((await model.contact).locations.last.id, 'added');
      final deleteButton = find.byKey(
        const ValueKey('contact-delete-address-added'),
      );
      await tester.ensureVisible(deleteButton);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('contact-delete-cancel')));
      await tester.pumpAndSettle();
      expect((await model.contact).locations.last.id, 'added');
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('contact-delete-confirm')));
      await tester.pumpAndSettle();
      expect((await model.contact).locations, hasLength(count));
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('user-personal-info')));
      await tester.pumpAndSettle();
      expect(
        (await tester
                .widget<ContactView>(find.byType(ContactView))
                .viewModel
                .contact)
            .name,
        'Updated',
      );
    },
  );

  testWidgets('聯絡人與個人資訊頁面返回來源路由', (
    tester,
  ) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-user')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('user-contacts')));
    await tester.pumpAndSettle();
    expect(find.byType(ContactListView), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byKey(ValueKey('contact-$myId')), findsNothing);
    final friend = (await MockPersonRepository().getAllUsers()).firstWhere(
      (person) => person.id != myId,
    );
    await tester.tap(find.byKey(ValueKey('contact-${friend.id}')));
    await tester.pumpAndSettle();
    final detail = tester.widget<ContactView>(find.byType(ContactView));
    expect((await detail.viewModel.contact).id, friend.id);
    expect(find.byType(NavigationBar), findsNothing);
    expect(
      tester
          .widget<IconButton>(find.byKey(const ValueKey('contact-edit-button')))
          .onPressed,
      isNotNull,
    );
    expect(await detail.viewModel.rename('Renamed friend'), isTrue);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(ContactListView), findsOneWidget);
    final updatedContacts = await tester
        .widget<ContactListView>(find.byType(ContactListView))
        .viewModel
        .contacts;
    expect(
      updatedContacts.firstWhere((person) => person.id == friend.id).name,
      'Renamed friend',
    );
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('user-view')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('user-personal-info')));
    await tester.pumpAndSettle();
    final mine = tester.widget<ContactView>(find.byType(ContactView));
    expect((await mine.viewModel.contact).id, myId);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('user-view')), findsOneWidget);
  });
}
