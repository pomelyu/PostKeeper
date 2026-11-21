import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postkeeper/constant.dart';
import 'package:postkeeper/data/repositories/mock.dart';
import 'support/test_app.dart';
import 'package:postkeeper/ui/contact_list_view.dart';
import 'package:postkeeper/ui/contact_view.dart';

void main() {
  test(
    'contact list excludes myself and personal info uses my record',
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

  testWidgets('contacts and personal info return to their source routes', (
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
      isNull,
    );
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(ContactListView), findsOneWidget);
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
