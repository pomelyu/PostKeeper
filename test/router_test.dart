import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/data/repositories/mock.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/main.dart';
import 'package:postkeeper/router.dart';
import 'package:postkeeper/ui/location_picker_view/location_picker_view.dart';

import 'support/test_app.dart';

class _PostcardRepository extends MockPostcardRepository {
  int latestSentCalls = 0;

  @override
  Future<Postcard?> getLatestSent() async {
    latestSentCalls++;
    return null;
  }
}

class _PersonRepository extends MockPersonRepository {
  int myInfoCalls = 0;

  @override
  Future<Person> getMyInfo() {
    myInfoCalls++;
    return super.getMyInfo();
  }
}

void main() {
  testWidgets('路由使用注入的 Repository，App 實例之間互相隔離', (tester) async {
    final postcards = _PostcardRepository();
    final people = _PersonRepository();
    final locations = TestLocationRepository();
    await tester.pumpWidget(
      PostKeeperApp(
        postcardRepository: postcards,
        personRepository: people,
        locationRepository: locations,
      ),
    );
    await tester.pumpAndSettle();
    expect(postcards.latestSentCalls, 1);

    await tester.tap(find.byKey(const ValueKey('nav-user')));
    await tester.pumpAndSettle();
    expect(people.myInfoCalls, 1);

    final router = GoRouter.of(
      tester.element(find.byKey(const ValueKey('user-view'))),
    );
    router.push<void>(locationPickerViewURI);
    await tester.pumpAndSettle();
    final picker = tester.widget<LocationPickerView>(
      find.byKey(const ValueKey('location-picker-view')),
    );
    expect(picker.viewModel.repository, same(locations));
    router.pop();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('user-view')), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    final otherPostcards = _PostcardRepository();
    await tester.pumpWidget(
      PostKeeperApp(
        postcardRepository: otherPostcards,
        personRepository: _PersonRepository(),
        locationRepository: TestLocationRepository(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('main-view')), findsOneWidget);
    expect(otherPostcards.latestSentCalls, 1);
    expect(postcards.latestSentCalls, 1);
  });
}
