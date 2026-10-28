import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/data/repositories/postcard_repository.dart';
import 'package:postkeeper/domain/models/collection.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/router.dart';
import 'package:postkeeper/ui/main_view/pinned_collection.dart';
import 'package:postkeeper/ui/main_view/postcard_tab.dart';
import 'package:postkeeper/ui/style.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel({required this._repository});

  final PostcardRepository _repository;

  Postcard? _latestSent;
  Postcard? _latestReceived;
  Collection? _collection1;
  Collection? _collection2;
  bool _disposed = false;

  Postcard? get latestSent => _latestSent;
  Postcard? get latestReceived => _latestReceived;

  Collection? get collection1 => _collection1;
  Collection? get collection2 => _collection2;

  Future<void> initialize() async {
    if (_disposed) return;

    final sent = await _repository.getLatestSent();
    final received = await _repository.getLatestReceived();
    final collection1 = await _repository.getAllFavorite();
    final collection2 = await _repository.getAllMyReceived();

    if (_disposed) return;

    _latestSent = sent;
    _latestReceived = received;
    _collection1 = collection1;
    _collection2 = collection2;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key, required this.viewModel});

  final MainViewModel viewModel;

  // 區域高度以 logical pixels 計；標題可隨內容增高，釘選區域使用剩餘高度。
  static const double _titleMinHeight = 80;
  static const double _tabHeight = 400;
  static const double _quickAddHeight = 80;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstrainedBox(
          key: ValueKey('main-title-section'),
          constraints: const BoxConstraints(minHeight: _titleMinHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.mainTitle, style: styleDisplayTitle),
                Text(l10n.mainSubtitle, style: styleBody),
              ],
            ),
          ),
        ),
        SizedBox(
          key: ValueKey('main-tab-section'),
          height: _tabHeight,
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              return PostcardTab(
                latestReceived: viewModel.latestReceived,
                latestSent: viewModel.latestSent,
              );
            },
          ),
        ),
        Divider(),
        Expanded(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              return PinnedCollection(
                key: ValueKey('main-pinned-section'),
                  collections1: viewModel.collection1,
                  collections2: viewModel.collection2,
                );
            },
          ),
        ),
        SizedBox(
          key: ValueKey('main-quick-add-section'),
          height: _quickAddHeight,
          child: TextButton(
            onPressed: () => context.push(postcardEditViewURI),
            child: Text(l10n.mainAddPostcard, style: styleSectionTitle),
          ),
        ),
      ],
    );
  }
}
