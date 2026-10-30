import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postkeeper/constant.dart';
import 'package:postkeeper/main.dart';
import 'package:postkeeper/ui/collection_view.dart';
import 'package:postkeeper/ui/keeper_view.dart';

void main() {
  testWidgets('收藏頁各分頁可開啟選取的收藏夾並返回', (
    tester,
  ) async {
    await tester.pumpWidget(const PostKeeperApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-keeper')));
    await tester.pumpAndSettle();

    for (final (tab, id) in [
      (0, '142'),
      (1, '2025'),
      (2, favoriteCollectionId),
      (2, 'custom-japan'),
    ]) {
      await tester.tap(find.byKey(ValueKey('keeper-tab-$tab')));
      await tester.pumpAndSettle();
      final item = find.byKey(ValueKey('keeper-item-$tab-$id'));
      final keeper = tester.widget<KeeperView>(
        find.byKey(const ValueKey('keeper-view')),
      );
      final source = switch (tab) {
        0 => keeper.viewModel.regions,
        1 => keeper.viewModel.years,
        _ => keeper.viewModel.collections,
      }.firstWhere((collection) => collection.id == id);
      await tester.ensureVisible(item);
      await tester.tap(item);
      await tester.pumpAndSettle();
      final collection = tester
          .widget<CollectionView>(find.byKey(const ValueKey('collection-view')))
          .collection;
      expect(collection, same(source));
      expect(collection.id, id);
      expect(collection.postcards, isNotEmpty);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey('keeper-list-$tab')), findsOneWidget);
    }
  });
}
