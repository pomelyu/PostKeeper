import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/data/repositories/postcard_repository.dart';
import 'package:postkeeper/domain/models/collection.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/router.dart';
import 'package:postkeeper/ui/core/collection_list_item.dart';
import 'package:postkeeper/ui/core/title.dart';
import 'package:postkeeper/ui/core/utils.dart';
import 'package:postkeeper/ui/style.dart';

class KeeperViewModel extends ChangeNotifier {
  KeeperViewModel({required this.repository});

  final PostcardRepository repository;
  int selectedTab = 0;
  bool loading = true;
  List<Collection> regions = [];
  List<Collection> years = [];
  List<Collection> collections = [];
  bool _disposed = false;

  Future<void> initialize() async {
    final results = await Future.wait([
      repository.getCollectionsByRegion(),
      repository.getCollectionsByYear(),
      repository.getCustomCollections(),
    ]);
    final favorites = await repository.getAllFavorite();
    final received = await repository.getAllMyReceived();
    final sent = await repository.getAllMySent();
    if (_disposed) return;
    regions = results[0];
    years = results[1];
    collections = [favorites, received, sent, ...results[2]];
    loading = false;
    notifyListeners();
  }

  void selectTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class KeeperView extends StatelessWidget {
  const KeeperView({super.key, required this.viewModel});

  final KeeperViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final items = switch (viewModel.selectedTab) {
          0 => viewModel.regions,
          1 => viewModel.years,
          _ => viewModel.collections,
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TitleTextBox(title: l10n.keeperTitle),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InputDecorator(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                ),
                child: Text(l10n.keeperSearch),
              ),
            ),
            Row(
              children: [
                for (final (index, label) in [
                  l10n.keeperRegion,
                  l10n.keeperYear,
                  l10n.keeperCollections,
                ].indexed)
                  Expanded(
                    child: TextButton(
                      key: ValueKey('keeper-tab-$index'),
                      onPressed: () => viewModel.selectTab(index),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontWeight: viewModel.selectedTab == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: viewModel.loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      key: ValueKey('keeper-list-${viewModel.selectedTab}'),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final collection = items[index];
                        return CollectionListItem(
                          key: ValueKey(
                            'keeper-item-${viewModel.selectedTab}-${collection.id}',
                          ),
                          title: decodeCollectionName(collection, l10n),
                          subtitle: l10n.keeperCount(
                            collection.postcards.length,
                          ),
                          onTap: () => context.push(
                            collectionViewURI,
                            extra: collection,
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
