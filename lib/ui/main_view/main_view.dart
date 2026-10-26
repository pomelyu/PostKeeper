import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/data/repositories/postcard_repository.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/router.dart';
import 'package:postkeeper/ui/main_view/postcard_tab.dart';
import 'package:postkeeper/ui/style.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel({required this._repository});

  final PostcardRepository _repository;

  Postcard? _latestSent;
  Postcard? _latestReceived;
  bool _disposed = false;

  Postcard? get latestSent => _latestSent;
  Postcard? get latestReceived => _latestReceived;

  Future<void> loadLatestPostcards() async {
    if (_disposed) return;

    final sent = await _repository.getLatestSentPostcard();
    final received = await _repository.getLatestReceivedPostcard();

    if (_disposed) return;

    _latestSent = sent;
    _latestReceived = received;
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
          child: Placeholder(
            key: ValueKey('main-pinned-section'),
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
